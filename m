Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD942528EE;
	Wed,  5 Mar 2025 18:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198091; cv=none; b=OntRUN0mk8KhOen7p3Y5r6doxLmiv0zvRdDWhSBX4ROUtNRnOu/Huo3ZLxGDoysjvsJ7yh/fISOsY5H5k3d+wyIIirC1XxlSbGW6sWboMvnlzIMzERl0wur84jCpRGSBuhVnTjDfzQOGicQB7N/P5Wd/h7dH6iyBz4ALC3gqjng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198091; c=relaxed/simple;
	bh=cjNY5J9iTKHNejXGAp6mBP2q3gBl/zAeRI/ImkcYK+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evgtDZ9wFjGu7sWAuJGGiSFTCYYbszxDp4LzbQhPADvOXyiCBiDVUg66+1rjNpxXzU0e+BO7g9Wugsex6kE/h0ucGqOUkt1PpL4/TtsZE2xF2h7i4AbHsx3zm47BvXsRxuRu3MN8vYxl1qFbqnpvrKMTXGscIZXMtZfdgBgbeJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FM6kKC77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FM6kKC77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379D2C4CED1;
	Wed,  5 Mar 2025 18:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198091;
	bh=cjNY5J9iTKHNejXGAp6mBP2q3gBl/zAeRI/ImkcYK+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FM6kKC77eXoNnNDDVCF4A4Fg5nF5aPvYLfcmCBiFBG3kWIV+CJyVXX84LkxEHHJvV
	 do1qFdl/0ZW8cyZ58RO90/XpbY+RPb7lh3PsjzK2VOkNsZ5rmjM18RY4+xAZjvGU3s
	 QHEsE5vGcAJjjg8vflJwRzc3ewpa+rKQXw9tV+Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/150] drm/xe/oa: Signal output fences
Date: Wed,  5 Mar 2025 18:47:53 +0100
Message-ID: <20250305174505.593715694@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit 343dd246fd9b58e67b395153e8e7298bd250f943 ]

Introduce 'struct xe_oa_fence' which includes the dma_fence used to signal
output fences in the xe_sync array. The fences are signaled
asynchronously. When there are no output fences to signal, the OA
configuration wait is synchronously re-introduced into the ioctl.

v2: Don't wait in the work, use callback + delayed work (Matt B)
    Use a single, not a per-fence spinlock (Matt Brost)
v3: Move ofence alloc before job submission (Matt)
    Assert, don't fail, from dma_fence_add_callback (Matt)
    Additional dma_fence_get for dma_fence_wait (Matt)
    Change dma_fence_wait to non-interruptible (Matt)
v4: Introduce last_fence to prevent uaf if stream is closed with
    pending OA config jobs
v5: Remove oa_fence_lock, move spinlock back into xe_oa_fence to
    prevent uaf

