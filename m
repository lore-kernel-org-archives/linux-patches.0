Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1070D3B3BE7;
	Thu, 17 Sep 2026 17:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665438; cv=none; b=c12ER2KCIJD+BnvOQrAm/yYW0KsEJC6PgZidnCZ8kacVarpXLJ8HFDvGoRXjAADFgyTtI9ZLeQhWglOMhhrVRaWNC6L0eX14vzHnfD+uklvB2OlD6SMNKI3mIWYWNfAzhnZ2efQQeBRy/OJLYzpPRPIxafpYequUALvdlycwvD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665438; c=relaxed/simple;
	bh=C2r/rTahWkmH+l00QX4qMFbY/n8y0/l3UmZTKKVr9Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6jWS+RPCnYA6XxfVxezNCQwakGYHPveSwWM9MzRBZ/lbh4vWvF5r0yHomiSRrIB1CwiUiQfTWv9AKOzHqA5RGfKR6BCi3tVhzMXk6brBwyeuKppvEGiX+EFnMyu4fUMSkoyNSIv9qniqIq1J329c61H/8Ewg9Ja6mrWmdcSD8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSpv3D+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSpv3D+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0089B1F000FF;
	Thu, 17 Sep 2026 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665436;
	bh=93G+AhRU6yh1XM7HmRYdCyyY7eTp+q8qC+vGZuw9TYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pSpv3D+F5HDIIe79qtGDYorLD67hxdHbFjdN4Yw7ti3ey/p2G6fiWvX6RYjWBGlaF
	 MNee2Jzm2uQQa6KkAXfMgWcVtNNO+tkgBeTxSzufm+Bu2K6ldWLb7dC76vfN09/0/C
	 cUv6IHdP5YXIHNeWdec3rzzDBxthR39X7URsOu2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Peter Zijlstra <peterz@infradead.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0705/1250] sched: Make class_schedulers avoid pushing current, and get rid of proxy_tag_curr()
Date: Thu, 17 Sep 2026 16:08:20 +0100
Message-ID: <20260917151611.007296640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: John Stultz <jstultz@google.com>

[ Upstream commit e0ca8991b2de6c9dfe6fcd8a0364951b2bd56797 ]

With proxy-execution, the scheduler selects the donor, but for
blocked donors, we end up running the lock owner.

This caused some complexity, because the class schedulers make
sure to remove the task they pick from their pushable task
lists, which prevents the donor from being migrated, but there
wasn't then anything to prevent rq->curr from being migrated
if rq->curr != rq->donor.

This was sort of hacked around by calling proxy_tag_curr() on
the rq->curr task if we were running something other then the
donor. proxy_tag_curr() did a dequeue/enqueue pair on the
rq->curr task, allowing the class schedulers to remove it from
their pushable list.

The dequeue/enqueue pair was wasteful, and additonally K Prateek
highlighted that we didn't properly undo things when we stopped
proxying, leaving the lock owner off the pushable list.

After some alternative approaches were considered, Peter
suggested just having the RT/DL classes just avoid migrating
when task_on_cpu().

So rework pick_next_pushable_dl_task() and the rt
pick_next_pushable_task() functions so that they skip over the
first pushable task if it is on_cpu.

Then just drop all of the proxy_tag_curr() logic.

Fixes: be39617e38e0 ("sched: Fix proxy/current (push,pull)ability")
Closes: https://lore.kernel.org/lkml/e735cae0-2cc9-4bae-b761-fcb082ed3e94@amd.com/
Reported-by: K Prateek Nayak <kprateek.nayak@amd.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260324191337.1841376-2-jstultz@google.com
Stable-dep-of: dae5c0292080 ("sched/rt,dl: Skip migrate-disabled tasks when picking a push candidate")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c     | 24 ------------------------
 kernel/sched/deadline.c | 18 ++++++++++++++++--
 kernel/sched/rt.c       | 15 ++++++++++++---
 3 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 560f735cb750b..a46716a8afc7a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6758,23 +6758,6 @@ find_proxy_task(struct rq *rq, struct task_struct *donor, struct rq_flags *rf)
 }
 #endif /* SCHED_PROXY_EXEC */
 
