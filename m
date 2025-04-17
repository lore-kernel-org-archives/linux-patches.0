Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0233594D;
	Thu, 17 Apr 2025 18:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913821; cv=none; b=fWtRmMjQONOkL/nKacGStB4nrmGl+Icz175lVl9Z4zGB0WP7or0WXMRlEtqVoNihAP95GN0oJxl0s3zqxjEML9HhGQ7iqagUI3Rv+o8Ll+lrdGcVBQ6CTesfC2ODfMW3jtz4kiuAfZEaawFVVFJnoCltV0mqYRZbOxteFgCHeo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913821; c=relaxed/simple;
	bh=Gz0onp/4i6eLdmBgeyCJVOWJ1I0eRhQJYvmBKYuTuUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8eFvfBcYGbQYFYXN6QuX7yYKOIQDx9DW1SRrJvrPiGAYKADm0MTERYMt7Dl31KPy3UZCNK7U13TIt5y/BDHUoBTEvPIoMJON7PxN6bWkKi+ffrlAG0jjVY83pFWhXSgxbSAmEwrqKcoMW6XLznuhycWBT+rDLosaYxKBUuKHEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1A+jtADJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1A+jtADJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5D5C4CEE4;
	Thu, 17 Apr 2025 18:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913820;
	bh=Gz0onp/4i6eLdmBgeyCJVOWJ1I0eRhQJYvmBKYuTuUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1A+jtADJ7vvNcgDzPHu6G4VrSwXw+6AIqenDzZyGwF4TbVlmb+kdiDw+I4jbJGMA6
	 txo5fYOM/+3r18dhCz2golIXp9Lyljy/GhXFUBgjEumO5wZHEHGbEt61pp1NI52+zR
	 kTkmV4k/lCH9X6ua4FtU1eJllaMuWnzGdHI1rGJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 004/414] cgroup/cpuset: Fix race between newly created partition and dying one
Date: Thu, 17 Apr 2025 19:46:02 +0200
Message-ID: <20250417175111.575545729@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit a22b3d54de94f82ca057cc2ebf9496fa91ebf698 ]

There is a possible race between removing a cgroup diectory that is
a partition root and the creation of a new partition.  The partition
to be removed can be dying but still online, it doesn't not currently
participate in checking for exclusive CPUs conflict, but the exclusive
CPUs are still there in subpartitions_cpus and isolated_cpus. These
two cpumasks are global states that affect the operation of cpuset
partitions. The exclusive CPUs in dying cpusets will only be removed
when cpuset_css_offline() function is called after an RCU delay.

As a result, it is possible that a new partition can be created with
exclusive CPUs that overlap with those of a dying one. When that dying
partition is finally offlined, it removes those overlapping exclusive
CPUs from subpartitions_cpus and maybe isolated_cpus resulting in an
incorrect CPU configuration.

This bug was found when a warning was triggered in
remote_partition_disable() during testing because the subpartitions_cpus
mask was empty.

One possible way to fix this is to iterate the dying cpusets as well and
avoid using the exclusive CPUs in those dying cpusets. However, this
can still cause random partition creation failures or other anomalies
due to racing. A better way to fix this race is to reset the partition
state at the moment when a cpuset is being killed.

Introduce a new css_killed() CSS function pointer and call it, if
defined, before setting CSS_DYING flag in kill_css(). Also update the
css_is_dying() helper to use the CSS_DYING flag introduced by commit
33c35aa48178 ("cgroup: Prevent kill_css() from being called more than
once") for proper synchronization.

Add a new cpuset_css_killed() function to reset the partition state of
a valid partition root if it is being killed.

Fixes: ee8dde0cd2ce ("cpuset: Add new v2 cpuset.sched.partition flag")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cgroup-defs.h |  1 +
 include/linux/cgroup.h      |  2 +-
 kernel/cgroup/cgroup.c      |  6 ++++++
 kernel/cgroup/cpuset.c      | 20 +++++++++++++++++---
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 17960a1e858db..d1aee2d3e189e 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -711,6 +711,7 @@ struct cgroup_subsys {
 	void (*css_released)(struct cgroup_subsys_state *css);
 	void (*css_free)(struct cgroup_subsys_state *css);
 	void (*css_reset)(struct cgroup_subsys_state *css);
+	void (*css_killed)(struct cgroup_subsys_state *css);
 	void (*css_rstat_flush)(struct cgroup_subsys_state *css, int cpu);
 	int (*css_extra_stat_show)(struct seq_file *seq,
 				   struct cgroup_subsys_state *css);
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f8ef47f8a634d..fc1324ed597d6 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -343,7 +343,7 @@ static inline u64 cgroup_id(const struct cgroup *cgrp)
  */
 static inline bool css_is_dying(struct cgroup_subsys_state *css)
 {
-	return !(css->flags & CSS_NO_REF) && percpu_ref_is_dying(&css->refcnt);
+	return css->flags & CSS_DYING;
 }
 
 static inline void cgroup_get(struct cgroup *cgrp)
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index afc665b7b1fe5..81f078c059e86 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5909,6 +5909,12 @@ static void kill_css(struct cgroup_subsys_state *css)
 	if (css->flags & CSS_DYING)
 		return;
 
+	/*
+	 * Call css_killed(), if defined, before setting the CSS_DYING flag
+	 */
+	if (css->ss->css_killed)
+		css->ss->css_killed(css);
+
 	css->flags |= CSS_DYING;
 
 	/*
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6c41968bcf4b0..a74df43f77f8f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3486,9 +3486,6 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 	cpus_read_lock();
 	mutex_lock(&cpuset_mutex);
 
-	if (is_partition_valid(cs))
-		update_prstate(cs, 0);
-
 	if (!cpuset_v2() && is_sched_load_balance(cs))
 		cpuset_update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
@@ -3499,6 +3496,22 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 	cpus_read_unlock();
 }
 
+static void cpuset_css_killed(struct cgroup_subsys_state *css)
+{
+	struct cpuset *cs = css_cs(css);
+
+	cpus_read_lock();
+	mutex_lock(&cpuset_mutex);
+
+	/* Reset valid partition back to member */
+	if (is_partition_valid(cs))
+		update_prstate(cs, PRS_MEMBER);
+
+	mutex_unlock(&cpuset_mutex);
+	cpus_read_unlock();
+
+}
+
 static void cpuset_css_free(struct cgroup_subsys_state *css)
 {
 	struct cpuset *cs = css_cs(css);
@@ -3620,6 +3633,7 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
 	.css_alloc	= cpuset_css_alloc,
 	.css_online	= cpuset_css_online,
 	.css_offline	= cpuset_css_offline,
+	.css_killed	= cpuset_css_killed,
 	.css_free	= cpuset_css_free,
 	.can_attach	= cpuset_can_attach,
 	.cancel_attach	= cpuset_cancel_attach,
-- 
2.39.5



