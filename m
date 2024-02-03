Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C349F1CAB5;
	Sat,  3 Feb 2024 04:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933872; cv=none; b=gYsPMWKr1M+X2Us74UQ2l0ODhya90qCz+GyQN4p7MfZOsGAHxOrmFX1YTuQFMi9ku1DgttT8i3gDBsjrb/pQZ0gmO1GjamhC8XkHfmH4rFsoDPIO2z9Wru5mmOoWvMshTZgkvRIDcYGjElx6niOqCPGBRDcQ/8Ea1m34CW6IE88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933872; c=relaxed/simple;
	bh=9WtO6CmCQSpHQeO3uLDj1vKQmOhivknztVo6xvEMTmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYHk7v/tNLW3HNr1DAOpxcfUGnQc8qN/q3nowjpax3B5k11o2nE6Wb+Q/dO/jrz8/oKOPn/OCAOf8eOoqUIotJUCAR7Yew7uHN5UBRR1MzS5MWWtbkS7GQFwDRL6YNHkeblSiMbv+GJYdNDRGuQvKZewzbe7d4T+NL0Myf/NF9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDs9/rBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDs9/rBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A370C43390;
	Sat,  3 Feb 2024 04:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933872;
	bh=9WtO6CmCQSpHQeO3uLDj1vKQmOhivknztVo6xvEMTmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDs9/rBB1j6zdn7FYhxKP9Ylz/5idWRCyk4VDLXFbGkQk2NV6gfBWdbkKPTxLTjx1
	 +F4JBTCdZT8FXiR0EGtWvUg8E5Gjg+HZxbrDdT5U6u8R37AI02PhSVfA0NSmW0QsYW
	 Esl3UmuKJykvkxrabNaJ8UglKD9L0uT5r8R8h/4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paloma Arellano <quic_parellan@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 211/353] drm/msm/dpu: Add mutex lock in control vblank irq
Date: Fri,  2 Feb 2024 20:05:29 -0800
Message-ID: <20240203035410.374895574@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paloma Arellano <quic_parellan@quicinc.com>

[ Upstream commit 45284ff733e4caf6c118aae5131eb7e7cf3eea5a ]

Add a mutex lock to control vblank irq to synchronize vblank
enable/disable operations happening from different threads to prevent
race conditions while registering/unregistering the vblank irq callback.

v4: -Removed vblank_ctl_lock from dpu_encoder_virt, so it is only a
    parameter of dpu_encoder_phys.
    -Switch from atomic refcnt to a simple int counter as mutex has
    now been added
v3: Mistakenly did not change wording in last version. It is done now.
v2: Slightly changed wording of commit message

