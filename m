Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8871A2FC3
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 20:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719520761; cv=none; b=INnyeq1dglgRnanY8H8fWw80DOocJliWiV4Xc8xbMe98Sm8p8vvsrksTOHDjCLDeVkXYHLf5YAvWz8dC0KIvePiLiYt5VO6mzMwj+JU9cqpRM5NAckkSBz0Z0RnEL1xgb4tJfn3tbfFfkoX6QXlaj0gUOnrvquqoIzcI2WWvDVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719520761; c=relaxed/simple;
	bh=zdAqMUk9VHyJiHDiw90uSeeCYe6sqc1oUAH918cf/OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4F2VVR4ZzvNbguLqyafVeM6RdZ9Gcyj/ZbAYG9WDNwh0QMWJtERwk0/7nxXMqyMJhNZxPrbd6wH52Mmundt+WvnZSXMnmWymvnGCQpcv5o1Lstu+uxwhEZsbDCvpcX5960Lij6W3pg0gO/BmDPz2m8OX40Gduj6Pk1LbA9519M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BiCVW+qx; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BiCVW+qx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719520759; x=1751056759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zdAqMUk9VHyJiHDiw90uSeeCYe6sqc1oUAH918cf/OY=;
  b=BiCVW+qxswnmYmW7CrBYhXAU6NlEDVtY+eWlVfrW3tR4JU+SlQ9LPQHN
   DBmFVlZs+TRNYoAtFlrGQbyJYnJnhy/BpU/cYgQ7GdsLG5hek1df/a6Q3
   kb/Ct9yMdVWywc/RbqRq21LxVMf4mFUnAa2YffugA0RorlhXni3ZfvXwA
   PprX/2jIE18AKQSlveFwkv56hl0OSrbnYvab3R0L0Qsu6ptBk6pGDkX9W
   xEA3Pbr2he6J/+N+BTJjiL1v6CQ0bL7LdaAkeh3PRehAFotJJchbfobN/
   0shTRCqDLgAPbS7nhv1Y3g/Cr3sgB9CnUEBJ3UqeQfrhVxASSSZLyjA+m
   Q==;
X-CSE-ConnectionGUID: v0B7zkmLQg69dCZ4yTS9Jw==
X-CSE-MsgGUID: CmE1j6JDR82i5mBS2TOl+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11116"; a="16809843"
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="16809843"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:11 -0700
X-CSE-ConnectionGUID: Yg5CSV4LQA24iyx2sIpRuw==
X-CSE-MsgGUID: pNxhQzCMQDuhEI4i9PSWEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,167,1716274800"; 
   d="scan'208";a="82052922"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2024 13:39:10 -0700
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
Subject: [PATCH v22 15/18] x86/resctrl: Make __mon_event_count() handle sum domains
Date: Thu, 27 Jun 2024 13:38:53 -0700
Message-ID: <20240627203856.66628-16-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240627203856.66628-1-tony.luck@intel.com>
References: <20240627203856.66628-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/monitor.c | 51 ++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index ca309c93a56b..ca486d00541e 100644
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
@@ -603,14 +603,47 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
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
+	 * domains that share the same L3 cache instance.
+	 * Report success if a read from any domain succeeds, -EINVAL
+	 * (translated to "Unavailable" for user space) if reading from
+	 * all domains fail for any reason.
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

