Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0EE344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301733; cv=none; b=UdnPmEpsy/89vHsJid4Tr67MyYBd8glKUt0VgPhL9JBRVmYTecLK+7OaUNQyuAK3xRVh4LY4939zTJAACfB4/QfYOVgy9ISagfIlQa/I43L2R/bX/vDxka4M4aHjOOdULoFkfjahbnsq9VKXzCi2q7KgKaONBs51NOSsapRLlaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301733; c=relaxed/simple;
	bh=+hHP9J5/5kCTJZdcWXnUjtw4zYzQ6Il4wJHgGepEmvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmeDOO3K2Ck7JavpKxvdc0NS85zD1fkdMc1KbaPJI6C5oAJUCTpY6ZoqoNee63N4w4l0sfujL4x+9oXGS4z/WMSjKU6rYsd/VIfToSjucjNZZrMkx8FUSpoQNg8iB/wAUZI7F3z3lOh/jI9WU1Se0yZORy3T9X/JrcJxaseYUZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SL+OGRDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SL+OGRDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A023CC19425;
	Sat, 28 Feb 2026 18:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301733;
	bh=+hHP9J5/5kCTJZdcWXnUjtw4zYzQ6Il4wJHgGepEmvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SL+OGRDMDkXjPt+a+CSgr5dEIU7MXOsH6zZn2SKNWk1yeY4yvz/7cgjyT0IJpgFx4
	 3P565REdpIRhfxaH1yBcfwmljtLdXuL2LMw0BVOAroFGhzGQfzFP30nCfduofYKS71
	 W5nm6fdzIWeks8BzBq0eER8o2BTKsuuFfNIHb9E1uFZPBIrUl6PG/ZBXVm4EtpAQKV
	 aMSzv02506L7p30dNxoQielF4HyQRZaVIVLJgG1VKIw9JHYVGPxMblgzcuSHBWFihh
	 Lk1vigLd4Qm27C5yVPl4r7ZAvMVz5C/1Av8a7F/X/T+Y5jAHb2QJaHJHZEXNyiP4lq
	 LpTQSFRFeFJHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/385] drm/panthor: Fix the logic that decides when to stop ticking
Date: Sat, 28 Feb 2026 12:55:54 -0500
Message-ID: <20260228180011.1568201-132-sashal@kernel.org>
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

[ Upstream commit 61d9a43d70dc3e1709ecd14a34f6d5f01e21dfc9 ]

When we have multiple active groups with the same priority, we need to
keep ticking for the priority rotation to take place. If we don't do
that, we might starve slots with lower priorities.

It's annoying to deal with that in tick_ctx_update_resched_target(),
so let's add a ::stop_tick field to the tick context which is
initialized to true, and downgraded to false as soon as we detect
something that requires to tick to happen. This way we can complement
the current logic with extra conditions if needed.

v2:
- Add R-b

v3:
- Drop panthor_sched_tick_ctx::min_priority (no longer relevant)
- Collect R-b

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Link: https://patch.msgid.link/20251128094839.3856402-7-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 44 ++++++++++---------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 04236fd41518d..6be977e69b192 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -1853,10 +1853,10 @@ struct panthor_sched_tick_ctx {
 	struct list_head groups[PANTHOR_CSG_PRIORITY_COUNT];
 	u32 idle_group_count;
 	u32 group_count;
-	enum panthor_csg_priority min_priority;
 	struct panthor_vm *vms[MAX_CS_PER_CSG];
 	u32 as_count;
 	bool immediate_tick;
+	bool stop_tick;
 	u32 csg_upd_failed_mask;
 };
 
@@ -1921,17 +1921,21 @@ tick_ctx_pick_groups_from_list(const struct panthor_scheduler *sched,
 		if (!owned_by_tick_ctx)
 			group_get(group);
 
-		list_move_tail(&group->run_node, &ctx->groups[group->priority]);
 		ctx->group_count++;
+
+		/* If we have more than one active group with the same priority,
+		 * we need to keep ticking to rotate the CSG priority.
+		 */
 		if (group_is_idle(group))
 			ctx->idle_group_count++;
+		else if (!list_empty(&ctx->groups[group->priority]))
+			ctx->stop_tick = false;
+
+		list_move_tail(&group->run_node, &ctx->groups[group->priority]);
 
 		if (i == ctx->as_count)
 			ctx->vms[ctx->as_count++] = group->vm;
 
-		if (ctx->min_priority > group->priority)
-			ctx->min_priority = group->priority;
-
 		if (tick_ctx_is_full(sched, ctx))
 			return;
 	}
@@ -1975,7 +1979,7 @@ tick_ctx_init(struct panthor_scheduler *sched,
 	memset(ctx, 0, sizeof(*ctx));
 	csgs_upd_ctx_init(&upd_ctx);
 
-	ctx->min_priority = PANTHOR_CSG_PRIORITY_COUNT;
+	ctx->stop_tick = true;
 	for (i = 0; i < ARRAY_SIZE(ctx->groups); i++) {
 		INIT_LIST_HEAD(&ctx->groups[i]);
 		INIT_LIST_HEAD(&ctx->old_groups[i]);
@@ -2287,32 +2291,18 @@ static u64
 tick_ctx_update_resched_target(struct panthor_scheduler *sched,
 			       const struct panthor_sched_tick_ctx *ctx)
 {
-	/* We had space left, no need to reschedule until some external event happens. */
-	if (!tick_ctx_is_full(sched, ctx))
-		goto no_tick;
-
-	/* If idle groups were scheduled, no need to wake up until some external
-	 * event happens (group unblocked, new job submitted, ...).
-	 */
-	if (ctx->idle_group_count)
-		goto no_tick;
+	u64 resched_target;
 
-	if (drm_WARN_ON(&sched->ptdev->base, ctx->min_priority >= PANTHOR_CSG_PRIORITY_COUNT))
+	if (ctx->stop_tick)
 		goto no_tick;
 
-	/* If there are groups of the same priority waiting, we need to
-	 * keep the scheduler ticking, otherwise, we'll just wait for
-	 * new groups with higher priority to be queued.
-	 */
-	if (!list_empty(&sched->groups.runnable[ctx->min_priority])) {
-		u64 resched_target = sched->last_tick + sched->tick_period;
+	resched_target = sched->last_tick + sched->tick_period;
 
-		if (time_before64(sched->resched_target, sched->last_tick) ||
-		    time_before64(resched_target, sched->resched_target))
-			sched->resched_target = resched_target;
+	if (time_before64(sched->resched_target, sched->last_tick) ||
+	    time_before64(resched_target, sched->resched_target))
+		sched->resched_target = resched_target;
 
-		return sched->resched_target - sched->last_tick;
-	}
+	return sched->resched_target - sched->last_tick;
 
 no_tick:
 	sched->resched_target = U64_MAX;
-- 
2.51.0

