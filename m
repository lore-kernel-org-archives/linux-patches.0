Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC77A374A03
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 21:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781038989; cv=none; b=MOkDDsmJoUExCuopmJjhVUe8DZymeTgztVrwU4qIPZWD5X2Y95fnOVoV+kIejfweW8q6L/FKqKTxzIw7Dyv7x3gk77GYqtX5ppfGXbubUZKgnNyCqbnGTVrUc+qhMz8VTS0QGvxhFfGpHiBtbUwJHGIy6cDdKVg8sCMJhvJS90c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781038989; c=relaxed/simple;
	bh=rw/RMtmGjnLsALK6wTgrci/d5YbDjOf1E3nt5prXDgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=le2yOTL/o17h89/XPP3mEXlYOkuP5Y5MaxLMHbcVeR2LeV35jvc6LeSsarJkj2rKoP/TfwFPE6DdWtbdn9oT+1+AioB+mfN7Uyle1DXCbzdqWgvcYRXiz41sW3vJxR83OwXYUTFmJiKyJk45aDqJpoLaybZmCmYNcRrWWw7xjeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LbLfvsR0; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LbLfvsR0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781038979; x=1812574979;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rw/RMtmGjnLsALK6wTgrci/d5YbDjOf1E3nt5prXDgU=;
  b=LbLfvsR0WqHubB6QJgXd1/GONhvEtdjHxU0vXxJOfzk2/it3ipAZ2W3s
   y466ooKk71G5arEpyIaUL9FVBepxI77baGPNrDikhDRpyOBT3bi2maPAv
   kWWITzUGPPQcEAnj6262WIk5m23j0ZDJ+LMWPrZK31SY6NI1vleZUXiqL
   owCt7UUjrO4ndeYNcdVBLHfVx8IU1RtWvpWW1XPTpA8fPEdNqTtqrxbH+
   aHPXGTcIHRleXpZ8ucMZ3sZZRSnUl0tAuiI61uJ3/oz9H1+Ca4P24jugY
   AOuA5GmnSM0t8Bij4C/jCY/ufG6xR8pLuLZXhCJt2/7TIxvFhZrH1rbiY
   A==;
X-CSE-ConnectionGUID: Zxn924YgQyS/5aDdP7IiOA==
X-CSE-MsgGUID: ROqTU7O5R+ysNSiubNELiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="81725090"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="81725090"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:58 -0700
X-CSE-ConnectionGUID: Si7PehL3QFS3EfhlAIXPjw==
X-CSE-MsgGUID: p7NjSHmCTeGeGT6+BA/NKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="251045742"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:56 -0700
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
Subject: [PATCH v5 09/11] fs/resctrl: Prevent deadlock and use-after-free in info file handlers
Date: Tue,  9 Jun 2026 14:02:35 -0700
Message-ID: <5daffbd831ad0b506566ff280e420954ca5a2b95.1781029125.git.reinette.chatre@intel.com>
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

resctrl provides files under the info/ directory to expose global
configuration and capabilities to userspace. These files are instantiated
statically during filesystem mount and expose data associated with internal
schema structures via kernfs private pointers.

A potential deadlock exists between userspace readers of these info files
and the unmount filesystem teardown process. Reading an info file invokes
kernfs which acquires an active reference, after which the handler typically
attempts to acquire the rdtgroup_mutex. Concurrently, unmounting the
filesystem holds the rdtgroup_mutex and then attempts to recursively
remove the info kernfs nodes involving kernfs_drain() which blocks until
all active references are released. Another problem exists where info files
might be accessed from an outdated mount if the filesystem is unmounted and
remounted during a reader's execution, leading to a use-after-free when
reading the now-deleted private schema data.

Introduce info_kn_lock() and info_kn_unlock() helpers to coordinate locking
across all info handlers. These helpers mirror similar logic used by resource
group handlers by deliberately breaking the kernfs active protection before
attempting to acquire the rdtgroup_mutex, preventing the deadlock. To guard
against the vulnerability from rapid mount cycling, info_kn_lock() securely
walks the parent lineage of the kernfs node under an RCU section to confirm
the node belongs to the globally active root before permitting the operation
to proceed. Convert all info file handlers to use this helper and only
de-reference the schema after it is determined safe to do so.

