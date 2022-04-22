Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3282F25
	for <patches@lists.linux.dev>; Fri, 22 Apr 2022 20:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650657752; x=1682193752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9SGqKP+RRrUMRHDTZuXBZum/5mUpmU8WzfMsEq5O2kU=;
  b=KvJmhjGDOSbtneOk/HCWeo9guLozbidQWI5mNh3oJm5v0G8RVNrXcSWt
   67EqoozbxUFXTKqG389OR//Ff0ql6lhgnHTRXUgSk1ULFuVcDBZ0M+0I1
   BsoGPwftFYhTBPKmk00JeiLpdiNAoLvQjSnbNYIyCIJYmBGvBMVPKNqw6
   0X55s9spHAmPsmJLD5peRaGyzfllyE9tj/JvYB+Iy8IbPKz9w7DMFhjxj
   SMeM/ViZ2rh8qFqFe4VPIb/EGTuxCUNmRHamfKlEV0REP7pIHDtmzRud8
   A/byAVzwKmvKWoadGLJenta6zyQJEfDmUpBG2IZncbOCJmvXhVGhSiap3
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="289897468"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="289897468"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 13:02:29 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="511719356"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 13:02:28 -0700
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
Subject: [PATCH v4 08/10] platform/x86/intel/ifs: Add IFS sysfs interface
Date: Fri, 22 Apr 2022 13:02:17 -0700
Message-Id: <20220422200219.2843823-9-tony.luck@intel.com>
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

Implement sysfs interface to trigger ifs test for a specific cpu.
Additional interfaces related to checking the status of the
scan test and seeing the version of the loaded IFS binary
are also added.

The basic usage is as below.
   - To start test, for example on cpu5:
       echo 5 > /sys/devices/platform/intel_ifs/run_test
   - To see the status of the last test
       cat /sys/devices/platform/intel_ifs/status
   - To see the version of the loaded scan binary
       cat /sys/devices/platform/intel_ifs/image_version

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/Makefile |   2 +-
 drivers/platform/x86/intel/ifs/core.c   |   4 +
 drivers/platform/x86/intel/ifs/ifs.h    |   3 +
 drivers/platform/x86/intel/ifs/sysfs.c  | 147 ++++++++++++++++++++++++
 4 files changed, 155 insertions(+), 1 deletion(-)
 create mode 100644 drivers/platform/x86/intel/ifs/sysfs.c

diff --git a/drivers/platform/x86/intel/ifs/Makefile b/drivers/platform/x86/intel/ifs/Makefile
index cedcb103f860..30f035ef5581 100644
--- a/drivers/platform/x86/intel/ifs/Makefile
+++ b/drivers/platform/x86/intel/ifs/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_INTEL_IFS)		+= intel_ifs.o
 
-intel_ifs-objs			:= core.o load.o runtest.o
+intel_ifs-objs			:= core.o load.o runtest.o sysfs.o
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index fa4a6b13c1e2..317ed3225307 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -3,6 +3,7 @@
 
 #include <linux/module.h>
 #include <linux/kdev_t.h>
+#include <linux/semaphore.h>
 
 #include <asm/cpu_device_id.h>
 
@@ -64,9 +65,12 @@ static int __init ifs_init(void)
 		if (!(msrval & BIT(ifs_devices[i].data.integrity_cap_bit)))
 			continue;
 
+		ifs_devices[i].misc.groups = ifs_get_groups();
 		if (!misc_register(&ifs_devices[i].misc)) {
 			ndevices++;
+			down(&ifs_sem);
 			ifs_load_firmware(ifs_devices[i].misc.this_device);
+			up(&ifs_sem);
 		}
 	}
 
diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 1df796227ace..2ba03b21e2f8 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -116,5 +116,8 @@ void ifs_load_firmware(struct device *dev);
 int ifs_setup_wq(void);
 void ifs_destroy_wq(void);
 int do_core_test(int cpu, struct device *dev);
+const struct attribute_group **ifs_get_groups(void);
+
+extern struct semaphore ifs_sem;
 
 #endif
