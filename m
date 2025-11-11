Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA8C33F39D;
	Tue, 11 Nov 2025 01:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824008; cv=none; b=I2wiLl7gV7fWy7vaxm9YIEJ9SJZxl0Rd51jN7LfGpUmzNDRCFGI5+MnQ11NPhJB7bW5bwBO48AnZhAvOdQkWfzexXS6xbM6P42eMs7JWFkwBwlSjQiiyaVG1pkgcNXsbxP/G9urRKHu+eKoPEWpLJ07kyUsy0VtUVzGJWzacNP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824008; c=relaxed/simple;
	bh=YyIymvxzxpccLWmULbu16ovYvF+yxEiT0oVJtKYpPTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7M7nqM2uk71DfqBorWz7vqBUPPUp5kD5K62OHJP3dG6XlG3PPj7iNzmLhguN3I1PJEkX4iO4qWSuj6j5yKvNGGgP9Ve0niJm/jRIJ44V7n9DIoh6ifpALi51F2eQICnY7zDeN/1Kx+OAkCzZx9AyFDXLUi6mWisWh85es7mW4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQEF67Ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQEF67Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0CCC116B1;
	Tue, 11 Nov 2025 01:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824008;
	bh=YyIymvxzxpccLWmULbu16ovYvF+yxEiT0oVJtKYpPTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQEF67FfU9S2isZ8/pMwc+iSTToN+UVuwaWQqdHegXBFAGOFf/bc9np6GW9AyuP7U
	 aa4y1RqECxeF+l9V8M2eHOoD6Aim5IV/g1HwOtiNvy7zxjxKFyF2AX9tTpCaXCO7ch
	 TgM4BBfS/4cOnRZOUrCTp37emh9NlRQax28L0DUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 419/849] drm/msm/dsi/phy_7nm: Fix missing initial VCO rate
Date: Tue, 11 Nov 2025 09:39:49 +0900
Message-ID: <20251111004546.571174060@linuxfoundation.org>
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



