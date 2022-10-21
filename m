Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEA46AA8
	for <patches@lists.linux.dev>; Fri, 21 Oct 2022 20:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666384557; x=1697920557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SAhT/BSzRTox0MsInHG55JZ6ufYQDkhSIvOxY17CTAQ=;
  b=bcfjX4ZPNkaorHhpixmHLHVODZa06hesQ+wT1uM8V43niziLhHPV4gBF
   rKC3Fsi6fim9G2lfkfHPJ0dQq0KUq7nnJIOHgV2uGK7z5KyCtFD1gyeoH
   VFrv8c8v3o6EaKPCUOIUCkSNPIkLpw6CjK+9+pYWYcn7O165+3X59KMn8
   t4PlRkFFSACsODxv86zO/6RnZhTEmyE3lQIkxnUgctAbPcHvau6MJgctS
   Z/m2VDR+f/hyou85MLnjAMbNTm1VEYCIliNzIeiZWnkwnp4X0Dz0Mps0w
   b73MiFw0BY4KdZ0TlmhEilQZKMEfzndkrMnzU1c2BzOzfctbLld/IsdRd
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="333675930"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="333675930"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:36 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="735701040"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="735701040"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:36 -0700
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
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com
Subject: [PATCH 12/14] platform/x86/intel/ifs: Add current_batch sysfs entry
Date: Fri, 21 Oct 2022 13:34:11 -0700
Message-Id: <20221021203413.1220137-13-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021203413.1220137-1-jithu.joseph@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Initial implementation assumed a single IFS test image file with a
fixed name ff-mm-ss.scan. (where ff, mm, ss refers to family, model
and stepping  of the core)

Subsequently, it became evident that supporting more than one
test image file is needed to provide more comprehensive
test coverage. (Test coverage in this scenario refers to testing
more transistors in the core to identify faults)

The other alternative of increasing the size of a single scan test image
file would not work as the  upper bound is limited by the size of memory
area reserved by BIOS for loading IFS test image.

Introduce "current_batch" file which accepts a number. Writing a
number to the current_batch file would load the test image file by name
ff-mm-ss-<xy>.scan, where <xy> is the number written to the
"current_batch" file in hex. Range check of the input is done to verify
it not greater than 0xff.

For e.g if the scan test image comprises of 6 files, they would be named
as show below:
	06-8f-06-01.scan
	06-8f-06-02.scan
	06-8f-06-03.scan
	06-8f-06-04.scan
	06-8f-06-05.scan
	06-8f-06-06.scan

And writing 3 to current_batch would result in loading 06-8f-06-03.scan
in the above e.g. The file can also be read to know the currently loaded
file.

And testing a system looks like:
	for each scan file
	do
		load the IFS test image file (write to the batch file)
		for each core
		do
			test the core with this set of tests
		done
	done

Qualify few error messages with the test image file suffix to
provide better context.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h     | 21 +++++++++----
 drivers/platform/x86/intel/ifs/core.c    |  1 +
 drivers/platform/x86/intel/ifs/load.c    | 14 +++++----
 drivers/platform/x86/intel/ifs/runtest.c | 10 ++++---
 drivers/platform/x86/intel/ifs/sysfs.c   | 38 ++++++++++++++++++++++++
 5 files changed, 70 insertions(+), 14 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index bb43fd65d2d2..7651558c218e 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -33,13 +33,23 @@
  * The driver loads the tests into memory reserved BIOS local to each CPU
  * socket in a two step process using writes to MSRs to first load the
  * SHA hashes for the test. Then the tests themselves. Status MSRs provide
- * feedback on the success/failure of these steps. When a new test file
- * is installed it can be loaded by writing to the driver reload file::
+ * feedback on the success/failure of these steps.
  *
- *   # echo 1 > /sys/devices/virtual/misc/intel_ifs_0/reload
+ * The test files are kept in a fixed location: /lib/firmware/intel/ifs_0/
+ * For e.g if there are 3 test files, they would be named in the following
+ * fashion:
+ * ff-mm-ss-01.scan
+ * ff-mm-ss-02.scan
+ * ff-mm-ss-03.scan
+ * (where ff refers to family, mm indicates model and ss indicates stepping)
  *
- * Similar to microcode, the current version of the scan tests is stored
- * in a fixed location: /lib/firmware/intel/ifs.0/family-model-stepping.scan
+ * A different testfile can be loaded by writing the numerical portion
+ * (e.g 1, 2 or 3 in the above scenario) into the curent_batch file.
+ * To load ff-mm-ss-02.scan, the following command can be used::
+ *
+ *   # echo 2 > /sys/devices/virtual/misc/intel_ifs_0/current_batch
+ *
+ * The above file can also be read to know the currently loaded image.
  *
  * Running tests
  * -------------
