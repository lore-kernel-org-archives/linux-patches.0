Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777A12222B2;
	Mon, 23 Jun 2025 22:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717614; cv=none; b=uKalBArr/2hSW4HNMcYvUe6A8dfm23uq/kEP775stIYsQcDjeiuo0V7r+LtxE4Gr1t6TlmPosVo+kDQpDOrqlRVhsUu+DuXYzHIpyC3FUQpti77NTCdB3CrLjYd16bjCcniWe89/rCY0hiic2BJPlbqLc3NKMO7UKlxUbFSSSRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717614; c=relaxed/simple;
	bh=HjX643CthLlTvuHWJK3JmiDGajS5aDKqMc0D4iG6pXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSZL6+CT+t/ay9de6SrVWTxmUZRy+31pfREDfr0c69I1yBvYfKJrVXPCnA1FqsFqgRbcn/t+tYKl8Wr+RPLi14IjmL2A/5Bzx9034dliUsLYg2euEEdaiZ2PDiCwTgMVGsi3hY81ROexGmlzypZNXJMVTMsCRRvdk+EOZCq8bho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QR3ASYpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QR3ASYpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F917C4CEEA;
	Mon, 23 Jun 2025 22:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717614;
	bh=HjX643CthLlTvuHWJK3JmiDGajS5aDKqMc0D4iG6pXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QR3ASYpwXtadMDPHqN2PkUlFhczLG86uxYvc3DRcxvG2pAEVOAKt+bUFkZjJFJTMr
	 AAeQ5sOgobTtAwkGyICoKnYavhNa9W2l7CvsSYw2JxtBHEjuJDGxBVoDSl3bgHgJv0
	 3AalMr42h0W6eCm95hEQVdhIq3Qhk09x02gAw1SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 471/508] drm/msm/dsi/dsi_phy_10nm: Fix missing initial VCO rate
Date: Mon, 23 Jun 2025 15:08:36 +0200
Message-ID: <20250623130656.683995608@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 8a48e35becb214743214f5504e726c3ec131cd6d ]

Driver unconditionally saves current state on first init in
dsi_pll_10nm_init(), but does not save the VCO rate, only some of the
divider registers.  The state is then restored during probe/enable via
msm_dsi_phy_enable() -> msm_dsi_phy_pll_restore_state() ->
dsi_10nm_pll_restore_state().

Restoring calls dsi_pll_10nm_vco_set_rate() with
pll_10nm->vco_current_rate=0, which basically overwrites existing rate of
VCO and messes with clock hierarchy, by setting frequency to 0 to clock
tree.  This makes anyway little sense - VCO rate was not saved, so
should not be restored.

If PLL was not configured configure it to minimum rate to avoid glitches
and configuring entire in clock hierarchy to 0 Hz.

Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/sz4kbwy5nwsebgf64ia7uq4ee7wbsa5uy3xmlqwcstsbntzcov@ew3dcyjdzmi2/
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Fixes: a4ccc37693a2 ("drm/msm/dsi_pll_10nm: restore VCO rate during
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/654796/
Link: https://lore.kernel.org/r/20250520111325.92352-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c
index 27b592c776a30..1c111969342a7 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c
@@ -716,6 +716,13 @@ static int dsi_pll_10nm_init(struct msm_dsi_phy *phy)
 	/* TODO: Remove this when we have proper display handover support */
 	msm_dsi_phy_pll_save_state(phy);
 
+	/*
+	 * Store also proper vco_current_rate, because its value will be used in
+	 * dsi_10nm_pll_restore_state().
+	 */
+	if (!dsi_pll_10nm_vco_recalc_rate(&pll_10nm->clk_hw, VCO_REF_CLK_RATE))
+		pll_10nm->vco_current_rate = pll_10nm->phy->cfg->min_pll_rate;
+
 	return 0;
 }
 
-- 
2.39.5