Make no attempt to output an error message to last_cmd_status on failure
since failure implies there is no filesystem with which to display the error
to user space.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260515193944.15114-1-tony.luck%40intel.com?part=3
Assisted-by: GitHub_Copilot:gemini-3.1-pro
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since V2:
- New patch

Changes since V3:
- Add Tony's Reviewed-by tag.
- Changelog grammar fixes.
---
 fs/resctrl/ctrlmondata.c |  38 ++++----
 fs/resctrl/internal.h    |   3 +-
 fs/resctrl/monitor.c     |  48 +++++-----
 fs/resctrl/rdtgroup.c    | 192 ++++++++++++++++++++++++++++++++-------
 4 files changed, 203 insertions(+), 78 deletions(-)

diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
index f33712c17d38..2b29fb5a8702 100644
--- a/fs/resctrl/ctrlmondata.c
+++ b/fs/resctrl/ctrlmondata.c
@@ -771,10 +771,12 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
 int resctrl_io_alloc_show(struct kernfs_open_file *of, struct seq_file *seq, void *v)
 {
 	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
-	struct rdt_resource *r = s->res;
+	struct rdt_resource *r;
 
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 
+	r = s->res;
 	if (r->cache.io_alloc_capable) {
 		if (resctrl_arch_get_io_alloc_enabled(r))
 			seq_puts(seq, "enabled\n");
@@ -784,7 +786,7 @@ int resctrl_io_alloc_show(struct kernfs_open_file *of, struct seq_file *seq, voi
 		seq_puts(seq, "not supported\n");
 	}
 
-	mutex_unlock(&rdtgroup_mutex);
+	info_kn_unlock(of->kn);
 
 	return 0;
 }
@@ -849,7 +851,7 @@ ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
 			       size_t nbytes, loff_t off)
 {
 	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
-	struct rdt_resource *r = s->res;
+	struct rdt_resource *r;
 	char const *grp_name;
 	u32 io_alloc_closid;
 	bool enable;
@@ -859,9 +861,10 @@ ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
 	if (ret)
 		return ret;
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 
+	r = s->res;
 	rdt_last_cmd_clear();
 
 	if (!r->cache.io_alloc_capable) {
@@ -909,8 +912,7 @@ ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
 	}
 
 out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
+	info_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
 }
