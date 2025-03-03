Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D40223AE66
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 23:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741044892; cv=none; b=e8zwIQpTzRuj7pDxPdRaOYPlM/DMyL/pEr4JbenSw1lhR16MemeZyCXvdRU0+SRuHdpFuy+zq7ITcRPtRFqwS3Od+05f4/0bPuusxILLNVt60SGio9Hr9iZPnLlJE9EotiFXA/8YPKQpQjMZgVko9kaUJMcx4RZvC9OB3AGmDiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741044892; c=relaxed/simple;
	bh=yy0dlVhKmEuufnCmp400TE9M9AV853wWbPKFkEusswM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGANiWhVovXcTisgDJ8iDjnBmEkvlIEgOn2TuMws+dV0PvcCCFTOYw9g8M3pz5qx4NU1U2nVkLFJ7LTY+86zVIez5uKvpyy8f359YVWGd9w7DhWv8FfmzfbB6B0yo0umKQTj+7/Mg8lz5xcn2kdwOCHglX/tHfpl9UEdkTCG6So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jWcbPQdP; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jWcbPQdP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741044890; x=1772580890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yy0dlVhKmEuufnCmp400TE9M9AV853wWbPKFkEusswM=;
  b=jWcbPQdPtAs6UAd2xJg/5Fo/whqFPj6RQVLee75lmJyGLfaSJbQSJoaX
   GEV9nE2N3TvJAuy2X8cAZOJ/UoA5gSzgGBJizLRtellb8WYVV+dfw3fz/
   sn7kBjJpafBcj0LO8cVQgy30lNcQIIlzlut4AKPxb4NizPbUjbDNfRe2k
   mewuIR0iJKO2Hjrae7SlEJvlhIy/q0/UhgiNvn4sBE3BYu0pHwH/DwRcA
   QIPTsfaoAOCWfW2Fe70G7ZbO+vhgnHl8ylXnGXeZ0sAfBrB2bqBsa6Dgn
   kKUei2zJ0oWA5VoMwi3HkV35a1SYtxJ0fOZsIvIScF6GjFip/Uht9vn5C
   A==;
X-CSE-ConnectionGUID: lCMF64gKRK2EheFo0GPjNw==
X-CSE-MsgGUID: E2wIHcYzR+ml9T9QDvxyBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41835923"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="41835923"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:34:46 -0800
X-CSE-ConnectionGUID: ZsKdpOW4SA6xeb013sQObw==
X-CSE-MsgGUID: vynoUKVTS3iMt5Uohz5NGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="117982286"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:33:50 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 04/17] x86/resctrl: Split L3 specific code out of rdtgroup_mondata_show()
Date: Mon,  3 Mar 2025 15:33:24 -0800
Message-ID: <20250303233340.333743-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250303233340.333743-1-tony.luck@intel.com>
References: <20250303233340.333743-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New monitor resources require different operations to read counters.

Move the L3 specific code to a helper function.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 79 +++++++++++++----------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 536351159cc2..515a9bec05cd 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -627,31 +627,14 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	resctrl_arch_mon_ctx_free(r, evtid, rr->arch_mon_ctx);
 }
 
-int rdtgroup_mondata_show(struct seq_file *m, void *arg)
+static int rdtgroup_l3_data_show(struct seq_file *m, struct rdt_resource *r,
+				 int domid, struct rdtgroup *rdtgrp, u32 evtid,
+				 bool sum, struct rmid_read *rr)
 {
-	struct kernfs_open_file *of = m->private;
 	struct rdt_domain_hdr *hdr;
-	struct rmid_read rr = {0};
 	struct rdt_mon_domain *d;
-	u32 resid, evtid, domid;
-	struct rdtgroup *rdtgrp;
-	struct rdt_resource *r;
-	union mon_data_bits md;
-	int ret = 0;
-
-	rdtgrp = rdtgroup_kn_lock_live(of->kn);
-	if (!rdtgrp) {
-		ret = -ENOENT;
-		goto out;
-	}
 
-	md.priv = of->kn->priv;
-	resid = md.u.rid;
-	domid = md.u.domid;
-	evtid = md.u.evtid;
-	r = &rdt_resources_all[resid].r_resctrl;
-
-	if (md.u.sum) {
+	if (sum) {
 		/*
 		 * This file requires summing across all domains that share
 		 * the L3 cache id that was provided in the "domid" field of the
@@ -660,37 +643,67 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 		 */
 		list_for_each_entry(d, &r->mon_domains, hdr.list) {
 			if (d->ci->id == domid) {
-				rr.ci = d->ci;
-				mon_event_read(&rr, r, NULL, rdtgrp,
+				rr->ci = d->ci;
+				mon_event_read(rr, r, NULL, rdtgrp,
 					       &d->ci->shared_cpu_map, evtid, false);
 				goto checkresult;
 			}
 		}
-		ret = -ENOENT;
-		goto out;
+		return -ENOENT;
 	} else {
 		/*
 		 * This file provides data from a single domain. Search
 		 * the resource to find the domain with "domid".
 		 */
 		hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
-		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
-			ret = -ENOENT;
-			goto out;
-		}
+		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN))
+			return -ENOENT;
 		d = container_of(hdr, struct rdt_mon_domain, hdr);
-		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
+		mon_event_read(rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
 	}
 
 checkresult:
 
-	if (rr.err == -EIO)
+	if (rr->err == -EIO)
 		seq_puts(m, "Error\n");
-	else if (rr.err == -EINVAL)
+	else if (rr->err == -EINVAL)
 		seq_puts(m, "Unavailable\n");
 	else
-		seq_printf(m, "%llu\n", rr.val);
+		seq_printf(m, "%llu\n", rr->val);
 
+	return 0;
+}
+
+int rdtgroup_mondata_show(struct seq_file *m, void *arg)
+{
+	struct kernfs_open_file *of = m->private;
+	struct rmid_read rr = {0};
+	u32 resid, evtid, domid;
+	struct rdtgroup *rdtgrp;
+	struct rdt_resource *r;
+	union mon_data_bits md;
+	int ret = 0;
+
+	rdtgrp = rdtgroup_kn_lock_live(of->kn);
+	if (!rdtgrp) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	md.priv = of->kn->priv;
+	resid = md.u.rid;
+	domid = md.u.domid;
+	evtid = md.u.evtid;
+	r = &rdt_resources_all[resid].r_resctrl;
+
+	switch (r->rid) {
+	case RDT_RESOURCE_L3:
+		ret = rdtgroup_l3_data_show(m, r, domid, rdtgrp, evtid, md.u.sum, &rr);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
 out:
 	rdtgroup_kn_unlock(of->kn);
 	return ret;
-- 
2.48.1

