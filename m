Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE33302CD6;
	Sat, 25 Oct 2025 16:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408714; cv=none; b=YWk3JFljcsMZSto224bJ80T4fTnGnRKOkTmWm/ay7fschfIr7yb5C4zZPEVTx6l81dZCTWOEa8RFtuTGD0gZLKKDB9QIWQ4xvA8CjpEmWyG+uVQbGcbdntIYOMdZu/EOgfbovwPihqs1EorKATdzDR/AGTb0WpmnPr6iQqRLerw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408714; c=relaxed/simple;
	bh=VpyZWWbFYpU622RfhzTyfqYAx/2Hh2zoj65DJwJfiP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WqTO2783fh74bqH9Z8KvS3JwPx78NTqCQF1kNF6c/KlptbfHeTkR1SMuDUvJOOUCm5o+QmyV078gNt+p8odSSIGeoYQHDzHLMMg+Aq+66QJonbfz19C+3POODVtC/uWlri6XPEOMr2d9LfgmJ/AUg3Qn8pIlSW3hPs7rP7EapR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6AZM+qY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6AZM+qY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA81C4CEF5;
	Sat, 25 Oct 2025 16:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408712;
	bh=VpyZWWbFYpU622RfhzTyfqYAx/2Hh2zoj65DJwJfiP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6AZM+qYoiaMCUEqy/KpvcePC4xY1U8zz36ylUHwR7ig4cefeQDOPvWlvzT7f+cOf
	 CVpBasCDhuf8truRTp42//GqVfViVTUl458l5aJxuLa1KszpVPk2A9bc3zfsr0jnf3
	 YCLYupOnU6XVvC1cX7VRNwBSpQlWP0iqJa/xC47/ylk6fhCerw4f1EbQT9DIHzvPbJ
	 +BTUU9rtajyLosHa9QIQuM3MwdMYOQ1koS0MYLM2FxaUfXW6GPPVZ5kq64IYe3btEI
	 qSrWvnnIGjy6/IQ53Kr5eOEGG7OtZ678jffdKdqpPaVV9fhXiITnQ/j1f/lgOE1SQ0
	 I7/tyA80xVV5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jessica Zhang <jessica.zhang@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	lumag@kernel.org,
	quic_abhinavk@quicinc.com,
	alexander.deucher@amd.com,
	zichenxie0106@gmail.com,
	alexandre.f.demers@gmail.com,
	krzysztof.kozlowski@linaro.org,
	robin.clark@oss.qualcomm.com
Subject: [PATCH AUTOSEL 6.17] drm/msm/dpu: Filter modes based on adjusted mode clock
Date: Sat, 25 Oct 2025 11:54:40 -0400
Message-ID: <20251025160905.3857885-49-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Prevents exposing display modes that the DPU core cannot clock at
    once inefficiency is accounted for, avoiding atomic commits that
    would be silently clamped or fail at runtime on SoCs with low core
    clk ceilings (e.g., QCS615). This is a user-visible correctness fix,
    not a feature.

- Key changes
  - Adds a helper to consistently apply the DPU clock inefficiency
    factor:
    - `dpu_core_perf_adjusted_mode_clk()` scales a given mode clock by
      `perf_cfg->clk_inefficiency_factor` and returns the adjusted value
      (drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c:40).
  - Refactors core clock calculation to use the new helper (no
    functional change vs. prior logic beyond centralizing the scaling):
    - `_dpu_core_perf_calc_clk()` now computes `mode_clk` as max of the
      mode-based estimate and per-plane clocks, then returns the
      adjusted clock via the helper
      (drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c:92,102,109,112).
  - Filters modes early in CRTC validation based on the adjusted mode
    clock:
    - In `dpu_crtc_mode_valid()`, the driver computes `adjusted_mode_clk
      = dpu_core_perf_adjusted_mode_clk(mode->clock, perf_cfg)` and
      rejects the mode if `adjusted_mode_clk * 1000 > max_core_clk_rate`
      (converts kHz → Hz), returning `MODE_CLOCK_HIGH`
      (drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c:1532,1545,1552).
  - Exposes the helper in the header so it can be used by CRTC
    (drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.h:57).

- Why this is correct and needed
  - The core CRTC clock request is at least the (inefficiency-adjusted)
    mode clock; the driver already derives core clock as max(plane_clk,
    mode_clk) and then applies the inefficiency factor
    (drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c:102,109,112).
    Therefore, any mode whose adjusted dot clock exceeds
    `max_core_clk_rate` cannot be driven without underclocking.
  - Today, when the required clock exceeds the limit, the driver clamps
    the rate to `max_core_clk_rate` rather than failing, which can
    underdeliver bandwidth/clock and cause visible problems. See the
    clamp in `dpu_core_perf_crtc_update()` before setting OPP: `clk_rate
    = min(clk_rate, kms->perf.max_core_clk_rate)`
    (drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c:383–389). Early
    filtering avoids exposing such modes to userspace altogether.
  - The inefficiency factor is already part of catalog data (e.g., 105%
    on sm8150) and is used elsewhere for perf modeling; using it for
    mode filtering aligns validation with the runtime perf model
    (drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h:352).

- Scope and risk
  - Minimal, localized to MSM DPU driver. No architectural changes, no
    cross-subsystem API/ABI changes.
  - The new check relies on already-initialized `perf.perf_cfg` and
    `max_core_clk_rate` which are set during KMS init
    (drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c:1237–1244).
  - The change reduces mode availability only when a mode cannot be
    driven within the hardware core clock limit (after inefficiency),
    which is correct and prevents runtime issues.

- Stable criteria
  - Fixes a real-world bug that affects users (modes being accepted that
    hardware cannot support at required core clock), especially on
    lower-CLK SoCs.
  - Change is small and contained, avoids new features, and follows
    existing perf infrastructure.
  - Low regression risk and clear benefit in preventing invalid modes.

Given the above, this is a good candidate for backporting to stable
trees.

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

