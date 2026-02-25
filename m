Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C02E2BAF7;
	Wed, 25 Feb 2026 01:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983038; cv=none; b=lO1Lm0Zcljrv0hqROMzJ9PtDnCBgPYZsH7kp42TXoeo/6ft3xtCEoNd6RZnykHDWoegc9+ZQCD7xCGmTsqPf1P4hJT+AtwDzo+ILdp4E+mpLiQooJMIk2NlfK8+Q8uGCzyTCBTmmKkWUyToT/STvpradheuctfR0ZsTDgV25iOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983038; c=relaxed/simple;
	bh=uMgBkNEq/Hy+sXVN+QOG+1FqW9p6qWje/0ZVFq4eWHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1F7t1An3Wiglks3iLqADCtmCT+L8uDDVEkdFepAVuKgokP3ABDFP6CWWWa/JpGtY4aNq1Nm9DN5Z+RGp9OZc+lsfDIZ+FzFG5No+Zt7tJ7cB2ZMDNWm0CP4afPcGmzoo4NvMChTb19fZ/tEQQ8vO5/YFupmF0bwCnGyeiDNPK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gETTwnqX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gETTwnqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35E6C19423;
	Wed, 25 Feb 2026 01:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983038;
	bh=uMgBkNEq/Hy+sXVN+QOG+1FqW9p6qWje/0ZVFq4eWHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gETTwnqXQGcxbEzOFERpzz+yFdI3hjXrs9ILPeOyrUnHBBZkqDXncKYsDIkHWmyXs
	 Bt6/SjF4XmfydECdpi5Koiog6R0GOooPsB+2C4ammtdGctlPK0Rx0MmmOXGrHYux9V
	 K6Q7JNXZBBkHZu65lx7OdTNtAL8CyUHH87kfnZMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ying chen <yc1082463@gmail.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 201/781] workqueue: Process rescuer work items one-by-one using a cursor
Date: Tue, 24 Feb 2026 17:15:10 -0800
Message-ID: <20260225012404.594350645@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

[ Upstream commit e5a30c303b07a4d6083e0f7f051b53add6d93c5d ]

Previously, the rescuer scanned for all matching work items at once and
processed them within a single rescuer thread, which could cause one
blocking work item to stall all others.

Make the rescuer process work items one-by-one instead of slurping all
matches in a single pass.

Break the rescuer loop after finding and processing the first matching
work item, then restart the search to pick up the next. This gives
normal worker threads a chance to process other items which gives them
the opportunity to be processed instead of waiting on the rescuer's
queue and prevents a blocking work item from stalling the rest once
memory pressure is relieved.

Introduce a dummy cursor work item to avoid potentially O(N^2)
rescans of the work list.  The marker records the resume position for
the next scan, eliminating redundant traversals.

Also introduce RESCUER_BATCH to control the maximum number of work items
the rescuer processes in each turn, and move on to other PWQs when the
limit is reached.

