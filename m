Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C531C68BE;
	Tue, 27 Aug 2024 14:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770614; cv=none; b=DAoVl53R9n7DwsLQ+X+FANebLA9vbNNMOUA08bjheXZ1P/h9401QoXXls+3BhsB2QB4GKEoHgJR3BHMavur2nIVoxsQtZm4+7BWxFHNz436ZCFZJNicclNHIyxO66lZ+Q4Sygg9UA6ET95Wyl92n9O6j0TOntKN1b9V9eNdoa54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770614; c=relaxed/simple;
	bh=9i/8yPkck6X9jYfipxL5Xr81K1MNH5GZVDeU+iGKPWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWfjNF9hbEWuIbJWRjXqLkqlihoIXjpcWeVSun0e+9kr6nBtPGp+gCUSrxketWoJnixvNJuDH4EzzKVAGUGWJA+9TeTlpBypw2v4vjAWnkdU15Bd0MBjNJE++bKLo5wsnqdZF5pLC2K5yZH6YnwGFBVf/kJeXeNLKR4rT321jAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOs5SUAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOs5SUAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A282DC4FE02;
	Tue, 27 Aug 2024 14:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770614;
	bh=9i/8yPkck6X9jYfipxL5Xr81K1MNH5GZVDeU+iGKPWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOs5SUAEuUDHD+0WrZItlP68In7bfs212/YLf1twVRCT50Ooe58gSX7VVza0d3VhI
	 lt7rEMTfE9oCrUJGEH4F9YfBZ6mIOrNPztMFt2cjH5PwoByeDZNjb5kxrm07zMqmmp
	 SoZ//3yxgI7dd3+BsC0gm3EbY6SwetF+qTely6HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 281/341] drm/msm/dpu: split dpu_encoder_wait_for_event into two functions
Date: Tue, 27 Aug 2024 16:38:32 +0200
Message-ID: <20240827143854.092666834@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d72a3d35b7ef5a3c0260462f130fa3dd7576aa2f ]

