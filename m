Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896D323F439;
	Thu, 27 Nov 2025 15:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255653; cv=none; b=unFO1XtZLBbw1GJkVJtU5WPPfQKmXlAGskCgF3kYSrfn1Y8o3q/myAasAdrRayqfloZKn5gN3etPZx4MMNd4vlQMms+/IZ/efRqHncTUMzpJDhDcfjBj52/eoXCO4IfbT0Xv5znQEhnJipX++BIx166M7Z7hzkzeVI3LqEY6nAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255653; c=relaxed/simple;
	bh=YFg4t1mObEuCRCpY/kYDbO7ebwt2m+f0yR0zBw0sEz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiMQWo/HFoTZg3ccHuZuDR63543T1BPX5v59kWQ/YiTtfQShG8h6PnWP4B2IduBGhREP1EK1NBC2+RcAbk8DJnP39K+XJ4DleW4UIzI33MSAgrBasYMdX4eUlT1yuwEwJGkI8snRdcDlgh3Zg2WQoE7tZYtPuORCYdGzKC0hyPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BV+ZZHvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BV+ZZHvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB23C113D0;
	Thu, 27 Nov 2025 15:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255653;
	bh=YFg4t1mObEuCRCpY/kYDbO7ebwt2m+f0yR0zBw0sEz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BV+ZZHvqQyHiVOcqTtuwykhXuC4v6iq+orS4Trg6sCSV05Ev9m/qitgYxOVeeYIUI
	 8YSuu76AoxvrWtYD5ha9IIXeNC4wHHAV/URUkmqkzWp0jTeGLe4oZrnUKt1Bg+8K1V
	 hOAdDXbdypmaUqw28b06kvDfAE5v7dFzUS1Leq0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 024/175] ACPI: APEI: EINJ: Fix EINJV2 initialization and injection
Date: Thu, 27 Nov 2025 15:44:37 +0100
Message-ID: <20251127144043.847191193@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit d2932a59c2d4fb364396f21df58431c44918dd47 upstream.

ACPI 6.6 specification for EINJV2 appends an extra structure to
the end of the existing struct set_error_type_with_address.

Several issues showed up in testing.

 1) Initialization was broken by an earlier fix [1] since is_v2 is only
    set while performing an injection, not during initialization.

 2) A buggy BIOS provided invalid "revision" and "length" for the
    extension structure. Add several sanity checks.

 3) When injecting legacy error types on an EINJV2 capable system,
    don't copy the component arrays.

Fixes: 6c7058514991 ("ACPI: APEI: EINJ: Check if user asked for EINJV2 injection") # [1]
Fixes: b47610296d17 ("ACPI: APEI: EINJ: Enable EINJv2 error injections")
Signed-off-by: Tony Luck <tony.luck@intel.com>
[ rjw: Changelog edits ]
Cc: 6.17+ <stable@vger.kernel.org> # 6.17+
Link: https://patch.msgid.link/20251119012712.178715-1-tony.luck@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/apei/einj-core.c |   64 ++++++++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 23 deletions(-)

--- a/drivers/acpi/apei/einj-core.c
+++ b/drivers/acpi/apei/einj-core.c
@@ -182,6 +182,7 @@ bool einj_initialized __ro_after_init;
 
 static void __iomem *einj_param;
 static u32 v5param_size;
+static u32 v66param_size;
 static bool is_v2;
 
 static void einj_exec_ctx_init(struct apei_exec_context *ctx)
@@ -283,6 +284,24 @@ static void check_vendor_extension(u64 p
 	acpi_os_unmap_iomem(p, sizeof(v));
 }
 
