Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D054263C8A
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992112; cv=none; b=SdfsbELzzQsooj7hf8sfHzhA4tb2oSpeFqnBjKZFXSx8g9dVnCFXO9e18OtHxrdVYklMCVGj/+rl0JnZPw9YkLtkSFK1XGrjze+S8q+FhsyPQuJftQEXHDR2kL0r6cULJSG+lxmqcB3HPMiCMWi1xvrn+/lK5pfbJlX693lxByo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992112; c=relaxed/simple;
	bh=L24aWggpIW1gmB0opROTv+D3aidHY2GKEO2b07UQ5DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6CbGsVLfL3UM450kfoFhLCmEtOBCskoE0Sbv4B7nJTQykUsPSiY+TflD4sh64BbLxCzkBRm1dFPtzQHEQ/LCW9f4lNMBc9o4icCEo0Uxn4NQGaqR+YwGUcnWup9x+I/Ntkp0qIfKmk4e4onLQFNHzjOAlcbllVehh52iMi4DRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ha4xUNYr; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ha4xUNYr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765992108; x=1797528108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L24aWggpIW1gmB0opROTv+D3aidHY2GKEO2b07UQ5DE=;
  b=Ha4xUNYrwD37wV6fuF7/un49+dEHFMGLQ5k3jBZvjhlvumx8otlPRzVT
   Dfay0hm+wHGp2XudwEvJ4iUXg/P/TKyr/YkTqui0JLYMMKeO7p12eugJr
   dEIXko+qm3PtiXjajVp/6Zu223JSLAqdv3q7ONFEC048ezmo9LkhFIvLi
   WMnM9QxSwPVOcRUNEzTCiP3HG+nLovu0KrjANUgvG+N4Zs4+kFnsfHZ5L
   13AtZN53OemfB36bLYIFr5IWI6eaz8etadVKp9jU90hNjEVlt9szdkXGe
   YfeXPBFIYR2gEvlSnkNkU7UXesuHpYzyHkorYokPi9E4dgjpb/F5MYg7Q
   w==;
X-CSE-ConnectionGUID: 1oQylr/zQpG1/fJugJygSA==
X-CSE-MsgGUID: oUptLOKlSEyvXhwulEiQ5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="90594657"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="90594657"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:32 -0800
X-CSE-ConnectionGUID: KVPqgzluRHeHCUMRJ3XNwA==
X-CSE-MsgGUID: ZvwKCmNySMa+g3fYbpaHsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="221748166"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.131])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:21:32 -0800
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
Subject: [PATCH v17 06/32] fs/resctrl: Split L3 dependent parts out of __mon_event_count()
Date: Wed, 17 Dec 2025 09:20:53 -0800
Message-ID: <20251217172121.12030-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217172121.12030-1-tony.luck@intel.com>
References: <20251217172121.12030-1-tony.luck@intel.com>
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
2.52.0

