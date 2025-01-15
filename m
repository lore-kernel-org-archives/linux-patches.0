Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EF3248BAF;
	Wed, 15 Jan 2025 11:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938870; cv=none; b=ggSbfo/e/KxqwZTC95cK7xz6sulbcV20ITJDqR2lajKxVXj5LifoiVoSDBp4GuuJXwnouUjF/TV1Q4eR18MIs5Ge/Z5xcJ7rbnkldadjI7+VWubeFITh3ca8ZH9S9mlK8KlgBmi0vhmpmtKb9cbZ0XPwj0l5fHKz8nz/I+7Dxm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938870; c=relaxed/simple;
	bh=ngm8zg57/eHDh9HabxZDuqvpgKqOmoUi/PwA0glv01s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjeVMXW7R0+ViOuW51jpWiSvlWIPQwDfj/wUnht5gbajSDYunO25jAk4ZSuhqXxh6QSi7Yg3VLDWZb5wXpykmlBJs3Zns/SNZktOouuqkx8CtjtZSZyI2gfvJNJJmT9pjm7nyAgia93RlyMfATP5lcZG16udSVPao28A4wbQbKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxlyKMfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxlyKMfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D6CC4CEDF;
	Wed, 15 Jan 2025 11:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938869;
	bh=ngm8zg57/eHDh9HabxZDuqvpgKqOmoUi/PwA0glv01s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxlyKMfsoVSFUzO6+uCl8msGKxPzeGMZxcQfYiDyZZJ+4nUy8yBckDJeEGOwGQEkU
	 00eIe9eTkFV1ChLIMTBo7rTDhw0WNLw7uMtQSjD9X50VA2CpzywoIp29pVFfq2R7N2
	 9xL4musTWnyYiqemZarLH/ggg//lwKM2UhJtsL2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Allen Pais <allen.lkml@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/129] workqueue: Update lock debugging code
Date: Wed, 15 Jan 2025 11:38:17 +0100
Message-ID: <20250115103559.218461611@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit c35aea39d1e106f61fd2130f0d32a3bac8bd4570 ]

These changes are in preparation of BH workqueue which will execute work
items from BH context.

- Update lock and RCU depth checks in process_one_work() so that it
  remembers and checks against the starting depths and prints out the depth
  changes.

- Factor out lockdep annotations in the flush paths into
  touch_{wq|work}_lockdep_map(). The work->lockdep_map touching is moved
  from __flush_work() to its callee - start_flush_work(). This brings it
  closer to the wq counterpart and will allow testing the associated wq's
  flags which will be needed to support BH workqueues. This is not expected
  to cause any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: Allen Pais <allen.lkml@gmail.com>
Stable-dep-of: de35994ecd2d ("workqueue: Do not warn when cancelling WQ_MEM_RECLAIM work from !WQ_MEM_RECLAIM worker")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 51 ++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2d85f232c675..da5750246a92 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2541,6 +2541,7 @@ __acquires(&pool->lock)
 	struct pool_workqueue *pwq = get_work_pwq(work);
 	struct worker_pool *pool = worker->pool;
 	unsigned long work_data;
+	int lockdep_start_depth, rcu_start_depth;
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * It is permissible to free the struct work_struct from
@@ -2603,6 +2604,8 @@ __acquires(&pool->lock)
 	pwq->stats[PWQ_STAT_STARTED]++;
 	raw_spin_unlock_irq(&pool->lock);
 
