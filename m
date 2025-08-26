Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C847D352080;
	Tue, 26 Aug 2025 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216700; cv=none; b=LJaRDmcAR3eWX8wpi9uVK+TxSKeYhC64a3OemLy0USEu5t4JI4RhnkXdBlsdqHgKJIO0xXyiQbg7B1nzwieusiBjYUJkek8PBHs8f2SorJN9xoyN02rAJD6IZX9EOVwvlhFkzCtX2TJQJZ/b5cYAsQUfdxf42ceZdPRbADo9GHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216700; c=relaxed/simple;
	bh=Md3e/sl1W3EZz7imY3uHTr8hfat6SkfsCRy1e6TYt5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B/PVeKl8HEv8nl6kVRrU3ZK4jegZtT/NCzf/GHCRDCLah7sSY/QmsBSrfP26bgJWJ4PxGfOBfzBTfcHtnnoMHaj9F1Qt83YPpATdqvyO9DIPyJx6ot6e06MpBCK1TNvQC/+f8XIVkPJsTma1SFVC+iRuqYwFdAPk3QupKScGu9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJ2CUxML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJ2CUxML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557EBC4CEF1;
	Tue, 26 Aug 2025 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216700;
	bh=Md3e/sl1W3EZz7imY3uHTr8hfat6SkfsCRy1e6TYt5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJ2CUxML/gyVD2Rts6JiyVjuDX3V5nFyDtBsrujE4MnEAFm7wHSgGkehn6Wr9Y5X5
	 zbdX84w049opQ8mrexpGEjO4uJ2nAKXGJlAl7h5YpthdpL7HNw1MkY6mvHjv2r+t6O
	 RwRIaPZD82Xo5JfD0/jHda1CR8TcCkTFlM6ppuTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 511/644] drm/sched: Remove optimization that causes hang when killing dependent jobs
Date: Tue, 26 Aug 2025 13:10:02 +0200
Message-ID: <20250826110959.168031726@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Lin.Cao" <lincao12@amd.com>

[ Upstream commit 15f77764e90a713ee3916ca424757688e4f565b9 ]

When application A submits jobs and application B submits a job with a
dependency on A's fence, the normal flow wakes up the scheduler after
processing each job. However, the optimization in
drm_sched_entity_add_dependency_cb() uses a callback that only clears
dependencies without waking up the scheduler.

When application A is killed before its jobs can run, the callback gets
triggered but only clears the dependency without waking up the scheduler,
causing the scheduler to enter sleep state and application B to hang.

Remove the optimization by deleting drm_sched_entity_clear_dep() and its
usage, ensuring the scheduler is always woken up when dependencies are
cleared.

Fixes: 777dbd458c89 ("drm/amdgpu: drop a dummy wakeup scheduler")
Cc: stable@vger.kernel.org # v4.6+
Signed-off-by: Lin.Cao <lincao12@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://lore.kernel.org/r/20250717084453.921097-1-lincao12@amd.com
[ Changed drm_sched_wakeup_if_can_queue() calls to drm_sched_wakeup() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |   27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -317,21 +317,8 @@ void drm_sched_entity_destroy(struct drm
 EXPORT_SYMBOL(drm_sched_entity_destroy);
 
 /*
- * drm_sched_entity_clear_dep - callback to clear the entities dependency
- */
-static void drm_sched_entity_clear_dep(struct dma_fence *f,
-				       struct dma_fence_cb *cb)
-{
-	struct drm_sched_entity *entity =
-		container_of(cb, struct drm_sched_entity, cb);
-
-	entity->dependency = NULL;
-	dma_fence_put(f);
-}
-
-/*
- * drm_sched_entity_clear_dep - callback to clear the entities dependency and
- * wake up scheduler
+ * drm_sched_entity_wakeup - callback to clear the entity's dependency and
+ * wake up the scheduler
  */
 static void drm_sched_entity_wakeup(struct dma_fence *f,
 				    struct dma_fence_cb *cb)
@@ -339,7 +326,8 @@ static void drm_sched_entity_wakeup(stru
 	struct drm_sched_entity *entity =
 		container_of(cb, struct drm_sched_entity, cb);
 
-	drm_sched_entity_clear_dep(f, cb);
+	entity->dependency = NULL;
+	dma_fence_put(f);
 	drm_sched_wakeup(entity->rq->sched);
 }
 
@@ -395,13 +383,6 @@ static bool drm_sched_entity_add_depende
 		fence = dma_fence_get(&s_fence->scheduled);
 		dma_fence_put(entity->dependency);
 		entity->dependency = fence;
-		if (!dma_fence_add_callback(fence, &entity->cb,
-					    drm_sched_entity_clear_dep))
-			return true;
-
-		/* Ignore it when it is already scheduled */
-		dma_fence_put(fence);
-		return false;
 	}
 
 	if (!dma_fence_add_callback(entity->dependency, &entity->cb,


