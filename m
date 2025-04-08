Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BE5264FB0;
	Tue,  8 Apr 2025 11:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113118; cv=none; b=M2FzMB3qYAxmSYcSkk1tINDnAagJlyJVpdCrnfkSsL68TvW+rkKYY7JvvpOIjySTR9HnSAgBxqy7NDIQxsOJdudIxFNcMSCV3bSxx1QEcgstcn9f/JYwh54dLtfrSQk9iEirdg+3o9ccrQCAQZ0stlA/qpn/o/ZuXbF1GJuwyKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113118; c=relaxed/simple;
	bh=Rx4moDJLxLb5QybH9J9eFaDtpyUMka+TuMm/rk8ywcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gw4fyJNgMAz+OKqcE/xs8pNxKSRU8Se26Slxxj1EPoIJZX/ldGtOu5Gt9FbV72s1vSOejJ8ncLTC11n5Rndmji/KdW0PBmBvWqdSVqCKmCT7s5Srb79er3xwjwz6z3XSh8rp3n7G8ESSo66yRrleybQMuI2QpI+HPooygoC4Das=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4znpxtZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4znpxtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00C7C4CEE5;
	Tue,  8 Apr 2025 11:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113118;
	bh=Rx4moDJLxLb5QybH9J9eFaDtpyUMka+TuMm/rk8ywcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4znpxtZd6n7bunMh1Qa5jS7JHMgOjViJgHKcV284jbqwtZvWLDKeO2HM9Uw2Ft2D
	 p2d/x/1h7l1KqRIdXOgHfaJDMwhGNd1ujtR45LljpJwSt5EnBMvBHtgwOTjMzSZKEw
	 FQDvxmZhe9iT8ytmCCGcMXqm6YlVWqTH83FScR0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/268] drm/msm/dpu: dont use active in atomic_check()
Date: Tue,  8 Apr 2025 12:47:32 +0200
Message-ID: <20250408104829.613190193@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ad57368dc13f0..2df1e6293062d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -1210,10 +1210,6 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 
 	DRM_DEBUG_ATOMIC("%s: check\n", dpu_crtc->name);
 
-	/* force a full mode set if active state changed */
-	if (crtc_state->active_changed)
-		crtc_state->mode_changed = true;
-
 	if (cstate->num_mixers) {
 		rc = _dpu_crtc_check_and_setup_lm_bounds(crtc, crtc_state);
 		if (rc)
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 35cf9080168b1..99cccde5d2216 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -669,12 +669,11 @@ static int dpu_encoder_virt_atomic_check(
 
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
 	}
-- 
2.39.5



