Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63E133375D;
	Fri,  9 Jan 2026 12:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960203; cv=none; b=Jv/kzpidPY9Bpbv3ecTZ7kbuti8QQvL04005gMFapvyUn1mIlJpBPlBryZTdC/gOf5TOf0kHl01eMGp53m7dTs/45YTwCP9spVJJ6XgpCG4Ykw06THM/iIoJ4uZGfTVkWTkcyMkI9xMvuOp5eGvccmZ27Vi/zoDSelpFHlVZSdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960203; c=relaxed/simple;
	bh=NbvYBe03tVcO35Eqsk2ezXWEJJlWgMfTzro5GLU63eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlrCUTfkaa2gHL3A7SoB0CDfxZszZgaLeMkBhRJkuNyF37q2NayPJ87nVOyqjWNZ62xXers18U1ub/yVXq+Y0P9OhJNBuIYCpT1HS5wR8OrvuacQM+RVWZq4ybtK7JG9xu1rEnZADa8d1VxQJ0Izhlhw/PhFRZGJTjak6Fz73PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0103f3DB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0103f3DB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B53C4CEF1;
	Fri,  9 Jan 2026 12:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960203;
	bh=NbvYBe03tVcO35Eqsk2ezXWEJJlWgMfTzro5GLU63eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0103f3DBXLqGVrJzF7R6kFaO9KFhfCyAQ0NfxbAiRyBoBGxUlPwFFvVZZbiugKhVD
	 f1dJwJ6okPNVJGuYG86nqKCAQ0rlqJPRwbaT88api8unPvqOhcGY96itEihHPOvRtQ
	 mbTEaEmIK0V0xpue4RTNqrgDlqhAYs9TPnN4dPF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 289/737] efi/cper: align ARM CPER type with UEFI 2.9A/2.10 specs
Date: Fri,  9 Jan 2026 12:37:08 +0100
Message-ID: <20260109112144.883539541@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 96b010536ee020e716d28d9b359a4bcd18800aeb ]

Up to UEFI spec 2.9, the type byte of CPER struct for ARM processor
was defined simply as:

Type at byte offset 4:

	- Cache error
	- TLB Error
	- Bus Error
	- Micro-architectural Error
	All other values are reserved

Yet, there was no information about how this would be encoded.

Spec 2.9A errata corrected it by defining:

	- Bit 1 - Cache Error
	- Bit 2 - TLB Error
	- Bit 3 - Bus Error
	- Bit 4 - Micro-architectural Error
	All other values are reserved

That actually aligns with the values already defined on older
versions at N.2.4.1. Generic Processor Error Section.

Spec 2.10 also preserve the same encoding as 2.9A.

Adjust CPER and GHES handling code for both generic and ARM
processors to properly handle UEFI 2.9A and 2.10 encoding.

Link: https://uefi.org/specs/UEFI/2.10/Apx_N_Common_Platform_Error_Record.html#arm-processor-error-information
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c        | 16 +++++++----
 drivers/firmware/efi/cper-arm.c | 50 ++++++++++++++++-----------------
 include/linux/cper.h            | 10 +++----
 3 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index ec364c2541124..e768dfd345fb2 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -22,6 +22,7 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/acpi.h>
