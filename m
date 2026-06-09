Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E027D3988E1
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 21:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781038975; cv=none; b=gTxPWfEptOFocKifNqENCIdsJ33MXk0NaAjgJzNRLpZA7KPispEHgAf7RpcYxYxs4tu9FaqyRtnGrTduXfa/n6S2pKfjsjlfKRVFtqURj2TUrzP2WYfatVLQ9KZ5jCno1s0YmiWDVwGF39mz6FTIRyTXbuD3OHEntRo0g7W+p4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781038975; c=relaxed/simple;
	bh=uj2HbwpeVZoI2H2eNfrEoI9yD3Oy3gxW4pyNDQE7YT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMHYmjwJuhMcFhVKnByggD/T9LMyQGEVVPanOr0LlK01f1B8u6blKB9X+JPgvQOpHclv22yZbtAmYTNfZp+sgoIewp74RLd9OqOgSpB4ROlWsMmH8vUbh4B9O7c5nNqg9kFs69qDY3sYJTf2oFs9cqW8RiR/dwkgF0W/wK0YJaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HsMFe1q6; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HsMFe1q6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781038974; x=1812574974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uj2HbwpeVZoI2H2eNfrEoI9yD3Oy3gxW4pyNDQE7YT4=;
  b=HsMFe1q65O3e3yN6Adx4DvQU8tUkUyNG0xTXsxBUD8dXzfNjj+r62kKt
   hG7U9UvImKm5lEPRhFyfD8SulNq/GvUaVh0ydxNVZlK3JMuup8/LB9ju4
   njZr2Rk8ebloU6rvGTyP940X6lfYhPOQUgzdpFEvA5vt3yhiGXqtMTv5d
   zz3qNQsAUvqhahCs2/t0KTSl1L5lu3lfYDKJ2/9iJ0Ez08l49L0tj6Kv1
   n63rRiIx2Y6dQ59brIwMSpqlor2Sw+1LvvAMxYWqqej2y3cvLs3hloOc2
   JBQ+GcXFYq7Rs4MuuZRrfu1UV/bV9KBPJ09wVYMaHOP9Wp5+vQEY3Libj
   A==;
X-CSE-ConnectionGUID: /veYos8FSq6sM3uxacdBUw==
X-CSE-MsgGUID: +/DZ9zxuQ66d/MHnvWyjnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="81725068"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="81725068"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:54 -0700
X-CSE-ConnectionGUID: lcR9f0kHSIS/7sHizfJRrQ==
X-CSE-MsgGUID: CH8OTXeQSMyKH9X/TyOMhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="251045686"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:52 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v5 05/11] fs/resctrl: Fix use-after-free during unmount
Date: Tue,  9 Jun 2026 14:02:31 -0700
Message-ID: <bd5ef3e15218a4163187e914a6a8f6fed84597bd.1781029125.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1781029125.git.reinette.chatre@intel.com>
References: <cover.1781029125.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tony Luck <tony.luck@intel.com>

During unmount or failure teardown all mon_data structures that contain
monitoring event file private data are freed after which kernfs nodes are
removed. However, the RDT_DELETED flag is never set for the statically
allocated default resource group.

A concurrent reader of an event file associated with the default resource
group may, after dropping kernfs active protection, block on rdtgroup_mutex
while unmount proceeds to free the file private data and destroy the kernfs
node without waiting for the reader.

When the mutex is released, the reader wakes up, observes that RDT_DELETED
is not set for the default group, and dereferences the already-freed
file private data.

