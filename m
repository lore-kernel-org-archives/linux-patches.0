Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC4B27467B;
	Wed, 30 Jul 2025 09:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869160; cv=none; b=hqwenTb6DK+F1vutzXXlR3OsfxvvdIgBdmQ6IPd5v9+27JExrWienzn0uVEJ9uJsKWIGJSkcbsVWOPiE7JL0Bc0zuqs5ui4p4bhAXLlTDv3m/z99q9STkt5wId7VowWgUi5r7sVcsfVzaEu98HY5CsRwqQE+ni3stez0Bm67GH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869160; c=relaxed/simple;
	bh=Lliiq1TZbvesRsMD2atRINUPa2GeuRIgLGYGldmPh8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i3d8rPfsXwEQ1KcPfspvn84b0gNa3LMTrQkBwVPmeBYeN8Pu++0epF8Ck7qje19/8Ax1B+17bYaNDPaWWfXJD9ULl5k03WaTzNCzVjTIHh3KpJL4B1ZXQHq0mCb7MBt7LKcJ/6/5C+LI2eQ0f0T/cz8rZjQzMPbTRKsWzejbOUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfI1vDQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfI1vDQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5BEC4CEF5;
	Wed, 30 Jul 2025 09:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869160;
	bh=Lliiq1TZbvesRsMD2atRINUPa2GeuRIgLGYGldmPh8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfI1vDQ7PK/VDLjO4WZqgM+aoXJ3R9EI0Pks232i1/WuHJiSaM9jDIt2j7zLd8j8j
	 c/Af2iJc2Aeqq+HgALcwNBAWKR8DtCG6uEF78LuFSLgMsJbIrTHAOhVEbnswziqdDf
	 DUM3nFuqtzitq3XkZ/Ky2U44Y34eXLhjv36VgnDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Philipp Stanner <phasta@kernel.org>
Subject: [PATCH 6.15 51/92] drm/sched: Remove optimization that causes hang when killing dependent jobs
Date: Wed, 30 Jul 2025 11:35:59 +0200
Message-ID: <20250730093232.727807158@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin.Cao <lincao12@amd.com>

commit 15f77764e90a713ee3916ca424757688e4f565b9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -355,17 +355,6 @@ void drm_sched_entity_destroy(struct drm
 }
 EXPORT_SYMBOL(drm_sched_entity_destroy);
 
-/* drm_sched_entity_clear_dep - callback to clear the entities dependency */
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
 /*
  * drm_sched_entity_wakeup - callback to clear the entity's dependency and
  * wake up the scheduler
@@ -376,7 +365,8 @@ static void drm_sched_entity_wakeup(stru
 	struct drm_sched_entity *entity =
 		container_of(cb, struct drm_sched_entity, cb);
 
-	drm_sched_entity_clear_dep(f, cb);
+	entity->dependency = NULL;
+	dma_fence_put(f);
 	drm_sched_wakeup(entity->rq->sched);
 }
 
@@ -429,13 +419,6 @@ static bool drm_sched_entity_add_depende
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