@@ -207,6 +217,7 @@ struct ifs_data {
 	int	status;
 	u64	scan_details;
 	int	cur_batch;
+	int	test_num;
 };
 
 struct ifs_work {
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 5fb7f655c291..1f040837e8eb 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -22,6 +22,7 @@ MODULE_DEVICE_TABLE(x86cpu, ifs_cpu_ids);
 static struct ifs_device ifs_device = {
 	.data = {
 		.integrity_cap_bit = MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT,
+		.test_num = 0,
 	},
 	.misc = {
 		.name = "intel_ifs_0",
diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index d300cf3ce5bd..abc217da3e55 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -225,17 +225,18 @@ static int ifs_image_sanity_check(struct device *dev, const struct microcode_hea
 
 /*
  * Load ifs image. Before loading ifs module, the ifs image must be located
- * in /lib/firmware/intel/ifs and named as {family/model/stepping}.{testname}.
+ * in /lib/firmware/intel/ifs_x/ and named as family-model-stepping-02x.{testname}.
  */
 int ifs_load_firmware(struct device *dev)
 {
 	struct ifs_data *ifsd = ifs_get_data(dev);
 	const struct firmware *fw;
-	char scan_path[32];
-	int ret;
+	char scan_path[64];
+	int ret = -EINVAL;
 
-	snprintf(scan_path, sizeof(scan_path), "intel/ifs/%02x-%02x-%02x.scan",
-		 boot_cpu_data.x86, boot_cpu_data.x86_model, boot_cpu_data.x86_stepping);
+	snprintf(scan_path, sizeof(scan_path), "intel/ifs_%d/%02x-%02x-%02x-%02x.scan",
+		 ifsd->test_num, boot_cpu_data.x86, boot_cpu_data.x86_model,
+		 boot_cpu_data.x86_stepping, ifsd->cur_batch);
 
 	ret = request_firmware_direct(&fw, scan_path, dev);
 	if (ret) {
@@ -251,6 +252,9 @@ int ifs_load_firmware(struct device *dev)
 	ifs_hash_ptr = (u64)(ifs_header_ptr + 1);
 
 	ret = scan_chunks_sanity_check(dev);
+	if (ret)
+		dev_err(dev, "Load failure for batch: %02x\n", ifsd->cur_batch);
+
 release:
 	release_firmware(fw);
 done:
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index b2ca2bb4501f..0bfd8fcdd7e8 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -78,14 +78,16 @@ static void message_not_tested(struct device *dev, int cpu, union ifs_status sta
 
 static void message_fail(struct device *dev, int cpu, union ifs_status status)
 {
+	struct ifs_data *ifsd = ifs_get_data(dev);
+
 	/*
 	 * control_error is set when the microcode runs into a problem
 	 * loading the image from the reserved BIOS memory, or it has
 	 * been corrupted. Reloading the image may fix this issue.
 	 */
 	if (status.control_error) {
-		dev_err(dev, "CPU(s) %*pbl: could not execute from loaded scan image\n",
-			cpumask_pr_args(cpu_smt_mask(cpu)));
+		dev_err(dev, "CPU(s) %*pbl: could not execute from loaded scan image. Batch: %02x version: 0x%x\n",
+			cpumask_pr_args(cpu_smt_mask(cpu)), ifsd->cur_batch, ifsd->loaded_version);
 	}
 
 	/*
@@ -96,8 +98,8 @@ static void message_fail(struct device *dev, int cpu, union ifs_status status)
 	 * the core being tested.
 	 */
 	if (status.signature_error) {
-		dev_err(dev, "CPU(s) %*pbl: test signature incorrect.\n",
-			cpumask_pr_args(cpu_smt_mask(cpu)));
+		dev_err(dev, "CPU(s) %*pbl: test signature incorrect. Batch: %02x version: 0x%x\n",
+			cpumask_pr_args(cpu_smt_mask(cpu)), ifsd->cur_batch, ifsd->loaded_version);
 	}
 }
 
diff --git a/drivers/platform/x86/intel/ifs/sysfs.c b/drivers/platform/x86/intel/ifs/sysfs.c
index e077910c5d28..e6e5fb2b7fc0 100644
--- a/drivers/platform/x86/intel/ifs/sysfs.c
+++ b/drivers/platform/x86/intel/ifs/sysfs.c
@@ -87,6 +87,43 @@ static ssize_t run_test_store(struct device *dev,
 
 static DEVICE_ATTR_WO(run_test);
 
+static ssize_t current_batch_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	struct ifs_data *ifsd = ifs_get_data(dev);
+	int cur_batch;
+	int rc;
+
+	rc = kstrtouint(buf, 0, &cur_batch);
+	if (rc < 0 || cur_batch > 0xff)
+		return -EINVAL;
+
+	if (down_interruptible(&ifs_sem))
+		return -EINTR;
+
+	ifsd->cur_batch = cur_batch;
+
+	rc = ifs_load_firmware(dev);
+
+	up(&ifs_sem);
+
+	return (rc == 0) ? count : rc;
+}
+
+static ssize_t current_batch_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct ifs_data *ifsd = ifs_get_data(dev);
+
+	if (!ifsd->loaded)
+		return sysfs_emit(buf, "%s\n", "none");
+	else
+		return sysfs_emit(buf, "0x%02x\n", ifsd->cur_batch);
+}
+
+static DEVICE_ATTR_RW(current_batch);
+
 /*
  * Display currently loaded IFS image version.
  */
@@ -108,6 +145,7 @@ static struct attribute *plat_ifs_attrs[] = {
 	&dev_attr_details.attr,
 	&dev_attr_status.attr,
 	&dev_attr_run_test.attr,
+	&dev_attr_current_batch.attr,
 	&dev_attr_image_version.attr,
 	NULL
 };
-- 
2.25.1

