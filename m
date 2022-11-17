Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E07A464
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 23:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668726326; x=1700262326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SI08aRfUPPyogEk92AvQFBq4JlMhWR8egcb+3yKDr30=;
  b=hWXYVwfkmQppnGrWEiJRHi6kHrI1+xYosj46XzYCdSmpdZtv2D455Nxp
   K2XnMcCYS9pDyTM1rdmhoptUgRohfSncbMReZb2DeZPS328xSAz8rvpiV
   2ygpDJcsCRRkeT0yeCCqEy7OpQaSowigAqTM+7ivnVZtbPcmpMQmdwRSa
   JuWmTgnzKMcttJ7xZGiyuPasaOudkD3AMTiH0BIDarjwa+zaRtdNzv60T
   4rnEVywOIu8kdJ5m6JHcMvIH9WcWvqgCzcZYGN5cH4486N3/wnU86VJZW
   uw0D2UuT2tjPMYk7xIB7LSAwqmzlK7PNrSCoF/1jpaQ7OdZ13P489Rc4D
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="377267775"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="377267775"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 15:05:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="671106093"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="671106093"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 15:05:25 -0800
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
	athenas.jimenez.gonzalez@intel.com,
	sohil.mehta@intel.com
Subject: [PATCH v3 12/16] platform/x86/intel/ifs: Add metadata validation
Date: Thu, 17 Nov 2022 15:04:08 -0800
Message-Id: <20221117230408.30331-1-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221117035935.4136738-13-jithu.joseph@intel.com>
References: <20221117035935.4136738-13-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The data portion of IFS test image file contains a metadata
region containing possibly multiple metadata structures in
addition to test data and hashes.

    IFS Metadata layout
   +----------------------+  0
   |META_TYPE_IFS (=1)    |
   +----------------------+
   |meta_size             |
   +----------------------+
   |test type             |
   +----------------------+
   |fusa info             |
   +----------------------+
   |total images          |
   +----------------------+
   |current image#        |
   +----------------------+
   |total chunks          |
   +----------------------+
   |starting chunk        |
   +----------------------+
   |size per chunk        |
   +----------------------+
   |chunks per stride     |
   +----------------------+
   |Reserved[54]          |
   +----------------------+ 256
   |                      |
   |                      |
   |                      |
   |                      |
   |Test Data/Chunks      |
   |                      |
   |                      |
   |                      |
   |                      |
   +----------------------+  meta_size
   |   META_TYPE_END (=0) |
   +----------------------+  meta_size + 4
   |   size of end (=8)   |
   |                      |
   +----------------------+  meta_size + 8

Introduce the layout of this meta_data structure and validate
the sanity of certain fields of the new image before loading.

Tweak references to IFS test image chunks to reflect the updated
layout of the test image.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
  - Rebased to apply alongside the updated 4/16 patch

 drivers/platform/x86/intel/ifs/ifs.h  |  2 +
 drivers/platform/x86/intel/ifs/load.c | 58 ++++++++++++++++++++++++++-
 2 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 8de1952a1b7b..74c051c544f4 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -197,6 +197,7 @@ union ifs_status {
  * @valid_chunks: number of chunks which could be validated.
  * @status: it holds simple status pass/fail/untested
  * @scan_details: opaque scan status code from h/w
+ * @cur_batch: number indicating the currently loaded test file
  */
 struct ifs_data {
 	int	integrity_cap_bit;
@@ -207,6 +208,7 @@ struct ifs_data {
 	int	valid_chunks;
 	int	status;
 	u64	scan_details;
+	u32	cur_batch;
 };
 
 struct ifs_work {
diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index 83434160bc4c..edc7baa976bf 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -7,7 +7,25 @@
 
 #include "ifs.h"
 
+#define IFS_CHUNK_ALIGNMENT	256
+union meta_data {
+	struct {
+		u32 meta_type;		// metadata type
+		u32 meta_size;		// size of this entire struct including hdrs.
+		u32 test_type;		// IFS test type
+		u32 fusa_info;		// Fusa info
+		u32 total_images;	// Total number of images
+		u32 current_image;	// Current Image #
+		u32 total_chunks;	// Total number of chunks in this image
+		u32 starting_chunk;	// Starting chunk number in this image
+		u32 size_per_chunk;	// size of each chunk
+		u32 chunks_per_stride;	// number of chunks in a stride
+	};
+	u8 padding[IFS_CHUNK_ALIGNMENT];
+};
+
 #define IFS_HEADER_SIZE	(sizeof(struct microcode_header_intel))
+#define META_TYPE_IFS	1
 static  struct microcode_header_intel *ifs_header_ptr;	/* pointer to the ifs image header */
 static u64 ifs_hash_ptr;			/* Address of ifs metadata (hash) */
 static u64 ifs_test_image_ptr;			/* 256B aligned address of test pattern */
@@ -128,6 +146,41 @@ static void copy_hashes_authenticate_chunks(struct work_struct *work)
 	complete(&ifs_done);
 }
 
+static int validate_ifs_metadata(struct device *dev)
+{
+	struct ifs_data *ifsd = ifs_get_data(dev);
+	union meta_data *ifs_meta;
+	char test_file[64];
+	int ret = -EINVAL;
+
+	snprintf(test_file, sizeof(test_file), "%02x-%02x-%02x-%02x.scan",
+		 boot_cpu_data.x86, boot_cpu_data.x86_model,
+		 boot_cpu_data.x86_stepping, ifsd->cur_batch);
+
+	ifs_meta = (union meta_data *)find_meta_data(ifs_header_ptr, META_TYPE_IFS);
+	if (!ifs_meta) {
+		dev_err(dev, "IFS Metadata missing in file %s\n", test_file);
+		return ret;
+	}
+
+	ifs_test_image_ptr = (u64)ifs_meta + sizeof(union meta_data);
+
+	/* Scan chunk start must be 256 byte aligned */
+	if (!IS_ALIGNED(ifs_test_image_ptr, IFS_CHUNK_ALIGNMENT)) {
+		dev_err(dev, "Scan pattern is not aligned on %d bytes aligned in %s\n",
+			IFS_CHUNK_ALIGNMENT, test_file);
+		return ret;
+	}
+
+	if (ifs_meta->current_image != ifsd->cur_batch) {
+		dev_warn(dev, "Mismatch between filename %s and batch metadata 0x%02x\n",
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
@@ -139,8 +192,11 @@ static int scan_chunks_sanity_check(struct device *dev)
 	struct ifs_work local_work;
 	int curr_pkg, cpu, ret;
 
-
 	memset(ifsd->pkg_auth, 0, (topology_max_packages() * sizeof(bool)));
+	ret = validate_ifs_metadata(dev);
+	if (ret)
+		return ret;
+
 	ifsd->loading_error = false;
 	ifsd->loaded_version = ifs_header_ptr->rev;
 
-- 
2.25.1