Signed-off-by: Paloma Arellano <quic_parellan@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/571854/
Link: https://lore.kernel.org/r/20231212231101.9240-2-quic_parellan@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c   |  1 -
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h  |  4 ++-
 .../drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c  | 32 ++++++++++++------
 .../drm/msm/disp/dpu1/dpu_encoder_phys_vid.c  | 33 ++++++++++++-------
 4 files changed, 47 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 0dd95b7ff1f9..b9f0093389a8 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -2500,7 +2500,6 @@ void dpu_encoder_phys_init(struct dpu_encoder_phys *phys_enc,
 	phys_enc->enc_spinlock = p->enc_spinlock;
 	phys_enc->enable_state = DPU_ENC_DISABLED;
 
-	atomic_set(&phys_enc->vblank_refcount, 0);
 	atomic_set(&phys_enc->pending_kickoff_cnt, 0);
 	atomic_set(&phys_enc->pending_ctlstart_cnt, 0);
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h
index 6f04c3d56e77..96bda57b6959 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h
@@ -155,6 +155,7 @@ enum dpu_intr_idx {
  * @hw_wb:		Hardware interface to the wb registers
  * @dpu_kms:		Pointer to the dpu_kms top level
  * @cached_mode:	DRM mode cached at mode_set time, acted on in enable
+ * @vblank_ctl_lock:	Vblank ctl mutex lock to protect vblank_refcount
  * @enabled:		Whether the encoder has enabled and running a mode
  * @split_role:		Role to play in a split-panel configuration
  * @intf_mode:		Interface mode
@@ -183,11 +184,12 @@ struct dpu_encoder_phys {
 	struct dpu_hw_wb *hw_wb;
 	struct dpu_kms *dpu_kms;
 	struct drm_display_mode cached_mode;
+	struct mutex vblank_ctl_lock;
 	enum dpu_enc_split_role split_role;
 	enum dpu_intf_mode intf_mode;
 	spinlock_t *enc_spinlock;
 	enum dpu_enc_enable_state enable_state;
-	atomic_t vblank_refcount;
+	int vblank_refcount;
 	atomic_t vsync_cnt;
 	atomic_t underrun_cnt;
 	atomic_t pending_ctlstart_cnt;
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
index be185fe69793..2d788c5e26a8 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
@@ -244,7 +244,8 @@ static int dpu_encoder_phys_cmd_control_vblank_irq(
 		return -EINVAL;
 	}
 
-	refcount = atomic_read(&phys_enc->vblank_refcount);
+	mutex_lock(&phys_enc->vblank_ctl_lock);
+	refcount = phys_enc->vblank_refcount;
 
 	/* Slave encoders don't report vblank */
 	if (!dpu_encoder_phys_cmd_is_master(phys_enc))
@@ -260,16 +261,24 @@ static int dpu_encoder_phys_cmd_control_vblank_irq(
 		      phys_enc->hw_pp->idx - PINGPONG_0,
 		      enable ? "true" : "false", refcount);
 
-	if (enable && atomic_inc_return(&phys_enc->vblank_refcount) == 1)
-		ret = dpu_core_irq_register_callback(phys_enc->dpu_kms,
-				phys_enc->irq[INTR_IDX_RDPTR],
-				dpu_encoder_phys_cmd_te_rd_ptr_irq,
-				phys_enc);
-	else if (!enable && atomic_dec_return(&phys_enc->vblank_refcount) == 0)
-		ret = dpu_core_irq_unregister_callback(phys_enc->dpu_kms,
-				phys_enc->irq[INTR_IDX_RDPTR]);
+	if (enable) {
+		if (phys_enc->vblank_refcount == 0)
+			ret = dpu_core_irq_register_callback(phys_enc->dpu_kms,
+					phys_enc->irq[INTR_IDX_RDPTR],
+					dpu_encoder_phys_cmd_te_rd_ptr_irq,
+					phys_enc);
+		if (!ret)
+			phys_enc->vblank_refcount++;
+	} else if (!enable) {
+		if (phys_enc->vblank_refcount == 1)
+			ret = dpu_core_irq_unregister_callback(phys_enc->dpu_kms,
+					phys_enc->irq[INTR_IDX_RDPTR]);
+		if (!ret)
+			phys_enc->vblank_refcount--;
+	}
 
 end:
+	mutex_unlock(&phys_enc->vblank_ctl_lock);
 	if (ret) {
 		DRM_ERROR("vblank irq err id:%u pp:%d ret:%d, enable %s/%d\n",
 			  DRMID(phys_enc->parent),
@@ -285,7 +294,7 @@ static void dpu_encoder_phys_cmd_irq_control(struct dpu_encoder_phys *phys_enc,
 {
 	trace_dpu_enc_phys_cmd_irq_ctrl(DRMID(phys_enc->parent),
 			phys_enc->hw_pp->idx - PINGPONG_0,
-			enable, atomic_read(&phys_enc->vblank_refcount));
+			enable, phys_enc->vblank_refcount);
 
 	if (enable) {
 		dpu_core_irq_register_callback(phys_enc->dpu_kms,
@@ -763,6 +772,9 @@ struct dpu_encoder_phys *dpu_encoder_phys_cmd_init(
 
 	dpu_encoder_phys_init(phys_enc, p);
 
+	mutex_init(&phys_enc->vblank_ctl_lock);
+	phys_enc->vblank_refcount = 0;
+
 	dpu_encoder_phys_cmd_init_ops(&phys_enc->ops);
 	phys_enc->intf_mode = INTF_MODE_CMD;
 	cmd_enc->stream_sel = 0;
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
index a01fda711883..eeb0acf9665e 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -364,7 +364,8 @@ static int dpu_encoder_phys_vid_control_vblank_irq(
 	int ret = 0;
 	int refcount;
 
-	refcount = atomic_read(&phys_enc->vblank_refcount);
+	mutex_lock(&phys_enc->vblank_ctl_lock);
+	refcount = phys_enc->vblank_refcount;
 
 	/* Slave encoders don't report vblank */
 	if (!dpu_encoder_phys_vid_is_master(phys_enc))
@@ -377,18 +378,26 @@ static int dpu_encoder_phys_vid_control_vblank_irq(
 	}
 
 	DRM_DEBUG_VBL("id:%u enable=%d/%d\n", DRMID(phys_enc->parent), enable,
-		      atomic_read(&phys_enc->vblank_refcount));
+		      refcount);
 
-	if (enable && atomic_inc_return(&phys_enc->vblank_refcount) == 1)
-		ret = dpu_core_irq_register_callback(phys_enc->dpu_kms,
-				phys_enc->irq[INTR_IDX_VSYNC],
-				dpu_encoder_phys_vid_vblank_irq,
-				phys_enc);
-	else if (!enable && atomic_dec_return(&phys_enc->vblank_refcount) == 0)
-		ret = dpu_core_irq_unregister_callback(phys_enc->dpu_kms,
-				phys_enc->irq[INTR_IDX_VSYNC]);
+	if (enable) {
+		if (phys_enc->vblank_refcount == 0)
+			ret = dpu_core_irq_register_callback(phys_enc->dpu_kms,
+					phys_enc->irq[INTR_IDX_VSYNC],
+					dpu_encoder_phys_vid_vblank_irq,
+					phys_enc);
+		if (!ret)
+			phys_enc->vblank_refcount++;
+	} else if (!enable) {
+		if (phys_enc->vblank_refcount == 1)
+			ret = dpu_core_irq_unregister_callback(phys_enc->dpu_kms,
+					phys_enc->irq[INTR_IDX_VSYNC]);
+		if (!ret)
+			phys_enc->vblank_refcount--;
+	}
 
 end:
+	mutex_unlock(&phys_enc->vblank_ctl_lock);
 	if (ret) {
 		DRM_ERROR("failed: id:%u intf:%d ret:%d enable:%d refcnt:%d\n",
 			  DRMID(phys_enc->parent),
@@ -618,7 +627,7 @@ static void dpu_encoder_phys_vid_irq_control(struct dpu_encoder_phys *phys_enc,
 	trace_dpu_enc_phys_vid_irq_ctrl(DRMID(phys_enc->parent),
 			    phys_enc->hw_intf->idx - INTF_0,
 			    enable,
-			    atomic_read(&phys_enc->vblank_refcount));
+			   phys_enc->vblank_refcount);
 
 	if (enable) {
 		ret = dpu_encoder_phys_vid_control_vblank_irq(phys_enc, true);
@@ -713,6 +722,8 @@ struct dpu_encoder_phys *dpu_encoder_phys_vid_init(
 	DPU_DEBUG_VIDENC(phys_enc, "\n");
 
 	dpu_encoder_phys_init(phys_enc, p);
+	mutex_init(&phys_enc->vblank_ctl_lock);
+	phys_enc->vblank_refcount = 0;
 
 	dpu_encoder_phys_vid_init_ops(&phys_enc->ops);
 	phys_enc->intf_mode = INTF_MODE_VIDEO;
-- 
2.43.0



