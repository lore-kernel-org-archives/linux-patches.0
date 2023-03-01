Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CADAA32
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 02:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677636075; x=1709172075;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VHHNnfW5fd3fWGPzletn/On5RWbJs2IQEjtgzueNm/I=;
  b=CR863AFlSfzzBpXt4ku5onPNcnc6xme8zqp5oeBClGrQTbZ5wShZs7Ui
   Wi8182TmCYkg4fRyz4fzgqYTJqHCGoUTn7qmRqUBOFXpR4mEYXg6mmpHc
   gZGRWX1sAz7MQ2ql60KGY9Soph1gFJLUhgnXVAx47ICVasJDYyrzWzW7W
   ZPjq+2SdJcCo7YBzopZ5xj4glNhnwhdhCiXAJCxuAfwecROt7GQpoZf7l
   G2s5lpuVjyNbwOGeGd0+2f/4b2V6GPqaZcIJmv5jHSnsyKFGrtbsJs6yj
   SgKX8IpLqK8OkhnsTOl10kT5AMZkYJmn9U4QMUjcnnIWPnf4+PFZw3aQc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="420558456"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="420558456"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 18:01:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="704639961"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="704639961"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 18:01:13 -0800
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
Subject: [PATCH v3 5/8] platform/x86/intel/ifs: Sysfs interface for Array BIST
Date: Tue, 28 Feb 2023 17:59:39 -0800
Message-Id: <20230301015942.462799-6-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230301015942.462799-1-jithu.joseph@intel.com>
References: <20230214234426.344960-1-jithu.joseph@intel.com>
 <20230301015942.462799-1-jithu.joseph@intel.com>
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
 drivers/platform/x86/intel/ifs/runtest.c | 10 +++++++++-
 drivers/platform/x86/intel/ifs/sysfs.c   | 10 +++++++++-
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index b8b956e29653..f31966e291df 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -250,5 +250,6 @@ extern bool *ifs_pkg_auth;
 int ifs_load_firmware(struct device *dev);
 int do_core_test(int cpu, struct device *dev);
 extern struct attribute *plat_ifs_attrs[];
+extern struct attribute *plat_ifs_array_attrs[];
 
 #endif
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 2237aaba7078..c74accedfc8d 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -22,6 +22,7 @@ static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
 MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
 
 ATTRIBUTE_GROUPS(plat_ifs);
+ATTRIBUTE_GROUPS(plat_ifs_array);
 
 bool *ifs_pkg_auth;
 
@@ -45,6 +46,7 @@ static struct ifs_device ifs_devices[] = {
 		.misc = {
 			.name = "intel_ifs_1",
 			.minor = MISC_DYNAMIC_MINOR,
+			.groups = plat_ifs_array_groups,
 		},
 	},
 };
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index 0bfd8fcdd7e8..969b3e0946d5 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -236,6 +236,7 @@ static void ifs_test_core(int cpu, struct device *dev)
  */
 int do_core_test(int cpu, struct device *dev)
 {
+	struct ifs_data *ifsd = ifs_get_data(dev);
 	int ret = 0;
 
 	/* Prevent CPUs from being taken offline during the scan test */
@@ -247,7 +248,14 @@ int do_core_test(int cpu, struct device *dev)
 		goto out;
 	}
 
-	ifs_test_core(cpu, dev);
+	switch (ifsd->ro_info->test_num) {
+	case IFS_TYPE_SAF:
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
index 2007d8054f04..88234798080a 100644
--- a/drivers/platform/x86/intel/ifs/sysfs.c
+++ b/drivers/platform/x86/intel/ifs/sysfs.c
@@ -75,7 +75,7 @@ static ssize_t run_test_store(struct device *dev,
 	if (down_interruptible(&ifs_sem))
 		return -EINTR;
 
-	if (!ifsd->loaded)
+	if (ifsd->ro_info->test_num != IFS_TYPE_ARRAY_BIST && !ifsd->loaded)
 		rc = -EPERM;
 	else
 		rc = do_core_test(cpu, dev);
@@ -149,3 +149,11 @@ struct attribute *plat_ifs_attrs[] = {
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

