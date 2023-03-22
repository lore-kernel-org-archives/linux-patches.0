Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA88D1118
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 00:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679445484; x=1710981484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BgdHjJC4QL7BVfBsochJmfeDk+Hnz+14Q2sFFqrIJxw=;
  b=oA1EgSgayLXtx++lVaKuvtUxuKJNzWQ5///4DbGHf/vWDxhO/T4znBGA
   Xm0osNiMCPvHQL/sjTHHWmn4tBSwVuhK80Sxn4TkAfZRyGcOjmv7csp7Q
   Z7rxdCCGPACOUYMcQ0XaQWiJb8hfzUr24MsTisHESB6hvFJ1dt8OJaE3l
   7zvSpkcwFLcz/2DvhAEelujYBdSwBc9O1b27c7b2Un6wo9/RVmmB1V7Si
   3cBodERlB5VABZz8IHqr8eFVceOPAspI2/pfOm4GMi6teELyY5hxe3s0l
   hGIIxDMr3CCw6Izbez66ze/BU8mVbo3x5E4014YZLPRh8HWW3yHkAM1JF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="322934896"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="322934896"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 17:38:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="675076031"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="675076031"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 17:38:02 -0700
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
Subject: [PATCH v4 2/9] platform/x86/intel/ifs: Reorganize driver data
Date: Tue, 21 Mar 2023 17:33:52 -0700
Message-Id: <20230322003359.213046-3-jithu.joseph@intel.com>
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

The struct holding device driver data contained both read only(ro)
and read write(rw) fields.

Separating ro fields from rw fields was recommended as
a preferable design pattern during review[1].

Group ro fields into a separate const struct. Associate it to
the miscdevice being registered by keeping its pointer in the
same container struct as the miscdevice.

Link: https://lore.kernel.org/lkml/Y+9H9otxLYPqMkUh@kroah.com/ [1]

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h  | 22 ++++++++++++++++------
 drivers/platform/x86/intel/ifs/core.c | 12 +++++++-----
 drivers/platform/x86/intel/ifs/load.c |  3 ++-
 3 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 221413b79281..d9c1a1f3e31d 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -197,9 +197,13 @@ union ifs_status {
 #define IFS_SW_TIMEOUT				0xFD
 #define IFS_SW_PARTIAL_COMPLETION		0xFE
 
+struct ifs_test_caps {
+	int	integrity_cap_bit;
+	int	test_num;
+};
+
 /**
  * struct ifs_data - attributes related to intel IFS driver
- * @integrity_cap_bit: MSR_INTEGRITY_CAPS bit enumerating this test
  * @loaded_version: stores the currently loaded ifs image version.
  * @loaded: If a valid test binary has been loaded into the memory
  * @loading_error: Error occurred on another CPU while loading image
@@ -207,10 +211,8 @@ union ifs_status {
  * @status: it holds simple status pass/fail/untested
  * @scan_details: opaque scan status code from h/w
  * @cur_batch: number indicating the currently loaded test file
- * @test_num: number indicating the test type
  */
 struct ifs_data {
-	int	integrity_cap_bit;
 	int	loaded_version;
 	bool	loaded;
 	bool	loading_error;
@@ -218,7 +220,6 @@ struct ifs_data {
 	int	status;
 	u64	scan_details;
 	u32	cur_batch;
-	int	test_num;
 };
 
 struct ifs_work {
@@ -227,7 +228,8 @@ struct ifs_work {
 };
 
 struct ifs_device {
-	struct ifs_data data;
+	const struct ifs_test_caps *test_caps;
+	struct ifs_data rw_data;
 	struct miscdevice misc;
 };
 
@@ -236,7 +238,15 @@ static inline struct ifs_data *ifs_get_data(struct device *dev)
 	struct miscdevice *m = dev_get_drvdata(dev);
 	struct ifs_device *d = container_of(m, struct ifs_device, misc);
 
-	return &d->data;
+	return &d->rw_data;
+}
+
+static inline const struct ifs_test_caps *ifs_get_test_caps(struct device *dev)
+{
+	struct miscdevice *m = dev_get_drvdata(dev);
+	struct ifs_device *d = container_of(m, struct ifs_device, misc);
+
+	return d->test_caps;
 }
 
 extern bool *ifs_pkg_auth;
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 3176d94b1fe5..e2bf728eefdf 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -22,11 +22,13 @@ MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
 
 bool *ifs_pkg_auth;
 
+static const struct ifs_test_caps scan_test = {
+	.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
+	.test_num = 0,
+};
+
 static struct ifs_device ifs_device = {
-	.data = {
-		.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
-		.test_num = 0,
-	},
+	.test_caps = &scan_test,
 	.misc = {
 		.name = "intel_ifs_0",
 		.nodename = "intel_ifs/0",
@@ -55,7 +57,7 @@ static int __init ifs_init(void)
 
 	ifs_device.misc.groups = ifs_get_groups();
 
-	if (!(msrval & BIT(ifs_device.data.integrity_cap_bit)))
+	if (!(msrval & BIT(ifs_device.test_caps->integrity_cap_bit)))
 		return -ENODEV;
 
 	ifs_pkg_auth = kmalloc_array(topology_max_packages(), sizeof(bool), GFP_KERNEL);
diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index 74a50e99cacd..61dffb4c8a1d 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -257,13 +257,14 @@ static int image_sanity_check(struct device *dev, const struct microcode_header_
  */
 int ifs_load_firmware(struct device *dev)
 {
+	const struct ifs_test_caps *test = ifs_get_test_caps(dev);
 	struct ifs_data *ifsd = ifs_get_data(dev);
 	const struct firmware *fw;
 	char scan_path[64];
 	int ret = -EINVAL;
 
 	snprintf(scan_path, sizeof(scan_path), "intel/ifs_%d/%02x-%02x-%02x-%02x.scan",
-		 ifsd->test_num, boot_cpu_data.x86, boot_cpu_data.x86_model,
+		 test->test_num, boot_cpu_data.x86, boot_cpu_data.x86_model,
 		 boot_cpu_data.x86_stepping, ifsd->cur_batch);
 
 	ret = request_firmware_direct(&fw, scan_path, dev);
-- 
2.25.1

