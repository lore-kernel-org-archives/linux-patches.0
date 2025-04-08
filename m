Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271B62236FC;
	Tue,  8 Apr 2025 12:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114504; cv=none; b=nYHrD3fCaaEytxxV77ATBTrFFpXDSNuMZLY7Qap3OnPOhP3gYCRvg1OpkrDZzqy8rc2M2/KispNWUI3ycdUcCaytMPLwTtFssBNnFlSQDZ2gUBNtR57YJnwx9VuH7rx9wst5Bmh0QGVa5WJtcQpwegQOUIJoxy5c1L62t+mxqVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114504; c=relaxed/simple;
	bh=nqhzS1NdKnCXMwkX6ahAbck9Dp75ssG1sPjyrHnXMm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2ysD/TSChxL62Tbv2seyL22ye14CDBgMC/3ak7WuXJcdoxl2y45N+l3/kfgiVC9CFnzkm6hcbjKB3sqLLoPuxB4c3pIbPzfdLfFEBLJBFXjpFtz3x1D6giaCv20w2NXXn4RU6UEg7H77v89BKaiVoy/Vim1YEHUKxQvbNFdUjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6H0Y/wu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6H0Y/wu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB23C4CEE5;
	Tue,  8 Apr 2025 12:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114504;
	bh=nqhzS1NdKnCXMwkX6ahAbck9Dp75ssG1sPjyrHnXMm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6H0Y/wuC4vkzu1CN8naAQOoCdkV0cagVduQLkEQN3jIY3NCAiIC4DhQnO02ZiyoB
	 Gwm91GKtwtotZt1kZW/PoKDdhp/Z08jcwMOL36FqF+HZRdT2k+WDWckESlZn+ix+Ws
	 /kZf1zrHyTxUa0GTQuTOMaei2SeDgWXKanosehzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 082/499] drm/msm/dpu: dont use active in atomic_check()
Date: Tue,  8 Apr 2025 12:44:54 +0200
Message-ID: <20250408104853.267845696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 25b4614843bcc56ba150f7c99905125a019e656c ]

The driver isn't supposed to consult crtc_state->active/active_check for
resource allocation. Instead all resources should be allocated if
crtc_state->enabled is set. Stop consulting active / active_changed in
order to determine whether the hardware resources should be
(re)allocated.

Fixes: ccc862b957c6 ("drm/msm/dpu: Fix reservation failures in modeset")
Reported-by: Simona Vetter <simona.vetter@ffwll.ch>
Closes: https://lore.kernel.org/dri-devel/ZtW_S0j5AEr4g0QW@phenom.ffwll.local/
Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/633393/
Link: https://lore.kernel.org/r/20250123-drm-dirty-modeset-v2-1-bbfd3a6cd1a4@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c    | 4 ----
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 3 +--
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index ad3462476a143..a71136e39738d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -1214,10 +1214,6 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 
 	DRM_DEBUG_ATOMIC("%s: check\n", dpu_crtc->name);
 
-	/* force a full mode set if active state changed */
-	if (crtc_state->active_changed)
-		crtc_state->mode_changed = true;
-
 	if (cstate->num_mixers) {
 		rc = _dpu_crtc_check_and_setup_lm_bounds(crtc, crtc_state);
 		if (rc)
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 67f5fc6fdae10..ebdfb76b6e61a 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -793,12 +793,11 @@ static int dpu_encoder_virt_atomic_check(
 		crtc_state->mode_changed = true;
 	/*
 	 * Release and Allocate resources on every modeset
-	 * Dont allocate when active is false.
 	 */
 	if (drm_atomic_crtc_needs_modeset(crtc_state)) {
 		dpu_rm_release(global_state, drm_enc);
 
-		if (!crtc_state->active_changed || crtc_state->enable)
+		if (crtc_state->enable)
 			ret = dpu_rm_reserve(&dpu_kms->rm, global_state,
 					drm_enc, crtc_state, topology);
 		if (!ret)
-- 
2.39.5



