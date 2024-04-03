Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88677154446;
	Wed,  3 Apr 2024 17:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712167025; cv=none; b=n+khURNEbnpGBuH97Z7kALocngcCcPf1Uhrekhnx3xfqFbvJPAjqKkAHmhbdwGU94SJ4DbBWFR30YSiOyUpkmReTKX8YBHca89SNE+GflneVYqjbfi1H1TVCNENN399dgxayOXqOZDWwjwGmGC7aRLMYG8dg73p+MI8S5lJTfIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712167025; c=relaxed/simple;
	bh=2KUVCGY0cYHJuDiWBA0kbwLjE6rLeXbAqmAqclql1k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPyp4vj0tuiaQIXajLiX8PKFTr3I4q/xgZP9xTeRDT6p3fkKEO9ae9Uceu3MWqUmhuuN0Yg75f//VMsoHFI9CrgGvZSUCWWtDqbB6htYRwCU6KeKURUXZvpD/+MetBxgoCKgNOqoz0ic0Z3VDA8CXDsptz1u2Newpd0AbQd/FxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vufNrDje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vufNrDje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8DDC433C7;
	Wed,  3 Apr 2024 17:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712167025;
	bh=2KUVCGY0cYHJuDiWBA0kbwLjE6rLeXbAqmAqclql1k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vufNrDjeR/7ALInmJkIEcUMykcOaTW0MA++lb3GRVD3lhaH5kixsEiNNrlBpO1WqD
	 jnL+2HSBCYf06DWXQuSCn7s1zpNdETURPMRW1iTlOtE/L9ciSXb5eCW1WpL9psgCoT
	 btemUeSVTcXdWxJFySGscjwe2+dWEvipB7U054Ss=
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
Subject: [PATCH 6.6 07/11] Revert "workqueue: Move nr_active handling into helpers"
Date: Wed,  3 Apr 2024 19:55:56 +0200
Message-ID: <20240403175127.077554173@linuxfoundation.org>
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

This reverts commit 4023a2d95076918abe2757d60810642a8115b586 which is
commit 1c270b79ce0b8290f146255ea9057243f6dd3c17 upstream.

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
 kernel/workqueue.c |   86 +++++++++++------------------------------------------
 1 file changed, 19 insertions(+), 67 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1458,14 +1458,11 @@ static bool pwq_is_empty(struct pool_wor
 static void __pwq_activate_work(struct pool_workqueue *pwq,
 				struct work_struct *work)
 {
-	unsigned long *wdb = work_data_bits(work);
-
-	WARN_ON_ONCE(!(*wdb & WORK_STRUCT_INACTIVE));
 	trace_workqueue_activate_work(work);
 	if (list_empty(&pwq->pool->worklist))
 		pwq->pool->watchdog_ts = jiffies;
 	move_linked_works(work, &pwq->pool->worklist, NULL);
-	__clear_bit(WORK_STRUCT_INACTIVE_BIT, wdb);
+	__clear_bit(WORK_STRUCT_INACTIVE_BIT, work_data_bits(work));
 }
 
 /**
@@ -1490,66 +1487,12 @@ static bool pwq_activate_work(struct poo
 	return true;
 }
 
-/**
- * pwq_tryinc_nr_active - Try to increment nr_active for a pwq
- * @pwq: pool_workqueue of interest
- *
- * Try to increment nr_active for @pwq. Returns %true if an nr_active count is
- * successfully obtained. %false otherwise.
- */
-static bool pwq_tryinc_nr_active(struct pool_workqueue *pwq)
-{
-	struct workqueue_struct *wq = pwq->wq;
-	struct worker_pool *pool = pwq->pool;
-	bool obtained;
-
-	lockdep_assert_held(&pool->lock);
-
-	obtained = pwq->nr_active < READ_ONCE(wq->max_active);
-
-	if (obtained)
-		pwq->nr_active++;
-	return obtained;
-}
-
-/**
- * pwq_activate_first_inactive - Activate the first inactive work item on a pwq
- * @pwq: pool_workqueue of interest
- *
- * Activate the first inactive work item of @pwq if available and allowed by
- * max_active limit.
- *
- * Returns %true if an inactive work item has been activated. %false if no
- * inactive work item is found or max_active limit is reached.
- */
-static bool pwq_activate_first_inactive(struct pool_workqueue *pwq)
-{
-	struct work_struct *work =
-		list_first_entry_or_null(&pwq->inactive_works,
-					 struct work_struct, entry);
-
-	if (work && pwq_tryinc_nr_active(pwq)) {
-		__pwq_activate_work(pwq, work);
-		return true;
-	} else {
-		return false;
-	}
-}
-
-/**
- * pwq_dec_nr_active - Retire an active count
- * @pwq: pool_workqueue of interest
- *
- * Decrement @pwq's nr_active and try to activate the first inactive work item.
- */
-static void pwq_dec_nr_active(struct pool_workqueue *pwq)
+static void pwq_activate_first_inactive(struct pool_workqueue *pwq)
 {
-	struct worker_pool *pool = pwq->pool;
+	struct work_struct *work = list_first_entry(&pwq->inactive_works,
+						    struct work_struct, entry);
 
-	lockdep_assert_held(&pool->lock);
-
-	pwq->nr_active--;
-	pwq_activate_first_inactive(pwq);
+	pwq_activate_work(pwq, work);
 }
 
 /**
@@ -1567,8 +1510,14 @@ static void pwq_dec_nr_in_flight(struct
 {
 	int color = get_work_color(work_data);
 
-	if (!(work_data & WORK_STRUCT_INACTIVE))
-		pwq_dec_nr_active(pwq);
+	if (!(work_data & WORK_STRUCT_INACTIVE)) {
+		pwq->nr_active--;
+		if (!list_empty(&pwq->inactive_works)) {
+			/* one down, submit an inactive one */
+			if (pwq->nr_active < READ_ONCE(pwq->wq->max_active))
+				pwq_activate_first_inactive(pwq);
+		}
+	}
 
 	pwq->nr_in_flight[color]--;
 
@@ -1870,11 +1819,13 @@ retry:
 	 * @work must also queue behind existing inactive work items to maintain
 	 * ordering when max_active changes. See wq_adjust_max_active().
 	 */
-	if (list_empty(&pwq->inactive_works) && pwq_tryinc_nr_active(pwq)) {
+	if (list_empty(&pwq->inactive_works) &&
+	    pwq->nr_active < READ_ONCE(pwq->wq->max_active)) {
 		if (list_empty(&pool->worklist))
 			pool->watchdog_ts = jiffies;
 
 		trace_workqueue_activate_work(work);
+		pwq->nr_active++;
 		insert_work(pwq, work, &pool->worklist, work_flags);
 		kick_pool(pool);
 	} else {
@@ -4736,8 +4687,9 @@ static void wq_adjust_max_active(struct
 		/* this function can be called during early boot w/ irq disabled */
 		raw_spin_lock_irqsave(&pwq->pool->lock, flags);
 
-		while (pwq_activate_first_inactive(pwq))
-			;
+		while (!list_empty(&pwq->inactive_works) &&
+		       pwq->nr_active < wq->max_active)
+			pwq_activate_first_inactive(pwq);
 
 		kick_pool(pwq->pool);
 


