Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE72376BC6
	for <patches@lists.linux.dev>; Fri, 22 May 2026 19:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779477328; cv=none; b=oA+e6LVwBtwpHGQ8AzW/uc6Y3IzuFgI7xsjUiRWBkGxPVb5WO5JjKkHUtyJ6D2yqbpEPFzfOCH+ctQUszvQwMZUmYzFbD8Q0J/dxh8EnKL8OPQOae1nFHiJ92wAnH/1hyH8dSwsXCe0qg+NEP//9GD6CqcZZ45Nwg9nhngfnAo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779477328; c=relaxed/simple;
	bh=M1GvEqxYzKuX9Mft4AR9cVFbpKNqwdER8HTsCv2sWoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyZBS8tHPd2LjBK9z5Lf0kyAsXg/zJZ6yTl1bAN97Ojcm+4QpVJ+NSY6fokDd7/UMN9DOLaYOFKqOnUP+G64C8ogluKbsQNSp9r6hVV+R/LsjYS4MNniPfaWu0dN4CxvRd6zLv3GojQ0yWwRZjfsTKw0HXZB2jwsgTRLVFrnajg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bUOf1QoI; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bUOf1QoI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779477326; x=1811013326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M1GvEqxYzKuX9Mft4AR9cVFbpKNqwdER8HTsCv2sWoE=;
  b=bUOf1QoIzvbnG1Rkx1b3XjtN1fePIjKxUr3ymenIT1ThB8Be38FeQrqD
   IRbZxsWwrRsvkZYX/Lwo7r0VFobKt+mpX9xv3qDQ9QQkHAhMpqfZ6g4qr
   VqiY0qoppsSN2xl5EGTqH3limvHg5et9mZxWhaxur6WdM8tBVFEmxwm+r
   IGXVqKidEGTinqwE9MK84iYol8uqPD2e1bzbj+/0wt7Jt3NYwvTGSOWgK
   eP2pbOKOMButOEgGkZPhgqBDZrU+N7Efbj7sLfBV5la1KuFCkALKKYsaQ
   ZShc3JvAAxKNZKkGvEVmU5WvvhmXMJ3ZzBjtZpeK3e8O+3vCHQrsyhTjw
   A==;
X-CSE-ConnectionGUID: PH/MdWgUQQCFfZNH3RRB3g==
X-CSE-MsgGUID: Sq1kgqBPQt+SmQtp1Jhvdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11794"; a="80140450"
X-IronPort-AV: E=Sophos;i="6.24,162,1774335600"; 
   d="scan'208";a="80140450"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 12:15:23 -0700
X-CSE-ConnectionGUID: luG879z4Rg2BiCeUp+axeQ==
X-CSE-MsgGUID: YuRZtfIaTkmFi6HV06G69A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,162,1774335600"; 
   d="scan'208";a="271336465"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 12:15:24 -0700
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
Subject: [PATCH v3 3/9] fs/resctrl: Fix use-after-free during unmount
Date: Fri, 22 May 2026 12:15:07 -0700
Message-ID: <0a48bc36304da0fce4525672cca5f41c3d8ae678.1779476724.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1779476724.git.reinette.chatre@intel.com>
References: <cover.1779476724.git.reinette.chatre@intel.com>
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

Set RDT_DELETED for the default group unconditionally since the flag does
not lead to free of this statically allocated group.

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
---
Changes since V2:
- Rewrite changelog to not describe code as much.
- Rework changelog to switch to "Reported-by/Closes".
- Merge the duplicate rdtgroup_remove() comment with the function comment.
- Fix changelog to not mention that RDT_DELETED flag is set conditionally.
- Change "Fixes:" tag to point to commit that introduced dynamically
  allocated mon_data this bug involves.
---
 fs/resctrl/rdtgroup.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index f573db9e6e84..8a1457825919 100644
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