-static inline void proxy_tag_curr(struct rq *rq, struct task_struct *owner)
-{
-	if (!sched_proxy_exec())
-		return;
-	/*
-	 * pick_next_task() calls set_next_task() on the chosen task
-	 * at some point, which ensures it is not push/pullable.
-	 * However, the chosen/donor task *and* the mutex owner form an
-	 * atomic pair wrt push/pull.
-	 *
-	 * Make sure owner we run is not pushable. Unfortunately we can
-	 * only deal with that by means of a dequeue/enqueue cycle. :-/
-	 */
-	dequeue_task(rq, owner, DEQUEUE_NOCLOCK | DEQUEUE_SAVE);
-	enqueue_task(rq, owner, ENQUEUE_NOCLOCK | ENQUEUE_RESTORE);
-}
-
 /*
  * __schedule() is the main scheduler function.
  *
@@ -6925,9 +6908,6 @@ static void __sched notrace __schedule(int sched_mode)
 		 */
 		RCU_INIT_POINTER(rq->curr, next);
 
-		if (!task_current_donor(rq, next))
-			proxy_tag_curr(rq, next);
-
 		/*
 		 * The membarrier system call requires each architecture
 		 * to have a full memory barrier after updating
@@ -6962,10 +6942,6 @@ static void __sched notrace __schedule(int sched_mode)
 		/* Also unlocks the rq: */
 		rq = context_switch(rq, prev, next, &rf);
 	} else {
-		/* In case next was already curr but just got blocked_donor */
-		if (!task_current_donor(rq, next))
-			proxy_tag_curr(rq, next);
-
 		rq_unpin_lock(rq, &rf);
 		__balance_callbacks(rq);
 		raw_spin_rq_unlock_irq(rq);
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 9c90d9f101a87..42160b9d41433 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2768,12 +2768,26 @@ static int find_later_rq(struct task_struct *task)
 
 static struct task_struct *pick_next_pushable_dl_task(struct rq *rq)
 {
-	struct task_struct *p;
+	struct task_struct *i, *p = NULL;
+	struct rb_node *next_node;
 
 	if (!has_pushable_dl_tasks(rq))
 		return NULL;
 
-	p = __node_2_pdl(rb_first_cached(&rq->dl.pushable_dl_tasks_root));
+	next_node = rb_first_cached(&rq->dl.pushable_dl_tasks_root);
+	while (next_node) {
+		i = __node_2_pdl(next_node);
+		/* make sure task isn't on_cpu (possible with proxy-exec) */
+		if (!task_on_cpu(rq, i)) {
+			p = i;
+			break;
+		}
+
+		next_node = rb_next(next_node);
+	}
+
+	if (!p)
+		return NULL;
 
 	WARN_ON_ONCE(rq->cpu != task_cpu(p));
 	WARN_ON_ONCE(task_current(rq, p));
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 717deb5d02156..720da18ade91b 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1853,13 +1853,22 @@ static int find_lowest_rq(struct task_struct *task)
 
 static struct task_struct *pick_next_pushable_task(struct rq *rq)
 {
-	struct task_struct *p;
+	struct plist_head *head = &rq->rt.pushable_tasks;
+	struct task_struct *i, *p = NULL;
 
 	if (!has_pushable_tasks(rq))
 		return NULL;
 
-	p = plist_first_entry(&rq->rt.pushable_tasks,
-			      struct task_struct, pushable_tasks);
+	plist_for_each_entry(i, head, pushable_tasks) {
+		/* make sure task isn't on_cpu (possible with proxy-exec) */
+		if (!task_on_cpu(rq, i)) {
+			p = i;
+			break;
+		}
+	}
+
+	if (!p)
+		return NULL;
 
 	BUG_ON(rq->cpu != task_cpu(p));
 	BUG_ON(task_current(rq, p));
-- 
2.53.0



