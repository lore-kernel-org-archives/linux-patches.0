Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2678322A7E9
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069254; cv=none; b=RW0Ck/PrNCjmI564hQyPQPqb94yyoUXMtqI2IM3ol9TDLkRM8yaw2b9PZrDKVT+6Zm0GU2QgcZYQbg+YfHE9ZqhrEQ3hYen73NUFJ4wObzurL3QYtYiBja9VX/94Q0KgmIhwfCVEMftkuBWXibympLSFThiaS6+1MmVB5bFv5/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069254; c=relaxed/simple;
	bh=PbAmaYUfs3cYnTUyhKKObGUQYfLatjVDLhG5ft36Q3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkHiw0IMUik9Igf2++ARIWkgPbQ9x3yaeSdxBxcS7TnpWN4L3OKZRcoYtMqDawozhV73UFLYUXeIGpOyx6teKyWZuWmsQglGoDqvQBuKiPWM6Q3IBzYZ+VeKl0F2bozknheqyMZ+AzJhXM0kNil8xnZxK0WeO4yz6ZTznnmgdLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aHo0OMLy; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aHo0OMLy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069252; x=1775605252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PbAmaYUfs3cYnTUyhKKObGUQYfLatjVDLhG5ft36Q3I=;
  b=aHo0OMLyiwm9w5UavDi0xLqI++dUW92sOv57fsH3M5mC4M9U7axP/3I4
   Dykk0u4QyDJfsYXJsAoedGgJOI42zSiDZPt7dA3cqX1nT1v5psoy59StB
   H3gshYYr68uITHfXTOG72bg2uJFji5M0DG/XPA0U1HlIpKiNBsnaxklDk
   RsPvcmst/9BJvq/5orxJiyHOgSGFBG96e0LKgAr4oNYJHekFhEzsa4PdK
   SMGB8BW3oxInttJqsSU6h8DUsQebxaq0hIqFjrYWJwzTuO4hYupFy7P5J
   yHBZ9C6CT6heXb+8jKILcXWGeeAksSyS8xluvI3UKwC6JlJGnq4Boe9gt
   g==;
X-CSE-ConnectionGUID: Oyg0BmmjT9e3fVZ9kVqM5g==
X-CSE-MsgGUID: RBK0Qsq2Q+C1AdFAOPdc7w==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193130"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193130"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:46 -0700
X-CSE-ConnectionGUID: EfZ3o3v/RZWENunGoIdVUw==
X-CSE-MsgGUID: RIpgCKW+SHeYXq99PvsPjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315452"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:45 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 03/26] fs/resctrl: Change how events are initialized
Date: Mon,  7 Apr 2025 16:40:05 -0700
Message-ID: <20250407234032.241215-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New monitor events break some assumptions:

1) New events can be in resources other than L3.
2) Enumeration of events may not be complete during early
   boot.

Prepare for events in other resources.

Delay building the event lists until first mount of the resctrl
file system.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/internal.h |  3 +++
 fs/resctrl/monitor.c  | 30 +++++++++++++++++++-----------
 fs/resctrl/rdtgroup.c |  2 ++
 3 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 7a65ea02d442..08dbf89939ac 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -76,6 +76,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
  */
 struct mon_evt {
 	enum resctrl_event_id	evtid;
+	enum resctrl_res_level	rid;
 	char			*name;
 	bool			configurable;
 	struct list_head	list;
@@ -390,6 +391,8 @@ int rdt_lookup_evtid_by_name(char *name);
 
 char *rdt_event_name(enum resctrl_event_id evt);
 
+void resctrl_init_mon_events(void);
+
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 66e613906f3e..472754d082cb 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -846,14 +846,17 @@ static struct mon_evt all_events[QOS_NUM_EVENTS] = {
 	[QOS_L3_OCCUP_EVENT_ID] = {
 		.name	= "llc_occupancy",
 		.evtid	= QOS_L3_OCCUP_EVENT_ID,
+		.rid	= RDT_RESOURCE_L3,
 	},
 	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
 		.name	= "mbm_total_bytes",
 		.evtid	= QOS_L3_MBM_TOTAL_EVENT_ID,
+		.rid	= RDT_RESOURCE_L3,
 	},
 	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
 		.name	= "mbm_local_bytes",
 		.evtid	= QOS_L3_MBM_LOCAL_EVENT_ID,
+		.rid	= RDT_RESOURCE_L3,
 	},
 };
 
@@ -878,22 +881,29 @@ char *rdt_event_name(enum resctrl_event_id evt)
 }
 
 /*
- * Initialize the event list for the resource.
+ * Initialize the event list for all mon_capable resources.
  *
- * Note that MBM events are also part of RDT_RESOURCE_L3 resource
- * because as per the SDM the total and local memory bandwidth
- * are enumerated as part of L3 monitoring.
- *
- * mon_put_default_kn_priv_all() also assumes monitor events are only supported
- * on the L3 resource.
+ * Called on each mount of the resctrl file system when all
+ * events have been enumerated. Only needs to build the per-resource
+ * event lists once.
  */
-static void l3_mon_evt_init(struct rdt_resource *r)
+void resctrl_init_mon_events(void)
 {
+	struct rdt_resource *r;
+	static bool only_once;
 	int evt;
 
-	INIT_LIST_HEAD(&r->evt_list);
+	if (only_once)
+		return;
+	only_once = true;
+
+	for_each_mon_capable_rdt_resource(r)
+		INIT_LIST_HEAD(&r->evt_list);
 
 	for_each_set_bit(evt, rdt_mon_features, QOS_NUM_EVENTS) {
+		r = resctrl_arch_get_resource(all_events[evt].rid);
+		if (!r->mon_capable)
+			continue;
 		list_add_tail(&all_events[evt].list, &r->evt_list);
 	}
 }
@@ -922,8 +932,6 @@ int resctrl_mon_resource_init(void)
 	if (ret)
 		return ret;
 
-	l3_mon_evt_init(r);
-
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
 		all_events[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
 		resctrl_file_fflags_init("mbm_total_bytes_config",
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 8d15d53fae76..1433fc098a90 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2574,6 +2574,8 @@ static int rdt_get_tree(struct fs_context *fc)
 		goto out;
 	}
 
+	resctrl_init_mon_events();
+
 	ret = rdtgroup_setup_root(ctx);
 	if (ret)
 		goto out;
-- 
2.48.1

