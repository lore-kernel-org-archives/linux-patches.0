Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E8C42A9B;
	Tue, 27 May 2025 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367661; cv=none; b=SEd3FiBVYmSgfL/kpk0IYQjosnwR3+WgsbI6kCLJ8fU9cxb+hq4QOauS11Bb/wzRWDhe70biHF+PRw09dEejGncdVCn/BGx1Z7+t+H14Vicc5KqLKPRhCJo5UBUehdQsVbljgQDVlDIfuUwH4SajhFOJVPNpdjRw4fjmdXJ++6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367661; c=relaxed/simple;
	bh=s6nUcxdD5ove/9iFwCXN+WpXgENS6ZEupdVk8gRHeEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adPTxTqmcbJ+vygPSB0JfFZjrOdpZvTG24+6V+2uKw+jIfYSn66LzY87lvM737po+QuJzLD4FmArNSnw4VV++P1CqbzSNgYWVc9BitU0y6YetG0wJpbb5dov+2Qu0BasCMeaBIuxSeUPoTYNpC5bUwqDyHD7geiXjJ3KrDRu8MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjfdRFTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjfdRFTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A774FC4CEE9;
	Tue, 27 May 2025 17:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367661;
	bh=s6nUcxdD5ove/9iFwCXN+WpXgENS6ZEupdVk8gRHeEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjfdRFTTjy6OOb5+QGezaWacbftgKOM1CMwpJwG+iv9xOYtgSjHB8tOjki2rZieRE
	 5C8Ot1OVFmFgfbrnvQU5FXo6CZoWh2eeXCdz6ukUtsnpeX9NApyWyJfy6ufCEE9481
	 jmHyw5CzqaHGpgg6auezXWDIaGjmdFv63BW3i1Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 459/783] accel/amdxdna: Refactor hardware context destroy routine
Date: Tue, 27 May 2025 18:24:16 +0200
Message-ID: <20250527162531.821290120@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 4fd6ca90fc7f509977585d39885f21b2911123f3 ]

It is required by firmware to wait up to 2 seconds for pending commands
before sending the destroy hardware context command. After 2 seconds
wait, if there are still pending commands, driver needs to cancel them.

So the context destroy steps need to be:
  1. Stop drm scheduler. (drm_sched_entity_destroy)
  2. Wait up to 2 seconds for pending commands.
  3. Destroy hardware context and cancel the rest pending requests.
  4. Wait all jobs associated with the hwctx are freed.
  5. Free job resources.

Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250124173536.148676-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c    | 29 ++++++++++++++++-------------
 drivers/accel/amdxdna/amdxdna_ctx.c |  2 ++
 drivers/accel/amdxdna/amdxdna_ctx.h |  3 +++
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 5f43db02b2404..92c768b0c9a03 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -34,6 +34,8 @@ static void aie2_job_release(struct kref *ref)
 
 	job = container_of(ref, struct amdxdna_sched_job, refcnt);
 	amdxdna_sched_job_cleanup(job);
+	atomic64_inc(&job->hwctx->job_free_cnt);
+	wake_up(&job->hwctx->priv->job_free_wq);
 	if (job->out_fence)
 		dma_fence_put(job->out_fence);
 	kfree(job);
@@ -134,7 +136,8 @@ static void aie2_hwctx_wait_for_idle(struct amdxdna_hwctx *hwctx)
 	if (!fence)
 		return;
 
-	dma_fence_wait(fence, false);
+	/* Wait up to 2 seconds for fw to finish all pending requests */
+	dma_fence_wait_timeout(fence, false, msecs_to_jiffies(2000));
 	dma_fence_put(fence);
 }
 
@@ -616,6 +619,7 @@ int aie2_hwctx_init(struct amdxdna_hwctx *hwctx)
 	hwctx->status = HWCTX_STAT_INIT;
 	ndev = xdna->dev_handle;
 	ndev->hwctx_num++;
