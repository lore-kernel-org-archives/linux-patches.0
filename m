Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18B71FBCB2;
	Tue,  8 Apr 2025 11:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110503; cv=none; b=HDXC0BYzYOm7ZnAyIG65ijGQ+bwkK7+La2x2BkUMEgDPRbsGRcDaT7xgfP/yM8inYpWWL7Pkg6avXFi7IpcZV808gSYnWe3txLHy2rVMyYASqUfKahOj/PkHKwgFSxxZpMuRlZ97mSzsONFwgX1pIhEXdL23HOKyh/77blYctzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110503; c=relaxed/simple;
	bh=vdaz0aLwlLZLMkSErmkdnCnp5AuCV4FUDZ6IfJuQgU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttSQLzpOFYke0zgDzenkFxTFjc4I0JTwd2htiUrltu8JtoxLJcMmY+fmqaz2s6O0EiSaWYKvXAPVtPzHfzJxu6dW1NO08SWUzTury59ktzpH94ZdJi9HhYwUFPExqOnydhIo9gE776jSnEGaTRJPI7BRDpomaBNKHPmKvN/dnzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGkNjW7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGkNjW7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F528C4CEE5;
	Tue,  8 Apr 2025 11:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110503;
	bh=vdaz0aLwlLZLMkSErmkdnCnp5AuCV4FUDZ6IfJuQgU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGkNjW7+m+5zRmeVq6+tQorMsO60QAgDy57v6LIL8gChRtw2EAKbero0o1X2yBMsP
	 eLd5rQSJzUoj67d83bt6C8f4Ss0W+mXmAeCqVy+Fwomf0y4l04BFpVci23WZ/kHpRY
	 60wetwP5zPfheC23pvrm7LkxmA3aWIxqnuleTABA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Kleen <ak@linux.intel.com>,
	Alexey Budankov <alexey.budankov@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 048/731] perf/x86/lbr: Fix shorter LBRs call stacks for the system-wide mode
Date: Tue,  8 Apr 2025 12:39:05 +0200
Message-ID: <20250408104915.393358149@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 3cec9fd03543c1e2919f906353e5cba079ae0a7c ]

In the system-wide mode, LBR callstacks are shorter in comparison to
the per-process mode.

LBR MSRs are reset during a context switch in the system-wide mode. For
the LBR call stack, the LBRs should be always saved/restored during a
context switch.

Use the space in task_struct to save/restore the LBR call stack data.

For a system-wide event, it's unnecessagy to update the
lbr_callstack_users for each threads. Add a variable in x86_pmu to
indicate whether the system-wide event is active.

Fixes: 76cb2c617f12 ("perf/x86/intel: Save/restore LBR stack during context switch")
Reported-by: Andi Kleen <ak@linux.intel.com>
Reported-by: Alexey Budankov <alexey.budankov@linux.intel.com>
Debugged-by: Alexey Budankov <alexey.budankov@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250314172700.438923-5-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/lbr.c  | 47 ++++++++++++++++++++++++++++++------
 arch/x86/events/perf_event.h |  1 +
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index dafeee216f3b6..24719adbcd7ea 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -422,11 +422,17 @@ static __always_inline bool lbr_is_reset_in_cstate(void *ctx)
 	return !rdlbr_from(((struct x86_perf_task_context *)ctx)->tos, NULL);
 }
 
+static inline bool has_lbr_callstack_users(void *ctx)
+{
+	return task_context_opt(ctx)->lbr_callstack_users ||
+	       x86_pmu.lbr_callstack_users;
+}
+
 static void __intel_pmu_lbr_restore(void *ctx)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
