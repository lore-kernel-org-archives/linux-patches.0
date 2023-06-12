Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8C0134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C4BC4339C;
	Mon, 12 Jun 2023 10:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566801;
	bh=WqUrUtcP2fE168HiGqovFdjgfrPXFZ4Umq06F3U53X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUIKJ6xIwXAfbPTNrnJfblVjHtFfBixPjwMZOMxxDX2r5BYWGjtitYQV9yu+x1eQc
	 lXw+jsexPWlycGuqQK0pFo5F89uA8swYeae2TL3dyOFR38Skx33WINl1hVa+ByLf4N
	 f8bMPoQR0VcagixDinO65j1avKeutFe363apP5wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 036/160] accel/ivpu: Reserve all non-command bos using DMA_RESV_USAGE_BOOKKEEP
Date: Mon, 12 Jun 2023 12:26:08 +0200
Message-ID: <20230612101716.698581298@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>

[ Upstream commit 411360257c1f4fccaa20143098b6d3fcc9d4e4dc ]

Use DMA_RESV_USAGE_BOOKKEEP reservation for buffer objects, except for
command buffers for which we use DMA_RESV_USAGE_WRITE (since VPU can
write to command buffer context save area).

Fixes: 0ec8671837a6 ("accel/ivpu: Fix S3 system suspend when not idle")
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230413063810.3167511-1-stanislaw.gruszka@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_job.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_job.c b/drivers/accel/ivpu/ivpu_job.c
index 3c6f1e16cf2ff..d45be0615b476 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -431,6 +431,7 @@ ivpu_job_prepare_bos_for_submit(struct drm_file *file, struct ivpu_job *job, u32
 	struct ivpu_file_priv *file_priv = file->driver_priv;
 	struct ivpu_device *vdev = file_priv->vdev;
 	struct ww_acquire_ctx acquire_ctx;
+	enum dma_resv_usage usage;
 	struct ivpu_bo *bo;
 	int ret;
 	u32 i;
@@ -461,22 +462,28 @@ ivpu_job_prepare_bos_for_submit(struct drm_file *file, struct ivpu_job *job, u32
 
 	job->cmd_buf_vpu_addr = bo->vpu_addr + commands_offset;
 
-	ret = drm_gem_lock_reservations((struct drm_gem_object **)job->bos, 1, &acquire_ctx);
+	ret = drm_gem_lock_reservations((struct drm_gem_object **)job->bos, buf_count,
+					&acquire_ctx);
 	if (ret) {
 		ivpu_warn(vdev, "Failed to lock reservations: %d\n", ret);
 		return ret;
 	}
 
-	ret = dma_resv_reserve_fences(bo->base.resv, 1);
-	if (ret) {
-		ivpu_warn(vdev, "Failed to reserve fences: %d\n", ret);
-		goto unlock_reservations;
+	for (i = 0; i < buf_count; i++) {
+		ret = dma_resv_reserve_fences(job->bos[i]->base.resv, 1);
+		if (ret) {
+			ivpu_warn(vdev, "Failed to reserve fences: %d\n", ret);
+			goto unlock_reservations;
+		}
 	}
 
-	dma_resv_add_fence(bo->base.resv, job->done_fence, DMA_RESV_USAGE_WRITE);
+	for (i = 0; i < buf_count; i++) {
+		usage = (i == CMD_BUF_IDX) ? DMA_RESV_USAGE_WRITE : DMA_RESV_USAGE_BOOKKEEP;
+		dma_resv_add_fence(job->bos[i]->base.resv, job->done_fence, usage);
+	}
 
 unlock_reservations:
-	drm_gem_unlock_reservations((struct drm_gem_object **)job->bos, 1, &acquire_ctx);
+	drm_gem_unlock_reservations((struct drm_gem_object **)job->bos, buf_count, &acquire_ctx);
 
 	wmb(); /* Flush write combining buffers */
 
-- 
2.39.2



