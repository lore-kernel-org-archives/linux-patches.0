Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639861779B1;
	Tue,  8 Oct 2024 12:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390934; cv=none; b=YwgA8kken8AueIfgdoGAeOewahT8zTKKQ0hz1wWTrd4V4yn8nBkv5Ee/J9vZaPPWHLwCgaKrvbeOOCGCN9sR8H/qqtGLMCU5ulzJuaAqYe/8Ftt7JSjma0XLhNidycmMKjnI8mvF9sEQs6jbYbqcog7sLIjzXw9/Zgt866UMbNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390934; c=relaxed/simple;
	bh=V7btzH06HqdZ6IZoGYKWpayy3s4rPn99jtAJ+lsbQ0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkmXMINZZfWC7z4/hq7kuQIwBMg9Ds8K54uY/5HkkK4/wKYoSlm5fDEio+rnhG4W4QDJI8UDB5zfZoQ1A8HzJrZmvjRSreyL2BKwYqEXiXLk4QBB/Pg9r2sFulQr5DEhsEZVA4eziiBtsrHH27JXPJq55Ad+54GR0kRBEXxh3O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngsj07lw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngsj07lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0D7C4CEC7;
	Tue,  8 Oct 2024 12:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390934;
	bh=V7btzH06HqdZ6IZoGYKWpayy3s4rPn99jtAJ+lsbQ0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngsj07lwvMwCFN0K47YdcvSX70MhmYrLqZZwSzyvl7z/25iZfa8/gKLyATYISM4qW
	 EOdPWwEHWnANkixbZgXlpjtvLs550OHEVA8Oxv0x6NK/Pz2ozEy6cTXyA70wbZf/2w
	 +vOPx6v/7Ows5xSeUCAjKEU4AUpFtCHlQpzRDlPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asahi Lina <lina@asahilina.net>,
	Rob Clark <robdclark@chromium.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Janne Grunau <j@jannau.net>
Subject: [PATCH 6.10 439/482] drm/sched: Fix dynamic job-flow control race
Date: Tue,  8 Oct 2024 14:08:22 +0200
Message-ID: <20241008115705.799383822@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/scheduler/sched_entity.c | 4 ++--
 drivers/gpu/drm/scheduler/sched_main.c   | 7 ++-----
 include/drm/gpu_scheduler.h              | 2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 58c8161289fe..567e5ace6d0c 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -380,7 +380,7 @@ static void drm_sched_entity_wakeup(struct dma_fence *f,
 		container_of(cb, struct drm_sched_entity, cb);
 
 	drm_sched_entity_clear_dep(f, cb);
-	drm_sched_wakeup(entity->rq->sched, entity);
+	drm_sched_wakeup(entity->rq->sched);
 }
 
 /**
@@ -612,7 +612,7 @@ void drm_sched_entity_push_job(struct drm_sched_job *sched_job)
 		if (drm_sched_policy == DRM_SCHED_POLICY_FIFO)
 			drm_sched_rq_update_fifo(entity, submit_ts);
 
-		drm_sched_wakeup(entity->rq->sched, entity);
+		drm_sched_wakeup(entity->rq->sched);
 	}
 }
 EXPORT_SYMBOL(drm_sched_entity_push_job);
diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index 7e90c9f95611..a124d5e77b5e 100644
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
diff --git a/include/drm/gpu_scheduler.h b/include/drm/gpu_scheduler.h
index 5acc64954a88..e28bc649b5c9 100644
--- a/include/drm/gpu_scheduler.h
+++ b/include/drm/gpu_scheduler.h
@@ -574,7 +574,7 @@ void drm_sched_entity_modify_sched(struct drm_sched_entity *entity,
 
 void drm_sched_tdr_queue_imm(struct drm_gpu_scheduler *sched);
 void drm_sched_job_cleanup(struct drm_sched_job *job);
-void drm_sched_wakeup(struct drm_gpu_scheduler *sched, struct drm_sched_entity *entity);
+void drm_sched_wakeup(struct drm_gpu_scheduler *sched);
 bool drm_sched_wqueue_ready(struct drm_gpu_scheduler *sched);
 void drm_sched_wqueue_stop(struct drm_gpu_scheduler *sched);
 void drm_sched_wqueue_start(struct drm_gpu_scheduler *sched);
-- 
2.46.2



