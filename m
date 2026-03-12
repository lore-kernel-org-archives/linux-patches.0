Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CAB3909AE;
	Thu, 12 Mar 2026 20:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346478; cv=none; b=kOQ4PD0z1d/IeU2uNfjfgnym2vrmhVz84vIchZo7LK092tXmtRU6kRp7/hzoDXIAuHdPvAH0+Bx27Tl61TEjK414EZzSCnjDzFLjrHdzGVI88cFAPVvwndhAe5JonBbjFisyaxp9r4BDErlKsr0SZYEM2iF/ZJ88sMParUaYHSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346478; c=relaxed/simple;
	bh=sVHQ5gG0MpWaHplGLv8q9mLAy3GSgWSl8k6ixjYhqR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C81Nz5yF8++DKABY6GgPkfVc0AmNl7OXJahWU/iZRzAQMxYWWncwMKbC27vlwOOXlrotA1p1GoSJUkx4JExr3qMhyyXhjD6aMYaeJKGDG07nlvrrvpStzo5Wc4scLuey/tDBk7HqkEIuS6/YFLvDgjAzArDo5ldNg8/l/SrDBcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAyr079A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAyr079A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C173C4CEF7;
	Thu, 12 Mar 2026 20:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346478;
	bh=sVHQ5gG0MpWaHplGLv8q9mLAy3GSgWSl8k6ixjYhqR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAyr079AkrWJXd+0zb3y6YlQQzia0xNP0jEEggSWF6YP+/mJB7juw3hG4HI2Sv/xg
	 AVIyNErkvV84zGcy0BQhOusBkk4QE/PsgLd5BrgIvfacnC/qSCsjmD4VCf9zl2XoFy
	 7Dd2BF0rjHeIBkM+7EJTNenDc8BxNNL/92X3Kfik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simond Hu <cmdhh1767@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/265] perf: Fix __perf_event_overflow() vs perf_remove_from_context() race
Date: Thu, 12 Mar 2026 21:06:47 +0100
Message-ID: <20260312201018.910515579@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 01a87cd9b5cce..814b6536b09d4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10001,6 +10001,13 @@ int perf_event_overflow(struct perf_event *event,
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
 
@@ -10077,6 +10084,19 @@ static void perf_swevent_event(struct perf_event *event, u64 nr,
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
@@ -10085,6 +10105,16 @@ static void perf_swevent_event(struct perf_event *event, u64 nr,
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
@@ -10584,6 +10614,11 @@ void perf_tp_event(u16 event_type, u64 count, void *record, int entry_size,
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
@@ -10906,6 +10941,11 @@ void perf_bp_event(struct perf_event *bp, void *data)
 	struct perf_sample_data sample;
 	struct pt_regs *regs = data;
 
+	/*
+	 * Exception context, will have interrupts disabled.
+	 */
+	lockdep_assert_irqs_disabled();
+
 	perf_sample_data_init(&sample, bp->attr.bp_addr, 0);
 
 	if (!bp->hw.state && !perf_exclude_event(bp, regs))
@@ -11358,7 +11398,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 
 	if (regs && !perf_exclude_event(event, regs)) {
 		if (!(event->attr.exclude_idle && is_idle_task(current)))
-			if (__perf_event_overflow(event, 1, &data, regs))
+			if (perf_event_overflow(event, &data, regs))
 				ret = HRTIMER_NORESTART;
 	}
 
-- 
2.51.0



