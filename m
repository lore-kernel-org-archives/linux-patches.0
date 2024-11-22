Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F901CEAC3
	for <patches@lists.linux.dev>; Fri, 22 Nov 2024 23:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732319922; cv=none; b=r6NPlR/utVPDSufsyT9GX7PQ2VJ16/BaLCRUv3+oxYp9+YkPKtARwuO7zIelg9lQnhS8PJH9aY27vFr97gQyvFzb0OhT+KO7uu6RZl+srs8hAhfTnV7R8kuUVqHitjvAV12qU2H2vbnMrjwfexBcGWZYA+LKaEfFtMmG4/5Fcg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732319922; c=relaxed/simple;
	bh=28d3tajIB1I9f5LK3PdnSh/I+O/CCvwrrBrwaxDseR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pmc5P/SAc+j3gbFUG3+3bhz3tWkwmwaxVLgaShNN5OySoyXK7rJV4S8NwXocXb7xx8cHB+lnzjHKrHA2+b80QyfB2XDJyqasPgdIDY867GlFKUzC9xI/BwS+utTmF0tdEwpE8V3iaWg439OaVGThjzk70HZTFB9/p+4+AhVjY60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZS8IzdSG; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZS8IzdSG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732319922; x=1763855922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=28d3tajIB1I9f5LK3PdnSh/I+O/CCvwrrBrwaxDseR8=;
  b=ZS8IzdSG8YRt3EB0MjiBLfUgqH96w0sJ+0lmFhJREU6EJ2xQQoSbOwIe
   ErUHffR14FxRvR5fDKGLG08kaVnd4T+C80D0kP2gtKgq8LuYb2Lor2gLC
   hZ6PIddK7JkHKCQ0yEslGUr+qJ908sghkiEHr26xtnLK8bqBf26LosjWI
   viLYZfi4jRxdQZ4xa80/cYz+4WMg3mkDVzhra1meM5g63LBtnSk83nFpO
   TIQ8ZJsGab26kh/9e37IhZyuCLn/XRTemvydKwDXecdgIttFcFZ97+j95
   d+oywfDiQqrztgYv7XlJtXk03+rUWVPt1IXNTrmdILY45g6B8VI9h2zdG
   A==;
X-CSE-ConnectionGUID: oEeEhOstRZGdI+GLD7RXAA==
X-CSE-MsgGUID: qglVw8ycR5+1z6X1NZK0EA==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32642724"
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="32642724"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 15:58:39 -0800
X-CSE-ConnectionGUID: RVFT7FKvRBe7cuw6QGf2BQ==
X-CSE-MsgGUID: tETC5iWzQMyLcVvt1ZLGGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,177,1728975600"; 
   d="scan'208";a="90850902"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 15:58:38 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v10 4/8] x86/resctrl: Compute memory bandwidth for all supported events
Date: Fri, 22 Nov 2024 15:58:28 -0800
Message-ID: <20241122235832.27498-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241122235832.27498-1-tony.luck@intel.com>
References: <20241122235832.27498-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switching between local and total memory bandwidth events as the input
to the mba_sc feedback loop would be cumbersome and take effect slowly
in the current implementation as the bandwidth is only known after two
consecutive readings of the same event.

Compute the bandwidth for all supported events. This doesn't add
significant overhead and will make changing which event is used
simple.

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 72 ++++++++++++---------------
 1 file changed, 33 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 6fe2e6ab8dd4..4ca38bc9dd96 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -663,9 +663,12 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
  */
 static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
 {
-	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
-	struct mbm_state *m = &rr->d->mbm_local[idx];
 	u64 cur_bw, bytes, cur_bytes;
+	struct mbm_state *m;
+
+	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
+	if (WARN_ON_ONCE(!m))
+		return;
 
 	cur_bytes = rr->val;
 	bytes = cur_bytes - m->prev_bw_bytes;
@@ -815,54 +818,45 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
 	resctrl_arch_update_one(r_mba, dom_mba, closid, CDP_NONE, new_msr_val);
 }
 
-static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
-		       u32 closid, u32 rmid)
+static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *d,
+				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
 {
 	struct rmid_read rr = {0};
 
 	rr.r = r;
 	rr.d = d;
+	rr.evtid = evtid;
+	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
+	if (IS_ERR(rr.arch_mon_ctx)) {
+		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
+				    PTR_ERR(rr.arch_mon_ctx));
+		return;
+	}
+
+	__mon_event_count(closid, rmid, &rr);
 
 	/*
-	 * This is protected from concurrent reads from user
-	 * as both the user and we hold the global mutex.
+	 * If the software controller is enabled, compute the
+	 * bandwidth for this event id.
 	 */
-	if (is_mbm_total_enabled()) {
-		rr.evtid = QOS_L3_MBM_TOTAL_EVENT_ID;
-		rr.val = 0;
-		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
-		if (IS_ERR(rr.arch_mon_ctx)) {
-			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
-					    PTR_ERR(rr.arch_mon_ctx));
-			return;
-		}
+	if (is_mba_sc(NULL))
+		mbm_bw_count(closid, rmid, &rr);
 
-		__mon_event_count(closid, rmid, &rr);
-
-		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
-	}
-	if (is_mbm_local_enabled()) {
-		rr.evtid = QOS_L3_MBM_LOCAL_EVENT_ID;
-		rr.val = 0;
-		rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
-		if (IS_ERR(rr.arch_mon_ctx)) {
-			pr_warn_ratelimited("Failed to allocate monitor context: %ld",
-					    PTR_ERR(rr.arch_mon_ctx));
-			return;
-		}
-
-		__mon_event_count(closid, rmid, &rr);
+	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
+}
 
-		/*
-		 * Call the MBA software controller only for the
-		 * control groups and when user has enabled
-		 * the software controller explicitly.
-		 */
-		if (is_mba_sc(NULL))
-			mbm_bw_count(closid, rmid, &rr);
+static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
+		       u32 closid, u32 rmid)
+{
+	/*
+	 * This is protected from concurrent reads from user as both
+	 * the user and overflow handler hold the global mutex.
+	 */
+	if (is_mbm_total_enabled())
+		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_TOTAL_EVENT_ID);
 
-		resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
-	}
+	if (is_mbm_local_enabled())
+		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_LOCAL_EVENT_ID);
 }
 
 /*
-- 
2.47.0

