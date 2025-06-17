Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8EF1E3DCF;
	Tue, 17 Jun 2025 16:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178585; cv=none; b=VXTVQGA4/7S4a9GpjDR/7DtItmIBXSjuyyLxX/L9EKpEB7yZjxQg0ryQ7vn9sl4riTCwcUaXD0YV8HrKjdcfQSRmLkkrrEWM7swsmo3NqCeLSjd6K4WmO/0Y9vlUfBI1l9fV/tPQ6ccKN/MWB33pEbBZEufg3dR1JHjSfHUtmqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178585; c=relaxed/simple;
	bh=rRFa0YMKaivV5eBpJ597M9CeLfDzoVeqvAj57TJqEeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHOjDIbrnh61btznGMx3DYwd4qoEZLmme5LvY5rZqUD4u8Ytw/n8zwZcqbZ+LcM1jE1qUWKVnz23vKf85KCkjFPwPhzCLMrUkJpOp5yzkYuH1GfMFRohY8cXT7rNw9/BZY1KhJ4mAy9ZauU1DrfxnhqX4FsoD4B8mPT73RW6G8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twKguGOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twKguGOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAE6C4CEE3;
	Tue, 17 Jun 2025 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178585;
	bh=rRFa0YMKaivV5eBpJ597M9CeLfDzoVeqvAj57TJqEeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twKguGOp8w/JudyKEfm6D+lKMNmLx9r4Zvj6gzPnAPL+DTlHZJW7jhzByIcHJ79K+
	 IbuniXaXuBPDrMy11Qw7UKBFMnhDsIfgJmbzFOWzOTMYufmsNpfOgWyb0kpkEO2aZ/
	 f5EPPD7dwIaH0YGgDRswDkYK9z8xD5vh2mwq7rgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 492/780] phy: rockchip: samsung-hdptx: Do no set rk_hdptx_phy->rate in case of errors
Date: Tue, 17 Jun 2025 17:23:20 +0200
Message-ID: <20250617152511.523393656@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 1f4d382769e3b38dfc498c806811dae856e40f31 ]

Ensure rk_hdptx_ropll_tmds_cmn_config() updates hdptx->rate only after
all the other operations have been successful.

Fixes: c4b09c562086 ("phy: phy-rockchip-samsung-hdptx: Add clock provider support")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20250318-phy-sam-hdptx-bpc-v6-4-8cb1678e7663@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index 6cfed3fcd647b..61db514ce5cfb 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -1008,9 +1008,7 @@ static int rk_hdptx_ropll_tmds_cmn_config(struct rk_hdptx_phy *hdptx,
 {
 	const struct ropll_config *cfg = NULL;
 	struct ropll_config rc = {0};
-	int i;
-
-	hdptx->rate = rate * 100;
+	int ret, i;
 
 	for (i = 0; i < ARRAY_SIZE(ropll_tmds_cfg); i++)
 		if (rate == ropll_tmds_cfg[i].bit_rate) {
@@ -1065,7 +1063,11 @@ static int rk_hdptx_ropll_tmds_cmn_config(struct rk_hdptx_phy *hdptx,
 	regmap_update_bits(hdptx->regmap, CMN_REG(0086), PLL_PCG_CLK_EN_MASK,
 			   FIELD_PREP(PLL_PCG_CLK_EN_MASK, 0x1));
 
-	return rk_hdptx_post_enable_pll(hdptx);
+	ret = rk_hdptx_post_enable_pll(hdptx);
+	if (!ret)
+		hdptx->rate = rate * 100;
+
+	return ret;
 }
 
 static int rk_hdptx_ropll_tmds_mode_config(struct rk_hdptx_phy *hdptx,
-- 
2.39.5



