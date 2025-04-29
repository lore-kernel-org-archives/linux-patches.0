Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B745B1A5BB0
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 00:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886858; cv=none; b=Oa4crc4kkeVVc+QoyYi88JeXQdnYWQKk2T8dJUrMhyds9BZeBUhwNiAiHbleGM8XM6tr5DbuBCJUeW7nGZvrMzNg1HSoWmOpocuTU3hrHYJQ2ugXNEMRMlu3i8i5tFurdDrWaxWytFYbrtvrOTHODIB16xSj6tcNOJZyEP+1/3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886858; c=relaxed/simple;
	bh=aZLZ0EH5C41avMnEPqdeWhsl/dnt2eLJe5QUYjid18Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hgp6NvfJZ5Ct7KYrk+HRFtcRVoktYoUX9p1EKQZ024cj8TJL2vO/4an1z3RglCOlBbt6dYtqDhZFsfJDf6kezx53EtGP09A7xTFr3q8cxNJSHx9M+p8sOzI47cZlrIQif6292soo0hot/6BZ5tfOgwU0MMmM/X+dbHOeGeai7TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HZRD9U8p; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HZRD9U8p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745886856; x=1777422856;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aZLZ0EH5C41avMnEPqdeWhsl/dnt2eLJe5QUYjid18Y=;
  b=HZRD9U8pdtUDBYaVmn57Hd1kbCk5flepr2sVe7H2eV7CKyhrOi6xsXgS
   BewZB59/vEg5SPIXhGT9rmeO5fbK9nE58oySK46xdyU8158ANQfvaxARF
   +jDR9p9LFrM9ow9RoSL7n9BK3Obtc+ILumiovfw9wPMPjvTLi5LckAwDV
   HZewbgnVMGJD0nKvKLrlZvK51t78UTUCnB9tj5qp8Le9u+8tCIQB9WAkU
   4l97bpW1n9HrQ8sTGKvOoeZODtMykpeFNjzZQ6PeDp7H3nH/jSa5iMv51
   7Q6SCFKqPEJUgv+WmRigGy3h6JASeLrYDpspz7eerlvi8CxLgROGFGEkf
   A==;
X-CSE-ConnectionGUID: cp69PC20TDiNLDG8Lc+BMg==
X-CSE-MsgGUID: kGCJvDB3SHWGEHJ8XSHLog==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="58148118"
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="58148118"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:12 -0700
X-CSE-ConnectionGUID: LCzWPjHoQKmcjHX5ssYYQg==
X-CSE-MsgGUID: SGFVKDZlTd+UlxHqh2BW5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,247,1739865600"; 
   d="scan'208";a="133393987"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2025 17:34:11 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 09/31] x86,fs/resctrl: Refactor domain_remove_cpu_mon() ready for new domain types
Date: Mon, 28 Apr 2025 17:33:35 -0700
Message-ID: <20250429003359.375508-10-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250429003359.375508-1-tony.luck@intel.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RDT_RESOURCE_L3 resource carries a lot of state in the domain
structures which needs to be dealt with when a domain is taken offline
by removing the last CPU in the domain.

Refactor so all the L3 processing is separated from general actions of
clearing the CPU bit in the mask and removing directories from mon_data.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 14 ++++++++------
 fs/resctrl/rdtgroup.c              |  5 ++++-
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index d48cdc85a86d..525439029865 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -645,17 +645,19 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 	if (check_domain_header(hdr, RESCTRL_MON_DOMAIN, r->rid))
 		return;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
-	hw_dom = resctrl_to_arch_mon_dom(d);
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
+		return;
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
+	switch (r->rid) {
+	case RDT_RESOURCE_L3:
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		hw_dom = resctrl_to_arch_mon_dom(d);
 		resctrl_offline_mon_domain(r, d);
 		list_del_rcu(&d->hdr.list);
 		synchronize_rcu();
 		free_l3_mon_domain(hw_dom);
-
-		return;
+		break;
 	}
 }
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index a0d2be84832c..a65f3e16bdab 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4042,6 +4042,9 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	if (resctrl_mounted && resctrl_arch_mon_capable())
 		rmdir_mondata_subdir_allrdtgrp(r, d);
 
+	if (r->rid != RDT_RESOURCE_L3)
+		goto done;
+
 	if (resctrl_is_mbm_enabled())
 		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
@@ -4058,7 +4061,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
 	}
 
 	domain_destroy_mon_state(d);
-
+done:
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-- 
2.48.1