Cc: ying chen <yc1082463@gmail.com>
Reported-by: ying chen <yc1082463@gmail.com>
Fixes: e22bee782b3b ("workqueue: implement concurrency managed dynamic worker pool")
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 75 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 59 insertions(+), 16 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 253311af47c6d..2909c19540ed1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -117,6 +117,8 @@ enum wq_internal_consts {
 	MAYDAY_INTERVAL		= HZ / 10,	/* and then every 100ms */
 	CREATE_COOLDOWN		= HZ,		/* time to breath after fail */
 
+	RESCUER_BATCH		= 16,		/* process items per turn */
+
 	/*
 	 * Rescue workers are used only on emergencies and shared by
 	 * all cpus.  Give MIN_NICE.
@@ -286,6 +288,7 @@ struct pool_workqueue {
 	struct list_head	pending_node;	/* LN: node on wq_node_nr_active->pending_pwqs */
 	struct list_head	pwqs_node;	/* WR: node on wq->pwqs */
 	struct list_head	mayday_node;	/* MD: node on wq->maydays */
+	struct work_struct	mayday_cursor;	/* L: cursor on pool->worklist */
 
 	u64			stats[PWQ_NR_STATS];
 
@@ -1120,6 +1123,12 @@ static struct worker *find_worker_executing_work(struct worker_pool *pool,
 	return NULL;
 }
 
+static void mayday_cursor_func(struct work_struct *work)
+{
+	/* should not be processed, only for marking position */
+	BUG();
+}
+
 /**
  * move_linked_works - move linked works to a list
  * @work: start of series of works to be scheduled
@@ -1182,6 +1191,16 @@ static bool assign_work(struct work_struct *work, struct worker *worker,
 
 	lockdep_assert_held(&pool->lock);
 
+	/* The cursor work should not be processed */
+	if (unlikely(work->func == mayday_cursor_func)) {
+		/* only worker_thread() can possibly take this branch */
+		WARN_ON_ONCE(worker->rescue_wq);
+		if (nextp)
+			*nextp = list_next_entry(work, entry);
+		list_del_init(&work->entry);
+		return false;
+	}
+
 	/*
 	 * A single work shouldn't be executed concurrently by multiple workers.
 	 * __queue_work() ensures that @work doesn't jump to a different pool
@@ -3440,22 +3459,30 @@ static int worker_thread(void *__worker)
 static bool assign_rescuer_work(struct pool_workqueue *pwq, struct worker *rescuer)
 {
 	struct worker_pool *pool = pwq->pool;
+	struct work_struct *cursor = &pwq->mayday_cursor;
 	struct work_struct *work, *n;
 
 	/* need rescue? */
 	if (!pwq->nr_active || !need_to_create_worker(pool))
 		return false;
 
-	/*
-	 * Slurp in all works issued via this workqueue and
-	 * process'em.
-	 */
-	list_for_each_entry_safe(work, n, &pool->worklist, entry) {
-		if (get_work_pwq(work) == pwq && assign_work(work, rescuer, &n))
+	/* search from the start or cursor if available */
+	if (list_empty(&cursor->entry))
+		work = list_first_entry(&pool->worklist, struct work_struct, entry);
+	else
+		work = list_next_entry(cursor, entry);
+
+	/* find the next work item to rescue */
+	list_for_each_entry_safe_from(work, n, &pool->worklist, entry) {
+		if (get_work_pwq(work) == pwq && assign_work(work, rescuer, &n)) {
 			pwq->stats[PWQ_STAT_RESCUED]++;
+			/* put the cursor for next search */
+			list_move_tail(&cursor->entry, &n->entry);
+			return true;
+		}
 	}
 
-	return !list_empty(&rescuer->scheduled);
+	return false;
 }
 
 /**
@@ -3512,6 +3539,7 @@ static int rescuer_thread(void *__rescuer)
 		struct pool_workqueue *pwq = list_first_entry(&wq->maydays,
 					struct pool_workqueue, mayday_node);
 		struct worker_pool *pool = pwq->pool;
+		unsigned int count = 0;
 
 		__set_current_state(TASK_RUNNING);
 		list_del_init(&pwq->mayday_node);
@@ -3524,19 +3552,16 @@ static int rescuer_thread(void *__rescuer)
 
 		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
 
-		if (assign_rescuer_work(pwq, rescuer)) {
+		while (assign_rescuer_work(pwq, rescuer)) {
 			process_scheduled_works(rescuer);
 
 			/*
-			 * The above execution of rescued work items could
-			 * have created more to rescue through
-			 * pwq_activate_first_inactive() or chained
-			 * queueing.  Let's put @pwq back on mayday list so
-			 * that such back-to-back work items, which may be
-			 * being used to relieve memory pressure, don't
-			 * incur MAYDAY_INTERVAL delay inbetween.
+			 * If the per-turn work item limit is reached and other
+			 * PWQs are in mayday, requeue mayday for this PWQ and
+			 * let the rescuer handle the other PWQs first.
 			 */
-			if (pwq->nr_active && need_to_create_worker(pool)) {
+			if (++count > RESCUER_BATCH && !list_empty(&pwq->wq->maydays) &&
+			    pwq->nr_active && need_to_create_worker(pool)) {
 				raw_spin_lock(&wq_mayday_lock);
 				/*
 				 * Queue iff somebody else hasn't queued it already.
@@ -3546,9 +3571,14 @@ static int rescuer_thread(void *__rescuer)
 					list_add_tail(&pwq->mayday_node, &wq->maydays);
 				}
 				raw_spin_unlock(&wq_mayday_lock);
+				break;
 			}
 		}
 
+		/* The cursor can not be left behind without the rescuer watching it. */
+		if (!list_empty(&pwq->mayday_cursor.entry) && list_empty(&pwq->mayday_node))
+			list_del_init(&pwq->mayday_cursor.entry);
+
 		/*
 		 * Leave this pool. Notify regular workers; otherwise, we end up
 		 * with 0 concurrency and stalling the execution.
@@ -5167,6 +5197,19 @@ static void init_pwq(struct pool_workqueue *pwq, struct workqueue_struct *wq,
 	INIT_LIST_HEAD(&pwq->pwqs_node);
 	INIT_LIST_HEAD(&pwq->mayday_node);
 	kthread_init_work(&pwq->release_work, pwq_release_workfn);
+
+	/*
+	 * Set the dummy cursor work with valid function and get_work_pwq().
+	 *
+	 * The cursor work should only be in the pwq->pool->worklist, and
+	 * should not be treated as a processable work item.
+	 *
+	 * WORK_STRUCT_PENDING and WORK_STRUCT_INACTIVE just make it less
+	 * surprise for kernel debugging tools and reviewers.
+	 */
+	INIT_WORK(&pwq->mayday_cursor, mayday_cursor_func);
+	atomic_long_set(&pwq->mayday_cursor.data, (unsigned long)pwq |
+			WORK_STRUCT_PENDING | WORK_STRUCT_PWQ | WORK_STRUCT_INACTIVE);
 }
 
 /* sync @pwq with the current state of its associated wq and link it */
-- 
2.51.0



