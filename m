Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54844307AEB
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 20:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764881660; cv=none; b=uFZzflxKOW3PZwMSaeNszMDyuWGJazm3NoKGWpLKNpsneoE2lTY+z9kllE827nwSsJfU0nZ0Zi7dMdFZz2Bh+/b4vzPHsC1YZSkYnNKuSZS/IvI9nZAsThvj5DOnXy1kXV4OL1zZR4Q00s19EzotYbHW+7LKH5LuoXSlLvg9xK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764881660; c=relaxed/simple;
	bh=ZWm7hPc2pA5FN4dZKCDkSqVyPN+dNMQhermj0QSQ+fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4EtCfyLpmjXIh4DrTc1/IIEulGfrXUtF3oO92DgN5QwnhHy5r25JXhfov2GrfstjjzhNU0Z0p3KzZiBfz+IHgPpwcqE2TwZEQIuJckpgmTYBz7B3Fpl3bYRaJHFbGIMqi5oSMEAFFh9sJT9pNuFigN2GYngcdh57lDKLyrckEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SRdEQtBD; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SRdEQtBD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764881658; x=1796417658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZWm7hPc2pA5FN4dZKCDkSqVyPN+dNMQhermj0QSQ+fo=;
  b=SRdEQtBDwdzQwHiZk3BHENOKB203pk7WXOlfv2vKj2DLeCBlHAWC5/Wx
   8/L9GPMamKmTzYk+2iiJ19aKHGa6MLy6XGXc9JFKhxDab27t5JVAf5ZNx
   /rXypVADOOgsFP7cnB4qTPmgtomKXLt6QVxbJnl/30RX2/QlP8IwKFLL+
   9hHNA0QE8RAnXrdrcOApC8PQ2zh/PI77/FjYcVylgYrJ45Y1HhzMcmwJS
   cyJIUsElhIGG/pya/2xYcMmXarFmMZchODxL2BL5uPGpPAGUzVOlv0ypr
   iuuZVo//HKh6jVJS83Qmnt/g7wrAjUTiT1oyKncnJW8rZaEvpeFKA709i
   Q==;
X-CSE-ConnectionGUID: F7PrLhoRRRWJAe6wpl1CCQ==
X-CSE-MsgGUID: XFQT56HhTh+WMr4gvH6NbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="69510887"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="69510887"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:16 -0800
X-CSE-ConnectionGUID: pyinPHR5SquCoeITzYp56w==
X-CSE-MsgGUID: SYTCYtiMTyaDagPWLQMX8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225752743"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.165])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 12:54:16 -0800
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
Subject: [PATCH v15 06/32] fs/resctrl: Split L3 dependent parts out of __mon_event_count()
Date: Thu,  4 Dec 2025 12:53:36 -0800
Message-ID: <20251204205404.12763-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251204205404.12763-1-tony.luck@intel.com>
References: <20251204205404.12763-1-tony.luck@intel.com>
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
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/monitor.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 572a9925bd6c..b5e0db38c8bf 100644
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
@@ -494,6 +494,17 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	return ret;
 }
 
+static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
+{
+	switch (rr->r->rid) {
+	case RDT_RESOURCE_L3:
+		return __l3_mon_event_count(rdtgrp, rr);
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

