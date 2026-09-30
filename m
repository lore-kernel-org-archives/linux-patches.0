Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C750E51C041;
	Wed, 30 Sep 2026 18:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793570; cv=none; b=Rx5tVDL+Mqwam9av9hlraOTo1F+8iYL04ue1KKcwD2ynYTw8UPPb7oQpuqJ2KDql03eNRYXxjWL1Mt91yLkRnDDgw4Q7kxWhxaSFHJAfIm+BJ5+LXqzv8BZIi6phRIof48kw6JbeoUzdjjp32mKLXmpiM0A1r3pxzy1Td2x5glQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793570; c=relaxed/simple;
	bh=NYFOlYdL8iOGhF66R1L1XPnTrKtyn+kcV3yUJ8sVnFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZC9IHj9WuQ7l4DkW6U6gXtITQg913U4gfWeGd/Crif8xXHzl0naKDV1CVJCAbBupnRM7bbHg/PTuf4O5bIhvk7FXuTEP+9Ry3FSjjusqrX3SIRFi3217R9pQqfXAKTCf7BtcOQyk7cIVDdG2V+42cOkdxuEKXYrHWNfvga8J64M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZZe+PIc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZZe+PIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0C91F000FF;
	Wed, 30 Sep 2026 18:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793568;
	bh=9R7XPBNkIw11LvvxTwGDlvdogqOFHUDvVJr6NKCF8x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HZZe+PIcfUPa5JZ/2pDPACiYMYfa5E4bhbi6NuznZDM3otatgJh536JFcRgWzoGBx
	 GAVR0k1hBZgEuxrxcGO83uSPtQt03VtOBUyHL92rwCfHFEftWOe/bGAyuyI3LKmmxR
	 RrEuGaGff+/nMy5bDkzTM1bYPxRAh9iAIelDWceo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Yifan Wu <wuyifan50@huawei.com>
Subject: [PATCH 6.18 300/395] perf/core: Run sched_task() for PMUs with only CPU-wide events
Date: Wed, 30 Sep 2026 17:29:22 +0200
Message-ID: <20260930152347.162542337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

commit 3d8d74100954a3b17e5c5e37adfe14e16b1db103 upstream.

perf_pmu_sched_task() returns early when cpuctx->task_ctx is set and
leaves the work to perf_ctx_sched_task_cb(), which only walks
ctx->pmu_ctx_list. A PMU whose events are all CPU-wide is not on that
list, so nothing calls its sched_task(). With

  perf record -b -e cycles -a -- ls

armv8pmu_sched_task() is skipped on every switch to a task that has a
perf context but no event on that PMU, and BRBE records leak across the
task boundary. intel_pmu_lbr_add() calls perf_sched_cb_inc()
unconditionally too, so LBR records leak the same way on x86.

Drop the early return and skip only the CPCs that
perf_ctx_sched_task_cb() handles. That one needs a gate of its own to
make the split exact: it tests cpc->sched_cb_usage, which
perf_sched_cb_inc() sets per CPU for every branch stack user, so a task
with an event for that PMU pinned to another CPU would be handled twice.
On x86 the second __intel_pmu_lbr_restore() finds lbr_stack_state ==
LBR_NONE and calls intel_pmu_lbr_reset(), throwing away the callstack
the first one restored.

cpc->task_epc is set only while a task context is scheduled in, and
there is one epc per PMU on ctx->pmu_ctx_list, so the two gates are
inverses.

For the CPCs perf_pmu_sched_task() picks up, the callback now runs
outside the perf_ctx_disable() and perf_ctx_enable() pair in
perf_event_context_sched_in(). __perf_pmu_sched_task() disables the PMU
around the call itself.

Fixes: bd2756811766 ("perf: Rewrite core context handling")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Yifan Wu <wuyifan50@huawei.com>
Link: https://patch.msgid.link/20260810133540.1947118-3-puranjay@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3655,6 +3655,9 @@ static void perf_ctx_sched_task_cb(struc
 	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
 		cpc = this_cpc(pmu_ctx->pmu);
 
+		if (cpc->task_epc != pmu_ctx)
+			continue;
+
 		if (cpc->sched_cb_usage && pmu_ctx->pmu->sched_task)
 			pmu_ctx->pmu->sched_task(pmu_ctx, task, sched_in);
 	}
@@ -3815,15 +3818,17 @@ static void perf_pmu_sched_task(struct t
 				struct task_struct *next,
 				bool sched_in)
 {
-	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
 	struct perf_cpu_pmu_context *cpc, *cpc2;
 
-	/* cpuctx->task_ctx will be handled in perf_event_context_sched_in/out */
-	if (prev == next || cpuctx->task_ctx)
+	if (prev == next)
 		return;
 
-	list_for_each_entry_safe(cpc, cpc2, this_cpu_ptr(&sched_cb_list), sched_cb_entry)
+	list_for_each_entry_safe(cpc, cpc2, this_cpu_ptr(&sched_cb_list), sched_cb_entry) {
+		if (cpc->task_epc)
+			continue;
+
 		__perf_pmu_sched_task(cpc, sched_in ? next : prev, sched_in);
+	}
 }
 
 static void perf_event_switch(struct task_struct *task,


