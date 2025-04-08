Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3CD265630;
	Tue,  8 Apr 2025 11:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111119; cv=none; b=KTzieV0I/QsMngDJMB7iK4znmhYnp17KD6oRV6qDDHnV3aZEQJta9yh7b5ovCh78pkqZremF8a0dj638iTL3d65F4MpEcLwQhL+Mncx16CYJ9R32lkx3zJfqXUhAOX9iggJ6w/qmJ4n2EDiIn3hNsY1MS4GHqQr8YBNfUgmvuTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111119; c=relaxed/simple;
	bh=+ycJwha3Yf0hjsmyIZSvVgKG1TEoYvm+jiuyhA+6NkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ax9enXzwXPRZKTrMaEm57qUdOOtj88aiVVJCN+AT3Qdg8ZglX4QkJFjKPWKucnBjs0SRaaxEMBby+/AWn20Jvo1jEvXWZ30sIZ1JTx8LsFL/hGiNcni5aLjQgmUWe8sMvbPZdL2ICg/T1fLW/8yQ1Pq8Vad/7h4cnVucDVq5i6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOfCWKFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOfCWKFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD9FC4CEE5;
	Tue,  8 Apr 2025 11:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111119;
	bh=+ycJwha3Yf0hjsmyIZSvVgKG1TEoYvm+jiuyhA+6NkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOfCWKFljneLq0PxSyunn+EbxSeuVb1bvCm0muhof/X2R4T3Hww88hYSDx3k2NwKb
	 N02t8T6r03nAWF8ylW4GBe0OcRbtIRySRHWKUO4UasmOnqTi675CM6vzVSw3DB8q5K
	 nTSOm98OtiHZ5H/vAJtm32XAjM9DG3LtY9XZUpjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 315/731] drm/msm/dpu: dont set crtc_state->mode_changed from atomic_check()
Date: Tue,  8 Apr 2025 12:43:32 +0200
Message-ID: <20250408104921.605889369@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 2dde2aadaed113feb724c19063ac61e2f6ba61a4 ]

The MSM driver uses drm_atomic_helper_check() which mandates that none
of the atomic_check() callbacks toggles crtc_state->mode_changed.
Perform corresponding check before calling the drm_atomic_helper_check()
function.

Fixes: 8b45a26f2ba9 ("drm/msm/dpu: reserve cdm blocks for writeback in case of YUV output")
Reported-by: Simona Vetter <simona.vetter@ffwll.ch>
Closes: https://lore.kernel.org/dri-devel/ZtW_S0j5AEr4g0QW@phenom.ffwll.local/
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
[DB: dropped the WARN_ON]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/633400/
Link: https://lore.kernel.org/r/20250123-drm-dirty-modeset-v2-4-bbfd3a6cd1a4@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 32 ++++++++++++++++++---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.h |  4 +++
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c     | 24 ++++++++++++++++
 drivers/gpu/drm/msm/msm_atomic.c            | 13 ++++++++-
 drivers/gpu/drm/msm/msm_kms.h               |  7 +++++
 5 files changed, 75 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 9928e72dfabda..7b56da24711e4 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -760,6 +760,34 @@ static void dpu_encoder_assign_crtc_resources(struct dpu_kms *dpu_kms,
 	cstate->num_mixers = num_lm;
 }
 
