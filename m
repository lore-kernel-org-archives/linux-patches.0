Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C814E1C6F58;
	Tue, 27 Aug 2024 14:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770620; cv=none; b=E3XZZVDgt0m/Gb0ha4655FTT5FTR3v+tLICpXPCKJhntmicHDFhsCfz5gEx7FvKs0arWyQVvNEZFDZa/lgA1Y/5myigwZ3dWqujOKQnaeT2JG/Ra1en/11IQEQe7z65ywtxxUDmd8iiFw7UqR4UEHDU39+iowL+6iVecbO31HZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770620; c=relaxed/simple;
	bh=XBVPqrawQdAWyvnFHLuAi8iD32nPZwWSGyj3pk12OOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRXB6lvFedXGZSsssuVLADntSWKIo+Fqc/ZZBcMl9IOZAgcdCAeqYKUiPE/Gr4Xk+NZrSjhWi246p4rFVmtIpwgZZYRPj0AWYTPLaYm5S+CLaXThGB3Gl4s1YTT3d9f4LVJFEzoO5/RojdwRyxckh3oMaSi73rvM5hcJTjkl3fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHNnHp20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHNnHp20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4361DC4FE01;
	Tue, 27 Aug 2024 14:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770620;
	bh=XBVPqrawQdAWyvnFHLuAi8iD32nPZwWSGyj3pk12OOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHNnHp20xeEujWdyPvCn+GbdImZHjS9rSIGNksgxq/r1UC4MntfLXRUTblOn+VbPc
	 dq2EUSXn53EpAeQIlxpMoYqgsJMBeqa0CMab8xVWZ8eRKDdkXQrIe6L3W1XLsrGOnA
	 XgLKM9dM//R6v2bDgli8uAtsCQVFRmVCtnQ1XTDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 282/341] drm/msm/dpu: capture snapshot on the first commit_done timeout
Date: Tue, 27 Aug 2024 16:38:33 +0200
Message-ID: <20240827143854.129641939@linuxfoundation.org>
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

[ Upstream commit 4be445f5b6b6810baf397b2d159bd07c3573fd75 ]

In order to debug commit_done timeouts, capture the devcoredump state
when the first timeout occurs after the encoder has been enabled.

Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/579850/
Link: https://lore.kernel.org/r/20240226-fd-dpu-debug-timeout-v4-3-51eec83dde23@linaro.org
Stable-dep-of: aedf02e46eb5 ("drm/msm/dpu: move dpu_encoder's connector assignment to atomic_enable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index ba60997350890..0c57588044641 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -124,6 +124,8 @@ enum dpu_enc_rc_states {
  * @base:		drm_encoder base class for registration with DRM
  * @enc_spinlock:	Virtual-Encoder-Wide Spin Lock for IRQ purposes
  * @enabled:		True if the encoder is active, protected by enc_lock
+ * @commit_done_timedout: True if there has been a timeout on commit after
+ *			enabling the encoder.
  * @num_phys_encs:	Actual number of physical encoders contained.
  * @phys_encs:		Container of physical encoders managed.
  * @cur_master:		Pointer to the current master in this mode. Optimization
@@ -172,6 +174,7 @@ struct dpu_encoder_virt {
 	spinlock_t enc_spinlock;
 
 	bool enabled;
+	bool commit_done_timedout;
 
 	unsigned int num_phys_encs;
 	struct dpu_encoder_phys *phys_encs[MAX_PHYS_ENCODERS_PER_VIRTUAL];
@@ -1210,6 +1213,9 @@ static void dpu_encoder_virt_atomic_enable(struct drm_encoder *drm_enc,
 	dpu_enc->dsc = dpu_encoder_get_dsc_config(drm_enc);
 
 	mutex_lock(&dpu_enc->enc_lock);
+
+	dpu_enc->commit_done_timedout = false;
+
 	cur_mode = &dpu_enc->base.crtc->state->adjusted_mode;
 
 	trace_dpu_enc_enable(DRMID(drm_enc), cur_mode->hdisplay,
@@ -2446,6 +2452,10 @@ int dpu_encoder_wait_for_commit_done(struct drm_encoder *drm_enc)
 			DPU_ATRACE_BEGIN("wait_for_commit_done");
 			ret = phys->ops.wait_for_commit_done(phys);
 			DPU_ATRACE_END("wait_for_commit_done");
+			if (ret == -ETIMEDOUT && !dpu_enc->commit_done_timedout) {
+				dpu_enc->commit_done_timedout = true;
+				msm_disp_snapshot_state(drm_enc->dev);
+			}
 			if (ret)
 				return ret;
 		}
-- 
2.43.0



