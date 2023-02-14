Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F33ACB9F
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 23:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676418357; x=1707954357;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FZhdytTplH8hafL4/6++wppoH2ryGQJ9fu1jV9238GY=;
  b=ktRUenTNueRRcYQ5/iFqASbJXm71O+LhtJKgz1teUnRq/EgYKNSfw0Bi
   yTtglJWsxKmvWKpg9Ql3xfhwakW3wPlgFsqv72Ngu6lgFQkwFIZNcqNmR
   KkBBRYBuu0sQpRXGCL4NKlPSUcnYkF6JJZUSR46jP0+oorZ/BT8JEBt1x
   I26Ewy2OscckJm3FaL7tp5bsjKEB5k/DT2x5yJ8s+tLV7kcC5sLp+Jm+y
   pAXvqOVyu6G2gU/tvrzZ8SdXrvzFJTqJwjz2GYoJqrx/NMjPNsVzSf2DB
   JE+NyIyxFqho5Yubmbbqrw/KPVwi37mwAhIWQ8PDuYolo/Mwl1g9gEPgI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="417523011"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="417523011"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 15:45:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="669391014"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="669391014"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 15:45:55 -0800
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
Subject: [PATCH v2 3/7] platform/x86/intel/ifs: Sysfs interface for Array BIST
Date: Tue, 14 Feb 2023 15:44:22 -0800
Message-Id: <20230214234426.344960-4-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230214234426.344960-1-jithu.joseph@intel.com>
References: <20230131234302.3997223-1-jithu.joseph@intel.com>
 <20230214234426.344960-1-jithu.joseph@intel.com>
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
 drivers/platform/x86/intel/ifs/core.c    | 21 ++++++++++++++++-----
 drivers/platform/x86/intel/ifs/runtest.c | 11 ++++++++++-
 drivers/platform/x86/intel/ifs/sysfs.c   | 10 +++++++++-
 4 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 2cef88a88aa9..a0cb2696c1d9 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -249,5 +249,6 @@ static inline struct ifs_data *ifs_get_data(struct device *dev)
 int ifs_load_firmware(struct device *dev);
 int do_core_test(int cpu, struct device *dev);
 const struct attribute_group **ifs_get_groups(void);
+extern struct attribute *plat_ifs_array_attrs[];
 
 #endif
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index ab234620ef4c..d0d4e1fb62f6 100644
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
@@ -48,6 +50,8 @@ static struct ifs_device ifs_devices[] = {
 
 #define IFS_NUMTESTS ARRAY_SIZE(ifs_devices)
 
+ATTRIBUTE_GROUPS(plat_ifs_array);
+
 static int __init ifs_init(void)
 {
 	const struct x86_cpu_id *m;
@@ -72,11 +76,18 @@ static int __init ifs_init(void)
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
+			ifs_devices[i].misc.groups = plat_ifs_array_groups;
+			break;
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
index ee636a76b083..3e205fead7ab 100644
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
@@ -156,3 +156,11 @@ const struct attribute_group **ifs_get_groups(void)
 {
 	return plat_ifs_groups;
 }
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