+#include <linux/bitfield.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/timer.h>
@@ -528,6 +529,7 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
 {
 	struct cper_sec_proc_arm *err = acpi_hest_get_payload(gdata);
 	int flags = sync ? MF_ACTION_REQUIRED : 0;
+	char error_type[120];
 	bool queued = false;
 	int sec_sev, i;
 	char *p;
@@ -541,9 +543,8 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
 	p = (char *)(err + 1);
 	for (i = 0; i < err->err_info_num; i++) {
 		struct cper_arm_err_info *err_info = (struct cper_arm_err_info *)p;
-		bool is_cache = (err_info->type == CPER_ARM_CACHE_ERROR);
+		bool is_cache = err_info->type & CPER_ARM_CACHE_ERROR;
 		bool has_pa = (err_info->validation_bits & CPER_ARM_INFO_VALID_PHYSICAL_ADDR);
-		const char *error_type = "unknown error";
 
 		/*
 		 * The field (err_info->error_info & BIT(26)) is fixed to set to
@@ -557,12 +558,15 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
 			continue;
 		}
 
-		if (err_info->type < ARRAY_SIZE(cper_proc_error_type_strs))
-			error_type = cper_proc_error_type_strs[err_info->type];
+		cper_bits_to_str(error_type, sizeof(error_type),
+				 FIELD_GET(CPER_ARM_ERR_TYPE_MASK, err_info->type),
+				 cper_proc_error_type_strs,
+				 ARRAY_SIZE(cper_proc_error_type_strs));
 
 		pr_warn_ratelimited(FW_WARN GHES_PFX
-				    "Unhandled processor error type: %s\n",
-				    error_type);
+				    "Unhandled processor error type 0x%02x: %s%s\n",
+				    err_info->type, error_type,
+				    (err_info->type & ~CPER_ARM_ERR_TYPE_MASK) ? " with reserved bit(s)" : "");
 		p += err_info->length;
 	}
 
diff --git a/drivers/firmware/efi/cper-arm.c b/drivers/firmware/efi/cper-arm.c
index eb7ee6af55f23..52d18490b59e3 100644
--- a/drivers/firmware/efi/cper-arm.c
+++ b/drivers/firmware/efi/cper-arm.c
@@ -93,15 +93,11 @@ static void cper_print_arm_err_info(const char *pfx, u32 type,
 	bool proc_context_corrupt, corrected, precise_pc, restartable_pc;
 	bool time_out, access_mode;
 
-	/* If the type is unknown, bail. */
-	if (type > CPER_ARM_MAX_TYPE)
-		return;
-
 	/*
 	 * Vendor type errors have error information values that are vendor
 	 * specific.
 	 */
-	if (type == CPER_ARM_VENDOR_ERROR)
+	if (type & CPER_ARM_VENDOR_ERROR)
 		return;
 
 	if (error_info & CPER_ARM_ERR_VALID_TRANSACTION_TYPE) {
@@ -116,43 +112,38 @@ static void cper_print_arm_err_info(const char *pfx, u32 type,
 	if (error_info & CPER_ARM_ERR_VALID_OPERATION_TYPE) {
 		op_type = ((error_info >> CPER_ARM_ERR_OPERATION_SHIFT)
 			   & CPER_ARM_ERR_OPERATION_MASK);
-		switch (type) {
-		case CPER_ARM_CACHE_ERROR:
+		if (type & CPER_ARM_CACHE_ERROR) {
 			if (op_type < ARRAY_SIZE(arm_cache_err_op_strs)) {
-				printk("%soperation type: %s\n", pfx,
+				printk("%scache error, operation type: %s\n", pfx,
 				       arm_cache_err_op_strs[op_type]);
 			}
-			break;
-		case CPER_ARM_TLB_ERROR:
+		}
+		if (type & CPER_ARM_TLB_ERROR) {
 			if (op_type < ARRAY_SIZE(arm_tlb_err_op_strs)) {
-				printk("%soperation type: %s\n", pfx,
+				printk("%sTLB error, operation type: %s\n", pfx,
 				       arm_tlb_err_op_strs[op_type]);
 			}
-			break;
-		case CPER_ARM_BUS_ERROR:
+		}
+		if (type & CPER_ARM_BUS_ERROR) {
 			if (op_type < ARRAY_SIZE(arm_bus_err_op_strs)) {
-				printk("%soperation type: %s\n", pfx,
+				printk("%sbus error, operation type: %s\n", pfx,
 				       arm_bus_err_op_strs[op_type]);
 			}
-			break;
 		}
 	}
 
 	if (error_info & CPER_ARM_ERR_VALID_LEVEL) {
 		level = ((error_info >> CPER_ARM_ERR_LEVEL_SHIFT)
 			 & CPER_ARM_ERR_LEVEL_MASK);
-		switch (type) {
-		case CPER_ARM_CACHE_ERROR:
+		if (type & CPER_ARM_CACHE_ERROR)
 			printk("%scache level: %d\n", pfx, level);
-			break;
-		case CPER_ARM_TLB_ERROR:
+
+		if (type & CPER_ARM_TLB_ERROR)
 			printk("%sTLB level: %d\n", pfx, level);
-			break;
-		case CPER_ARM_BUS_ERROR:
+
+		if (type & CPER_ARM_BUS_ERROR)
 			printk("%saffinity level at which the bus error occurred: %d\n",
 			       pfx, level);
-			break;
-		}
 	}
 
 	if (error_info & CPER_ARM_ERR_VALID_PROC_CONTEXT_CORRUPT) {
@@ -241,6 +232,7 @@ void cper_print_proc_arm(const char *pfx,
 	struct cper_arm_err_info *err_info;
 	struct cper_arm_ctx_info *ctx_info;
 	char newpfx[64], infopfx[ARRAY_SIZE(newpfx) + 1];
+	char error_type[120];
 
 	printk("%sMIDR: 0x%016llx\n", pfx, proc->midr);
 
@@ -289,9 +281,15 @@ void cper_print_proc_arm(const char *pfx,
 				       newpfx);
 		}
 
-		printk("%serror_type: %d, %s\n", newpfx, err_info->type,
-			err_info->type < ARRAY_SIZE(cper_proc_error_type_strs) ?
-			cper_proc_error_type_strs[err_info->type] : "unknown");
+		cper_bits_to_str(error_type, sizeof(error_type),
+				 FIELD_GET(CPER_ARM_ERR_TYPE_MASK, err_info->type),
+				 cper_proc_error_type_strs,
+				 ARRAY_SIZE(cper_proc_error_type_strs));
+
+		printk("%serror_type: 0x%02x: %s%s\n", newpfx, err_info->type,
+		       error_type,
+		       (err_info->type & ~CPER_ARM_ERR_TYPE_MASK) ? " with reserved bit(s)" : "");
+
 		if (err_info->validation_bits & CPER_ARM_INFO_VALID_ERR_INFO) {
 			printk("%serror_info: 0x%016llx\n", newpfx,
 			       err_info->error_info);
diff --git a/include/linux/cper.h b/include/linux/cper.h
index f792e4b3df907..ad1ed24730917 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -270,11 +270,11 @@ enum {
 #define CPER_ARM_INFO_FLAGS_PROPAGATED		BIT(2)
 #define CPER_ARM_INFO_FLAGS_OVERFLOW		BIT(3)
 
-#define CPER_ARM_CACHE_ERROR			0
-#define CPER_ARM_TLB_ERROR			1
-#define CPER_ARM_BUS_ERROR			2
-#define CPER_ARM_VENDOR_ERROR			3
-#define CPER_ARM_MAX_TYPE			CPER_ARM_VENDOR_ERROR
+#define CPER_ARM_ERR_TYPE_MASK			GENMASK(4,1)
+#define CPER_ARM_CACHE_ERROR			BIT(1)
+#define CPER_ARM_TLB_ERROR			BIT(2)
+#define CPER_ARM_BUS_ERROR			BIT(3)
+#define CPER_ARM_VENDOR_ERROR			BIT(4)
 
 #define CPER_ARM_ERR_VALID_TRANSACTION_TYPE	BIT(0)
 #define CPER_ARM_ERR_VALID_OPERATION_TYPE	BIT(1)
-- 
2.51.0



