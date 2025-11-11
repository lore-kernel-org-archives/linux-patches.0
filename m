Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8535D3064AB;
	Tue, 11 Nov 2025 01:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825552; cv=none; b=bGdO/dvHFH/LsWV8ayQhW8vPM3YWbRfcK7Zyl+EKiiQMpl2Hh1wTv0/OAP3rY617idcH6grrhRLGjqESFXvnh5eEQZJXnimsIaDiYBxEPQPijBR0vbff5kNhntqLgz4niVUrVwURr4KkqNkfUQ/R2VWLQhQexVwwaFK6Onj11gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825552; c=relaxed/simple;
	bh=fmGK9sTPKpu9lsf9Pv2eNZOahb9GNLPHhtVJkwq7LVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VrTeBoLD4MCDV//4UYDiyyuvClg76negsfYWR1SIS1svOlwzLKNOxYU+Bs9iuSBI1hBzuY6VBeDlt9tVPgWg1vOz4gzCSuGhqzkzLsHk6tGKRKZYM6SV4/rZHobdN4z4/Qi4FRsQk4/rn2X40GPl5/K4a+SIt0zkAbbu+F5oL/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIR7wjXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIR7wjXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E59C19424;
	Tue, 11 Nov 2025 01:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825552;
	bh=fmGK9sTPKpu9lsf9Pv2eNZOahb9GNLPHhtVJkwq7LVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIR7wjXO1uppZFpvpIrDm7CualYv+cXVcym7xFmifhf8CSyW0Imdfunx8SMeUeM64
	 0sbCBQl0jBGpyoOIiN4F2KVSRkISkUMo9vgX1rwMobfXmouagILcfoCGBw3zBBQdmx
	 trG/5I+kFDSIw8/V1H/GYWZkDG6IrwIoKefIs2kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Philipp Stanner <phasta@kernel.org>
Subject: [PATCH 6.17 808/849] drm/sched: Fix deadlock in drm_sched_entity_kill_jobs_cb
Date: Tue, 11 Nov 2025 09:46:18 +0900
Message-ID: <20251111004555.960781175@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

commit 487df8b698345dd5a91346335f05170ed5f29d4e upstream.

The Mesa issue referenced below pointed out a possible deadlock:

[ 1231.611031]  Possible interrupt unsafe locking scenario:

[ 1231.611033]        CPU0                    CPU1
[ 1231.611034]        ----                    ----
[ 1231.611035]   lock(&xa->xa_lock#17);
[ 1231.611038]                                local_irq_disable();
[ 1231.611039]                                lock(&fence->lock);
[ 1231.611041]                                lock(&xa->xa_lock#17);
[ 1231.611044]   <Interrupt>
[ 1231.611045]     lock(&fence->lock);
[ 1231.611047]
                *** DEADLOCK ***

In this example, CPU0 would be any function accessing job->dependencies
through the xa_* functions that don't disable interrupts (eg:
drm_sched_job_add_dependency(), drm_sched_entity_kill_jobs_cb()).

CPU1 is executing drm_sched_entity_kill_jobs_cb() as a fence signalling
callback so in an interrupt context. It will deadlock when trying to
grab the xa_lock which is already held by CPU0.

Replacing all xa_* usage by their xa_*_irq counterparts would fix
this issue, but Christian pointed out another issue: dma_fence_signal
takes fence.lock and so does dma_fence_add_callback.

  dma_fence_signal() // locks f1.lock
  -> drm_sched_entity_kill_jobs_cb()
  -> foreach dependencies
     -> dma_fence_add_callback() // locks f2.lock

This will deadlock if f1 and f2 share the same spinlock.

To fix both issues, the code iterating on dependencies and re-arming them
is moved out to drm_sched_entity_kill_jobs_work().

Cc: stable@vger.kernel.org # v6.2+
Fixes: 2fdb8a8f07c2 ("drm/scheduler: rework entity flush, kill and fini")
Link: https://gitlab.freedesktop.org/mesa/mesa/-/issues/13908
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
[phasta: commit message nits]
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://patch.msgid.link/20251104095358.15092-1-pierre-eric.pelloux-prayer@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |   34 +++++++++++++++++--------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -173,26 +173,15 @@ int drm_sched_entity_error(struct drm_sc
 }
 EXPORT_SYMBOL(drm_sched_entity_error);
 
+static void drm_sched_entity_kill_jobs_cb(struct dma_fence *f,
+					  struct dma_fence_cb *cb);
+
 static void drm_sched_entity_kill_jobs_work(struct work_struct *wrk)
 {
 	struct drm_sched_job *job = container_of(wrk, typeof(*job), work);
-
-	drm_sched_fence_scheduled(job->s_fence, NULL);
-	drm_sched_fence_finished(job->s_fence, -ESRCH);
-	WARN_ON(job->s_fence->parent);
-	job->sched->ops->free_job(job);
-}
-
-/* Signal the scheduler finished fence when the entity in question is killed. */
-static void drm_sched_entity_kill_jobs_cb(struct dma_fence *f,
-					  struct dma_fence_cb *cb)
-{
-	struct drm_sched_job *job = container_of(cb, struct drm_sched_job,
-						 finish_cb);
+	struct dma_fence *f;
 	unsigned long index;
 
-	dma_fence_put(f);
-
 	/* Wait for all dependencies to avoid data corruptions */
 	xa_for_each(&job->dependencies, index, f) {
 		struct drm_sched_fence *s_fence = to_drm_sched_fence(f);
@@ -220,6 +209,21 @@ static void drm_sched_entity_kill_jobs_c
 		dma_fence_put(f);
 	}
 
+	drm_sched_fence_scheduled(job->s_fence, NULL);
+	drm_sched_fence_finished(job->s_fence, -ESRCH);
+	WARN_ON(job->s_fence->parent);
+	job->sched->ops->free_job(job);
+}
+
+/* Signal the scheduler finished fence when the entity in question is killed. */
+static void drm_sched_entity_kill_jobs_cb(struct dma_fence *f,
+					  struct dma_fence_cb *cb)
+{
+	struct drm_sched_job *job = container_of(cb, struct drm_sched_job,
+						 finish_cb);
+
+	dma_fence_put(f);
+
 	INIT_WORK(&job->work, drm_sched_entity_kill_jobs_work);
 	schedule_work(&job->work);
 }


