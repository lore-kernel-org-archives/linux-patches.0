Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F8D3F20EC
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 03:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780457283; cv=none; b=VgEOzwDVv80sREIRLAgGPWQSBIYpF9lTDawKw3EpPp+m6H+sM68fJBkEYPcSSMU0XRndkTZIkMRtrVJhCv8ZjYDs/y8c02jz9kGG3bCsc09jDZLmG6W3t47w0O5fQ8bs4xiOvpAHl/xZjOhIcEivRx2hWOdCTd67RwcpEe8YPDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780457283; c=relaxed/simple;
	bh=uj2HbwpeVZoI2H2eNfrEoI9yD3Oy3gxW4pyNDQE7YT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cM9gGTxbuSLoqv3z+Cs3tvNKbS+2XaeHhNhTAJrpH6eA/oS2/X2oNmJ3LW/r4gow0KQ6WUK5n81kO3jSihT/WNtAOjho/xl/QwOpUAnvHPVi9cnTw419pJ/EsT5QiRAP6Beq5HlyH09YrhOMUWfdZD7KDsyr4Q39/ZgRTExK604=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E+SkXlDn; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E+SkXlDn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780457282; x=1811993282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uj2HbwpeVZoI2H2eNfrEoI9yD3Oy3gxW4pyNDQE7YT4=;
  b=E+SkXlDnP6l5m1TX4Wr9XxS2Sc3PNaoXhTSrQzc1TK5+ZpuxTqW8G0RY
   dCdJTIXe78xLanRpkoF+77QIrCUfYZE3ZLfsp64L9aEa11Sp5HRSys4zx
   sMq2saoe/uX0CBf33on0ebCDTXJhMu9jfoRONvNRgiCUzZf6KvAIwrWr0
   /mReXAgj5m9DRCqm4JshMyl1ze0qPTQ5GmjM0lKi8vsND8uefrWT+UTNF
   fHEoJGUTSEfyVCwkxLkWyrmFVzIDXSQH6KbZaGobY5/98tpwR0RODG6LB
   feKG5NjoNo1UbCodVla0WI7PYvtSULv6ZuB84RDH81ocs+iyvLEc+2jGc
   g==;
X-CSE-ConnectionGUID: D3t5N8rxSfetj7ElBm/gSw==
X-CSE-MsgGUID: gXEXpyw4SKyvt0gHPfASJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="91939000"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="91939000"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:28:00 -0700
X-CSE-ConnectionGUID: rt556nYLQ9Wc7DZoPIo8CA==
X-CSE-MsgGUID: 9He36uLFT8qGq+TD0vD2tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="241110106"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:27:59 -0700
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
Subject: [PATCH v4 04/10] fs/resctrl: Fix use-after-free during unmount
Date: Tue,  2 Jun 2026 20:27:32 -0700
Message-ID: <ae6174bbd6b8320943ddd0edefab7bceb16d101e.1780456704.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1780456704.git.reinette.chatre@intel.com>
References: <cover.1780456704.git.reinette.chatre@intel.com>
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

