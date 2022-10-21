Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20366AA6
	for <patches@lists.linux.dev>; Fri, 21 Oct 2022 20:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666384555; x=1697920555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yo+BuHHe+5788jOOlbf8kqFseScnYm+6V1Kpa1hItDA=;
  b=VX9kbZWa5P8BdmYw0mkq1msoQaA0VpoZbPJA1eSxlaIsXj7b+2+9sVOG
   EuH14+EESKMH21x3v5N3wKFqvhzXjV1n8YVMbdRptQjR1GTrAgV1vat/V
   Ljr3UEgEL++91dQTYczJ45CEX178rNuMPVGx6P86g9jLa4JDY2trLiP8W
   AZ9Map+FxUPMVupVlstkArB57m5VYyPSg3b6r6k2caQBrnNnODMlabUtL
   WrauONljW0ehEheKyeNujnawgp1Ic+soMo6j9T9XyIyio+6qbPFO41bx2
   wjEK1gESkDEBnK/Mak5viNCA8xnxfaGvxT38G3CEa0YHVeBWMOJj9gyyx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="333675913"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="333675913"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:36 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="735701022"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="735701022"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:35 -0700
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
Subject: [PATCH 08/14] x86/microcode/intel: Meta-data support in microcode file
Date: Fri, 21 Oct 2022 13:34:07 -0700
Message-Id: <20221021203413.1220137-9-jithu.joseph@intel.com>
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

From: Ashok Raj <ashok.raj@intel.com>

Intel has made extensions to the microcode file format so that it
can also be used for In Field Scan. One of the existing reserved fields
has been allocated to indicate the size of the region in the file allocated
for metadata structures.

    Microcode Format
   +----------------------+  Base
   |Header Version        |
   +----------------------+
   |Update revision       |
   +----------------------+
   |Date DDMMYYYY         |
   +----------------------+
   |Sig                   |
   +----------------------+
   |Checksum              |
   +----------------------+
   |Loader Version        |
   +----------------------+
   |Processor Flags       |
   +----------------------+
   |Data Size             |
   +----------------------+
   |Total Size            |
   +----------------------+
   |Meta Size             |
   +----------------------+
   |Reserved              |
   +----------------------+
   |Reserved              |
   +----------------------+  Base+48
   |                      |
   |                      |
   |                      |
   |                      |
   |    Microcode         |
   |                      |
   |     Data             |
   |                      |
   |                      |
   +----------------------+  Base+48+data_size-
   |                      |     meta_size
   |   Meta Data          |
   |                      |
   +----------------------+  Base+48+data_size
   |   Extended Signature |
   |        Table         |
   |                      |
   |                      |
   |                      |
   |                      |
   |                      |
   +----------------------+  Base+total_size

In subsequent patches IFS test image file (which reuse microcode header
format) will make use of metadata section. Though IFS is the first
consumer of this metadata within microcode file, it is expected that
this will be used for supporting upcoming microcode update
related enhancements.

