Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80E4266584;
	Fri, 21 Nov 2025 13:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733132; cv=none; b=u+MNPmvj2qndCQIo/YDQohUeT5ZhLEWvUGIMkCm8/hReg2M3d1DLgjtYS6PHDd5AuVSYZYieRETBFDtQpOWjbEmdFizRdGH2XX7WLL6lGnVcQQO14gyPY2SwPzC5fKXFW2PXVS/Wuj9uJvUAlFRpfNi97Koxc2pCrRGoeTUWK9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733132; c=relaxed/simple;
	bh=7YyrhZ84gSn10tqHNYDMBcg1Eb1+KdsEj0ZknwEAfPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=krelN+MeVfe/ClvezA3NpEShQx6BPZ2GkEi0Bu4jjAtykFOQjnOKWVhJUxeKoRmlg0hmHSBf/bBB5mW3XvzCEelbzvnxiZQdke+ZREWAkkMPMQjcTF9AYRbBbJ++ZfckZqa6TG8AMAAztkgePKKYzAmAZBTDAJM0+aGIvTFuC7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQRl7K9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQRl7K9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72075C4CEF1;
	Fri, 21 Nov 2025 13:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733131;
	bh=7YyrhZ84gSn10tqHNYDMBcg1Eb1+KdsEj0ZknwEAfPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQRl7K9RFF5wOSa6YDXJ8FUIYmeNGhStgdCc89MOuWYJQvw6Iv8cfbOe9vRoKQBjH
	 EOS6S7xSGQ6PPbjPZ4UbsPAyQystjKbZ8WR0lyUCvKcyEcgmopQcQV7ClHtjnKzebn
	 IP16Npfx9waYKY9ivW6ARKUi8652e+MN2jMERAeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Philipp Stanner <phasta@kernel.org>
Subject: [PATCH 6.6 363/529] drm/sched: Fix deadlock in drm_sched_entity_kill_jobs_cb
Date: Fri, 21 Nov 2025 14:11:02 +0100
Message-ID: <20251121130243.943767343@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -163,26 +163,15 @@ int drm_sched_entity_error(struct drm_sc
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
@@ -210,6 +199,21 @@ static void drm_sched_entity_kill_jobs_c
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


