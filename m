Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECE73939BC
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 04:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782880052; cv=none; b=oVjeWaRmiggIojSPteu+Y1wtdxYvsdRF4UnS/ZkKFKwNc1wwzD+B+4ln48TqMipdDJdKQSrBp7ry403Mh/PGRYG4uZg9DU1FIrthuzQCLTVlDZ0HqfyVCTl7Wa9nqgETA3LtR4vk7wnHpSnl/vr6Jy4+wTd4IevhXdlQ5hDeh1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782880052; c=relaxed/simple;
	bh=z99SOMFcZteEMD1NpCUp2D0xF81/ZHccjPc8d8bdGfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImL4IoFoXift99Mc0+/6M2ltmgDuezcierw/BZPaoriqQxGd6djSrFT3xt9nrRIAi7Cr2UuLC7G2YpjmTPTZEqtGl+DmIISQH9fqFiM3J8lOtKFhQBeWWpTIpN7P8udmkseCNn5EhHIUpe735W0iCy7i+8JazzloNuro1Rya/c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Od8ipeig; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Od8ipeig"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782880048; x=1814416048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z99SOMFcZteEMD1NpCUp2D0xF81/ZHccjPc8d8bdGfI=;
  b=Od8ipeigDt95xWCgQBkp5WNlUQurgUshBo1h4D/n4j+BApBq9S/gg01A
   0E3pqE4hg4zv5ZH9zZtG4jV6OMkr+aBAhHPY2czEcpW3AQBivKwZcI7QO
   MREaMQBUbypt++L9+J9T4JwfD6t8inXpFF4bzNuhxQ589qKUydWqLyUzV
   MjXAyevU6DJvuKAouDKbb4zRL7VjdK9Oohw7bJkZg2xv8nUF08Nv1n9d6
   g7MQ4xgi8f+UnzCj5Sxa2lmQe4DUF4rq6eZNhcvVkjK29omQFDDw6kpMO
   0FkivfVxS1Hde/cmyQ9fiVlzxedq6dsuP6vwVp8zRpr5DvKbTFbRHL/dh
   w==;
X-CSE-ConnectionGUID: 1AgOhz6PTqivFoYqg3hEEQ==
X-CSE-MsgGUID: E9zgpTG4SPCdz6BrbOgVOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87514314"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="87514314"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:20 -0700
X-CSE-ConnectionGUID: po6AZFwiRKac3YLeFsda/w==
X-CSE-MsgGUID: YAUdhBfGS8izUoGsuMxLsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="249080656"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:20 -0700
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
Subject: [PATCH v5 09/10] fs/resctrl: Communicate resource group deleted error via last_cmd_status
Date: Tue, 30 Jun 2026 21:27:09 -0700
Message-ID: <9982141ec6f3ec18e0c53d7feabb19651583cf0e.1782857711.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782857711.git.reinette.chatre@intel.com>
References: <cover.1782857711.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

User space expects last_cmd_status to contain additional information if
any resctrl command fails.

A resctrl command may be blocked waiting on the rdtgroup_mutex waiting for
another command to finish and find that once the mutex is available that
the resource group has since been deleted. In this scenario the command
will fail while last_cmd_status contains either "ok" if the last_cmd_status
buffer is empty or an outdated error from a previous command failure if
last_cmd_status buffer has content.

Include clearing of last_cmd_status buffer as part of
rdtgroup_kn_lock_live() that is used to obtain access and needed locking
to a resource group before attempting a command on the group. With the
last_cmd_status buffer ready, provide an appropriate message to user space
if the resource group has been deleted.

No last_cmd_status treatment is needed for the remaining failure of
rdtgroup_kn_lock_live() encountering a non-existent resource group since
that could only occur during an attempt to obtain a resource group lock
on a file in info/ which is an invalid usage.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v1:
- Add snippet about why it is safe to dereference the kn to get
  to resource group name when resource group is deleted.

Changes since v4:
- Add Tony's Reviewed-by tag.
---
 fs/resctrl/ctrlmondata.c |  3 ---
 fs/resctrl/monitor.c     |  2 --
 fs/resctrl/rdtgroup.c    | 20 +++++++++++---------
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index 8d5a8b1e659a..18ec9f564b5a 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -317,7 +317,6 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 		rdtgroup_kn_unlock(of->kn);
 		return -ENOENT;
 	}
