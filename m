Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6DE170832
	for <patches@lists.linux.dev>; Fri, 21 Jun 2024 22:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719009561; cv=none; b=eF0epAEC0dlSNfY9OhuaFfSjFcMMT6M4z63RDRg/WNbajAQ+6mOfaWQw5VPVJyG0KUuOGbBfF0UN8bLQFHF3uwcIXTV1lxhK3KGMZD9YKinY0DhOZUZ/xz19ZZMkYovwBiJYX6Nat1Qs+dCz0+Mcs8Ht2CmFigOEzzrdz7NLP4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719009561; c=relaxed/simple;
	bh=ShJI2BeQ1QdFeKWXT1gxab709VsIREG9no0ixwZjSg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjwDHky9u40KbEhIfrdBMV+KeljBhxmTf7wRwdhrkgIahaDORbzes/9a6zykWpe5aDV0EaFvh9PBeEAE3GakjXyiSTGWp71+uq7in7f/WFOeBdvJWDklVwkMFKqVx/2B8pVvDvZ/sIPNFWYUq93WvxaUEB8sxkY1VDuFK8cMeoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lyNVu0xj; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lyNVu0xj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719009559; x=1750545559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ShJI2BeQ1QdFeKWXT1gxab709VsIREG9no0ixwZjSg0=;
  b=lyNVu0xjVFWTPTZQ4P6mAtuptSZBcpQFdPUehJkNGsRXBXvhmJIkjpr0
   CHi2SSTI8sSTvaeWqveBcPvJVn18qv6Cn2WzWyG5FNWuVf0IwwuXksVRr
   Qxhf3cT7tRjGvbIYdS1Pdg8mMHHNCjuwa4CXE3Vf43pig7FDf+6Pdkwde
   fa/e9DzgnIj5WOgSv+uo5RNV2VcS/7ZIHa4FSY7qrQNlp/QOUToE/WhNY
   rUp91j1j9E52k31K5SGHNSoa/l/zRYgztrVEyrmHPbseJh+R3qEQRP40L
   yq162hBFCQW2mS2GaCkybhj2fKlDQmm8mQonMpkQDNFmbe1vaj6kRye5L
   w==;
X-CSE-ConnectionGUID: 7s78ORXRThG5N6LOv3MUfQ==
X-CSE-MsgGUID: JxIoMaHARne71VUOjrLABA==
X-IronPort-AV: E=McAfee;i="6700,10204,11110"; a="26691355"
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="26691355"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:09 -0700
X-CSE-ConnectionGUID: 70FWh62mToONoFDpuF6KPA==
X-CSE-MsgGUID: Ttmj2XPQRTSVja800nP/7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,256,1712646000"; 
   d="scan'208";a="73935687"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2024 15:39:09 -0700
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
Subject: [PATCH v21 15/18] x86/resctrl: Make __mon_event_count() handle sum domains
Date: Fri, 21 Jun 2024 15:38:56 -0700
Message-ID: <20240621223859.43471-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240621223859.43471-1-tony.luck@intel.com>
References: <20240621223859.43471-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Legacy resctrl monitor files must provide the sum of event values across
all Sub-NUMA Cluster (SNC) domains that share an L3 cache instance.

There are now two cases:
1) A specific domain is provided in struct rmid_read
   This is either a non-SNC system, or the request is to read data
   from just one SNC node.
2) Domain pointer is NULL. In this case the cacheinfo field in struct
   rmid_read indicates that all SNC nodes that share that L3 cache
   instance should have the event read and return the sum of all
   values.

Update the CPU sanity check. The existing check that an event is read
from a CPU in the requested domain still applies when reading a single
domain. But when summing across domains a more relaxed check that the
current CPU is in the scope of the L3 cache instance is appropriate
since the MSRs to read events are scoped at L3 cache level.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 50 ++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 877d898e8fd0..6812560bee3c 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -324,9 +324,6 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
 
 	resctrl_arch_rmid_read_context_check();
 
-	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
-		return -EINVAL;
-
 	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
 	ret = __rmid_read_phys(prmid, eventid, &msr_val);
 	if (ret)
@@ -592,7 +589,10 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
 
 static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 {
+	int cpu = smp_processor_id();
+	struct rdt_mon_domain *d;
 	struct mbm_state *m;
+	int err, ret;
 	u64 tval = 0;
 
 	if (rr->first) {
@@ -603,14 +603,46 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		return 0;
 	}
 
-	rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid, rr->evtid,
-					 &tval, rr->arch_mon_ctx);
-	if (rr->err)
-		return rr->err;
+	if (rr->d) {
+		/* Reading a single domain, must be on a CPU in that domain. */
+		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
+			return -EINVAL;
+		rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
+						 rr->evtid, &tval, rr->arch_mon_ctx);
+		if (rr->err)
+			return rr->err;
 
-	rr->val += tval;
+		rr->val += tval;
 
-	return 0;
+		return 0;
+	}
+
+	/* Summing domains that share a cache, must be on a CPU for that cache. */
+	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
+		return -EINVAL;
+
+	/*
+	 * Legacy files must report the sum of an event across all
+	 * domains that share the same L3 cache instance. But newly
+	 * created domains with no traffic may report -EINVAL/Unavailable.
+	 * Report success if a read from any domain succeeds.
+	 */
+	ret = -EINVAL;
+	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
+		if (d->ci->id != rr->ci->id)
+			continue;
+		err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
+					     rr->evtid, &tval, rr->arch_mon_ctx);
+		if (!err) {
+			rr->val += tval;
+			ret = 0;
+		}
+	}
+
+	if (ret)
+		rr->err = ret;
+
+	return ret;
 }
 
 /*
-- 
2.45.2

