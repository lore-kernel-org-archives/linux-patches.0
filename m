Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4781731A570
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010494; cv=none; b=DXloET1opEWrVqk7RuyL0OUutNQrDMdIUYUHfV/+zNfCnJ3rXWR3LI9opm4/gnWy3t4CEpWoaVE14TUBPYa4bk1sdQGnqrFpVTwJVCeUE00h5vSfNklfy/yhleIErrjaknbeKlkAf6yYzQRaFqkgHxdDcQiPA3cDgh7IPPwNGc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010494; c=relaxed/simple;
	bh=SyYCwtOZTaDXsXXpoKZ5vF1vrbpqwxs2p9inu/VN0zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwQkZzIjCGsKHyAzMkQV+AIyPeZflwPhqCJP7NohlmQV7jZ7ksP1zhCkg4KW2AZlj3dFkDBJzmTxJafRAyZQCCtUeY6QIMF8TeiX4YE6oZRSVYdTbTcBtWyhXljIm2pDjE6Gp81xvhY9901QeC9sf904Z38dvhl2P7QVAgraOp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CfuF59QI; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CfuF59QI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010492; x=1795546492;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SyYCwtOZTaDXsXXpoKZ5vF1vrbpqwxs2p9inu/VN0zw=;
  b=CfuF59QIQsavHBHZgnxtSKT0VIWniJvWjH4fJh/KcHGc90XuhAXBKstc
   IOtCA1sRD6U/wQ9OX2YGOfpsDvLn+ywMDTF/HXTT82lKTKuCX0Iguhc3L
   PwRdwd7MQaxNQjrOfgDM0JLIt7cL7KszaGO40p7LBcOQbOqHHYojyAbQf
   gFGHBALIOnzCqIjUE6aOfbHb6q28N02vdoksdzYX0aZ6GA/FlUpBNBSHW
   8KFeMByQ/DtKDeSgryQgpXEY/YDSHSSKAmuokzLUVY+VWPdXCtXIZDaqH
   9HY2//FIDx8Yh08x1TOjxMRxaLLI/kFQ8D7jHNHRZxhyMpOC1uHnVIzt2
   A==;
X-CSE-ConnectionGUID: +LxE1eImQu+4eglXEu8/9Q==
X-CSE-MsgGUID: m8yiQGWjQnyefM40yWwGig==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636595"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636595"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:25 -0800
X-CSE-ConnectionGUID: CGAOnjALQNKsODLPPmoyBQ==
X-CSE-MsgGUID: ne5pTmn6RZymOerdoNPg/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192224976"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:25 -0800
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
Subject: [PATCH v14 11/32] x86,fs/resctrl: Handle events that can be read from any CPU
Date: Mon, 24 Nov 2025 10:53:48 -0800
Message-ID: <20251124185412.24155-12-tony.luck@intel.com>
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

resctrl assumes that monitor events can only be read from a CPU in the
cpumask_t set of each domain.  This is true for x86 events accessed with an
MSR interface, but may not be true for other access methods such as MMIO.

Introduce and use flag mon_evt::any_cpu, settable by architecture, that
indicates there are no restrictions on which CPU can read that event.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            | 2 +-
 fs/resctrl/internal.h              | 2 ++
 arch/x86/kernel/cpu/resctrl/core.c | 6 +++---
 fs/resctrl/ctrlmondata.c           | 6 ++++++
 fs/resctrl/monitor.c               | 3 ++-
 5 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 79aaaabcdd3f..22c5d07fe9ff 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -412,7 +412,7 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
 u32 resctrl_arch_system_num_rmid_idx(void);
 int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid);
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
 
 bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
 
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 86cf38ab08a7..fb0b6e40d022 100644
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
index b3a2dc56155d..bd4a98106153 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -902,15 +902,15 @@ static __init bool get_rdt_mon_resources(void)
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
index 7f9b2fed117a..2c69fcd70eeb 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -578,6 +578,11 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 		}
 	}
 
+	if (evt->any_cpu) {
+		mon_event_count(rr);
+		goto out_ctx_free;
+	}
+
 	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
 
 	/*
@@ -591,6 +596,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
 	else
 		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
 
+out_ctx_free:
 	if (rr->arch_mon_ctx)
 		resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
 }
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 9f78ea17c825..a503ddd159fd 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -981,7 +981,7 @@ struct mon_evt mon_event_all[QOS_NUM_EVENTS] = {
 	},
 };
 
-void resctrl_enable_mon_event(enum resctrl_event_id eventid)
+void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu)
 {
 	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
 		return;
@@ -990,6 +990,7 @@ void resctrl_enable_mon_event(enum resctrl_event_id eventid)
 		return;
 	}
 
+	mon_event_all[eventid].any_cpu = any_cpu;
 	mon_event_all[eventid].enabled = true;
 }
 
-- 
2.51.1

