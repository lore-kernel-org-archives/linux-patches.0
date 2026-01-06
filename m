Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF6C224B04;
	Tue,  6 Jan 2026 17:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720723; cv=none; b=aox+ka97m/IFrXlcVAH5GAeqEBAJNUKT+sYjFB1L7ZOYQZMPJ/zg2cPH1m4L/WetMwrbSj8DBse7i+v4mKOWT6yPoHiIaH/4ALuiYXrM6htEmCZmjOwQ8iqb/cc8iJ/n+VHrIT41jr4KA1bWcqtImgBJWK36WMMWeu8Om15uFPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720723; c=relaxed/simple;
	bh=UZmzT2IlVg1XzQwa8ob83YBi3OJFUvgpbi0AoCe4x4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cAFCMwZbxnzpOHU0BCGkNZIczAJC0Zo771A8/lhOIwtnzkexEI57N4/ZrdPBWV1S1mjARbofRz3yXYf3LNcabJ3QYcIfXGvN1QduupJUMMoHuqH2IQutMESo7Y8pmdFTeJQytc/ifrlVi+5XOU7gxcvgF+/hqaPDPRm4I0ydtDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1MVQWRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1MVQWRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B094C116C6;
	Tue,  6 Jan 2026 17:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720723;
	bh=UZmzT2IlVg1XzQwa8ob83YBi3OJFUvgpbi0AoCe4x4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1MVQWRsXHQ69O6KBrGOpKfmdsRGDFJ1FbYFPV/kdWj9vq8hMfbo5GhcvDcn6glcE
	 Vw8KPTU/x9bkck6uBkk0jKZJIolOeUj/WcqH+UVInlIzOS/yjegiqhZPUWGeuOyZmM
	 HwGDH0B8rwrSuJWeFdox6qTbCvU3GuZJNeai3z98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/567] platform/x86: hp-bioscfg: Fix out-of-bounds array access in ACPI package parsing
Date: Tue,  6 Jan 2026 18:01:45 +0100
Message-ID: <20260106170503.272593325@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c50ad5880503..f346aad8e9d8 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
@@ -207,7 +207,7 @@ static int hp_populate_enumeration_elements_from_package(union acpi_object *enum
 		case PREREQUISITES:
 			size = min_t(u32, enum_data->common.prerequisites_size, MAX_PREREQUISITES_SIZE);
 			for (reqs = 0; reqs < size; reqs++) {
-				if (elem >= enum_obj_count) {
+				if (elem + reqs >= enum_obj_count) {
 					pr_err("Error enum-objects package is too small\n");
 					return -EINVAL;
 				}
@@ -255,7 +255,7 @@ static int hp_populate_enumeration_elements_from_package(union acpi_object *enum
 
 			for (pos_values = 0; pos_values < size && pos_values < MAX_VALUES_SIZE;
 			     pos_values++) {
-				if (elem >= enum_obj_count) {
+				if (elem + pos_values >= enum_obj_count) {
 					pr_err("Error enum-objects package is too small\n");
 					return -EINVAL;
 				}
diff --git a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
index 6c7f4d5fa9cb..63b1fda2be4e 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
@@ -227,7 +227,7 @@ static int hp_populate_integer_elements_from_package(union acpi_object *integer_
 			size = min_t(u32, integer_data->common.prerequisites_size, MAX_PREREQUISITES_SIZE);
 
 			for (reqs = 0; reqs < size; reqs++) {
-				if (elem >= integer_obj_count) {
+				if (elem + reqs >= integer_obj_count) {
 					pr_err("Error elem-objects package is too small\n");
 					return -EINVAL;
 				}
diff --git a/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
index c6e57bb9d8b7..6a31f47ce3f5 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/order-list-attributes.c
@@ -216,6 +216,11 @@ static int hp_populate_ordered_list_elements_from_package(union acpi_object *ord
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
index 35936c05e45b..a5c457d06b9c 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -303,6 +303,11 @@ static int hp_populate_password_elements_from_package(union acpi_object *passwor
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
index 27758b779b2d..7b885d25650c 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/string-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/string-attributes.c
@@ -217,7 +217,7 @@ static int hp_populate_string_elements_from_package(union acpi_object *string_ob
 				     MAX_PREREQUISITES_SIZE);
 
 			for (reqs = 0; reqs < size; reqs++) {
-				if (elem >= string_obj_count) {
+				if (elem + reqs >= string_obj_count) {
 					pr_err("Error elem-objects package is too small\n");
 					return -EINVAL;
 				}
-- 
2.51.0



