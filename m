Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4B315A8
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 00:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679445487; x=1710981487;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5aYESLOoWjLS/ePaQj9XJXoxw/ffemCQIpasdHuVrYQ=;
  b=FwZQJGhJXKg1XyCgOD3kHeIM4lXUgB68IYQKjcfJCW+RWnC2VXVEAga8
   W/qaAfG18Nbq5jgKNwPt7m5rP1hFdGYsPlysKxJHWvVJoJXr/X7+EkMwu
   2+9tbg622yE3qU8RSbPu73alBlpLKZN2peA8T/2GIG4Ux1Pm06bB6Y1YK
   u9DmLZ/AFVnlpnLreEamiCQ+9aG9hlZPqU+kexL2I5td/5LvqDQdfryHb
   BWIxdzTz+RcV+i/LuedwR6IM6CrokLgHm/OfGg44HIInBP1oMfA662tdT
   E1bM2bRPveBzOqU8i1rcZHRQj87asDvjWvlRz+dQGfp5SGwq4IhSkjNbo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="322934924"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="322934924"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 17:38:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="675076049"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="675076049"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 17:38:04 -0700
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
Subject: [PATCH v4 5/9] platform/x86/intel/ifs: Introduce Array Scan test to IFS
Date: Tue, 21 Mar 2023 17:33:55 -0700
Message-Id: <20230322003359.213046-6-jithu.joseph@intel.com>
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

Array BIST is a new type of core test introduced under the Intel Infield
Scan (IFS) suite of tests.

Emerald Rapids (EMR) is the first CPU to support Array BIST.
Array BIST performs tests on some portions of the core logic such as
caches and register files. These are different portions of the silicon
compared to the parts tested by the first test type
i.e Scan at Field (SAF).

Make changes in the device driver init flow to register this new test
type with the device driver framework. Each test will have its own
sysfs directory (intel_ifs_0 , intel_ifs_1) under misc hierarchy to
accommodate for the differences in test type and how they are initiated.

Upcoming patches will add actual support.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h  |  3 ++
 drivers/platform/x86/intel/ifs/core.c | 65 +++++++++++++++++++--------
 2 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 55bcc70c2966..14789b156299 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -137,6 +137,9 @@
 #define SCAN_TEST_PASS				1
 #define SCAN_TEST_FAIL				2
 
+#define IFS_TYPE_SAF			0
+#define IFS_TYPE_ARRAY_BIST		1
+
 /* MSR_SCAN_HASHES_STATUS bit fields */
 union ifs_scan_hashes_status {
 	u64	data;
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index f272644617a3..0067eee25f3c 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -16,6 +16,7 @@
 
 static const struct x86_cpu_id ifs_cpu_ids[] __initconst = {
 	X86_MATCH(SAPPHIRERAPIDS_X),
+	X86_MATCH(EMERALDRAPIDS_X),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
@@ -26,23 +27,50 @@ bool *ifs_pkg_auth;
 
 static const struct ifs_test_caps scan_test = {
 	.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
-	.test_num = 0,
+	.test_num = IFS_TYPE_SAF,
 };
 
-static struct ifs_device ifs_device = {
-	.test_caps = &scan_test,
-	.misc = {
-		.name = "intel_ifs_0",
-		.minor = MISC_DYNAMIC_MINOR,
-		.groups = plat_ifs_groups,
+static const struct ifs_test_caps array_test = {
+	.integrity_cap_bit = MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT,
+	.test_num = IFS_TYPE_ARRAY_BIST,
+};
+
+static struct ifs_device ifs_devices[] = {
+	[IFS_TYPE_SAF] = {
+		.test_caps = &scan_test,
+		.misc = {
+			.name = "intel_ifs_0",
+			.minor = MISC_DYNAMIC_MINOR,
+			.groups = plat_ifs_groups,
+		},
+	},
+	[IFS_TYPE_ARRAY_BIST] = {
+		.test_caps = &array_test,
+		.misc = {
+			.name = "intel_ifs_1",
+			.minor = MISC_DYNAMIC_MINOR,
+		},
 	},
 };
 
+#define IFS_NUMTESTS ARRAY_SIZE(ifs_devices)
+
+static void ifs_cleanup(void)
+{
+	int i;
+
+	for (i = 0; i < IFS_NUMTESTS; i++) {
+		if (ifs_devices[i].misc.this_device)
+			misc_deregister(&ifs_devices[i].misc);
+	}
+	kfree(ifs_pkg_auth);
+}
+
 static int __init ifs_init(void)
 {
 	const struct x86_cpu_id *m;
 	u64 msrval;
-	int ret;
+	int i, ret;
 
 	m = x86_match_cpu(ifs_cpu_ids);
 	if (!m)
@@ -57,26 +85,27 @@ static int __init ifs_init(void)
 	if (rdmsrl_safe(MSR_INTEGRITY_CAPS, &msrval))
 		return -ENODEV;
 
-	if (!(msrval & BIT(ifs_device.test_caps->integrity_cap_bit)))
-		return -ENODEV;
-
 	ifs_pkg_auth = kmalloc_array(topology_max_packages(), sizeof(bool), GFP_KERNEL);
 	if (!ifs_pkg_auth)
 		return -ENOMEM;
 
-	ret = misc_register(&ifs_device.misc);
-	if (ret) {
-		kfree(ifs_pkg_auth);
-		return ret;
+	for (i = 0; i < IFS_NUMTESTS; i++) {
+		if (!(msrval & BIT(ifs_devices[i].test_caps->integrity_cap_bit)))
+			continue;
+		ret = misc_register(&ifs_devices[i].misc);
+		if (ret)
+			goto err_exit;
 	}
-
 	return 0;
+
+err_exit:
+	ifs_cleanup();
+	return ret;
 }
 
 static void __exit ifs_exit(void)
 {
-	misc_deregister(&ifs_device.misc);
-	kfree(ifs_pkg_auth);
+	ifs_cleanup();
 }
 
 module_init(ifs_init);
-- 
2.25.1

