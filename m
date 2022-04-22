Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C492F36
	for <patches@lists.linux.dev>; Fri, 22 Apr 2022 20:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650657750; x=1682193750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0y0ARuJOG0aT4gpANTyQc+sN+Oa1pFODX+GbED6WNn4=;
  b=lJclzM34PM/nnsMPzAi/iTJ1qfFRwweYeF3X9EF2rael7HrP/34NdmpH
   JofyRK7waDSIwyyaPtZuE05mH9doGW9Cd4XEj6vB4Pof6nZesJKRrMG5x
   zKLAG1Q0mmazK4Qk5tamJF+EkyoFBsh2OTux2LoqR0MaS2zTECdbVqzzz
   n49SC6zDUKb4GxQMM+Mo9CUYlr4K3UCwCtCfiYjEibLhaRPHXkXi8Vn7K
   J+f0YIqDOcEnWFq0+qAHusZmvs0q6B1NpYb4myjGhx4DzPDpKxa6mB438
   cSoveZjgUwvNoL8Tc780ijGtiC+s5xnCULzVCehN2DwLqxTZ82bMTPuKs
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="289897456"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="289897456"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 13:02:27 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="511719334"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 13:02:26 -0700
From: Tony Luck <tony.luck@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	corbet@lwn.net,
	gregkh@linuxfoundation.org,
	andriy.shevchenko@linux.intel.com,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	rostedt@goodmis.org,
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: [PATCH v4 04/10] platform/x86/intel/ifs: Read IFS firmware image
Date: Fri, 22 Apr 2022 13:02:13 -0700
Message-Id: <20220422200219.2843823-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422200219.2843823-1-tony.luck@intel.com>
References: <20220419163859.2228874-1-tony.luck@intel.com>
 <20220422200219.2843823-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jithu Joseph <jithu.joseph@intel.com>

Driver probe routine allocates structure to communicate status
and parameters between functions in the driver. Also call
load_ifs_binary() to load the scan image file.

There is a separate scan image file for each processor family,
model, stepping combination. This is read from the static path:

  /lib/firmware/intel/ifs/{ff-mm-ss}.scan

Step 1 in loading is to generate the correct path and use
request_firmware_direct() to load into memory.

Subsequent patches will use the IFS MSR interfaces to copy
the image to BIOS reserved memory and validate the SHA256
checksums.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/Makefile |  2 +-
 drivers/platform/x86/intel/ifs/core.c   | 36 ++++++++++++++++++++++++-
 drivers/platform/x86/intel/ifs/ifs.h    | 25 +++++++++++++++++
 drivers/platform/x86/intel/ifs/load.c   | 28 +++++++++++++++++++
 4 files changed, 89 insertions(+), 2 deletions(-)
 create mode 100644 drivers/platform/x86/intel/ifs/ifs.h
 create mode 100644 drivers/platform/x86/intel/ifs/load.c

diff --git a/drivers/platform/x86/intel/ifs/Makefile b/drivers/platform/x86/intel/ifs/Makefile
index af904880e959..98b6fde15689 100644
--- a/drivers/platform/x86/intel/ifs/Makefile
+++ b/drivers/platform/x86/intel/ifs/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_INTEL_IFS)		+= intel_ifs.o
 
-intel_ifs-objs			:= core.o
+intel_ifs-objs			:= core.o load.o
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 5713e6ee90f0..ed4ded6755b2 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -6,6 +6,8 @@
 
 #include <asm/cpu_device_id.h>
 
+#include "ifs.h"
+
 enum test_types {
 	IFS_SAF,
 };
@@ -20,10 +22,27 @@ static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
 };
 MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
 
+static struct ifs_device ifs_devices[] = {
+	[IFS_SAF] = {
+		.data = {
+			.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
+		},
+		.misc = {
+			.name = "intel_ifs_0",
+			.nodename = "intel_ifs/0",
+			.minor = MISC_DYNAMIC_MINOR,
+		},
+	},
+};
+
+#define IFS_NUMTESTS ARRAY_SIZE(ifs_devices)
+
 static int __init ifs_init(void)
 {
 	const struct x86_cpu_id *m;
+	int ndevices = 0;
 	u64 msrval;
+	int i;
 
 	m = x86_match_cpu(ifs_cpu_ids);
 	if (!m)
@@ -38,11 +57,26 @@ static int __init ifs_init(void)
 	if (rdmsrl_safe(MSR_INTEGRITY_CAPS, &msrval))
 		return -ENODEV;
 
-	return 0;
+	for (i = 0; i < IFS_NUMTESTS; i++) {
+		if (!(msrval & BIT(ifs_devices[i].data.integrity_cap_bit)))
+			continue;
+
+		if (!misc_register(&ifs_devices[i].misc)) {
+			ndevices++;
+			ifs_load_firmware(ifs_devices[i].misc.this_device);
+		}
+	}
+
+	return ndevices ? 0 : -ENODEV;
 }
 
 static void __exit ifs_exit(void)
 {
+	int i;
+
+	for (i = 0; i < IFS_NUMTESTS; i++)
+		if (ifs_devices[i].misc.this_device)
+			misc_deregister(&ifs_devices[i].misc);
 }
 
 module_init(ifs_init);
diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
new file mode 100644
index 000000000000..9a0f8e2077e2
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2022 Intel Corporation. */
+
+#ifndef _IFS_H_
+#define _IFS_H_
+
+#include <linux/device.h>
+#include <linux/miscdevice.h>
+
+/**
+ * struct ifs_data - attributes related to intel IFS driver
+ * @integrity_cap_bit - MSR_INTEGRITY_CAPS bit enumerating this test
+ */
+struct ifs_data {
+	int integrity_cap_bit;
+};
+
+struct ifs_device {
+	struct ifs_data data;
+	struct miscdevice misc;
+};
+
+void ifs_load_firmware(struct device *dev);
+
+#endif
diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
new file mode 100644
index 000000000000..9fb71d38c819
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2022 Intel Corporation. */
+
+#include <linux/firmware.h>
+
+#include "ifs.h"
+
+/*
+ * Load ifs image. Before loading ifs module, the ifs image must be located
+ * in /lib/firmware/intel/ifs and named as {family/model/stepping}.{testname}.
+ */
+void ifs_load_firmware(struct device *dev)
+{
+	const struct firmware *fw;
+	char scan_path[32];
+	int ret;
+
+	snprintf(scan_path, sizeof(scan_path), "intel/ifs/%02x-%02x-%02x.scan",
+		 boot_cpu_data.x86, boot_cpu_data.x86_model, boot_cpu_data.x86_stepping);
+
+	ret = request_firmware_direct(&fw, scan_path, dev);
+	if (ret) {
+		dev_err(dev, "ifs file %s load failed\n", scan_path);
+		return;
+	}
+
+	release_firmware(fw);
+}
-- 
2.35.1

