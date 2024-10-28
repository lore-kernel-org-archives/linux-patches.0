Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5618837;
	Mon, 28 Oct 2024 06:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098092; cv=none; b=soItjfmWlM9quxEwHzOQZIwOYOW9iL4sQr6VKhC6U34Fu/b6Iwontv03q87GdzBP5EbXlP5vfkJ4v8h13yYYtCotJaP84f7MTzRaOm8+lxM4yDTMrpfO2XNWRr/uY7Jff3AEyYtyHv1oJs6OeuV6fWfmfH1R+fAB1pITgGy0rnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098092; c=relaxed/simple;
	bh=wenoaY4pVxLaCsImAI7KLiVvMF6lsdQ/rqXsg2h+b6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlmdK4KUOvuOLoK4VVvUK9nLbejCT+HxWUjBtbfSEVe3GaUzJdS/Lh+l4yEAuAOutv6sc6pgFQKuUWUw7+PqKLjd5lvP9PXJ8rX2R5QBSp1oofG6HzsLgD1kL//NrNhJwf3/3lCb3qD+T1gDJRd0Kqn/QCTuDbm37bDMucLN1TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycnP6Me2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycnP6Me2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5C8C4CEC3;
	Mon, 28 Oct 2024 06:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098092;
	bh=wenoaY4pVxLaCsImAI7KLiVvMF6lsdQ/rqXsg2h+b6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ycnP6Me2VRHnarqhWxGpy09bYXWcICiN9FHACvAU9XIm3B2tA9u9so3tkWOa3b3w/
	 2Rr6Z4YyJCv/6P56ImbIY6q17BUWOoQRVGlRpC/rapgxe1nf3zNjvh4NcQUtm+Wuez
	 aFeoDpsPbuUbZ/EMn3eSQO4/HlPwC6lWD5HegePA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 074/261] drm/msm/dpu: Dont always set merge_3d pending flush
Date: Mon, 28 Oct 2024 07:23:36 +0100
Message-ID: <20241028062313.883873532@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jessica Zhang <quic_jesszhan@quicinc.com>

[ Upstream commit 40dad89cb86ce824f2080441b2a6b7aedf695329 ]

Don't set the merge_3d pending flush bits if the mode_3d is
BLEND_3D_NONE.

Always flushing merge_3d can cause timeout issues when there are
multiple commits with concurrent writeback enabled.

This is because the video phys enc waits for the hw_ctl flush register
to be completely cleared [1] in its wait_for_commit_done(), but the WB
encoder always sets the merge_3d pending flush during each commit
regardless of if the merge_3d is actually active.

This means that the hw_ctl flush register will never be 0 when there are
multiple CWB commits and the video phys enc will hit vblank timeout
errors after the first CWB commit.

[1] commit fe9df3f50c39 ("drm/msm/dpu: add real wait_for_commit_done()")

Fixes: 3e79527a33a8 ("drm/msm/dpu: enable merge_3d support on sm8150/sm8250")
Fixes: d7d0e73f7de3 ("drm/msm/dpu: introduce the dpu_encoder_phys_* for writeback")
Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/619092/
Link: https://lore.kernel.org/r/20241009-mode3d-fix-v1-1-c0258354fadc@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c | 5 ++++-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c  | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
index ba8878d21cf0e..8864ace938e03 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -440,10 +440,12 @@ static void dpu_encoder_phys_vid_enable(struct dpu_encoder_phys *phys_enc)
 	struct dpu_hw_ctl *ctl;
 	const struct msm_format *fmt;
 	u32 fmt_fourcc;
+	u32 mode_3d;
 
 	ctl = phys_enc->hw_ctl;
 	fmt_fourcc = dpu_encoder_get_drm_fmt(phys_enc);
 	fmt = mdp_get_format(&phys_enc->dpu_kms->base, fmt_fourcc, 0);
+	mode_3d = dpu_encoder_helper_get_3d_blend_mode(phys_enc);
 
 	DPU_DEBUG_VIDENC(phys_enc, "\n");
 
@@ -466,7 +468,8 @@ static void dpu_encoder_phys_vid_enable(struct dpu_encoder_phys *phys_enc)
 		goto skip_flush;
 
 	ctl->ops.update_pending_flush_intf(ctl, phys_enc->hw_intf->idx);
-	if (ctl->ops.update_pending_flush_merge_3d && phys_enc->hw_pp->merge_3d)
+	if (mode_3d && ctl->ops.update_pending_flush_merge_3d &&
+	    phys_enc->hw_pp->merge_3d)
 		ctl->ops.update_pending_flush_merge_3d(ctl, phys_enc->hw_pp->merge_3d->idx);
 
 	if (ctl->ops.update_pending_flush_cdm && phys_enc->hw_cdm)
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
index 882c717859cec..07035ab77b792 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
@@ -275,6 +275,7 @@ static void _dpu_encoder_phys_wb_update_flush(struct dpu_encoder_phys *phys_enc)
 	struct dpu_hw_pingpong *hw_pp;
 	struct dpu_hw_cdm *hw_cdm;
 	u32 pending_flush = 0;
+	u32 mode_3d;
 
 	if (!phys_enc)
 		return;
@@ -283,6 +284,7 @@ static void _dpu_encoder_phys_wb_update_flush(struct dpu_encoder_phys *phys_enc)
 	hw_pp = phys_enc->hw_pp;
 	hw_ctl = phys_enc->hw_ctl;
 	hw_cdm = phys_enc->hw_cdm;
+	mode_3d = dpu_encoder_helper_get_3d_blend_mode(phys_enc);
 
 	DPU_DEBUG("[wb:%d]\n", hw_wb->idx - WB_0);
 
@@ -294,7 +296,8 @@ static void _dpu_encoder_phys_wb_update_flush(struct dpu_encoder_phys *phys_enc)
 	if (hw_ctl->ops.update_pending_flush_wb)
 		hw_ctl->ops.update_pending_flush_wb(hw_ctl, hw_wb->idx);
 
-	if (hw_ctl->ops.update_pending_flush_merge_3d && hw_pp && hw_pp->merge_3d)
+	if (mode_3d && hw_ctl->ops.update_pending_flush_merge_3d &&
+	    hw_pp && hw_pp->merge_3d)
 		hw_ctl->ops.update_pending_flush_merge_3d(hw_ctl,
 				hw_pp->merge_3d->idx);
 
-- 
2.43.0



