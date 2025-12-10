Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62642ECEA3
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 23:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765408480; cv=none; b=WuyOjgb+ZwCaQgddNvLYGUI6rTXFt/WsQptjPMq+ZrslDkFvAevvoqded5T2yDwHd593dA5BOChs/MXq9WKEKLSXjKqDquQMCFYF42eIa4btaENDCzXrBorMBdwLygnyVr4MC37zEV4j0WCVYZxIpha2DTPBDSVOhLQ6VS4tCcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765408480; c=relaxed/simple;
	bh=ZWm7hPc2pA5FN4dZKCDkSqVyPN+dNMQhermj0QSQ+fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhYcW89n066xhQ0CpcoIi6vdyEIgjsmN8xnpE1fZkrefP3E3g05TME3+Th3oMDl43JxvNLbgX3k/UHBNtnnrOhQVgrPIuw0Smk2DoAV8ERzYgQ3O+J3QlMAasBmJP+wBElgGNZU/HYheWkR5fjFR0lJU9d3tZSPFwTTaLn0fvrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=irNpUHdl; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="irNpUHdl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765408478; x=1796944478;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZWm7hPc2pA5FN4dZKCDkSqVyPN+dNMQhermj0QSQ+fo=;
  b=irNpUHdlA6bjAVD0zrlrhJFAWYULpcQp4uUTFJsEGCjaTBzDDatZm1tb
   x/Km1NTrB1yLtLZ2WceOlBa+fiXopa63MMpmy3SlXRoM+CNgc+2l1w8Py
   1okeS6g94nRgjCN+4oLEUU2i8N9EBjQzygA+hQc/2kdlPyvhruUn7p6kt
   53GQM/Fs7jCI+NKpyoAhU2ATiKpFXTPvoFYJD+aFWlGAzkq81bQLaP6A7
   u2Zz/ccYMHGbldlpouLmxN5wn0KWGs6zxplesGP+fZwpKtOcvecGJclH4
   VPwGxMQLMjUMF/ejXMDR++L4KzZOvZSxC1JCbYtB5St/6qgtprxXwD47S
   w==;
X-CSE-ConnectionGUID: YCDbZHSCT6Gs2YhieDrk5Q==
X-CSE-MsgGUID: lzAESIN/Tx6tZb4kNwCYIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69973523"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69973523"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:27 -0800
X-CSE-ConnectionGUID: ObJqWqlyT0upfueh4kY6aw==
X-CSE-MsgGUID: 5SP9BKi6QbCZ3ClPgjsc8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227297046"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:14:27 -0800
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
Subject: [PATCH v16 06/32] fs/resctrl: Split L3 dependent parts out of __mon_event_count()
Date: Wed, 10 Dec 2025 15:13:45 -0800
Message-ID: <20251210231413.59102-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251210231413.59102-1-tony.luck@intel.com>
References: <20251210231413.59102-1-tony.luck@intel.com>
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

