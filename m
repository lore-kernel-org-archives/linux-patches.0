Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73157339872;
	Fri,  4 Sep 2026 06:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501608; cv=none; b=p5XSiER69hhRh+NsROIFu93P/e0kZv1yKzcVtJGg2xETpp65BSDzAfAG5XwOHDv52lzvZEif3iGroFbBrFU4mixtz0hKgsJsPnLd5pSuxwm9OaOjGxyB+qIRJDle+nxUVx6+BHyI3hcEFCS5NGCnSN4SMO9Ugdby+0Ys8GzzbbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501608; c=relaxed/simple;
	bh=TYIjs+wUkfgWgH/mHNcpVmxXRwIPSdH0/zj3KDWNL0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uBO7dyheEtAZYG4l8AvM8LvvxieKsHyOj/KDLh75I5lqre0Owszas67QRC2ijtJs9K7F1Ane3mL3Mg4Hl2RNHd+zNOCmkqx4i3m4EBD5O659wXtLkUDEzwu4SRbk2rrIffs5/8XOuXfaXnE8tCFuEOiMRyxsvgGhNQ4Yivb8bAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nv2AisOL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nv2AisOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7641F00A3D;
	Fri,  4 Sep 2026 06:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501607;
	bh=FM6hTHJwAr3+ysSNnb+3yJJiivRrY7nEcmpir4zrlag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nv2AisOLi3nWw7RSvigh2rmYuBAMOr5rTIIZplvn1bx+N+iLFCuIs0roSIwI03Q72
	 AgJyl5+Yb1LjMdrUOGRNr1SLUha7Bg826klc3B29h+BA/XPkL/RE7eGGOsW8EUNfRl
	 elNtyKYE1B98ZS8sUb/c5tK/lW0cSX057ebUT1SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 442/552] platform/x86: hp-bioscfg: pass validated element count to package parsers
Date: Fri,  4 Sep 2026 06:59:59 +0200
Message-ID: <20260904045800.610542137@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit e0ddfd77c0c320b7d12b6c9169303b140b798775 upstream.

The per-type package parsers are handed the wrong element count.

hp_init_bios_package_attribute() validates obj->package.count and then
calls one of the five hp_populate_*_package_data() wrappers (string,
integer, enumeration, ordered list, password). Each wrapper forwards a
count to its hp_populate_*_elements_from_package() parser, but instead
of forwarding the validated obj->package.count it derives the count
from elements[0]. elements[0] is the NAME field and is always an
ACPI_TYPE_STRING, so reading ->package.count from it in fact reads
->string.length through the union acpi_object. The parsers thus bound
themselves against the length of the name string rather than against
the real number of elements in the package.

This is safe today because hp_init_bios_package_attribute() refuses any
package that has fewer than the type's element count, so a parser only
ever runs on a full package and never reads past it regardless of the
bogus bound.

An upcoming change relaxes that check to accept shorter packages. Once
a parser can receive fewer elements than its per-type count, a bound
taken from the name length no longer reflects the array size, and the
"elem < count" loop conditions and "elem + n >= count" sub-loop guards
read past the end of elements[] - an out-of-bounds heap read.

Forward the validated obj->package.count to every *_package_data()
wrapper so the parsers bound themselves against the real package size.
This does not change behaviour for the packages that enumerate
correctly today and is a prerequisite for accepting shorter packages
safely.

Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260709165900.30615-2-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c               |    5 +++++
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.h               |    5 +++++
 drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c       |    4 +++-
 drivers/platform/x86/hp/hp-bioscfg/int-attributes.c        |    4 +++-
 drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c |    6 ++++--
 drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c  |    6 ++++--
 drivers/platform/x86/hp/hp-bioscfg/string-attributes.c     |    4 +++-
 7 files changed, 27 insertions(+), 7 deletions(-)

