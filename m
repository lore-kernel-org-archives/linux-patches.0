Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04D2322A32
	for <patches@lists.linux.dev>; Thu, 25 Sep 2025 20:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758830660; cv=none; b=nhOzu29ISj/yA64076/I+qp2l+ioHSHH99GUaGKLNh583BCK8GUBBKdQhUE0lCWbSKlAp4SQI/+fdD0ILscti0hwL1sGclfTJ7e3ipkRoy1d5uoe71PqKNKL04u4MWujP+gA2YwfFuDWvK+e31OXRGcBsGBAHVgjeekEFoozabM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758830660; c=relaxed/simple;
	bh=/RsJXpchbZOQWLP1rBycPqcyp3pfyqvgNkBpbmu913M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHXiexHGfpAZx3i8Xlo7HwAWZ+XXngRZIHaWsdTs0pONdIp2Ks+yCcJx48s54xntnK+vySOWGr+E4MPSIWY3WRie8blD6M+Xqp3iho9ziEsWOEoOopLRGwdDcUKr8XwXZU5wJ4Zc4cetD5LoF6iK0OiEAJmF4v3bf6f3qs+zm+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YrnbJAAk; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YrnbJAAk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758830658; x=1790366658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/RsJXpchbZOQWLP1rBycPqcyp3pfyqvgNkBpbmu913M=;
  b=YrnbJAAkLb7kJ9VF7iB++5nzn0px00kh0dDwl0OpTkjzv/x3IzzPjfVh
   uyL/pATQiHmau8dd9UyoNsC4jaaS63NGtuvv+q4Ub305ZK5Wa+PkU7gC3
   zU8KS6WV7EOo0tzLWcP3uy/xzlunLyfXpeQULa9rTSd14YNVeYgvN+Vht
   pfFoAhJxQV94MM6W3e3ooOOPEJ3C5cAAqolUtmVuVUZ7Ahj64yMtvHdpe
   3P5ygX/7+HhhdcGxZlciURrHcztDYaXiZ8mPwWhoyuc9SJX0nK8CLkz5h
   3sFkqyNAsrgUsl3LKBP0vFAC2xUuOK2xkZcbf9H6pjRLviorHvpWioWnj
   g==;
X-CSE-ConnectionGUID: 3WAlQdngRXa6/xFFi4Qvng==
X-CSE-MsgGUID: wFsgj3aDQjad6YQV2LNnmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61074286"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61074286"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:11 -0700
X-CSE-ConnectionGUID: 1zdtfjHiR3K3ZB9T8hxgQg==
X-CSE-MsgGUID: MU6+2s2KTY21b+dV9a7frQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177003662"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.220.206])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 13:04:11 -0700
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
Subject: [PATCH v11 18/31] fs/resctrl: Refactor L3 specific parts of __mon_event_count()
Date: Thu, 25 Sep 2025 13:03:12 -0700
Message-ID: <20250925200328.64155-19-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925200328.64155-1-tony.luck@intel.com>
References: <20250925200328.64155-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The "MBM counter assignment" and "reset counter on first read" features
are only applicable to the RDT_RESOURCE_L3 resource.

Add a check for the RDT_RESOURCE_L3 resource.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/monitor.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 1eb054749d20..d484983c0f02 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -453,27 +453,29 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	if (!cpu_on_correct_domain(rr))
 		return -EINVAL;
 
-	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
-		return -EINVAL;
-	d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
-
-	if (rr->is_mbm_cntr) {
-		cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evt->evtid);
-		if (cntr_id < 0) {
-			rr->err = -ENOENT;
+	if (rr->r->rid == RDT_RESOURCE_L3) {
+		if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 			return -EINVAL;
+		d = container_of(rr->hdr, struct rdt_l3_mon_domain, hdr);
+
+		if (rr->is_mbm_cntr) {
+			cntr_id = mbm_cntr_get(rr->r, d, rdtgrp, rr->evt->evtid);
+			if (cntr_id < 0) {
+				rr->err = -ENOENT;
+				return -EINVAL;
+			}
 		}
-	}
 
-	if (rr->first) {
-		if (rr->is_mbm_cntr)
-			resctrl_arch_reset_cntr(rr->r, d, closid, rmid, cntr_id, rr->evt->evtid);
-		else
-			resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evt->evtid);
-		m = get_mbm_state(d, closid, rmid, rr->evt->evtid);
-		if (m)
-			memset(m, 0, sizeof(struct mbm_state));
-		return 0;
+		if (rr->first) {
+			if (rr->is_mbm_cntr)
+				resctrl_arch_reset_cntr(rr->r, d, closid, rmid, cntr_id, rr->evt->evtid);
+			else
+				resctrl_arch_reset_rmid(rr->r, d, closid, rmid, rr->evt->evtid);
+			m = get_mbm_state(d, closid, rmid, rr->evt->evtid);
+			if (m)
+				memset(m, 0, sizeof(struct mbm_state));
+			return 0;
+		}
 	}
 
 	if (rr->hdr) {
-- 
2.51.0

