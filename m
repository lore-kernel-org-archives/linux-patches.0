Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417C71F03DE;
	Wed, 25 Feb 2026 01:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983030; cv=none; b=j9JT3GO3J1+6Sobxl7DtwylrlhSIcKq0+wY1R48XhDEePdjAiPiGUcV234T4aL+NreQio1cQCBDVwWgOIn0IbSv6HGvM3rEVLDw8kNEq7xOGDqKEC8rX1Pwnq2BcmE6zanAzDtk7ntjqjxJz4mNOpsOiVQXQGD4n3WEpqqBDIgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983030; c=relaxed/simple;
	bh=lfKuVs9stuA0wnhecTkLqw3L1VXCSCNNG0tWQhR99aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVuEVUf2mtQsPihBrG4WdHNpCVjgDLydYFwVu60Ntz35gkKqieHwiaKvf27sqsigC+mYtPOCgJDzG/aRWlI1a9Rb3jGt1cPHumJrn0obNjJJAnF82YFuvVInCw4IZlJTtvZc774rxkE5epn2tvxCBH0g8DwA+90PDGZi2fzdzc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBswpEwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBswpEwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02498C116D0;
	Wed, 25 Feb 2026 01:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983030;
	bh=lfKuVs9stuA0wnhecTkLqw3L1VXCSCNNG0tWQhR99aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBswpEwtcgnthA4052iJsTd0UqtkTbjMChxNcOBNZolDqH55MdbD6XohmR7Atx8n6
	 uOuJ+6Jvh/dGIBvn3nUdgDkNaTEVC1HL3aeE8z82b0ohMasBJUAB+eHpTqXbViMZ12
	 qJjXkXU4/xeglKaWfbvXPEccoxcP6P1cZrFLGVco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 195/781] drm/panthor: Fix the group priority rotation logic
Date: Tue, 24 Feb 2026 17:15:04 -0800
Message-ID: <20260225012404.436260114@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 3b52c23849339..3f502cc7cfd1f 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2085,31 +2085,22 @@ tick_ctx_pick_groups_from_list(const struct panthor_scheduler *sched,
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
@@ -2119,8 +2110,7 @@ tick_ctx_insert_old_group(struct panthor_scheduler *sched,
 
 static void
 tick_ctx_init(struct panthor_scheduler *sched,
-	      struct panthor_sched_tick_ctx *ctx,
-	      bool full_tick)
+	      struct panthor_sched_tick_ctx *ctx)
 {
 	struct panthor_device *ptdev = sched->ptdev;
 	struct panthor_csg_slots_upd_ctx upd_ctx;
@@ -2158,7 +2148,7 @@ tick_ctx_init(struct panthor_scheduler *sched,
 				group->fatal_queues |= GENMASK(group->queue_count - 1, 0);
 		}
 
-		tick_ctx_insert_old_group(sched, ctx, group, full_tick);
+		tick_ctx_insert_old_group(sched, ctx, group);
 		csgs_upd_ctx_queue_reqs(ptdev, &upd_ctx, i,
 					csg_iface->output->ack ^ CSG_STATUS_UPDATE,
 					CSG_STATUS_UPDATE);
@@ -2501,7 +2491,7 @@ static void tick_work(struct work_struct *work)
 	if (panthor_device_reset_is_pending(sched->ptdev))
 		goto out_unlock;
 
-	tick_ctx_init(sched, &ctx, full_tick);
+	tick_ctx_init(sched, &ctx);
 	if (ctx.csg_upd_failed_mask)
 		goto out_cleanup_ctx;
 
@@ -2527,9 +2517,29 @@ static void tick_work(struct work_struct *work)
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



