Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E4A26A0FF;
	Tue,  8 Apr 2025 12:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117103; cv=none; b=Q1eZxFTcJAHt1SMq1LQpgr/1qMfkXQbd7bcY5Ac8+YOL9dNks5bLbFfglgue5hJu8KL8yBG39YkqPM+4eFlzqTa20bKJrv8P2ndRXrrngOuvyIzKRW8PiQhy3GNJ+FeEajJmiQ8hkNPhPftTYRebgUPc3cby7/kOWxLK2D34meU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117103; c=relaxed/simple;
	bh=EzhjkN8k6SBVS9njw0bb32spitwfDVbF5LaqhTdatfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLcKkohyIGx/1jOKnDdVmWDxwZRi4s4jVQcAgsjmEGCGDNR1Nr0g1HTPUEd3c+R6Js2MKxpjVthltiMh0yUbULYAXuld/pUSJXeABbEAoRzAYTfe8InMkC2o9hqe1W8MS1xKzOQ6Txo0qHxmc12s1C4QrkN0ENpLeSLPNL/t2uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXXIQWTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXXIQWTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1EFC4CEE5;
	Tue,  8 Apr 2025 12:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117103;
	bh=EzhjkN8k6SBVS9njw0bb32spitwfDVbF5LaqhTdatfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXXIQWTt36EP0kXH6BGpqMnCPZbgNsxIGDCjvJn5yTPFKf+NLJx1ANfPw5bMQ/NOE
	 PKJXxRiqo8uSoddq1Hy4vFcYpMlTDoUk17VlGCvVLV51sQPxpc1LpJeAk1P5OOYR90
	 9H9x8mNz+uL1+I3f6LSHriufZUGbc2l23+cNYeHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Leo Yan <leo.yan@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 348/423] perf/core: Fix child_total_time_enabled accounting bug at task exit
Date: Tue,  8 Apr 2025 12:51:14 +0200
Message-ID: <20250408104853.947712477@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit a3c3c66670cee11eb13aa43905904bf29cb92d32 ]

The perf events code fails to account for total_time_enabled of
inactive events.

Here is a failure case for accounting total_time_enabled for
CPU PMU events:

  sudo ./perf stat -vvv -e armv8_pmuv3_0/event=0x08/ -e armv8_pmuv3_1/event=0x08/ -- stress-ng --pthread=2 -t 2s
  ...

  armv8_pmuv3_0/event=0x08/: 1138698008 2289429840 2174835740
  armv8_pmuv3_1/event=0x08/: 1826791390 1950025700 847648440
                             `          `          `
                             `          `          > total_time_running with child
                             `          > total_time_enabled with child
                             > count with child

  Performance counter stats for 'stress-ng --pthread=2 -t 2s':

       1,138,698,008      armv8_pmuv3_0/event=0x08/                                               (94.99%)
       1,826,791,390      armv8_pmuv3_1/event=0x08/                                               (43.47%)

The two events above are opened on two different CPU PMUs, for example,
each event is opened for a cluster in an Arm big.LITTLE system, they
will never run on the same CPU.  In theory, the total enabled time should
be same for both events, as two events are opened and closed together.

As the result show, the two events' total enabled time including
child event is different (2289429840 vs 1950025700).

This is because child events are not accounted properly
if a event is INACTIVE state when the task exits:

  perf_event_exit_event()
   `> perf_remove_from_context()
     `> __perf_remove_from_context()
       `> perf_child_detach()   -> Accumulate child_total_time_enabled
         `> list_del_event()    -> Update child event's time

The problem is the time accumulation happens prior to child event's
time updating. Thus, it misses to account the last period's time when
the event exits.

The perf core layer follows the rule that timekeeping is tied to state
change. To address the issue, make __perf_remove_from_context()
handle the task exit case by passing 'DETACH_EXIT' to it and
invoke perf_event_state() for state alongside with accounting the time.

Then, perf_child_detach() populates the time into the parent's time metrics.

After this patch, the bug is fixed:

  sudo ./perf stat -vvv -e armv8_pmuv3_0/event=0x08/ -e armv8_pmuv3_1/event=0x08/ -- stress-ng --pthread=2 -t 10s
  ...
  armv8_pmuv3_0/event=0x08/: 15396770398 32157963940 21898169000
  armv8_pmuv3_1/event=0x08/: 22428964974 32157963940 10259794940

   Performance counter stats for 'stress-ng --pthread=2 -t 10s':

      15,396,770,398      armv8_pmuv3_0/event=0x08/                                               (68.10%)
      22,428,964,974      armv8_pmuv3_1/event=0x08/                                               (31.90%)

[ mingo: Clarified the changelog. ]

Fixes: ef54c1a476aef ("perf: Rework perf_event_exit_event()")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Leo Yan <leo.yan@arm.com>
Link: https://lore.kernel.org/r/20250326082003.1630986-1-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index cf2ec0a1582fd..b5ccf52bb71ba 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2407,6 +2407,7 @@ ctx_time_update_event(struct perf_event_context *ctx, struct perf_event *event)
 #define DETACH_GROUP	0x01UL
 #define DETACH_CHILD	0x02UL
 #define DETACH_DEAD	0x04UL
+#define DETACH_EXIT	0x08UL
 
 /*
  * Cross CPU call to remove a performance event
@@ -2421,6 +2422,7 @@ __perf_remove_from_context(struct perf_event *event,
 			   void *info)
 {
 	struct perf_event_pmu_context *pmu_ctx = event->pmu_ctx;
+	enum perf_event_state state = PERF_EVENT_STATE_OFF;
 	unsigned long flags = (unsigned long)info;
 
 	ctx_time_update(cpuctx, ctx);
@@ -2429,16 +2431,19 @@ __perf_remove_from_context(struct perf_event *event,
 	 * Ensure event_sched_out() switches to OFF, at the very least
 	 * this avoids raising perf_pending_task() at this time.
 	 */
-	if (flags & DETACH_DEAD)
+	if (flags & DETACH_EXIT)
+		state = PERF_EVENT_STATE_EXIT;
+	if (flags & DETACH_DEAD) {
 		event->pending_disable = 1;
+		state = PERF_EVENT_STATE_DEAD;
+	}
 	event_sched_out(event, ctx);
+	perf_event_set_state(event, min(event->state, state));
 	if (flags & DETACH_GROUP)
 		perf_group_detach(event);
 	if (flags & DETACH_CHILD)
 		perf_child_detach(event);
 	list_del_event(event, ctx);
-	if (flags & DETACH_DEAD)
-		event->state = PERF_EVENT_STATE_DEAD;
 
 	if (!pmu_ctx->nr_events) {
 		pmu_ctx->rotate_necessary = 0;
@@ -13343,12 +13348,7 @@ perf_event_exit_event(struct perf_event *event, struct perf_event_context *ctx)
 		mutex_lock(&parent_event->child_mutex);
 	}
 
-	perf_remove_from_context(event, detach_flags);
-
-	raw_spin_lock_irq(&ctx->lock);
-	if (event->state > PERF_EVENT_STATE_EXIT)
-		perf_event_set_state(event, PERF_EVENT_STATE_EXIT);
-	raw_spin_unlock_irq(&ctx->lock);
+	perf_remove_from_context(event, detach_flags | DETACH_EXIT);
 
 	/*
 	 * Child events can be freed.
-- 
2.39.5