-	if (task_context_opt(ctx)->lbr_callstack_users == 0 ||
+	if (!has_lbr_callstack_users(ctx) ||
 	    task_context_opt(ctx)->lbr_stack_state == LBR_NONE) {
 		intel_pmu_lbr_reset();
 		return;
@@ -503,7 +509,7 @@ static void __intel_pmu_lbr_save(void *ctx)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
-	if (task_context_opt(ctx)->lbr_callstack_users == 0) {
+	if (!has_lbr_callstack_users(ctx)) {
 		task_context_opt(ctx)->lbr_stack_state = LBR_NONE;
 		return;
 	}
@@ -543,6 +549,7 @@ void intel_pmu_lbr_sched_task(struct perf_event_pmu_context *pmu_ctx,
 			      struct task_struct *task, bool sched_in)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	struct perf_ctx_data *ctx_data;
 	void *task_ctx;
 
 	if (!cpuc->lbr_users)
@@ -553,14 +560,18 @@ void intel_pmu_lbr_sched_task(struct perf_event_pmu_context *pmu_ctx,
 	 * the task was scheduled out, restore the stack. Otherwise flush
 	 * the LBR stack.
 	 */
-	task_ctx = pmu_ctx ? pmu_ctx->task_ctx_data : NULL;
+	rcu_read_lock();
+	ctx_data = rcu_dereference(task->perf_ctx_data);
+	task_ctx = ctx_data ? ctx_data->data : NULL;
 	if (task_ctx) {
 		if (sched_in)
 			__intel_pmu_lbr_restore(task_ctx);
 		else
 			__intel_pmu_lbr_save(task_ctx);
+		rcu_read_unlock();
 		return;
 	}
+	rcu_read_unlock();
 
 	/*
 	 * Since a context switch can flip the address space and LBR entries
@@ -589,9 +600,19 @@ void intel_pmu_lbr_add(struct perf_event *event)
 
 	cpuc->br_sel = event->hw.branch_reg.reg;
 
-	if (branch_user_callstack(cpuc->br_sel) && event->pmu_ctx->task_ctx_data)
-		task_context_opt(event->pmu_ctx->task_ctx_data)->lbr_callstack_users++;
+	if (branch_user_callstack(cpuc->br_sel)) {
+		if (event->attach_state & PERF_ATTACH_TASK) {
+			struct task_struct *task = event->hw.target;
+			struct perf_ctx_data *ctx_data;
 
+			rcu_read_lock();
+			ctx_data = rcu_dereference(task->perf_ctx_data);
+			if (ctx_data)
+				task_context_opt(ctx_data->data)->lbr_callstack_users++;
+			rcu_read_unlock();
+		} else
+			x86_pmu.lbr_callstack_users++;
+	}
 	/*
 	 * Request pmu::sched_task() callback, which will fire inside the
 	 * regular perf event scheduling, so that call will:
@@ -665,9 +686,19 @@ void intel_pmu_lbr_del(struct perf_event *event)
 	if (!x86_pmu.lbr_nr)
 		return;
 
-	if (branch_user_callstack(cpuc->br_sel) &&
-	    event->pmu_ctx->task_ctx_data)
-		task_context_opt(event->pmu_ctx->task_ctx_data)->lbr_callstack_users--;
+	if (branch_user_callstack(cpuc->br_sel)) {
+		if (event->attach_state & PERF_ATTACH_TASK) {
+			struct task_struct *task = event->hw.target;
+			struct perf_ctx_data *ctx_data;
+
+			rcu_read_lock();
+			ctx_data = rcu_dereference(task->perf_ctx_data);
+			if (ctx_data)
+				task_context_opt(ctx_data->data)->lbr_callstack_users--;
+			rcu_read_unlock();
+		} else
+			x86_pmu.lbr_callstack_users--;
+	}
 
 	if (event->hw.flags & PERF_X86_EVENT_LBR_SELECT)
 		cpuc->lbr_select = 0;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index ce7c98364d5b6..b93b526d6834a 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -914,6 +914,7 @@ struct x86_pmu {
 		const int	*lbr_sel_map;	   /* lbr_select mappings */
 		int		*lbr_ctl_map;	   /* LBR_CTL mappings */
 	};
+	u64		lbr_callstack_users;	   /* lbr callstack system wide users */
 	bool		lbr_double_abort;	   /* duplicated lbr aborts */
 	bool		lbr_pt_coexist;		   /* (LBR|BTS) may coexist with PT */
 
-- 
2.39.5



