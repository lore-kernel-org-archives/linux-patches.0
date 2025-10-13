Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E3E30BBB0
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 22:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394853; cv=none; b=bpy3bXFBOUEUDawNc/jUz0IY7BZExzVaaoSqZyIwbftcHtsOoNn49BkoKFg+TOW5r0MyRSkxNHKTeUrlStw8NBwiwNUgZg6UtHhIaj+HsL3Arh0rEg5LDKKQhs3rZXkoFzyYejaSH9ANKiwa0GbRIjWmtomyrMmXTl1fULjBD4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394853; c=relaxed/simple;
	bh=kWaREN+qw5U+9WEOQnBR6QUpwJLrakooKUdGQZpPzG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBtw9wv9qx3i8dUOatleZ9PkuG3fc1Mn/18Atw/CoAWipYqc0kziM0KKYCRA9jmOj9V+yn5lgtQIhJ8TfcM60c8DH5FvO78+kWqaZaVjWymNH3S0uadVBi1muMc8B5EPLbRIh9jierUPySni1yVX43FEplx2dRqYE0sH64c8e/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E2WOeu7f; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E2WOeu7f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760394852; x=1791930852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kWaREN+qw5U+9WEOQnBR6QUpwJLrakooKUdGQZpPzG0=;
  b=E2WOeu7fuu00ocYYxZ3FJJmuZVeLJMLNmrRZ81nybrpYF2I99bfIDCnM
   haJBCqkVlMWr20EXe7DwQR/tqKsfiIK3V3Jk6FT5HM5flps4ZhorMNVzX
   TgCbd8aKrNRGaMF18SnvO49VMvC83xR1JAg/wuqia3ujG1z0p1/ofn49w
   X1z154s1enlbFf83lvm0d0+7PPKJVYobLrQjL3PX6tnYSOjTbr1QZxLdy
   nTBI/qcU13WrawmpxpuEKN6zWeh3u4BU6V8NBx70SnUjDQGX6FvmkVH5V
   xksX0xFXSrBcVh+9TMytven+Nb4KF4bRM9nSAgn/awD8kldrexw3F8LHG
   g==;
X-CSE-ConnectionGUID: zRBJvLuzTxKGbrdi5v9Mcg==
X-CSE-MsgGUID: Nhk++rBqTOm51aFX1cNRLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="85168882"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="85168882"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:02 -0700
X-CSE-ConnectionGUID: jE/C/8ymT3yXNThnJNhRwQ==
X-CSE-MsgGUID: 3QZcjLCYR2mqqD6nzbD8iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="182145307"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.79])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 15:34:02 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v12 18/31] fs/resctrl: Split L3 dependent parts out of __mon_event_count()
Date: Mon, 13 Oct 2025 15:33:32 -0700
Message-ID: <20251013223348.103390-19-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013223348.103390-1-tony.luck@intel.com>
References: <20251013223348.103390-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Almost all of the code in __mon_event_count() is specific to the RDT_RESOURCE_L3
resource.

Split it out into __l3_mon_event_count().

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/monitor.c | 70 ++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 31 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 895cf5b0f524..faaa2851c5c2 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -415,32 +415,7 @@ static void mbm_cntr_free(struct rdt_l3_mon_domain *d, int cntr_id)
 	memset(&d->cntr_cfg[cntr_id], 0, sizeof(*d->cntr_cfg));
 }
 
-/*
- * Called from preemptible context via a direct call of mon_event_count() for
- * events that can be read on any CPU.
- * Called from preemptible but non-migratable process context (mon_event_count()
- * via smp_call_on_cpu()) OR non-preemptible context (mon_event_count() via
- * smp_call_function_any()) for events that need to be read on a specific CPU.
- */
-static bool cpu_on_correct_domain(struct rmid_read *rr)
-{
-	int cpu;
-
-	/* Any CPU is OK for this event */
-	if (rr->evt->any_cpu)
-		return true;
-
-	cpu = smp_processor_id();
-
-	/* Single domain. Must be on a CPU in that domain. */
-	if (rr->hdr)
-		return cpumask_test_cpu(cpu, &rr->hdr->cpu_mask);
-
-	/* Summing domains that share a cache, must be on a CPU for that cache. */
-	return cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map);
-}
-
-static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
+static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 {
 	u32 closid = rdtgrp->closid;
 	u32 rmid = rdtgrp->mon.rmid;
@@ -450,9 +425,6 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	int err, ret;
 	u64 tval = 0;
 
-	if (!cpu_on_correct_domain(rr))
-		return -EINVAL;
-
 	if (rr->is_mbm_cntr) {
 		if (!rr->hdr || !domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 			return -EINVAL;
@@ -504,8 +476,6 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	 * all domains fail for any reason.
 	 */
 	ret = -EINVAL;
-	if (WARN_ON_ONCE(rr->r->rid != RDT_RESOURCE_L3))
-		return ret;
 
 	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
 		if (d->ci_id != rr->ci->id)
@@ -529,6 +499,44 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	return ret;
 }
 
+/*
+ * Called from preemptible context via a direct call of mon_event_count() for
+ * events that can be read on any CPU.
+ * Called from preemptible but non-migratable process context (mon_event_count()
+ * via smp_call_on_cpu()) OR non-preemptible context (mon_event_count() via
+ * smp_call_function_any()) for events that need to be read on a specific CPU.
+ */
+static bool cpu_on_correct_domain(struct rmid_read *rr)
+{
+	int cpu;
+
+	/* Any CPU is OK for this event */
+	if (rr->evt->any_cpu)
+		return true;
+
+	cpu = smp_processor_id();
+
+	/* Single domain. Must be on a CPU in that domain. */
+	if (rr->hdr)
+		return cpumask_test_cpu(cpu, &rr->hdr->cpu_mask);
+
+	/* Summing domains that share a cache, must be on a CPU for that cache. */
+	return cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map);
+}
+
+static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
+{
+	if (!cpu_on_correct_domain(rr))
+		return -EINVAL;
+
+	switch (rr->r->rid) {
+	case RDT_RESOURCE_L3:
+		return __l3_mon_event_count(rdtgrp, rr);
+	default:
+		return -EINVAL;
+	}
+}
+
 /*
  * mbm_bw_count() - Update bw count from values previously read by
  *		    __mon_event_count().
-- 
2.51.0