+	rcu_start_depth = rcu_preempt_depth();
+	lockdep_start_depth = lockdep_depth(current);
 	lock_map_acquire(&pwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
 	/*
@@ -2638,12 +2641,15 @@ __acquires(&pool->lock)
 	lock_map_release(&lockdep_map);
 	lock_map_release(&pwq->wq->lockdep_map);
 
-	if (unlikely(in_atomic() || lockdep_depth(current) > 0 ||
-		     rcu_preempt_depth() > 0)) {
-		pr_err("BUG: workqueue leaked lock or atomic: %s/0x%08x/%d/%d\n"
-		       "     last function: %ps\n",
-		       current->comm, preempt_count(), rcu_preempt_depth(),
-		       task_pid_nr(current), worker->current_func);
+	if (unlikely((worker->task && in_atomic()) ||
+		     lockdep_depth(current) != lockdep_start_depth ||
+		     rcu_preempt_depth() != rcu_start_depth)) {
+		pr_err("BUG: workqueue leaked atomic, lock or RCU: %s[%d]\n"
+		       "     preempt=0x%08x lock=%d->%d RCU=%d->%d workfn=%ps\n",
+		       current->comm, task_pid_nr(current), preempt_count(),
+		       lockdep_start_depth, lockdep_depth(current),
+		       rcu_start_depth, rcu_preempt_depth(),
+		       worker->current_func);
 		debug_show_held_locks(current);
 		dump_stack();
 	}
@@ -3123,6 +3129,19 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
 	return wait;
 }
 
+static void touch_wq_lockdep_map(struct workqueue_struct *wq)
+{
+	lock_map_acquire(&wq->lockdep_map);
+	lock_map_release(&wq->lockdep_map);
+}
+
+static void touch_work_lockdep_map(struct work_struct *work,
+				   struct workqueue_struct *wq)
+{
+	lock_map_acquire(&work->lockdep_map);
+	lock_map_release(&work->lockdep_map);
+}
+
 /**
  * __flush_workqueue - ensure that any scheduled work has run to completion.
  * @wq: workqueue to flush
@@ -3142,8 +3161,7 @@ void __flush_workqueue(struct workqueue_struct *wq)
 	if (WARN_ON(!wq_online))
 		return;
 
-	lock_map_acquire(&wq->lockdep_map);
-	lock_map_release(&wq->lockdep_map);
+	touch_wq_lockdep_map(wq);
 
 	mutex_lock(&wq->mutex);
 
@@ -3342,6 +3360,7 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 	struct worker *worker = NULL;
 	struct worker_pool *pool;
 	struct pool_workqueue *pwq;
+	struct workqueue_struct *wq;
 
 	might_sleep();
 
@@ -3365,11 +3384,14 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 		pwq = worker->current_pwq;
 	}
 
-	check_flush_dependency(pwq->wq, work);
+	wq = pwq->wq;
+	check_flush_dependency(wq, work);
 
 	insert_wq_barrier(pwq, barr, work, worker);
 	raw_spin_unlock_irq(&pool->lock);
 
+	touch_work_lockdep_map(work, wq);
+
 	/*
 	 * Force a lock recursion deadlock when using flush_work() inside a
 	 * single-threaded or rescuer equipped workqueue.
@@ -3379,11 +3401,9 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 	 * workqueues the deadlock happens when the rescuer stalls, blocking
 	 * forward progress.
 	 */
-	if (!from_cancel &&
-	    (pwq->wq->saved_max_active == 1 || pwq->wq->rescuer)) {
-		lock_map_acquire(&pwq->wq->lockdep_map);
-		lock_map_release(&pwq->wq->lockdep_map);
-	}
+	if (!from_cancel && (wq->saved_max_active == 1 || wq->rescuer))
+		touch_wq_lockdep_map(wq);
+
 	rcu_read_unlock();
 	return true;
 already_gone:
@@ -3402,9 +3422,6 @@ static bool __flush_work(struct work_struct *work, bool from_cancel)
 	if (WARN_ON(!work->func))
 		return false;
 
-	lock_map_acquire(&work->lockdep_map);
-	lock_map_release(&work->lockdep_map);
-
 	if (start_flush_work(work, &barr, from_cancel)) {
 		wait_for_completion(&barr.done);
 		destroy_work_on_stack(&barr.work);
-- 
2.39.5



