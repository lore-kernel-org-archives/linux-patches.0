Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC91A1AAE28;
	Sat, 17 Oct 2026 17:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257735; cv=none; b=N09O11D/uMUCUu+Tq1oerXpBNt9491uL1yAOagrGhqyu7bb9F9bGLxg4bT/S2oDCQPm+8P7KkbERh2eZcK8+gb3weTpcNqLXSHj/V6uJjPo1v4vGlJM/8CHE/gnKP6odeULTQ3YHximunbdr0gV4ZmTMgaoUQ+Le3wHaeNGniLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257735; c=relaxed/simple;
	bh=iiybtnL+bGBlCnsSh7uEg4ZDY74bYPZFtu6tAjyNnas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8zqhMewP6WxvxKyB9oXwPqCf4LynSBjY/wKVvUL5skNmTaGRpcWu2t8aXTe444NfplukKevPBDi+GVasQ6D3Op+/xr51VGqhZJKlsmFFP1I4/aH7e5Ong42hQQ/G6wKQ3lPhuE4OJDdzC7yC7s5ycarupOgpGYQtHqLqOntV/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+QsfToW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+QsfToW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C6F1F000C4;
	Sat, 17 Oct 2026 17:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257733;
	bh=kGefcS15k5afXIWVGE34U90PX8bzLIgSvuDZ+UXsFss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+QsfToWYgeZmXtziAK71RyIBaWNZOilSZhXCXN+RWr1QYPw54r6rz7DmIlk7olAI
	 nj7QZOBDILGrDwSdKboz43NF5yOyHG/zRyrLw3TSnYEH07uSYWq25HOlBdbsluPnbj
	 gAlhYoxH5FI6YD0KBgz2ssFR/L62Q7e66puKW+Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paloma Arellano <quic_parellan@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0616/1674] drm/msm/dpu: Add mutex lock in control vblank irq
Date: Sat, 17 Oct 2026 17:48:08 +0200
Message-ID: <20261017160446.889113301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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
index 8c630615ed928..dcf8127b9b6ef 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -2541,7 +2541,6 @@ void dpu_encoder_phys_init(struct dpu_encoder_phys *phys_enc,
 	phys_enc->enc_spinlock = p->enc_spinlock;
 	phys_enc->enable_state = DPU_ENC_DISABLED;
 
-	atomic_set(&phys_enc->vblank_refcount, 0);
 	atomic_set(&phys_enc->pending_kickoff_cnt, 0);
 	atomic_set(&phys_enc->pending_ctlstart_cnt, 0);
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h
index ddfed280597d8..461e8c20cce81 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h
@@ -154,6 +154,7 @@ enum dpu_intr_idx {
  * @hw_wb:		Hardware interface to the wb registers
  * @dpu_kms:		Pointer to the dpu_kms top level
  * @cached_mode:	DRM mode cached at mode_set time, acted on in enable
+ * @vblank_ctl_lock:	Vblank ctl mutex lock to protect vblank_refcount
  * @enabled:		Whether the encoder has enabled and running a mode
  * @split_role:		Role to play in a split-panel configuration
  * @intf_mode:		Interface mode
@@ -182,11 +183,12 @@ struct dpu_encoder_phys {
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
index fd2400c4665d2..6ec75f215d2e5 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
@@ -252,7 +252,8 @@ static int dpu_encoder_phys_cmd_control_vblank_irq(
 		return -EINVAL;
 	}
 
-	refcount = atomic_read(&phys_enc->vblank_refcount);
+	mutex_lock(&phys_enc->vblank_ctl_lock);
+	refcount = phys_enc->vblank_refcount;
 
 	/* Slave encoders don't report vblank */
 	if (!dpu_encoder_phys_cmd_is_master(phys_enc))
@@ -268,16 +269,24 @@ static int dpu_encoder_phys_cmd_control_vblank_irq(
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
@@ -293,7 +302,7 @@ static void dpu_encoder_phys_cmd_irq_control(struct dpu_encoder_phys *phys_enc,
 {
 	trace_dpu_enc_phys_cmd_irq_ctrl(DRMID(phys_enc->parent),
 			phys_enc->hw_pp->idx - PINGPONG_0,
-			enable, atomic_read(&phys_enc->vblank_refcount));
+			enable, phys_enc->vblank_refcount);
 
 	if (enable) {
 		dpu_core_irq_register_callback(phys_enc->dpu_kms,
@@ -735,6 +744,9 @@ struct dpu_encoder_phys *dpu_encoder_phys_cmd_init(struct drm_device *dev,
 
 	dpu_encoder_phys_init(phys_enc, p);
 
+	mutex_init(&phys_enc->vblank_ctl_lock);
+	phys_enc->vblank_refcount = 0;
+
 	dpu_encoder_phys_cmd_init_ops(&phys_enc->ops);
 	phys_enc->intf_mode = INTF_MODE_CMD;
 	cmd_enc->stream_sel = 0;
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
index 2cda9bbf68f96..da753f2dbd26d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -373,7 +373,8 @@ static int dpu_encoder_phys_vid_control_vblank_irq(
 	int ret = 0;
 	int refcount;
 
-	refcount = atomic_read(&phys_enc->vblank_refcount);
+	mutex_lock(&phys_enc->vblank_ctl_lock);
+	refcount = phys_enc->vblank_refcount;
 
 	/* Slave encoders don't report vblank */
 	if (!dpu_encoder_phys_vid_is_master(phys_enc))
@@ -386,18 +387,26 @@ static int dpu_encoder_phys_vid_control_vblank_irq(
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
@@ -621,7 +630,7 @@ static void dpu_encoder_phys_vid_irq_control(struct dpu_encoder_phys *phys_enc,
 	trace_dpu_enc_phys_vid_irq_ctrl(DRMID(phys_enc->parent),
 			    phys_enc->hw_intf->idx - INTF_0,
 			    enable,
-			    atomic_read(&phys_enc->vblank_refcount));
+			   phys_enc->vblank_refcount);
 
 	if (enable) {
 		ret = dpu_encoder_phys_vid_control_vblank_irq(phys_enc, true);
@@ -714,6 +723,8 @@ struct dpu_encoder_phys *dpu_encoder_phys_vid_init(struct drm_device *dev,
 	DPU_DEBUG_VIDENC(phys_enc, "\n");
 
 	dpu_encoder_phys_init(phys_enc, p);
+	mutex_init(&phys_enc->vblank_ctl_lock);
+	phys_enc->vblank_refcount = 0;
 
 	dpu_encoder_phys_vid_init_ops(&phys_enc->ops);
 	phys_enc->intf_mode = INTF_MODE_VIDEO;
-- 
2.53.0



