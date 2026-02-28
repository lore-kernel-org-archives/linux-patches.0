Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E2E33507A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302035; cv=none; b=oGNcQVXIPppuSJQ28CLkArHh3mytv/eyAN4t52YzAClyqWGvFhvGC2jfC/xvmKhs2ANF8FoQdeyrKOd5Kal2vSq0Q6GAfoexFcoJD8idohZRps39nkkTpNpSvhNlDyF7EQgRGZD/WsBm+POHVrVCj+TZp11/xl9Eoo8mSjoojkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302035; c=relaxed/simple;
	bh=tbEvjvc6IykNwl127Iy2EXnMGUBAeBFTH6ToCBmGQkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l82FRJTLa63hleib6sAXeVi0wscjyPaLQtsuXGlBaG5jh2wJ0ALUfHmDflBtdZO3WszSC3DdygKD4SXp+s0xz3DgPOEKMdCvFdbSOV0ctxi0pAAvVRqt4ay7q0EPiMM5BElfVWeC6JtH3qbg3Ri1rXDm8hhviamUBVVUCMdDJ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WPxkvHBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WPxkvHBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2EFC116D0;
	Sat, 28 Feb 2026 18:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302035;
	bh=tbEvjvc6IykNwl127Iy2EXnMGUBAeBFTH6ToCBmGQkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPxkvHBXI/rNSr6eoVikzemEG0bHL4wIw7gvgmkYLKX3WUNsaiZPlM/5GwaMM6QVT
	 hne4c72c++70dQxa1RM2lGya7MQG+qVZHN1vw+T3vZusXY3ZIVTI4P1v6j0y+GfvCl
	 iZo7pkOJd88d3TPhakP9N020qzIfc5WbjDBjSdfXG8qU3pughXOcSwf2Nk1pPekPcc
	 79NAzXHiFEHPvHQ3yioLuYMtaeteZxF8dH5l0BmiouV5fK99XKARzq/JFQq2PhlsBC
	 ctkWyKyqfIkRRnuo4bOM/BGVr9ZU3unkNaePJRVGUZdH5gSKPvuhv/d5xsZwb4N9BV
	 mTSjEtimZaCPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/283] rcu/exp: Move expedited kthread worker creation functions above rcutree_prepare_cpu()
Date: Sat, 28 Feb 2026 13:02:28 -0500
Message-ID: <20260228180709.1583486-6-sashal@kernel.org>
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

[ Upstream commit c19e5d3b497a3036f800edf751dc7814e3e887e1 ]

The expedited kthread worker performing the per node initialization is
going to be split into per node kthreads. As such, the future per node
kthread creation will need to be called from CPU hotplug callbacks
instead of an initcall, right beside the per node boost kthread
creation.

To prepare for that, move the kthread worker creation above
rcutree_prepare_cpu() as a first step to make the review smoother for
the upcoming modifications.

No intended functional change.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Stable-dep-of: d41e37f26b31 ("rcu: Fix rcu_read_unlock() deadloop due to softirq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 96 +++++++++++++++++++++++------------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 43133dff2a04b..81f0a730c54b2 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4379,6 +4379,54 @@ rcu_boot_init_percpu_data(int cpu)
 	rcu_boot_init_nocb_percpu_data(rdp);
 }
 
