Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29122596
	for <patches@lists.linux.dev>; Thu,  7 Apr 2022 19:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649358858; x=1680894858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Y4gJAbytw/F2rabC0TV0qHXjA19vEQTh9ZYHXlLb3LE=;
  b=lq14v/32G4ETb5bNwnZDc3ewADmZZvBvBxB7df+wzBPdc5qtBdKW2IjM
   DabWB3lxeuRedElPIdse6whUXWlO1Nog/3bGU5TP5lNLjhpo1nVw0GwK4
   Peu4lK19cWMPTGxtzn7HGUkWP6MFsI2cnSmMLgAJ4KpHWAqJ5sbb4GjAt
   HzS+A8z+gllwRl/2VOXcAhd96vJU+T2O9ubVSp1FQh17jk6+iw9ac9bdJ
   +xEnewuU1raBVQqoOd4dMmv+JEnenYQYlLgY4TtVKU+Rh4jSnvnHHIKNQ
   YiJu9w1SSBAurcL4vDoQlXJIvLJ13Astbt/hRVdomA7yQdusz7oZeyzPo
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="322111000"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="322111000"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 12:14:16 -0700
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="571193709"
Received: from coffy.sc.intel.com ([10.3.79.166])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 12:14:16 -0700
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
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: [PATCH v2 03/10] platform/x86/intel/ifs: Add driver for In-Field Scan
Date: Thu,  7 Apr 2022 12:13:40 -0700
Message-Id: <20220407191347.9681-4-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220407191347.9681-1-jithu.joseph@intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Cloud Service Providers that operate fleets of servers have reported
[1] occasions where they can detect that a CPU has gone bad due to
effects like electromigration, or isolated manufacturing defects.
However, that detection method is A/B testing seemingly random
application failures looking for a pattern. In-Field Scan (IFS) is
a driver for a platform capability to load a crafted 'scan image'
to run targeted low level diagnostics outside of the CPU's architectural
error detection capabilities.

[1]: https://www.youtube.com/watch?v=QMF3rqhjYuM

IFS will be available in some server SKUs starting with Sapphire Rapids.

Add basic parts of the IFS module (initialization and check IFS capability
support in a processor).

MSR IA32_CORE_CAPABILITY is a feature-enumerating MSR, bit 2 of which
reports MSR_INTEGRITY_CAPABILITIES. Processor that supports IFS
should reports the MSR_INTEGRITY_CAPABILITIES enabled.

Please check the latest Intel 64 and IA-32 Architectures Software
Developer's Manual for more detailed information on the MSR and the
MSR_INTEGRITY_CAPABILITIES.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 MAINTAINERS                             |  7 ++++
 drivers/platform/x86/intel/Kconfig      |  1 +
 drivers/platform/x86/intel/Makefile     |  1 +
 drivers/platform/x86/intel/ifs/Kconfig  |  9 +++++
 drivers/platform/x86/intel/ifs/Makefile |  3 ++
 drivers/platform/x86/intel/ifs/core.c   | 44 +++++++++++++++++++++++++
 drivers/platform/x86/intel/ifs/ifs.h    | 11 +++++++
 7 files changed, 76 insertions(+)
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
index 000000000000..c44305dff542
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_INTEL_IFS)			+= intel_ifs.o
+
+intel_ifs-objs				:= core.o
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
new file mode 100644
index 000000000000..87956623208f
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2022 Intel Corporation. */
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
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Intel In Field Scan (IFS) driver");
+module_init(ifs_init);
+module_exit(ifs_exit);
diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
new file mode 100644
index 000000000000..bb25a4cd3af6
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2022 Intel Corporation. */
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

