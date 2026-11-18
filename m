Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021944;
	b=f/XSv7Qc1738l36NlLdf9sl9/Ty5brXExy0dWcq4p38cC3VEwuVCrJqPecFbkiicZ5sk
	 x5jLQXxXHsyi9imQtzuZR1c/kml6F3D5Q2whgMU2fwD4P9izUVeRz0/WXdFtIZ8rckaUS
	 Su0Uo09X2MoQ0Euot5dhiBIxtfaCPjKIBTVh9DiSubS+hG53xGNP5K4yzgX7B83yrbTzq
	 1Jo3lHd+Gsa/U7Uloaju8RsYjzG27MjLge6dRM1qOHgxaaDQ4sbaNDcZHcZV3pElE+I/9
	 awFhqSQFAYgolzFBwhsT7D6elxtWvly8jdfUXta03KkhozE1Gj7a1yS0ou9HQKaaCPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uR/fQBcSCNP2nrsmNNqO8Us/sX+TGZkuR7xpKuYzUOg=;
	b=H8qp2Svj0ypyHOsfStbTWAT/DApAK/lN49yCUwCFN/5SlTcYNFC+vXomwJmmwSdliW5C
	 Nc9wYkM4iGnUl+aWq7t6aPEDVm4vDBplD9qloQhy+VBX2BvewVwJULedjRV/sbc8TxmvP
	 tbL9PoUBwyZdcnOlLc0IWE5cnCwtQA2puInqCCj6WC2JYGt6hUGSiyI2WlwznlSGCdRvi
	 bUrJJDm+h19siK6oXi6sGfo5Ew/L4EsvBcbI9+jgrNMtWSpt2UiwVBMzDnv+AYEvqoJkO
	 8sU8OW+DSN4VZfA4u0dbi4Qwr4ls38o8jPmn4ML1nWqW5u6YfGLkroayw6vUuAmgJ3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnzIdstZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8354606A320;
	Wed, 18 Nov 2026 17:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnzIdstZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2871F000C4;
	Wed, 18 Nov 2026 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021944;
	bh=uR/fQBcSCNP2nrsmNNqO8Us/sX+TGZkuR7xpKuYzUOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnzIdstZvNrOGmzSTYuZekvb9MCcHNJPwEH6BYkB7UpIy8GWqu+Sk15eptZ3lz018
	 2gn0tPi0gIpxe4nsA3mnUGOBJT3DvIDBzpEhAuBxO9TcCEL67KDkMODWhvpH6x9fYk
	 Ep0T0wszjgxO60P1CWYw89ZU5OkzgAiNWA8ecxaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2486/2651] sched_ext: Fix ops.running/stopping() pairing for proxy-exec donors
Date: Wed, 18 Nov 2026 16:02:06 +0100
Message-ID: <20261118150414.387867376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit 5f882051efabaf19f9b4dbe4b50cee1d250ac19e ]

With proxy execution, pick_next_task() can select a blocked task as the
scheduling context before find_proxy_task() resolves the execution
context.

>From the BPF scheduler perspective, that donor is running while its
scheduling context drives the lock owner; ops.tick() and other
accounting must therefore remain enclosed by a matching
ops.running()/ops.stopping() session.

In this scenario, the session boundaries do not always match physical
task switches. Keep the "running" session open when the same donor
continues on the same CPU. When proxy execution migrates a donor's
scheduling context to another CPU, end its running session on the source
CPU and start a new session on the destination CPU only after proxy
resolution succeeds. This prevents a failed resolution from exposing a
provisional ops.running() event.

Track these sessions with a new SCX_TASK_RUN_TRACKED flag. The explicit
running-state tracking is also required by later donor-based accounting:
it prevents an EXT owner executing for a non-EXT donor from being
treated as the active EXT scheduling context when it is dequeued.

This is a preparatory change for enabling proxy execution together with
sched_ext.