+/**
+ * dpu_encoder_virt_check_mode_changed: check if full modeset is required
+ * @drm_enc:    Pointer to drm encoder structure
+ * @crtc_state:	Corresponding CRTC state to be checked
+ * @conn_state: Corresponding Connector's state to be checked
+ *
+ * Check if the changes in the object properties demand full mode set.
+ */
+int dpu_encoder_virt_check_mode_changed(struct drm_encoder *drm_enc,
+					struct drm_crtc_state *crtc_state,
+					struct drm_connector_state *conn_state)
+{
+	struct dpu_encoder_virt *dpu_enc = to_dpu_encoder_virt(drm_enc);
+	struct msm_display_topology topology;
+
+	DPU_DEBUG_ENC(dpu_enc, "\n");
+
+	/* Using mode instead of adjusted_mode as it wasn't computed yet */
+	topology = dpu_encoder_get_topology(dpu_enc, &crtc_state->mode, crtc_state, conn_state);
+
+	if (topology.needs_cdm && !dpu_enc->cur_master->hw_cdm)
+		crtc_state->mode_changed = true;
+	else if (!topology.needs_cdm && dpu_enc->cur_master->hw_cdm)
+		crtc_state->mode_changed = true;
+
+	return 0;
+}
+
 static int dpu_encoder_virt_atomic_check(
 		struct drm_encoder *drm_enc,
 		struct drm_crtc_state *crtc_state,
@@ -793,10 +821,6 @@ static int dpu_encoder_virt_atomic_check(
 
 	topology = dpu_encoder_get_topology(dpu_enc, adj_mode, crtc_state, conn_state);
 
-	if (topology.needs_cdm && !dpu_enc->cur_master->hw_cdm)
-		crtc_state->mode_changed = true;
-	else if (!topology.needs_cdm && dpu_enc->cur_master->hw_cdm)
-		crtc_state->mode_changed = true;
 	/*
 	 * Release and Allocate resources on every modeset
 	 */
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.h
index 92b5ee390788d..da133ee4701a3 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.h
@@ -88,4 +88,8 @@ void dpu_encoder_cleanup_wb_job(struct drm_encoder *drm_enc,
 
 bool dpu_encoder_is_valid_for_commit(struct drm_encoder *drm_enc);
 
+int dpu_encoder_virt_check_mode_changed(struct drm_encoder *drm_enc,
+					struct drm_crtc_state *crtc_state,
+					struct drm_connector_state *conn_state);
+
 #endif /* __DPU_ENCODER_H__ */
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index 97e9cb8c2b099..8741dc6fc8ddc 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -446,6 +446,29 @@ static void dpu_kms_disable_commit(struct msm_kms *kms)
 	pm_runtime_put_sync(&dpu_kms->pdev->dev);
 }
 
+static int dpu_kms_check_mode_changed(struct msm_kms *kms, struct drm_atomic_state *state)
+{
+	struct drm_crtc_state *new_crtc_state;
+	struct drm_connector *connector;
+	struct drm_connector_state *new_conn_state;
+	int i;
+
+	for_each_new_connector_in_state(state, connector, new_conn_state, i) {
+		struct drm_encoder *encoder;
+
+		if (!new_conn_state->crtc || !new_conn_state->best_encoder)
+			continue;
+
+		new_crtc_state = drm_atomic_get_new_crtc_state(state, new_conn_state->crtc);
+
+		encoder = new_conn_state->best_encoder;
+
+		dpu_encoder_virt_check_mode_changed(encoder, new_crtc_state, new_conn_state);
+	}
+
+	return 0;
+}
+
 static void dpu_kms_flush_commit(struct msm_kms *kms, unsigned crtc_mask)
 {
 	struct dpu_kms *dpu_kms = to_dpu_kms(kms);
@@ -1062,6 +1085,7 @@ static const struct msm_kms_funcs kms_funcs = {
 	.irq             = dpu_core_irq,
 	.enable_commit   = dpu_kms_enable_commit,
 	.disable_commit  = dpu_kms_disable_commit,
+	.check_mode_changed = dpu_kms_check_mode_changed,
 	.flush_commit    = dpu_kms_flush_commit,
 	.wait_flush      = dpu_kms_wait_flush,
 	.complete_commit = dpu_kms_complete_commit,
diff --git a/drivers/gpu/drm/msm/msm_atomic.c b/drivers/gpu/drm/msm/msm_atomic.c
index a7a2384044ffd..364df245e3a20 100644
--- a/drivers/gpu/drm/msm/msm_atomic.c
+++ b/drivers/gpu/drm/msm/msm_atomic.c
@@ -183,10 +183,16 @@ static unsigned get_crtc_mask(struct drm_atomic_state *state)
 
 int msm_atomic_check(struct drm_device *dev, struct drm_atomic_state *state)
 {
+	struct msm_drm_private *priv = dev->dev_private;
+	struct msm_kms *kms = priv->kms;
 	struct drm_crtc_state *old_crtc_state, *new_crtc_state;
 	struct drm_crtc *crtc;
-	int i;
+	int i, ret = 0;
 
+	/*
+	 * FIXME: stop setting allow_modeset and move this check to the DPU
+	 * driver.
+	 */
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state,
 				      new_crtc_state, i) {
 		if ((old_crtc_state->ctm && !new_crtc_state->ctm) ||
@@ -196,6 +202,11 @@ int msm_atomic_check(struct drm_device *dev, struct drm_atomic_state *state)
 		}
 	}
 
+	if (kms && kms->funcs && kms->funcs->check_mode_changed)
+		ret = kms->funcs->check_mode_changed(kms, state);
+	if (ret)
+		return ret;
+
 	return drm_atomic_helper_check(dev, state);
 }
 
diff --git a/drivers/gpu/drm/msm/msm_kms.h b/drivers/gpu/drm/msm/msm_kms.h
index e60162744c669..ec2a75af89b09 100644
--- a/drivers/gpu/drm/msm/msm_kms.h
+++ b/drivers/gpu/drm/msm/msm_kms.h
@@ -59,6 +59,13 @@ struct msm_kms_funcs {
 	void (*enable_commit)(struct msm_kms *kms);
 	void (*disable_commit)(struct msm_kms *kms);
 
+	/**
+	 * @check_mode_changed:
+	 *
+	 * Verify if the commit requires a full modeset on one of CRTCs.
+	 */
+	int (*check_mode_changed)(struct msm_kms *kms, struct drm_atomic_state *state);
+
 	/**
 	 * Prepare for atomic commit.  This is called after any previous
 	 * (async or otherwise) commit has completed.
-- 
2.39.5



