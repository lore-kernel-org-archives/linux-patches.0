Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2012417EC
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 04:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668657664; x=1700193664;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3H6t5AxADTI7uec2GmddnFXYVAjGLBJeGJq+yHqIGqY=;
  b=H7s4akZFO/1TjQ+LY5/bjVaOT6gTkRcloJYgg7JR17MM9Ps1QBx71RE2
   3r2DIW9HPVgaSppAtWH5Rx/O2GCNtMIwCfF2rRsLIdPsxK46P/GN0ZH7e
   rADxSYu3r6V2VyIyGImWHXmoIas+lrxh9b7bPPl8Qd8DBq6qZno0RggZP
   ZMjIDqVif0eMp7nko+B/AYyMm6vf3QRFaPaqf9qR3WMK86x1r5wdG2HU2
   EwZrRiF1YQMXHrRq+SS0u/eNn2wjC8a+pqW96v3q3ETdpiWgu7w6c0Q1z
   XrLJ51ch4Rxdoy/7DlSHdKYB8qw0NPClfWNSArEG4bUgmJBq6DjEJ7+Nq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="399038896"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="399038896"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 20:00:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="590462686"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="590462686"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 20:00:57 -0800
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
Subject: [PATCH v3 07/16] x86/microcode/intel: Reuse microcode_sanity_check()
Date: Wed, 16 Nov 2022 19:59:26 -0800
Message-Id: <20221117035935.4136738-8-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221117035935.4136738-1-jithu.joseph@intel.com>
References: <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221117035935.4136738-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IFS test image carries the same microcode header as regular Intel
microcode blobs.

microcode_sanity_check() can be used by IFS driver to perform
sanity check of the IFS test images too.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 arch/x86/include/asm/cpu.h            |   1 +
 arch/x86/kernel/cpu/intel.c           |  99 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/microcode/intel.c | 102 +-------------------------
 3 files changed, 102 insertions(+), 100 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index e853440b5c65..9e3ac95acf2d 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -96,5 +96,6 @@ static inline bool intel_cpu_signatures_match(unsigned int s1, unsigned int p1,
 
 extern u64 x86_read_arch_cap_msr(void);
 int intel_find_matching_signature(void *mc, unsigned int csig, int cpf);
+int intel_microcode_sanity_check(void *mc, bool print_err);
 
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index b6f9210fb31a..01e73ec1d585 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -245,6 +245,105 @@ int intel_find_matching_signature(void *mc, unsigned int csig, int cpf)
 }
 EXPORT_SYMBOL_GPL(intel_find_matching_signature);
 
