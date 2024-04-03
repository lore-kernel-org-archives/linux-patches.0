Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0378152DF0;
	Wed,  3 Apr 2024 17:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712167034; cv=none; b=jZOrgPw77qeEA09Wlmrl1aWA++2XXjDwhfjIVMFhgxMPCDW1yNSjWZ9N3572dWMrn+L9gddoBSLaKjHdD6jk0K163pwj5dyw0wa4MfyAUIuwgrxtbkm2+2eHA17EODmH2OWwB/Yu0RW3QhHHAqKA80XHyQtNO6tQLuqzy7XSTOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712167034; c=relaxed/simple;
	bh=ICFC+pR/DyQgl0QsBCU41d3bO2hYKcIopyTjBXOPhqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKOIEOrPVgXaEuIA3b/VIdaQpzG3+FrOezywhCtQw2D8qX2mDB6Pv0hF6elqoVmcAir5L13Y1lSBroJRDxnAk4Y9YxR08PMxzrtDayFF/gL2k97lemXPUFi/BSwTz8QTl/xVTmBQ6qRKsahw++0S5uwuuiWgTItfHkE9vt0ZnwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PE5G7m2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PE5G7m2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FC3C433C7;
	Wed,  3 Apr 2024 17:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712167034;
	bh=ICFC+pR/DyQgl0QsBCU41d3bO2hYKcIopyTjBXOPhqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PE5G7m2b5mCqK4Xh346firvOHtDpt/9tHMQyylQgr+6o2llotPXRdi72J8EcRTPc4
	 mk3ytHY4LQW4LKEelH5LyWzdi5qG6XHshGkJWiyK6bRzu6opJ+HH/ZwZTE0skRzpKK
	 qhfAe4AnqhLMv71kJOFos7bhcppjJcxvv4Ka4S48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Tejun Heo <tj@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Audra Mitchell <audra@redhat.com>
Subject: [PATCH 6.6 10/11] Revert "workqueue: Move pwq->max_active to wq->max_active"
Date: Wed,  3 Apr 2024 19:55:59 +0200
Message-ID: <20240403175127.170444800@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403175126.839589571@linuxfoundation.org>
References: <20240403175126.839589571@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 82e098f5bed1ff167332d26f8551662098747ec4 which is
commit a045a272d887575da17ad86d6573e82871b50c27 upstream.

The workqueue patches backported to 6.6.y caused some reported
regressions, so revert them for now.

