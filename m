Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8F0224AEF;
	Tue,  8 Apr 2025 11:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112026; cv=none; b=OZQxYj4CN8HDAIaDOBzWtpsgr5V55lzo4sJq+uEczObpQSfCgT5SZOJM0BiGwbCUlNh6zz6YoLfvKYUp533SagnaDeFvwo+HBIplN3vnBH2VDZ6NwgGVGF6s4UFJsrbWf1qwYd38HpTeMx83uyNgFOK0WHL6ADYIwaMnjD8tj9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112026; c=relaxed/simple;
	bh=XU3DHvpRC0VGoGLkkmhEfImnhMtQMUAET3GzvI/C1Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnQivuBJuR8qbTyTDAQh256evXJPdxCUeLSMTMiCPTWUyMRXt5nh5Hio19VxAERg0Ju1XYiR3c6VpzF3974/RgB+itBSyA30K/7jjTzJRoXOQi5EAMa6X5S3yV4VquOWFEtElm29EX3/Vg34fOBX+5sN1MA7mT9xiT0+0f0Q4p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0LJbwea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0LJbwea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32587C4CEE5;
	Tue,  8 Apr 2025 11:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112026;
	bh=XU3DHvpRC0VGoGLkkmhEfImnhMtQMUAET3GzvI/C1Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0LJbweaa+YJNsgiQH8ezXfo3psiAGNy76cqtQXTL4ww5w5TP0d0sk/6OifZuSOYi
	 umA00HawQBZvVrFaVRFyYyf3Fgayr/2kmDM32oc32Ld4cvk7VmDVQUWj6qNUABNWTy
	 Wapb3qv7605pCAYm2JCpJ43wk41J7CIrwxjdQY+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Leo Yan <leo.yan@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 649/731] perf/core: Fix child_total_time_enabled accounting bug at task exit
Date: Tue,  8 Apr 2025 12:49:06 +0200
Message-ID: <20250408104929.361774222@linuxfoundation.org>
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
index 03c27754aef8b..f6cf17929bb98 100644
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
@@ -13450,12 +13455,7 @@ perf_event_exit_event(struct perf_event *event, struct perf_event_context *ctx)
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



