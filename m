Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C196D17ED
	for <patches@lists.linux.dev>; Thu, 17 Nov 2022 04:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668657661; x=1700193661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GOVqqmB/udIpGjOieUk0ZM7mu9Vt8k1erZYYzlDXV9w=;
  b=a1pSkasUDtLwK1y849yVcvXv3/5lSsUmYhzU/v55yhFye8KKJ9qIQIKY
   l1nQhE/y3p0gHzDug+z4e1lun+6ShHYQwft/WDWzB9ENfJ8wZ2Xhfuj4D
   /+NYcwj154E5bqJMq6Syx03koUlZhTZAVw2ia6AJb/MbFO4Hc7r5tKZ8e
   UKkd6svqKv4PxEcVGJ9T1us534/T4RCyYL9uyhdX7c8elHX8NvSaOkGW3
   rXTujCwzKjdzmA461w2UcKWs2e2biEnhLKRU7gMKLFMRghmA8at7fYRnY
   WpcDsYCnqTWDGZJe8FTVGAERAtePGF2eK90epMFy/Rk1mUBJe1sU0YGpn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="399038891"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="399038891"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 20:00:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="590462678"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="590462678"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 20:00:56 -0800
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
Subject: [PATCH v3 05/16] x86/microcode/intel: Reuse find_matching_signature()
Date: Wed, 16 Nov 2022 19:59:24 -0800
Message-Id: <20221117035935.4136738-6-jithu.joseph@intel.com>
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

IFS uses test images provided by Intel that can be regarded as
firmware. IFS test image carries microcode header with extended signature
table.

Reuse find_matching_signature() for verifying if the test image
header or the extended signature table indicate whether an IFS test image
is fit to run on a system.

No functional change

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 arch/x86/include/asm/cpu.h            |  1 +
 arch/x86/kernel/cpu/intel.c           | 29 ++++++++++++++++++
 arch/x86/kernel/cpu/microcode/intel.c | 44 +++++----------------------
 3 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index b472ef76826a..e853440b5c65 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -95,5 +95,6 @@ static inline bool intel_cpu_signatures_match(unsigned int s1, unsigned int p1,
 }
 
 extern u64 x86_read_arch_cap_msr(void);
+int intel_find_matching_signature(void *mc, unsigned int csig, int cpf);
 
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 2d7ea5480ec3..b6f9210fb31a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -216,6 +216,35 @@ int intel_cpu_collect_info(struct ucode_cpu_info *uci)
 }
 EXPORT_SYMBOL_GPL(intel_cpu_collect_info);
 
+/*
+ * Returns 1 if update has been found, 0 otherwise.
+ */
+int intel_find_matching_signature(void *mc, unsigned int csig, int cpf)
+{
+	struct microcode_header_intel *mc_hdr = mc;
+	struct extended_sigtable *ext_hdr;
+	struct extended_signature *ext_sig;
+	int i;
+
+	if (intel_cpu_signatures_match(csig, cpf, mc_hdr->sig, mc_hdr->pf))
+		return 1;
+
+	/* Look for ext. headers: */
+	if (get_totalsize(mc_hdr) <= get_datasize(mc_hdr) + MC_HEADER_SIZE)
+		return 0;
+
+	ext_hdr = mc + get_datasize(mc_hdr) + MC_HEADER_SIZE;
+	ext_sig = (void *)ext_hdr + EXT_HEADER_SIZE;
+
+	for (i = 0; i < ext_hdr->count; i++) {
+		if (intel_cpu_signatures_match(csig, cpf, ext_sig->sig, ext_sig->pf))
+			return 1;
+		ext_sig++;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(intel_find_matching_signature);
+
 static void early_init_intel(struct cpuinfo_x86 *c)
 {
 	u64 misc_enable;
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 1fcbd671f1df..4e611a708718 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -45,34 +45,6 @@ static struct microcode_intel *intel_ucode_patch;
 /* last level cache size per core */
 static int llc_size_per_core;
 
-/*
- * Returns 1 if update has been found, 0 otherwise.
- */
-static int find_matching_signature(void *mc, unsigned int csig, int cpf)
-{
-	struct microcode_header_intel *mc_hdr = mc;
-	struct extended_sigtable *ext_hdr;
-	struct extended_signature *ext_sig;
-	int i;
-
-	if (intel_cpu_signatures_match(csig, cpf, mc_hdr->sig, mc_hdr->pf))
-		return 1;
-
-	/* Look for ext. headers: */
-	if (get_totalsize(mc_hdr) <= get_datasize(mc_hdr) + MC_HEADER_SIZE)
-		return 0;
-
-	ext_hdr = mc + get_datasize(mc_hdr) + MC_HEADER_SIZE;
-	ext_sig = (void *)ext_hdr + EXT_HEADER_SIZE;
-
-	for (i = 0; i < ext_hdr->count; i++) {
-		if (intel_cpu_signatures_match(csig, cpf, ext_sig->sig, ext_sig->pf))
-			return 1;
-		ext_sig++;
-	}
-	return 0;
-}
-
 /*
  * Returns 1 if update has been found, 0 otherwise.
  */
@@ -83,7 +55,7 @@ static int has_newer_microcode(void *mc, unsigned int csig, int cpf, int new_rev
 	if (mc_hdr->rev <= new_rev)
 		return 0;
 
-	return find_matching_signature(mc, csig, cpf);
+	return intel_find_matching_signature(mc, csig, cpf);
 }
 
 static struct ucode_patch *memdup_patch(void *data, unsigned int size)
@@ -117,7 +89,7 @@ static void save_microcode_patch(struct ucode_cpu_info *uci, void *data, unsigne
 		sig	     = mc_saved_hdr->sig;
 		pf	     = mc_saved_hdr->pf;
 
-		if (find_matching_signature(data, sig, pf)) {
+		if (intel_find_matching_signature(data, sig, pf)) {
 			prev_found = true;
 
 			if (mc_hdr->rev <= mc_saved_hdr->rev)
@@ -149,7 +121,7 @@ static void save_microcode_patch(struct ucode_cpu_info *uci, void *data, unsigne
 	if (!p)
 		return;
 
-	if (!find_matching_signature(p->data, uci->cpu_sig.sig, uci->cpu_sig.pf))
+	if (!intel_find_matching_signature(p->data, uci->cpu_sig.sig, uci->cpu_sig.pf))
 		return;
 
 	/*
@@ -286,8 +258,8 @@ scan_microcode(void *data, size_t size, struct ucode_cpu_info *uci, bool save)
 
 		size -= mc_size;
 
-		if (!find_matching_signature(data, uci->cpu_sig.sig,
-					     uci->cpu_sig.pf)) {
+		if (!intel_find_matching_signature(data, uci->cpu_sig.sig,
+						   uci->cpu_sig.pf)) {
 			data += mc_size;
 			continue;
 		}
@@ -652,9 +624,9 @@ static struct microcode_intel *find_patch(struct ucode_cpu_info *uci)
 		if (phdr->rev <= uci->cpu_sig.rev)
 			continue;
 
-		if (!find_matching_signature(phdr,
-					     uci->cpu_sig.sig,
-					     uci->cpu_sig.pf))
+		if (!intel_find_matching_signature(phdr,
+						   uci->cpu_sig.sig,
+						   uci->cpu_sig.pf))
 			continue;
 
 		return iter->data;
-- 
2.25.1

