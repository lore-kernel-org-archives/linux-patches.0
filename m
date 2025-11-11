Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9E723FC41;
	Tue, 11 Nov 2025 00:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822677; cv=none; b=lSwEFPXvSP84GS57WyfL1DGHnGkF8g4FcAhxu/0IeuYP1ANkoPH8g2PvFwntsaInPaKdM2+Ze1ICxjS0VtWyePDsjhGKW8lXFTRheqtpna9wLWwvUGNNoO7uw6sPguTkXoNJWYGStO3S9ynDFBx41pJezqm0GGAG4XdcAhqbgNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822677; c=relaxed/simple;
	bh=S6LPenAJA445iFiwHvuS7U/rGBDVr/jYmV/KwBMTk4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ijuLoTwXajyLBpAHApfjbH8tP+j87KXvW+y9i012SQXn4hK4AQwCutu5jsrYu2LnQkXEmOe7GohuOP1V6Lh1MD9nxUyyxuqvQsWAiooibdLfnoAcmRIAkn4VAsDiQeqGUkTGC4VbTy3J71C39WGZAzOLVpmwthcnm0fTB6y9JIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhXBgzGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhXBgzGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC0EC116B1;
	Tue, 11 Nov 2025 00:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822677;
	bh=S6LPenAJA445iFiwHvuS7U/rGBDVr/jYmV/KwBMTk4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhXBgzGRKuojdA1GSGAsis6LdO1LA/IW35vDWJ/HZ/7wIavpuxEizMEKaQwz4iF5y
	 30A1DRYuQH8oqux9vWGHI2jQzpL5Dbxw7DS5HdZWp9oLeHEjIScS3m16fS7bVUzb+x
	 dMt/zyT0thWnzpQxx40vuLlfs3sVmPtA1jbNpqxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Luben Tuikov <ltuikov89@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Philipp Stanner <pstanner@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/565] drm/sched: Re-group and rename the entity run-queue lock
Date: Tue, 11 Nov 2025 09:39:00 +0900
Message-ID: <20251111004528.857251276@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit f93126f5d55920d1447ef00a3fbe6706f40f53de ]

When writing to a drm_sched_entity's run-queue, writers are protected
through the lock drm_sched_entity.rq_lock. This naming, however,
frequently collides with the separate internal lock of struct
drm_sched_rq, resulting in uses like this:

	spin_lock(&entity->rq_lock);
	spin_lock(&entity->rq->lock);

Rename drm_sched_entity.rq_lock to improve readability. While at it,
re-order that struct's members to make it more obvious what the lock
protects.

