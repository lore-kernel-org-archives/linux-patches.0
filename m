Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E5A1367
	for <patches@lists.linux.dev>; Thu, 28 Apr 2022 15:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651160350; x=1682696350;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rSfuTmJhr4/0Y4U/3KMAilCbF6SV+1+lcHUVM2PCHjA=;
  b=Xs/sntzRyKXPonslsjuxd0G5WaIaCeunlEr1Kd1xcOZZaY2ZvK4C0DGd
   ucqWTnfn/PSgx4kC/1D0qa+ZcuqMB0GIxVH9PsEyyOIf2jaHRAYjik1qq
   XY2pMuY/iURfpqaP7T5Kqdxk1D1DMyjd+D4jUHs5cJJ0j55Aw14M62q9i
   mN00a5F5UVLwiXbSlJi3z/kX2fdYOtxgX5OOC95miYoF9ZPwafusng47B
   vu8igVRUDMG3Ug08qC/5otKwM73m7KJbymfmn+r52qwrdJjkIeg67q+rj
   7rsSgfXp3HmYy7eJMetNX+A0Hi2kNu42JnKGf8qF9eBa+xDdCDUqUieYh
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="352759585"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="352759585"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 08:39:02 -0700
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="559734340"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 08:39:02 -0700
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
Subject: [PATCH v5 06/10] platform/x86/intel/ifs: Authenticate and copy to secured memory
Date: Thu, 28 Apr 2022 08:38:45 -0700
Message-Id: <20220428153849.295779-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220428153849.295779-1-tony.luck@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jithu Joseph <jithu.joseph@intel.com>

The IFS image contains hashes that will be used to authenticate the ifs
test chunks. First, use WRMSR to copy the hashes and enumerate the number
of test chunks, chunk size and the maximum number of cores that can run
scan test simultaneously.

Next, use WRMSR to authenticate each and every scan test chunk which is
also stored in the IFS image. The CPU will check if the test chunks match
the hashes, otherwise failure is indicated to system software. If the test
chunk is authenticated, it is automatically copied to secured memory.

The ifs hash copy and authentication only needs to be done on the first
logical cpu of each socket.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h  |  47 +++++++
 drivers/platform/x86/intel/ifs/load.c | 170 +++++++++++++++++++++++++-
 2 files changed, 215 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 9a0f8e2077e2..d985b4a50f46 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -7,12 +7,51 @@
 #include <linux/device.h>
 #include <linux/miscdevice.h>
 
