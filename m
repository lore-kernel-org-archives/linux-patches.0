Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444D51FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4E3C433C8;
	Tue,  1 Aug 2023 09:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883110;
	bh=KLrhwMPnhrz98PT6DSU5P0cEV1CnSIpKhRS+Uo0k6vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzfnRDOo17ggETFqoLvbY4zQOOueea449YJ1hxkwqkh6/y/Abztnl5GKzZDMQTXRb
	 wVLJw1weACJlApaceUvMe+xMn5snsx47av7erpM4egB6xbkmc79hfRCuEHEovTlZb6
	 BmWmBYTVOAmxkHLOsKb6+ilVtTliTUCPpeH3H5NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 118/239] drm/msm: Fix hw_fence error path cleanup
Date: Tue,  1 Aug 2023 11:19:42 +0200
Message-ID: <20230801091929.982987496@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 1cd0787f082e1a179f2b6e749d08daff1a9f6b1b ]

In an error path where the submit is free'd without the job being run,
the hw_fence pointer is simply a kzalloc'd block of memory.  In this
case we should just kfree() it, rather than trying to decrement it's
reference count.  Fortunately we can tell that this is the case by
checking for a zero refcount, since if the job was run, the submit would
be holding a reference to the hw_fence.

Fixes: f94e6a51e17c ("drm/msm: Pre-allocate hw_fence")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/547088/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_fence.c      |  6 ++++++
 drivers/gpu/drm/msm/msm_gem_submit.c | 14 +++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_fence.c b/drivers/gpu/drm/msm/msm_fence.c
index 96599ec3eb783..1a5d4f1c8b422 100644
--- a/drivers/gpu/drm/msm/msm_fence.c
+++ b/drivers/gpu/drm/msm/msm_fence.c
@@ -191,6 +191,12 @@ msm_fence_init(struct dma_fence *fence, struct msm_fence_context *fctx)
 
 	f->fctx = fctx;
 
+	/*
+	 * Until this point, the fence was just some pre-allocated memory,
+	 * no-one should have taken a reference to it yet.
+	 */
+	WARN_ON(kref_read(&fence->refcount));
+
 	dma_fence_init(&f->base, &msm_fence_ops, &fctx->spinlock,
 		       fctx->context, ++fctx->last_fence);
 }
diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 9f5933c75e3df..10cad7b99bac8 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -86,7 +86,19 @@ void __msm_gem_submit_destroy(struct kref *kref)
 	}
 
 	dma_fence_put(submit->user_fence);
-	dma_fence_put(submit->hw_fence);
+
+	/*
+	 * If the submit is freed before msm_job_run(), then hw_fence is
+	 * just some pre-allocated memory, not a reference counted fence.
+	 * Once the job runs and the hw_fence is initialized, it will
+	 * have a refcount of at least one, since the submit holds a ref
+	 * to the hw_fence.
+	 */
+	if (kref_read(&submit->hw_fence->refcount) == 0) {
+		kfree(submit->hw_fence);
+	} else {
+		dma_fence_put(submit->hw_fence);
+	}
 
 	put_pid(submit->pid);
 	msm_submitqueue_put(submit->queue);
-- 
2.40.1



