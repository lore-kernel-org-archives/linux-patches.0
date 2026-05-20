Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A5D3F0773;
	Wed, 20 May 2026 17:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296655; cv=none; b=hS5GF6KQhxsB9oUFNf0WKJo/ZvzX744xsZdczo1VaWbptD5jl5MlP6GsU9SQamD1w/OQc6/zjvEzMW+5OBreLb8v8mHxuUB+ahmJ7RhCQTD2NR+nQ9//O1QiNIXVWMj9MkoZYB379/z8SoOHXgrkQfQGo/RwBgXClLW2WaOajWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296655; c=relaxed/simple;
	bh=UE8jsOts6OgcflGg8nN6XdrNp6PtFizQUPcH/E4BtRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRK7EBZ8y0xtAXVC79Y37Ztcrtb/SjpuAWqZZz7wlCBImufo//xsV9h1cqBPRcGpgBXpLcDhg7IoQU41ZdOvw6myFwM3KuXRxtjd9Rlv924VfmBZ0nr2X2XWLATlgMIBYIN6+SNJ1ZGWRMnDwL4sg3X68rgMi9vfuixZ4hYgZr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HScTJVkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HScTJVkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644E71F000E9;
	Wed, 20 May 2026 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296653;
	bh=DRMi9S+6rnurRxIdgJ2NghaIPtqUwfaLlFn6SzhCnzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HScTJVkHcDL4DZ9wbCBkcxb8fIMaF4vTr6tDJvyr5htASYetJtz9lSOhq4xsUukFr
	 yPbg7cOxXKQI1/dT+Ypt+xDG6wl8LHAwiBxD45VShgeTlkpOOA+Gvluo1c5A5ANzAu
	 IM5HZ4TyG6J404cY4LBMVa39gW23Ybz7GDnrxmy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0882/1146] cgroup/cpuset: record DL BW alloc CPU for attach rollback
Date: Wed, 20 May 2026 18:18:52 +0200
Message-ID: <20260520162208.199307138@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

[ Upstream commit 41d701ddc36d5301b44ea79529f3cf03c541c1e1 ]

cpuset_can_attach() allocates DL bandwidth only when migrating
deadline tasks to a disjoint CPU mask, but cpuset_cancel_attach()
rolls back based only on nr_migrate_dl_tasks. This makes the DL
bandwidth alloc/free paths asymmetric: rollback can call dl_bw_free()
even when no dl_bw_alloc() was done.

Rollback also needs to undo the reservation against the same CPU/root
domain that was charged. Record the CPU used by dl_bw_alloc() and use
that state in cpuset_cancel_attach(). If no allocation happened,
dl_bw_cpu stays at -1 and rollback skips dl_bw_free(). If allocation
did happen, bandwidth is returned to the same CPU/root domain.

Successful attach paths are unchanged. This only fixes failed attach
rollback accounting.

Fixes: 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case can_attach() fails")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset-internal.h |  5 +++++
 kernel/cgroup/cpuset.c          | 13 +++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index fd7d19842ded7..bb4e692bea300 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -168,6 +168,11 @@ struct cpuset {
 	int nr_deadline_tasks;
 	int nr_migrate_dl_tasks;
 	u64 sum_migrate_dl_bw;
+	/*
+	 * CPU used for temporary DL bandwidth allocation during attach;
+	 * -1 if no DL bandwidth was allocated in the current attach.
+	 */
+	int dl_bw_cpu;
 
 	/* Invalid partition error code, not lock protected */
 	enum prs_errcode prs_err;
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1335e437098e8..e3a081a07c6d5 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -288,6 +288,7 @@ struct cpuset top_cpuset = {
 	.flags = BIT(CS_CPU_EXCLUSIVE) |
 		 BIT(CS_MEM_EXCLUSIVE) | BIT(CS_SCHED_LOAD_BALANCE),
 	.partition_root_state = PRS_ROOT,
+	.dl_bw_cpu = -1,
 };
 
 /**
@@ -579,6 +580,8 @@ static struct cpuset *dup_or_alloc_cpuset(struct cpuset *cs)
 	if (!trial)
 		return NULL;
 
+	trial->dl_bw_cpu = -1;
+
 	/* Setup cpumask pointer array */
 	cpumask_var_t *pmask[4] = {
 		&trial->cpus_allowed,
@@ -2980,6 +2983,7 @@ static void reset_migrate_dl_data(struct cpuset *cs)
 {
 	cs->nr_migrate_dl_tasks = 0;
 	cs->sum_migrate_dl_bw = 0;
+	cs->dl_bw_cpu = -1;
 }
 
 /* Called by cgroups to determine if a cpuset is usable; cpuset_mutex held */
@@ -3056,6 +3060,8 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 			reset_migrate_dl_data(cs);
 			goto out_unlock;
 		}
+
+		cs->dl_bw_cpu = cpu;
 	}
 
 out_success:
@@ -3080,12 +3086,11 @@ static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 	mutex_lock(&cpuset_mutex);
 	dec_attach_in_progress_locked(cs);
 
-	if (cs->nr_migrate_dl_tasks) {
-		int cpu = cpumask_any(cs->effective_cpus);
+	if (cs->dl_bw_cpu >= 0)
+		dl_bw_free(cs->dl_bw_cpu, cs->sum_migrate_dl_bw);
 
-		dl_bw_free(cpu, cs->sum_migrate_dl_bw);
+	if (cs->nr_migrate_dl_tasks)
 		reset_migrate_dl_data(cs);
-	}
 
 	mutex_unlock(&cpuset_mutex);
 }
-- 
2.53.0



