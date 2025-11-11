Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEBE26E146;
	Tue, 11 Nov 2025 01:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825473; cv=none; b=jIHVKewirq5Or6mnUJfR3SvWqH6s9/QJwI7yChKFAOzDftCZYssM7WsFCQ4u1JRWB9z9vWJEDKWbcUm44Chj1ktS/wuezzxqv29fXjUT9wPqrSZupMDpKCO6M0q8qpVTEIxyGN8PEsUVARcf3VDBY8fN4pK5xn8fZb6VuzStlSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825473; c=relaxed/simple;
	bh=T/QCPGjtNYIWgAHXb7KqTv951RjYi8WmSRBRQCtJZz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDhzQmONx4IvWilsBhgB8kWGHfVk3fclYrXGTx3l+lHatISS9BcfavtCPICB1AXMhdALfMKmw3VxlkkuOl66O9gZvcLXbS+lzmLrO9MBsomgXwvYFhn4H/UlLCRuJmxt08XNLe/9oBj0sAdxFi6ycoRpUVPafJAvzK4q2pmC8tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLB4G2fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLB4G2fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDDFC116B1;
	Tue, 11 Nov 2025 01:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825473;
	bh=T/QCPGjtNYIWgAHXb7KqTv951RjYi8WmSRBRQCtJZz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLB4G2fvH1p9QHkdPMHfGBWN/7AjBdgnhN4UDOt3gjoMHG5t0xC/IoZKNOQg+tpsD
	 ypkTy05MK4ZLvLvxVATygC3HYNmNOvVE9puFG/RSg4Y7WqOpZPLwjPSf24SxW0z4Zt
	 Z/GWwBFb+dXCR/PT3deOGpnWSfCKowFYiJcAMptc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Octavia Togami <octavia.togami@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.17 818/849] perf/core: Fix system hang caused by cpu-clock usage
Date: Tue, 11 Nov 2025 09:46:28 +0900
Message-ID: <20251111004556.202259336@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

commit eb3182ef0405ff2f6668fd3e5ff9883f60ce8801 upstream.

cpu-clock usage by the async-profiler tool can trigger a system hang,
which got bisected back to the following commit by Octavia Togami:

  18dbcbfabfff ("perf: Fix the POLL_HUP delivery breakage") causes this issue

The root cause of the hang is that cpu-clock is a special type of SW
event which relies on hrtimers. The __perf_event_overflow() callback
is invoked from the hrtimer handler for cpu-clock events, and
__perf_event_overflow() tries to call cpu_clock_event_stop()
to stop the event, which calls htimer_cancel() to cancel the hrtimer.

But that's a recursion into the hrtimer code from a hrtimer handler,
which (unsurprisingly) deadlocks.

To fix this bug, use hrtimer_try_to_cancel() instead, and set
the PERF_HES_STOPPED flag, which causes perf_swevent_hrtimer()
to stop the event once it sees the PERF_HES_STOPPED flag.

[ mingo: Fixed the comments and improved the changelog. ]

Closes: https://lore.kernel.org/all/CAHPNGSQpXEopYreir+uDDEbtXTBvBvi8c6fYXJvceqtgTPao3Q@mail.gmail.com/
Fixes: 18dbcbfabfff ("perf: Fix the POLL_HUP delivery breakage")
Reported-by: Octavia Togami <octavia.togami@gmail.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Octavia Togami <octavia.togami@gmail.com>
Cc: stable@vger.kernel.org
Link: https://github.com/lucko/spark/issues/530
Link: https://patch.msgid.link/20251015051828.12809-1-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11757,7 +11757,8 @@ static enum hrtimer_restart perf_swevent
 
 	event = container_of(hrtimer, struct perf_event, hw.hrtimer);
 
-	if (event->state != PERF_EVENT_STATE_ACTIVE)
+	if (event->state != PERF_EVENT_STATE_ACTIVE ||
+	    event->hw.state & PERF_HES_STOPPED)
 		return HRTIMER_NORESTART;
 
 	event->pmu->read(event);
@@ -11803,15 +11804,20 @@ static void perf_swevent_cancel_hrtimer(
 	struct hw_perf_event *hwc = &event->hw;
 
 	/*
-	 * The throttle can be triggered in the hrtimer handler.
-	 * The HRTIMER_NORESTART should be used to stop the timer,
-	 * rather than hrtimer_cancel(). See perf_swevent_hrtimer()
+	 * Careful: this function can be triggered in the hrtimer handler,
+	 * for cpu-clock events, so hrtimer_cancel() would cause a
+	 * deadlock.
+	 *
+	 * So use hrtimer_try_to_cancel() to try to stop the hrtimer,
+	 * and the cpu-clock handler also sets the PERF_HES_STOPPED flag,
+	 * which guarantees that perf_swevent_hrtimer() will stop the
+	 * hrtimer once it sees the PERF_HES_STOPPED flag.
 	 */
 	if (is_sampling_event(event) && (hwc->interrupts != MAX_INTERRUPTS)) {
 		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
 		local64_set(&hwc->period_left, ktime_to_ns(remaining));
 
-		hrtimer_cancel(&hwc->hrtimer);
+		hrtimer_try_to_cancel(&hwc->hrtimer);
 	}
 }
 
@@ -11855,12 +11861,14 @@ static void cpu_clock_event_update(struc
 
 static void cpu_clock_event_start(struct perf_event *event, int flags)
 {
+	event->hw.state = 0;
 	local64_set(&event->hw.prev_count, local_clock());
 	perf_swevent_start_hrtimer(event);
 }
 
 static void cpu_clock_event_stop(struct perf_event *event, int flags)
 {
+	event->hw.state = PERF_HES_STOPPED;
 	perf_swevent_cancel_hrtimer(event);
 	if (flags & PERF_EF_UPDATE)
 		cpu_clock_event_update(event);
@@ -11934,12 +11942,14 @@ static void task_clock_event_update(stru
 
 static void task_clock_event_start(struct perf_event *event, int flags)
 {
+	event->hw.state = 0;
 	local64_set(&event->hw.prev_count, event->ctx->time);
 	perf_swevent_start_hrtimer(event);
 }
 
 static void task_clock_event_stop(struct perf_event *event, int flags)
 {
+	event->hw.state = PERF_HES_STOPPED;
 	perf_swevent_cancel_hrtimer(event);
 	if (flags & PERF_EF_UPDATE)
 		task_clock_event_update(event, event->ctx->time);


