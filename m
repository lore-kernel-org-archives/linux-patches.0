Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931CA1EB5FD;
	Sat, 12 Sep 2026 07:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197614; cv=none; b=WcbFaEZiwEDYkso0uhcq9tcYrh/kLs9viJ5ySMOrgp5QyO5fCjW353qnhCcPfbNTHA8KEveA2mGUlmhg22j6bZW5T4m+LUgGiQH3RkjnqpaScVB6+NpMmNLyS4IuyFNnh+SB0ZYNhMTeszDTmlofeX39GUv/fQJNFSzUUudBDAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197614; c=relaxed/simple;
	bh=jQsm0hT25+KzS8Vb9LeKU3/xsos4flXSPCG+8/RvGRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baAs6LMMd5TrZOKmsvgzXZf6gNXYhP5MmAIvVmuGAbHXQbuRVT/8O18mbOrqrDsJhlfIcX230fNK2BqfMafOyOzSmCyZ/jooU2rXrbfjkz3iLg4gDoieiWZnSs5zg8+daSy8tErzV30a60KSJINYGn2K1KUUqkfY8I04F9NuQi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUI17lF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUI17lF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F4E1F000FF;
	Sat, 12 Sep 2026 07:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197613;
	bh=lrDvmuF7azis56tE1I/K64d0MtsEaOz+YYx55JQcJfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUI17lF3eR042bzxZHRVJE/sf2wDVtOtGjhii3pT7pcyA6p5kjIZluC6w+1icNQU/
	 0vA3ERXA5OGkWVfVQWSk2U/RNDZU9z3BnAM2Pe8KFeBY7uKw2SMmd9EYISRMaOOYqL
	 Kf2SrEute/w1dwVcLe/u1mSjR5vt0gw6+9I8whVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridong Chen <ridong.chen@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0210/1815] cgroup/cpuset: Make nr_deadline_tasks an atomic_t
Date: Sat, 12 Sep 2026 08:32:40 +0200
Message-ID: <20260912065653.925997231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f7aaf01f7cd5e..140700e5e236d 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -165,7 +165,7 @@ struct cpuset {
 	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
 	 * know when to rebuild associated root domain bandwidth information.
 	 */
-	int nr_deadline_tasks;
+	atomic_t nr_deadline_tasks;
 	int nr_migrate_dl_tasks;
 	/* DL bandwidth that needs destination reservation for this attach. */
 	u64 sum_migrate_dl_bw;
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index cce1f0e292ade..411533d1b46c8 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -222,14 +222,14 @@ void inc_dl_tasks_cs(struct task_struct *p)
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
@@ -918,7 +918,7 @@ static void dl_update_tasks_root_domain(struct cpuset *cs)
 	struct css_task_iter it;
 	struct task_struct *task;
 
-	if (cs->nr_deadline_tasks == 0)
+	if (atomic_read(&cs->nr_deadline_tasks) == 0)
 		return;
 
 	css_task_iter_start(&cs->css, 0, &it);
@@ -3216,8 +3216,8 @@ static void cpuset_attach(struct cgroup_taskset *tset)
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



