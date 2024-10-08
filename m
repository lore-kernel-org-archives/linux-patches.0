Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A601DEFE0;
	Tue,  8 Oct 2024 13:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392787; cv=none; b=SnqFGJuHtLq/OmGgvqP3ITpltr64qB0GBTgVQdrf5TvR9Ui1J/81RGF9BOUDAOydGZeB8OgMWqRNZlIaNWnJtnogD8AXhQWsXHlsjOWSXeBfmoYYV9GjuXyRVKNrCQpmWORmaeL0YgACTsqkrrBaqv4P2Gwz0CSG9O5r41I8EEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392787; c=relaxed/simple;
	bh=2t2uShpQt0e2sHtZcWcrX6s1z647KssbatTxBUceT0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTvtM+lozTAbyDfQyqhuhYCmMMXeH1C86YvOzv7ah6hst6hFnywVy+e7BaMBFxr4QBhEDWZCy4xRD5AKDheiFjiHmGh/bY51ud9IrirPcSixSpQuYPfZjTJDGJk+TH7MGk/rwGzkB53DFrKXg9rJ58V5rsJuCexQQERtUxk+tKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fiz8Kc+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fiz8Kc+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D82CC4CED1;
	Tue,  8 Oct 2024 13:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392787;
	bh=2t2uShpQt0e2sHtZcWcrX6s1z647KssbatTxBUceT0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fiz8Kc+gpGP/IYTuoGtHBk4k5bJweqyT7VHDoMjzl9TAGH7auHW8B7cBX5S3gd93T
	 hooWUQCOl9RuHULKf3MJgPeDIIUv5E1rCD4qXTOoC+RPSrHoa9zAPcp5JLj9WIyup/
	 ybB2/+5SqHilqi9QXXG+jbNn72z8khP/zAty0zVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asahi Lina <lina@asahilina.net>,
	Rob Clark <robdclark@chromium.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Janne Grunau <j@jannau.net>
Subject: [PATCH 6.11 520/558] drm/sched: Fix dynamic job-flow control race
Date: Tue,  8 Oct 2024 14:09:10 +0200
Message-ID: <20241008115722.691612010@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

commit 440d52b370b03b366fd26ace36bab20552116145 upstream.

Fixes a race condition reported here: https://github.com/AsahiLinux/linux/issues/309#issuecomment-2238968609

The whole premise of lockless access to a single-producer-single-
consumer queue is that there is just a single producer and single
consumer.  That means we can't call drm_sched_can_queue() (which is
about queueing more work to the hw, not to the spsc queue) from
anywhere other than the consumer (wq).

This call in the producer is just an optimization to avoid scheduling
the consuming worker if it cannot yet queue more work to the hw.  It
is safe to drop this optimization to avoid the race condition.

Suggested-by: Asahi Lina <lina@asahilina.net>
Fixes: a78422e9dff3 ("drm/sched: implement dynamic job-flow control")
Closes: https://github.com/AsahiLinux/linux/issues/309
Cc: stable@vger.kernel.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Tested-by: Janne Grunau <j@jannau.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240913202301.16772-1-robdclark@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c |    4 ++--
 drivers/gpu/drm/scheduler/sched_main.c   |    7 ++-----
 include/drm/gpu_scheduler.h              |    2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -380,7 +380,7 @@ static void drm_sched_entity_wakeup(stru
 		container_of(cb, struct drm_sched_entity, cb);
 
 	drm_sched_entity_clear_dep(f, cb);
-	drm_sched_wakeup(entity->rq->sched, entity);
+	drm_sched_wakeup(entity->rq->sched);
 }
 
 /**
@@ -612,7 +612,7 @@ void drm_sched_entity_push_job(struct dr
 		if (drm_sched_policy == DRM_SCHED_POLICY_FIFO)
 			drm_sched_rq_update_fifo(entity, submit_ts);
 
-		drm_sched_wakeup(entity->rq->sched, entity);
+		drm_sched_wakeup(entity->rq->sched);
 	}
 }
 EXPORT_SYMBOL(drm_sched_entity_push_job);
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -1022,15 +1022,12 @@ EXPORT_SYMBOL(drm_sched_job_cleanup);
 /**
  * drm_sched_wakeup - Wake up the scheduler if it is ready to queue
  * @sched: scheduler instance
- * @entity: the scheduler entity
  *
  * Wake up the scheduler if we can queue jobs.
  */
-void drm_sched_wakeup(struct drm_gpu_scheduler *sched,
-		      struct drm_sched_entity *entity)
+void drm_sched_wakeup(struct drm_gpu_scheduler *sched)
 {
-	if (drm_sched_can_queue(sched, entity))
-		drm_sched_run_job_queue(sched);
+	drm_sched_run_job_queue(sched);
 }
 
 /**
--- a/include/drm/gpu_scheduler.h
+++ b/include/drm/gpu_scheduler.h
@@ -574,7 +574,7 @@ void drm_sched_entity_modify_sched(struc
 
 void drm_sched_tdr_queue_imm(struct drm_gpu_scheduler *sched);
 void drm_sched_job_cleanup(struct drm_sched_job *job);
-void drm_sched_wakeup(struct drm_gpu_scheduler *sched, struct drm_sched_entity *entity);
+void drm_sched_wakeup(struct drm_gpu_scheduler *sched);
 bool drm_sched_wqueue_ready(struct drm_gpu_scheduler *sched);
 void drm_sched_wqueue_stop(struct drm_gpu_scheduler *sched);
 void drm_sched_wqueue_start(struct drm_gpu_scheduler *sched);


