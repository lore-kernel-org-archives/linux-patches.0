Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7022459DD
	for <patches@lists.linux.dev>; Fri, 29 Aug 2025 19:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756496040; cv=none; b=kdm0Czf/AaZbcBh7+PSitx0zY5dtGOSw2H+DosassiOC7TRN+XraiBLjhyAKFHjG+mUcocTnoPd65G8xp1pqhAEYikMH+0BBtNXpdwOK6vvlsDC94ouStfXvZvVAkthFvSGgouZ7AVXBf2EIxdGw8L7yBz1CJesJYRutarsBCuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756496040; c=relaxed/simple;
	bh=6Zn2TTL02JAoA2YPShxOLk6KCmeLMUwrfmkID4is6cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKD08Zohvdl1xW5JLa2wB3S0oNMsW+qSv+VVtf92nlg8h4TfSn5jECsM4mPTcwG4NYTLrGwd1ZnadHeKeK/YlNwXGsbHIlAnl37laTUF+WUHC0Mcr5klQbgQE/QOdZmRCc6AvXvFHr6fxamMGPliEIwH0vWGjqcWwctDog94qg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kyFV4HpK; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kyFV4HpK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756496038; x=1788032038;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Zn2TTL02JAoA2YPShxOLk6KCmeLMUwrfmkID4is6cA=;
  b=kyFV4HpK4Bt/iZS5TnPakAwXIp9KJsjD6WeFujZ/TNLjWY4hOJexmCgR
   6Z6+9NnS3COGMDaVEUR4worvJ9+aaFr8c79TVhQbOW7rQgpxuO7xRqVYs
   ujgM+HAYl6X8bNs9GEbMMASygylRtxNL0Pyy9fHCiaYHsfrd5TZ2zpykX
   fpSDxuhOYlMVg4RzVWnT+phlIPnD55GpPw4mVDt4IH//r50WI6MJlfzY7
   aRGZzQUJLnVz/MTf9nKHfnRDc3Eyt/JSH7AMP91yr2k86fA67U2VGFnza
   9Db0JTluV2ic1p+2oMockU+FZmF2szkNrtg1qMxyvtoppYFWkBMpNFHhE
   Q==;
X-CSE-ConnectionGUID: VaC81wJuTcCpMvKn03s+bA==
X-CSE-MsgGUID: 0G2RQo0VS3CxJwEsuEUykw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62625188"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62625188"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:53 -0700
X-CSE-ConnectionGUID: jNWdvQ1oRF6C70HNeGJCYA==
X-CSE-MsgGUID: 0FwLw9HHQRyNd/mUe9ZK/w==
X-ExtLoop1: 1
Received: from ldmartin-desk2.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.202])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:33:53 -0700
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
Subject: [PATCH v9 07/31] x86,fs/resctrl: Refactor domain_remove_cpu_mon() ready for new domain types
Date: Fri, 29 Aug 2025 12:33:19 -0700
Message-ID: <20250829193346.31565-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829193346.31565-1-tony.luck@intel.com>
References: <20250829193346.31565-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All monitoring events are associated with the L3 resource.

The RDT_RESOURCE_L3 resource carries a lot of state in the domain
structures which needs to be dealt with when a domain is taken offline
by removing the last CPU in the domain.

New telemetry events will be associated with a new package scoped
resource with new domain structures.

Refactor domain_remove_cpu_mon() so all the L3 processing is separate
from general actions of clearing the CPU bit in the mask and removing
sub-directories from the mon_data directory.

resctrl_offline_mon_domain() continues to remove domain specific
directories and files from the "mon_data" directories, but skips the
L3 resource specific cleanup when called for other resource types.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 21 +++++++++++++--------
 fs/resctrl/rdtgroup.c              |  5 ++++-
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 4db46c282b5c..f1b215b72844 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -646,20 +646,25 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
 		return;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
-	hw_dom = resctrl_to_arch_mon_dom(d);
+	switch (r->rid) {
+	case RDT_RESOURCE_L3:
+		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
+			return;
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		hw_dom = resctrl_to_arch_mon_dom(d);
 		resctrl_offline_mon_domain(r, d);
-		list_del_rcu(&d->hdr.list);
+		list_del_rcu(&hdr->list);
 		synchronize_rcu();
 		mon_domain_free(hw_dom);
-
-		return;
+		break;
+	default:
+		pr_warn_once("Unknown resource rid=%d\n", r->rid);
+		break;
 	}
 }
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 77336d5e4915..05438e15e2ca 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4047,6 +4047,9 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	if (resctrl_mounted && resctrl_arch_mon_capable())
 		rmdir_mondata_subdir_allrdtgrp(r, d);
 
+	if (r->rid != RDT_RESOURCE_L3)
+		goto out_unlock;
+
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
@@ -4063,7 +4066,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	}
 
 	domain_destroy_mon_state(d);
-
+out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-- 
2.50.1