@@ -918,14 +920,15 @@ ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
 int resctrl_io_alloc_cbm_show(struct kernfs_open_file *of, struct seq_file *seq, void *v)
 {
 	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
-	struct rdt_resource *r = s->res;
+	struct rdt_resource *r;
 	int ret = 0;
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 
 	rdt_last_cmd_clear();
 
+	r = s->res;
 	if (!r->cache.io_alloc_capable) {
 		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
 		ret = -ENODEV;
@@ -947,8 +950,7 @@ int resctrl_io_alloc_cbm_show(struct kernfs_open_file *of, struct seq_file *seq,
 	show_doms(seq, s, NULL, resctrl_io_alloc_closid(r));
 
 out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
+	info_kn_unlock(of->kn);
 	return ret;
 }
 
@@ -1015,7 +1017,7 @@ ssize_t resctrl_io_alloc_cbm_write(struct kernfs_open_file *of, char *buf,
 				   size_t nbytes, loff_t off)
 {
 	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
-	struct rdt_resource *r = s->res;
+	struct rdt_resource *r;
 	u32 io_alloc_closid;
 	int ret = 0;
 
@@ -1025,10 +1027,11 @@ ssize_t resctrl_io_alloc_cbm_write(struct kernfs_open_file *of, char *buf,
 
 	buf[nbytes - 1] = '\0';
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 	rdt_last_cmd_clear();
 
+	r = s->res;
 	if (!r->cache.io_alloc_capable) {
 		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
 		ret = -ENODEV;
@@ -1053,8 +1056,7 @@ ssize_t resctrl_io_alloc_cbm_write(struct kernfs_open_file *of, char *buf,
 out_clear_configs:
 	rdt_staged_configs_clear();
 out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
+	info_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
 }
diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 48af75b9dc85..e62a277dee85 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -335,8 +335,9 @@ __printf(1, 2)
 void rdt_last_cmd_printf(const char *fmt, ...);
 
 struct rdtgroup *rdtgroup_kn_lock_live(struct kernfs_node *kn);
-
 void rdtgroup_kn_unlock(struct kernfs_node *kn);
+bool info_kn_lock(struct kernfs_node *kn);
+void info_kn_unlock(struct kernfs_node *kn);
 
 int rdtgroup_kn_mode_restrict(struct rdtgroup *r, const char *name);
 
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 2dacb589625d..15e3eeddb6df 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1062,7 +1062,8 @@ int event_filter_show(struct kernfs_open_file *of, struct seq_file *seq, void *v
 	bool sep = false;
 	int ret = 0, i;
 
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 	rdt_last_cmd_clear();
 
 	r = resctrl_arch_get_resource(mevt->rid);
@@ -1083,7 +1084,7 @@ int event_filter_show(struct kernfs_open_file *of, struct seq_file *seq, void *v
 	seq_putc(seq, '\n');
 
 out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
+	info_kn_unlock(of->kn);
 
 	return ret;
 }
@@ -1094,7 +1095,8 @@ int resctrl_mbm_assign_on_mkdir_show(struct kernfs_open_file *of, struct seq_fil
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 	int ret = 0;
 
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 	rdt_last_cmd_clear();
 
 	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
@@ -1106,7 +1108,7 @@ int resctrl_mbm_assign_on_mkdir_show(struct kernfs_open_file *of, struct seq_fil
 	seq_printf(s, "%u\n", r->mon.mbm_assign_on_mkdir);
 
 out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
+	info_kn_unlock(of->kn);
 
 	return ret;
 }
@@ -1122,7 +1124,8 @@ ssize_t resctrl_mbm_assign_on_mkdir_write(struct kernfs_open_file *of, char *buf
 	if (ret)
 		return ret;
 
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 	rdt_last_cmd_clear();
 
 	if (!resctrl_arch_mbm_cntr_assign_enabled(r)) {
@@ -1134,7 +1137,7 @@ ssize_t resctrl_mbm_assign_on_mkdir_write(struct kernfs_open_file *of, char *buf
 	r->mon.mbm_assign_on_mkdir = value;
 
 out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
+	info_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
 }
@@ -1424,8 +1427,8 @@ ssize_t event_filter_write(struct kernfs_open_file *of, char *buf, size_t nbytes
 
 	buf[nbytes - 1] = '\0';
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 
 	rdt_last_cmd_clear();
 
@@ -1448,8 +1451,7 @@ ssize_t event_filter_write(struct kernfs_open_file *of, char *buf, size_t nbytes
 	}
 
 out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
+	info_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
 }
@@ -1460,7 +1462,8 @@ int resctrl_mbm_assign_mode_show(struct kernfs_open_file *of,
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 	bool enabled;
 
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 	enabled = resctrl_arch_mbm_cntr_assign_enabled(r);
 
 	if (r->mon.mbm_cntr_assignable) {
@@ -1479,7 +1482,7 @@ int resctrl_mbm_assign_mode_show(struct kernfs_open_file *of,
 		seq_puts(s, "[default]\n");
 	}
 
-	mutex_unlock(&rdtgroup_mutex);
+	info_kn_unlock(of->kn);
 
 	return 0;
 }
@@ -1498,8 +1501,8 @@ ssize_t resctrl_mbm_assign_mode_write(struct kernfs_open_file *of, char *buf,
 
 	buf[nbytes - 1] = '\0';
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 
 	rdt_last_cmd_clear();
 
@@ -1557,8 +1560,7 @@ ssize_t resctrl_mbm_assign_mode_write(struct kernfs_open_file *of, char *buf,
 	}
 
 out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
+	info_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
 }
@@ -1570,8 +1572,8 @@ int resctrl_num_mbm_cntrs_show(struct kernfs_open_file *of,
 	struct rdt_l3_mon_domain *dom;
 	bool sep = false;
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 
 	list_for_each_entry_rcu(dom, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (sep)
@@ -1582,8 +1584,7 @@ int resctrl_num_mbm_cntrs_show(struct kernfs_open_file *of,
 	}
 	seq_putc(s, '\n');
 
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
+	info_kn_unlock(of->kn);
 	return 0;
 }
 
@@ -1596,8 +1597,8 @@ int resctrl_available_mbm_cntrs_show(struct kernfs_open_file *of,
 	u32 cntrs, i;
 	int ret = 0;
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 
 	rdt_last_cmd_clear();
 
@@ -1623,8 +1624,7 @@ int resctrl_available_mbm_cntrs_show(struct kernfs_open_file *of,
 	seq_putc(s, '\n');
 
 out_unlock:
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
+	info_kn_unlock(of->kn);
 
 	return ret;
 }
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 77c9d22017bc..9f998e394911 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -977,13 +977,14 @@ static int rdt_last_cmd_status_show(struct kernfs_open_file *of,
 {
 	int len;
 
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 	len = seq_buf_used(&last_cmd_status);
 	if (len)
 		seq_printf(seq, "%.*s", len, last_cmd_status_buf);
 	else
 		seq_puts(seq, "ok\n");
-	mutex_unlock(&rdtgroup_mutex);
+	info_kn_unlock(of->kn);
 	return 0;
 }
 
@@ -1002,7 +1003,11 @@ static int rdt_num_closids_show(struct kernfs_open_file *of,
 {
 	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
 
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 	seq_printf(seq, "%u\n", s->num_closid);
+	info_kn_unlock(of->kn);
+
 	return 0;
 }
 
@@ -1010,9 +1015,14 @@ static int rdt_default_ctrl_show(struct kernfs_open_file *of,
 				 struct seq_file *seq, void *v)
 {
 	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
-	struct rdt_resource *r = s->res;
+	struct rdt_resource *r;
 
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
+	r = s->res;
 	seq_printf(seq, "%x\n", resctrl_get_default_ctrl(r));
+	info_kn_unlock(of->kn);
+
 	return 0;
 }
 
@@ -1020,9 +1030,15 @@ static int rdt_min_cbm_bits_show(struct kernfs_open_file *of,
 				 struct seq_file *seq, void *v)
 {
 	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
-	struct rdt_resource *r = s->res;
+	struct rdt_resource *r;
+
 
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
+	r = s->res;
 	seq_printf(seq, "%u\n", r->cache.min_cbm_bits);
+	info_kn_unlock(of->kn);
+
 	return 0;
 }
 
@@ -1030,9 +1046,14 @@ static int rdt_shareable_bits_show(struct kernfs_open_file *of,
 				   struct seq_file *seq, void *v)
 {
 	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
-	struct rdt_resource *r = s->res;
+	struct rdt_resource *r;
 
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
+	r = s->res;
 	seq_printf(seq, "%x\n", r->cache.shareable_bits);
+	info_kn_unlock(of->kn);
+
 	return 0;
 }
 
@@ -1060,15 +1081,16 @@ static int rdt_bit_usage_show(struct kernfs_open_file *of,
 	 */
 	unsigned long sw_shareable = 0, hw_shareable = 0;
 	unsigned long exclusive = 0, pseudo_locked = 0;
-	struct rdt_resource *r = s->res;
 	struct rdt_ctrl_domain *dom;
 	int i, hwb, swb, excl, psl;
+	struct rdt_resource *r;
 	enum rdtgrp_mode mode;
 	bool sep = false;
 	u32 ctrl_val;
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
+	r = s->res;
 	list_for_each_entry_rcu(dom, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (sep)
 			seq_putc(seq, ';');
@@ -1144,8 +1166,7 @@ static int rdt_bit_usage_show(struct kernfs_open_file *of,
 		sep = true;
 	}
 	seq_putc(seq, '\n');
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
+	info_kn_unlock(of->kn);
 	return 0;
 }
 
@@ -1153,9 +1174,14 @@ static int rdt_min_bw_show(struct kernfs_open_file *of,
 			   struct seq_file *seq, void *v)
 {
 	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
-	struct rdt_resource *r = s->res;
+	struct rdt_resource *r;
 
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
+	r = s->res;
 	seq_printf(seq, "%u\n", r->membw.min_bw);
+	info_kn_unlock(of->kn);
+
 	return 0;
 }
 
@@ -1164,8 +1190,12 @@ static int rdt_num_rmids_show(struct kernfs_open_file *of,
 {
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 	seq_printf(seq, "%u\n", r->mon.num_rmid);
 
+	info_kn_unlock(of->kn);
+
 	return 0;
 }
 
@@ -1175,6 +1205,8 @@ static int rdt_mon_features_show(struct kernfs_open_file *of,
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 	struct mon_evt *mevt;
 
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 	for_each_mon_event(mevt) {
 		if (mevt->rid != r->rid || !mevt->enabled)
 			continue;
@@ -1184,6 +1216,8 @@ static int rdt_mon_features_show(struct kernfs_open_file *of,
 			seq_printf(seq, "%s_config\n", mevt->name);
 	}
 
+	info_kn_unlock(of->kn);
+
 	return 0;
 }
 
@@ -1191,9 +1225,14 @@ static int rdt_bw_gran_show(struct kernfs_open_file *of,
 			    struct seq_file *seq, void *v)
 {
 	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
-	struct rdt_resource *r = s->res;
+	struct rdt_resource *r;
 
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
+	r = s->res;
 	seq_printf(seq, "%u\n", r->membw.bw_gran);
+	info_kn_unlock(of->kn);
+
 	return 0;
 }
 
@@ -1201,16 +1240,24 @@ static int rdt_delay_linear_show(struct kernfs_open_file *of,
 				 struct seq_file *seq, void *v)
 {
 	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
-	struct rdt_resource *r = s->res;
+	struct rdt_resource *r;
 
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
+	r = s->res;
 	seq_printf(seq, "%u\n", r->membw.delay_linear);
+	info_kn_unlock(of->kn);
+
 	return 0;
 }
 
 static int max_threshold_occ_show(struct kernfs_open_file *of,
 				  struct seq_file *seq, void *v)
 {
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 	seq_printf(seq, "%u\n", resctrl_rmid_realloc_threshold);
+	info_kn_unlock(of->kn);
 
 	return 0;
 }
@@ -1219,22 +1266,28 @@ static int rdt_thread_throttle_mode_show(struct kernfs_open_file *of,
 					 struct seq_file *seq, void *v)
 {
 	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
-	struct rdt_resource *r = s->res;
+	struct rdt_resource *r;
+
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 
+	r = s->res;
 	switch (r->membw.throttle_mode) {
 	case THREAD_THROTTLE_PER_THREAD:
 		seq_puts(seq, "per-thread\n");
-		return 0;
+		break;
 	case THREAD_THROTTLE_MAX:
 		seq_puts(seq, "max\n");
-		return 0;
+		break;
 	case THREAD_THROTTLE_UNDEFINED:
 		seq_puts(seq, "undefined\n");
-		return 0;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
 	}
 
-	WARN_ON_ONCE(1);
-
+	info_kn_unlock(of->kn);
 	return 0;
 }
 
@@ -1248,12 +1301,20 @@ static ssize_t max_threshold_occ_write(struct kernfs_open_file *of,
 	if (ret)
 		return ret;
 
-	if (bytes > resctrl_rmid_realloc_limit)
-		return -EINVAL;
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
+
+	if (bytes > resctrl_rmid_realloc_limit) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
 
 	resctrl_rmid_realloc_threshold = resctrl_arch_round_mon_val(bytes);
 
-	return nbytes;
+out_unlock:
+	info_kn_unlock(of->kn);
+
+	return ret ?: nbytes;
 }
 
 /*
@@ -1293,10 +1354,15 @@ static int rdt_has_sparse_bitmasks_show(struct kernfs_open_file *of,
 					struct seq_file *seq, void *v)
 {
 	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
-	struct rdt_resource *r = s->res;
+	struct rdt_resource *r;
 
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
+	r = s->res;
 	seq_printf(seq, "%u\n", r->cache.arch_has_sparse_bitmasks);
 
+	info_kn_unlock(of->kn);
+
 	return 0;
 }
 
@@ -1652,8 +1718,8 @@ static int mbm_config_show(struct seq_file *s, struct rdt_resource *r, u32 evtid
 	struct rdt_l3_mon_domain *dom;
 	bool sep = false;
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
+	lockdep_assert_cpus_held();
+	lockdep_assert_held(&rdtgroup_mutex);
 
 	list_for_each_entry_rcu(dom, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
 		if (sep)
@@ -1670,8 +1736,6 @@ static int mbm_config_show(struct seq_file *s, struct rdt_resource *r, u32 evtid
 	}
 	seq_puts(s, "\n");
 
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
 
 	return 0;
 }
@@ -1681,8 +1745,12 @@ static int mbm_total_bytes_config_show(struct kernfs_open_file *of,
 {
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
+
 	mbm_config_show(seq, r, QOS_L3_MBM_TOTAL_EVENT_ID);
 
+	info_kn_unlock(of->kn);
 	return 0;
 }
 
@@ -1691,8 +1759,12 @@ static int mbm_local_bytes_config_show(struct kernfs_open_file *of,
 {
 	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
 
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
+
 	mbm_config_show(seq, r, QOS_L3_MBM_LOCAL_EVENT_ID);
 
+	info_kn_unlock(of->kn);
 	return 0;
 }
 
@@ -1790,8 +1862,8 @@ static ssize_t mbm_total_bytes_config_write(struct kernfs_open_file *of,
 	if (nbytes == 0 || buf[nbytes - 1] != '\n')
 		return -EINVAL;
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 
 	rdt_last_cmd_clear();
 
@@ -1799,8 +1871,7 @@ static ssize_t mbm_total_bytes_config_write(struct kernfs_open_file *of,
 
 	ret = mon_config_write(r, buf, QOS_L3_MBM_TOTAL_EVENT_ID);
 
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
+	info_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
 }
@@ -1816,8 +1887,8 @@ static ssize_t mbm_local_bytes_config_write(struct kernfs_open_file *of,
 	if (nbytes == 0 || buf[nbytes - 1] != '\n')
 		return -EINVAL;
 
-	cpus_read_lock();
-	mutex_lock(&rdtgroup_mutex);
+	if (!info_kn_lock(of->kn))
+		return -ENOENT;
 
 	rdt_last_cmd_clear();
 
@@ -1825,8 +1896,7 @@ static ssize_t mbm_local_bytes_config_write(struct kernfs_open_file *of,
 
 	ret = mon_config_write(r, buf, QOS_L3_MBM_LOCAL_EVENT_ID);
 
-	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
+	info_kn_unlock(of->kn);
 
 	return ret ?: nbytes;
 }
@@ -2659,6 +2729,58 @@ void rdtgroup_kn_unlock(struct kernfs_node *kn)
 	rdtgroup_kn_put(rdtgrp, kn);
 }
 
+/*
+ * Accessing the kn after breaking active protection is safe since the open
+ * of resctrl file holds a kernfs base reference (different from active
+ * protection) on the kn ensuring that it remains accessible even if it was
+ * unlinked. Each kn in turn holds base reference to parent so the kn's
+ * genealogy remains in memory until all base references dropped.
+ */
+static bool is_active_resctrl_node(struct kernfs_node *kn)
+{
+	struct kernfs_node *p;
+	bool match = false;
+
+	guard(rcu)();
+	p = kn;
+	while (p) {
+		if (p == rdtgroup_default.kn) {
+			match = true;
+			break;
+		}
+		p = rcu_dereference(p->__parent);
+	}
+
+	return match;
+}
+
+bool info_kn_lock(struct kernfs_node *kn)
+{
+	kernfs_break_active_protection(kn);
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+
+	/*
+	 * Check both if resctrl is torn down (!rdtgroup_default.kn) and
+	 * if the reader's kernfs_node originates from a dead mount.
+	 */
+	if (!rdtgroup_default.kn || !is_active_resctrl_node(kn)) {
+		mutex_unlock(&rdtgroup_mutex);
+		cpus_read_unlock();
+		kernfs_unbreak_active_protection(kn);
+		return false;
+	}
+
+	return true;
+}
+
+void info_kn_unlock(struct kernfs_node *kn)
+{
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+	kernfs_unbreak_active_protection(kn);
+}
+
 static int mkdir_mondata_all(struct kernfs_node *parent_kn,
 			     struct rdtgroup *prgrp,
 			     struct kernfs_node **mon_data_kn);
-- 
2.50.1

