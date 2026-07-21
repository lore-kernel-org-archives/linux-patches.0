Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DA1367B92;
	Tue, 21 Jul 2026 21:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670898; cv=none; b=RZJlsdxFc5Sgkw8IV1paHJTIjhn1l9VEKNvP7kEtT638ZUPLg0YX3YhUpsBkh2bSa0Z0y7MTR7sBg2DI2QCFqf2IB5qMJvS//3oImRAqVePVAPcHdnhpE6sbyvUT/VXY3L0zE1HGjrPIPiXj/B/FT4NGkNQndH3OrhbJCoXC7hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670898; c=relaxed/simple;
	bh=KIKHLDzf+TvqC5rYYFfrNfhVMaxniqLOEjMsaHv9COw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCRI7r1ewauA4baUdNMpmL8faD8TmdssLOH6XD+a9mGKjhatjEP3SCuwfDzGIXtu0hQQTHTQ4RciItWj2E2+0MsISWuxnQrs1sJqLscKWhdsqyKyyCxwjc6VDEXwJNKFGzbsZo53yOpZahkNmU5BtPd65n/KxurgXV4m9ZEpQh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qKjfvWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qKjfvWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3833C1F000E9;
	Tue, 21 Jul 2026 21:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670897;
	bh=iipHJsbnOQDrOfj2ypQB4HGwIbSSbkUmXwDslKr1XJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2qKjfvWiRFMFMgI9sJc5xjeE6DztkBJVIQS3PXnUf+4RMDG7/C+7SWPupoeQYPjzA
	 SJVexnHIqYafL69S8SlSgRwbTUMgtXaplcrj7o9+s0lg+9uf3VRUQc5KWYqVXkhFwQ
	 HnZ+6RStHeD2vA/ujqreDiUJ+TUOBbTWWnnA9X+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/843] perf/core: Detach event groups during remove_on_exec
Date: Tue, 21 Jul 2026 17:14:38 +0200
Message-ID: <20260721152406.948172562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taeyang Lee <0wn@theori.io>

[ Upstream commit 037a3c43edfb597665dd34457cd22b14692f2ba3 ]

perf_event_remove_on_exec() removes events by calling
perf_event_exit_event(). For top-level events, this removes the event from
the context without DETACH_GROUP.

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
event. This preserves the existing task-exit behavior, while ensuring
surviving siblings are ungrouped before the removed event leaves the context.

Fixes: 2e498d0a74e5 ("perf: Add support for event removal on exec")
Signed-off-by: Taeyang Lee <0wn@theori.io>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/ai65GgZcC0LAlWLG@Taeyangs-MacBook-Pro.local
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 156221bd56615c..9b01cfeb3a0663 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4422,7 +4422,8 @@ static void perf_event_enable_on_exec(int ctxn)
 
 static void perf_remove_from_owner(struct perf_event *event);
 static void perf_event_exit_event(struct perf_event *event,
-				  struct perf_event_context *ctx);
+				  struct perf_event_context *ctx,
+				  unsigned long detach_flags);
 
 /*
  * Removes all events from the current task that have been marked
@@ -4454,7 +4455,7 @@ static void perf_event_remove_on_exec(int ctxn)
 
 		modified = true;
 
-		perf_event_exit_event(event, ctx);
+		perf_event_exit_event(event, ctx, DETACH_GROUP);
 	}
 
 	raw_spin_lock_irqsave(&ctx->lock, flags);
@@ -13024,10 +13025,11 @@ static void sync_child_event(struct perf_event *child_event)
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
@@ -13042,7 +13044,7 @@ perf_event_exit_event(struct perf_event *event, struct perf_event_context *ctx)
 		 * Do destroy all inherited groups, we don't care about those
 		 * and being thorough is better.
 		 */
-		detach_flags = DETACH_GROUP | DETACH_CHILD;
+		detach_flags |= DETACH_GROUP | DETACH_CHILD;
 		mutex_lock(&parent_event->child_mutex);
 	}
 
@@ -13127,7 +13129,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	perf_event_task(child, child_ctx, 0);
 
 	list_for_each_entry_safe(child_event, next, &child_ctx->event_list, event_entry)
-		perf_event_exit_event(child_event, child_ctx);
+		perf_event_exit_event(child_event, child_ctx, 0);
 
 	mutex_unlock(&child_ctx->mutex);
 
-- 
2.53.0