v2:
 * Rename some rq_lock straddlers in kerneldoc, improve commit text. (Philipp)

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Luben Tuikov <ltuikov89@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Philipp Stanner <pstanner@redhat.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
[pstanner: Fix typo in docstring]
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241016122013.7857-5-tursulin@igalia.com
Stable-dep-of: d25e3a610bae ("drm/sched: Fix race in drm_sched_entity_select_rq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |   28 ++++++++++++++--------------
 drivers/gpu/drm/scheduler/sched_main.c   |    2 +-
 include/drm/gpu_scheduler.h              |   21 +++++++++++----------
 3 files changed, 26 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -106,7 +106,7 @@ int drm_sched_entity_init(struct drm_sch
 	/* We start in an idle state. */
 	complete_all(&entity->entity_idle);
 
-	spin_lock_init(&entity->rq_lock);
+	spin_lock_init(&entity->lock);
 	spsc_queue_init(&entity->job_queue);
 
 	atomic_set(&entity->fence_seq, 0);
@@ -134,10 +134,10 @@ void drm_sched_entity_modify_sched(struc
 {
 	WARN_ON(!num_sched_list || !sched_list);
 
-	spin_lock(&entity->rq_lock);
+	spin_lock(&entity->lock);
 	entity->sched_list = sched_list;
 	entity->num_sched_list = num_sched_list;
-	spin_unlock(&entity->rq_lock);
+	spin_unlock(&entity->lock);
 }
 EXPORT_SYMBOL(drm_sched_entity_modify_sched);
 
@@ -246,10 +246,10 @@ static void drm_sched_entity_kill(struct
 	if (!entity->rq)
 		return;
 
-	spin_lock(&entity->rq_lock);
+	spin_lock(&entity->lock);
 	entity->stopped = true;
 	drm_sched_rq_remove_entity(entity->rq, entity);
-	spin_unlock(&entity->rq_lock);
+	spin_unlock(&entity->lock);
 
 	/* Make sure this entity is not used by the scheduler at the moment */
 	wait_for_completion(&entity->entity_idle);
@@ -395,9 +395,9 @@ static void drm_sched_entity_wakeup(stru
 void drm_sched_entity_set_priority(struct drm_sched_entity *entity,
 				   enum drm_sched_priority priority)
 {
-	spin_lock(&entity->rq_lock);
+	spin_lock(&entity->lock);
 	entity->priority = priority;
-	spin_unlock(&entity->rq_lock);
+	spin_unlock(&entity->lock);
 }
 EXPORT_SYMBOL(drm_sched_entity_set_priority);
 
@@ -507,10 +507,10 @@ struct drm_sched_job *drm_sched_entity_p
 
 		next = to_drm_sched_job(spsc_queue_peek(&entity->job_queue));
 		if (next) {
-			spin_lock(&entity->rq_lock);
+			spin_lock(&entity->lock);
 			drm_sched_rq_update_fifo_locked(entity,
 							next->submit_ts);
-			spin_unlock(&entity->rq_lock);
+			spin_unlock(&entity->lock);
 		}
 	}
 
@@ -551,14 +551,14 @@ void drm_sched_entity_select_rq(struct d
 	if (fence && !dma_fence_is_signaled(fence))
 		return;
 
-	spin_lock(&entity->rq_lock);
+	spin_lock(&entity->lock);
 	sched = drm_sched_pick_best(entity->sched_list, entity->num_sched_list);
 	rq = sched ? sched->sched_rq[entity->priority] : NULL;
 	if (rq != entity->rq) {
 		drm_sched_rq_remove_entity(entity->rq, entity);
 		entity->rq = rq;
 	}
-	spin_unlock(&entity->rq_lock);
+	spin_unlock(&entity->lock);
 
 	if (entity->num_sched_list == 1)
 		entity->sched_list = NULL;
@@ -599,9 +599,9 @@ void drm_sched_entity_push_job(struct dr
 		struct drm_sched_rq *rq;
 
 		/* Add the entity to the run queue */
-		spin_lock(&entity->rq_lock);
+		spin_lock(&entity->lock);
 		if (entity->stopped) {
-			spin_unlock(&entity->rq_lock);
+			spin_unlock(&entity->lock);
 
 			DRM_ERROR("Trying to push to a killed entity\n");
 			return;
@@ -615,7 +615,7 @@ void drm_sched_entity_push_job(struct dr
 		if (drm_sched_policy == DRM_SCHED_POLICY_FIFO)
 			drm_sched_rq_update_fifo_locked(entity, submit_ts);
 
-		spin_unlock(&entity->rq_lock);
+		spin_unlock(&entity->lock);
 
 		drm_sched_wakeup(sched);
 	}
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -176,7 +176,7 @@ void drm_sched_rq_update_fifo_locked(str
 	 * for entity from within concurrent drm_sched_entity_select_rq and the
 	 * other to update the rb tree structure.
 	 */
-	lockdep_assert_held(&entity->rq_lock);
+	lockdep_assert_held(&entity->lock);
 
 	spin_lock(&entity->rq->lock);
 
--- a/include/drm/gpu_scheduler.h
+++ b/include/drm/gpu_scheduler.h
@@ -97,13 +97,21 @@ struct drm_sched_entity {
 	struct list_head		list;
 
 	/**
+	 * @lock:
+	 *
+	 * Lock protecting the run-queue (@rq) to which this entity belongs,
+	 * @priority and the list of schedulers (@sched_list, @num_sched_list).
+	 */
+	spinlock_t			lock;
+
+	/**
 	 * @rq:
 	 *
 	 * Runqueue on which this entity is currently scheduled.
 	 *
 	 * FIXME: Locking is very unclear for this. Writers are protected by
-	 * @rq_lock, but readers are generally lockless and seem to just race
-	 * with not even a READ_ONCE.
+	 * @lock, but readers are generally lockless and seem to just race with
+	 * not even a READ_ONCE.
 	 */
 	struct drm_sched_rq		*rq;
 
@@ -136,18 +144,11 @@ struct drm_sched_entity {
 	 * @priority:
 	 *
 	 * Priority of the entity. This can be modified by calling
-	 * drm_sched_entity_set_priority(). Protected by &rq_lock.
+	 * drm_sched_entity_set_priority(). Protected by @lock.
 	 */
 	enum drm_sched_priority         priority;
 
 	/**
-	 * @rq_lock:
-	 *
-	 * Lock to modify the runqueue to which this entity belongs.
-	 */
-	spinlock_t			rq_lock;
-
-	/**
 	 * @job_queue: the list of jobs of this entity.
 	 */
 	struct spsc_queue		job_queue;


