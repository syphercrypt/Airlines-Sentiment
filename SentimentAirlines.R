library(readr)
library(dplyr)
CleanAirlines <- read_csv("C:/Python27/project/CleanAirlines.csv")

unique(CleanAirlines$airline)

###            Overall Airline Sentiment Data           ###
###########################################################
body <- CleanAirlines[,4]
body <- data.frame(body)

library('syuzhet')

body$tweets <- as.character(body$final_set)
body$text <-iconv(body$tweets, "ASCII", "UTF-8", sub="")

sentences <- data.frame(get_sentences(body$text))
names(sentences)[1] <- "Text"
sentences$Text <- as.character(sentences$Text)

sentences <- data.frame(get_sentences(body$text))

names(sentences)[1] <- "Text"

sentences$Text <- as.character(sentences$Text)

sentences$syuzhet = get_sentiment(sentences$Text, method="syuzhet")
sentences$bing = get_sentiment(sentences$Text, method="bing")
sentences$afinn = get_sentiment(sentences$Text, method="afinn")
sentences$nrc = get_sentiment(sentences$Text, method="nrc")
emotions<-get_nrc_sentiment(sentences$Text)
emotions2 <- get_nrc_values(sentences$Text)

n = names(emotions)
for (nn in n) sentences[, nn] = emotions[nn]

td<-data.frame(t(emotions))

#The function rowSums computes column sums across rows for each level of a grouping variable.
td_new <- data.frame(rowSums(td[2:11540]))
td_new
#Transformation and  cleaning
names(td_new)[1] <- "count"
td_new <- cbind("sentiment" = rownames(td_new), td_new)
rownames(td_new) <- NULL
td_new

##Sentiment Perception of Airlines Neg / Pos 
Negative_perc <- td_new[9,2] / (td_new[9,2] + td_new[10,2])
Negative_perc
Positive_perc <- td_new[10,2] / (td_new[9,2] + td_new[10,2])
Positive_perc

td_new2<-td_new[1:8,]
td_new2

#Visualisation
library("ggplot2")


qplot(sentiment, data=td_new2, weight=count, geom="bar",fill=sentiment)+
  ggtitle("Airline Sentiments")
