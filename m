Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116FB4C93
	for <patches@lists.linux.dev>; Thu, 26 Jan 2023 18:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674758552; x=1706294552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bsHRrFSHNHwYzutnGoCpp7L6CsbI7cB3D9T+kZSrwWU=;
  b=YktPJEPrLD2tAupjxrIbi1BuYiJimYlnZM3lleuZtzAclv+LMNaXu82N
   QgM4MX6fUUQVZC2OYtaMiqsojQEyCqJdXKAschbSIxZsDLPn9Wj5FE7Sp
   WUqBdk8pK7uDNH+v1UHr6rVYzHhBQxUNXGkb8HfoLfayIV2Gdl+mHG2gj
   /QFjmZLeF9yIw35vXbwi9Zq2/yVk1nHEkCjNzHwDFeVqYrBkZ+bVxs3Hv
   2IsbFtl9ck8BhG5HDBrxvaDBs09ZVA0u0Cck0BuZrQU/rooJq4JCqf9hS
   Zjtpg25Xcfh5fn9V+N4vQVfMOcVvL2udMc2sTaouMQjegOG2U19yt8MwW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="354203331"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="354203331"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 10:42:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="991745442"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="991745442"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 10:42:05 -0800
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
Subject: [PATCH 2/7] x86/resctrl: Remove hard code of RDT_RESOURCE_L3 in monitor.c
Date: Thu, 26 Jan 2023 10:41:52 -0800
Message-Id: <20230126184157.27626-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126184157.27626-1-tony.luck@intel.com>
References: <20230126184157.27626-1-tony.luck@intel.com>
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
 arch/x86/kernel/cpu/resctrl/monitor.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 77538abeb72a..d05bbd4f6b2d 100644
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
@@ -251,7 +253,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain *d,
  */
 void __check_limbo(struct rdt_domain *d, bool force_free)
 {
-	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	struct rdt_resource *r = mon_resource;
 	struct rmid_entry *entry;
 	u32 crmid = 1, nrmid;
 	bool rmid_dirty;
@@ -316,7 +318,7 @@ int alloc_rmid(void)
 
 static void add_rmid_to_limbo(struct rmid_entry *entry)
 {
-	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	struct rdt_resource *r = mon_resource;
 	struct rdt_domain *d;
 	int cpu, err;
 	u64 val = 0;
@@ -633,7 +635,7 @@ void cqm_handle_limbo(struct work_struct *work)
 
 	mutex_lock(&rdtgroup_mutex);
 
-	r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	r = mon_resource;
 	d = container_of(work, struct rdt_domain, cqm_limbo.work);
 
 	__check_limbo(d, false);
@@ -669,7 +671,7 @@ void mbm_handle_overflow(struct work_struct *work)
 	if (!static_branch_likely(&rdt_mon_enable_key))
 		goto out_unlock;
 
-	r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	r = mon_resource;
 	d = container_of(work, struct rdt_domain, mbm_over.work);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
@@ -747,9 +749,11 @@ static struct mon_evt mbm_local_event = {
 /*
  * Initialize the event list for the resource.
  *
- * Note that MBM events are also part of RDT_RESOURCE_L3 resource
+ * Note that MBM events can either be part of RDT_RESOURCE_L3 resource
  * because as per the SDM the total and local memory bandwidth
- * are enumerated as part of L3 monitoring.
+ * are enumerated as part of L3 monitoring, or they may be per NUMA
+ * node on systems with sub-NUMA cluster enabled and are then in the
+ * RDT_RESOURCE_NODE resource.
  */
 static void l3_mon_evt_init(struct rdt_resource *r)
 {
@@ -761,6 +765,8 @@ static void l3_mon_evt_init(struct rdt_resource *r)
 		list_add_tail(&mbm_total_event.list, &r->evt_list);
 	if (is_mbm_local_enabled())
 		list_add_tail(&mbm_local_event.list, &r->evt_list);
+
+	mon_resource = r;
 }
 
 int rdt_get_mon_l3_config(struct rdt_resource *r)
-- 
2.39.1

