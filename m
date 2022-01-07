Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF802CA1
	for <patches@lists.linux.dev>; Fri,  7 Jan 2022 22:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641596090; x=1673132090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zc2g+5Xaa8F3zL1JthKmLIHh19yHSOuOELavALf191I=;
  b=bPJoiaSs1q8eaG1/8++jgzy0jecGqVEu9ouBA3MtPjCdcnP7h/yK6C5X
   vCcpZJl7t10WBfRiEG32VpHZBPGMmxOtV3Eb28NZZ8H8ArsRR6JSTrcIO
   Ly3GgSQITjrzrABhFDIwK+w5VdFdRa+4XEonbaz8h47AefWU76hNNbRJC
   onTcOAIw1Z+YhN26K0Bzh1Vlroq7o/pGCjY06MLazkfZr0KWKmSTwH+Xd
   XN9fphofxOUVETkd3uxC1xLyH+wMWLuEj5Q8FLQLJPE19EnY3R/TMFdaH
   DJMN1W9MdJFu9nEd0LQhm5oQjcli6cjWLUfvpuqSmRbr60lS3HDY1+hM3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="242907959"
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="242907959"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:54:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="471452456"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:54:48 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 1/5] x86/ras: Merge Intel and AMD ppin_init() functions
Date: Fri,  7 Jan 2022 14:54:38 -0800
Message-Id: <20220107225442.1690165-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220107225442.1690165-1-tony.luck@intel.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The code to decide whether a system supports the PPIN (Protected
Processor Inventory Number) MSR was cloned from the Intel
implementation. Apart from the X86_FEATURE bit and the MSR numbers it is
identical.

Merge the two functions into common x86 code, but use x86_match_cpu()
instead of the switch (c->x86_model) that was used by the old Intel
code.

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/amd.c       | 30 -------------
 arch/x86/kernel/cpu/common.c    | 76 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mce/intel.c | 41 ------------------
 3 files changed, 76 insertions(+), 71 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 4edb6f0f628c..bad0fa4c1779 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -394,35 +394,6 @@ static void amd_detect_cmp(struct cpuinfo_x86 *c)
 	per_cpu(cpu_llc_id, cpu) = c->cpu_die_id = c->phys_proc_id;
 }
 
-static void amd_detect_ppin(struct cpuinfo_x86 *c)
-{
-	unsigned long long val;
-
-	if (!cpu_has(c, X86_FEATURE_AMD_PPIN))
-		return;
-
-	/* When PPIN is defined in CPUID, still need to check PPIN_CTL MSR */
-	if (rdmsrl_safe(MSR_AMD_PPIN_CTL, &val))
-		goto clear_ppin;
-
-	/* PPIN is locked in disabled mode, clear feature bit */
-	if ((val & 3UL) == 1UL)
-		goto clear_ppin;
-
-	/* If PPIN is disabled, try to enable it */
-	if (!(val & 2UL)) {
-		wrmsrl_safe(MSR_AMD_PPIN_CTL,  val | 2UL);
-		rdmsrl_safe(MSR_AMD_PPIN_CTL, &val);
-	}
-
-	/* If PPIN_EN bit is 1, return from here; otherwise fall through */
-	if (val & 2UL)
-		return;
-
-clear_ppin:
-	clear_cpu_cap(c, X86_FEATURE_AMD_PPIN);
-}
-
 u32 amd_get_nodes_per_socket(void)
 {
 	return nodes_per_socket;
@@ -947,7 +918,6 @@ static void init_amd(struct cpuinfo_x86 *c)
 	amd_detect_cmp(c);
 	amd_get_topology(c);
 	srat_detect_node(c);
-	amd_detect_ppin(c);
 
 	init_amd_cacheinfo(c);
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0083464de5e3..a1e29c0844d1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -88,6 +88,80 @@ EXPORT_SYMBOL_GPL(get_llc_id);
 /* L2 cache ID of each logical CPU */
 DEFINE_PER_CPU_READ_MOSTLY(u16, cpu_l2c_id) = BAD_APICID;
 
+static struct ppin_info {
+	int	feature;
+	int	msr_ppin_ctl;
+	int	msr_ppin;
+} ppin_info[] = {
+	[X86_VENDOR_INTEL] = {
+		.feature = X86_FEATURE_INTEL_PPIN,
+		.msr_ppin_ctl = MSR_PPIN_CTL,
+		.msr_ppin = MSR_PPIN
+	},
+	[X86_VENDOR_AMD] = {
+		.feature = X86_FEATURE_AMD_PPIN,
+		.msr_ppin_ctl = MSR_AMD_PPIN_CTL,
+		.msr_ppin = MSR_AMD_PPIN
+	},
+};
+
+static const struct x86_cpu_id ppin_cpuids[] = {
+	X86_MATCH_VENDOR_FEATURE(AMD, X86_FEATURE_AMD_PPIN, &ppin_info[X86_VENDOR_AMD]),
+
+	/* Legacy models without CPUID enumeration */
+	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE_X, &ppin_info[X86_VENDOR_INTEL]),
+	X86_MATCH_INTEL_FAM6_MODEL(HASWELL_X, &ppin_info[X86_VENDOR_INTEL]),
+	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_D, &ppin_info[X86_VENDOR_INTEL]),
+	X86_MATCH_INTEL_FAM6_MODEL(BROADWELL_X, &ppin_info[X86_VENDOR_INTEL]),
+	X86_MATCH_INTEL_FAM6_MODEL(SKYLAKE_X, &ppin_info[X86_VENDOR_INTEL]),
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, &ppin_info[X86_VENDOR_INTEL]),
+	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, &ppin_info[X86_VENDOR_INTEL]),
+	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNL, &ppin_info[X86_VENDOR_INTEL]),
+	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNM, &ppin_info[X86_VENDOR_INTEL]),
+
+	{}
+};
+
+static void ppin_init(struct cpuinfo_x86 *c)
+{
+	const struct x86_cpu_id *id;
+	unsigned long long val;
+	struct ppin_info *info;
+
+	id = x86_match_cpu(ppin_cpuids);
+	if (!id)
+		return;
+
+	/*
+	 * Testing the prescence of the MSR is not enough. Need to check
+	 * that the PPIN_CTL allows reading of the PPIN.
+	 */
+	info = (struct ppin_info *)id->driver_data;
+
+	if (rdmsrl_safe(info->msr_ppin_ctl, &val))
+		goto clear_ppin;
+
+	if ((val & 3UL) == 1UL) {
+		/* PPIN locked in disabled mode */
+		goto clear_ppin;
+	}
+
+	/* If PPIN is disabled, try to enable */
+	if (!(val & 2UL)) {
+		wrmsrl_safe(info->msr_ppin_ctl,  val | 2UL);
+		rdmsrl_safe(info->msr_ppin_ctl, &val);
+	}
+
+	/* Is the enable bit set? */
+	if (val & 2UL) {
+		set_cpu_cap(c, info->feature);
+		return;
+	}
+
+clear_ppin:
+	clear_cpu_cap(c, info->feature);
+}
+
 /* correctly size the local cpu masks */
 void __init setup_cpu_local_masks(void)
 {
@@ -1655,6 +1729,8 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 			c->x86_capability[i] |= boot_cpu_data.x86_capability[i];
 	}
 