The scenario can be depicted as follows:
  CPU0                                      CPU1
   /*
    * Default resource group's
    * monitoring data accessible via
    * kernfs file with kernfs_node::priv
    * pointing to a struct mon_data.
    * User opens the file for reading.
    */
   rdtgroup_mondata_show()                 /* arch encounters fatal error */
    rdtgroup_kn_lock_live()                 resctrl_exit()
     atomic_inc(&rdtgroup_default.waitcount) cpus_read_lock()
     kernfs_break_active_protection(kn)      mutex_lock(&rdtgroup_mutex)
     cpus_read_lock()                        resctrl_fs_teardown()
     mutex_lock(&rdtgroup_mutex)              rmdir_all_sub()
                                              mon_put_kn_priv()
                                               /* Delete all mon_data structures */
                                              rdtgroup_destroy_root()
                                               kernfs_destroy_root()
                                               rdtgroup_default.kn = NULL
                                             mutex_unlock(&rdtgroup_mutex)
     /*
      * rdtgroup_default.flags is empty so
      * rdtgroup_kn_lock_live() returns
      * &rdtgroup_default
      */
     md = of->kn->priv;

     /* md points to freed mon_data */

Set RDT_DELETED for the default group unconditionally since the flag does
not lead to the freeing of this statically allocated group.

Do not allow a new resctrl mount if there are any waiters on default group
of previous mount. A new mount will re-initialize the default group that
would appear to waiters from previous mount as though the default group is
accessible causing them to access the mon_data structures from the previous
mount that have been removed.

Fixes: 2a6566038544 ("x86/resctrl: Expand the width of domid by replacing mon_data_bits")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260508182143.14592-1-tony.luck%40intel.com?part=2 [1]
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
---
Changes since V2:
- Rewrite changelog to not describe code as much.
- Rework changelog to switch to "Reported-by/Closes".
- Merge the duplicate rdtgroup_remove() comment with the function comment.
- Fix changelog to not mention that RDT_DELETED flag is set conditionally.
- Change "Fixes:" tag to point to commit that introduced dynamically
  allocated mon_data this bug involves.

Changes since V3:
- Depict the race. (Chenyu)
- Add Chenyu's Reviewed-by tag.
- Changelog grammar fixes.
---
 fs/resctrl/rdtgroup.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 31cfb54a5488..809f0965474c 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -585,14 +585,20 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
  *
  * On resource group creation via a mkdir, an extra kernfs_node reference is
  * taken to ensure that the rdtgroup structure remains accessible for the
- * rdtgroup_kn_unlock() calls where it is removed.
+ * rdtgroup_kn_unlock() calls where it is removed. The default group is
+ * statically allocated: it does not have an extra reference but will have
+ * RDT_DELETED set on unmount to support safe access to its associated files
+ * via rdtgroup_kn_lock_live/rdtgroup_kn_unlock().
  *
- * Drop the extra reference here, then free the rdtgroup structure.
+ * For all but the default group: drop the extra reference, then free the
+ * rdtgroup structure.
  *
  * Return: void
  */
 static void rdtgroup_remove(struct rdtgroup *rdtgrp)
 {
+	if (rdtgrp == &rdtgroup_default)
+		return;
 	kernfs_put(rdtgrp->kn);
 	kfree(rdtgrp);
 }
@@ -2975,6 +2981,7 @@ static void resctrl_fs_teardown(void)
 	mon_put_kn_priv();
 	rdt_pseudo_lock_release();
 	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
+	rdtgroup_default.flags = RDT_DELETED;
 	closid_exit();
 	schemata_list_destroy();
 	rdtgroup_destroy_root();
@@ -3000,6 +3007,12 @@ static int rdt_get_tree(struct fs_context *fc)
 		goto out;
 	}
 
+	/* Avoid races from pending operations from a previous mount */
+	if (atomic_read(&rdtgroup_default.waitcount) != 0) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = setup_rmid_lru_list();
 	if (ret)
 		goto out;
@@ -4275,6 +4288,7 @@ static int rdtgroup_setup_root(struct rdt_fs_context *ctx)
 
 	ctx->kfc.root = rdt_root;
 	rdtgroup_default.kn = kernfs_root_to_node(rdt_root);
+	rdtgroup_default.flags = 0;
 
 	return 0;
 }
-- 
2.50.1