Suggested-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241022200352.1192560-5-ashutosh.dixit@intel.com
Stable-dep-of: 5bd566703e16 ("drm/xe/oa: Allow oa_exponent value of 0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c       | 119 ++++++++++++++++++++++++++-----
 drivers/gpu/drm/xe/xe_oa_types.h |   3 +
 2 files changed, 105 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index e6744422dee49..a54098c1a944a 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -94,6 +94,17 @@ struct xe_oa_config_bo {
 	struct xe_bb *bb;
 };
 
+struct xe_oa_fence {
+	/* @base: dma fence base */
+	struct dma_fence base;
+	/* @lock: lock for the fence */
+	spinlock_t lock;
+	/* @work: work to signal @base */
+	struct delayed_work work;
+	/* @cb: callback to schedule @work */
+	struct dma_fence_cb cb;
+};
+
 #define DRM_FMT(x) DRM_XE_OA_FMT_TYPE_##x
 
 static const struct xe_oa_format oa_formats[] = {
@@ -166,10 +177,10 @@ static struct xe_oa_config *xe_oa_get_oa_config(struct xe_oa *oa, int metrics_se
 	return oa_config;
 }
 
-static void free_oa_config_bo(struct xe_oa_config_bo *oa_bo)
+static void free_oa_config_bo(struct xe_oa_config_bo *oa_bo, struct dma_fence *last_fence)
 {
 	xe_oa_config_put(oa_bo->oa_config);
-	xe_bb_free(oa_bo->bb, NULL);
+	xe_bb_free(oa_bo->bb, last_fence);
 	kfree(oa_bo);
 }
 
@@ -668,7 +679,8 @@ static void xe_oa_free_configs(struct xe_oa_stream *stream)
 
 	xe_oa_config_put(stream->oa_config);
 	llist_for_each_entry_safe(oa_bo, tmp, stream->oa_config_bos.first, node)
-		free_oa_config_bo(oa_bo);
+		free_oa_config_bo(oa_bo, stream->last_fence);
+	dma_fence_put(stream->last_fence);
 }
 
 static int xe_oa_load_with_lri(struct xe_oa_stream *stream, struct xe_oa_reg *reg_lri, u32 count)
@@ -902,40 +914,113 @@ xe_oa_alloc_config_buffer(struct xe_oa_stream *stream, struct xe_oa_config *oa_c
 	return oa_bo;
 }
 
+static void xe_oa_update_last_fence(struct xe_oa_stream *stream, struct dma_fence *fence)
+{
+	dma_fence_put(stream->last_fence);
+	stream->last_fence = dma_fence_get(fence);
+}
+
+static void xe_oa_fence_work_fn(struct work_struct *w)
+{
+	struct xe_oa_fence *ofence = container_of(w, typeof(*ofence), work.work);
+
+	/* Signal fence to indicate new OA configuration is active */
+	dma_fence_signal(&ofence->base);
+	dma_fence_put(&ofence->base);
+}
+
+static void xe_oa_config_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
+{
+	/* Additional empirical delay needed for NOA programming after registers are written */
+#define NOA_PROGRAM_ADDITIONAL_DELAY_US 500
+
+	struct xe_oa_fence *ofence = container_of(cb, typeof(*ofence), cb);
+
+	INIT_DELAYED_WORK(&ofence->work, xe_oa_fence_work_fn);
+	queue_delayed_work(system_unbound_wq, &ofence->work,
+			   usecs_to_jiffies(NOA_PROGRAM_ADDITIONAL_DELAY_US));
+	dma_fence_put(fence);
+}
+
+static const char *xe_oa_get_driver_name(struct dma_fence *fence)
+{
+	return "xe_oa";
+}
+
+static const char *xe_oa_get_timeline_name(struct dma_fence *fence)
+{
+	return "unbound";
+}
+
+static const struct dma_fence_ops xe_oa_fence_ops = {
+	.get_driver_name = xe_oa_get_driver_name,
+	.get_timeline_name = xe_oa_get_timeline_name,
+};
+
 static int xe_oa_emit_oa_config(struct xe_oa_stream *stream, struct xe_oa_config *config)
 {
 #define NOA_PROGRAM_ADDITIONAL_DELAY_US 500
 	struct xe_oa_config_bo *oa_bo;
-	int err = 0, us = NOA_PROGRAM_ADDITIONAL_DELAY_US;
+	struct xe_oa_fence *ofence;
+	int i, err, num_signal = 0;
 	struct dma_fence *fence;
-	long timeout;
 
-	/* Emit OA configuration batch */
+	ofence = kzalloc(sizeof(*ofence), GFP_KERNEL);
+	if (!ofence) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
 	oa_bo = xe_oa_alloc_config_buffer(stream, config);
 	if (IS_ERR(oa_bo)) {
 		err = PTR_ERR(oa_bo);
 		goto exit;
 	}
 
+	/* Emit OA configuration batch */
 	fence = xe_oa_submit_bb(stream, XE_OA_SUBMIT_ADD_DEPS, oa_bo->bb);
 	if (IS_ERR(fence)) {
 		err = PTR_ERR(fence);
 		goto exit;
 	}
 
-	/* Wait till all previous batches have executed */
-	timeout = dma_fence_wait_timeout(fence, false, 5 * HZ);
-	dma_fence_put(fence);
-	if (timeout < 0)
-		err = timeout;
-	else if (!timeout)
-		err = -ETIME;
-	if (err)
-		drm_dbg(&stream->oa->xe->drm, "dma_fence_wait_timeout err %d\n", err);
+	/* Point of no return: initialize and set fence to signal */
+	spin_lock_init(&ofence->lock);
+	dma_fence_init(&ofence->base, &xe_oa_fence_ops, &ofence->lock, 0, 0);
 
-	/* Additional empirical delay needed for NOA programming after registers are written */
-	usleep_range(us, 2 * us);
+	for (i = 0; i < stream->num_syncs; i++) {
+		if (stream->syncs[i].flags & DRM_XE_SYNC_FLAG_SIGNAL)
+			num_signal++;
+		xe_sync_entry_signal(&stream->syncs[i], &ofence->base);
+	}
+
+	/* Additional dma_fence_get in case we dma_fence_wait */
+	if (!num_signal)
+		dma_fence_get(&ofence->base);
+
+	/* Update last fence too before adding callback */
+	xe_oa_update_last_fence(stream, fence);
+
+	/* Add job fence callback to schedule work to signal ofence->base */
+	err = dma_fence_add_callback(fence, &ofence->cb, xe_oa_config_cb);
+	xe_gt_assert(stream->gt, !err || err == -ENOENT);
+	if (err == -ENOENT)
+		xe_oa_config_cb(fence, &ofence->cb);
+
+	/* If nothing needs to be signaled we wait synchronously */
+	if (!num_signal) {
+		dma_fence_wait(&ofence->base, false);
+		dma_fence_put(&ofence->base);
+	}
+
+	/* Done with syncs */
+	for (i = 0; i < stream->num_syncs; i++)
+		xe_sync_entry_cleanup(&stream->syncs[i]);
+	kfree(stream->syncs);
+
+	return 0;
 exit:
+	kfree(ofence);
 	return err;
 }
 
diff --git a/drivers/gpu/drm/xe/xe_oa_types.h b/drivers/gpu/drm/xe/xe_oa_types.h
index 99f4b2d4bdcf6..c8e0df13faf83 100644
--- a/drivers/gpu/drm/xe/xe_oa_types.h
+++ b/drivers/gpu/drm/xe/xe_oa_types.h
@@ -239,6 +239,9 @@ struct xe_oa_stream {
 	/** @no_preempt: Whether preemption and timeslicing is disabled for stream exec_q */
 	u32 no_preempt;
 
+	/** @last_fence: fence to use in stream destroy when needed */
+	struct dma_fence *last_fence;
+
 	/** @num_syncs: size of @syncs array */
 	u32 num_syncs;
 
-- 
2.39.5



