Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D1926B2CD;
	Tue,  8 Apr 2025 12:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116238; cv=none; b=hInybC7GuQLkoLYMATaepbeUA5IddZlgPrt68Vi4Plf+of1Cm+l+Pdy/9GMZEa5nkAiB+VlKQE1jwEZ7I+e4B+b7n1Iyp5pTkZ9iZCOqK+Iw2+/IBxAslFHG6yCUID5IFQ7a5iO8ZN2pcmwaIvHrSuuPh7CHXEqqRHFrzAelkRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116238; c=relaxed/simple;
	bh=DA5JV307KvoUz3lVrwetEmTBkrn0kjrnH/60UUpiDog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyRrEQwGjF7t5QIIqy+2UER1TxPT9N573jgSmajkLIeh47Da9/+mKy2btH9c2eTaO8COeANzI8Sahhfm/wAfY+6V5THtNcjpohkpPHxJ+QoB6xh3Fu31fEgxr99ftH8ClJws2xiacStR+CkZMLfxXCJDe8lLBvPyxuv4cm06q3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gs6GGyEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gs6GGyEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E763CC4CEE5;
	Tue,  8 Apr 2025 12:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116238;
	bh=DA5JV307KvoUz3lVrwetEmTBkrn0kjrnH/60UUpiDog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gs6GGyEtf4SqK6AYkNAjcMQzoReqNYhoECVKcGzE5/WolL0upkU5Z83Hpf0uJyt19
	 DTkN82uvxD94Exa/DiW4VxtSEHNzIbqyIHTJmlpnlVTB1l6UxGwbRGzCWRL27qdRqR
	 cL38LDSbsmDI4D1xFB1dNKJaCIj/r/FshrZhZr6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/423] drm/msm/dpu: dont use active in atomic_check()
Date: Tue,  8 Apr 2025 12:46:32 +0200
Message-ID: <20250408104847.285662098@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index db6c57900781d..ecd595215a6be 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -1191,10 +1191,6 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 
 	DRM_DEBUG_ATOMIC("%s: check\n", dpu_crtc->name);
 
-	/* force a full mode set if active state changed */
-	if (crtc_state->active_changed)
-		crtc_state->mode_changed = true;
-
 	if (cstate->num_mixers) {
 		rc = _dpu_crtc_check_and_setup_lm_bounds(crtc, crtc_state);
 		if (rc)
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 2cf8150adf81f..47b514c89ce66 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -718,12 +718,11 @@ static int dpu_encoder_virt_atomic_check(
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



