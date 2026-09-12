Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434051D514E;
	Sat, 12 Sep 2026 09:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206490; cv=none; b=QCQ5QYXWCArKHpew2QXCNLMnso4vqGwHdfN7yKiqW4+Ej1Zkm98CC0TqKx0Y2QJbrGnwjt4dNVjYsWVqX4RSkgjfJ+/0H/NQC7bAGd6r1Hgcxz4MjiSoKmyCI8ymKabAWXrQsmMmMbc8iqCAGW87Mryb7U/IRZHsYdqmq320R/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206490; c=relaxed/simple;
	bh=+VvktH7qiQYzf2Z8N00BjFOieypIFMsFHZt4X0fv73Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lahX9PkSL3+nMsnKVe0p7uuYOU1Zt+TaMmLYLIjQXzGMx933yCTxsGFakRHL17WAvawUziLxxPvXcjd4zB92rwrSCmzvHih6W7SUuQNQ9W6NMjh8eE9yBwlkeNZm3pWxIi0pSEweXtkaTNdd072Go7//0PzGl1Jrq8mJq+gTNtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9WGgeX9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9WGgeX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1482E1F00893;
	Sat, 12 Sep 2026 09:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206489;
	bh=L1yITZcKD3ejIy+K9NzxJH8uD+hqQuh+P0/wL4AHiok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B9WGgeX9rEV0+JBS6fWKnEad5D43XGMGgExnZuQAlvQthWuAWqbxTgSXwM+q0oHcs
	 ba389ponWhrcrRtvudJS4w/ta5klLNg9BxTDWWxSMZQrNWVZsQLKYNHhK6wL9q7bLF
	 bVJG+jZUsPfJnvdxgg2EDDbjghq0IP7cRuO+rFtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridong Chen <ridong.chen@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0217/1518] cgroup/cpuset: Make nr_deadline_tasks an atomic_t
Date: Sat, 12 Sep 2026 08:39:46 +0200
Message-ID: <20260912065628.399372573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 95220e1f18f6321008f021abc7d6f581f64bcb82 ]

The nr_deadline_tasks variable in the cpuset structure was introduced by
commit 6c24849f5515 ("sched/cpuset: Keep track of SCHED_DEADLINE task
in cpusets"). It is reported by sashiko [1] that nr_deadline_tasks
can currently be modified by inc_dl_tasks_cs() under rq->lock and
by cpuset_attach() under cpuset_mutex. So if both updates happen
simultaneously, the nr_deadline_tasks variable can be corrupted leading
to incorrect operations down the road.

Fix that by changing its type to atomic_t so that nr_deadline_tasks
are always atomically updated. This fix patch is a low hanging fruit.
It can handle some of the races between a concurrent sched_setscheduler()
and cpuset_can_attach()/cpuset_attach() calls, but not all of them like
the other issue raised by sashiko [2]. This will be handled hopefully
in a future follow up patch.

[1] https://sashiko.dev/#/patchset/20260626181923.133658-1-longman%40redhat.com
[2] https://sashiko.dev/#/patchset/20260630033344.352702-1-longman%40redhat.com

Fixes: 6c24849f5515 ("sched/cpuset: Keep track of SCHED_DEADLINE task in cpusets")
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset-internal.h |  2 +-
 kernel/cgroup/cpuset.c          | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 337608f408ce0..0eb9ebd4fcb92 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -165,7 +165,7 @@ struct cpuset {
 	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
 	 * know when to rebuild associated root domain bandwidth information.
 	 */
-	int nr_deadline_tasks;
+	atomic_t nr_deadline_tasks;
 	int nr_migrate_dl_tasks;
 	u64 sum_migrate_dl_bw;
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2386090351cd3..23c90b1e219ac 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -145,14 +145,14 @@ void inc_dl_tasks_cs(struct task_struct *p)
 {
 	struct cpuset *cs = task_cs(p);
 
-	cs->nr_deadline_tasks++;
+	atomic_inc(&cs->nr_deadline_tasks);
 }
 
 void dec_dl_tasks_cs(struct task_struct *p)
 {
 	struct cpuset *cs = task_cs(p);
 
-	cs->nr_deadline_tasks--;
+	atomic_dec(&cs->nr_deadline_tasks);
 }
 
 static inline bool is_partition_valid(const struct cpuset *cs)
@@ -1033,7 +1033,7 @@ static void dl_update_tasks_root_domain(struct cpuset *cs)
 	struct css_task_iter it;
 	struct task_struct *task;
 
-	if (cs->nr_deadline_tasks == 0)
+	if (atomic_read(&cs->nr_deadline_tasks) == 0)
 		return;
 
 	css_task_iter_start(&cs->css, 0, &it);
@@ -3313,8 +3313,8 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	cs->old_mems_allowed = cpuset_attach_nodemask_to;
 
 	if (cs->nr_migrate_dl_tasks) {
-		cs->nr_deadline_tasks += cs->nr_migrate_dl_tasks;
-		oldcs->nr_deadline_tasks -= cs->nr_migrate_dl_tasks;
+		atomic_add(cs->nr_migrate_dl_tasks, &cs->nr_deadline_tasks);
+		atomic_sub(cs->nr_migrate_dl_tasks, &oldcs->nr_deadline_tasks);
 		reset_migrate_dl_data(cs);
 	}
 
-- 
2.53.0



