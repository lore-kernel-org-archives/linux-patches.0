Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50FB1527A1
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 18:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718044551; cv=none; b=Tiof8pClyZ9VFBQsMqNGiMj1zY5+aBMtNmjoSk4TLD2vy1oCM9mm674adO1YYKQULf8PAiowjZ6hglP5KTCPlaHPE3LTyxdav0O/uwkmeMB7yVQm5jWDtvDAmOz8xssXVaCiUB4Cd9xo/jzpL4mKBE0nP26m+/xQzRJYN9sRn5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718044551; c=relaxed/simple;
	bh=MOVo9LCjnBkFDTv0jmvksxP4b4C/NsmyRHbJP3G3/Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQ+r1RuLw/vP8RMpNmEeE1pI3qkXcNIepsHrjVkuBUWeuI1ne+Oxh/Ikq3xTYjHXIMtQCpS0OLR4TvHjuapXHWTi2BydBZcO4EGu2KKpjihvWlhYZmQyek2OqBLVYxC91Mx8oOBjKixkKbdOl1KMbZznEs7tOikQ0zXp942sHn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WGv2XywV; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WGv2XywV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718044550; x=1749580550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MOVo9LCjnBkFDTv0jmvksxP4b4C/NsmyRHbJP3G3/Hs=;
  b=WGv2XywVURILZUrs+kTzq3y+oBAWSMDgVfTGa4PuSmpVR/rRswXDNmUR
   bheAZNWIDP+VrbV/s9gXF3OnPzrdJc0BfZqNoKHRq3YSERqdCvkjuSgD2
   8A1bf2WRD4Ckx1IQ304psn3tXbR0spNPdOi4dckz0dYEErKj4FAvj+bd/
   /BVvZzuE5PyjUp6aH0T/vYNGi6ZBZwWCXSUHpt1GKAJXXgLzqgjaj0VoT
   vK2TywDIyZR9SA0UBChFEEb7nyxLj9JQw6D+1K3Hz5SyRLkm4H0A2elGj
   XzqfUDHf9A6utJ73S6UYDtSESw9tYjYs0C81wtMZHWHPmZ2avV7s7tqMw
   Q==;
X-CSE-ConnectionGUID: 138x+WAgT0SR6W2yjAAcSw==
X-CSE-MsgGUID: zy6tAPU+R+WGAZtQ5PN/rg==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="12004864"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="12004864"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:38 -0700
X-CSE-ConnectionGUID: D6ytpHxqRU29qUObdZX60w==
X-CSE-MsgGUID: UYX+K0vvRmeRJnMBYr3ALQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="43576593"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:39 -0700
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
Subject: [PATCH v20 14/18] x86/resctrl: Fill out rmid_read structure for smp_call*() to read a counter
Date: Mon, 10 Jun 2024 11:35:24 -0700
Message-ID: <20240610183528.349198-15-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240610183528.349198-1-tony.luck@intel.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mon_event_read() fills out most fields of the struct rmid_read that is
passed via an smp_call*() function to a CPU that is part of the correct
domain to read the monitor counters.

With Sub-NUMA Cluster (SNC) mode there are now two cases to handle:

1) Reading a file that returns a value for a single domain.
   + Choose the CPU to execute from the domain cpu_mask

2) Reading a file that must sum across domains sharing an L3 cache
   instance.
   + Indicate to called code that a sum is needed by passing a NULL
     rdt_mon_domain pointer.
   + Choose the CPU from the L3 shared_cpu_map.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h    |  2 +-
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 39 ++++++++++++++++++-----
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  2 +-
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 77da29ced7eb..75bb1afc4842 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -627,7 +627,7 @@ void mon_event_count(void *info);
 int rdtgroup_mondata_show(struct seq_file *m, void *arg);
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
-		    int evtid, int first);
+		    cpumask_t *cpumask, int evtid, int first);
 void mbm_setup_overflow_handler(struct rdt_mon_domain *dom,
 				unsigned long delay_ms,
 				int exclude_cpu);
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 3b9383612c35..5a43931fd423 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -515,7 +515,7 @@ static int smp_mon_event_count(void *arg)
 
 void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
-		    int evtid, int first)
+		    cpumask_t *cpumask, int evtid, int first)
 {
 	int cpu;
 
@@ -537,7 +537,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		return;
 	}
 
-	cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask, RESCTRL_PICK_ANY_CPU);
+	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
 
 	/*
 	 * cpumask_any_housekeeping() prefers housekeeping CPUs, but
@@ -546,7 +546,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	 * counters on some platforms if its called in IRQ context.
 	 */
 	if (tick_nohz_full_cpu(cpu))
-		smp_call_function_any(&d->hdr.cpu_mask, mon_event_count, rr, 1);
+		smp_call_function_any(cpumask, mon_event_count, rr, 1);
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
@@ -575,16 +575,39 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 	resid = md.u.rid;
 	domid = md.u.domid;
 	evtid = md.u.evtid;
-
 	r = &rdt_resources_all[resid].r_resctrl;
-	hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
-	if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
+
+	if (md.u.sum) {
+		/*
+		 * This file requires summing across all SNC domains that share
+		 * the L3 cache id that was provided in the "domid" field of the
+		 * mon_data_bits union. Search all domains in the resource for
+		 * one that matches this cache id.
+		 */
+		list_for_each_entry(d, &r->mon_domains, hdr.list) {
+			if (d->ci->id == domid) {
+				rr.ci = d->ci;
+				mon_event_read(&rr, r, NULL, rdtgrp, &d->ci->shared_cpu_map, evtid, false);
+				goto checkresult;
+			}
+		}
 		ret = -ENOENT;
 		goto out;
+	} else {
+		/*
+		 * This file provides data from a single domain. Search
+		 * the resource to find the domain with "domid".
+		 */
+		hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
+		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
+			ret = -ENOENT;
+			goto out;
+		}
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
 	}
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
 
-	mon_event_read(&rr, r, d, rdtgrp, evtid, false);
+checkresult:
 
 	if (rr.err == -EIO)
 		seq_puts(m, "Error\n");
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 5142ce43ac13..cd54ca6cc563 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -3070,7 +3070,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 			return ret;
 
 		if (!do_sum && is_mbm_event(mevt->evtid))
-			mon_event_read(&rr, r, d, prgrp, mevt->evtid, true);
+			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
 	}
 
 	return 0;
-- 
2.45.0

