Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F867B
	for <patches@lists.linux.dev>; Fri, 21 Oct 2022 20:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666384556; x=1697920556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4GA/zUmUAfO1cKUlriGt7rRQ7snnRf1VH62DtYVeQqU=;
  b=k+6jw503/lGr7cazh17wk7QsYfiElFYKQJdv569G0byeZ62O58GD+EFT
   CxNcbInKSqFD7Ux0w7hUVowCbuumGEocfLvqrffxcXLmY1ofd9QiF1tFn
   qbTp+seuy37nXx+XQ7aalRmzFjFue6VKWarz5HoFLtooE9nwWCR38wqZ6
   h6c5VPqvCpBsTn2pq/DW1LfvzwzinTPM13Iq3gpkUr0FvN3V6qIw3E6dG
   9oxfhQAnIM46slkfitI7BfDxIHQrsJIwOrLSsXphLe5ZVf5YnlkYNcRmK
   WzIvRurtV0G1Eh3sL7ZdiA+2Zhz15KutVUwQoTumOgT8HZJoZrxwgqH4d
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="333675921"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="333675921"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:36 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="735701029"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="735701029"
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
Subject: [PATCH 10/14] platform/x86/intel/ifs: Add metadata validation
Date: Fri, 21 Oct 2022 13:34:09 -0700
Message-Id: <20221021203413.1220137-11-jithu.joseph@intel.com>
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

The data portion of IFS test image file contains a meta-data
structure in addition to test data and hashes.

Introduce the layout of this meta_data structure and validate
the sanity of certain fields of the new-image before loading.

Tweak references to IFS test image chunks to reflect the updated
layout of the test image.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/ifs.h  |  2 +
 drivers/platform/x86/intel/ifs/load.c | 54 +++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index be37512535f2..bb43fd65d2d2 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -196,6 +196,7 @@ union ifs_status {
  * @valid_chunks: number of chunks which could be validated.
  * @status: it holds simple status pass/fail/untested
  * @scan_details: opaque scan status code from h/w
+ * @cur_batch: suffix indicating the currently loaded test file
  */
 struct ifs_data {
 	int	integrity_cap_bit;
@@ -205,6 +206,7 @@ struct ifs_data {
 	int	valid_chunks;
 	int	status;
 	u64	scan_details;
+	int	cur_batch;
 };
 
 struct ifs_work {
diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index 3cb13a7aa74b..d300cf3ce5bd 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -8,8 +8,24 @@
 
 #include "ifs.h"
 
+struct meta_data {
+	unsigned int meta_type;		// metadata type
+	unsigned int meta_size;		// size of this entire struct including hdrs.
+	unsigned int test_type;		// IFS test type
+	unsigned int fusa_info;		// Fusa info
+	unsigned int total_images;	// Total number of images
+	unsigned int current_image;	// Current Image #
+	unsigned int total_chunks;	// Total number of chunks in this image
+	unsigned int starting_chunk;	// Starting chunk number in this image
+	unsigned int size_per_chunk;	// size of each chunk
+	unsigned int chunks_per_stride;	// number of chunks in a stride
+	unsigned int reserved[54];	// Align to 256 bytes for chunk alignment.
+};
+
 #define IFS_HEADER_SIZE	(sizeof(struct microcode_header_intel))
 #define IFS_HEADER_VER	2
+#define META_TYPE_IFS	1
+#define IFS_CHUNK_ALIGNMENT	256
 static  struct microcode_header_intel *ifs_header_ptr;	/* pointer to the ifs image header */
 static u64 ifs_hash_ptr;			/* Address of ifs metadata (hash) */
 static u64 ifs_test_image_ptr;			/* 256B aligned address of test pattern */
@@ -98,6 +114,41 @@ static void copy_hashes_authenticate_chunks(struct work_struct *work)
 	complete(&ifs_done);
 }
 
+static int validate_ifs_metadata(struct device *dev)
+{
+	struct ifs_data *ifsd = ifs_get_data(dev);
+	struct meta_data *ifs_meta;
+	char test_file[64];
+	int ret = -EINVAL;
+
+	snprintf(test_file, sizeof(test_file), "%02x-%02x-%02x-%02x.scan",
+		 boot_cpu_data.x86, boot_cpu_data.x86_model,
+		 boot_cpu_data.x86_stepping, ifsd->cur_batch);
+
+	ifs_meta = (struct meta_data *)microcode_intel_find_meta_data(ifs_header_ptr,
+								      META_TYPE_IFS);
+	if (!ifs_meta) {
+		dev_err(dev, "IFS Metadata missing in file %s\n", test_file);
+		return ret;
+	}
+
+	ifs_test_image_ptr = (u64)ifs_meta + sizeof(struct meta_data);
+
+	/* Scan chunk start must be 256 byte aligned */
+	if (!IS_ALIGNED(ifs_test_image_ptr, IFS_CHUNK_ALIGNMENT)) {
+		dev_err(dev, "Scan pattern offset is not 256 byte aligned in %s\n", test_file);
+		return ret;
+	}
+
+	if (ifs_meta->current_image != ifsd->cur_batch) {
+		dev_warn(dev, "Suffix metadata is not matching with filename %s(0x%02x)\n",
+			 test_file, ifs_meta->current_image);
+		return ret;
+	}
+
+	return 0;
+}
+
 /*
  * IFS requires scan chunks authenticated per each socket in the platform.
  * Once the test chunk is authenticated, it is automatically copied to secured memory
@@ -114,6 +165,9 @@ static int scan_chunks_sanity_check(struct device *dev)
 	if (!package_authenticated)
 		return ret;
 
+	ret = validate_ifs_metadata(dev);
+	if (ret)
+		return ret;
 
 	ifsd->loading_error = false;
 	ifsd->loaded_version = ifs_header_ptr->rev;
-- 
2.25.1