Stop multiplexing several events via the dpu_encoder_wait_for_event()
function. Split it into two distinct functions two allow separate
handling of those events.

Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/579848/
Link: https://lore.kernel.org/r/20240226-fd-dpu-debug-timeout-v4-2-51eec83dde23@linaro.org
Stable-dep-of: aedf02e46eb5 ("drm/msm/dpu: move dpu_encoder's connector assignment to atomic_enable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 70 +++++++++++++++------
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.h | 22 +------
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c     |  2 +-
 drivers/gpu/drm/msm/msm_drv.h               | 10 ---
 4 files changed, 55 insertions(+), 49 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 57001543dc220..ba60997350890 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1265,7 +1265,7 @@ static void dpu_encoder_virt_atomic_disable(struct drm_encoder *drm_enc,
 	trace_dpu_enc_disable(DRMID(drm_enc));
 
 	/* wait for idle */
-	dpu_encoder_wait_for_event(drm_enc, MSM_ENC_TX_COMPLETE);
+	dpu_encoder_wait_for_tx_complete(drm_enc);
 
 	dpu_encoder_resource_control(drm_enc, DPU_ENC_RC_EVENT_PRE_STOP);
 
@@ -2417,10 +2417,18 @@ struct drm_encoder *dpu_encoder_init(struct drm_device *dev,
 	return ERR_PTR(ret);
 }
 
-int dpu_encoder_wait_for_event(struct drm_encoder *drm_enc,
-	enum msm_event_wait event)
+/**
+ * dpu_encoder_wait_for_commit_done() - Wait for encoder to flush pending state
+ * @drm_enc:	encoder pointer
+ *
+ * Wait for hardware to have flushed the current pending changes to hardware at
+ * a vblank or CTL_START. Physical encoders will map this differently depending
+ * on the type: vid mode -> vsync_irq, cmd mode -> CTL_START.
+ *
+ * Return: 0 on success, -EWOULDBLOCK if already signaled, error otherwise
+ */
+int dpu_encoder_wait_for_commit_done(struct drm_encoder *drm_enc)
 {
-	int (*fn_wait)(struct dpu_encoder_phys *phys_enc) = NULL;
 	struct dpu_encoder_virt *dpu_enc = NULL;
 	int i, ret = 0;
 
@@ -2434,23 +2442,47 @@ int dpu_encoder_wait_for_event(struct drm_encoder *drm_enc,
 	for (i = 0; i < dpu_enc->num_phys_encs; i++) {
 		struct dpu_encoder_phys *phys = dpu_enc->phys_encs[i];
 
-		switch (event) {
-		case MSM_ENC_COMMIT_DONE:
-			fn_wait = phys->ops.wait_for_commit_done;
-			break;
-		case MSM_ENC_TX_COMPLETE:
-			fn_wait = phys->ops.wait_for_tx_complete;
-			break;
-		default:
-			DPU_ERROR_ENC(dpu_enc, "unknown wait event %d\n",
-					event);
-			return -EINVAL;
+		if (phys->ops.wait_for_commit_done) {
+			DPU_ATRACE_BEGIN("wait_for_commit_done");
+			ret = phys->ops.wait_for_commit_done(phys);
+			DPU_ATRACE_END("wait_for_commit_done");
+			if (ret)
+				return ret;
 		}
+	}
+
+	return ret;
+}
+
+/**
+ * dpu_encoder_wait_for_tx_complete() - Wait for encoder to transfer pixels to panel
+ * @drm_enc:	encoder pointer
+ *
+ * Wait for the hardware to transfer all the pixels to the panel. Physical
+ * encoders will map this differently depending on the type: vid mode -> vsync_irq,
+ * cmd mode -> pp_done.
+ *
+ * Return: 0 on success, -EWOULDBLOCK if already signaled, error otherwise
+ */
+int dpu_encoder_wait_for_tx_complete(struct drm_encoder *drm_enc)
+{
+	struct dpu_encoder_virt *dpu_enc = NULL;
+	int i, ret = 0;
+
+	if (!drm_enc) {
+		DPU_ERROR("invalid encoder\n");
+		return -EINVAL;
+	}
+	dpu_enc = to_dpu_encoder_virt(drm_enc);
+	DPU_DEBUG_ENC(dpu_enc, "\n");
+
+	for (i = 0; i < dpu_enc->num_phys_encs; i++) {
+		struct dpu_encoder_phys *phys = dpu_enc->phys_encs[i];
 
-		if (fn_wait) {
-			DPU_ATRACE_BEGIN("wait_for_completion_event");
-			ret = fn_wait(phys);
-			DPU_ATRACE_END("wait_for_completion_event");
+		if (phys->ops.wait_for_tx_complete) {
+			DPU_ATRACE_BEGIN("wait_for_tx_complete");
+			ret = phys->ops.wait_for_tx_complete(phys);
+			DPU_ATRACE_END("wait_for_tx_complete");
 			if (ret)
 				return ret;
 		}
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.h
index fe6b1d312a742..0c928d1876e4a 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.h
@@ -93,25 +93,9 @@ void dpu_encoder_kickoff(struct drm_encoder *encoder);
  */
 int dpu_encoder_vsync_time(struct drm_encoder *drm_enc, ktime_t *wakeup_time);
 
-/**
- * dpu_encoder_wait_for_event - Waits for encoder events
- * @encoder:	encoder pointer
- * @event:      event to wait for
- * MSM_ENC_COMMIT_DONE -  Wait for hardware to have flushed the current pending
- *                        frames to hardware at a vblank or ctl_start
- *                        Encoders will map this differently depending on the
- *                        panel type.
- *	                  vid mode -> vsync_irq
- *                        cmd mode -> ctl_start
- * MSM_ENC_TX_COMPLETE -  Wait for the hardware to transfer all the pixels to
- *                        the panel. Encoders will map this differently
- *                        depending on the panel type.
- *                        vid mode -> vsync_irq
- *                        cmd mode -> pp_done
- * Returns: 0 on success, -EWOULDBLOCK if already signaled, error otherwise
- */
-int dpu_encoder_wait_for_event(struct drm_encoder *drm_encoder,
-						enum msm_event_wait event);
+int dpu_encoder_wait_for_commit_done(struct drm_encoder *drm_encoder);
+
+int dpu_encoder_wait_for_tx_complete(struct drm_encoder *drm_encoder);
 
 /*
  * dpu_encoder_get_intf_mode - get interface mode of the given encoder
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index aa6ba2cf4b840..6ba289e04b3b2 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -490,7 +490,7 @@ static void dpu_kms_wait_for_commit_done(struct msm_kms *kms,
 		 * mode panels. This may be a no-op for command mode panels.
 		 */
 		trace_dpu_kms_wait_for_commit_done(DRMID(crtc));
-		ret = dpu_encoder_wait_for_event(encoder, MSM_ENC_COMMIT_DONE);
+		ret = dpu_encoder_wait_for_commit_done(encoder);
 		if (ret && ret != -EWOULDBLOCK) {
 			DPU_ERROR("wait for commit done returned %d\n", ret);
 			break;
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index 182543c92770c..48e1a8c6942c9 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -74,16 +74,6 @@ enum msm_dsi_controller {
 #define MSM_GPU_MAX_RINGS 4
 #define MAX_H_TILES_PER_DISPLAY 2
 
-/**
- * enum msm_event_wait - type of HW events to wait for
- * @MSM_ENC_COMMIT_DONE - wait for the driver to flush the registers to HW
- * @MSM_ENC_TX_COMPLETE - wait for the HW to transfer the frame to panel
- */
-enum msm_event_wait {
-	MSM_ENC_COMMIT_DONE = 0,
-	MSM_ENC_TX_COMPLETE,
-};
-
 /**
  * struct msm_display_topology - defines a display topology pipeline
  * @num_lm:       number of layer mixers used
-- 
2.43.0