+	ppin_init(c);
+
 	/* Init Machine Check Exception if available. */
 	mcheck_cpu_init(c);
 
diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index bb9a46a804bf..95275a5e57e0 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -470,46 +470,6 @@ void intel_clear_lmce(void)
 	wrmsrl(MSR_IA32_MCG_EXT_CTL, val);
 }
 
-static void intel_ppin_init(struct cpuinfo_x86 *c)
-{
-	unsigned long long val;
-
-	/*
-	 * Even if testing the presence of the MSR would be enough, we don't
-	 * want to risk the situation where other models reuse this MSR for
-	 * other purposes.
-	 */
-	switch (c->x86_model) {
-	case INTEL_FAM6_IVYBRIDGE_X:
-	case INTEL_FAM6_HASWELL_X:
-	case INTEL_FAM6_BROADWELL_D:
-	case INTEL_FAM6_BROADWELL_X:
-	case INTEL_FAM6_SKYLAKE_X:
-	case INTEL_FAM6_ICELAKE_X:
-	case INTEL_FAM6_SAPPHIRERAPIDS_X:
-	case INTEL_FAM6_XEON_PHI_KNL:
-	case INTEL_FAM6_XEON_PHI_KNM:
-
-		if (rdmsrl_safe(MSR_PPIN_CTL, &val))
-			return;
-
-		if ((val & 3UL) == 1UL) {
-			/* PPIN locked in disabled mode */
-			return;
-		}
-
-		/* If PPIN is disabled, try to enable */
-		if (!(val & 2UL)) {
-			wrmsrl_safe(MSR_PPIN_CTL,  val | 2UL);
-			rdmsrl_safe(MSR_PPIN_CTL, &val);
-		}
-
-		/* Is the enable bit set? */
-		if (val & 2UL)
-			set_cpu_cap(c, X86_FEATURE_INTEL_PPIN);
-	}
-}
-
 /*
  * Enable additional error logs from the integrated
  * memory controller on processors that support this.
@@ -534,7 +494,6 @@ void mce_intel_feature_init(struct cpuinfo_x86 *c)
 {
 	intel_init_cmci();
 	intel_init_lmce();
-	intel_ppin_init(c);
 	intel_imc_init(c);
 }
 
-- 
2.31.1

