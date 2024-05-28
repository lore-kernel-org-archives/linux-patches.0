Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DBE14199C
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716934828; cv=none; b=FdhLpaMQi6Irs4n6Jo+ScNXH2vch1+xoCVFRIPnfWZoKWm44Uv9zkiD15STnSOdsJ8Dt/+pD11mgtfsEU8e5PBbLUvj8+B7bmVczenj0b8mTGg9pI3esGOjg2lKm7fb6/l+hPqtFD1Rd980AvZxFoRh2ECACJb7H1s1JpHThtkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716934828; c=relaxed/simple;
	bh=PBJ2zpkPM/0ZXpavxoUVI8BBig+p/tYD6BH0Qwfm874=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLSf+Bn0H56KQiMoNqRIvK5BGKKNDbdoFJTVj2YcGM1dA80De5eOv+FPizGuUnusTZ2bpDQwY40+mQyml1p2sDX1kE2ZFoFSekbrPyrcfgiTP4DK6APdGXFoj5pqgizWlL/GKBBbAC+YNvTChjvrFoojwue5QJyec8wYLNxQlRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KBbEBfdS; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KBbEBfdS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716934827; x=1748470827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PBJ2zpkPM/0ZXpavxoUVI8BBig+p/tYD6BH0Qwfm874=;
  b=KBbEBfdSYHFplIUanXppaBcrMGBIWe6LumDITO+ZgshnAD189dsAC9O+
   cnuHIoOVbMGsuVsJrH1pNmmJ6d8Nq/81HK19gExsiMKtxoS8zrOwUUibQ
   1vCEcMJYaPxfwmcMVmWvDf5QxdFOihhHN1E5w3fHwsO2nnKflfTdZ3Qp2
   Lln5EmE6/w3LI6EKe9Jl/Bex5mduD1uHelnalWwpnp/J4tYFHM5hjwfKb
   /igbds4CeeS8bcHj5JlqLPO+EZtk7zzamj72v6QdrfQF3wOQ01XhAC9F0
   vRRg2L/+YQ2wJNYbQAINfMdE1qDjKSx0GZeMoYf1UU08mR7hyMYI9SkXv
   g==;
X-CSE-ConnectionGUID: R2q88ePITpy+pxyN92eH6Q==
X-CSE-MsgGUID: tsGzDGYlTeG8r36Modxtqg==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30812248"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30812248"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:19 -0700
X-CSE-ConnectionGUID: r1WM+vtUSL2H3u3RWaJrDw==
X-CSE-MsgGUID: u+6YuskcTZCTgyZc8IPWQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40090768"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v19 16/20] x86/resctrl: Make resctrl_arch_rmid_read() handle sum over domains
Date: Tue, 28 May 2024 15:20:01 -0700
Message-ID: <20240528222006.58283-17-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240528222006.58283-1-tony.luck@intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Legacy resctrl monitor files must provide the sum of event values across
all Sub-NUMA Cluster (SNC) domains that share an L3 cache instance.

Rename the existing resctrl_arch_rmid_read() function as
resctrl_arch_rmid_read_one() (with some small refactoring to drop
arguments that are not needed.

Create a new resctrl_arch_rmid_read() that iterates across
domains when necessary. Pass a CPU number from the right domain to
resctrl_arch_rmid_read_one().

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 41 ++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 5f89ed4823ee..c9dd6ec68fcd 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -200,10 +200,9 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
  * Caller is responsible to make sure execution running on a CPU in
  * the domain to be read.
  */
-static int logical_rmid_to_physical_rmid(int lrmid)
+static int logical_rmid_to_physical_rmid(int cpu, int lrmid)
 {
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
-	int cpu = smp_processor_id();
 
 	if (snc_nodes_per_l3_cache  == 1)
 		return lrmid;
@@ -211,13 +210,13 @@ static int logical_rmid_to_physical_rmid(int lrmid)
 	return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
 }
 
-static int __rmid_read(u32 lrmid,
+static int __rmid_read(int cpu, u32 lrmid,
 		       enum resctrl_event_id eventid, u64 *val)
 {
 	u64 msr_val;
 	int prmid;
 
-	prmid = logical_rmid_to_physical_rmid(lrmid);
+	prmid = logical_rmid_to_physical_rmid(cpu, lrmid);
 	/*
 	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
 	 * with a valid event code for supported resource type and the bits
@@ -269,7 +268,7 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
 		memset(am, 0, sizeof(*am));
 
 		/* Record any initial, non-zero count value. */
-		__rmid_read(rmid, eventid, &am->prev_msr);
+		__rmid_read(smp_processor_id(), rmid, eventid, &am->prev_msr);
 	}
 }
 
@@ -298,9 +297,8 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
 	return chunks >> shift;
 }
 
-int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
-			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
-			   u64 *val, bool sum, struct cacheinfo *ci, void *ignored)
+static int resctrl_arch_rmid_read_one(struct rdt_resource *r, struct rdt_mon_domain *d,
+				      int cpu, u32 rmid, enum resctrl_event_id eventid, u64 *val)
 {
 	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
@@ -313,7 +311,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
 	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
 		return -EINVAL;
 
-	ret = __rmid_read(rmid, eventid, &msr_val);
+	ret = __rmid_read(cpu, rmid, eventid, &msr_val);
 	if (ret)
 		return ret;
 
@@ -327,7 +325,30 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
 		chunks = msr_val;
 	}
 
-	*val = chunks * hw_res->mon_scale;
+	*val += chunks * hw_res->mon_scale;
+
+	return 0;
+}
+
+int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
+			   u64 *val, bool sum, struct cacheinfo *ci, void *ignored)
+{
+	int cpu = smp_processor_id();
+	int ret;
+
+	*val = 0;
+	if (!sum)
+		return resctrl_arch_rmid_read_one(r, d, cpu, rmid, eventid, val);
+
+	list_for_each_entry(d, &r->mon_domains, hdr.list) {
+		if (d->ci->id != ci->id)
+			continue;
+		cpu = cpumask_any(&d->hdr.cpu_mask);
+		ret = resctrl_arch_rmid_read_one(r, d, cpu, rmid, eventid, val);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
-- 
2.45.0

