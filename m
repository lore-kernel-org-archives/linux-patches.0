Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4FB320CB6;
	Fri,  9 Jan 2026 12:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960783; cv=none; b=ZqNAJ244Vu4RHVWZUceASSscWNaa1M92p6Ssrelr3MJZpFbgsVXYpgdbVKqxx9kxSF2o6owFcUe9veZ0sElwVezpDJ6KxPhMTqzZTXo2CV8OVEGWj4PTQ3oRT4osxIFYOG5zBSLAVf6JBC3M7JEn532hkKIucvmZ0iqtTj82aRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960783; c=relaxed/simple;
	bh=46w9UfnD2IK+oqzecefTyx5Px8G+ozJ1+rpjf58ODZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZdMLR2G8YkEC8jm3bZqG5PbIfZ2fx6tt62NFsdDFEjldraS6X7rKxFRBe7Y/wcZIEeJfmirluyOi0SVV2s/Zqo4TqmmJRskYXUqeVKH/7w4MtaIcub3ltbrq03EIecM1sX0a8bNS4TpL/if7Ao/zj7N+aP3kSdG6CHexvAby6iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHz170S0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHz170S0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C634C4CEF1;
	Fri,  9 Jan 2026 12:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960782;
	bh=46w9UfnD2IK+oqzecefTyx5Px8G+ozJ1+rpjf58ODZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHz170S0ROxsJVT5IbTUd//nnkHl1CO7OyJshYvFmU1IFhx2caHaMag7XxfLTPlGQ
	 blImwAHyzwgT0OUlK6gumgTOYysSdAxtF3Scd1wOY48GLHICNKAQWrCc0UpBEKe/62
	 UQuSrFYGVoDCONlZ/MwFUIYh5Q2fEuNu6yAlx9OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 523/737] platform/x86: hp-bioscfg: Fix out-of-bounds array access in ACPI package parsing
Date: Fri,  9 Jan 2026 12:41:02 +0100
Message-ID: <20260109112153.674060392@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit e44c42c830b7ab36e3a3a86321c619f24def5206 ]

The hp_populate_*_elements_from_package() functions in the hp-bioscfg
driver contain out-of-bounds array access vulnerabilities.

These functions parse ACPI packages into internal data structures using
a for loop with index variable 'elem' that iterates through
enum_obj/integer_obj/order_obj/password_obj/string_obj arrays.

When processing multi-element fields like PREREQUISITES and
ENUM_POSSIBLE_VALUES, these functions read multiple consecutive array
elements using expressions like 'enum_obj[elem + reqs]' and
'enum_obj[elem + pos_values]' within nested loops.

The bug is that the bounds check only validated elem, but did not consider
the additional offset when accessing elem + reqs or elem + pos_values.

The fix changes the bounds check to validate the actual accessed index.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: e6c7b3e15559 ("platform/x86: hp-bioscfg: string-attributes")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB788173D7DD4EA2CB6383683DAFB0A@SYBPR01MB7881.ausprd01.prod.outlook.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c       | 4 ++--
 drivers/platform/x86/hp/hp-bioscfg/int-attributes.c        | 2 +-
 drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c | 5 +++++
 drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c  | 5 +++++
 drivers/platform/x86/hp/hp-bioscfg/string-attributes.c     | 2 +-
 5 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
index a2402d31c146..20de4596e301 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
@@ -210,7 +210,7 @@ static int hp_populate_enumeration_elements_from_package(union acpi_object *enum
 		case PREREQUISITES:
 			size = min_t(u32, enum_data->common.prerequisites_size, MAX_PREREQUISITES_SIZE);
 			for (reqs = 0; reqs < size; reqs++) {
-				if (elem >= enum_obj_count) {
+				if (elem + reqs >= enum_obj_count) {
 					pr_err("Error enum-objects package is too small\n");
 					return -EINVAL;
 				}
@@ -261,7 +261,7 @@ static int hp_populate_enumeration_elements_from_package(union acpi_object *enum
 
 			for (pos_values = 0; pos_values < size && pos_values < MAX_VALUES_SIZE;
 			     pos_values++) {
-				if (elem >= enum_obj_count) {
+				if (elem + pos_values >= enum_obj_count) {
 					pr_err("Error enum-objects package is too small\n");
 					return -EINVAL;
 				}
diff --git a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
index 86b7ac63fec2..875a807ccb89 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
@@ -228,7 +228,7 @@ static int hp_populate_integer_elements_from_package(union acpi_object *integer_
 			size = min_t(u32, integer_data->common.prerequisites_size, MAX_PREREQUISITES_SIZE);
 
 			for (reqs = 0; reqs < size; reqs++) {
-				if (elem >= integer_obj_count) {
+				if (elem + reqs >= integer_obj_count) {
 					pr_err("Error elem-objects package is too small\n");
 					return -EINVAL;
 				}
diff --git a/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
index 1ff09dfb7d7e..94a95ee57810 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
@@ -220,6 +220,11 @@ static int hp_populate_ordered_list_elements_from_package(union acpi_object *ord
 			size = min_t(u32, ordered_list_data->common.prerequisites_size,
 				     MAX_PREREQUISITES_SIZE);
 			for (reqs = 0; reqs < size; reqs++) {
+				if (elem + reqs >= order_obj_count) {
+					pr_err("Error elem-objects package is too small\n");
+					return -EINVAL;
+				}
+
 				ret = hp_convert_hexstr_to_str(order_obj[elem + reqs].string.pointer,
 							       order_obj[elem + reqs].string.length,
 							       &str_value, &value_len);
diff --git a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
index 03d0188804ba..6775a7ca74f5 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -309,6 +309,11 @@ static int hp_populate_password_elements_from_package(union acpi_object *passwor
 				     MAX_PREREQUISITES_SIZE);
 
 			for (reqs = 0; reqs < size; reqs++) {
+				if (elem + reqs >= password_obj_count) {
+					pr_err("Error elem-objects package is too small\n");
+					return -EINVAL;
+				}
+
 				ret = hp_convert_hexstr_to_str(password_obj[elem + reqs].string.pointer,
 							       password_obj[elem + reqs].string.length,
 							       &str_value, &value_len);
diff --git a/drivers/platform/x86/hp/hp-bioscfg/string-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/string-attributes.c
index f0c20070094d..5b3eac7f1685 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/string-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/string-attributes.c
@@ -219,7 +219,7 @@ static int hp_populate_string_elements_from_package(union acpi_object *string_ob
 				     MAX_PREREQUISITES_SIZE);
 
 			for (reqs = 0; reqs < size; reqs++) {
-				if (elem >= string_obj_count) {
+				if (elem + reqs >= string_obj_count) {
 					pr_err("Error elem-objects package is too small\n");
 					return -EINVAL;
 				}
-- 
2.51.0



