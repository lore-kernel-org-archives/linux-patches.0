Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E381F10E6
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 00:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679445487; x=1710981487;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nqUH8s/50nhlaqxdRML8go3KMYy8jHe6DCaPoKvFnrM=;
  b=bnmDPDhhQGex/92o3V7Go/42+jD3LJF3GnVNiZ4JQ7cEvrXK3vRqIRPq
   NahlfzgEC7Zwo9Gy/3Vjv5w5K7BRyAHW6em11nVEvw4YYif/zP+cpBzPt
   0ZEIuXsi0DoO6plwN+Aj6yLxrARSezCmGS6zr6QFAbjPrusakV0zucknv
   WJk6tImsAQYJFSIq7upIYo0ZG0AcLKOd2gaybJ/M9RB9yoouOLWb0kjZI
   zGFohNuc8yrXEmn5H2aTqGqJvwlEu0kjCS4MiZBPeIvmCEOyf28Uhb1Qn
   slDhwczWeJayRA9RbU3IOzr6V+HEQ62NfxiTdy29btB2wYk/HBtBWN4eT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="322934934"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="322934934"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 17:38:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="675076054"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="675076054"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 17:38:05 -0700
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
Subject: [PATCH v4 6/9] platform/x86/intel/ifs: Sysfs interface for Array BIST
Date: Tue, 21 Mar 2023 17:33:56 -0700
Message-Id: <20230322003359.213046-7-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230322003359.213046-1-jithu.joseph@intel.com>
References: <20230301015942.462799-1-jithu.joseph@intel.com>
 <20230322003359.213046-1-jithu.joseph@intel.com>
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

Add sysfs interface for array BIST test, the testing support will
be added by subsequent patch.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h     |  1 +
 drivers/platform/x86/intel/ifs/core.c    |  2 ++
 drivers/platform/x86/intel/ifs/runtest.c | 13 ++++++++++++-
 drivers/platform/x86/intel/ifs/sysfs.c   | 14 +++++++++-----
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 14789b156299..a7d87fb4c412 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -256,5 +256,6 @@ extern bool *ifs_pkg_auth;
 int ifs_load_firmware(struct device *dev);
 int do_core_test(int cpu, struct device *dev);
 extern struct attribute *plat_ifs_attrs[];
+extern struct attribute *plat_ifs_array_attrs[];
 
 #endif
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 0067eee25f3c..306f886b52d2 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -22,6 +22,7 @@ static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
 MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
 
 ATTRIBUTE_GROUPS(plat_ifs);
+ATTRIBUTE_GROUPS(plat_ifs_array);
 
 bool *ifs_pkg_auth;
 
@@ -49,6 +50,7 @@ static struct ifs_device ifs_devices[] = {
 		.misc = {
 			.name = "intel_ifs_1",
 			.minor = MISC_DYNAMIC_MINOR,
+			.groups = plat_ifs_array_groups,
 		},
 	},
 };
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 0bfd8fcdd7e8..323752fe5034 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -236,6 +236,8 @@ static void ifs_test_core(int cpu, struct device *dev)
  */
 int do_core_test(int cpu, struct device *dev)
 {
+	const struct ifs_test_caps *test = ifs_get_test_caps(dev);
+	struct ifs_data *ifsd = ifs_get_data(dev);
 	int ret = 0;
 
 	/* Prevent CPUs from being taken offline during the scan test */
@@ -247,7 +249,16 @@ int do_core_test(int cpu, struct device *dev)
 		goto out;
 	}
 
-	ifs_test_core(cpu, dev);
+	switch (test->test_num) {
+	case IFS_TYPE_SAF:
+		if (!ifsd->loaded)
+			return -EPERM;
+		ifs_test_core(cpu, dev);
+		break;
+	case IFS_TYPE_ARRAY_BIST:
+	default:
+		return -EINVAL;
+	}
 out:
 	cpus_read_unlock();
 	return ret;
diff --git a/drivers/platform/x86/intel/ifs/sysfs.c b/drivers/platform/x86/intel/ifs/sysfs.c
index 2007d8054f04..d856d6b8fc03 100644
--- a/drivers/platform/x86/intel/ifs/sysfs.c
+++ b/drivers/platform/x86/intel/ifs/sysfs.c
@@ -64,7 +64,6 @@ static ssize_t run_test_store(struct device *dev,
 			      struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
-	struct ifs_data *ifsd = ifs_get_data(dev);
 	unsigned int cpu;
 	int rc;
 
@@ -75,10 +74,7 @@ static ssize_t run_test_store(struct device *dev,
 	if (down_interruptible(&ifs_sem))
 		return -EINTR;
 
-	if (!ifsd->loaded)
-		rc = -EPERM;
-	else
-		rc = do_core_test(cpu, dev);
+	rc = do_core_test(cpu, dev);
 
 	up(&ifs_sem);
 
@@ -149,3 +145,11 @@ struct attribute *plat_ifs_attrs[] = {
 	&dev_attr_image_version.attr,
 	NULL
 };
+
+/* global array sysfs attributes */
+struct attribute *plat_ifs_array_attrs[] = {
+	&dev_attr_details.attr,
+	&dev_attr_status.attr,
+	&dev_attr_run_test.attr,
+	NULL
+};
-- 
2.25.1