+	init_waitqueue_head(&priv->job_free_wq);
 
 	XDNA_DBG(xdna, "hwctx %s init completed", hwctx->name);
 
@@ -652,25 +656,23 @@ void aie2_hwctx_fini(struct amdxdna_hwctx *hwctx)
 	xdna = hwctx->client->xdna;
 	ndev = xdna->dev_handle;
 	ndev->hwctx_num--;
-	drm_sched_wqueue_stop(&hwctx->priv->sched);
 
-	/* Now, scheduler will not send command to device. */
+	XDNA_DBG(xdna, "%s sequence number %lld", hwctx->name, hwctx->priv->seq);
+	drm_sched_entity_destroy(&hwctx->priv->entity);
+
+	aie2_hwctx_wait_for_idle(hwctx);
+
+	/* Request fw to destroy hwctx and cancel the rest pending requests */
 	aie2_release_resource(hwctx);
 
-	/*
-	 * All submitted commands are aborted.
-	 * Restart scheduler queues to cleanup jobs. The amdxdna_sched_job_run()
-	 * will return NODEV if it is called.
-	 */
-	drm_sched_wqueue_start(&hwctx->priv->sched);
+	/* Wait for all submitted jobs to be completed or canceled */
+	wait_event(hwctx->priv->job_free_wq,
+		   atomic64_read(&hwctx->job_submit_cnt) ==
+		   atomic64_read(&hwctx->job_free_cnt));
 
-	aie2_hwctx_wait_for_idle(hwctx);
-	drm_sched_entity_destroy(&hwctx->priv->entity);
 	drm_sched_fini(&hwctx->priv->sched);
 	aie2_ctx_syncobj_destroy(hwctx);
 
-	XDNA_DBG(xdna, "%s sequence number %lld", hwctx->name, hwctx->priv->seq);
-
 	for (idx = 0; idx < ARRAY_SIZE(hwctx->priv->cmd_buf); idx++)
 		drm_gem_object_put(to_gobj(hwctx->priv->cmd_buf[idx]));
 	amdxdna_gem_unpin(hwctx->priv->heap);
@@ -879,6 +881,7 @@ int aie2_cmd_submit(struct amdxdna_hwctx *hwctx, struct amdxdna_sched_job *job,
 	drm_gem_unlock_reservations(job->bos, job->bo_cnt, &acquire_ctx);
 
 	aie2_job_put(job);
+	atomic64_inc(&hwctx->job_submit_cnt);
 
 	return 0;
 
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index d11b1c83d9c3b..43442b9e273b3 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -220,6 +220,8 @@ int amdxdna_drm_create_hwctx_ioctl(struct drm_device *dev, void *data, struct dr
 	args->syncobj_handle = hwctx->syncobj_hdl;
 	mutex_unlock(&xdna->dev_lock);
 
+	atomic64_set(&hwctx->job_submit_cnt, 0);
+	atomic64_set(&hwctx->job_free_cnt, 0);
 	XDNA_DBG(xdna, "PID %d create HW context %d, ret %d", client->pid, args->handle, ret);
 	drm_dev_exit(idx);
 	return 0;
diff --git a/drivers/accel/amdxdna/amdxdna_ctx.h b/drivers/accel/amdxdna/amdxdna_ctx.h
index 80b0304193ec3..f0a4a8586d858 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.h
+++ b/drivers/accel/amdxdna/amdxdna_ctx.h
@@ -87,6 +87,9 @@ struct amdxdna_hwctx {
 	struct amdxdna_qos_info		     qos;
 	struct amdxdna_hwctx_param_config_cu *cus;
 	u32				syncobj_hdl;
+
+	atomic64_t			job_submit_cnt;
+	atomic64_t			job_free_cnt ____cacheline_aligned_in_smp;
 };
 
 #define drm_job_to_xdna_job(j) \
-- 
2.39.5