diff --git a/drivers/platform/x86/intel/ifs/sysfs.c b/drivers/platform/x86/intel/ifs/sysfs.c
new file mode 100644
index 000000000000..8f3b0fb5a423
--- /dev/null
+++ b/drivers/platform/x86/intel/ifs/sysfs.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2022 Intel Corporation. */
+
+#include <linux/cpu.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/semaphore.h>
+#include <linux/slab.h>
+
+#include "ifs.h"
+
+/*
+ * Protects against simultaneous tests on multiple cores, or
+ * reloading can file while a test is in progress
+ */
+DEFINE_SEMAPHORE(ifs_sem);
+
+/*
+ * The sysfs interface to check additional details of last test
+ * cat /sys/devices/system/platform/ifs/details
+ */
+static ssize_t details_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct ifs_data *ifsd = ifs_get_data(dev);
+
+	return sysfs_emit(buf, "%#llx\n", ifsd->scan_details);
+}
+
+static DEVICE_ATTR_RO(details);
+
+static const char * const status_msg[] = {
+	[SCAN_NOT_TESTED] = "untested",
+	[SCAN_TEST_PASS] = "pass",
+	[SCAN_TEST_FAIL] = "fail"
+};
+
+/*
+ * The sysfs interface to check the test status:
+ * To check the status of last test
+ * cat /sys/devices/platform/ifs/status
+ */
+static ssize_t status_show(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
+{
+	struct ifs_data *ifsd = ifs_get_data(dev);
+
+	return sysfs_emit(buf, "%s\n", status_msg[ifsd->status]);
+}
+
+static DEVICE_ATTR_RO(status);
+
+/*
+ * The sysfs interface for single core testing
+ * To start test, for example, cpu5
+ * echo 5 > /sys/devices/platform/ifs/run_test
+ * To check the result:
+ * cat /sys/devices/platform/ifs/result
+ * The sibling core gets tested at the same time.
+ */
+static ssize_t run_test_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct ifs_data *ifsd = ifs_get_data(dev);
+	unsigned int cpu;
+	int rc;
+
+	rc = kstrtouint(buf, 0, &cpu);
+	if (rc < 0 || cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	if (down_interruptible(&ifs_sem))
+		return -EINTR;
+
+	if (!ifsd->loaded)
+		rc = -EPERM;
+	else
+		rc = do_core_test(cpu, dev);
+
+	up(&ifs_sem);
+
+	return rc ? rc : count;
+}
+
+static DEVICE_ATTR_WO(run_test);
+
+/*
+ * Reload the IFS image. When user wants to install new IFS image
+ */
+static ssize_t reload_store(struct device *dev,
+			    struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	bool res;
+
+	if (kstrtobool(buf, &res))
+		return -EINVAL;
+	if (!res)
+		return count;
+
+	if (down_interruptible(&ifs_sem))
+		return -EINTR;
+
+	ifs_load_firmware(dev);
+
+	up(&ifs_sem);
+
+	return count;
+}
+
+static DEVICE_ATTR_WO(reload);
+
+/*
+ * Display currently loaded IFS image version.
+ */
+static ssize_t image_version_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct ifs_data *ifsd = ifs_get_data(dev);
+
+	if (!ifsd->loaded)
+		return sysfs_emit(buf, "%s\n", "none");
+	else
+		return sysfs_emit(buf, "%#x\n", ifsd->loaded_version);
+}
+
+static DEVICE_ATTR_RO(image_version);
+
+/* global scan sysfs attributes */
+static struct attribute *plat_ifs_attrs[] = {
+	&dev_attr_details.attr,
+	&dev_attr_status.attr,
+	&dev_attr_run_test.attr,
+	&dev_attr_reload.attr,
+	&dev_attr_image_version.attr,
+	NULL
+};
+
+ATTRIBUTE_GROUPS(plat_ifs);
+
+const struct attribute_group **ifs_get_groups(void)
+{
+	return plat_ifs_groups;
+}
-- 
2.35.1

