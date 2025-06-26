Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571E02F0C4B
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 16:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750956608; cv=none; b=KVlA86r3saRwwLUozkdkzkUOSBRG4D2oQ3BTXGaTI7EUR+5LGX2biorm1ZnVCraRAzXZlTMoDrPwUzClX5gCNe4kcP6KhwYbkquL6s83aWt2BARQ+dnF83IgDtok+f28v8rOucW0ABqFV9veZpSXZqo87js6+DS7MCU1cKYp7MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750956608; c=relaxed/simple;
	bh=y83k3MtJ1MImHe0mXB07hDaFkXHwfELscLworcbBB/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgqp/Pzhl17OUtSEaKlRd12YOEhcuJpO0vMg52gUVOy2pv6hMchtRTaCktbE4z180BE+R36PCAqKXA+bPiOmCvt5qZSGaOWZQuHGzF5OHfvKWEamyTVG4RF5jZQP0T/H+7m+weVwspRUi7vhoQfTq28BNecQ4ywD32aAmDORcvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HonpykEg; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HonpykEg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750956607; x=1782492607;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y83k3MtJ1MImHe0mXB07hDaFkXHwfELscLworcbBB/w=;
  b=HonpykEgEb3HizVPZQCtg522tF/DU5fvp9xA9Crhl0frunf+3ALJi8Tl
   2L2sFr0JMpklGStslDCFjQDnHpug03Ji6imOJri35zY+/0l107faFD0YK
   lbZ6GLlrOKkp5B01ccYFVcKrI0VPqs3bad1VIMVDPhbBQSrnJZM1li+Jc
   ePSdvYPej965mU4LUpXWWxPT8h580C7rVf51aZLY8kwyNQGGfS5/rn/KZ
   W8FJDm7OcR1a9GZq4mwEpHqbY2hlrSUnS8isIxNTP/T2XWQCtmrcN210s
   sGGPOB+EY+igRJZG2YPp/cIdCtMBH93xjaTWN1Emh/zDznux8otq+EZsz
   Q==;
X-CSE-ConnectionGUID: TjlkW+goQCSajb6D3HwFQA==
X-CSE-MsgGUID: SA11UPGuQraisaNOcZCmFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="53136487"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="53136487"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:01 -0700
X-CSE-ConnectionGUID: D4lNhUSyRPWt9I7QZCgfbA==
X-CSE-MsgGUID: IxiV2StaRDGYHuBm7j71mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="153069274"
Received: from agluck-desk3.sc.intel.com ([172.25.103.51])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 09:50:00 -0700
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
Subject: [PATCH v6 21/30] x86,fs/resctrl: Add architectural event pointer
Date: Thu, 26 Jun 2025 09:49:30 -0700
Message-ID: <20250626164941.106341-22-tony.luck@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
References: <20250626164941.106341-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resctrl file system layer passed the domain, rmid, and event id to
resctrl_arch_rmid_read() to fetch an event counter.

For some resources this may not be enough information to efficiently
access the counter.

Add mon_evt::arch_priv void pointer. Architecture code can initialize
this when marking each event enabled.

File system code passes this pointer to resctrl_arch_rmid_read().

Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h               |  6 ++++--
 fs/resctrl/internal.h                 |  1 +
 arch/x86/kernel/cpu/resctrl/core.c    |  6 +++---
 arch/x86/kernel/cpu/resctrl/monitor.c |  2 +-
 fs/resctrl/monitor.c                  | 12 ++++++++----
 5 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 76c54b81e426..b9f2690bee1e 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -383,7 +383,8 @@ int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
 #define MAX_BINARY_BITS	27
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, u32 binary_bits);
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
+			      u32 binary_bits, void *arch_priv);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
@@ -478,6 +479,7 @@ void resctrl_arch_pre_mount(void);
  *			only.
  * @rmid:		rmid of the counter to read.
  * @eventid:		eventid to read, e.g. L3 occupancy.
+ * @arch_priv:		architecture private data for this event.
  * @val:		result of the counter read in bytes.
  * @arch_mon_ctx:	An architecture specific value from
  *			resctrl_arch_mon_ctx_alloc(), for MPAM this identifies
@@ -495,7 +497,7 @@ void resctrl_arch_pre_mount(void);
  */
 int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
-			   u64 *val, void *arch_mon_ctx);
+			   void *arch_priv, u64 *val, void *arch_mon_ctx);
 
 /**
  * resctrl_arch_rmid_read_context_check()  - warn about invalid contexts
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 53ced959a27d..2126006075f3 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -71,6 +71,7 @@ struct mon_evt {
 	bool			is_floating_point;
 	int			binary_bits;
 	bool			enabled;
+	void			*arch_priv;
 };
 
 extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 9144766da836..f3144fe918dd 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -909,15 +909,15 @@ static __init bool get_rdt_mon_resources(void)
 	bool ret = false;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
-		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0);
+		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0);
+		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0, NULL);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0);
+		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0, NULL);
 		ret = true;
 	}
 
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 043f777378a6..185b203f6321 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -219,7 +219,7 @@ static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
 
 int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
-			   u64 *val, void *ignored)
+			   void *arch_priv, u64 *val, void *ignored)
 {
 	int cpu = cpumask_any(&hdr->cpu_mask);
 	struct rdt_hw_l3_mon_domain *hw_dom;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index cff8af3a263e..c4b092aec9f8 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -160,7 +160,7 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 
 		entry = __rmid_entry(idx);
 		if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid, entry->rmid,
-					   QOS_L3_OCCUP_EVENT_ID, &val,
+					   QOS_L3_OCCUP_EVENT_ID, NULL, &val,
 					   arch_mon_ctx)) {
 			rmid_dirty = true;
 		} else {
@@ -402,7 +402,8 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 			return -EINVAL;
 
 		rr->err = resctrl_arch_rmid_read(rr->r, rr->hdr, closid, rmid,
-						 rr->evt->evtid, &tval, rr->arch_mon_ctx);
+						 rr->evt->evtid, rr->evt->arch_priv,
+						 &tval, rr->arch_mon_ctx);
 		if (rr->err)
 			return rr->err;
 
@@ -430,7 +431,8 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
 		if (d->ci_id != rr->ci_id)
 			continue;
 		err = resctrl_arch_rmid_read(rr->r, &d->hdr, closid, rmid,
-					     rr->evt->evtid, &tval, rr->arch_mon_ctx);
+					     rr->evt->evtid, rr->evt->arch_priv,
+					     &tval, rr->arch_mon_ctx);
 		if (!err) {
 			rr->val += tval;
 			ret = 0;
@@ -902,7 +904,8 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	MON_EVENT(PMT_EVENT_UOPS_RETIRED,		"uops_retired",		RDT_RESOURCE_PERF_PKG,	false),
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, u32 binary_bits)
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
+			      u32 binary_bits, void *arch_priv)
 {
 	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS) ||
 			 binary_bits > MAX_BINARY_BITS)
@@ -918,6 +921,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu, u32 b
 
 	mon_event_all[eventid].any_cpu = any_cpu;
 	mon_event_all[eventid].binary_bits = binary_bits;
+	mon_event_all[eventid].arch_priv = arch_priv;
 	mon_event_all[eventid].enabled = true;
 }
 
-- 
2.49.0

