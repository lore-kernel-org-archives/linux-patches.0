Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104DC155732;
	Mon, 16 Sep 2024 12:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488185; cv=none; b=D5iuhfZV4Z24UolqudTcqzcFaO9R2cNP/DsE5Cn3lm4eVVtYSeEEJJCNOG/aKE+pSeMWpO9Tw72BDDCcacRWA7WttIFS8+Vtfam8aoSyJezjhMVJxE8TQXwqh1w3bo0Ywky9wunzY4TrF1/KJhGvJX4TUS+Wz1ewSuT8PlY6bFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488185; c=relaxed/simple;
	bh=siRCnTcuZ6MR0tvaUs+9qZ3HwG2DjyW8XpSdmgcP1Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFEn379binVQAReAgx2EFLwyMdOaOpIGQLQilR525x6IgeEgWQusAaUZm7aUwy6/lyxT5n/AUH23aUjy3awQUgrHilhRVKZXSfgg9haTtOUKFNCktGIcXdL90uglj6OfmM/mAEy5YcaRRUGWpIzvtcwSydM89pkrhURfPRKM7MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2WnRRPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2WnRRPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C62C4CEC4;
	Mon, 16 Sep 2024 12:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488184;
	bh=siRCnTcuZ6MR0tvaUs+9qZ3HwG2DjyW8XpSdmgcP1Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2WnRRPI26cUAtEMihtqxBB9S8yoJ7J3b9HiwipwoHRBsKrV8rw5YKOYbhdA7HrqN
	 jy1AX3AqWZdtgh7z6MxN735NDHBQ4vm/7tN63tD9o/28CzMQibpRJS/c0O/aC3f7hM
	 8xfcDG276mLSLQ/NSy1nlG6HBpsiRHfRE+sqjSj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 024/121] cgroup/cpuset: Eliminate unncessary sched domains rebuilds in hotplug
Date: Mon, 16 Sep 2024 13:43:18 +0200
Message-ID: <20240916114229.798019521@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit ff0ce721ec213499ec5a532041fb3a1db2dc5ecb ]

It was found that some hotplug operations may cause multiple
rebuild_sched_domains_locked() calls. Some of those intermediate calls
may use cpuset states not in the final correct form leading to incorrect
sched domain setting.

Fix this problem by using the existing force_rebuild flag to inhibit
immediate rebuild_sched_domains_locked() calls if set and only doing
one final call at the end. Also renaming the force_rebuild flag to
force_sd_rebuild to make its meaning for clear.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e8f24483e05f..c03a2bc106d4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -223,6 +223,13 @@ static cpumask_var_t	isolated_cpus;
 /* List of remote partition root children */
 static struct list_head remote_children;
 
+/*
+ * A flag to force sched domain rebuild at the end of an operation while
+ * inhibiting it in the intermediate stages when set. Currently it is only
+ * set in hotplug code.
+ */
+static bool force_sd_rebuild;
+
 /*
  * Partition root states:
  *
@@ -1442,7 +1449,7 @@ static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
 			clear_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	}
 
-	if (rebuild_domains)
+	if (rebuild_domains && !force_sd_rebuild)
 		rebuild_sched_domains_locked();
 }
 
@@ -1805,7 +1812,7 @@ static void remote_partition_check(struct cpuset *cs, struct cpumask *newmask,
 			remote_partition_disable(child, tmp);
 			disable_cnt++;
 		}
-	if (disable_cnt)
+	if (disable_cnt && !force_sd_rebuild)
 		rebuild_sched_domains_locked();
 }
 
@@ -2415,7 +2422,8 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 	}
 	rcu_read_unlock();
 
-	if (need_rebuild_sched_domains && !(flags & HIER_NO_SD_REBUILD))
+	if (need_rebuild_sched_domains && !(flags & HIER_NO_SD_REBUILD) &&
+	    !force_sd_rebuild)
 		rebuild_sched_domains_locked();
 }
 
@@ -3077,7 +3085,8 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	cs->flags = trialcs->flags;
 	spin_unlock_irq(&callback_lock);
 
-	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
+	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed &&
+	    !force_sd_rebuild)
 		rebuild_sched_domains_locked();
 
 	if (spread_flag_changed)
@@ -4478,11 +4487,9 @@ hotplug_update_tasks(struct cpuset *cs,
 		update_tasks_nodemask(cs);
 }
 
-static bool force_rebuild;
-
 void cpuset_force_rebuild(void)
 {
-	force_rebuild = true;
+	force_sd_rebuild = true;
 }
 
 /**
@@ -4630,15 +4637,9 @@ static void cpuset_handle_hotplug(void)
 		       !cpumask_empty(subpartitions_cpus);
 	mems_updated = !nodes_equal(top_cpuset.effective_mems, new_mems);
 
-	/*
-	 * In the rare case that hotplug removes all the cpus in
-	 * subpartitions_cpus, we assumed that cpus are updated.
-	 */
-	if (!cpus_updated && !cpumask_empty(subpartitions_cpus))
-		cpus_updated = true;
-
 	/* For v1, synchronize cpus_allowed to cpu_active_mask */
 	if (cpus_updated) {
+		cpuset_force_rebuild();
 		spin_lock_irq(&callback_lock);
 		if (!on_dfl)
 			cpumask_copy(top_cpuset.cpus_allowed, &new_cpus);
@@ -4694,8 +4695,8 @@ static void cpuset_handle_hotplug(void)
 	}
 
 	/* rebuild sched domains if cpus_allowed has changed */
-	if (cpus_updated || force_rebuild) {
-		force_rebuild = false;
+	if (force_sd_rebuild) {
+		force_sd_rebuild = false;
 		rebuild_sched_domains_cpuslocked();
 	}
 
-- 
2.43.0



