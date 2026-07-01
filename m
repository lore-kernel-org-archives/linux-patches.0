Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C075A392820
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 04:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782880051; cv=none; b=RoZWcH1abynIXyjK2tD8oNz5Cj69EnIUVAVVQrRNbmywOQC+mFlK1aj4avvniBKP8fZbB6LDy59sz6ikO/gbm0iIq5JkitNB/Lnjl58GRGsA+mF+CHN3gIrIoiGZ93S1i+p8DVS6P00iuSPBmWJv++xDpoLitwzHDg48HqTqduc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782880051; c=relaxed/simple;
	bh=yhTBPZF0oaWUidGn7SvU1aUoj+eCSN5+ZbmchkSX58k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLm4jlg6DyNxu4qoFsrtN0F0kpTP2utl6kAc3ViRdcbNtYso43mPjiSsVzeTeWcgAAkpUCGKp7Je4E8wjwurOnnYEqp6wlla+GZ+mexvi281UrIh/c59gOjRHCyIhZ3yIRmmmqALHlw7nOETuZt2KBGe0vVNvLVtStkGeF9CPyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lHzED/At; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lHzED/At"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782880047; x=1814416047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yhTBPZF0oaWUidGn7SvU1aUoj+eCSN5+ZbmchkSX58k=;
  b=lHzED/Atu0xW5iydugsunUUe4Is5Q7ZpKdI5am2TE8P0hHsZf8QfaeBC
   Ip4ntiTptUcY78QLANJyOE4F8+CdqhdP30O1XV/4q5/9G8jThF1z5q9co
   TweM5O7cNuvRGBPN1KMZx5Ebl8W4rjYWxKrRMN1fzYrzEr6Nk3zoG44rR
   xHoN/KLqP+gUbSggSdSzFbo/++cYPwQxM6nAkQBnTnHmWT093Z/FOAkGH
   pNQcnd/PrNw6O3jLjHTrJ1vIpdk5q/IaoQL0smA+mOy3/xz86bqIGdXjq
   kSCoWnmZ1f3wxlCpSg4DpK3V1109fuoUrtkxhu4JvtiD7Vlavrv8NCt59
   A==;
X-CSE-ConnectionGUID: KsR685qNRTu5xohfcrYgDg==
X-CSE-MsgGUID: T9NKMKUtSMSGolPY9bfClw==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87514294"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="87514294"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:20 -0700
X-CSE-ConnectionGUID: vtz4pi+AQM+L0+QfqBKV1w==
X-CSE-MsgGUID: rdZwNilpTPOzZin6dsP/Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="249080630"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:19 -0700
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
Subject: [PATCH v5 07/10] fs/resctrl: Change last_cmd_status custom during input parsing
Date: Tue, 30 Jun 2026 21:27:07 -0700
Message-ID: <c9eba0ef3b9a72b845b4ae02ecd7c098ed8bf06f.1782857711.git.reinette.chatre@intel.com>
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

A pattern of usage of last_cmd_status was introduced during its enabling in
commit

c377dcfbee80 ("x86/intel_rdt: Add diagnostics when writing the schemata file")

and since copied throughout resctrl to result in the following custom:

	..._write()
	{
		/* Early parsing of input, exit on failure. */

		/* Obtain rdtgroup_mutex */
		rdt_last_cmd_clear(); /* Clear last_cmd_status buffer */

		/*
		 * Act on user command, failures result in detail
		 * error message in last_cmd_status buffer via
		 * rdt_last_cmd_puts()/rdt_last_cmd_printf().
		 */

		/* Release rdtgroup_mutex */
	}

If resctrl exits with failure during early parsing of input there are two
possible scenarios:
 - The last_cmd_status buffer is empty and a user's read of
   info/last_cmd_status returns "ok".
 - The last_cmd_status buffer contains details from an earlier ...write()
   failure and a user's read of info/last_cmd_status returns this outdated
   error description.

Writing to a resctrl file is considered a "resctrl command" and the
resctrl documentation states the following about the last_cmd_status file:
   "If the command failed, it will provide more information that can be
    conveyed in the error returns from file operations."
Neither of the current scenarios is correct behavior.

Move early input parsing to be done with rdtgroup_mutex held after the
last_cmd_status buffer is cleared. Let info/last_cmd_status be accurate
when an error is encountered during parsing of user command.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v1:
- Add Ben's RB tag.

Changes since v4:
- Rebase on top of the "x86,fs/resctrl: Fix long-standing issues"
  series that added locking helpers to info file handlers.
- Add resctrl filename to new error messages to disambiguate the
  various "Invalid input" messages. (Tony)
- Add Tony's Reviewed-by tag.
---
 fs/resctrl/ctrlmondata.c | 55 ++++++++++++++++----------
 fs/resctrl/monitor.c     | 60 ++++++++++++++++------------
 fs/resctrl/rdtgroup.c    | 84 +++++++++++++++++++++++-----------------
 3 files changed, 120 insertions(+), 79 deletions(-)

diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index e6ad8927cf50..8d5a8b1e659a 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -312,11 +312,6 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 	char *tok, *resname;
 	int ret = 0;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-	buf[nbytes - 1] = '\0';
