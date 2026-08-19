Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E750648550F
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 16:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787156018; cv=none; b=DMVZi3RJxb4epRyT/8qnfQpmoTjf95NURL4HMh4Ax9bJhIUEx8A90wcKaUEF15wcZiRsrMZ5ldNXVJNvUO2oDNk/HNiRJS/PUdI9/DwcWy6z0Hixkau7L2rZI+MNbYjWus5AKrlxJV7JeDbFqEDjYlQEd/+ttCRWa7Nv/RE3Pac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787156018; c=relaxed/simple;
	bh=IXRrDceqzOhX8M6QyZuJwyUegKGxImEtimTfeHQceDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ga53T9054iC6g5aChV4BwuFyjbG1sqIJFqBE/Gh8mm3/fplgUMgS/JEHRv+L6BO2Q5mbUlvMB61O9C9XunrbPuLdX+CZd2aSLNInBcY3maIZdsSN0vj9tfCPgG+Pz6pr0f/j2wGFBFPvBSOVJQQCBOXw/+kaz8n9GivM47R2KYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jEprRKOf; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jEprRKOf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787156016; x=1818692016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IXRrDceqzOhX8M6QyZuJwyUegKGxImEtimTfeHQceDI=;
  b=jEprRKOfmawof1L19ltjSLiCgjd1BxCbBNlImvj1+5GbfvOm8D7Q2dDU
   oDrAscW+Qcn5uByCS/5t+bD5CxTOAJ47L3XpmtS8sjuYxpqFUmBnpP3BQ
   L/7JVdHdaKLxMemXpSejzxdcFu5uY6Tjr+S5LbsY1awGxMfE24pXhF8ac
   +8bRq16zM1PKK6855eHOFWLNqsia47NgJFv1R/I1wp6J1D+GxGi9p8826
   KidfY14gKC2qoF602/lsrcBkLt/658ML2l5qUEPJmBjZCmi8rCOhRQkLe
   1Jijy4bz9XUlA/xcbckXdkSk28en6Y/60Eob3C0z8Xe8V4lDjJyvsjrg9
   A==;
X-CSE-ConnectionGUID: jBW742cITceHJl212dHQRQ==
X-CSE-MsgGUID: uxWWl+bBQ7WHHEAtOl6fjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11880"; a="87598055"
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="87598055"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 09:13:33 -0700
X-CSE-ConnectionGUID: p+R+a11QQeyj9+ax8wtWjw==
X-CSE-MsgGUID: lTqtgbnOS9e6wf6KcGOLsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,231,1779174000"; 
   d="scan'208";a="290391844"
Received: from rodrigoa-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2026 09:13:33 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 2/4] x86/resctrl: Enumerate monitor features in rdt_get_l3_mon_config()
Date: Wed, 19 Aug 2026 09:13:20 -0700
Message-ID: <20260819161323.11587-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819161323.11587-1-tony.luck@intel.com>
References: <20260819161323.11587-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The original implementation of Intel Cache QoS Monitoring (CQM) planned
to integrate with the "perf" and "cgroup" subsystems. With that plan it
made sense for parameters from CPUID to be stored in fields of the
cpuinfo_x86 structure. But that plan was abandoned and the resctrl file
system user interface replaced it.

Enumerate the L3 monitoring features in rdt_get_l3_mon_config().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/resctrl.h        |  9 ++++----
 arch/x86/kernel/cpu/resctrl/monitor.c | 32 ++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 8f6edcdcfd87..9bfa9b14002b 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -44,6 +44,7 @@ DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
 extern bool rdt_alloc_capable;
 extern bool rdt_mon_capable;
+extern unsigned int __ro_after_init rdt_l3_mon_scale;
 
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
@@ -132,11 +133,9 @@ static inline void __resctrl_sched_in(struct task_struct *tsk)
 
 static inline unsigned int resctrl_arch_round_mon_val(unsigned int val)
 {
-	unsigned int scale = boot_cpu_data.x86_cache_occ_scale;
-
-	/* h/w works in units of "boot_cpu_data.x86_cache_occ_scale" */
-	val /= scale;
-	return val * scale;
+	/* Round down to nearest h/w monitoring unit */
+	val /= rdt_l3_mon_scale;
+	return val * rdt_l3_mon_scale;
 }
 
 static inline void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid,
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 3838e0a13d36..0c2aa20148a1 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -32,6 +32,11 @@
  */
 bool rdt_mon_capable;
 
+/*
+ * Scale factor to convert L3 monitor events to bytes.
+ */
+unsigned int __ro_after_init rdt_l3_mon_scale;
+
 #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
 
 static int snc_nodes_per_l3_cache = 1;
@@ -418,16 +423,37 @@ static __init int snc_get_config(void)
 
 int __init rdt_get_l3_mon_config(struct rdt_resource *r)
 {
-	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
+	unsigned int mbm_offset;
 	unsigned int threshold;
 	u32 eax, ebx, ecx, edx;
+	u32 num_rmid;
+
+	/* QoS sub-leaf, EAX=0Fh, ECX=1 */
+	cpuid_count(0xf, 1, &eax, &ebx, &ecx, &edx);
+	mbm_offset = eax & 0xff;
+	rdt_l3_mon_scale = ebx;
+	num_rmid = ecx + 1;
+
+	if (!mbm_offset) {
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_AMD:
+			mbm_offset = MBM_CNTR_WIDTH_OFFSET_AMD;
+			break;
+		case X86_VENDOR_HYGON:
+			mbm_offset = MBM_CNTR_WIDTH_OFFSET_HYGON;
+			break;
+		default:
+			/* Leave mbm_offset as 0 */
+			break;
+		}
+	}
 
 	snc_nodes_per_l3_cache = snc_get_config();
 
 	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
-	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
-	r->mon.num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
+	hw_res->mon_scale = rdt_l3_mon_scale / snc_nodes_per_l3_cache;
+	r->mon.num_rmid = num_rmid / snc_nodes_per_l3_cache;
 	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
 
 	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)
-- 
2.55.0

