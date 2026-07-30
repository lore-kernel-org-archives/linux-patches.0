Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BB44519AB;
	Thu, 30 Jul 2026 15:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425182; cv=none; b=DLE00RH1hLmi5wBchwX6xx5y3GtNNWm37Gu0yOIOUcMBa39feSvOPLwUFk44EdiqSfQLGvu1h13eonMz3WCD5oeWUUrpbb6HXanM8l9BUukEF3aYopZndjSNy6UhrIVFo+ONdHUzdpxKq3anObHLNt5G4AIiNtF5NRgsi/YdXkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425182; c=relaxed/simple;
	bh=ZY1L/Ua6tRVAUgII/sk5ImKFGklv3qYgTgKJl0DdziM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvTkUnxpGiBymgXrOOqtQprHgvLzJbl8OJHWE9QrYWU6/XwLl2r6ByszdFV7TFm05xHed9i22Z4G+62cEIhUA8qwN7qfLelRcyCSiLsG9H7AHwVYDq9LRixTH3VGBZvPdSdQJgzaC9JJ11S/Ar/D/CHOiGUQUCnfYzS7Xfcpi/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/QCVah7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/QCVah7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B551F00A3F;
	Thu, 30 Jul 2026 15:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425180;
	bh=V49cqbg6Jm+Zbe6y2qTnzyRu/4liQ3feeaMCMcO6wCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/QCVah7gwE5cFMbHMWWy3kWqypDymLbRAPXDze2ULjByeOBc9kMmA6sWlv+1/B1Y
	 eKqS8hQEodrbs5YnJ6Jo1pknj8FS8XUgTd2NK18EBKn5fMWDJuWadQwCqIOFUf5x+N
	 Fy8mmnEce17iYE+ttI7XpLkV7AQoLO6L2Bakmcdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 653/675] fs/resctrl: Move RMID initialization to first mount
Date: Thu, 30 Jul 2026 16:16:23 +0200
Message-ID: <20260730141459.021723428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit d0891647fbc6e931f27517364cbc4ee1811d76db ]

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
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lore.kernel.org/20251217172121.12030-1-tony.luck@intel.com
Stable-dep-of: 52fce648607e ("fs/resctrl: Fix use-after-free during unmount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/resctrl/internal.h |    4 +++
 fs/resctrl/monitor.c  |   54 +++++++++++++++++++++++---------------------------
 fs/resctrl/rdtgroup.c |    5 ++++
 3 files changed, 34 insertions(+), 29 deletions(-)

--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -351,6 +351,10 @@ int closids_supported(void);
 
 void closid_free(int closid);
 
+int setup_rmid_lru_list(void);
+
+void free_rmid_lru_list(void);
+
 int alloc_rmid(u32 closid);
 
 void free_rmid(u32 closid, u32 rmid);
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -862,20 +862,29 @@ void mbm_setup_overflow_handler(struct r
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
@@ -888,30 +897,24 @@ static int dom_data_init(struct rdt_reso
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
 
@@ -1773,7 +1776,8 @@ static void closid_num_dirty_rmid_free(v
  * resctrl_l3_mon_resource_init() - Initialise global monitoring structures.
  *
  * Allocate and initialise global monitor resources that do not belong to a
- * specific domain. i.e. the rmid_ptrs[] used for the limbo and free lists.
+ * specific domain. i.e. the closid_num_dirty_rmid[] used to find the CLOSID
+ * with the cleanest set of RMIDs.
  * Called once during boot after the struct rdt_resource's have been configured
  * but before the filesystem is mounted.
  * Resctrl's cpuhp callbacks may be called before this point to bring a domain
@@ -1793,12 +1797,6 @@ int resctrl_l3_mon_resource_init(void)
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
@@ -1845,6 +1843,4 @@ void resctrl_l3_mon_resource_exit(void)
 		return;
 
 	closid_num_dirty_rmid_free();
-
-	dom_data_exit(r);
 }
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2732,6 +2732,10 @@ static int rdt_get_tree(struct fs_contex
 		goto out;
 	}
 
+	ret = setup_rmid_lru_list();
+	if (ret)
+		goto out;
+
 	ret = rdtgroup_setup_root(ctx);
 	if (ret)
 		goto out;
@@ -4518,4 +4522,5 @@ void resctrl_exit(void)
 	 */
 
 	resctrl_l3_mon_resource_exit();
+	free_rmid_lru_list();
 }


