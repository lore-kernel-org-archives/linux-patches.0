Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349F634D4DC;
	Wed,  3 Dec 2025 16:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777760; cv=none; b=n4omzIbx3MMjZ8uFPTZZRBltlFlDLhUOR9tpU0bjJl9HDsQC5+/6ygAMoFW/ZMhSVBtruztfvy6rUW3lRh0NBXb51GyRBV1n0iMSC1jQOL/8ceIGMSF4zKDM1VbvCZ8P0bpGC6WgxmXPMZ1iHE98PlLALSnzS5GWeCJTapCU2jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777760; c=relaxed/simple;
	bh=hsGBtzFcXF5feSV50KKYHjEJCJgxvuvDBKQ0sUj6f64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zo9ErrVHix3bk6aWiPG7icwo/BDZn6CZLV5SwLVIyy0m/BBWW5bBpUY5bzVC0z0WXfE+z4R/Ru9YAb6eK/2/cQUPTWtxc+Ya8Rrl5Jc52q0t2/uwMIs6EkCrcnYzkSeeCA9dzzuhAPoIVVIbd785ngF/u8Im6Bi13CM5nnLTB6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUztl51F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUztl51F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02B1C4CEF5;
	Wed,  3 Dec 2025 16:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777760;
	bh=hsGBtzFcXF5feSV50KKYHjEJCJgxvuvDBKQ0sUj6f64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUztl51FKlaHfp8RizH8HzkxnYUiV+uDXDzGOwufEUYx9vx27mTQmO0Ufmq9R7IuC
	 ba5Vn/aRslbndXgepBTQE5w+F87XA9WRAUIhC7PqQO/YQLtynDtJ8o0UuqxtSGuSXY
	 FOjtSR/ssTGOZ9RhPD5mj0pwnOXlZCuCL9sl2/40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/392] drm/msm/dsi/phy_7nm: Fix missing initial VCO rate
Date: Wed,  3 Dec 2025 16:24:41 +0100
Message-ID: <20251203152418.913147283@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 10d5b9cf98df5..a5f51534e6e96 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
@@ -760,6 +760,12 @@ static int dsi_pll_7nm_init(struct msm_dsi_phy *phy)
 
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



