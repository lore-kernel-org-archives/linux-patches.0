Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDD0248BA1;
	Wed, 15 Jan 2025 10:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938192; cv=none; b=b/6+oIhA/SxbWxfCZ0v3b2squIH7qmi+fkJLeZ8ZIu5ZBeaBQyWbZ1m9A039EnyqJ8g8250yadP0w8h+SCgq8sHdDSeWxGo2u2thyTU0fmjIdTvgqSMnUJbSXsoa5mcok/WM+J0Kh37xFPost7f9bxQNLgG6T23rHrGoCNQg7bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938192; c=relaxed/simple;
	bh=NmZ+xZbk5HsGQt1fYmsJNtbfJNXrQKkdRW0IdILUtMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4CKTMA5zYABwJYKQiItZg3DIenUEp0l9XTq757Q7ZztVbXj7XYVMNGOGDb4czxIq6Pfn5/zcX1BDEP6g9dLU8cKRDB4YQVaIp5Nk+dQcd54WjUtQdhUMSWQcPlN5Xzb+qUQoBg2iL+COcOg4q8ZLJCXlruPnVfwUkItyq+qaxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJP4T+1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJP4T+1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01679C4CEDF;
	Wed, 15 Jan 2025 10:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938191;
	bh=NmZ+xZbk5HsGQt1fYmsJNtbfJNXrQKkdRW0IdILUtMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJP4T+1t/A97IhHArB/rycQa98ZVy23r6q6GvgzOjy/+KOAP2snz0fYHfnwCmlhuT
	 uRCAWvkSOYIjhidI+rSQLIFlfbmMEPkbPUrbpEh1R3QzdnXvIyYuqDf92cuDEx7KzI
	 zyy1HxfsElIOaQAP5xexMHzjRzVstHC7mBvsf1Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/189] sched_ext: idle: Refresh idle masks during idle-to-idle transitions
Date: Wed, 15 Jan 2025 11:36:47 +0100
Message-ID: <20250115103610.884320775@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit a2a3374c47c428c0edb0bbc693638d4783f81e31 ]

With the consolidation of put_prev_task/set_next_task(), see
commit 436f3eed5c69 ("sched: Combine the last put_prev_task() and the
first set_next_task()"), we are now skipping the transition between
these two functions when the previous and the next tasks are the same.

As a result, the scx idle state of a CPU is updated only when
transitioning to or from the idle thread. While this is generally
correct, it can lead to uneven and inefficient core utilization in
certain scenarios [1].

A typical scenario involves proactive wake-ups: scx_bpf_pick_idle_cpu()
selects and marks an idle CPU as busy, followed by a wake-up via
scx_bpf_kick_cpu(), without dispatching any tasks. In this case, the CPU
continues running the idle thread, returns to idle, but remains marked
as busy, preventing it from being selected again as an idle CPU (until a
task eventually runs on it and releases the CPU).

For example, running a workload that uses 20% of each CPU, combined with
an scx scheduler using proactive wake-ups, results in the following core
utilization:

 CPU 0: 25.7%
 CPU 1: 29.3%
 CPU 2: 26.5%
 CPU 3: 25.5%
 CPU 4:  0.0%
 CPU 5: 25.5%
 CPU 6:  0.0%
 CPU 7: 10.5%

To address this, refresh the idle state also in pick_task_idle(), during
idle-to-idle transitions, but only trigger ops.update_idle() on actual
state changes to prevent unnecessary updates to the scx scheduler and
maintain balanced state transitions.

With this change in place, the core utilization in the previous example
becomes the following:

 CPU 0: 18.8%
 CPU 1: 19.4%
 CPU 2: 18.0%
 CPU 3: 18.7%
 CPU 4: 19.3%
 CPU 5: 18.9%
 CPU 6: 18.7%
 CPU 7: 19.3%

[1] https://github.com/sched-ext/scx/pull/1139

Fixes: 7c65ae81ea86 ("sched_ext: Don't call put_prev_task_scx() before picking the next task")
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c  | 61 ++++++++++++++++++++++++++++++++++++++-------
 kernel/sched/ext.h  |  8 +++---
 kernel/sched/idle.c |  5 ++--
 3 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index f3ca1a88375c..f928a67a07d2 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3240,16 +3240,8 @@ static void reset_idle_masks(void)
 	cpumask_copy(idle_masks.smt, cpu_online_mask);
 }
 
-void __scx_update_idle(struct rq *rq, bool idle)
+static void update_builtin_idle(int cpu, bool idle)
 {
-	int cpu = cpu_of(rq);
-
-	if (SCX_HAS_OP(update_idle) && !scx_rq_bypassing(rq)) {
-		SCX_CALL_OP(SCX_KF_REST, update_idle, cpu_of(rq), idle);
-		if (!static_branch_unlikely(&scx_builtin_idle_enabled))
-			return;
-	}
-
 	if (idle)
 		cpumask_set_cpu(cpu, idle_masks.cpu);
 	else
@@ -3276,6 +3268,57 @@ void __scx_update_idle(struct rq *rq, bool idle)
 #endif
 }
 