Also add an accessor function which will return a pointer to the
start of a specific meta_type being queried.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 arch/x86/include/asm/microcode_intel.h | 19 +++++++++-
 arch/x86/kernel/cpu/microcode/intel.c  | 48 ++++++++++++++++++++++++--
 2 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 27eba991c6b6..dcbc377f67d1 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -14,7 +14,8 @@ struct microcode_header_intel {
 	unsigned int            pf;
 	unsigned int            datasize;
 	unsigned int            totalsize;
-	unsigned int            reserved[3];
+	unsigned int            metasize;
+	unsigned int            reserved[2];
 };
 
 struct microcode_intel {
@@ -36,6 +37,18 @@ struct extended_sigtable {
 	struct extended_signature sigs[];
 };
 
+#define META_TYPE_END		(0)
+
+struct metadata_header {
+	unsigned int		meta_type;
+	unsigned int		meta_blk_size;
+};
+
+struct metadata_intel {
+	struct metadata_header	meta_hdr;
+	unsigned int		meta_bits[];
+};
+
 #define DEFAULT_UCODE_DATASIZE	(2000)
 #define MC_HEADER_SIZE		(sizeof(struct microcode_header_intel))
 #define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE)
@@ -76,6 +89,7 @@ extern int __init save_microcode_in_initrd_intel(void);
 void reload_ucode_intel(void);
 int microcode_intel_find_matching_signature(void *mc, unsigned int csig, int cpf);
 int microcode_intel_sanity_check(void *mc, bool print_err, int hdr_ver);
+struct metadata_header *microcode_intel_find_meta_data(void *ucode, unsigned int meta_type);
 #else
 static inline __init void load_ucode_intel_bsp(void) {}
 static inline void load_ucode_intel_ap(void) {}
@@ -86,6 +100,9 @@ static inline int microcode_intel_find_matching_signature(void *mc, unsigned int
 	{ return 0; }
 static inline int microcode_intel_sanity_check(void *mc, bool print_err, int hdr_ver)
 	{ return -EINVAL; }
+static inline struct metadata_header *microcode_intel_find_meta_data(void *ucode,
+								     unsigned int meta_type)
+	{ return NULL; }
 #endif
 
 #endif /* _ASM_X86_MICROCODE_INTEL_H */
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index bc3f33a25d7a..179ca345bc06 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -168,14 +168,17 @@ static void save_microcode_patch(struct ucode_cpu_info *uci, void *data, unsigne
 
 int microcode_intel_sanity_check(void *mc, bool print_err, int hdr_ver)
 {
-	unsigned long total_size, data_size, ext_table_size;
+	unsigned long total_size, data_size, ext_table_size, total_meta;
 	struct microcode_header_intel *mc_header = mc;
 	struct extended_sigtable *ext_header = NULL;
 	u32 sum, orig_sum, ext_sigcount = 0, i;
 	struct extended_signature *ext_sig;
+	struct metadata_header *meta_header;
+	unsigned long meta_size = 0;
 
 	total_size = get_totalsize(mc_header);
 	data_size = get_datasize(mc_header);
+	total_meta = mc_header->metasize;
 
 	if (data_size + MC_HEADER_SIZE > total_size) {
 		if (print_err)
@@ -245,7 +248,7 @@ int microcode_intel_sanity_check(void *mc, bool print_err, int hdr_ver)
 	}
 
 	if (!ext_table_size)
-		return 0;
+		goto check_meta;
 
 	/*
 	 * Check extended signature checksum: 0 => valid.
@@ -262,6 +265,22 @@ int microcode_intel_sanity_check(void *mc, bool print_err, int hdr_ver)
 			return -EINVAL;
 		}
 	}
+
+check_meta:
+	if (!total_meta)
+		return 0;
+
+	meta_header =  (mc + MC_HEADER_SIZE + data_size) - total_meta;
+	while (meta_header->meta_type != META_TYPE_END) {
+		meta_size += meta_header->meta_blk_size;
+		if (!meta_header->meta_blk_size || meta_size > total_meta) {
+			if (print_err) {
+				pr_err("Bad value for metadata size, aborting.\n");
+				return -EINVAL;
+			}
+		}
+		meta_header = (void *)meta_header + meta_header->meta_blk_size;
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(microcode_intel_sanity_check);
@@ -967,3 +986,28 @@ struct microcode_ops * __init init_intel_microcode(void)
 
 	return &microcode_intel_ops;
 }
+
+struct metadata_header *microcode_intel_find_meta_data(void *ucode, unsigned int meta_type)
+{
+	struct metadata_header *meta_header;
+	unsigned long data_size, total_meta;
+	unsigned long meta_size = 0;
+
+	data_size = get_datasize(ucode);
+	total_meta = ((struct microcode_intel *)ucode)->hdr.metasize;
+
+	if (!total_meta)
+		return NULL;
+
+	meta_header = (ucode + MC_HEADER_SIZE + data_size) - total_meta;
+
+	while ((meta_header->meta_type != META_TYPE_END) && meta_size < total_meta) {
+		meta_size += meta_header->meta_blk_size;
+		if (meta_header->meta_type == meta_type)
+			return meta_header;
+
+		meta_header = (void *)meta_header + meta_header->meta_blk_size;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(microcode_intel_find_meta_data);
-- 
2.25.1

