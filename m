Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BA77C
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 19:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646164557; x=1677700557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=IX9RbOmrBoZoGdoaea4eD/8Uj1Ve7FBJwYQ9q6QGXdw=;
  b=JshYMWM18WSsaO3XeS9TAcK7aJ2imu5taXPJHtxQiqdFnZt0CisPMVPd
   5OBxVopQnQDIWZM7A9xNXI/rmqgFt6XOZ/UDIBWPL84UC4Q6OJ9tfDAFb
   ZJdd7cSFDvyzMwjE1x9crZ8HkWqjPKIugbiVzBpgGoLLyaP4ALqIreSKA
   7xqzBWGTBiDVcmWgX8cB09rlJAtkMZL11RU4tYU1YlwlCCXOHO2PCuOF+
   4ufBSaNIrRZrGMn9VZXJdFh5KY1qeahjDQIn6z8gwIqCsS5V2qskRJh68
   HI7jhA/0EugSf/XhcvZ6PiBKMz4TzaBaGICT6GCjyWJxWPb/1EWRvcJMV
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="252958558"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="252958558"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 11:55:53 -0800
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="630133161"
Received: from coffy.sc.intel.com ([10.3.79.166])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 11:55:53 -0800
From: Jithu Joseph <jithu.joseph@intel.com>
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
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: [RFC 03/10] platform/x86/intel/ifs: Add driver for In-Field Scan
Date: Tue,  1 Mar 2022 11:54:50 -0800
Message-Id: <20220301195457.21152-4-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301195457.21152-1-jithu.joseph@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

In-Field Scan (IFS) provides hardware hooks to perform core tests and
report failures for portions of silicon that lack error detection
capabilities, which will be available in some server SKUs starting with
Sapphire Rapids. It offers infrastructure to specific users such as cloud
providers or OEMs to schedule tests and find in-field failures due to aging
in silicon that might not necessarily be reported with normal machine
checks.

Add basic parts of the IFS module (initialization and check IFS capability
support in a processor).

MSR IA32_CORE_CAPABILITY is a feature-enumerating MSR, bit 2 of which
reports MSR_INTEGRITY_CAPABILITIES. Processor that supports IFS
should reports the MSR_INTEGRITY_CAPABILITIES enabled.

Please check the latest Intel 64 and IA-32 Architectures Software
Developer's Manual for more detailed information on the MSR and the
MSR_INTEGRITY_CAPABILITIES.

Originally-by: Kyung Min Park <kyung.min.park@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 MAINTAINERS                             |  7 ++++
 drivers/platform/x86/intel/Kconfig      |  1 +
 drivers/platform/x86/intel/Makefile     |  1 +
 drivers/platform/x86/intel/ifs/Kconfig  |  9 +++++
 drivers/platform/x86/intel/ifs/Makefile |  7 ++++
 drivers/platform/x86/intel/ifs/core.c   | 49 +++++++++++++++++++++++++
 drivers/platform/x86/intel/ifs/ifs.h    | 14 +++++++
 7 files changed, 88 insertions(+)
 create mode 100644 drivers/platform/x86/intel/ifs/Kconfig
 create mode 100644 drivers/platform/x86/intel/ifs/Makefile
 create mode 100644 drivers/platform/x86/intel/ifs/core.c
 create mode 100644 drivers/platform/x86/intel/ifs/ifs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 777cd6fa2b3d..4c9912c0d725 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9685,6 +9685,13 @@ B:	https://bugzilla.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git
 F:	drivers/idle/intel_idle.c
 
+INTEL IN FIELD SCAN (IFS) DRIVER
+M:	Jithu Joseph <jithu.joseph@intel.com>
+R:	Ashok Raj <ashok.raj@intel.com>
+R:	Tony Luck <tony.luck@intel.com>
+S:	Maintained
+F:	drivers/platform/x86/intel/ifs
+
 INTEL INTEGRATED SENSOR HUB DRIVER
 M:	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
 M:	Jiri Kosina <jikos@kernel.org>
diff --git a/drivers/platform/x86/intel/Kconfig b/drivers/platform/x86/intel/Kconfig
index 8e65086bb6c8..7339e7daf0a1 100644
--- a/drivers/platform/x86/intel/Kconfig
+++ b/drivers/platform/x86/intel/Kconfig
@@ -4,6 +4,7 @@
 #
 
 source "drivers/platform/x86/intel/atomisp2/Kconfig"