+#define MSR_COPY_SCAN_HASHES			0x000002c2
+#define MSR_SCAN_HASHES_STATUS			0x000002c3
+#define MSR_AUTHENTICATE_AND_COPY_CHUNK		0x000002c4
+#define MSR_CHUNKS_AUTHENTICATION_STATUS	0x000002c5
+
+/* MSR_SCAN_HASHES_STATUS bit fields */
+union ifs_scan_hashes_status {
+	u64	data;
+	struct {
+		u32	chunk_size	:16;
+		u32	num_chunks	:8;
+		u32	rsvd1		:8;
+		u32	error_code	:8;
+		u32	rsvd2		:11;
+		u32	max_core_limit	:12;
+		u32	valid		:1;
+	};
+};
+
+/* MSR_CHUNKS_AUTH_STATUS bit fields */
+union ifs_chunks_auth_status {
+	u64	data;
+	struct {
+		u32	valid_chunks	:8;
+		u32	total_chunks	:8;
+		u32	rsvd1		:16;
+		u32	error_code	:8;
+		u32	rsvd2		:24;
+	};
+};
+
 /**
  * struct ifs_data - attributes related to intel IFS driver
  * @integrity_cap_bit - MSR_INTEGRITY_CAPS bit enumerating this test
+ * @loaded_version: stores the currently loaded ifs image version.
+ * @loaded: If a valid test binary has been loaded into the memory
+ * @loading_error: Error occurred on another CPU while loading image
+ * @valid_chunks: number of chunks which could be validated.
  */
 struct ifs_data {
 	int integrity_cap_bit;
+	int loaded_version;
+	bool loaded;
+	bool loading_error;
+	int valid_chunks;
 };
 
 struct ifs_device {
@@ -20,6 +59,14 @@ struct ifs_device {
 	struct miscdevice misc;
 };
 
+static inline struct ifs_data *ifs_get_data(struct device *dev)
+{
+	struct miscdevice *m = dev_get_drvdata(dev);
+	struct ifs_device *d = container_of(m, struct ifs_device, misc);
+
+	return &d->data;
+}
+
 void ifs_load_firmware(struct device *dev);
 
 #endif
diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index aece78d1c757..46a9b78aa195 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -3,10 +3,166 @@
 
 #include <linux/firmware.h>
 #include <asm/cpu.h>
+#include <linux/slab.h>
 #include <asm/microcode_intel.h>
 
 #include "ifs.h"
 
+struct ifs_header {
+	u32 header_ver;
+	u32 blob_revision;
+	u32 date;
+	u32 processor_sig;
+	u32 check_sum;
+	u32 loader_rev;
+	u32 processor_flags;
+	u32 metadata_size;
+	u32 total_size;
+	u32 fusa_info;
+	u64 reserved;
+};
+
+#define IFS_HEADER_SIZE	(sizeof(struct ifs_header))
+static struct ifs_header *ifs_header_ptr;	/* pointer to the ifs image header */
+static u64 ifs_hash_ptr;			/* Address of ifs metadata (hash) */
+static u64 ifs_test_image_ptr;			/* 256B aligned address of test pattern */
+
+static const char * const scan_hash_status[] = {
+	[0] = "No error reported",
+	[1] = "Attempt to copy scan hashes when copy already in progress",
+	[2] = "Secure Memory not set up correctly",
+	[3] = "FuSaInfo.ProgramID does not match or ff-mm-ss does not match",
+	[4] = "Reserved",
+	[5] = "Integrity check failed",
+	[6] = "Scan reload or test is in progress"
+};
+
+static const char * const scan_authentication_status[] = {
+	[0] = "No error reported",
+	[1] = "Attempt to authenticate a chunk which is already marked as authentic",
+	[2] = "Chunk authentication error. The hash of chunk did not match expected value"
+};
+
+/*
+ * To copy scan hashes and authenticate test chunks, the initiating cpu must point
+ * to the EDX:EAX to the test image in linear address.
+ * Run wrmsr(MSR_COPY_SCAN_HASHES) for scan hash copy and run wrmsr(MSR_AUTHENTICATE_AND_COPY_CHUNK)
+ * for scan hash copy and test chunk authentication.
+ */
+static void copy_hashes_authenticate_chunks(void *arg)
+{
+	union ifs_scan_hashes_status hashes_status;
+	union ifs_chunks_auth_status chunk_status;
+	int i, num_chunks, chunk_size;
+	struct device *dev = arg;
+	struct ifs_data *ifsd;
+	u64 linear_addr, base;
+	u32 err_code;
+
+	ifsd = ifs_get_data(dev);
+	/* run scan hash copy */
+	wrmsrl(MSR_COPY_SCAN_HASHES, ifs_hash_ptr);
+	rdmsrl(MSR_SCAN_HASHES_STATUS, hashes_status.data);
+
+	/* enumerate the scan image information */
+	num_chunks = hashes_status.num_chunks;
+	chunk_size = hashes_status.chunk_size * 1024;
+	err_code = hashes_status.error_code;
+
+	if (!hashes_status.valid) {
+		ifsd->loading_error = true;
+		if (err_code >= ARRAY_SIZE(scan_hash_status)) {
+			dev_err(dev, "invalid error code 0x%x for hash copy\n", err_code);
+			return;
+		}
+		dev_err(dev, "Hash copy error : %s", scan_hash_status[err_code]);
+		return;
+	}
+
+	/* base linear address to the scan data */
+	base = ifs_test_image_ptr;
+
+	/* scan data authentication and copy chunks to secured memory */
+	for (i = 0; i < num_chunks; i++) {
+		linear_addr = base + i * chunk_size;
+		linear_addr |= i;
+
+		wrmsrl(MSR_AUTHENTICATE_AND_COPY_CHUNK, linear_addr);
+		rdmsrl(MSR_CHUNKS_AUTHENTICATION_STATUS, chunk_status.data);
+
+		ifsd->valid_chunks = chunk_status.valid_chunks;
+		err_code = chunk_status.error_code;
+
+		if (err_code) {
+			ifsd->loading_error = true;
+			if (err_code >= ARRAY_SIZE(scan_authentication_status)) {
+				dev_err(dev,
+					"invalid error code 0x%x for authentication\n", err_code);
+				return;
+			}
+			dev_err(dev, "Chunk authentication error %s\n",
+				scan_authentication_status[err_code]);
+			return;
+		}
+	}
+}
+
+/*
+ * IFS requires scan chunks authenticated per each socket in the platform.
+ * Once the test chunk is authenticated, it is automatically copied to secured memory
+ * and proceed the authentication for the next chunk.
+ */
+static int scan_chunks_sanity_check(struct device *dev)
+{
+	int metadata_size, curr_pkg, cpu, ret = -ENOMEM;
+	struct ifs_data *ifsd = ifs_get_data(dev);
+	bool *package_authenticated;
+	char *test_ptr;
+
+	package_authenticated = kcalloc(topology_max_packages(), sizeof(bool), GFP_KERNEL);
+	if (!package_authenticated)
+		return ret;
+
+	metadata_size = ifs_header_ptr->metadata_size;
+
+	/* Spec says that if the Meta Data Size = 0 then it should be treated as 2000 */
+	if (metadata_size == 0)
+		metadata_size = 2000;
+
+	/* Scan chunk start must be 256 byte aligned */
+	if ((metadata_size + IFS_HEADER_SIZE) % 256) {
+		dev_err(dev, "Scan pattern offset within the binary is not 256 byte aligned\n");
+		return -EINVAL;
+	}
+
+	test_ptr = (char *)ifs_header_ptr + IFS_HEADER_SIZE + metadata_size;
+	ifsd->loading_error = false;
+
+	ifs_test_image_ptr = (u64)test_ptr;
+	ifsd->loaded_version = ifs_header_ptr->blob_revision;
+
+	/* copy the scan hash and authenticate per package */
+	cpus_read_lock();
+	for_each_online_cpu(cpu) {
+		curr_pkg = topology_physical_package_id(cpu);
+		if (package_authenticated[curr_pkg])
+			continue;
+		package_authenticated[curr_pkg] = 1;
+		ret = smp_call_function_single(cpu, copy_hashes_authenticate_chunks,
+					       dev, 1);
+		if (ret || ifsd->loading_error) {
+			ret = ifsd->loading_error ? -ENOMEM : ret;
+			goto out;
+		}
+	}
+
+out:
+	cpus_read_unlock();
+	kfree(package_authenticated);
+
+	return ret;
+}
+
 static int ifs_sanity_check(struct device *dev,
 			    const struct microcode_header_intel *mc_header)
 {
@@ -76,6 +232,7 @@ static bool ifs_image_sanity_check(struct device *dev, const struct microcode_he
  */
 void ifs_load_firmware(struct device *dev)
 {
+	struct ifs_data *ifsd = ifs_get_data(dev);
 	const struct firmware *fw;
 	char scan_path[32];
 	int ret;
@@ -86,11 +243,20 @@ void ifs_load_firmware(struct device *dev)
 	ret = request_firmware_direct(&fw, scan_path, dev);
 	if (ret) {
 		dev_err(dev, "ifs file %s load failed\n", scan_path);
-		return;
+		goto done;
 	}
 
-	if (!ifs_image_sanity_check(dev, (struct microcode_header_intel *)fw->data))
+	if (!ifs_image_sanity_check(dev, (struct microcode_header_intel *)fw->data)) {
 		dev_err(dev, "ifs header sanity check failed\n");
+		goto release;
+	}
+
+	ifs_header_ptr = (struct ifs_header *)fw->data;
+	ifs_hash_ptr = (u64)(ifs_header_ptr + 1);
 
+	ret = scan_chunks_sanity_check(dev);
+release:
 	release_firmware(fw);
+done:
+	ifsd->loaded = (ret == 0);
 }
-- 
2.35.1