+/*
+ * Update the idle state of a CPU to @idle.
+ *
+ * If @do_notify is true, ops.update_idle() is invoked to notify the scx
+ * scheduler of an actual idle state transition (idle to busy or vice
+ * versa). If @do_notify is false, only the idle state in the idle masks is
+ * refreshed without invoking ops.update_idle().
+ *
+ * This distinction is necessary, because an idle CPU can be "reserved" and
+ * awakened via scx_bpf_pick_idle_cpu() + scx_bpf_kick_cpu(), marking it as
+ * busy even if no tasks are dispatched. In this case, the CPU may return
+ * to idle without a true state transition. Refreshing the idle masks
+ * without invoking ops.update_idle() ensures accurate idle state tracking
+ * while avoiding unnecessary updates and maintaining balanced state
+ * transitions.
+ */
+void __scx_update_idle(struct rq *rq, bool idle, bool do_notify)
+{
+	int cpu = cpu_of(rq);
+
+	lockdep_assert_rq_held(rq);
+
+	/*
+	 * Trigger ops.update_idle() only when transitioning from a task to
+	 * the idle thread and vice versa.
+	 *
+	 * Idle transitions are indicated by do_notify being set to true,
+	 * managed by put_prev_task_idle()/set_next_task_idle().
+	 */
+	if (SCX_HAS_OP(update_idle) && do_notify && !scx_rq_bypassing(rq))
+		SCX_CALL_OP(SCX_KF_REST, update_idle, cpu_of(rq), idle);
+
+	/*
+	 * Update the idle masks:
+	 * - for real idle transitions (do_notify == true)
+	 * - for idle-to-idle transitions (indicated by the previous task
+	 *   being the idle thread, managed by pick_task_idle())
+	 *
+	 * Skip updating idle masks if the previous task is not the idle
+	 * thread, since set_next_task_idle() has already handled it when
+	 * transitioning from a task to the idle thread (calling this
+	 * function with do_notify == true).
+	 *
+	 * In this way we can avoid updating the idle masks twice,
+	 * unnecessarily.
+	 */
+	if (static_branch_likely(&scx_builtin_idle_enabled))
+		if (do_notify || is_idle_task(rq->curr))
+			update_builtin_idle(cpu, idle);
+}
+
 static void handle_hotplug(struct rq *rq, bool online)
 {
 	int cpu = cpu_of(rq);
diff --git a/kernel/sched/ext.h b/kernel/sched/ext.h
index b1675bb59fc4..4d022d17ac7d 100644
--- a/kernel/sched/ext.h
+++ b/kernel/sched/ext.h
@@ -57,15 +57,15 @@ static inline void init_sched_ext_class(void) {}
 #endif	/* CONFIG_SCHED_CLASS_EXT */
 
 #if defined(CONFIG_SCHED_CLASS_EXT) && defined(CONFIG_SMP)
-void __scx_update_idle(struct rq *rq, bool idle);
+void __scx_update_idle(struct rq *rq, bool idle, bool do_notify);
 
-static inline void scx_update_idle(struct rq *rq, bool idle)
+static inline void scx_update_idle(struct rq *rq, bool idle, bool do_notify)
 {
 	if (scx_enabled())
-		__scx_update_idle(rq, idle);
+		__scx_update_idle(rq, idle, do_notify);
 }
 #else
-static inline void scx_update_idle(struct rq *rq, bool idle) {}
+static inline void scx_update_idle(struct rq *rq, bool idle, bool do_notify) {}
 #endif
 
 #ifdef CONFIG_CGROUP_SCHED
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index d2f096bb274c..53bb9193c537 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -453,19 +453,20 @@ static void wakeup_preempt_idle(struct rq *rq, struct task_struct *p, int flags)
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev, struct task_struct *next)
 {
 	dl_server_update_idle_time(rq, prev);
-	scx_update_idle(rq, false);
+	scx_update_idle(rq, false, true);
 }
 
 static void set_next_task_idle(struct rq *rq, struct task_struct *next, bool first)
 {
 	update_idle_core(rq);
-	scx_update_idle(rq, true);
+	scx_update_idle(rq, true, true);
 	schedstat_inc(rq->sched_goidle);
 	next->se.exec_start = rq_clock_task(rq);
 }
 
 struct task_struct *pick_task_idle(struct rq *rq)
 {
+	scx_update_idle(rq, true, false);
 	return rq->idle;
 }
 
-- 
2.39.5



