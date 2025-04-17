Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0430825DAF9;
	Thu, 17 Apr 2025 18:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915122; cv=none; b=e8ef5Ronl+zOCvHx6d7hd3hUrxvbPHHWYVUp1jZhTVDbWSqjyN4TmIryFmnlpftYD1iq9n2nhMl7zy+q8yBT9/X3UJtdyz+4d/HD9eoLX5z7fKqQTNnEbohgZt9uikugSjs4WrxpjocBGXBiBlZ3XOBoaOgjPJZkPpp8StcXVCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915122; c=relaxed/simple;
	bh=YABnuamHG4xBAV802SC0m28upVEFB6GLq1zobwgVAJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVhEjfWGLslkxthmHYt85kk+2VvlzXT0ad2qXoVMHo/gj79PyFqcf3KcpVHWXS8h5+3hvOq+MJ+rs61aCLHLMlB+GJ3tKYBRQfWj/qIAg77R/kJDsl49+8ksNKFtcfQBnzlTL53cU6F9hOXgELtJv3YHvgh5zO/j7N1bMJsTyR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZE0KT7nB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZE0KT7nB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71107C4CEE4;
	Thu, 17 Apr 2025 18:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915121;
	bh=YABnuamHG4xBAV802SC0m28upVEFB6GLq1zobwgVAJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZE0KT7nBRJH8NaSDiHzaa4bp3wPkjQdhExEIMPIrpFb+mXEDCDeQeUM7Ypu5vzCw1
	 7KmyUHVGCnaz8SpiCy+CVIusciy7EU92/URSld1gsyYW4MCblzbVQ6HpdzzQPhTIpB
	 cIpaIaJnv6XamLT+++sE4OUlkscVwd5DkZKAdJ0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juri Lelli <juri.lelli@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/393] cgroup/cpuset: Enforce at most one rebuild_sched_domains_locked() call per operation
Date: Thu, 17 Apr 2025 19:46:54 +0200
Message-ID: <20250417175107.784721165@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit a040c351283e3ac75422621ea205b1d8d687e108 ]

