Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5283596F2;
	Tue, 16 Dec 2025 12:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886653; cv=none; b=tBZxCNvplWj+dHYjHMmQZE+snLsilfTk5DGxNs9F3E/eNK99SkMBrxiNO54JAGE/ysoZMmNDZglzvjparE1f+MrMomZEx269IygB9PJtEnVP1bjJ5r5LC95+biaenPKjyIq5xhaEGzgVFfdWKcEKnkNzSGnHlCgZE9LDwSCq85k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886653; c=relaxed/simple;
	bh=AatL3ZTN/lDuPdj4CbcO+FKWt4eKq6P4ZkKflx/F+L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tae/b174f/0CbKY2P/5u44fRUMiV2iDUL1Try4S2td+NgzOewb9FyciqAknIj3y5qaBv3L5CPjAjOqtBv1Jx+WkEURsESEsrQPIpSUKjNjvt9pwc6l4EvELZj73nbBd4CtF5B9+ZVanPPXnfZylf3ed1+eUB/YlaSGSFSmXrkMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlxxNsXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlxxNsXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9DEC4CEF1;
	Tue, 16 Dec 2025 12:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886653;
	bh=AatL3ZTN/lDuPdj4CbcO+FKWt4eKq6P4ZkKflx/F+L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlxxNsXCiW/L5/ba/edQ11fqiSLte5fIeGAMcPiZRjIzO8w2VaPkceWzQSah7UC1e
	 kkBqucK5ukh07yfxaUAkXgUEYpG35uDvQQhxKI3+1cmk7I5JgfJw2UP0+iyKQ2GBjh
	 OGO/LSo5CPPM2lscuTXDh9qHTnWFAL+ER2Teub5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thaumy Cheng <thaumy.love@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 493/507] perf/core: Fix missing read event generation on task exit
Date: Tue, 16 Dec 2025 12:15:34 +0100
Message-ID: <20251216111403.300971684@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Thaumy Cheng <thaumy.love@gmail.com>

[ Upstream commit c418d8b4d7a43a86b82ee39cb52ece3034383530 ]

For events with inherit_stat enabled, a "read" event will be generated
to collect per task event counts on task exit.

The call chain is as follows:

do_exit
  -> perf_event_exit_task
    -> perf_event_exit_task_context
      -> perf_event_exit_event
        -> perf_remove_from_context
          -> perf_child_detach
            -> sync_child_event
              -> perf_event_read_event

However, the child event context detaches the task too early in
perf_event_exit_task_context, which causes sync_child_event to never
generate the read event in this case, since child_event->ctx->task is
always set to TASK_TOMBSTONE. Fix that by moving context lock section
backward to ensure ctx->task is not set to TASK_TOMBSTONE before
generating the read event.

Because perf_event_free_task calls perf_event_exit_task_context with
exit = false to tear down all child events from the context, and the
task never lived, accessing the task PID can lead to a use-after-free.

To fix that, let sync_child_event read task from argument and move the
call to the only place it should be triggered to avoid the effect of
setting ctx->task to TASK_TOMESTONE, and add a task parameter to
perf_event_exit_event to trigger the sync_child_event properly when
needed.

This bug can be reproduced by running "perf record -s" and attaching to
any program that generates perf events in its child tasks. If we check
the result with "perf report -T", the last line of the report will leave
an empty table like "# PID  TID", which is expected to contain the
per-task event counts by design.

Fixes: ef54c1a476ae ("perf: Rework perf_event_exit_event()")
Signed-off-by: Thaumy Cheng <thaumy.love@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-perf-users@vger.kernel.org
Link: https://patch.msgid.link/20251209041600.963586-1-thaumy.love@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 01d080978865f..a9d7ad4301353 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2316,8 +2316,6 @@ static void perf_group_detach(struct perf_event *event)
 	perf_event__header_size(leader);
 }
 
-static void sync_child_event(struct perf_event *child_event);
-
 static void perf_child_detach(struct perf_event *event)
 {
 	struct perf_event *parent_event = event->parent;
@@ -2336,7 +2334,6 @@ static void perf_child_detach(struct perf_event *event)
 	lockdep_assert_held(&parent_event->child_mutex);
 	 */
 
-	sync_child_event(event);
 	list_del_init(&event->child_list);
 }
 
@@ -4587,6 +4584,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 static void perf_remove_from_owner(struct perf_event *event);
 static void perf_event_exit_event(struct perf_event *event,
 				  struct perf_event_context *ctx,
+				  struct task_struct *task,
 				  bool revoke);
 
 /*
@@ -4614,7 +4612,7 @@ static void perf_event_remove_on_exec(struct perf_event_context *ctx)
 
 		modified = true;
 
-		perf_event_exit_event(event, ctx, false);
+		perf_event_exit_event(event, ctx, ctx->task, false);
 	}
 
 	raw_spin_lock_irqsave(&ctx->lock, flags);
@@ -12431,7 +12429,7 @@ static void __pmu_detach_event(struct pmu *pmu, struct perf_event *event,
 	/*
 	 * De-schedule the event and mark it REVOKED.
 	 */
-	perf_event_exit_event(event, ctx, true);
+	perf_event_exit_event(event, ctx, ctx->task, true);
 
 	/*
 	 * All _free_event() bits that rely on event->pmu:
@@ -13988,14 +13986,13 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 }
 EXPORT_SYMBOL_GPL(perf_pmu_migrate_context);
 
-static void sync_child_event(struct perf_event *child_event)
+static void sync_child_event(struct perf_event *child_event,
+			     struct task_struct *task)
 {
 	struct perf_event *parent_event = child_event->parent;
 	u64 child_val;
 
 	if (child_event->attr.inherit_stat) {
-		struct task_struct *task = child_event->ctx->task;
-
 		if (task && task != TASK_TOMBSTONE)
 			perf_event_read_event(child_event, task);
 	}
@@ -14014,7 +14011,9 @@ static void sync_child_event(struct perf_event *child_event)
 
 static void
 perf_event_exit_event(struct perf_event *event,
-		      struct perf_event_context *ctx, bool revoke)
+		      struct perf_event_context *ctx,
+		      struct task_struct *task,
+		      bool revoke)
 {
 	struct perf_event *parent_event = event->parent;
 	unsigned long detach_flags = DETACH_EXIT;
@@ -14037,6 +14036,9 @@ perf_event_exit_event(struct perf_event *event,
 		mutex_lock(&parent_event->child_mutex);
 		/* PERF_ATTACH_ITRACE might be set concurrently */
 		attach_state = READ_ONCE(event->attach_state);
+
+		if (attach_state & PERF_ATTACH_CHILD)
+			sync_child_event(event, task);
 	}
 
 	if (revoke)
@@ -14128,7 +14130,7 @@ static void perf_event_exit_task_context(struct task_struct *task, bool exit)
 		perf_event_task(task, ctx, 0);
 
 	list_for_each_entry_safe(child_event, next, &ctx->event_list, event_entry)
-		perf_event_exit_event(child_event, ctx, false);
+		perf_event_exit_event(child_event, ctx, exit ? task : NULL, false);
 
 	mutex_unlock(&ctx->mutex);
 
-- 
2.51.0



