Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC874471438;
	Tue, 21 Jul 2026 20:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664803; cv=none; b=L/crg9388dVS+G6UN+mANjItd+gZ5TAorkdycyJsXM3c6DGvO2qpcChxiQaSG/zJ6fEVvt96LHbM3f+HKmvYugA1vemUb6YNJfbUGW+6u6E30OKeX3y2irxH7/1A31ljHTsbfNm6U6guVekD/7nvSsh4dgKaPAy8v9wpkd3n6q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664803; c=relaxed/simple;
	bh=Kz0GRaN7ouFx9gfp3a78MEXPbsQXEyxOSmGT1WVwmJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0gZvZZSWoLWLCkMcU4xfyfkFDjUmGuR27svd0u2YOB34i8BDpcBkuNCpMJgcOYne0RzWZZGQQ+S7hn4cPL1sGDw+XQU8iukaf03Ez4dtiI8Se4F7cJo3rzrE3hScDC4x2e8cR/c7w11haiYdcnaPou0AC2V8drEsWLAKvCIbhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhsV6WuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhsV6WuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D78B1F00A3A;
	Tue, 21 Jul 2026 20:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664801;
	bh=N00WsY59ij/WmPRSY572fsCXLh3w5XIw06lfJX/pwbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhsV6WuVffxvkzm4Obv8ZG6wxJtP7O/8OL0v2Ff1FsNgZgRbtvUjEWEFrtKnXnsoW
	 wEabOMxqWEPC9ea6bXchUcY7T4G887J0hv6+tvYZbIcq+gpiZ9k9tlBp6HzQFaP8Qs
	 7kK3eQHeMxhPHrsUzQeaNwTwRLPWq49yRqTzVJUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0064/1266] perf/core: Detach event groups during remove_on_exec
Date: Tue, 21 Jul 2026 17:08:21 +0200
Message-ID: <20260721152443.235079947@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/events/core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 73a86db06cc9b1..d45bce2acdbc75 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4449,7 +4449,8 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 
 static void perf_remove_from_owner(struct perf_event *event);
 static void perf_event_exit_event(struct perf_event *event,
-				  struct perf_event_context *ctx);
+				  struct perf_event_context *ctx,
+				  unsigned long detach_flags);
 
 /*
  * Removes all events from the current task that have been marked
@@ -4476,7 +4477,7 @@ static void perf_event_remove_on_exec(struct perf_event_context *ctx)
 
 		modified = true;
 
-		perf_event_exit_event(event, ctx);
+		perf_event_exit_event(event, ctx, DETACH_GROUP);
 	}
 
 	raw_spin_lock_irqsave(&ctx->lock, flags);
@@ -13230,10 +13231,11 @@ static void sync_child_event(struct perf_event *child_event)
 }
 
 static void
-perf_event_exit_event(struct perf_event *event, struct perf_event_context *ctx)
+perf_event_exit_event(struct perf_event *event,
+		      struct perf_event_context *ctx,
+		      unsigned long detach_flags)
 {
 	struct perf_event *parent_event = event->parent;
-	unsigned long detach_flags = 0;
 
 	if (parent_event) {
 		/*
@@ -13248,7 +13250,7 @@ perf_event_exit_event(struct perf_event *event, struct perf_event_context *ctx)
 		 * Do destroy all inherited groups, we don't care about those
 		 * and being thorough is better.
 		 */
-		detach_flags = DETACH_GROUP | DETACH_CHILD;
+		detach_flags |= DETACH_GROUP | DETACH_CHILD;
 		mutex_lock(&parent_event->child_mutex);
 	}
 
@@ -13328,7 +13330,7 @@ static void perf_event_exit_task_context(struct task_struct *child)
 	perf_event_task(child, child_ctx, 0);
 
 	list_for_each_entry_safe(child_event, next, &child_ctx->event_list, event_entry)
-		perf_event_exit_event(child_event, child_ctx);
+		perf_event_exit_event(child_event, child_ctx, 0);
 
 	mutex_unlock(&child_ctx->mutex);
 
-- 
2.53.0



