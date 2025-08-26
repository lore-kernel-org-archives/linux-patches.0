Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F8222370D;
	Tue, 26 Aug 2025 14:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219318; cv=none; b=IXC2XnlImhAbOA9RPVPgwlRDUFDofcI5LL+sd2928At1dus7K3hvRUN+w6iLhuorZqZiAA00DimuZ4XFETtBjx8jn4Jw7BUKfdUYa7DqwBqVQgLKdDV3UG7G2CvfBjHlrqejcb+iJDRA3T3bximvrlgdyvnvenruyW06bqzjM7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219318; c=relaxed/simple;
	bh=pj/Dz0oQyoq/OR4JaKgefxnDxLlBJKdH2850pDspp4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CuU9RkQHzyGDCKraxQbY2JPWbmLt42x9zqetp9nBr17GGCRK754z0z9wH1r+RWjzkkJtCqtonqA66Gif8iKqGKU/DW+4WP0fbr5YBy047PynUU/YfrBlKoODOKRkowJFMSAKkWFCtG8hF11EzSj7QLO8L726pMGvotAtWXbi92M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZWyQSu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZWyQSu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868C8C4CEF1;
	Tue, 26 Aug 2025 14:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219317;
	bh=pj/Dz0oQyoq/OR4JaKgefxnDxLlBJKdH2850pDspp4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZWyQSu7q+C7CqxVwZ1mVy+shGnYSNmLSotOXmyDsxOolRGv7upILqoe1kuydq8fh
	 mJBiz5M6IH8I5Z+sp5N4kXQtKmBmv1rn+RxUtH+CtDovvwE87ZZyv65zSaBYxCv8QP
	 tCdPxPt1DrgJVPMSJmHp9syM0pk6Kza8imM4nYdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 336/403] drm/sched: Remove optimization that causes hang when killing dependent jobs
Date: Tue, 26 Aug 2025 13:11:02 +0200
Message-ID: <20250826110916.129245168@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
[ adjusted context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |   23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -328,19 +328,6 @@ void drm_sched_entity_destroy(struct drm
 EXPORT_SYMBOL(drm_sched_entity_destroy);
 
 /**
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
-/**
  * drm_sched_entity_clear_dep - callback to clear the entities dependency and
  * wake up scheduler
  */
@@ -350,7 +337,8 @@ static void drm_sched_entity_wakeup(stru
 	struct drm_sched_entity *entity =
 		container_of(cb, struct drm_sched_entity, cb);
 
-	drm_sched_entity_clear_dep(f, cb);
+	entity->dependency = NULL;
+	dma_fence_put(f);
 	drm_sched_wakeup(entity->rq->sched);
 }
 
@@ -426,13 +414,6 @@ static bool drm_sched_entity_add_depende
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