Acked-by: John Stultz <jstultz@google.com>
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 5c23d1710606 ("sched_ext: Fix queued bypassed tasks stalling when the host loses SCX_CAP_BASE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/ext.h                     |  1 +
 kernel/sched/ext/ext.c                        | 72 ++++++++++++++-----
 kernel/sched/ext/internal.h                   |  6 ++
 .../sched_ext/include/scx/enum_defs.autogen.h |  1 +
 4 files changed, 64 insertions(+), 16 deletions(-)

diff --git a/include/linux/sched/ext.h b/include/linux/sched/ext.h
index 36c04797436c7..81a29b3c0e5d8 100644
--- a/include/linux/sched/ext.h
+++ b/include/linux/sched/ext.h
@@ -104,6 +104,7 @@ enum scx_ent_flags {
 	SCX_TASK_SUB_INIT	= 1 << 4, /* task being initialized for a sub sched */
 	SCX_TASK_IMMED		= 1 << 5, /* task is on local DSQ with %SCX_ENQ_IMMED */
 	SCX_TASK_PROTECTED	= 1 << 6, /* slice and DSQ head position protected */
+	SCX_TASK_RUN_TRACKED	= 1 << 7, /* task is in an ops.running()/stopping() session */
 
 	/*
 	 * Bits 8 to 10 are used to carry task state:
diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 4482df6d1187d..c7565bc66fa1f 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -2333,10 +2333,10 @@ static bool dequeue_task_scx(struct rq *rq, struct task_struct *p, int core_deq_
 	ops_dequeue(rq, p, deq_flags);
 
 	/*
-	 * A currently running task which is going off @rq first gets dequeued
-	 * and then stops running. As we want running <-> stopping transitions
-	 * to be contained within runnable <-> quiescent transitions, trigger
-	 * ->stopping() early here instead of in put_prev_task_scx().
+	 * A current scheduling context which is going off @rq first gets
+	 * dequeued and then stops running. As we want running <-> stopping
+	 * transitions to be contained within runnable <-> quiescent transitions,
+	 * trigger ->stopping() early here instead of in put_prev_task_scx().
 	 *
 	 * @p may go through multiple stopping <-> running transitions between
 	 * here and put_prev_task_scx() if task attribute changes occur while
@@ -2344,11 +2344,13 @@ static bool dequeue_task_scx(struct rq *rq, struct task_struct *p, int core_deq_
 	 * information meaningful to the BPF scheduler and can be suppressed by
 	 * skipping the callbacks if the task is !QUEUED.
 	 */
-	if (task_current(rq, p) &&
-	    (SCX_HAS_OP(sch, stopping) || unlikely(p == scx_rescuee(rq)))) {
-		update_curr_scx(rq);
-		if (SCX_HAS_OP(sch, stopping))
-			SCX_CALL_OP_TASK(sch, stopping, rq, p, false);
+	if (task_current_donor(rq, p) && (p->scx.flags & SCX_TASK_RUN_TRACKED)) {
+		if (SCX_HAS_OP(sch, stopping) || unlikely(p == scx_rescuee(rq))) {
+			update_curr_scx(rq);
+			if (SCX_HAS_OP(sch, stopping))
+				SCX_CALL_OP_TASK(sch, stopping, rq, p, false);
+		}
+		p->scx.flags &= ~SCX_TASK_RUN_TRACKED;
 	}
 
 	if (SCX_HAS_OP(sch, quiescent) && !task_on_rq_migrating(p))
@@ -3065,10 +3067,23 @@ static enum scx_dsp_verdict dispatch_one(struct rq *rq, struct task_struct *prev
 	return verdict;
 }
 
-static void set_next_task_scx(struct rq *rq, struct task_struct *p, enum snt_e type)
+static void scx_start_task_running(struct rq *rq, struct task_struct *p)
 {
 	struct scx_sched *sch = scx_task_sched(p);
 
+	if (p->scx.flags & SCX_TASK_RUN_TRACKED)
+		return;
+
+	if (SCX_HAS_OP(sch, running))
+		SCX_CALL_OP_TASK(sch, running, rq, p);
+
+	p->scx.flags |= SCX_TASK_RUN_TRACKED;
+}
+
+static void set_next_task_scx(struct rq *rq, struct task_struct *p, enum snt_e type)
+{
+	bool first = type == SNT_PICK;
+
 	if (type == SNT_REPICK)
 		return;
 
@@ -3083,9 +3098,20 @@ static void set_next_task_scx(struct rq *rq, struct task_struct *p, enum snt_e t
 
 	p->se.exec_start = rq_clock_task(rq);
 
-	/* see dequeue_task_scx() on why we skip when !QUEUED */
-	if (SCX_HAS_OP(sch, running) && (p->scx.flags & SCX_TASK_QUEUED))
-		SCX_CALL_OP_TASK(sch, running, rq, p);
+	/*
+	 * See dequeue_task_scx() for why we skip when !QUEUED.
+	 *
+	 * During a normal switch (@first), a blocked task is only a provisional
+	 * donor. Proxy resolution may fail or migrate the donor to another CPU,
+	 * so defer ops.running() until scx_proxy_donor_start() confirms that
+	 * resolution succeeded.
+	 *
+	 * !@first denotes restoration after a SAVE/RESTORE cycle. The matching
+	 * dequeue already issued ops.stopping(), so restart the session here
+	 * regardless of the donor state.
+	 */
+	if ((p->scx.flags & SCX_TASK_QUEUED) && !(p->is_blocked && first))
+		scx_start_task_running(rq, p);
 
 	clr_task_runnable(p, true);
 
@@ -3131,6 +3157,12 @@ static void set_next_task_scx(struct rq *rq, struct task_struct *p, enum snt_e t
 
 void scx_proxy_donor_start(struct rq *rq)
 {
+	struct task_struct *donor = rq->donor;
+
+	lockdep_assert_rq_held(rq);
+
+	if (donor->sched_class == &ext_sched_class && (donor->scx.flags & SCX_TASK_QUEUED))
+		scx_start_task_running(rq, donor);
 }
 
 static enum scx_cpu_preempt_reason
@@ -3206,9 +3238,17 @@ static void put_prev_task_scx(struct rq *rq, struct task_struct *p,
 			scx_task_slice_ended(rq, p);
 	}
 
-	/* see dequeue_task_scx() on why we skip when !QUEUED */
-	if (SCX_HAS_OP(sch, stopping) && (p->scx.flags & SCX_TASK_QUEUED))
-		SCX_CALL_OP_TASK(sch, stopping, rq, p, true);
+	/*
+	 * Preserve the running session when proxy execution refreshes the same
+	 * donor around an execution-context switch on this rq.
+	 */
+	if (next != p && (p->scx.flags & SCX_TASK_QUEUED) &&
+	    (p->scx.flags & SCX_TASK_RUN_TRACKED)) {
+		if (SCX_HAS_OP(sch, stopping))
+			SCX_CALL_OP_TASK(sch, stopping, rq, p, true);
+
+		p->scx.flags &= ~SCX_TASK_RUN_TRACKED;
+	}
 
 	if (p->scx.flags & SCX_TASK_QUEUED) {
 		set_task_runnable(rq, p);
diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
index a0619c941e91b..8d5ebec29b70d 100644
--- a/kernel/sched/ext/internal.h
+++ b/kernel/sched/ext/internal.h
@@ -477,6 +477,12 @@ struct sched_ext_ops {
 	 * Therefore, always use scx_bpf_task_cpu(@p) to determine the
 	 * target CPU the task is going to use.
 	 *
+	 * Under proxy execution, the BPF scheduler continues to observe the
+	 * donor as the current scheduling context. A blocked donor enters a
+	 * ->running()/->stopping() session while its scheduling context drives
+	 * the lock owner. The lock owner executing on its behalf is intentionally
+	 * not reported through these callbacks.
+	 *
 	 * See ->runnable() for explanation on the task state notifiers.
 	 */
 	void (*running)(struct task_struct *p);
diff --git a/tools/sched_ext/include/scx/enum_defs.autogen.h b/tools/sched_ext/include/scx/enum_defs.autogen.h
index 63b6b14b19bd4..6cb26ad5033cd 100644
--- a/tools/sched_ext/include/scx/enum_defs.autogen.h
+++ b/tools/sched_ext/include/scx/enum_defs.autogen.h
@@ -105,6 +105,7 @@
 #define HAVE_SCX_TASK_SUB_INIT
 #define HAVE_SCX_TASK_IMMED
 #define HAVE_SCX_TASK_PROTECTED
+#define HAVE_SCX_TASK_RUN_TRACKED
 #define HAVE_SCX_TASK_STATE_SHIFT
 #define HAVE_SCX_TASK_STATE_BITS
 #define HAVE_SCX_TASK_STATE_MASK
-- 
2.53.0



