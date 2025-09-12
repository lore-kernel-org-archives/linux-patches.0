Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B4027F017
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 22:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715071; cv=none; b=UHNEb3zVPyA1RoI6EfyE+JpnfPuEh7KG6nuFAk+sCBXbF1apxDvBuWglxakzwxzRvYL1aVCMys101bk2EwM64UpQyIH1RqiXyND0Wg2E7v1tEroIwylnQtwutys4o7heQBe+NgNHD6HUcmS7c39wpTBZc/BIIVskReWB0m9FvoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715071; c=relaxed/simple;
	bh=3g75GflHMLHIEnvdqdbf6Z3VQJmxgcXbIMLAWkVqYJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPfhBdZGB7dw0b0UwqCA36cAY80f3pabvAPhrFOZOcqBoG2Br+kW+6BLe47Uv7srKMDmeTF7DC0HmW3KE8dFEzZtbpd98O2AbDGsgktv1aDLNnLHgN6GbRwhs+zh4YVG1GWHO33fC+W88Brom1VoskaNB2Fh539LQIuP/qRHSKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l915myjE; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l915myjE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757715069; x=1789251069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3g75GflHMLHIEnvdqdbf6Z3VQJmxgcXbIMLAWkVqYJU=;
  b=l915myjE4YUGwdCrPPo0mVMA0nucagwhZ2QcSXYw0h+JCFYM7D3+pkC0
   9lVNMWyCTgFBPRjlC4S/2ONw7XxsQ7CkKbrR+5FJOrP/fnpqwLn2QZIvX
   mtylDvs755H/HQFo142uowky2s3pKRifefkNwJPoN4jFUYhsp0meAyChB
   b2BGPtTVPMa9XMT7jaWr/68vYhZHCcqzBduEd5gVkRFoJ1V6hRT2AD5sY
   OgxJ7lYSf0MceOtLU2wYbcYWPCKRFBiPP+PReXL1ZfKaIQQlWWciCDQZ1
   oLhkO8BEsZKKJFgu1ZW9jj98hl5Ym69BI2lPVCs/MkKi1K2lQMn/ZGdjV
   Q==;
X-CSE-ConnectionGUID: pyZY32hYRVilXk+dw8FbOQ==
X-CSE-MsgGUID: Nj443MkCQUGNZ7U3l1NS+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="60002701"
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="60002701"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:05 -0700
X-CSE-ConnectionGUID: umgN+hU9RPCbOSA0SPYGqg==
X-CSE-MsgGUID: ZIab9rSHTmq2s3i6hGRibw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="179265163"
Received: from smoehrl-linux.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.221.49])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 15:11:05 -0700
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
Subject: [PATCH v10 10/28] x86,fs/resctrl: Handle events that can be read from any CPU
Date: Fri, 12 Sep 2025 15:10:31 -0700
Message-ID: <20250912221053.11349-11-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912221053.11349-1-tony.luck@intel.com>
References: <20250912221053.11349-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resctrl assumes that monitor events can only be read from a CPU in the
cpumask_t set of each domain.

This is true for x86 events accessed with an MSR interface, but may
not be true for other access methods such as MMIO.

Add a flag to struct mon_evt to indicate if the event can be read on
any CPU.

Architecture uses resctrl_enable_mon_event() to enable an event and
set the flag appropriately.

Bypass all the smp_call*() code for events that can be read on any CPU
and call mon_event_count() directly from mon_event_read().

Add a test for events that can be read from any domain to skip checks
in __mon_event_count() that the read is being done from a CPU in the
correct domain or cache scope.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            |  2 +-
 fs/resctrl/internal.h              |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c |  6 +++---
 fs/resctrl/ctrlmondata.c           |  6 ++++++
 fs/resctrl/monitor.c               | 13 ++++++++++---
 5 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 66569662efee..22edd8d131d8 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -409,7 +409,7 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid);
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index b6578e572f60..45b97835449f 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -61,6 +61,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  *			READS_TO_REMOTE_MEM) being tracked by @evtid.
  *			Only valid if @evtid is an MBM event.
  * @configurable:	true if the event is configurable
+ * @any_cpu:		true if the event can be read from any CPU
  * @enabled:		true if the event is enabled
  */
 struct mon_evt {
@@ -69,6 +70,7 @@ struct mon_evt {
 	char			*name;
 	u32			evt_cfg;
 	bool			configurable;
+	bool			any_cpu;
 	bool			enabled;
 };
 
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 6608d1097eae..040962751250 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -892,15 +892,15 @@ static __init bool get_rdt_mon_resources(void)
 	bool ret = false;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
-		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID);
+		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
+		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
-		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
+		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
 		ret = true;
 	}
 	if (rdt_cpu_has(X86_FEATURE_ABMC))
diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 77602563cb1f..fbf55e61445c 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -574,6 +574,11 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		}
 	}
 
+	if (evt->any_cpu) {
+		mon_event_count(rr);
+		goto out_ctx_free;
+	}
+
 	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
 
 	/*
@@ -587,6 +592,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
+out_ctx_free:
 	if (rr->arch_mon_ctx)
 		resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 276041c1a922..9cdda6ff2e14 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -414,6 +414,8 @@ static void mbm_cntr_free(struct rdt_l3_mon_domain *d, int cntr_id)
 }
 
 /*
+ * Called from preemptible context via a direct call of mon_event_count() for
+ * events that can be read on any CPU.
  * Called from preemptible but non-migratable process context (mon_event_count()
  * via smp_call_on_cpu()) OR non-preemptible context (mon_event_count() via
  * smp_call_function_any()) for events that need to be read on a specific CPU.
@@ -422,6 +424,10 @@ static bool cpu_on_correct_domain(struct rmid_read *rr)
 {
 	int cpu;
 
+	/* Any CPU is OK for this event */
+	if (rr->evt->any_cpu)
+		return true;
+
 	cpu = smp_processor_id();
 
 	/* Single domain. Must be on a CPU in that domain. */
@@ -975,7 +981,7 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	},
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid)
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu)
 {
 	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
 		return;
@@ -984,6 +990,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid)
 		return;
 	}
 
+	mon_event_all[eventid].any_cpu = any_cpu;
 	mon_event_all[eventid].enabled = true;
 }
 
@@ -1809,9 +1816,9 @@ int resctrl_l3_mon_resource_init(void)
 
 	if (r->mon.mbm_cntr_assignable) {
 		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
-			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
+			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
 		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
-			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
+			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
 		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
 		mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
 								   (READS_TO_LOCAL_MEM |
-- 
2.51.0

