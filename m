Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C9A1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68010C433D6;
	Wed, 23 Nov 2022 09:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196437;
	bh=KztOp8qiQQ6o2p8/9EWNV2l4Add6B6H4zZ667ATuFoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxYBiut72tzC48X8MbwyVMIFpix65Z6En0nOTn14nKJKFGE8L5ydpV8BmHBT+nQfI
	 XfU2i88TQeYxDY3p7JBFyqXZ0bdFt4BQirkjSqxmbD3VEryLAg59Jn0z1p9D220Mhf
	 5pLI8rnrgWxAxq59kkZU/FtC/Udl5G7Ngoe79fxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 030/314] drm/scheduler: fix fence ref counting
Date: Wed, 23 Nov 2022 09:47:55 +0100
Message-Id: <20221123084626.888062675@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian König <christian.koenig@amd.com>

[ Upstream commit b3af84383e7abdc5e63435817bb73a268e7c3637 ]

We leaked dependency fences when processes were beeing killed.

Additional to that grab a reference to the last scheduled fence.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220929180151.139751-1-christian.koenig@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 6b25b2f4f5a3..7ef1a086a6fb 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -207,6 +207,7 @@ static void drm_sched_entity_kill_jobs_cb(struct dma_fence *f,
 	struct drm_sched_job *job = container_of(cb, struct drm_sched_job,
 						 finish_cb);
 
+	dma_fence_put(f);
 	INIT_WORK(&job->work, drm_sched_entity_kill_jobs_work);
 	schedule_work(&job->work);
 }
@@ -234,8 +235,10 @@ static void drm_sched_entity_kill_jobs(struct drm_sched_entity *entity)
 		struct drm_sched_fence *s_fence = job->s_fence;
 
 		/* Wait for all dependencies to avoid data corruptions */
-		while ((f = drm_sched_job_dependency(job, entity)))
+		while ((f = drm_sched_job_dependency(job, entity))) {
 			dma_fence_wait(f, false);
+			dma_fence_put(f);
+		}
 
 		drm_sched_fence_scheduled(s_fence);
 		dma_fence_set_error(&s_fence->finished, -ESRCH);
@@ -250,6 +253,7 @@ static void drm_sched_entity_kill_jobs(struct drm_sched_entity *entity)
 			continue;
 		}
 
+		dma_fence_get(entity->last_scheduled);
 		r = dma_fence_add_callback(entity->last_scheduled,
 					   &job->finish_cb,
 					   drm_sched_entity_kill_jobs_cb);
-- 
2.35.1



