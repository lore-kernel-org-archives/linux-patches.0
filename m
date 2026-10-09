Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312124E3ED9;
	Fri,  9 Oct 2026 14:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555309; cv=none; b=lNcCnOcM0Tyws/dgwVDtHm0sYGK7XMtxZNA+7S96BWIP4KGQsce96vs635RrH15NL2f/ecIOGzlJuXY0+J8sGnAIs7tkPbLBsJkXOz6rv0oSz2M2H5sHfTTPDP7y43pwvFKlEsQdubeG5poTZvRzXykZfqgL7oG3zYdOfLrRw/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555309; c=relaxed/simple;
	bh=PYUGO/lmju5fj0efEDInsmsC6FrXEZAoxwA9melhzG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyNAryitiIXzv5YDlbVo4naf8KVJIOh1ovC4nuJa0LJH9EqacIZXH9m2oDgIo2w6IAmjAO0c9DG7JuaCogkzyuDWwOyvoXvf7tIOA8Wk8cTZId8xm1hDwRLPDeukz6X0oSiazLpzZ10+EqLZE7hqCLwjJQXrreTeRH4jZEMpXMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIKh8qF1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIKh8qF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCB31F00899;
	Fri,  9 Oct 2026 14:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555302;
	bh=FBNLd9E7jD7aHTwRhCAaEvKIrNogMoif1HgOz5wyiso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gIKh8qF1Zd0OPSnskFqSKzyr40xSVIR8zYPXX9Dane3bjnTo5CrjvDKoIH0UWq6R9
	 2QHAgfOrI3YOZ5tC9JqyjxZ7avUU5wNGxn/3/kgEzUr8t9zAc8AATDgf1lZRNoRhfG
	 oDNaUg1dWexOlma6ORnkJttZUlJmSWa4ATPkb3O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>,
	Lu Wang <wanglu.priv@gmail.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 7.2 007/428] sched/cache: Honor migrate_llc_task semantics in active load balance, to fix LLC mis-scheduling bug
Date: Fri,  9 Oct 2026 16:05:44 +0200
Message-ID: <20261009140946.191363856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Lu Wang <wanglu.priv@gmail.com>

[ Upstream commit d6013e2465d98d524b030a81c1223882a1bb7e4c ]

Cache aware scheduling introduced the migrate_llc_task migration type to direct
tasks toward their preferred LLC, but its semantics can be lost when passive
load balance falls back to active load balance (ALB). This may allow ALB to
select a candidate whose preferred LLC does not match the destination, moving
it away from its preferred LLC.

Example scenario:

src_rq has two runnable tasks, p1 and p2. p1 prefers dst_rq (dst_llc), while p2
prefers src_rq (src_llc). In this case, migrate_llc_task is set because src_rq
has at least one task, p1, that wants to migrate to dst_rq. In ALB,
can_migrate_task() finds p2 and returns true for it, thus moving p2 out of its
preferred LLC.

Solution:

The CPU stopper in ALB constructs a fresh lb_env that does not inherit
migration_type from the passive load-balance pass. Two approaches are
possible:

(a) Add a new member to struct rq so ALB can inherit migrate_llc_task
    from the passive LB that triggered it.

(b) Define a new flag LBF_ACTIVE_LB_LLC and select the stopper callback
    at kick time to preserve the migration semantics across the
    asynchronous boundary.

We choose (b) because it avoids passing migration_type through the
stopper, which would affect the meaning of migration_type for
delayed-dequeue tasks.

Fixes: e4c9a4cb244a ("sched/cache: Add migrate_llc_task migration type for cache-aware balancing")
Suggested-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Lu Wang <wanglu.priv@gmail.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Cc: <stable@kernel.org> # v7.2.x
Link: https://patch.msgid.link/cb39f64a17fc2b76097264aaec74a2d6dfff4315.1790035273.git.tim.c.chen@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 57 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 855ff50349f15..9e813d34abf12 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10395,6 +10395,7 @@ enum migration_type {
 #define LBF_SOME_PINNED	0x08
 #define LBF_ACTIVE_LB	0x10
 #define LBF_LLC_PINNED	0x20
+#define LBF_ACTIVE_LB_LLC	0x40
 
 struct lb_env {
 	struct sched_domain	*sd;
@@ -10823,6 +10824,21 @@ alb_break_llc(struct lb_env *env)
 	return false;
 }
 