+int intel_microcode_sanity_check(void *mc, bool print_err)
+{
+	unsigned long total_size, data_size, ext_table_size;
+	struct microcode_header_intel *mc_header = mc;
+	struct extended_sigtable *ext_header = NULL;
+	u32 sum, orig_sum, ext_sigcount = 0, i;
+	struct extended_signature *ext_sig;
+
+	total_size = get_totalsize(mc_header);
+	data_size = get_datasize(mc_header);
+
+	if (data_size + MC_HEADER_SIZE > total_size) {
+		if (print_err)
+			pr_err("Error: bad microcode data file size.\n");
+		return -EINVAL;
+	}
+
+	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
+		if (print_err)
+			pr_err("Error: invalid/unknown microcode update format.\n");
+		return -EINVAL;
+	}
+
+	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
+	if (ext_table_size) {
+		u32 ext_table_sum = 0;
+		u32 *ext_tablep;
+
+		if (ext_table_size < EXT_HEADER_SIZE ||
+		    ((ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE)) {
+			if (print_err)
+				pr_err("Error: truncated extended signature table.\n");
+			return -EINVAL;
+		}
+
+		ext_header = mc + MC_HEADER_SIZE + data_size;
+		if (ext_table_size != exttable_size(ext_header)) {
+			if (print_err)
+				pr_err("Error: extended signature table size mismatch.\n");
+			return -EFAULT;
+		}
+
+		ext_sigcount = ext_header->count;
+
+		/*
+		 * Check extended table checksum: the sum of all dwords that
+		 * comprise a valid table must be 0.
+		 */
+		ext_tablep = (u32 *)ext_header;
+
+		i = ext_table_size / sizeof(u32);
+		while (i--)
+			ext_table_sum += ext_tablep[i];
+
+		if (ext_table_sum) {
+			if (print_err)
+				pr_warn("Bad extended signature table checksum, aborting.\n");
+			return -EINVAL;
+		}
+	}
+
+	/*
+	 * Calculate the checksum of update data and header. The checksum of
+	 * valid update data and header including the extended signature table
+	 * must be 0.
+	 */
+	orig_sum = 0;
+	i = (MC_HEADER_SIZE + data_size) / sizeof(u32);
+	while (i--)
+		orig_sum += ((u32 *)mc)[i];
+
+	if (orig_sum) {
+		if (print_err)
+			pr_err("Bad microcode data checksum, aborting.\n");
+		return -EINVAL;
+	}
+
+	if (!ext_table_size)
+		return 0;
+
+	/*
+	 * Check extended signature checksum: 0 => valid.
+	 */
+	for (i = 0; i < ext_sigcount; i++) {
+		ext_sig = (void *)ext_header + EXT_HEADER_SIZE +
+			  EXT_SIGNATURE_SIZE * i;
+
+		sum = (mc_header->sig + mc_header->pf + mc_header->cksum) -
+		      (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
+		if (sum) {
+			if (print_err)
+				pr_err("Bad extended signature checksum, aborting.\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(intel_microcode_sanity_check);
+
 static void early_init_intel(struct cpuinfo_x86 *c)
 {
 	u64 misc_enable;
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 234b163806ea..af7134073e65 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -135,104 +135,6 @@ static void save_microcode_patch(struct ucode_cpu_info *uci, void *data, unsigne
 		intel_ucode_patch = p->data;
 }
 
-static int microcode_sanity_check(void *mc, bool print_err)
-{
-	unsigned long total_size, data_size, ext_table_size;
-	struct microcode_header_intel *mc_header = mc;
-	struct extended_sigtable *ext_header = NULL;
-	u32 sum, orig_sum, ext_sigcount = 0, i;
-	struct extended_signature *ext_sig;
-
-	total_size = get_totalsize(mc_header);
-	data_size = get_datasize(mc_header);
-
-	if (data_size + MC_HEADER_SIZE > total_size) {
-		if (print_err)
-			pr_err("Error: bad microcode data file size.\n");
-		return -EINVAL;
-	}
-
-	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
-		if (print_err)
-			pr_err("Error: invalid/unknown microcode update format.\n");
-		return -EINVAL;
-	}
-
-	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
-	if (ext_table_size) {
-		u32 ext_table_sum = 0;
-		u32 *ext_tablep;
-
-		if ((ext_table_size < EXT_HEADER_SIZE)
-		 || ((ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE)) {
-			if (print_err)
-				pr_err("Error: truncated extended signature table.\n");
-			return -EINVAL;
-		}
-
-		ext_header = mc + MC_HEADER_SIZE + data_size;
-		if (ext_table_size != exttable_size(ext_header)) {
-			if (print_err)
-				pr_err("Error: extended signature table size mismatch.\n");
-			return -EFAULT;
-		}
-
-		ext_sigcount = ext_header->count;
-
-		/*
-		 * Check extended table checksum: the sum of all dwords that
-		 * comprise a valid table must be 0.
-		 */
-		ext_tablep = (u32 *)ext_header;
-
-		i = ext_table_size / sizeof(u32);
-		while (i--)
-			ext_table_sum += ext_tablep[i];
-
-		if (ext_table_sum) {
-			if (print_err)
-				pr_warn("Bad extended signature table checksum, aborting.\n");
-			return -EINVAL;
-		}
-	}
-
-	/*
-	 * Calculate the checksum of update data and header. The checksum of
-	 * valid update data and header including the extended signature table
-	 * must be 0.
-	 */
-	orig_sum = 0;
-	i = (MC_HEADER_SIZE + data_size) / sizeof(u32);
-	while (i--)
-		orig_sum += ((u32 *)mc)[i];
-
-	if (orig_sum) {
-		if (print_err)
-			pr_err("Bad microcode data checksum, aborting.\n");
-		return -EINVAL;
-	}
-
-	if (!ext_table_size)
-		return 0;
-
-	/*
-	 * Check extended signature checksum: 0 => valid.
-	 */
-	for (i = 0; i < ext_sigcount; i++) {
-		ext_sig = (void *)ext_header + EXT_HEADER_SIZE +
-			  EXT_SIGNATURE_SIZE * i;
-
-		sum = (mc_header->sig + mc_header->pf + mc_header->cksum) -
-		      (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
-		if (sum) {
-			if (print_err)
-				pr_err("Bad extended signature checksum, aborting.\n");
-			return -EINVAL;
-		}
-	}
-	return 0;
-}
-
 /*
  * Get microcode matching with BSP's model. Only CPUs with the same model as
  * BSP can stay in the platform.
@@ -253,7 +155,7 @@ scan_microcode(void *data, size_t size, struct ucode_cpu_info *uci, bool save)
 		mc_size = get_totalsize(mc_header);
 		if (!mc_size ||
 		    mc_size > size ||
-		    microcode_sanity_check(data, false) < 0)
+		    intel_microcode_sanity_check(data, false) < 0)
 			break;
 
 		size -= mc_size;
@@ -792,7 +694,7 @@ static enum ucode_state generic_load_microcode(int cpu, struct iov_iter *iter)
 		memcpy(mc, &mc_header, sizeof(mc_header));
 		data = mc + sizeof(mc_header);
 		if (!copy_from_iter_full(data, data_size, iter) ||
-		    microcode_sanity_check(mc, true) < 0) {
+		    intel_microcode_sanity_check(mc, true) < 0) {
 			break;
 		}
 
-- 
2.25.1