+#ifdef CONFIG_RCU_EXP_KTHREAD
+struct kthread_worker *rcu_exp_gp_kworker;
+struct kthread_worker *rcu_exp_par_gp_kworker;
+
+static void __init rcu_start_exp_gp_kworkers(void)
+{
+	const char *par_gp_kworker_name = "rcu_exp_par_gp_kthread_worker";
+	const char *gp_kworker_name = "rcu_exp_gp_kthread_worker";
+	struct sched_param param = { .sched_priority = kthread_prio };
+
+	rcu_exp_gp_kworker = kthread_create_worker(0, gp_kworker_name);
+	if (IS_ERR_OR_NULL(rcu_exp_gp_kworker)) {
+		pr_err("Failed to create %s!\n", gp_kworker_name);
+		rcu_exp_gp_kworker = NULL;
+		return;
+	}
+
+	rcu_exp_par_gp_kworker = kthread_create_worker(0, par_gp_kworker_name);
+	if (IS_ERR_OR_NULL(rcu_exp_par_gp_kworker)) {
+		pr_err("Failed to create %s!\n", par_gp_kworker_name);
+		rcu_exp_par_gp_kworker = NULL;
+		kthread_destroy_worker(rcu_exp_gp_kworker);
+		rcu_exp_gp_kworker = NULL;
+		return;
+	}
+
+	sched_setscheduler_nocheck(rcu_exp_gp_kworker->task, SCHED_FIFO, &param);
+	sched_setscheduler_nocheck(rcu_exp_par_gp_kworker->task, SCHED_FIFO,
+				   &param);
+}
+
+static inline void rcu_alloc_par_gp_wq(void)
+{
+}
+#else /* !CONFIG_RCU_EXP_KTHREAD */
+struct workqueue_struct *rcu_par_gp_wq;
+
+static void __init rcu_start_exp_gp_kworkers(void)
+{
+}
+
+static inline void rcu_alloc_par_gp_wq(void)
+{
+	rcu_par_gp_wq = alloc_workqueue("rcu_par_gp", WQ_MEM_RECLAIM, 0);
+	WARN_ON(!rcu_par_gp_wq);
+}
+#endif /* CONFIG_RCU_EXP_KTHREAD */
+
 /*
  * Invoked early in the CPU-online process, when pretty much all services
  * are available.  The incoming CPU is not present.
@@ -4686,54 +4734,6 @@ static int rcu_pm_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-#ifdef CONFIG_RCU_EXP_KTHREAD
-struct kthread_worker *rcu_exp_gp_kworker;
-struct kthread_worker *rcu_exp_par_gp_kworker;
-
-static void __init rcu_start_exp_gp_kworkers(void)
-{
-	const char *par_gp_kworker_name = "rcu_exp_par_gp_kthread_worker";
-	const char *gp_kworker_name = "rcu_exp_gp_kthread_worker";
-	struct sched_param param = { .sched_priority = kthread_prio };
-
-	rcu_exp_gp_kworker = kthread_create_worker(0, gp_kworker_name);
-	if (IS_ERR_OR_NULL(rcu_exp_gp_kworker)) {
-		pr_err("Failed to create %s!\n", gp_kworker_name);
-		rcu_exp_gp_kworker = NULL;
-		return;
-	}
-
-	rcu_exp_par_gp_kworker = kthread_create_worker(0, par_gp_kworker_name);
-	if (IS_ERR_OR_NULL(rcu_exp_par_gp_kworker)) {
-		pr_err("Failed to create %s!\n", par_gp_kworker_name);
-		rcu_exp_par_gp_kworker = NULL;
-		kthread_destroy_worker(rcu_exp_gp_kworker);
-		rcu_exp_gp_kworker = NULL;
-		return;
-	}
-
-	sched_setscheduler_nocheck(rcu_exp_gp_kworker->task, SCHED_FIFO, &param);
-	sched_setscheduler_nocheck(rcu_exp_par_gp_kworker->task, SCHED_FIFO,
-				   &param);
-}
-
-static inline void rcu_alloc_par_gp_wq(void)
-{
-}
-#else /* !CONFIG_RCU_EXP_KTHREAD */
-struct workqueue_struct *rcu_par_gp_wq;
-
-static void __init rcu_start_exp_gp_kworkers(void)
-{
-}
-
-static inline void rcu_alloc_par_gp_wq(void)
-{
-	rcu_par_gp_wq = alloc_workqueue("rcu_par_gp", WQ_MEM_RECLAIM, 0);
-	WARN_ON(!rcu_par_gp_wq);
-}
-#endif /* CONFIG_RCU_EXP_KTHREAD */
-
 /*
  * Spawn the kthreads that handle RCU's grace periods.
  */
-- 
2.51.0

