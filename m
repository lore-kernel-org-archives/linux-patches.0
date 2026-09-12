Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B6E3C1419;
	Sat, 12 Sep 2026 07:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197091; cv=none; b=SlXGlBLXGrcW0u3iwJLrVRhgC/8le5NaHEx78FU8pSRYoj7haajUxab0/ogEk/3BVBAnIwpkkYPscoDjTNgbjM4jIHZhYwxZG3oKHGQZK8tVMnfpNWGZk9ZFLhpoGkrLF4qET8CdEwrlGvSonQzx9ZFwIFsZc1zO/U5YRLxchN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197091; c=relaxed/simple;
	bh=z78W7OdLuOH0P8WLRqpF/r+3UcVETR7gFJqfvaa/5OI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HS4/4Xs2j4QEvq4rMIET/Z57ihNGVDljU2q3L+ayXjcvR6DGfNQy7RkrKO3LZMWCpFbbwH+EIRa3YqwMfSSefosxfcG6JjPcQlA5G/vRId4/NC9msvn6nHGy57CZCajHU5W4D4WyYAu5DNW/hHvkQkT4adzE9CvjGUZrfI3Kk7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xX6Wbedc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xX6Wbedc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703E31F000FF;
	Sat, 12 Sep 2026 07:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197090;
	bh=jOhh+TeF5fJqf6Uh/ifz6fixCaCLB2fFsC4UGTy/ky4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xX6WbedcY3s9LnYeX5eFwY0zAaqjftkuDK+9zvtNtogtbX/ckGp8o566HPoh69Jky
	 oIVyuU+v3RkIOB2Mxz7J7J4jlbtoGNl72s0s4+J40ex2Y8zAK7ol0orgR1QCEmp+2u
	 ajd3W7zPSwcKpsG4fTXGSShVxiKedf3TP9XDR3ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0100/1815] sched/core: Fix inter-class wakeup_preempt()
Date: Sat, 12 Sep 2026 08:30:50 +0200
Message-ID: <20260912065651.358027678@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit fa02b2868420d9f33d64ddcb15ef0f96880b2a6d ]

The way wakeup_preempt() works since commit 704069649b5b ("sched/core: Rework
sched_class::wakeup_preempt() and rq_modified_*()") is that it will call
rq->next_class->wakeup_preempt(rq, p) when p is of an equal or higher class,
and raise ->next_class when higher.

This means that:

	running idle task

	wakeup fair-A
	  (next_class == idle)
	  if (sched_class_above(fair, idle)) {
	     wakeup_preempt_idle(fair-A);
	     resched_curr(rq);
	     next_class = fair;
	  }

	wakeup fair-B
	  (next_class == fair)
	  if (fair == fair)
	    wakeup_preempt_fair(fair-B);
	      (but current is idle)

All wakeup_preempt_$class() methods, except for wakeup_preempt_scx() (for whoem
this was build) ignore cross-class wakeups by testing if @p is of the right
class, but per the above case, it also should check current.

This is mostly harmless in the current form, but will lead to trouble with
later patches.

Fixes: 704069649b5b ("sched/core: Rework sched_class::wakeup_preempt() and rq_modified_*()")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260626074605.GB2568396%40noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 6 ++++--
 kernel/sched/fair.c     | 3 ++-
 kernel/sched/rt.c       | 3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 200300043fa54..857dbe3519a86 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2734,15 +2734,17 @@ static int balance_dl(struct rq *rq, struct rq_flags *rf)
  */
 static void wakeup_preempt_dl(struct rq *rq, struct task_struct *p, int flags)
 {
+	struct task_struct *donor = rq->donor;
 	/*
 	 * Can only get preempted by stop-class, and those should be
 	 * few and short lived, doesn't really make sense to push
 	 * anything away for that.
 	 */
-	if (p->sched_class != &dl_sched_class)
+	if (p->sched_class != &dl_sched_class ||
+	    donor->sched_class != &dl_sched_class)
 		return;
 
-	if (dl_entity_preempt(&p->dl, &rq->donor->dl)) {
+	if (dl_entity_preempt(&p->dl, &donor->dl)) {
 		resched_curr(rq);
 		return;
 	}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f15f5764818eb..c36f1e8bff647 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9780,7 +9780,8 @@ static void wakeup_preempt_fair(struct rq *rq, struct task_struct *p, int wake_f
 	/*
 	 * XXX Getting preempted by higher class, try and find idle CPU?
 	 */
-	if (p->sched_class != &fair_sched_class)
+	if (p->sched_class != &fair_sched_class ||
+	    donor->sched_class != &fair_sched_class)
 		return;
 
 	if (unlikely(se == pse))
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e474c31d8fe66..e6e5f8a2caafb 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1629,7 +1629,8 @@ static void wakeup_preempt_rt(struct rq *rq, struct task_struct *p, int flags)
 	/*
 	 * XXX If we're preempted by DL, queue a push?
 	 */
-	if (p->sched_class != &rt_sched_class)
+	if (p->sched_class != &rt_sched_class ||
+	    donor->sched_class != &rt_sched_class)
 		return;
 
 	if (p->prio < donor->prio) {
-- 
2.53.0



