Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA07118EFCD;
	Mon, 28 Oct 2024 06:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097550; cv=none; b=dZCSKcIIjYG1gu52N6xjUgZRTPry+IZDUwzIjhqZe+DJsTmKCA3vYC0ZDuqpDiJHgVXjBH0d1hIxzYioj/U2W/SxVQc7ZbVbAWd3MXzQZ1C/wXwjzjUeTjsiRc9ULgBnZsv9wUyqlABPSrbfPDUJ3ZOhYCtT8Fxkd/aimw5azw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097550; c=relaxed/simple;
	bh=+mUVeOV+hOd4iQP2VY3GJfKy3yN0RSfHlIKaERt9N/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTIeAKOEki4oQ7SLHZgvXLN1MHFiORiK/9fWRkcZeRxxrIoXz2G0cXT2DDD7R8g3MaVn8iZxw2KJc2L6ijHEDyxppsj+t/lKOelCkOA603JxWlCrl5XqPFlRCll2A/NzozT03iMHaVIj6GNOhiYUZ++tVf1CEZAiw5lewewXckw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJCPyZ8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJCPyZ8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE8CC4CEC3;
	Mon, 28 Oct 2024 06:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097550;
	bh=+mUVeOV+hOd4iQP2VY3GJfKy3yN0RSfHlIKaERt9N/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJCPyZ8WXqiT6EIvEsZ2SswID6G48u1Q4fcDYWh6eQn4aZJDvX2bFbCFUA8IAPr05
	 YE0ai50f6a+n+K+/0hxzNo7PNJ/zXPkOv8MxfkCgs76eelnoXO1Z39bnHzvoNyupkB
	 IJKNCFhdIonBlbcnNAP1Ekux8SechZNn6wYXf0gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/208] drm/msm/dpu: check for overflow in _dpu_crtc_setup_lm_bounds()
Date: Mon, 28 Oct 2024 07:23:42 +0100
Message-ID: <20241028062307.691691854@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

[ Upstream commit 3a0851b442d1f63ba42ecfa2506d3176cfabf9d4 ]

Make _dpu_crtc_setup_lm_bounds() check that CRTC width is not
overflowing LM requirements. Rename the function accordingly.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Tested-by: Abhinav Kumar <quic_abhinavk@quicinc.com> # sc7280
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/612237/
Link: https://lore.kernel.org/r/20240903-dpu-mode-config-width-v6-3-617e1ecc4b7a@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index e238e4e8116ca..ad57368dc13f0 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -722,12 +722,13 @@ void dpu_crtc_complete_commit(struct drm_crtc *crtc)
 	_dpu_crtc_complete_flip(crtc);
 }
 
-static void _dpu_crtc_setup_lm_bounds(struct drm_crtc *crtc,
+static int _dpu_crtc_check_and_setup_lm_bounds(struct drm_crtc *crtc,
 		struct drm_crtc_state *state)
 {
 	struct dpu_crtc_state *cstate = to_dpu_crtc_state(state);
 	struct drm_display_mode *adj_mode = &state->adjusted_mode;
 	u32 crtc_split_width = adj_mode->hdisplay / cstate->num_mixers;
+	struct dpu_kms *dpu_kms = _dpu_crtc_get_kms(crtc);
 	int i;
 
 	for (i = 0; i < cstate->num_mixers; i++) {
@@ -738,7 +739,12 @@ static void _dpu_crtc_setup_lm_bounds(struct drm_crtc *crtc,
 		r->y2 = adj_mode->vdisplay;
 
 		trace_dpu_crtc_setup_lm_bounds(DRMID(crtc), i, r);
+
+		if (drm_rect_width(r) > dpu_kms->catalog->caps->max_mixer_width)
+			return -E2BIG;
 	}
+
+	return 0;
 }
 
 static void _dpu_crtc_get_pcc_coeff(struct drm_crtc_state *state,
@@ -814,7 +820,7 @@ static void dpu_crtc_atomic_begin(struct drm_crtc *crtc,
 
 	DRM_DEBUG_ATOMIC("crtc%d\n", crtc->base.id);
 
-	_dpu_crtc_setup_lm_bounds(crtc, crtc->state);
+	_dpu_crtc_check_and_setup_lm_bounds(crtc, crtc->state);
 
 	/* encoder will trigger pending mask now */
 	drm_for_each_encoder_mask(encoder, crtc->dev, crtc->state->encoder_mask)
@@ -1208,8 +1214,11 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 	if (crtc_state->active_changed)
 		crtc_state->mode_changed = true;
 
-	if (cstate->num_mixers)
-		_dpu_crtc_setup_lm_bounds(crtc, crtc_state);
+	if (cstate->num_mixers) {
+		rc = _dpu_crtc_check_and_setup_lm_bounds(crtc, crtc_state);
+		if (rc)
+			return rc;
+	}
 
 	/* FIXME: move this to dpu_plane_atomic_check? */
 	drm_atomic_crtc_state_for_each_plane_state(plane, pstate, crtc_state) {
-- 
2.43.0



