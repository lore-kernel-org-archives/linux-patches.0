Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2299379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302034; cv=none; b=dTEkf2LTWVpYODMmxg33M9SiaxlI3uJ3Nz0tiJjBkPDibKwTy7xr63vBylrGD1ggubURgzIl9bAIXOP3gBeXk7L6ONohulch24J75hCQqpZ0V+ujqXSfOBC6fMRbTZMd49iwLDwmv5j0Zu23ka3tRW24F4yyLYMAd8AaCytp66I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302034; c=relaxed/simple;
	bh=Xfe6eVxixM6dBDrLZQesj08wz9+vQPLrs3pyeegbo8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ux/seZl9CxE8hE9z2pG+WIQS6rv6tDIDPra+B8CAgQqQNuz0+LP4M4gGPpvQuX+sRlRZ+TMOm0R1Rip/BzheBvXo5NkPXTyWgWpyWz6IHYgR/8W18Yy8jIRaeYPkSQp5XSIzRPUWl3qdDPV6NfGxE8loCOQkIljPf6UlVY6975c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UKtWe3Zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UKtWe3Zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE724C19424;
	Sat, 28 Feb 2026 18:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302034;
	bh=Xfe6eVxixM6dBDrLZQesj08wz9+vQPLrs3pyeegbo8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKtWe3ZfjtL8+bt9r7q9QBMVhbvGiKLiPduOpJGL8oDQY+W0DfNGF2nsTt8rUG6ZP
	 5zxR/SWm/rURztt3QlOE6QuZoul0nGNfrwt3bJ5TYahqJV6flxMbti/r635RTc666S
	 coRebfT62ltlz19X7hoAag/LfDIRcp3j+QKYb2/Js57sTU+seob6o23sfbMulacqJr
	 wJ/BY+tgfLoDXSOcfOwuc/w8Sd1mqCB64LUnTT771wYXNZ6ndeL5VcvOFRkaM1UDFQ
	 HyhrfCmY28HpUtFTy4pcxvfNy4Yp1LxAwe99Zcvzg9SbFvhPu4isBeukZIuxV69KTZ
	 lF1yvu0gb4WPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/283] rcu: s/boost_kthread_mutex/kthread_mutex
Date: Sat, 28 Feb 2026 13:02:27 -0500
Message-ID: <20260228180709.1583486-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 7836b270607676ed1c0c6a4a840a2ede9437a6a1 ]

This mutex is currently protecting per node boost kthreads creation and
affinity setting across CPU hotplug operations.

Since the expedited kworkers will soon be split per node as well, they
will be subject to the same concurrency constraints against hotplug.

Therefore their creation and affinity tuning operations will be grouped
with those of boost kthreads and then rely on the same mutex.

To prepare for that, generalize its name.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Stable-dep-of: d41e37f26b31 ("rcu: Fix rcu_read_unlock() deadloop due to softirq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c        |  2 +-
 kernel/rcu/tree.h        |  2 +-
 kernel/rcu/tree_plugin.h | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 607b2e68fa4c2..43133dff2a04b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4874,7 +4874,7 @@ static void __init rcu_init_one(void)
 			init_waitqueue_head(&rnp->exp_wq[2]);
 			init_waitqueue_head(&rnp->exp_wq[3]);
 			spin_lock_init(&rnp->exp_lock);
-			mutex_init(&rnp->boost_kthread_mutex);
+			mutex_init(&rnp->kthread_mutex);
 			raw_spin_lock_init(&rnp->exp_poll_lock);
 			rnp->exp_seq_poll_rq = RCU_GET_STATE_COMPLETED;
 			INIT_WORK(&rnp->exp_poll_wq, sync_rcu_do_polled_gp);
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 71403d22a8465..f8408e7a5f824 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -113,7 +113,7 @@ struct rcu_node {
 				/*  side effect, not as a lock. */
 	unsigned long boost_time;
 				/* When to start boosting (jiffies). */
-	struct mutex boost_kthread_mutex;
+	struct mutex kthread_mutex;
 				/* Exclusion for thread spawning and affinity */
 				/*  manipulation. */
 	struct task_struct *boost_kthread_task;
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 8707f155afb6d..f178a8bb83650 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1229,7 +1229,7 @@ static void rcu_spawn_one_boost_kthread(struct rcu_node *rnp)
 	struct sched_param sp;
 	struct task_struct *t;
 
-	mutex_lock(&rnp->boost_kthread_mutex);
+	mutex_lock(&rnp->kthread_mutex);
 	if (rnp->boost_kthread_task || !rcu_scheduler_fully_active)
 		goto out;
 
@@ -1246,7 +1246,7 @@ static void rcu_spawn_one_boost_kthread(struct rcu_node *rnp)
 	wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
 
  out:
-	mutex_unlock(&rnp->boost_kthread_mutex);
+	mutex_unlock(&rnp->kthread_mutex);
 }
 
 /*
@@ -1258,7 +1258,7 @@ static void rcu_spawn_one_boost_kthread(struct rcu_node *rnp)
  * no outgoing CPU.  If there are no CPUs left in the affinity set,
  * this function allows the kthread to execute on any CPU.
  *
- * Any future concurrent calls are serialized via ->boost_kthread_mutex.
+ * Any future concurrent calls are serialized via ->kthread_mutex.
  */
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 {
@@ -1271,7 +1271,7 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 		return;
 	if (!zalloc_cpumask_var(&cm, GFP_KERNEL))
 		return;
-	mutex_lock(&rnp->boost_kthread_mutex);
+	mutex_lock(&rnp->kthread_mutex);
 	mask = rcu_rnp_online_cpus(rnp);
 	for_each_leaf_node_possible_cpu(rnp, cpu)
 		if ((mask & leaf_node_cpu_bit(rnp, cpu)) &&
@@ -1284,7 +1284,7 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 			cpumask_clear_cpu(outgoingcpu, cm);
 	}
 	set_cpus_allowed_ptr(t, cm);
-	mutex_unlock(&rnp->boost_kthread_mutex);
+	mutex_unlock(&rnp->kthread_mutex);
 	free_cpumask_var(cm);
 }
 
-- 
2.51.0

