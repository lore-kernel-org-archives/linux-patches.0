Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548A3327219
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 18:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010513; cv=none; b=eYDTjoE+pY2aWEQeljtaW4IYcJZtfGmJXgybJPt8FqghQg70zE2G1tAKrjAzeMElZKvJx42bb3MA3QSB20ctGvmdJcgHd0pMs9EX5aKaoc4ECCCUuQtKVtmNK8ep327dbewjv+faEU5J3Hu4ZgRHKapv4VSOzPIdU92l5UJQBy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010513; c=relaxed/simple;
	bh=r5Ul2DM4PmLvMaeyHK+TpelMi2f91vGBiwdPwZ0mZDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPfiN6/NzT93h8qw68V71Rya7Qj0fqjifsTro3uqJmz330LNG6PbTdARYTb16OXLqMCEN3KvsE0ZVbCnRzX8/yo0jvt0yob4fF675PEhXA857oaGoSd5xZyRd93YM0YYH006TbUpg+Lj0earTk/MAnixHoT71HL/mis7aJ7fls4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bh3KIltJ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bh3KIltJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764010511; x=1795546511;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r5Ul2DM4PmLvMaeyHK+TpelMi2f91vGBiwdPwZ0mZDE=;
  b=bh3KIltJjqPNBfcSuPuVB5gCWO6xc/6OeBVpwhFlwc8oNKbeQO5yncOb
   NN9UBnJ24Ltpwx2No3ico3B4vbfALQ5uxNcDqUwoEEtgHENIok3nOVgAO
   KbILPAm6Xba8wkEZlelx0dzUOcnVVG3axS2sosMA4ARA+1FvCcERBSnms
   WT/2za8she1l3v48PWq0iNcrHhkyqjSeY/bi08q0x02Xn3+U9gxCfzg9m
   xGUF0aZcGIjeYM31VutBwS8wCn7y/NOqHpOZ0kudBB0mOm/h3vtI5Y05g
   Ji2kbIrs0olMyr5G1gp38c0RxrP7qaNAV0d7wRfX9F8JibsSTfAtvFpgx
   w==;
X-CSE-ConnectionGUID: 89PuYnO5SWyjJKWDcFfhfQ==
X-CSE-MsgGUID: xX9ldrFMRnKx82FNRPfLyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76636918"
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="76636918"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:32 -0800
X-CSE-ConnectionGUID: XDhGFgslSgSIrVDWcqmQXg==
X-CSE-MsgGUID: siQbzqTSR+2cmvfziW4eNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,223,1758610800"; 
   d="scan'208";a="192225038"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 10:54:31 -0800
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
Subject: [PATCH v14 28/32] fs/resctrl: Move RMID initialization to first mount
Date: Mon, 24 Nov 2025 10:54:05 -0800
Message-ID: <20251124185412.24155-29-tony.luck@intel.com>
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

L3 monitor features are enumerated during resctrl initialization and
rmid_ptrs[] that tracks all RMIDs and depends on the number of supported
RMIDs is allocated during this time.

Telemetry monitor features are enumerated during first resctrl mount and
may support a different number of RMIDs compared to L3 monitor features.

Delay allocation and initialization of rmid_ptrs[] until first mount.
Since the number of RMIDs cannot change on later mounts, keep the same set of
rmid_ptrs[] until resctrl_exit(). This is required because the limbo handler
keeps running after resctrl is unmounted and needs to access rmid_ptrs[]
as it keeps tracking busy RMIDs after unmount.

Rename routines to match what they now do:
dom_data_init() -> setup_rmid_lru_list()
dom_data_exit() -> free_rmid_lru_list()

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/internal.h |  4 ++++
 fs/resctrl/monitor.c  | 54 ++++++++++++++++++++-----------------------
 fs/resctrl/rdtgroup.c |  5 ++++
 3 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 399f625be67d..1a9b29119f88 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -369,6 +369,10 @@ int closids_supported(void);
 
 void closid_free(int closid);
 
+int setup_rmid_lru_list(void);
+
+void free_rmid_lru_list(void);
+
 int alloc_rmid(u32 closid);
 
 void free_rmid(u32 closid, u32 rmid);
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 55772aeec1a2..bec6a69f2aae 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -896,20 +896,29 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
 		schedule_delayed_work_on(cpu, &dom->mbm_over, delay);
 }
 