+source "drivers/platform/x86/intel/ifs/Kconfig"
 source "drivers/platform/x86/intel/int1092/Kconfig"
 source "drivers/platform/x86/intel/int33fe/Kconfig"
 source "drivers/platform/x86/intel/int3472/Kconfig"
diff --git a/drivers/platform/x86/intel/Makefile b/drivers/platform/x86/intel/Makefile
index 35f2066578b2..bd7f2ef5e767 100644
--- a/drivers/platform/x86/intel/Makefile
+++ b/drivers/platform/x86/intel/Makefile
@@ -5,6 +5,7 @@
 #
 
 obj-$(CONFIG_INTEL_ATOMISP2_PDX86)	+= atomisp2/
+obj-$(CONFIG_INTEL_IFS)			+= ifs/
 obj-$(CONFIG_INTEL_SAR_INT1092)		+= int1092/
 obj-$(CONFIG_INTEL_CHT_INT33FE)		+= int33fe/
 obj-$(CONFIG_INTEL_SKL_INT3472)		+= int3472/
diff --git a/drivers/platform/x86/intel/ifs/Kconfig b/drivers/platform/x86/intel/ifs/Kconfig
new file mode 100644
index 000000000000..88e3d4fa1759
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/Kconfig
@@ -0,0 +1,9 @@
+config INTEL_IFS
+	tristate "Intel In Field Scan"
+	depends on X86 && 64BIT && SMP
+	help
+	  Enable support for In Field Scan in Intel CPU to perform core
+	  logic test in the field. To compile this driver as a module, choose
+	  M here. The module will be called intel_ifs.
+
+	  If unsure, say N.
diff --git a/drivers/platform/x86/intel/ifs/Makefile b/drivers/platform/x86/intel/ifs/Makefile
new file mode 100644
index 000000000000..05b4925402b4
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the In-Field Scan driver
+#
+
+obj-$(CONFIG_INTEL_IFS)			+= intel_ifs.o
+
+intel_ifs-objs				:= core.o
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
new file mode 100644
index 000000000000..fb3c864d3085
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2021 Intel Corporation.
+ *
+ * Author: Jithu Joseph <jithu.joseph@intel.com>
+ */
+
+#include <linux/module.h>
+#include <asm/cpu_device_id.h>
+
+#include "ifs.h"
+
+#define X86_MATCH(model)					\
+	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(INTEL, 6,		\
+		INTEL_FAM6_##model, X86_FEATURE_CORE_CAPABILITIES, NULL)
+
+static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
+	X86_MATCH(SAPPHIRERAPIDS_X),
+	{}
+};
+
+MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
+
+static int __init ifs_init(void)
+{
+	const struct x86_cpu_id *m;
+	u64 ia32_core_caps;
+
+	/* ifs capability check */
+	m = x86_match_cpu(ifs_cpu_ids);
+	if (!m)
+		return -ENODEV;
+	if (rdmsrl_safe(MSR_IA32_CORE_CAPS, &ia32_core_caps))
+		return -ENODEV;
+	if (!(ia32_core_caps & MSR_IA32_CORE_CAPS_INTEGRITY))
+		return -ENODEV;
+
+	return 0;
+}
+
+static void __exit ifs_exit(void)
+{
+	pr_info("unloaded 'In-Field Scan' module\n");
+}
+
+MODULE_LICENSE("GPL");
+MODULE_INFO(name, "ifs");
+MODULE_DESCRIPTION("ifs");
+module_init(ifs_init);
+module_exit(ifs_exit);
diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
new file mode 100644
index 000000000000..f3f924fced06
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2021 Intel Corporation.
+ *
+ * Author: Jithu Joseph <jithu.joseph@intel.com>
+ */
+
+#ifndef _IFS_H_
+#define _IFS_H_
+
+/* These bits are in the IA32_CORE_CAPABILITIES MSR */
+#define MSR_IA32_CORE_CAPS_INTEGRITY_BIT	2
+#define MSR_IA32_CORE_CAPS_INTEGRITY		BIT(MSR_IA32_CORE_CAPS_INTEGRITY_BIT)
+
+#endif
-- 
2.17.1

