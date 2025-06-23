Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0CD21B8F6;
	Mon, 23 Jun 2025 22:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716862; cv=none; b=K0vR4lHgZ+P7YgypoXf32rDMBc61SwL2CnX+ApTN+ybUqoFU1/k+OYKvpcHSDpDEJ7KQioAQJHTZQFjHApru87HOQ1Hf7JNI0tHqEoRyQRMkZYDVJWs9Hjg5L9WYY5/jZCHdSGTtrOTmo9IyFh8woGAwSIMKImltapCki5pfPQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716862; c=relaxed/simple;
	bh=YV0A2fRNCF1/4xBlYeO2iQsSYRodZGQgqKqvHttlDjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUZO0TyhLVn9aDHs6PaqKmdklnCwUnNG3Pn+zZqFMg6zV1it7kQHu/fgTP3FSolTfo3yKZxacfuBeWaWbxj9ubR49+VXQth90XPtPx1O5d1CaEwocnZn2G26wTiVsLBXb+/6BQ+ax5fTGrl9hOI1aZz0DhjxyQm3Lzsi2jXGy08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hN508Y8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hN508Y8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041F5C4CEEA;
	Mon, 23 Jun 2025 22:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716862;
	bh=YV0A2fRNCF1/4xBlYeO2iQsSYRodZGQgqKqvHttlDjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hN508Y8OZnj0aV0LJJB3vdPp9je1eZumv8vs3Wuh5Mk5/BdXkdzcnK2rou8yOmiJB
	 1O9eRnlphKiIopnEO+3yFNLyBq8RiCY9xLf2PZ5LDTwrrPBFbY9mG85CujDLl3G7RR
	 QumZHPVp875JwFfRPPPzMdjdggAOJztlY6OZnHJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 366/411] drm/msm/dsi/dsi_phy_10nm: Fix missing initial VCO rate
Date: Mon, 23 Jun 2025 15:08:30 +0200
Message-ID: <20250623130642.856783653@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0b782cc18b3f4..e14044d3c95a3 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c
@@ -713,6 +713,13 @@ static int dsi_pll_10nm_init(struct msm_dsi_phy *phy)
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



