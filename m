Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E0A303A08;
	Tue, 11 Nov 2025 01:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823849; cv=none; b=erQ2r3fUKIS+7tbSY4ITRTQsqo9fRlh3/I1uuzXUidlGqqYLcPUNsUIYKd4qRqsZPEezJNlfWPi7ykOnBDm8qfri+c1dMi8zsjvySMuKsaHTuyPf46QGHNctYkQpiU1ZkfHyrzmSYtNiussfEQJfltGzGTLpqymyoTXunu1FeY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823849; c=relaxed/simple;
	bh=iWNqWotAPZMBDXNqkKVojR8BUp56hgi9JJaBAiUamwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ar7JitXDvxScoM/YU4jlGFra39kk5WCewrmQWs+pDcUYPBkH/T4K/8NigKtDKVB2BaA2KMfjpRQSnk/z/+YvUHZ/R9DTLpXUALhkFhY+9d6+WHlKEuMJZkLHpNyZqLMuxWM4X6pJX/lTW6Cp2zV/4OyQTCHihXiic2xnLordpU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uT9YVS1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uT9YVS1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1204CC113D0;
	Tue, 11 Nov 2025 01:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823849;
	bh=iWNqWotAPZMBDXNqkKVojR8BUp56hgi9JJaBAiUamwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uT9YVS1nuStJmDipRwF806iYwRhIMVe2VEs11HezOr+hURDULrKMFDA4Uc/v7HR9n
	 Zz8Mf31HzL+wOgY8OVnJeKB931bFSwErTZwHPZYZSE0qXhMgw3XYsIhheJoIz0xjdu
	 Kt/oShL8m5cZ1HtemD1RBXEyrGIjJCa2dmSvjm5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jessica Zhang <jessica.zhang@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 384/849] drm/msm/dpu: Filter modes based on adjusted mode clock
Date: Tue, 11 Nov 2025 09:39:14 +0900
Message-ID: <20251111004545.714810648@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jessica Zhang <jessica.zhang@oss.qualcomm.com>

[ Upstream commit 62b7d68352881609e237b303fa391410ebc583a5 ]

Filter out modes that have a clock rate greater than the max core clock
rate when adjusted for the perf clock factor

This is especially important for chipsets such as QCS615 that have lower
limits for the MDP max core clock.

Since the core CRTC clock is at least the mode clock (adjusted for the
perf clock factor) [1], the modes supported by the driver should be less
than the max core clock rate.

[1] https://elixir.bootlin.com/linux/v6.12.4/source/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c#L83

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Jessica Zhang <jessica.zhang@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/652041/
Link: https://lore.kernel.org/r/20250506-filter-modes-v2-1-c20a0b7aa241@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c | 35 +++++++++++++------
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h |  3 ++
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c      | 12 +++++++
 3 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
index 0fb5789c60d0d..13cc658065c56 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -31,6 +31,26 @@ enum dpu_perf_mode {
 	DPU_PERF_MODE_MAX
 };
 
+/**
+ * dpu_core_perf_adjusted_mode_clk - Adjust given mode clock rate according to
+ *   the perf clock factor.
+ * @crtc_clk_rate - Unadjusted mode clock rate
+ * @perf_cfg: performance configuration
+ */
+u64 dpu_core_perf_adjusted_mode_clk(u64 mode_clk_rate,
+				    const struct dpu_perf_cfg *perf_cfg)
+{
+	u32 clk_factor;
+
+	clk_factor = perf_cfg->clk_inefficiency_factor;
+	if (clk_factor) {
+		mode_clk_rate *= clk_factor;
+		do_div(mode_clk_rate, 100);
+	}
+
+	return mode_clk_rate;
+}
+
 /**
  * _dpu_core_perf_calc_bw() - to calculate BW per crtc
  * @perf_cfg: performance configuration
@@ -75,28 +95,21 @@ static u64 _dpu_core_perf_calc_clk(const struct dpu_perf_cfg *perf_cfg,
 	struct drm_plane *plane;
 	struct dpu_plane_state *pstate;
 	struct drm_display_mode *mode;
-	u64 crtc_clk;
-	u32 clk_factor;
+	u64 mode_clk;
 
 	mode = &state->adjusted_mode;
 
-	crtc_clk = (u64)mode->vtotal * mode->hdisplay * drm_mode_vrefresh(mode);
+	mode_clk = (u64)mode->vtotal * mode->hdisplay * drm_mode_vrefresh(mode);
 
 	drm_atomic_crtc_for_each_plane(plane, crtc) {
 		pstate = to_dpu_plane_state(plane->state);
 		if (!pstate)
 			continue;
 
-		crtc_clk = max(pstate->plane_clk, crtc_clk);
-	}
-
-	clk_factor = perf_cfg->clk_inefficiency_factor;
-	if (clk_factor) {
-		crtc_clk *= clk_factor;
-		do_div(crtc_clk, 100);
+		mode_clk = max(pstate->plane_clk, mode_clk);
 	}
 
-	return crtc_clk;
+	return dpu_core_perf_adjusted_mode_clk(mode_clk, perf_cfg);
 }
 
 static struct dpu_kms *_dpu_crtc_get_kms(struct drm_crtc *crtc)
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h
index d2f21d34e501e..3740bc97422ca 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h
@@ -54,6 +54,9 @@ struct dpu_core_perf {
 	u32 fix_core_ab_vote;
 };
 
+u64 dpu_core_perf_adjusted_mode_clk(u64 clk_rate,
+				    const struct dpu_perf_cfg *perf_cfg);
+
 int dpu_core_perf_crtc_check(struct drm_crtc *crtc,
 		struct drm_crtc_state *state);
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index 94912b4708fb5..d59512e45af05 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -1534,6 +1534,7 @@ static enum drm_mode_status dpu_crtc_mode_valid(struct drm_crtc *crtc,
 						const struct drm_display_mode *mode)
 {
 	struct dpu_kms *dpu_kms = _dpu_crtc_get_kms(crtc);
+	u64 adjusted_mode_clk;
 
 	/* if there is no 3d_mux block we cannot merge LMs so we cannot
 	 * split the large layer into 2 LMs, filter out such modes
@@ -1541,6 +1542,17 @@ static enum drm_mode_status dpu_crtc_mode_valid(struct drm_crtc *crtc,
 	if (!dpu_kms->catalog->caps->has_3d_merge &&
 	    mode->hdisplay > dpu_kms->catalog->caps->max_mixer_width)
 		return MODE_BAD_HVALUE;
+
+	adjusted_mode_clk = dpu_core_perf_adjusted_mode_clk(mode->clock,
+							    dpu_kms->perf.perf_cfg);
+
+	/*
+	 * The given mode, adjusted for the perf clock factor, should not exceed
+	 * the max core clock rate
+	 */
+	if (dpu_kms->perf.max_core_clk_rate < adjusted_mode_clk * 1000)
+		return MODE_CLOCK_HIGH;
+
 	/*
 	 * max crtc width is equal to the max mixer width * 2 and max height is 4K
 	 */
-- 
2.51.0



