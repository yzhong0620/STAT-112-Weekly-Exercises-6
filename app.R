library(tidyverse)     # for data cleaning and plotting
library(shiny)         # for creating interactive apps
theme_set(theme_minimal())

covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

ui <- fluidPage(
  selectInput("state", 
              "state", 
              choices = as.list(covid19$state),
              multiple = TRUE),
  submitButton(text = "Create my plot!"),
  plotOutput(outputId = "timeplot")
)

server <- function(input, output) {
  output$timeplot <- renderPlot({
    covid19 %>% 
      filter(cases > 20) %>% 
      filter(state %in% input$state) %>% 
      ggplot() +
      geom_line(aes(x = date, y = cases, color = state)) +
      labs(title = "cumulative cases on the log scale over time",
           y = "") +
      scale_y_log10() +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)