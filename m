Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5F92D5957
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010489; cv=none; b=rWkUjcD2xQnoLZYF+BYC82O/yZjdIO68A2PiqBHS8ls4he6GJV4e3jVDV8dzqCyrG/+5cQVxWg09xZNxtI6Hpq3KFivWu26RKjGb/ch478Bo9MZ924PCJOucw+BlX+4UlHyUmJdM5tGSMF44Wi1NgRAYHx47Jp9qlHr+OdU3y1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010489; c=relaxed/simple;
	bh=T0pledc9NIwFCM7bjxrvqASAAUwPfvukY1vMLOaAJq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZ6uU4R3EkcHuUMEGH+iGgwGowWNih0hUI0V66lEXsEhafnCMa9ocQ1ChgSUi/+yTB3wBT+NXuoAMru2+pU7Yf4BTEO0o1Mz8DD7oFltLlUszX6nqn2EMzxZbO7fjE97CIYYaXy9/3uZ+evwUXfJXnbBlVwiUl3koDkzJx9ipyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bDjQgZEJ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bDjQgZEJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010487; x=1795546487;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T0pledc9NIwFCM7bjxrvqASAAUwPfvukY1vMLOaAJq4=;
  b=bDjQgZEJLxkUnkcuEJyitB3koztJQVn3aBNK1JSobAkRFbrHEl+cHCK2
   Aph8pshbzTf2J6HN3FIwPoTpwJlpOAUOyfaXYAA1d8/EdiWdLcrD3tLox
   IqCNRno2RQwegMjv373EA4ZR4jjOcyifWnPlqTo7Oxqt6BPqxY60PdrN2
   m6LwjgRFG9WNV9eRiCCExfdg3YQzxD+RsnqGg5A+64I081k0Z0sETdD8b
   /zWUTOD6eBX7X7VNsUmpfKoUhBDZf/3WFyR19qJroWwUxc2yAojKDBsKw
   I356NuTm5Zz/GwUlMhCZknvsKOUvDOZCLiUCsNM6MvgmsdJTTCneCAAef
   w==;
X-CSE-ConnectionGUID: z9rmiecDQLq1mrCroYHP1w==
X-CSE-MsgGUID: rlIFpGc0SqqM353l1wGMGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636499"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636499"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:23 -0800
X-CSE-ConnectionGUID: QNjlbCW6TBita6Ye6YgUHQ==
X-CSE-MsgGUID: RGJvCF8LRNuR7a1Qsf+T+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192224959"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:23 -0800
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
Subject: [PATCH v14 06/32] fs/resctrl: Split L3 dependent parts out of __mon_event_count()
Date: Mon, 24 Nov 2025 10:53:43 -0800
Message-ID: <20251124185412.24155-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124185412.24155-1-tony.luck@intel.com>
References: <20251124185412.24155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Carve out the L3 resource specific event reading code into a separate helper
to support reading event data from a new monitoring resource.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/monitor.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 572a9925bd6c..179962a81362 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -413,7 +413,7 @@ static void mbm_cntr_free(struct rdt_mon_domain *d, int cntr_id)
 	memset(&d->cntr_cfg[cntr_id], 0, sizeof(*d->cntr_cfg));
 }
 
-static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
+static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 {
 	int cpu = smp_processor_id();
 	u32 closid = rdtgrp->closid;
@@ -494,6 +494,18 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	return ret;
 }
 
+static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
+{
+	switch (rr->r->rid) {
+	case RDT_RESOURCE_L3:
+		return __l3_mon_event_count(rdtgrp, rr);
+
+	default:
+		rr->err = -EINVAL;
+		return -EINVAL;
+	}
+}
+
 /*
  * mbm_bw_count() - Update bw count from values previously read by
  *		    __mon_event_count().
-- 
2.51.1