+/*
+ * Returns true if p's preferred LLC does not match the destination CPU
+ * under migrate_llc_task semantics. Passive LB passes migrate_llc_task
+ * in env->migration_type, while active LB carries LBF_ACTIVE_LB_LLC in
+ * env->flags to avoid overwriting env->migration_type.
+ */
+static inline bool
+migrate_llc_task_wrong_dst(struct task_struct *p, struct lb_env *env)
+{
+	return sched_cache_enabled() &&
+	       (env->migration_type == migrate_llc_task ||
+		env->flags & LBF_ACTIVE_LB_LLC) &&
+	       READ_ONCE(p->preferred_llc) != llc_id(env->dst_cpu);
+}
+
 /*
  * Check if migrating task p from env->src_cpu to
  * env->dst_cpu breaks LLC localiy.
@@ -10851,8 +10867,7 @@ static bool migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
 	 * run on env->dst_cpu, skip the tasks do not prefer
 	 * env->dst_cpu, and find the one that prefers.
 	 */
-	if (env->migration_type == migrate_llc_task &&
-	    READ_ONCE(p->preferred_llc) != llc_id(env->dst_cpu))
+	if (migrate_llc_task_wrong_dst(p, env))
 		return true;
 
 	if (can_migrate_llc_task(env, p) != mig_forbid)
@@ -10874,6 +10889,12 @@ alb_break_llc(struct lb_env *env)
 	return false;
 }
 
+static inline bool
+migrate_llc_task_wrong_dst(struct task_struct *p, struct lb_env *env)
+{
+	return false;
+}
+
 static inline bool
 migrate_degrades_llc(struct task_struct *p, struct lb_env *env)
 {
@@ -10973,7 +10994,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 4) too many balance attempts have failed.
 	 */
 	if (env->flags & LBF_ACTIVE_LB)
-		return 1;
+		return !migrate_llc_task_wrong_dst(p, env);
 
 	degrades = migrate_degrades_locality(p, env);
 	if (!degrades) {
@@ -13344,6 +13365,20 @@ static int need_active_balance(struct lb_env *env)
 }
 
 static int active_load_balance_cpu_stop(void *data);
+static int active_load_balance_llc_cpu_stop(void *data);
+
+/*
+ * migration_type is checked elsewhere to decide migration policy, so
+ * it shouldn't be repurposed just to flag an LLC-directed active
+ * balance across the stopper. Pick the callback here instead.
+ */
+static inline cpu_stop_fn_t alb_stop_fn(struct lb_env *env)
+{
+	if (env->migration_type == migrate_llc_task)
+		return active_load_balance_llc_cpu_stop;
+
+	return active_load_balance_cpu_stop;
+}
 
 static int should_we_balance(struct lb_env *env)
 {
@@ -13680,7 +13715,7 @@ static int sched_balance_rq(int this_cpu, struct rq *this_rq,
 			raw_spin_rq_unlock_irqrestore(busiest, flags);
 			if (active_balance) {
 				stop_one_cpu_nowait(cpu_of(busiest),
-					active_load_balance_cpu_stop, busiest,
+					alb_stop_fn(&env), busiest,
 					&busiest->active_balance_work);
 			}
 			preempt_enable();
@@ -13791,7 +13826,7 @@ update_next_balance(struct sched_domain *sd, unsigned long *next_balance)
  * least 1 task to be running on each physical CPU where possible, and
  * avoids physical / logical imbalances.
  */
-static int active_load_balance_cpu_stop(void *data)
+static int __active_load_balance_cpu_stop(void *data, unsigned int lb_flags)
 {
 	struct rq *busiest_rq = data;
 	int busiest_cpu = cpu_of(busiest_rq);
@@ -13841,7 +13876,7 @@ static int active_load_balance_cpu_stop(void *data)
 			.src_cpu	= busiest_rq->cpu,
 			.src_rq		= busiest_rq,
 			.idle		= CPU_IDLE,
-			.flags		= LBF_ACTIVE_LB,
+			.flags		= LBF_ACTIVE_LB | lb_flags,
 		};
 
 		schedstat_inc(sd->alb_count);
@@ -13869,6 +13904,16 @@ static int active_load_balance_cpu_stop(void *data)
 	return 0;
 }
 
+static int active_load_balance_cpu_stop(void *data)
+{
+	return __active_load_balance_cpu_stop(data, 0);
+}
+
+static int active_load_balance_llc_cpu_stop(void *data)
+{
+	return __active_load_balance_cpu_stop(data, LBF_ACTIVE_LB_LLC);
+}
+
 /*
  * Scale the max sched_balance_rq interval with the number of CPUs in the system.
  * This trades load-balance latency on larger machines for less cross talk.
-- 
2.53.0