+static u32 einjv2_init(struct einjv2_extension_struct *e)
+{
+	if (e->revision != 1) {
+		pr_info("Unknown v2 extension revision %u\n", e->revision);
+		return 0;
+	}
+	if (e->length < sizeof(*e) || e->length > PAGE_SIZE) {
+		pr_info(FW_BUG "Bad1 v2 extension length %u\n", e->length);
+		return 0;
+	}
+	if ((e->length - sizeof(*e)) % sizeof(e->component_arr[0])) {
+		pr_info(FW_BUG "Bad2 v2 extension length %u\n", e->length);
+		return 0;
+	}
+
+	return (e->length - sizeof(*e)) / sizeof(e->component_arr[0]);
+}
+
 static void __iomem *einj_get_parameter_address(void)
 {
 	int i;
@@ -310,28 +329,21 @@ static void __iomem *einj_get_parameter_
 		v5param_size = sizeof(v5param);
 		p = acpi_os_map_iomem(pa_v5, sizeof(*p));
 		if (p) {
-			int offset, len;
-
 			memcpy_fromio(&v5param, p, v5param_size);
 			acpi5 = 1;
 			check_vendor_extension(pa_v5, &v5param);
-			if (is_v2 && available_error_type & ACPI65_EINJV2_SUPP) {
-				len = v5param.einjv2_struct.length;
-				offset = offsetof(struct einjv2_extension_struct, component_arr);
-				max_nr_components = (len - offset) /
-						sizeof(v5param.einjv2_struct.component_arr[0]);
-				/*
-				 * The first call to acpi_os_map_iomem above does not include the
-				 * component array, instead it is used to read and calculate maximum
-				 * number of components supported by the system. Below, the mapping
-				 * is expanded to include the component array.
-				 */
+			if (available_error_type & ACPI65_EINJV2_SUPP) {
+				struct einjv2_extension_struct *e;
+
+				e = &v5param.einjv2_struct;
+				max_nr_components = einjv2_init(e);
+
+				/* remap including einjv2_extension_struct */
 				acpi_os_unmap_iomem(p, v5param_size);
-				offset = offsetof(struct set_error_type_with_address, einjv2_struct);
-				v5param_size = offset + struct_size(&v5param.einjv2_struct,
-					component_arr, max_nr_components);
-				p = acpi_os_map_iomem(pa_v5, v5param_size);
+				v66param_size = v5param_size - sizeof(*e) + e->length;
+				p = acpi_os_map_iomem(pa_v5, v66param_size);
 			}
+
 			return p;
 		}
 	}
@@ -527,6 +539,7 @@ static int __einj_error_inject(u32 type,
 			       u64 param3, u64 param4)
 {
 	struct apei_exec_context ctx;
+	u32 param_size = is_v2 ? v66param_size : v5param_size;
 	u64 val, trigger_paddr, timeout = FIRMWARE_TIMEOUT;
 	int i, rc;
 
@@ -539,11 +552,11 @@ static int __einj_error_inject(u32 type,
 	if (acpi5) {
 		struct set_error_type_with_address *v5param;
 
-		v5param = kmalloc(v5param_size, GFP_KERNEL);
+		v5param = kmalloc(param_size, GFP_KERNEL);
 		if (!v5param)
 			return -ENOMEM;
 
-		memcpy_fromio(v5param, einj_param, v5param_size);
+		memcpy_fromio(v5param, einj_param, param_size);
 		v5param->type = type;
 		if (type & ACPI5_VENDOR_BIT) {
 			switch (vendor_flags) {
@@ -601,7 +614,7 @@ static int __einj_error_inject(u32 type,
 				break;
 			}
 		}
-		memcpy_toio(einj_param, v5param, v5param_size);
+		memcpy_toio(einj_param, v5param, param_size);
 		kfree(v5param);
 	} else {
 		rc = apei_exec_run(&ctx, ACPI_EINJ_SET_ERROR_TYPE);
@@ -1099,9 +1112,14 @@ static void einj_remove(struct faux_devi
 	struct apei_exec_context ctx;
 
 	if (einj_param) {
-		acpi_size size = (acpi5) ?
-			v5param_size :
-			sizeof(struct einj_parameter);
+		acpi_size size;
+
+		if (v66param_size)
+			size = v66param_size;
+		else if (acpi5)
+			size = v5param_size;
+		else
+			size = sizeof(struct einj_parameter);
 
 		acpi_os_unmap_iomem(einj_param, size);
 		if (vendor_errors.size)