-	rdt_last_cmd_clear();
 
 	/* Valid input requires a trailing newline */
 	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
@@ -434,7 +433,6 @@ int rdtgroup_schemata_show(struct kernfs_open_file *of,
 			}
 		} else if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
 			if (!rdtgrp->plr->d) {
-				rdt_last_cmd_clear();
 				rdt_last_cmd_puts("Cache domain offline\n");
 				ret = -ENODEV;
 			} else {
@@ -475,7 +473,6 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
 		rdtgroup_kn_unlock(of->kn);
 		return -ENOENT;
 	}
-	rdt_last_cmd_clear();
 
 	/* Valid input requires a trailing newline */
 	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index b50da2b02594..73413cb128ea 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1696,7 +1696,6 @@ int mbm_L3_assignments_show(struct kernfs_open_file *of, struct seq_file *s, voi
 		goto out_unlock;
 	}
 
-	rdt_last_cmd_clear();
 	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
 		rdt_last_cmd_puts("mbm_event counter assignment mode is not enabled\n");
 		ret = -EINVAL;
@@ -1836,7 +1835,6 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
 		rdtgroup_kn_unlock(of->kn);
 		return -ENOENT;
 	}
-	rdt_last_cmd_clear();
 
 	/* Valid input requires a trailing newline */
 	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 0e428d337641..fa456c469386 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -359,7 +359,6 @@ static int rdtgroup_cpus_show(struct kernfs_open_file *of,
 	if (rdtgrp) {
 		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
 			if (!rdtgrp->plr->d) {
-				rdt_last_cmd_clear();
 				rdt_last_cmd_puts("Cache domain offline\n");
 				ret = -ENODEV;
 			} else {
@@ -522,8 +521,6 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 		goto out_unlock;
 	}
 
-	rdt_last_cmd_clear();
-
 	if (!buf) {
 		rdt_last_cmd_printf("%s: Invalid input\n",
 				    is_cpu_list(of) ? "cpus_list" : "cpus");
@@ -788,7 +785,6 @@ static ssize_t rdtgroup_tasks_write(struct kernfs_open_file *of,
 		rdtgroup_kn_unlock(of->kn);
 		return -ENOENT;
 	}
-	rdt_last_cmd_clear();
 
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED ||
 	    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP) {
@@ -1530,7 +1526,6 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
 		return -ENOENT;
 	}
 
-	rdt_last_cmd_clear();
 	/* Valid input requires a trailing newline */
 	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
 		rdt_last_cmd_puts("mode: Invalid input\n");
@@ -1667,7 +1662,6 @@ static int rdtgroup_size_show(struct kernfs_open_file *of,
 
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
 		if (!rdtgrp->plr->d) {
-			rdt_last_cmd_clear();
 			rdt_last_cmd_puts("Cache domain offline\n");
 			ret = -ENODEV;
 		} else {
@@ -2728,10 +2722,20 @@ struct rdtgroup *rdtgroup_kn_lock_live(struct kernfs_node *kn)
 
 	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
+	rdt_last_cmd_clear();
 
 	/* Was this group deleted while we waited? */
-	if (rdtgrp->flags & RDT_DELETED)
+	if (rdtgrp->flags & RDT_DELETED) {
+		/*
+		 * It is safe to dereference kn to obtain the resource group's
+		 * name because one extra reference to kn is obtained
+		 * during resource group creation that will be released by
+		 * rdtgroup_remove() called by rdtgroup_kn_put().
+		 */
+		rdt_last_cmd_printf("Resource group %s deleted. No commands possible.\n",
+				    rdt_kn_name(rdtgrp->kn));
 		return NULL;
+	}
 
 	return rdtgrp;
 }
@@ -3945,8 +3949,6 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 		goto out_unlock;
 	}
 
-	rdt_last_cmd_clear();
-
 	/*
 	 * Check that the parent directory for a monitor group is a "mon_groups"
 	 * directory.
-- 
2.54.0