Since commit ff0ce721ec21 ("cgroup/cpuset: Eliminate unncessary
sched domains rebuilds in hotplug"), there is only one
rebuild_sched_domains_locked() call per hotplug operation. However,
writing to the various cpuset control files may still casue more than
one rebuild_sched_domains_locked() call to happen in some cases.

Juri had found that two rebuild_sched_domains_locked() calls in
update_prstate(), one from update_cpumasks_hier() and another one from
update_partition_sd_lb() could cause cpuset partition to be created
with null total_bw for DL tasks. IOW, DL tasks may not be scheduled
correctly in such a partition.

A sample command sequence that can reproduce null total_bw is as
follows.

  # echo Y >/sys/kernel/debug/sched/verbose
  # echo +cpuset >/sys/fs/cgroup/cgroup.subtree_control
  # mkdir /sys/fs/cgroup/test
  # echo 0-7 > /sys/fs/cgroup/test/cpuset.cpus
  # echo 6-7 > /sys/fs/cgroup/test/cpuset.cpus.exclusive
  # echo root >/sys/fs/cgroup/test/cpuset.cpus.partition

Fix this double rebuild_sched_domains_locked() calls problem
by replacing existing calls with cpuset_force_rebuild() except
the rebuild_sched_domains_cpuslocked() call at the end of
cpuset_handle_hotplug(). Checking of the force_sd_rebuild flag is
now done at the end of cpuset_write_resmask() and update_prstate()
to determine if rebuild_sched_domains_locked() should be called or not.

The cpuset v1 code can still call rebuild_sched_domains_locked()
directly as double rebuild_sched_domains_locked() calls is not possible.

Reported-by: Juri Lelli <juri.lelli@redhat.com>
Closes: https://lore.kernel.org/lkml/ZyuUcJDPBln1BK1Y@jlelli-thinkpadt14gen4.remote.csb/
Signed-off-by: Waiman Long <longman@redhat.com>
Tested-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: a22b3d54de94 ("cgroup/cpuset: Fix race between newly created partition and dying one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 49 ++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 0012c34bb8601..7ac2a634128b3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -84,9 +84,19 @@ static bool		have_boot_isolcpus;
 static struct list_head remote_children;
 
 /*
- * A flag to force sched domain rebuild at the end of an operation while
- * inhibiting it in the intermediate stages when set. Currently it is only
- * set in hotplug code.
+ * A flag to force sched domain rebuild at the end of an operation.
+ * It can be set in
+ *  - update_partition_sd_lb()
+ *  - remote_partition_check()
+ *  - update_cpumasks_hier()
+ *  - cpuset_update_flag()
+ *  - cpuset_hotplug_update_tasks()
+ *  - cpuset_handle_hotplug()
+ *
+ * Protected by cpuset_mutex (with cpus_read_lock held) or cpus_write_lock.
+ *
+ * Note that update_relax_domain_level() in cpuset-v1.c can still call
+ * rebuild_sched_domains_locked() directly without using this flag.
  */
 static bool force_sd_rebuild;
 
@@ -998,6 +1008,7 @@ void rebuild_sched_domains_locked(void)
 
 	lockdep_assert_cpus_held();
 	lockdep_assert_held(&cpuset_mutex);
+	force_sd_rebuild = false;
 
 	/*
 	 * If we have raced with CPU hotplug, return early to avoid
@@ -1172,8 +1183,8 @@ static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
 			clear_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	}
 
-	if (rebuild_domains && !force_sd_rebuild)
-		rebuild_sched_domains_locked();
+	if (rebuild_domains)
+		cpuset_force_rebuild();
 }
 
 /*
@@ -1530,8 +1541,8 @@ static void remote_partition_check(struct cpuset *cs, struct cpumask *newmask,
 			remote_partition_disable(child, tmp);
 			disable_cnt++;
 		}
-	if (disable_cnt && !force_sd_rebuild)
-		rebuild_sched_domains_locked();
+	if (disable_cnt)
+		cpuset_force_rebuild();
 }
 
 /*
@@ -2124,8 +2135,8 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 	}
 	rcu_read_unlock();
 
-	if (need_rebuild_sched_domains && !force_sd_rebuild)
-		rebuild_sched_domains_locked();
+	if (need_rebuild_sched_domains)
+		cpuset_force_rebuild();
 }
 
 /**
@@ -2744,9 +2755,13 @@ int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	cs->flags = trialcs->flags;
 	spin_unlock_irq(&callback_lock);
 
-	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed &&
-	    !force_sd_rebuild)
-		rebuild_sched_domains_locked();
+	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed) {
+		if (!IS_ENABLED(CONFIG_CPUSETS_V1) ||
+		    cgroup_subsys_on_dfl(cpuset_cgrp_subsys))
+			cpuset_force_rebuild();
+		else
+			rebuild_sched_domains_locked();
+	}
 
 	if (spread_flag_changed)
 		cpuset1_update_tasks_flags(cs);
@@ -2866,6 +2881,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	update_partition_sd_lb(cs, old_prs);
 
 	notify_partition_change(cs, old_prs);
+	if (force_sd_rebuild)
+		rebuild_sched_domains_locked();
 	free_cpumasks(NULL, &tmpmask);
 	return 0;
 }
@@ -3136,6 +3153,8 @@ ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	}
 
 	free_cpuset(trialcs);
+	if (force_sd_rebuild)
+		rebuild_sched_domains_locked();
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
 	cpus_read_unlock();
@@ -3879,11 +3898,9 @@ static void cpuset_handle_hotplug(void)
 		rcu_read_unlock();
 	}
 
-	/* rebuild sched domains if cpus_allowed has changed */
-	if (force_sd_rebuild) {
-		force_sd_rebuild = false;
+	/* rebuild sched domains if necessary */
+	if (force_sd_rebuild)
 		rebuild_sched_domains_cpuslocked();
-	}
 
 	free_cpumasks(NULL, ptmp);
 }
-- 
2.39.5