Reported-by: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Tejun Heo <tj@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Audra Mitchell <audra@redhat.com>
Link: https://lore.kernel.org/all/ce4c2f67-c298-48a0-87a3-f933d646c73b@leemhuis.info/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |  133 ++++++++++++++++++++++++++---------------------------
 1 file changed, 67 insertions(+), 66 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -143,9 +143,6 @@ enum {
  *
  * WR: wq->mutex protected for writes.  RCU protected for reads.
  *
- * WO: wq->mutex protected for writes. Updated with WRITE_ONCE() and can be read
- *     with READ_ONCE() without locking.
- *
  * MD: wq_mayday_lock protected.
  *
  * WD: Used internally by the watchdog.
@@ -253,6 +250,7 @@ struct pool_workqueue {
 	 * is marked with WORK_STRUCT_INACTIVE iff it is in pwq->inactive_works.
 	 */
 	int			nr_active;	/* L: nr of active works */
+	int			max_active;	/* L: max active works */
 	struct list_head	inactive_works;	/* L: inactive works */
 	struct list_head	pwqs_node;	/* WR: node on wq->pwqs */
 	struct list_head	mayday_node;	/* MD: node on wq->maydays */
@@ -300,8 +298,7 @@ struct workqueue_struct {
 	struct worker		*rescuer;	/* MD: rescue worker */
 
 	int			nr_drainers;	/* WQ: drain in progress */
-	int			max_active;	/* WO: max active works */
-	int			saved_max_active; /* WQ: saved max_active */
+	int			saved_max_active; /* WQ: saved pwq max_active */
 
 	struct workqueue_attrs	*unbound_attrs;	/* PW: only for unbound wqs */
 	struct pool_workqueue	*dfl_pwq;	/* PW: only for unbound wqs */
@@ -1489,7 +1486,7 @@ static void pwq_dec_nr_in_flight(struct
 		pwq->nr_active--;
 		if (!list_empty(&pwq->inactive_works)) {
 			/* one down, submit an inactive one */
-			if (pwq->nr_active < READ_ONCE(pwq->wq->max_active))
+			if (pwq->nr_active < pwq->max_active)
 				pwq_activate_first_inactive(pwq);
 		}
 	}
@@ -1790,13 +1787,7 @@ retry:
 	pwq->nr_in_flight[pwq->work_color]++;
 	work_flags = work_color_to_flags(pwq->work_color);
 
-	/*
-	 * Limit the number of concurrently active work items to max_active.
-	 * @work must also queue behind existing inactive work items to maintain
-	 * ordering when max_active changes. See wq_adjust_max_active().
-	 */
-	if (list_empty(&pwq->inactive_works) &&
-	    pwq->nr_active < READ_ONCE(pwq->wq->max_active)) {
+	if (likely(pwq->nr_active < pwq->max_active)) {
 		if (list_empty(&pool->worklist))
 			pool->watchdog_ts = jiffies;
 
@@ -4145,6 +4136,50 @@ static void pwq_release_workfn(struct kt
 	}
 }
 
+/**
+ * pwq_adjust_max_active - update a pwq's max_active to the current setting
+ * @pwq: target pool_workqueue
+ *
+ * If @pwq isn't freezing, set @pwq->max_active to the associated
+ * workqueue's saved_max_active and activate inactive work items
+ * accordingly.  If @pwq is freezing, clear @pwq->max_active to zero.
+ */
+static void pwq_adjust_max_active(struct pool_workqueue *pwq)
+{
+	struct workqueue_struct *wq = pwq->wq;
+	bool freezable = wq->flags & WQ_FREEZABLE;
+	unsigned long flags;
+
+	/* for @wq->saved_max_active */
+	lockdep_assert_held(&wq->mutex);
+
+	/* fast exit for non-freezable wqs */
+	if (!freezable && pwq->max_active == wq->saved_max_active)
+		return;
+
+	/* this function can be called during early boot w/ irq disabled */
+	raw_spin_lock_irqsave(&pwq->pool->lock, flags);
+
+	/*
+	 * During [un]freezing, the caller is responsible for ensuring that
+	 * this function is called at least once after @workqueue_freezing
+	 * is updated and visible.
+	 */
+	if (!freezable || !workqueue_freezing) {
+		pwq->max_active = wq->saved_max_active;
+
+		while (!list_empty(&pwq->inactive_works) &&
+		       pwq->nr_active < pwq->max_active)
+			pwq_activate_first_inactive(pwq);
+
+		kick_pool(pwq->pool);
+	} else {
+		pwq->max_active = 0;
+	}
+
+	raw_spin_unlock_irqrestore(&pwq->pool->lock, flags);
+}
+
 /* initialize newly allocated @pwq which is associated with @wq and @pool */
 static void init_pwq(struct pool_workqueue *pwq, struct workqueue_struct *wq,
 		     struct worker_pool *pool)
@@ -4177,6 +4212,9 @@ static void link_pwq(struct pool_workque
 	/* set the matching work_color */
 	pwq->work_color = wq->work_color;
 
+	/* sync max_active to the current setting */
+	pwq_adjust_max_active(pwq);
+
 	/* link in @pwq */
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
 }
@@ -4627,52 +4665,6 @@ static int init_rescuer(struct workqueue
 	return 0;
 }
 
-/**
- * wq_adjust_max_active - update a wq's max_active to the current setting
- * @wq: target workqueue
- *
- * If @wq isn't freezing, set @wq->max_active to the saved_max_active and
- * activate inactive work items accordingly. If @wq is freezing, clear
- * @wq->max_active to zero.
- */
-static void wq_adjust_max_active(struct workqueue_struct *wq)
-{
-	struct pool_workqueue *pwq;
-
-	lockdep_assert_held(&wq->mutex);
-
-	if ((wq->flags & WQ_FREEZABLE) && workqueue_freezing) {
-		WRITE_ONCE(wq->max_active, 0);
-		return;
-	}
-
-	if (wq->max_active == wq->saved_max_active)
-		return;
-
-	/*
-	 * Update @wq->max_active and then kick inactive work items if more
-	 * active work items are allowed. This doesn't break work item ordering
-	 * because new work items are always queued behind existing inactive
-	 * work items if there are any.
-	 */
-	WRITE_ONCE(wq->max_active, wq->saved_max_active);
-
-	for_each_pwq(pwq, wq) {
-		unsigned long flags;
-
-		/* this function can be called during early boot w/ irq disabled */
-		raw_spin_lock_irqsave(&pwq->pool->lock, flags);
-
-		while (!list_empty(&pwq->inactive_works) &&
-		       pwq->nr_active < wq->max_active)
-			pwq_activate_first_inactive(pwq);
-
-		kick_pool(pwq->pool);
-
-		raw_spin_unlock_irqrestore(&pwq->pool->lock, flags);
-	}
-}
-
 __printf(1, 4)
 struct workqueue_struct *alloc_workqueue(const char *fmt,
 					 unsigned int flags,
@@ -4680,6 +4672,7 @@ struct workqueue_struct *alloc_workqueue
 {
 	va_list args;
 	struct workqueue_struct *wq;
+	struct pool_workqueue *pwq;
 	int len;
 
 	/*
@@ -4718,7 +4711,6 @@ struct workqueue_struct *alloc_workqueue
 
 	/* init wq */
 	wq->flags = flags;
-	wq->max_active = max_active;
 	wq->saved_max_active = max_active;
 	mutex_init(&wq->mutex);
 	atomic_set(&wq->nr_pwqs_to_flush, 0);
@@ -4747,7 +4739,8 @@ struct workqueue_struct *alloc_workqueue
 	mutex_lock(&wq_pool_mutex);
 
 	mutex_lock(&wq->mutex);
-	wq_adjust_max_active(wq);
+	for_each_pwq(pwq, wq)
+		pwq_adjust_max_active(pwq);
 	mutex_unlock(&wq->mutex);
 
 	list_add_tail_rcu(&wq->list, &workqueues);
@@ -4885,6 +4878,8 @@ EXPORT_SYMBOL_GPL(destroy_workqueue);
  */
 void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 {
+	struct pool_workqueue *pwq;
+
 	/* disallow meddling with max_active for ordered workqueues */
 	if (WARN_ON(wq->flags & __WQ_ORDERED_EXPLICIT))
 		return;
@@ -4895,7 +4890,9 @@ void workqueue_set_max_active(struct wor
 
 	wq->flags &= ~__WQ_ORDERED;
 	wq->saved_max_active = max_active;
-	wq_adjust_max_active(wq);
+
+	for_each_pwq(pwq, wq)
+		pwq_adjust_max_active(pwq);
 
 	mutex_unlock(&wq->mutex);
 }
@@ -5142,8 +5139,8 @@ static void show_pwq(struct pool_workque
 	pr_info("  pwq %d:", pool->id);
 	pr_cont_pool_info(pool);
 
-	pr_cont(" active=%d refcnt=%d%s\n",
-		pwq->nr_active, pwq->refcnt,
+	pr_cont(" active=%d/%d refcnt=%d%s\n",
+		pwq->nr_active, pwq->max_active, pwq->refcnt,
 		!list_empty(&pwq->mayday_node) ? " MAYDAY" : "");
 
 	hash_for_each(pool->busy_hash, bkt, worker, hentry) {
@@ -5691,6 +5688,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu_safe_key);
 void freeze_workqueues_begin(void)
 {
 	struct workqueue_struct *wq;
+	struct pool_workqueue *pwq;
 
 	mutex_lock(&wq_pool_mutex);
 
@@ -5699,7 +5697,8 @@ void freeze_workqueues_begin(void)
 
 	list_for_each_entry(wq, &workqueues, list) {
 		mutex_lock(&wq->mutex);
-		wq_adjust_max_active(wq);
+		for_each_pwq(pwq, wq)
+			pwq_adjust_max_active(pwq);
 		mutex_unlock(&wq->mutex);
 	}
 
@@ -5764,6 +5763,7 @@ out_unlock:
 void thaw_workqueues(void)
 {
 	struct workqueue_struct *wq;
+	struct pool_workqueue *pwq;
 
 	mutex_lock(&wq_pool_mutex);
 
@@ -5775,7 +5775,8 @@ void thaw_workqueues(void)
 	/* restore max_active and repopulate worklist */
 	list_for_each_entry(wq, &workqueues, list) {
 		mutex_lock(&wq->mutex);
-		wq_adjust_max_active(wq);
+		for_each_pwq(pwq, wq)
+			pwq_adjust_max_active(pwq);
 		mutex_unlock(&wq->mutex);
 	}
 


