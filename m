Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5778AD29
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 23:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675208699; x=1706744699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f9j1tac3fXJ7zWWtJKdbIWJZZUO6h9XAWqOwYcAGIU0=;
  b=YFeVwNw7ts7a3dQ1kNfjYqw01eVDZGxy09cpmX4+URghoiwLfjTKXCbD
   UfQulYtHpFQ4Kp6vVm8VYFDkeN2VD7UJm9NwlDmjBymce4MU4kQSWa1Xw
   0Ml/Bz0LotlCV2s1V2cchOvzuRomcfN+N+RPxcLvkktxGVVbUg38XEtf5
   6u3K4IAmM1Vk5Ghe3ha9vrJzv7K1Ed9rYeUm2BTuTFvTLA/Mec0zASFDA
   yQFS/3OaO6CFq07toAyzm/yd1wXdrDZO87YVtVlYP7eKMDw9GqaHH/51x
   Ay0bck366Z+obEDO/pRk/srmTa32WKhSYiAeorVeb2DkGERl1MSGa03Lo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="390360425"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="390360425"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 15:44:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="773192030"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="773192030"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 15:44:55 -0800
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	gregkh@linuxfoundation.org,
	rostedt@goodmis.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com,
	sohil.mehta@intel.com
Subject: [PATCH 3/5] platform/x86/intel/ifs: Sysfs interface for Array BIST
Date: Tue, 31 Jan 2023 15:43:00 -0800
Message-Id: <20230131234302.3997223-4-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230131234302.3997223-1-jithu.joseph@intel.com>
References: <20230131234302.3997223-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The interface to trigger Array BIST test and obtain its result
is similar to the existing scan test. The only notable
difference is that, Array BIST doesn't require any test content
to be loaded. So binary load related options are not needed for
this test.

Add sysfs interface array BIST test, the testing support will
be added by subsequent patch.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h     |  1 +
 drivers/platform/x86/intel/ifs/core.c    | 18 +++++++++++++-----
 drivers/platform/x86/intel/ifs/runtest.c | 11 ++++++++++-
 drivers/platform/x86/intel/ifs/sysfs.c   | 17 ++++++++++++++++-
 4 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 2cef88a88aa9..07423bc4e368 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -249,5 +249,6 @@ static inline struct ifs_data *ifs_get_data(struct device *dev)
 int ifs_load_firmware(struct device *dev);
 int do_core_test(int cpu, struct device *dev);
 const struct attribute_group **ifs_get_groups(void);
+const struct attribute_group **ifs_get_array_groups(void);
 
 #endif
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index ab234620ef4c..2b7a49fd473d 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -25,6 +25,7 @@ static struct ifs_device ifs_devices[] = {
 	[IFS_SAF] = {
 		.data = {
 			.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
+			.pkg_auth = NULL,
 			.test_num = IFS_SAF,
 		},
 		.misc = {
@@ -36,6 +37,7 @@ static struct ifs_device ifs_devices[] = {
 	[IFS_ARRAY] = {
 		.data = {
 			.integrity_cap_bit = MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT,
+			.pkg_auth = NULL,
 			.test_num = IFS_ARRAY,
 		},
 		.misc = {
@@ -72,11 +74,17 @@ static int __init ifs_init(void)
 		if (!(msrval & BIT(ifs_devices[i].data.integrity_cap_bit)))
 			continue;
 
-		ifs_devices[i].data.pkg_auth = kmalloc_array(topology_max_packages(),
-							     sizeof(bool), GFP_KERNEL);
-		if (!ifs_devices[i].data.pkg_auth)
-			continue;
-		ifs_devices[i].misc.groups = ifs_get_groups();
+		switch (ifs_devices[i].data.test_num) {
+		case IFS_SAF:
+			ifs_devices[i].data.pkg_auth = kmalloc_array(topology_max_packages(),
+								     sizeof(bool), GFP_KERNEL);
+			if (!ifs_devices[i].data.pkg_auth)
+				continue;
+			ifs_devices[i].misc.groups = ifs_get_groups();
+			break;
+		case IFS_ARRAY:
+			ifs_devices[i].misc.groups = ifs_get_array_groups();
+		}
 
 		if (misc_register(&ifs_devices[i].misc))
 			kfree(ifs_devices[i].data.pkg_auth);
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 0bfd8fcdd7e8..65e08af70994 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -236,6 +236,7 @@ static void ifs_test_core(int cpu, struct device *dev)
  */
 int do_core_test(int cpu, struct device *dev)
 {
+	struct ifs_data *ifsd = ifs_get_data(dev);
 	int ret = 0;
 
 	/* Prevent CPUs from being taken offline during the scan test */
@@ -247,7 +248,15 @@ int do_core_test(int cpu, struct device *dev)
 		goto out;
 	}
 
-	ifs_test_core(cpu, dev);
+	switch (ifsd->test_num) {
+	case IFS_SAF:
+		ifs_test_core(cpu, dev);
+		break;
+	case IFS_ARRAY:
+	default:
+		return -EINVAL;
+	}
+
 out:
 	cpus_read_unlock();
 	return ret;
diff --git a/drivers/platform/x86/intel/ifs/sysfs.c b/drivers/platform/x86/intel/ifs/sysfs.c
index ee636a76b083..7cf32184ce6a 100644
--- a/drivers/platform/x86/intel/ifs/sysfs.c
+++ b/drivers/platform/x86/intel/ifs/sysfs.c
@@ -75,7 +75,7 @@ static ssize_t run_test_store(struct device *dev,
 	if (down_interruptible(&ifs_sem))
 		return -EINTR;
 
-	if (!ifsd->loaded)
+	if (ifsd->test_num != IFS_ARRAY && !ifsd->loaded)
 		rc = -EPERM;
 	else
 		rc = do_core_test(cpu, dev);
@@ -156,3 +156,18 @@ const struct attribute_group **ifs_get_groups(void)
 {
 	return plat_ifs_groups;
 }
+
+/* global array sysfs attributes */
+static struct attribute *plat_ifs_array_attrs[] = {
+	&dev_attr_details.attr,
+	&dev_attr_status.attr,
+	&dev_attr_run_test.attr,
+	NULL
+};
+
+ATTRIBUTE_GROUPS(plat_ifs_array);
+
+const struct attribute_group **ifs_get_array_groups(void)
+{
+	return plat_ifs_array_groups;
+}
-- 
2.25.1