--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -736,26 +736,31 @@ static int hp_init_bios_package_attribut
 	switch (attr_type) {
 	case HPWMI_STRING_TYPE:
 		ret = hp_populate_string_package_data(elements,
+						      obj->package.count,
 						      instance_id,
 						      attr_name_kobj);
 		break;
 	case HPWMI_INTEGER_TYPE:
 		ret = hp_populate_integer_package_data(elements,
+						       obj->package.count,
 						       instance_id,
 						       attr_name_kobj);
 		break;
 	case HPWMI_ENUMERATION_TYPE:
 		ret = hp_populate_enumeration_package_data(elements,
+							   obj->package.count,
 							   instance_id,
 							   attr_name_kobj);
 		break;
 	case HPWMI_ORDERED_LIST_TYPE:
 		ret = hp_populate_ordered_list_package_data(elements,
+							    obj->package.count,
 							    instance_id,
 							    attr_name_kobj);
 		break;
 	case HPWMI_PASSWORD_TYPE:
 		ret = hp_populate_password_package_data(elements,
+							obj->package.count,
 							instance_id,
 							attr_name_kobj);
 		break;
--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.h
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.h
@@ -404,6 +404,7 @@ int hp_populate_string_buffer_data(u8 *b
 int hp_alloc_string_data(void);
 void hp_exit_string_attributes(void);
 int hp_populate_string_package_data(union acpi_object *str_obj,
+				    int str_obj_count,
 				    int instance_id,
 				    struct kobject *attr_name_kobj);
 
@@ -414,6 +415,7 @@ int hp_populate_integer_buffer_data(u8 *
 int hp_alloc_integer_data(void);
 void hp_exit_integer_attributes(void);
 int hp_populate_integer_package_data(union acpi_object *integer_obj,
+				     int integer_obj_count,
 				     int instance_id,
 				     struct kobject *attr_name_kobj);
 
@@ -424,6 +426,7 @@ int hp_populate_enumeration_buffer_data(
 int hp_alloc_enumeration_data(void);
 void hp_exit_enumeration_attributes(void);
 int hp_populate_enumeration_package_data(union acpi_object *enum_obj,
+					 int enum_obj_count,
 					 int instance_id,
 					 struct kobject *attr_name_kobj);
 
@@ -435,6 +438,7 @@ int hp_populate_ordered_list_buffer_data
 int hp_alloc_ordered_list_data(void);
 void hp_exit_ordered_list_attributes(void);
 int hp_populate_ordered_list_package_data(union acpi_object *order_obj,
+					  int order_obj_count,
 					  int instance_id,
 					  struct kobject *attr_name_kobj);
 
@@ -443,6 +447,7 @@ int hp_populate_password_buffer_data(u8
 				     int instance_id,
 				     struct kobject *attr_name_kobj);
 int hp_populate_password_package_data(union acpi_object *password_obj,
+				      int password_obj_count,
 				      int instance_id,
 				      struct kobject *attr_name_kobj);
 int hp_alloc_password_data(void);
--- a/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
@@ -304,10 +304,12 @@ exit_enumeration_package:
  * Populate all properties of an instance under enumeration attribute
  *
  * @enum_obj: ACPI object with enumeration data
+ * @enum_obj_count: Number of elements in @enum_obj
  * @instance_id: The instance to enumerate
  * @attr_name_kobj: The parent kernel object
  */
 int hp_populate_enumeration_package_data(union acpi_object *enum_obj,
+					 int enum_obj_count,
 					 int instance_id,
 					 struct kobject *attr_name_kobj)
 {
@@ -316,7 +318,7 @@ int hp_populate_enumeration_package_data
 	enum_data->attr_name_kobj = attr_name_kobj;
 
 	hp_populate_enumeration_elements_from_package(enum_obj,
-						      enum_obj->package.count,
+						      enum_obj_count,
 						      instance_id);
 	hp_update_attribute_permissions(enum_data->common.is_readonly,
 					&enumeration_current_val);
--- a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
@@ -277,10 +277,12 @@ exit_integer_package:
  * Populate all properties of an instance under integer attribute
  *
  * @integer_obj: ACPI object with integer data
+ * @integer_obj_count: Number of elements in @integer_obj
  * @instance_id: The instance to enumerate
  * @attr_name_kobj: The parent kernel object
  */
 int hp_populate_integer_package_data(union acpi_object *integer_obj,
+				     int integer_obj_count,
 				     int instance_id,
 				     struct kobject *attr_name_kobj)
 {
@@ -288,7 +290,7 @@ int hp_populate_integer_package_data(uni
 
 	integer_data->attr_name_kobj = attr_name_kobj;
 	hp_populate_integer_elements_from_package(integer_obj,
-						  integer_obj->package.count,
+						  integer_obj_count,
 						  instance_id);
 	hp_update_attribute_permissions(integer_data->common.is_readonly,
 					&integer_current_val);
--- a/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
@@ -303,10 +303,12 @@ exit_list:
  * Populate all properties of an instance under ordered_list attribute
  *
  * @order_obj: ACPI object with ordered_list data
+ * @order_obj_count: Number of elements in @order_obj
  * @instance_id: The instance to enumerate
  * @attr_name_kobj: The parent kernel object
  */
-int hp_populate_ordered_list_package_data(union acpi_object *order_obj, int instance_id,
+int hp_populate_ordered_list_package_data(union acpi_object *order_obj, int order_obj_count,
+					  int instance_id,
 					  struct kobject *attr_name_kobj)
 {
 	struct ordered_list_data *ordered_list_data = &bioscfg_drv.ordered_list_data[instance_id];
@@ -314,7 +316,7 @@ int hp_populate_ordered_list_package_dat
 	ordered_list_data->attr_name_kobj = attr_name_kobj;
 
 	hp_populate_ordered_list_elements_from_package(order_obj,
-						       order_obj->package.count,
+						       order_obj_count,
 						       instance_id);
 	hp_update_attribute_permissions(ordered_list_data->common.is_readonly,
 					&ordered_list_current_val);
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -389,10 +389,12 @@ exit_package:
  *	Populate all properties for an instance under password attribute
  *
  * @password_obj: ACPI object with password data
+ * @password_obj_count: Number of elements in @password_obj
  * @instance_id: The instance to enumerate
  * @attr_name_kobj: The parent kernel object
  */
-int hp_populate_password_package_data(union acpi_object *password_obj, int instance_id,
+int hp_populate_password_package_data(union acpi_object *password_obj, int password_obj_count,
+				      int instance_id,
 				      struct kobject *attr_name_kobj)
 {
 	struct password_data *password_data = &bioscfg_drv.password_data[instance_id];
@@ -400,7 +402,7 @@ int hp_populate_password_package_data(un
 	password_data->attr_name_kobj = attr_name_kobj;
 
 	hp_populate_password_elements_from_package(password_obj,
-						   password_obj->package.count,
+						   password_obj_count,
 						   instance_id);
 
 	hp_friendly_user_name_update(password_data->common.path,
--- a/drivers/platform/x86/hp/hp-bioscfg/string-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/string-attributes.c
@@ -265,10 +265,12 @@ exit_string_package:
  * Populate all properties of an instance under string attribute
  *
  * @string_obj: ACPI object with string data
+ * @string_obj_count: Number of elements in @string_obj
  * @instance_id: The instance to enumerate
  * @attr_name_kobj: The parent kernel object
  */
 int hp_populate_string_package_data(union acpi_object *string_obj,
+				    int string_obj_count,
 				    int instance_id,
 				    struct kobject *attr_name_kobj)
 {
@@ -277,7 +279,7 @@ int hp_populate_string_package_data(unio
 	string_data->attr_name_kobj = attr_name_kobj;
 
 	hp_populate_string_elements_from_package(string_obj,
-						 string_obj->package.count,
+						 string_obj_count,
 						 instance_id);
 
 	hp_update_attribute_permissions(string_data->common.is_readonly,


