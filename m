Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C775A79B;
	Thu, 16 Jul 2026 14:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210431; cv=none; b=KGGzaTLQ58Revg3fHFzpp/SOUuwbXN7kxozp9Zw0G4ti6I4KaJkqTZD07a8ArqP2eVrhVvDIksvhscfO0+/eD394Oja2dMd1w5hLTv0YuExM+CWXGF/9je1txH3C2fTEXguM2l5wl3ST52Jqt3tHWDRGVZ/U3F35jEIANSB+Fg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210431; c=relaxed/simple;
	bh=IKKrz+bPLuMTEPjNUGeNKstGUwJoGtGjJR3P64RW00A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/iDlIkRVdiJ9g7CKRHYt1zzOmGlSfhjmQZ7apv5Mev983KaGbxHIJ5AxS5VjIpLsTuOTxdHxij70X+3dG6GmvpbOrczdFKmXCL5f5RILlU7OtSqAVctpdlQad0wO9AuviRrOL6BgTO9W9UIgasyAlrRqRvzuu8A33cDgIrHHKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUrWaF+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUrWaF+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D4D1F000E9;
	Thu, 16 Jul 2026 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210429;
	bh=/KlmWl69WJcHg1QgZgTSUrqsrGpOw+9xNlCRz4pvp/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUrWaF+sz0IpOM0gLjjIbH3b7DSM57+Jv/lTJbx/efH/0Qf4tEiGdY6v5STsULjs6
	 tk06+d6q+nZpStubH7KSK3dyNhqr77KjrROSp8kTNRJs5X9lhSm9lkm7brnTm8+ZJ5
	 BDg3Cv9XN1V0Nxh3j9a0sHmAnz5HyWxa4seI6WaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 042/480] perf/core: Detach event groups during remove_on_exec
Date: Thu, 16 Jul 2026 15:26:29 +0200
Message-ID: <20260716133045.614100734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Taeyang Lee <0wn@theori.io>

[ Upstream commit 037a3c43edfb597665dd34457cd22b14692f2ba3 ]

perf_event_remove_on_exec() removes events by calling
perf_event_exit_event(). For top-level events, this removes the event from
the context with DETACH_EXIT only.

This can leave inconsistent group state when a removed event is a group
leader and the group contains siblings without remove_on_exec. If the group
was active, the surviving siblings can remain active and attached to the
removed leader's sibling list, but are no longer represented by a valid
group leader on the PMU context active lists.

A later close of the removed leader uses DETACH_GROUP and can promote the
still-active siblings from this stale group state. The next schedule-in can
then add an already-linked active_list entry again, corrupting the PMU
context active list.

With DEBUG_LIST enabled, this is caught as a list_add double-add in
merge_sched_in().

Fix this by detaching group relationships when remove_on_exec removes an
event. This preserves the existing task-exit and revoke behavior, while
ensuring surviving siblings are ungrouped before the removed event leaves
the context.

Fixes: 2e498d0a74e5 ("perf: Add support for event removal on exec")
Signed-off-by: Taeyang Lee <0wn@theori.io>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/ai65GgZcC0LAlWLG@Taeyangs-MacBook-Pro.local
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6b6fea8d33e044..449550b3bb286a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4586,7 +4586,7 @@ static void perf_remove_from_owner(struct perf_event *event);
 static void perf_event_exit_event(struct perf_event *event,
 				  struct perf_event_context *ctx,
 				  struct task_struct *task,
-				  bool revoke);
+				  unsigned long detach_flags);
 
 /*
  * Removes all events from the current task that have been marked
@@ -4613,7 +4613,7 @@ static void perf_event_remove_on_exec(struct perf_event_context *ctx)
 
 		modified = true;
 
-		perf_event_exit_event(event, ctx, ctx->task, false);
+		perf_event_exit_event(event, ctx, ctx->task, DETACH_GROUP);
 	}
 
 	raw_spin_lock_irqsave(&ctx->lock, flags);
@@ -12511,7 +12511,7 @@ static void __pmu_detach_event(struct pmu *pmu, struct perf_event *event,
 	/*
 	 * De-schedule the event and mark it REVOKED.
 	 */
-	perf_event_exit_event(event, ctx, ctx->task, true);
+	perf_event_exit_event(event, ctx, ctx->task, DETACH_REVOKE);
 
 	/*
 	 * All _free_event() bits that rely on event->pmu:
@@ -14095,12 +14095,13 @@ static void
 perf_event_exit_event(struct perf_event *event,
 		      struct perf_event_context *ctx,
 		      struct task_struct *task,
-		      bool revoke)
+		      unsigned long detach_flags)
 {
 	struct perf_event *parent_event = event->parent;
-	unsigned long detach_flags = DETACH_EXIT;
 	unsigned int attach_state;
 
+	detach_flags |= DETACH_EXIT;
+
 	if (parent_event) {
 		/*
 		 * Do not destroy the 'original' grouping; because of the
@@ -14123,8 +14124,8 @@ perf_event_exit_event(struct perf_event *event,
 			sync_child_event(event, task);
 	}
 
-	if (revoke)
-		detach_flags |= DETACH_GROUP | DETACH_REVOKE;
+	if (detach_flags & DETACH_REVOKE)
+		detach_flags |= DETACH_GROUP;
 
 	perf_remove_from_context(event, detach_flags);
 	/*
@@ -14212,7 +14213,7 @@ static void perf_event_exit_task_context(struct task_struct *task, bool exit)
 		perf_event_task(task, ctx, 0);
 
 	list_for_each_entry_safe(child_event, next, &ctx->event_list, event_entry)
-		perf_event_exit_event(child_event, ctx, exit ? task : NULL, false);
+		perf_event_exit_event(child_event, ctx, exit ? task : NULL, 0);
 
 	mutex_unlock(&ctx->mutex);
 
-- 
2.53.0



