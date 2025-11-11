Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98721DF258;
	Tue, 11 Nov 2025 00:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822672; cv=none; b=q1NVbeXefr8rfWAxPFG5nHW910q+syThwsiyh+5NtjWQciB8xyBSdvaEUUhMzy23K4R0DE/aSSdxpqbfSrHheO9dF6Fxfuyc1VTdtvIjk4Y7RcqzwBvMBdbD6apRIbvhVdOxz96ZI/fIwdfcZ8K99Fm/YHz9yFx5NAODWI8U0lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822672; c=relaxed/simple;
	bh=LJRWELax0r8vZxNJTrqabuzlN5OQfBgIJwsQIHh3PGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pGiI+Z/cjj2MrJyAmZkicX9k3gaALM6ifDp9IvJXRA/s0hM92bUM4Wio9L+FIfM/QnHKpngaFYN7C8vwxoKFX+p8gAAqlYmN97xgZcDqiJJUmKcHu/NlMmhxRHBW/GvpHeRM00VWHcvXZMwIIOPmP2I04R3nPtMwyPCTYhB4Wv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvOdmjGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvOdmjGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66698C4CEFB;
	Tue, 11 Nov 2025 00:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822672;
	bh=LJRWELax0r8vZxNJTrqabuzlN5OQfBgIJwsQIHh3PGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvOdmjGAYkstEEZ8TLqDTMUUpf8rdz45+k3KxONKyB5cVZJHEhc+ULjrEIRtU2W6G
	 q7sgOGYR37EPKcm6I0iZkR2JoEJawLP2ecw8UKOIPBFCk6uqHhdwshMG9Qlhp+9rWJ
	 uaghFh1/fNt8Fb1W2hHOwZHd239KVX9f+JVM1dLw=
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
Subject: [PATCH 6.12 083/565] drm/sched: Optimise drm_sched_entity_push_job
Date: Tue, 11 Nov 2025 09:38:59 +0900
Message-ID: <20251111004528.834203751@linuxfoundation.org>
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

[ Upstream commit d42a254633c773921884a19e8a1a0f53a31150c3 ]

In FIFO mode (which is the default), both drm_sched_entity_push_job() and
drm_sched_rq_update_fifo(), where the latter calls the former, are
currently taking and releasing the same entity->rq_lock.

We can avoid that design inelegance, and also have a miniscule
efficiency improvement on the submit from idle path, by introducing a new
drm_sched_rq_update_fifo_locked() helper and pulling up the lock taking to
its callers.

v2:
 * Remove drm_sched_rq_update_fifo() altogether. (Christian)

v3:
 * Improved commit message. (Philipp)

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Luben Tuikov <ltuikov89@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Philipp Stanner <pstanner@redhat.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Philipp Stanner <pstanner@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241016122013.7857-2-tursulin@igalia.com
Stable-dep-of: d25e3a610bae ("drm/sched: Fix race in drm_sched_entity_select_rq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |   13 +++++++++----
 drivers/gpu/drm/scheduler/sched_main.c   |    6 +++---
 include/drm/gpu_scheduler.h              |    2 +-
 3 files changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -506,8 +506,12 @@ struct drm_sched_job *drm_sched_entity_p
 		struct drm_sched_job *next;
 
 		next = to_drm_sched_job(spsc_queue_peek(&entity->job_queue));
-		if (next)
-			drm_sched_rq_update_fifo(entity, next->submit_ts);
+		if (next) {
+			spin_lock(&entity->rq_lock);
+			drm_sched_rq_update_fifo_locked(entity,
+							next->submit_ts);
+			spin_unlock(&entity->rq_lock);
+		}
 	}
 
 	/* Jobs and entities might have different lifecycles. Since we're
@@ -607,10 +611,11 @@ void drm_sched_entity_push_job(struct dr
 		sched = rq->sched;
 
 		drm_sched_rq_add_entity(rq, entity);
-		spin_unlock(&entity->rq_lock);
 
 		if (drm_sched_policy == DRM_SCHED_POLICY_FIFO)
-			drm_sched_rq_update_fifo(entity, submit_ts);
+			drm_sched_rq_update_fifo_locked(entity, submit_ts);
+
+		spin_unlock(&entity->rq_lock);
 
 		drm_sched_wakeup(sched);
 	}
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -169,14 +169,15 @@ static inline void drm_sched_rq_remove_f
 	}
 }
 
-void drm_sched_rq_update_fifo(struct drm_sched_entity *entity, ktime_t ts)
+void drm_sched_rq_update_fifo_locked(struct drm_sched_entity *entity, ktime_t ts)
 {
 	/*
 	 * Both locks need to be grabbed, one to protect from entity->rq change
 	 * for entity from within concurrent drm_sched_entity_select_rq and the
 	 * other to update the rb tree structure.
 	 */
-	spin_lock(&entity->rq_lock);
+	lockdep_assert_held(&entity->rq_lock);
+
 	spin_lock(&entity->rq->lock);
 
 	drm_sched_rq_remove_fifo_locked(entity);
@@ -187,7 +188,6 @@ void drm_sched_rq_update_fifo(struct drm
 		      drm_sched_entity_compare_before);
 
 	spin_unlock(&entity->rq->lock);
-	spin_unlock(&entity->rq_lock);
 }
 
 /**
--- a/include/drm/gpu_scheduler.h
+++ b/include/drm/gpu_scheduler.h
@@ -593,7 +593,7 @@ void drm_sched_rq_add_entity(struct drm_
 void drm_sched_rq_remove_entity(struct drm_sched_rq *rq,
 				struct drm_sched_entity *entity);
 
-void drm_sched_rq_update_fifo(struct drm_sched_entity *entity, ktime_t ts);
+void drm_sched_rq_update_fifo_locked(struct drm_sched_entity *entity, ktime_t ts);
 
 int drm_sched_entity_init(struct drm_sched_entity *entity,
 			  enum drm_sched_priority priority,