-
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 	if (!rdtgrp) {
 		rdtgroup_kn_unlock(of->kn);
@@ -324,6 +319,15 @@ ssize_t rdtgroup_schemata_write(struct kernfs_open_file *of,
 	}
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("schemata: Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	buf[nbytes - 1] = '\0';
+
 	/*
 	 * No changes to pseudo-locked region allowed. It has to be removed
 	 * and re-created instead.
@@ -466,11 +470,6 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
 	struct rdtgroup *rdtgrp;
 	int ret = 0;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-	buf[nbytes - 1] = '\0';
-
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 	if (!rdtgrp) {
 		rdtgroup_kn_unlock(of->kn);
@@ -478,6 +477,15 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
 	}
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("mba_MBps_event: Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	buf[nbytes - 1] = '\0';
+
 	if (!strcmp(buf, "mbm_local_bytes")) {
 		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
 			rdtgrp->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
@@ -495,6 +503,7 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
 	if (ret)
 		rdt_last_cmd_printf("Unsupported event id '%s'\n", buf);
 
+out_unlock:
 	rdtgroup_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
@@ -858,16 +867,18 @@ ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
 	bool enable;
 	int ret;
 
-	ret = kstrtobool(buf, &enable);
-	if (ret)
-		return ret;
-
 	if (!info_kn_lock(of->kn))
 		return -ENOENT;
 
 	r = s->res;
 	rdt_last_cmd_clear();
 
+	ret = kstrtobool(buf, &enable);
+	if (ret) {
+		rdt_last_cmd_puts("io_alloc: Invalid input\n");
+		goto out_unlock;
+	}
+
 	if (!r->cache.io_alloc_capable) {
 		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
 		ret = -ENODEV;
@@ -1022,17 +1033,21 @@ ssize_t resctrl_io_alloc_cbm_write(struct kernfs_open_file *of, char *buf,
 	u32 io_alloc_closid;
 	int ret = 0;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-
-	buf[nbytes - 1] = '\0';
-
 	if (!info_kn_lock(of->kn))
 		return -ENOENT;
 	rdt_last_cmd_clear();
 
 	r = s->res;
+
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("io_alloc_cbm: Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	buf[nbytes - 1] = '\0';
+
 	if (!r->cache.io_alloc_capable) {
 		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
 		ret = -ENODEV;
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 7f3fe055f7c9..b50da2b02594 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1164,14 +1164,16 @@ ssize_t resctrl_mbm_assign_on_mkdir_write(struct kernfs_open_file *of, char *buf
 	bool value;
 	int ret;
 
-	ret = kstrtobool(buf, &value);
-	if (ret)
-		return ret;
-
 	if (!info_kn_lock(of->kn))
 		return -ENOENT;
 	rdt_last_cmd_clear();
 
+	ret = kstrtobool(buf, &value);
+	if (ret) {
+		rdt_last_cmd_puts("mbm_assign_on_mkdir: Invalid input\n");
+		goto out_unlock;
+	}
+
 	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
 		rdt_last_cmd_puts("mbm_event counter assignment mode is not enabled\n");
 		ret = -EINVAL;
@@ -1465,17 +1467,20 @@ ssize_t event_filter_write(struct kernfs_open_file *of, char *buf, size_t nbytes
 	u32 evt_cfg = 0;
 	int ret = 0;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-
-	buf[nbytes - 1] = '\0';
-
 	if (!info_kn_lock(of->kn))
 		return -ENOENT;
 
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("event_filter: Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	buf[nbytes - 1] = '\0';
+
 	r = resctrl_arch_get_resource(mevt->rid);
 	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
 		rdt_last_cmd_puts("mbm_event counter assignment mode is not enabled\n");
@@ -1539,17 +1544,20 @@ ssize_t resctrl_mbm_assign_mode_write(struct kernfs_open_file *of, char *buf,
 	int ret = 0;
 	bool enable;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-
-	buf[nbytes - 1] = '\0';
-
 	if (!info_kn_lock(of->kn))
 		return -ENOENT;
 
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("mbm_assign_mode: Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	buf[nbytes - 1] = '\0';
+
 	if (!strcmp(buf, "default")) {
 		enable = 0;
 	} else if (!strcmp(buf, "mbm_event")) {
@@ -1823,12 +1831,6 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
 	char *token, *event;
 	int ret = 0;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-
-	buf[nbytes - 1] = '\0';
-
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 	if (!rdtgrp) {
 		rdtgroup_kn_unlock(of->kn);
@@ -1836,10 +1838,19 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
 	}
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("mbm_L3_assignments: Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	buf[nbytes - 1] = '\0';
+
 	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
 		rdt_last_cmd_puts("mbm_event mode is not enabled\n");
-		rdtgroup_kn_unlock(of->kn);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_unlock;
 	}
 
 	while ((token = strsep(&buf, "\n")) != NULL) {
@@ -1855,6 +1866,7 @@ ssize_t mbm_L3_assignments_write(struct kernfs_open_file *of, char *buf,
 			break;
 	}
 
+out_unlock:
 	rdtgroup_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index b5fb59d0e035..a5fe76b0e9eb 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -511,38 +511,40 @@ static int cpus_ctrl_write(struct rdtgroup *rdtgrp, cpumask_var_t newmask,
 static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 				   char *buf, size_t nbytes, loff_t off)
 {
-	cpumask_var_t tmpmask, newmask, tmpmask1;
+	cpumask_var_t tmpmask = CPUMASK_VAR_NULL, newmask = CPUMASK_VAR_NULL;
+	cpumask_var_t tmpmask1 = CPUMASK_VAR_NULL;
 	struct rdtgroup *rdtgrp;
 	int ret;
 
-	if (!buf)
-		return -EINVAL;
-
-	if (!zalloc_cpumask_var(&tmpmask, GFP_KERNEL))
-		return -ENOMEM;
-	if (!zalloc_cpumask_var(&newmask, GFP_KERNEL)) {
-		free_cpumask_var(tmpmask);
-		return -ENOMEM;
-	}
-	if (!zalloc_cpumask_var(&tmpmask1, GFP_KERNEL)) {
-		free_cpumask_var(tmpmask);
-		free_cpumask_var(newmask);
-		return -ENOMEM;
-	}
-
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 	if (!rdtgrp) {
 		ret = -ENOENT;
-		goto unlock;
+		goto out_unlock;
 	}
 
 	rdt_last_cmd_clear();
 
+	if (!buf) {
+		rdt_last_cmd_printf("%s: Invalid input\n",
+				    is_cpu_list(of) ? "cpus_list" : "cpus");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (!zalloc_cpumask_var(&tmpmask, GFP_KERNEL) ||
+	    !zalloc_cpumask_var(&newmask, GFP_KERNEL) ||
+	    !zalloc_cpumask_var(&tmpmask1, GFP_KERNEL)) {
+		rdt_last_cmd_printf("%s: Kernel allocation failure\n",
+				    is_cpu_list(of) ? "cpus_list" : "cpus");
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED ||
 	    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP) {
 		ret = -EINVAL;
 		rdt_last_cmd_puts("Pseudo-locking in progress\n");
-		goto unlock;
+		goto out_free;
 	}
 
 	if (is_cpu_list(of))
@@ -552,7 +554,7 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 
 	if (ret) {
 		rdt_last_cmd_puts("Bad CPU list/mask\n");
-		goto unlock;
+		goto out_free;
 	}
 
 	/* check that user didn't specify any offline cpus */
@@ -560,7 +562,7 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 	if (!cpumask_empty(tmpmask)) {
 		ret = -EINVAL;
 		rdt_last_cmd_puts("Can only assign online CPUs\n");
-		goto unlock;
+		goto out_free;
 	}
 
 	if (rdtgrp->type == RDTCTRL_GROUP)
@@ -570,11 +572,12 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 	else
 		ret = -EINVAL;
 
-unlock:
-	rdtgroup_kn_unlock(of->kn);
+out_free:
 	free_cpumask_var(tmpmask);
 	free_cpumask_var(newmask);
 	free_cpumask_var(tmpmask1);
+out_unlock:
+	rdtgroup_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
 }
@@ -1515,11 +1518,6 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
 	enum rdtgrp_mode mode;
 	int ret = 0;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-	buf[nbytes - 1] = '\0';
-
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 	if (!rdtgrp) {
 		rdtgroup_kn_unlock(of->kn);
@@ -1527,6 +1525,14 @@ static ssize_t rdtgroup_mode_write(struct kernfs_open_file *of,
 	}
 
 	rdt_last_cmd_clear();
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("mode: Invalid input\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	buf[nbytes - 1] = '\0';
 
 	mode = rdtgrp->mode;
 
@@ -1858,19 +1864,23 @@ static ssize_t mbm_total_bytes_config_write(struct kernfs_open_file *of,
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 	int ret;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-
 	if (!info_kn_lock(of->kn))
 		return -ENOENT;
 
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("mbm_total_bytes_config: Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	buf[nbytes - 1] = '\0';
 
 	ret = mon_config_write(r, buf, QOS_L3_MBM_TOTAL_EVENT_ID);
 
+out_unlock:
 	info_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
@@ -1883,19 +1893,23 @@ static ssize_t mbm_local_bytes_config_write(struct kernfs_open_file *of,
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 	int ret;
 
-	/* Valid input requires a trailing newline */
-	if (nbytes == 0 || buf[nbytes - 1] != '\n')
-		return -EINVAL;
-
 	if (!info_kn_lock(of->kn))
 		return -ENOENT;
 
 	rdt_last_cmd_clear();
 
+	/* Valid input requires a trailing newline */
+	if (nbytes == 0 || buf[nbytes - 1] != '\n') {
+		rdt_last_cmd_puts("mbm_local_bytes_config: Invalid input\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	buf[nbytes - 1] = '\0';
 
 	ret = mon_config_write(r, buf, QOS_L3_MBM_LOCAL_EVENT_ID);
 
+out_unlock:
 	info_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
-- 
2.54.0