-static int dom_data_init(struct rdt_resource *r)
+int setup_rmid_lru_list(void)
 {
-	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	struct rmid_entry *entry = NULL;
-	int err = 0, i;
+	u32 idx_limit;
 	u32 idx;
+	int i;
 
-	mutex_lock(&rdtgroup_mutex);
+	if (!resctrl_arch_mon_capable())
+		return 0;
 
+	/*
+	 * Called on every mount, but the number of RMIDs cannot change
+	 * after the first mount, so keep using the same set of rmid_ptrs[]
+	 * until resctrl_exit(). Note that the limbo handler continues to
+	 * access rmid_ptrs[] after resctrl is unmounted.
+	 */
+	if (rmid_ptrs)
+		return 0;
+
+	idx_limit = resctrl_arch_system_num_rmid_idx();
 	rmid_ptrs = kcalloc(idx_limit, sizeof(struct rmid_entry), GFP_KERNEL);
-	if (!rmid_ptrs) {
-		err = -ENOMEM;
-		goto out_unlock;
-	}
+	if (!rmid_ptrs)
+		return -ENOMEM;
 
 	for (i = 0; i < idx_limit; i++) {
 		entry = &rmid_ptrs[i];
@@ -922,30 +931,24 @@ static int dom_data_init(struct rdt_resource *r)
 	/*
 	 * RESCTRL_RESERVED_CLOSID and RESCTRL_RESERVED_RMID are special and
 	 * are always allocated. These are used for the rdtgroup_default
-	 * control group, which will be setup later in resctrl_init().
+	 * control group, which was setup earlier in rdtgroup_setup_default().
 	 */
 	idx = resctrl_arch_rmid_idx_encode(RESCTRL_RESERVED_CLOSID,
 					   RESCTRL_RESERVED_RMID);
 	entry = __rmid_entry(idx);
 	list_del(&entry->list);
 
-out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
-
-	return err;
+	return 0;
 }
 
-static void dom_data_exit(struct rdt_resource *r)
+void free_rmid_lru_list(void)
 {
-	mutex_lock(&rdtgroup_mutex);
-
-	if (!r->mon_capable)
-		goto out_unlock;
+	if (!resctrl_arch_mon_capable())
+		return;
 
+	mutex_lock(&rdtgroup_mutex);
 	kfree(rmid_ptrs);
 	rmid_ptrs = NULL;
-
-out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
 }
 
@@ -1823,7 +1826,8 @@ static void closid_num_dirty_rmid_free(void)
  * resctrl_l3_mon_resource_init() - Initialise global monitoring structures.
  *
  * Allocate and initialise global monitor resources that do not belong to a
- * specific domain. i.e. the rmid_ptrs[] used for the limbo and free lists.
+ * specific domain. i.e. the closid_num_dirty_rmid[] used to find the CLOSID
+ * with the cleanest set of RMIDs.
  * Called once during boot after the struct rdt_resource's have been configured
  * but before the filesystem is mounted.
  * Resctrl's cpuhp callbacks may be called before this point to bring a domain
@@ -1843,12 +1847,6 @@ int resctrl_l3_mon_resource_init(void)
 	if (ret)
 		return ret;
 
-	ret = dom_data_init(r);
-	if (ret) {
-		closid_num_dirty_rmid_free();
-		return ret;
-	}
-
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
 		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
 		resctrl_file_fflags_init("mbm_total_bytes_config",
@@ -1895,6 +1893,4 @@ void resctrl_l3_mon_resource_exit(void)
 		return;
 
 	closid_num_dirty_rmid_free();
-
-	dom_data_exit(r);
 }
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index e95d3d0dc515..d49ffc56ea61 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2799,6 +2799,10 @@ static int rdt_get_tree(struct fs_context *fc)
 		goto out;
 	}
 
+	ret = setup_rmid_lru_list();
+	if (ret)
+		goto out;
+
 	ret = rdtgroup_setup_root(ctx);
 	if (ret)
 		goto out;
@@ -4654,4 +4658,5 @@ void resctrl_exit(void)
 	 */
 
 	resctrl_l3_mon_resource_exit();
+	free_rmid_lru_list();
 }
-- 
2.51.1

