Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBC4279918;
	Sat, 25 Oct 2025 16:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408924; cv=none; b=bbPbiQpLEzCsRkhCrs7ABdbdYP2BilDLPGxeKJ+zJX36OwZuKSDuVoeVyqvl+fZTn257dX+2U42eDHI/es7kg2zZr6cbJb+rqaYEqAYhilBy+OrD4X456ZuZV3Etu12MiKxYk6NpiHhb2cMZH1W0GjVFLm93ALuobQWznTksQH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408924; c=relaxed/simple;
	bh=2MjjwEisNt9tsNebqWRatjA6eLUSviJHcSJU/w6Mi/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mx8xctP5s5YHVa0fBpGYMmP5+BgHg8MhAtf1cil6aY/k2O8w4do4GYKioj6KLPrOkPtIPr6Q5rOFypyY1uSI6Nipwy6ndhCqKZkDco7U/D0k5N3ZCFHPhLo4GE/jTBKPM5f5QJ/IQ5qg1dGTgT6/ctYh7vfsr21H8iFDlbjVlRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hc/nu6eR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hc/nu6eR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2F9C4CEFF;
	Sat, 25 Oct 2025 16:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408924;
	bh=2MjjwEisNt9tsNebqWRatjA6eLUSviJHcSJU/w6Mi/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hc/nu6eR8MchB0TzE6mpWZ1k3wHCZ++n4iMGn/o7D/Aq8R+OIuUYCI3q25DQEhsN0
	 yJd4WijUyQjlMk8yLy4tC1jdJjrFuWUVQWNystiL1BwqAVvzF9dmT32M0g7yvb7RED
	 xdK7QpVnsKh06YSvNG7qI8tatpZQ3iiXKpFd8/jFPmkAd1XbW1oP9J7cWg1xxRvU4G
	 dedQd1McuCqr+f0fWH6F6pShYx2uXwre6hV5hKljHv/UBx4t0pOvpLLhbtuyjhOFgH
	 K+q6l9GlwYZn0rH1AdcKVhn57BKl73DLA2f/ot703RVUo3+CsT/xrUJ5aYm9dZYE7l
	 RaetdwPLdla9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	lumag@kernel.org,
	quic_abhinavk@quicinc.com,
	konrad.dybcio@oss.qualcomm.com,
	quic_amakhija@quicinc.com,
	alexandre.f.demers@gmail.com,
	bmasney@redhat.com
Subject: [PATCH AUTOSEL 6.17-5.15] drm/msm/dsi/phy_7nm: Fix missing initial VCO rate
Date: Sat, 25 Oct 2025 11:56:05 -0400
Message-ID: <20251025160905.3857885-134-sashal@kernel.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 5ddcb0cb9d10e6e70a68e0cb8f0b8e3a7eb8ccaf ]

Driver unconditionally saves current state on first init in
dsi_pll_7nm_init(), but does not save the VCO rate, only some of the
divider registers.  The state is then restored during probe/enable via
msm_dsi_phy_enable() -> msm_dsi_phy_pll_restore_state() ->
dsi_7nm_pll_restore_state().

Restoring calls dsi_pll_7nm_vco_set_rate() with
pll_7nm->vco_current_rate=0, which basically overwrites existing rate of
VCO and messes with clock hierarchy, by setting frequency to 0 to clock
tree.  This makes anyway little sense - VCO rate was not saved, so
should not be restored.

If PLL was not configured configure it to minimum rate to avoid glitches
and configuring entire in clock hierarchy to 0 Hz.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/657827/
Link: https://lore.kernel.org/r/20250610-b4-sm8750-display-v6-9-ee633e3ddbff@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Bug fixed: On first init the driver saves PLL state but not the VCO
  rate, so the subsequent restore path programs the VCO to 0 Hz,
  breaking the clock tree and potentially blanking display. This is
  evident because the init path unconditionally saves state without
  setting `vco_current_rate`
  (drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:890), while the restore
  path uses `pll_7nm->vco_current_rate` to reprogram the VCO
  (drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:677), and the VCO
  programming logic computes dividers from `pll->vco_current_rate`
  (drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:129).
- Root cause in code:
  - Init: `msm_dsi_phy_pll_save_state(phy)` is called but no VCO rate is
    captured (drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:890).
  - Restore: `dsi_7nm_pll_restore_state()` writes cached mux/dividers
    and then calls `dsi_pll_7nm_vco_set_rate(…,
    pll_7nm->vco_current_rate, …)`
    (drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:677), which assumes
    `vco_current_rate` is valid.
  - Divider calc uses `pll->vco_current_rate` directly
    (drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:129), so a zero value
    yields dec/frac=0, propagating 0 Hz into the clock tree.
  - Restore is actually invoked during enable: `msm_dsi_phy_enable()`
    calls `msm_dsi_phy_pll_restore_state()` via the ops hook
    (drivers/gpu/drm/msm/dsi/phy/dsi_phy.c:774), so the bad
    `vco_current_rate` directly impacts runtime bring-up/handover.
- The fix: Initialize `vco_current_rate` at init by reading the current
  hardware rate; if it can’t be determined, fall back to the minimum
  safe PLL rate to avoid 0 Hz:
  - Added in `dsi_pll_7nm_init()`:
    - `if (!dsi_pll_7nm_vco_recalc_rate(&pll_7nm->clk_hw,
      VCO_REF_CLK_RATE)) pll_7nm->vco_current_rate =
      pll_7nm->phy->cfg->min_pll_rate;`
      (drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:893).
- Why this is correct and low risk:
  - `dsi_pll_7nm_vco_recalc_rate()` reads current PLL dec/frac and
    updates/returns the actual VCO rate
    (drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:572), so subsequent
    restore reprograms the VCO to its real, pre-existing frequency,
    enabling clean handover from bootloader firmware.
  - If hardware isn’t configured (recalc returns 0), falling back to
    `min_pll_rate` avoids the destructive 0 Hz program while still
    keeping a safe, bounded frequency using SoC-provided limits (e.g.,
    `min_pll_rate` in the 7nm cfgs at
    drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c:1289, 1309, 1332, 1350…).
  - This mirrors established practice in other MSM DSI PHY generations,
    e.g. the 10nm PHY already does the same recalc/fallback in its init
    path (drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c:709), and the 14nm
    PHY also guards against a 0 rate on startup
    (drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c:546).
  - The change is localized to a single function in one driver, does not
    alter interfaces, and only affects first-init/handover behavior. It
    reduces, rather than increases, the chance of glitches by avoiding a
    0 Hz restore.
- Backport criteria:
  - Important user-facing bug fix (prevents display/clock tree breakage
    on bring-up/handover).
  - Small and self-contained (one file, a few lines).
  - No new features or architectural changes; consistent with other PHY
    drivers’ behavior.
  - Low regression risk with clear, safe fallback behavior.

Given the above, this is a strong candidate for stable backport.

 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
index 6b765f3fd529a..5c8a3394c3da0 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
@@ -843,6 +843,12 @@ static int dsi_pll_7nm_init(struct msm_dsi_phy *phy)
 
 	/* TODO: Remove this when we have proper display handover support */
 	msm_dsi_phy_pll_save_state(phy);
+	/*
+	 * Store also proper vco_current_rate, because its value will be used in
+	 * dsi_7nm_pll_restore_state().
+	 */
+	if (!dsi_pll_7nm_vco_recalc_rate(&pll_7nm->clk_hw, VCO_REF_CLK_RATE))
+		pll_7nm->vco_current_rate = pll_7nm->phy->cfg->min_pll_rate;
 
 	return 0;
 }
-- 
2.51.0

