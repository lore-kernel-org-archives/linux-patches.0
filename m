Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCA12511F;
	Fri, 24 Nov 2023 18:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YaanWFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20DBC433CC;
	Fri, 24 Nov 2023 18:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849843;
	bh=B1d6BT5X4tGTlE9Bawo1gSmbilEjYHf64TkUFBdUTHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YaanWFEfdwR5q/BCcCA1yIoHk7joFRzCctZcrYMDrdYAnlu0l4RR1SijxWGgrgST
	 Pj6cW2jln0Yxs2XN5gTRp/Cf9lfDi9CADOBC1Bb1pNR0W7qHBtaeVNIuqVuKFw9z3B
	 KuzJ/tqRFUDq/0OTMR4o1noVCGf3N7u/18NZ0Ne4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 342/530] ACPI: FPDT: properly handle invalid FPDT subtables
Date: Fri, 24 Nov 2023 17:48:28 +0000
Message-ID: <20231124172038.445761333@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vasily Khoruzhick <anarsoul@gmail.com>

commit a83c68a3bf7c418c9a46693c63c638852b0c1f4e upstream.

Buggy BIOSes may have invalid FPDT subtables, e.g. on my hardware:

S3PT subtable:

7F20FE30: 53 33 50 54 24 00 00 00-00 00 00 00 00 00 18 01  *S3PT$...........*
7F20FE40: 00 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00  *................*
7F20FE50: 00 00 00 00

Here the first record has zero length.

FBPT subtable:

7F20FE50:             46 42 50 54-3C 00 00 00 46 42 50 54  *....FBPT<...FBPT*
7F20FE60: 02 00 30 02 00 00 00 00-00 00 00 00 00 00 00 00  *..0.............*
7F20FE70: 2A A6 BC 6E 0B 00 00 00-1A 44 41 70 0B 00 00 00  **..n.....DAp....*
7F20FE80: 00 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00  *................*

And here FBPT table has FBPT signature repeated instead of the first
record.

Current code will be looping indefinitely due to zero length records, so
break out of the loop if record length is zero.

While we are here, add proper handling for fpdt_process_subtable()
failures.

Fixes: d1eb86e59be0 ("ACPI: tables: introduce support for FPDT table")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
[ rjw: Comment edit, added empty code lines ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_fpdt.c |   45 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

--- a/drivers/acpi/acpi_fpdt.c
+++ b/drivers/acpi/acpi_fpdt.c
@@ -194,12 +194,19 @@ static int fpdt_process_subtable(u64 add
 		record_header = (void *)subtable_header + offset;
 		offset += record_header->length;
 
+		if (!record_header->length) {
+			pr_err(FW_BUG "Zero-length record found in FPTD.\n");
+			result = -EINVAL;
+			goto err;
+		}
+
 		switch (record_header->type) {
 		case RECORD_S3_RESUME:
 			if (subtable_type != SUBTABLE_S3PT) {
 				pr_err(FW_BUG "Invalid record %d for subtable %s\n",
 				     record_header->type, signature);
-				return -EINVAL;
+				result = -EINVAL;
+				goto err;
 			}
 			if (record_resume) {
 				pr_err("Duplicate resume performance record found.\n");
@@ -208,7 +215,7 @@ static int fpdt_process_subtable(u64 add
 			record_resume = (struct resume_performance_record *)record_header;
 			result = sysfs_create_group(fpdt_kobj, &resume_attr_group);
 			if (result)
-				return result;
+				goto err;
 			break;
 		case RECORD_S3_SUSPEND:
 			if (subtable_type != SUBTABLE_S3PT) {
@@ -223,13 +230,14 @@ static int fpdt_process_subtable(u64 add
 			record_suspend = (struct suspend_performance_record *)record_header;
 			result = sysfs_create_group(fpdt_kobj, &suspend_attr_group);
 			if (result)
-				return result;
+				goto err;
 			break;
 		case RECORD_BOOT:
 			if (subtable_type != SUBTABLE_FBPT) {
 				pr_err(FW_BUG "Invalid %d for subtable %s\n",
 				     record_header->type, signature);
-				return -EINVAL;
+				result = -EINVAL;
+				goto err;
 			}
 			if (record_boot) {
 				pr_err("Duplicate boot performance record found.\n");
@@ -238,7 +246,7 @@ static int fpdt_process_subtable(u64 add
 			record_boot = (struct boot_performance_record *)record_header;
 			result = sysfs_create_group(fpdt_kobj, &boot_attr_group);
 			if (result)
-				return result;
+				goto err;
 			break;
 
 		default:
@@ -247,6 +255,18 @@ static int fpdt_process_subtable(u64 add
 		}
 	}
 	return 0;
+
+err:
+	if (record_boot)
+		sysfs_remove_group(fpdt_kobj, &boot_attr_group);
+
+	if (record_suspend)
+		sysfs_remove_group(fpdt_kobj, &suspend_attr_group);
+
+	if (record_resume)
+		sysfs_remove_group(fpdt_kobj, &resume_attr_group);
+
+	return result;
 }
 
 static int __init acpi_init_fpdt(void)
@@ -255,6 +275,7 @@ static int __init acpi_init_fpdt(void)
 	struct acpi_table_header *header;
 	struct fpdt_subtable_entry *subtable;
 	u32 offset = sizeof(*header);
+	int result;
 
 	status = acpi_get_table(ACPI_SIG_FPDT, 0, &header);
 
@@ -263,8 +284,8 @@ static int __init acpi_init_fpdt(void)
 
 	fpdt_kobj = kobject_create_and_add("fpdt", acpi_kobj);
 	if (!fpdt_kobj) {
-		acpi_put_table(header);
-		return -ENOMEM;
+		result = -ENOMEM;
+		goto err_nomem;
 	}
 
 	while (offset < header->length) {
@@ -272,8 +293,10 @@ static int __init acpi_init_fpdt(void)
 		switch (subtable->type) {
 		case SUBTABLE_FBPT:
 		case SUBTABLE_S3PT:
-			fpdt_process_subtable(subtable->address,
+			result = fpdt_process_subtable(subtable->address,
 					      subtable->type);
+			if (result)
+				goto err_subtable;
 			break;
 		default:
 			/* Other types are reserved in ACPI 6.4 spec. */
@@ -282,6 +305,12 @@ static int __init acpi_init_fpdt(void)
 		offset += sizeof(*subtable);
 	}
 	return 0;
+err_subtable:
+	kobject_put(fpdt_kobj);
+
+err_nomem:
+	acpi_put_table(header);
+	return result;
 }
 
 fs_initcall(acpi_init_fpdt);


