Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF9B18C16
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 17:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687369241; x=1718905241;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dhSYaV/feip3Bku5n5e/swWWwTp+mDFZDryH6jxbEoc=;
  b=SHujggXhOUNDzO/+U3WPvLBWVxK8IPTzDllHz8KPpcN0Jqi9tq+0z2gk
   ROGLSXQbaLzweMvWIofaknNw6/AEc7LjW6cVtAleIuVZtsGoreiVyking
   z1Hh6bl/tvJ8gCQLVelbxDOxgZ4YlrlNs+Nj9Ec6S8TFDkBBfiBbrLfFy
   rHJzJE6WyTj0G3jXn2DoRTqPlSgyuz3bHbDgyFKCcqC5WzRo70Keqp5aN
   OV97/E/lDe+ZT6yJ7pdu0QkgEgyqCEfidKcnm41sTAE6GBS46bE9/UWs2
   I68kIBftkgSOJ+bFKzMQ3Qq66JdL/Nk3Zt7AVU3kghmLYD99LKWpBFQnv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="359120515"
X-IronPort-AV: E=Sophos;i="6.00,261,1681196400"; 
   d="scan'208";a="359120515"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 10:40:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="779921564"
X-IronPort-AV: E=Sophos;i="6.00,261,1681196400"; 
   d="scan'208";a="779921564"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 10:40:16 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 2/7] x86/resctrl: Remove hard code of RDT_RESOURCE_L3 in monitor.c
Date: Wed, 21 Jun 2023 10:40:01 -0700
Message-Id: <20230621174006.42533-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230621174006.42533-1-tony.luck@intel.com>
References: <20230621174006.42533-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Scope of monitoring may be scoped at L3 cache granularity (legacy) or
at the node level (systems with Sub NUMA Cluster enabled).

Save the struct rdt_resource pointer that was used to initialize
the monitor sections of code and use that value instead of the
hard-coded RDT_RESOURCE_L3.

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index ded1fc7cb7cb..9be6ffdd01ae 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -30,6 +30,8 @@ struct rmid_entry {
 	struct list_head		list;
 };
 
+static struct rdt_resource *mon_resource;
+
 /**
  * @rmid_free_lru    A least recently used list of free RMIDs
  *     These RMIDs are guaranteed to have an occupancy less than the
@@ -268,7 +270,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain *d,
  */
 void __check_limbo(struct rdt_domain *d, bool force_free)
 {
-	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	struct rdt_resource *r = mon_resource;
 	struct rmid_entry *entry;
 	u32 crmid = 1, nrmid;
 	bool rmid_dirty;
@@ -333,7 +335,7 @@ int alloc_rmid(void)
 
 static void add_rmid_to_limbo(struct rmid_entry *entry)
 {
-	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	struct rdt_resource *r = mon_resource;
 	struct rdt_domain *d;
 	int cpu, err;
 	u64 val = 0;
@@ -645,7 +647,7 @@ void cqm_handle_limbo(struct work_struct *work)
 
 	mutex_lock(&rdtgroup_mutex);
 
-	r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	r = mon_resource;
 	d = container_of(work, struct rdt_domain, cqm_limbo.work);
 
 	__check_limbo(d, false);
@@ -681,7 +683,7 @@ void mbm_handle_overflow(struct work_struct *work)
 	if (!static_branch_likely(&rdt_mon_enable_key))
 		goto out_unlock;
 
-	r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	r = mon_resource;
 	d = container_of(work, struct rdt_domain, mbm_over.work);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
@@ -759,9 +761,9 @@ static struct mon_evt mbm_local_event = {
 /*
  * Initialize the event list for the resource.
  *
- * Note that MBM events are also part of RDT_RESOURCE_L3 resource
- * because as per the SDM the total and local memory bandwidth
- * are enumerated as part of L3 monitoring.
+ * Monitor events can either be part of RDT_RESOURCE_L3 resource,
+ * or they may be per NUMA node on systems with sub-NUMA cluster
+ * enabled and are then in the RDT_RESOURCE_NODE resource.
  */
 static void l3_mon_evt_init(struct rdt_resource *r)
 {
@@ -773,6 +775,8 @@ static void l3_mon_evt_init(struct rdt_resource *r)
 		list_add_tail(&mbm_total_event.list, &r->evt_list);
 	if (is_mbm_local_enabled())
 		list_add_tail(&mbm_local_event.list, &r->evt_list);
+
+	mon_resource = r;
 }
 
 int __init rdt_get_mon_l3_config(struct rdt_resource *r)
-- 
2.40.1

