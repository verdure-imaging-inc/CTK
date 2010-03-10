
#
#
#
MACRO(ctk_build_qtplugin)
  CTK_PARSE_ARGUMENTS(MYQTPLUGIN
    "NAME;EXPORT_DIRECTIVE;SRCS;MOC_SRCS;UI_FORMS;INCLUDE_DIRECTORIES;TARGET_LIBRARIES;UI_RESOURCES;LIBRARY_TYPE"
    ""
    ${ARGN}
    )

  # Sanity checks
  IF(NOT DEFINED MYQTPLUGIN_NAME)
    MESSAGE(SEND_ERROR "NAME is mandatory")
  ENDIF(NOT DEFINED MYQTPLUGIN_NAME)
  IF(NOT DEFINED MYQTPLUGIN_EXPORT_DIRECTIVE)
    MESSAGE(SEND_ERROR "EXPORT_DIRECTIVE is mandatory")
  ENDIF(NOT DEFINED MYQTPLUGIN_EXPORT_DIRECTIVE)
  IF(NOT DEFINED MYQTPLUGIN_LIBRARY_TYPE)
    SET(MYQTLIB_LIBRARY_TYPE "SHARED")
  ENDIF(NOT DEFINED MYQTPLUGIN_LIBRARY_TYPE)

  # Define library name
  SET(lib_name ${MYQTPLUGIN_NAME})

  # --------------------------------------------------------------------------
  # Include dirs
  SET(my_includes
    ${CTK_BASE_INCLUDE_DIRS}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${MYQTPLUGIN_INCLUDE_DIRECTORIES}
    )  
  INCLUDE_DIRECTORIES(
    ${my_includes}
    )  
 
  SET(MY_LIBRARY_EXPORT_DIRECTIVE ${MYQTPLUGIN_EXPORT_DIRECTIVE})
  SET(MY_EXPORT_HEADER_PREFIX ${MYQTPLUGIN_NAME})
  SET(MY_LIBNAME ${lib_name})
  
  CONFIGURE_FILE(
    ${CTK_SOURCE_DIR}/Libs/CTKExport.h.in
    ${CMAKE_CURRENT_BINARY_DIR}/${MY_EXPORT_HEADER_PREFIX}Export.h
    )
  SET(dynamicHeaders
    "${dynamicHeaders};${CMAKE_CURRENT_BINARY_DIR}/${MY_EXPORT_HEADER_PREFIX}Export.h")

  QT4_WRAP_CPP(MYQTPLUGIN_SRCS ${MYQTPLUGIN_MOC_SRCS})
  QT4_WRAP_UI(MYQTPLUGIN_UI_CXX ${MYQTPLUGIN_UI_FORMS})
  SET(MYQTPLUGIN_QRC_SRCS "")
  IF(DEFINED MYQTPLUGIN_UI_RESOURCES)
    QT4_ADD_RESOURCES(MYQTPLUGIN_QRC_SRCS ${MYQTPLUGIN_UI_RESOURCES})
  ENDIF(DEFINED MYQTPLUGIN_UI_RESOURCES)

  SOURCE_GROUP("Resources" FILES
    ${MYQTPLUGIN_UI_RESOURCES}
    ${MYQTPLUGIN_UI_FORMS}
    )

  SOURCE_GROUP("Generated" FILES
    ${MYQTPLUGIN_MOC_SRCS}
    ${MYQTPLUGIN_QRC_SRCS}
    ${MYQTPLUGIN_UI_CXX}
    )
  
  ADD_LIBRARY(${lib_name} ${OV_LIBRARY_TYPE}
    ${MYQTPLUGIN_SRCS}
    ${MYQTPLUGIN_UI_CXX}
    ${MYQTPLUGIN_QRC_SRCS}
    )

  # Note: The plugin may be installed in some other location ???
  # Install rules
  #IF(CTK_BUILD_SHARED_LIBS)
  #  INSTALL(TARGETS ${lib_name}
  #    RUNTIME DESTINATION ${CTK_INSTALL_BIN_DIR} COMPONENT Runtime
  #    LIBRARY DESTINATION ${CTK_INSTALL_LIB_DIR} COMPONENT Runtime
  #    ARCHIVE DESTINATION ${CTK_INSTALL_LIB_DIR} COMPONENT Development)
  #ENDIF(CTK_BUILD_SHARED_LIBS)
  
  SET(my_libs
    ${CTK_BASE_LIBRARIES}
    ${MYQTPLUGIN_TARGET_LIBRARIES}
    )
  TARGET_LINK_LIBRARIES(${lib_name} ${my_libs})
  
  # Install headers
  #FILE(GLOB headers "${CMAKE_CURRENT_SOURCE_DIR}/*.h")
  #INSTALL(FILES
  #  ${headers}
  #  ${dynamicHeaders}
  #  DESTINATION ${CTK_INSTALL_INCLUDE_DIR} COMPONENT Development
  #  )

ENDMACRO(ctk_build_qtplugin)


