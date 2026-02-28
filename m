Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F3A338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301731; cv=none; b=U8toEyMCmB3PSH7F47o5ZC8411lrbmcM8+z0FRz6aZcAk1AFe+04TJLASIqAZxFlMMln/QJorCljLRuS/2EnGHqYCDdtJSSJryDO9o373OaZDTr2G2kmDvOKz7Z3HisTAbnV6Wbrm1QnLCWnagnXR1bixwFoFkNerSdPQ66P9cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301731; c=relaxed/simple;
	bh=vHBBfAsD1hiV27AdSeRBxVKWuRHvkHWqzL3i5nBaw0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNYi9C3MN1I+3jbtj9PI5dplRdvuRnW6c8n2pb8/9GGCeS8yrNl/qjYm1/ZP6hqDnQ5Gb9kgRQItyqxRz3C7NL5W9gmvMaMd37X0XiX+xSStg7DqbLvZrd/3uWOGK+dxywWD/jeCpCND8liSNjPvbhWBxuwtTuO5/p3OimAbP8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TsMlNtK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TsMlNtK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BE9C2BC87;
	Sat, 28 Feb 2026 18:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301731;
	bh=vHBBfAsD1hiV27AdSeRBxVKWuRHvkHWqzL3i5nBaw0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TsMlNtK+T/L2f2kskJXao1UuV2NVollPaYWlkaE8x3vwVkQ6pqmwOx2bdVTvhsNF6
	 Kh8YWNb03wQ5Tc1mAkofQkTlJNg6zVhxyQZ0bW06srEls8Z6Sah0F1tdiKEmFvYHtV
	 IIGBmOHfD1JSa+qFHQRfN40IoVLOVyLbMpHzm3sGm8QjifM7WQsn+skX0QLzMG9NZS
	 0P/Ax28phWr1B94QGMEZqngxDPeMu75M0YsxuqzvjHNRgeRHULp+mtO2/zdtGzm0Ou
	 kxgAi87t2nrRaSo0Zb3grJ7TazwoTFf8QOmC6S8UE96cpicViH2fJh7+sZmZDyHpcO
	 cmY7VxtgXAiGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/385] drm/panthor: Fix the group priority rotation logic
Date: Sat, 28 Feb 2026 12:55:52 -0500
Message-ID: <20260228180011.1568201-130-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 55429c51d5db3db24c2ad561944c6a0ca922d476 ]

When rotating group priorities, we want the group with the
highest priority to go back to the end of the queue, and all
other active groups to get their priority bumped, otherwise
some groups will never get a chance to run with the highest
priority. This implies moving the rotation itself to
tick_work(), and only dealing with old group ordering in
tick_ctx_insert_old_group().

v2:
- Add R-b
- Fix the commit message

v3:
- Drop the full_tick argument in tick_ctx_init()
- Collect R-b

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Link: https://patch.msgid.link/20251128094839.3856402-5-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 52 +++++++++++++++----------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 6cfd44a414802..d2386e54a4bc4 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -1940,31 +1940,22 @@ tick_ctx_pick_groups_from_list(const struct panthor_scheduler *sched,
 static void
 tick_ctx_insert_old_group(struct panthor_scheduler *sched,
 			  struct panthor_sched_tick_ctx *ctx,
-			  struct panthor_group *group,
-			  bool full_tick)
+			  struct panthor_group *group)
 {
 	struct panthor_csg_slot *csg_slot = &sched->csg_slots[group->csg_id];
 	struct panthor_group *other_group;
 
-	if (!full_tick) {
-		list_add_tail(&group->run_node, &ctx->old_groups[group->priority]);
-		return;
-	}
-
-	/* Rotate to make sure groups with lower CSG slot
-	 * priorities have a chance to get a higher CSG slot
-	 * priority next time they get picked. This priority
-	 * has an impact on resource request ordering, so it's
-	 * important to make sure we don't let one group starve
-	 * all other groups with the same group priority.
-	 */
+	/* Class groups in descending priority order so we can easily rotate. */
 	list_for_each_entry(other_group,
 			    &ctx->old_groups[csg_slot->group->priority],
 			    run_node) {
 		struct panthor_csg_slot *other_csg_slot = &sched->csg_slots[other_group->csg_id];
 
-		if (other_csg_slot->priority > csg_slot->priority) {
-			list_add_tail(&csg_slot->group->run_node, &other_group->run_node);
+		/* Our group has a higher prio than the one we're testing against,
+		 * place it just before.
+		 */
+		if (csg_slot->priority > other_csg_slot->priority) {
+			list_add_tail(&group->run_node, &other_group->run_node);
 			return;
 		}
 	}
@@ -1974,8 +1965,7 @@ tick_ctx_insert_old_group(struct panthor_scheduler *sched,
 
 static void
 tick_ctx_init(struct panthor_scheduler *sched,
-	      struct panthor_sched_tick_ctx *ctx,
-	      bool full_tick)
+	      struct panthor_sched_tick_ctx *ctx)
 {
 	struct panthor_device *ptdev = sched->ptdev;
 	struct panthor_csg_slots_upd_ctx upd_ctx;
@@ -2013,7 +2003,7 @@ tick_ctx_init(struct panthor_scheduler *sched,
 				group->fatal_queues |= GENMASK(group->queue_count - 1, 0);
 		}
 
-		tick_ctx_insert_old_group(sched, ctx, group, full_tick);
+		tick_ctx_insert_old_group(sched, ctx, group);
 		csgs_upd_ctx_queue_reqs(ptdev, &upd_ctx, i,
 					csg_iface->output->ack ^ CSG_STATUS_UPDATE,
 					CSG_STATUS_UPDATE);
@@ -2356,7 +2346,7 @@ static void tick_work(struct work_struct *work)
 	if (panthor_device_reset_is_pending(sched->ptdev))
 		goto out_unlock;
 
-	tick_ctx_init(sched, &ctx, full_tick);
+	tick_ctx_init(sched, &ctx);
 	if (ctx.csg_upd_failed_mask)
 		goto out_cleanup_ctx;
 
@@ -2382,9 +2372,29 @@ static void tick_work(struct work_struct *work)
 	for (prio = PANTHOR_CSG_PRIORITY_COUNT - 1;
 	     prio >= 0 && !tick_ctx_is_full(sched, &ctx);
 	     prio--) {
+		struct panthor_group *old_highest_prio_group =
+			list_first_entry_or_null(&ctx.old_groups[prio],
+						 struct panthor_group, run_node);
+
+		/* Pull out the group with the highest prio for rotation. */
+		if (old_highest_prio_group)
+			list_del(&old_highest_prio_group->run_node);
+
+		/* Re-insert old active groups so they get a chance to run with higher prio. */
+		tick_ctx_pick_groups_from_list(sched, &ctx, &ctx.old_groups[prio], true, true);
+
+		/* Fill the remaining slots with runnable groups. */
 		tick_ctx_pick_groups_from_list(sched, &ctx, &sched->groups.runnable[prio],
 					       true, false);
-		tick_ctx_pick_groups_from_list(sched, &ctx, &ctx.old_groups[prio], true, true);
+
+		/* Re-insert the old group with the highest prio, and give it a chance to be
+		 * scheduled again (but with a lower prio) if there's room left.
+		 */
+		if (old_highest_prio_group) {
+			list_add_tail(&old_highest_prio_group->run_node, &ctx.old_groups[prio]);
+			tick_ctx_pick_groups_from_list(sched, &ctx, &ctx.old_groups[prio],
+						       true, true);
+		}
 	}
 
 	/* If we have free CSG slots left, pick idle groups */
-- 
2.51.0

