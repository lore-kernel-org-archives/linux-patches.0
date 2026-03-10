Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8D437B413;
	Tue, 10 Mar 2026 11:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141918; cv=none; b=k2d8fRriAxfi7Vqtg/13c73EPl0pF4jvmFn+zj6O3OWews9u7NGmDiyxcog7gf6rDyxIhY1sQRGF0YiLeAoev6M1GgeMzFkVDVxfGkQz8idpTDrnh021Ma5QI1rwifavoHtlDTq18tZfwg+q/arS5maQbABIBE40jg+cXRZX2Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141918; c=relaxed/simple;
	bh=0deO4SoHbw4VPNECkueHMbGi4skY6KoTMMvbykUh4UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpC1KTXoHAXH8XLuquHWN4JTrmjQ5s4IdYZeoOkx05hVX8uR/UjjmMYj0HU7Y0WpPFQYl03rvyliixPG43VB0Escgt2rBL5DZyDMKq3O+N6bD59pGOu70ld9VmRZcPoXrJbIAkYk0mYyozHJZSavD5hl98mepOiOiHP7BdZv4hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8APZ71X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8APZ71X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA94DC19423;
	Tue, 10 Mar 2026 11:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141918;
	bh=0deO4SoHbw4VPNECkueHMbGi4skY6KoTMMvbykUh4UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8APZ71XoByLUyL4DUxswFHtc560/MlO/TXF4LgRhy51WRDOF/XVPsmPWTB34goQo
	 Xc0tLSiBdqcpq509CKlk//b6boyOXF2QWhWDUF8GHu5ZKji0xldfsw7lJ1LIPi3hlb
	 LT55Arpen5IOntOAl7nx+BLxVl9celov4b5RBM2xSWjdl4mp7PVXGyKF8Cj7b/JKCN
	 ypsgRwl6oCoVBqmSeoo6XYOxQYcJukKVNktP+TVzEGBi8qS2OKQJXLMn7zSGq0uedX
	 6N7/YDRCHbJCjJ06j698/Sy++C2uBORQonlZgdcDBLe05tOqCMMghnLEC1AS5Ob6cP
	 UlAqAnWJ+s1Cg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Simond Hu <cmdhh1767@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 042/314] perf: Fix __perf_event_overflow() vs perf_remove_from_context() race
Date: Tue, 10 Mar 2026 07:15:01 -0400
Message-ID: <977a53abf375d3352da7d70166d7340e5b298f41.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit c9bc1753b3cc41d0e01fbca7f035258b5f4db0ae ]

Make sure that __perf_event_overflow() runs with IRQs disabled for all
possible callchains. Specifically the software events can end up running
it with only preemption disabled.

This opens up a race vs perf_event_exit_event() and friends that will go
and free various things the overflow path expects to be present, like
the BPF program.

Fixes: 592903cdcbf6 ("perf_counter: add an event_list")
Reported-by: Simond Hu <cmdhh1767@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Simond Hu <cmdhh1767@gmail.com>
Link: https://patch.msgid.link/20260224122909.GV1395416@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0255795191cc8..b7e73ac3e512f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10427,6 +10427,13 @@ int perf_event_overflow(struct perf_event *event,
 			struct perf_sample_data *data,
 			struct pt_regs *regs)
 {
+	/*
+	 * Entry point from hardware PMI, interrupts should be disabled here.
+	 * This serializes us against perf_event_remove_from_context() in
+	 * things like perf_event_release_kernel().
+	 */
+	lockdep_assert_irqs_disabled();
+
 	return __perf_event_overflow(event, 1, data, regs);
 }
 
@@ -10503,6 +10510,19 @@ static void perf_swevent_event(struct perf_event *event, u64 nr,
 {
 	struct hw_perf_event *hwc = &event->hw;
 
+	/*
+	 * This is:
+	 *   - software		preempt
+	 *   - tracepoint	preempt
+	 *   -   tp_target_task	irq (ctx->lock)
+	 *   - uprobes		preempt/irq
+	 *   - kprobes		preempt/irq
+	 *   - hw_breakpoint	irq
+	 *
+	 * Any of these are sufficient to hold off RCU and thus ensure @event
+	 * exists.
+	 */
+	lockdep_assert_preemption_disabled();
 	local64_add(nr, &event->count);
 
 	if (!regs)
@@ -10511,6 +10531,16 @@ static void perf_swevent_event(struct perf_event *event, u64 nr,
 	if (!is_sampling_event(event))
 		return;
 
+	/*
+	 * Serialize against event_function_call() IPIs like normal overflow
+	 * event handling. Specifically, must not allow
+	 * perf_event_release_kernel() -> perf_remove_from_context() to make
+	 * progress and 'release' the event from under us.
+	 */
+	guard(irqsave)();
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return;
+
 	if ((event->attr.sample_type & PERF_SAMPLE_PERIOD) && !event->attr.freq) {
 		data->period = nr;
 		return perf_swevent_overflow(event, 1, data, regs);
@@ -11009,6 +11039,11 @@ void perf_tp_event(u16 event_type, u64 count, void *record, int entry_size,
 	struct perf_sample_data data;
 	struct perf_event *event;
 
+	/*
+	 * Per being a tracepoint, this runs with preemption disabled.
+	 */
+	lockdep_assert_preemption_disabled();
+
 	struct perf_raw_record raw = {
 		.frag = {
 			.size = entry_size,
@@ -11341,6 +11376,11 @@ void perf_bp_event(struct perf_event *bp, void *data)
 	struct perf_sample_data sample;
 	struct pt_regs *regs = data;
 
+	/*
+	 * Exception context, will have interrupts disabled.
+	 */
+	lockdep_assert_irqs_disabled();
+
 	perf_sample_data_init(&sample, bp->attr.bp_addr, 0);
 
 	if (!bp->hw.state && !perf_exclude_event(bp, regs))
@@ -11805,7 +11845,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 
 	if (regs && !perf_exclude_event(event, regs)) {
 		if (!(event->attr.exclude_idle && is_idle_task(current)))
-			if (__perf_event_overflow(event, 1, &data, regs))
+			if (perf_event_overflow(event, &data, regs))
 				ret = HRTIMER_NORESTART;
 	}
 
-- 
2.51.0

