Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD7535C1B3;
	Tue,  6 Jan 2026 17:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721573; cv=none; b=UfvOJqeYXnzpM3aFU4p+kdG3eFh7sieuqTBYhwZlmlo0wWgqnR+QmR6tQlZ0eg90QkI49NpD4yXRBpB4QoRNHm9UuyQVhPxio/q5z9HqH3K4HZqWKKAgMhQJ0OwVa0VsQYpQVb5lPT1S/DdnG5HvTgAMWUrieykkohm240F8VzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721573; c=relaxed/simple;
	bh=yYNbcevIFGl1jHgmxma8GWMY+M1ygwWeiwpi/WLhgJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n8OCyiFW1s7c4MdRJ2LhHvi0vU+dxS7dYqWhRjnH9AcXDMFwWHgWOYV5wJ1VTeIP05sJGyfCudxnjoIWYIjGormT7d/TqiGE3BkmL3yhEInAe+acrENxABrpj3I5pPjgI2VP7oSHrM9Xl9rdpkLhnbsmaQSsj+drsGzK+GFO+lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyBcqYjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyBcqYjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CC9C116C6;
	Tue,  6 Jan 2026 17:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721573;
	bh=yYNbcevIFGl1jHgmxma8GWMY+M1ygwWeiwpi/WLhgJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyBcqYjgPlIh2ybOhoQQ/alr0kIS8QzL3OHcLKlCqtMK0XjpfOhdBHC8Pw6xuP9nh
	 bYRNjvPMkWnKmBz/6HYDjuazUZYSe4JddZ+YWAU12kE1FEE1BWyhk6Pd3J0AwAYdx6
	 dbAKh8Gwk1SWxnzcYyAODrPynrHob+VXAeA+gZoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Fernand Sieber <sieberf@amazon.com>,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Subject: [PATCH 6.18 001/312] sched/proxy: Yield the donor task
Date: Tue,  6 Jan 2026 18:01:15 +0100
Message-ID: <20260106170547.891234889@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernand Sieber <sieberf@amazon.com>

commit 127b90315ca07ccad2618db7ba950a63e3b32d22 upstream.

When executing a task in proxy context, handle yields as if they were
requested by the donor task. This matches the traditional PI semantics
of yield() as well.

This avoids scenario like proxy task yielding, pick next task selecting the
same previous blocked donor, running the proxy task again, etc.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202510211205.1e0f5223-lkp@intel.com
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fernand Sieber <sieberf@amazon.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20251106104022.195157-1-sieberf@amazon.com
Cc: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/deadline.c |    2 +-
 kernel/sched/ext.c      |    4 ++--
 kernel/sched/fair.c     |    2 +-
 kernel/sched/rt.c       |    2 +-
 kernel/sched/syscalls.c |    5 +++--
 5 files changed, 8 insertions(+), 7 deletions(-)

--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2143,7 +2143,7 @@ static void yield_task_dl(struct rq *rq)
 	 * it and the bandwidth timer will wake it up and will give it
 	 * new scheduling parameters (thanks to dl_yielded=1).
 	 */
-	rq->curr->dl.dl_yielded = 1;
+	rq->donor->dl.dl_yielded = 1;
 
 	update_rq_clock(rq);
 	update_curr_dl(rq);
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -1493,7 +1493,7 @@ static bool dequeue_task_scx(struct rq *
 static void yield_task_scx(struct rq *rq)
 {
 	struct scx_sched *sch = scx_root;
-	struct task_struct *p = rq->curr;
+	struct task_struct *p = rq->donor;
 
 	if (SCX_HAS_OP(sch, yield))
 		SCX_CALL_OP_2TASKS_RET(sch, SCX_KF_REST, yield, rq, p, NULL);
@@ -1504,7 +1504,7 @@ static void yield_task_scx(struct rq *rq
 static bool yield_to_task_scx(struct rq *rq, struct task_struct *to)
 {
 	struct scx_sched *sch = scx_root;
-	struct task_struct *from = rq->curr;
+	struct task_struct *from = rq->donor;
 
 	if (SCX_HAS_OP(sch, yield))
 		return SCX_CALL_OP_2TASKS_RET(sch, SCX_KF_REST, yield, rq,
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8993,7 +8993,7 @@ static void put_prev_task_fair(struct rq
  */
 static void yield_task_fair(struct rq *rq)
 {
-	struct task_struct *curr = rq->curr;
+	struct task_struct *curr = rq->donor;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	struct sched_entity *se = &curr->se;
 
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1490,7 +1490,7 @@ static void requeue_task_rt(struct rq *r
 
 static void yield_task_rt(struct rq *rq)
 {
-	requeue_task_rt(rq, rq->curr, 0);
+	requeue_task_rt(rq, rq->donor, 0);
 }
 
 static int find_lowest_rq(struct task_struct *task);
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -1351,7 +1351,7 @@ static void do_sched_yield(void)
 	rq = this_rq_lock_irq(&rf);
 
 	schedstat_inc(rq->yld_count);
-	current->sched_class->yield_task(rq);
+	rq->donor->sched_class->yield_task(rq);
 
 	preempt_disable();
 	rq_unlock_irq(rq, &rf);
@@ -1420,12 +1420,13 @@ EXPORT_SYMBOL(yield);
  */
 int __sched yield_to(struct task_struct *p, bool preempt)
 {
-	struct task_struct *curr = current;
+	struct task_struct *curr;
 	struct rq *rq, *p_rq;
 	int yielded = 0;
 
 	scoped_guard (raw_spinlock_irqsave, &p->pi_lock) {
 		rq = this_rq();
+		curr = rq->donor;
 
 again:
 		p_rq = task_rq(p);


