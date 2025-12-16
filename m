Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C1235502D;
	Tue, 16 Dec 2025 11:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885943; cv=none; b=SVNpx126B/eu3NNXDKNDfZdYzO9PC4XMY8MBfcXXeeHOWwOUuZBXY9FPpL67eZ2oqzk3us9ij9BKwjsS65ALQ60c9n4twtzYem7jagUpimax5hVOtTlNkLl5Y1f1a4o+nUVcX7bIJEeA1kKj9JVJhwuR48B8Z1yU3wApCZBkfdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885943; c=relaxed/simple;
	bh=FJwYzxF4VITM+N826QmRESTMcK0rJQuODIkU4AgVegE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1Wgz7RKkAgSjZFh3fWhNLCGUNa8uyc08n1udSvJeILUsuZwaABg9hUF4AFkCT6tICGHWqD3a5b/bMn1nOvaIxwZuoBSSyU5I7uaGwssmmVuySs1fGDmdlRTcdnfc5JcDCRR89bBB09bRJTTnySWNRfq1bDaUFNnaADCftC66rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZeqtYME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZeqtYME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1675FC4CEF1;
	Tue, 16 Dec 2025 11:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885942;
	bh=FJwYzxF4VITM+N826QmRESTMcK0rJQuODIkU4AgVegE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZeqtYMELgaTJF3ntkfY2jwDeUttS/UaBrHFinzF+MEI//DEZBEBtaQFpoHcXwyqY
	 EVg9RAQ0ayCISC35b3Tc3UbjHapccNZU6SueggHzPKrWxx3PDmFANSRk+OWcxy4MzW
	 2Vjfdiqo2U1CCKG2pCEh4N1X6N+04UJaeVkzu9Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 291/507] phy: rockchip: naneng-combphy: Fix PCIe L1ss support RK3562
Date: Tue, 16 Dec 2025 12:12:12 +0100
Message-ID: <20251216111356.019073080@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit be866e68966d20bcc4a73708093d577176f99c0c ]

When PCIe link enters L1 PM substates, the PHY will turn off its
PLL for power-saving. However, it turns off the PLL too fast which
leads the PHY to be broken. According to the PHY document, we need
to delay PLL turnoff time.

Fixes: f13bff25161b ("phy: rockchip-naneng-combo: Support rk3562")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/1763459526-35004-2-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
index ce84166cd7725..6d69288693952 100644
--- a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
@@ -64,6 +64,10 @@
 #define RK3568_PHYREG18				0x44
 #define RK3568_PHYREG18_PLL_LOOP		0x32
 
+#define RK3568_PHYREG30				0x74
+#define RK3568_PHYREG30_GATE_TX_PCK_SEL         BIT(7)
+#define RK3568_PHYREG30_GATE_TX_PCK_DLY_PLL_OFF BIT(7)
+
 #define RK3568_PHYREG32				0x7C
 #define RK3568_PHYREG32_SSC_MASK		GENMASK(7, 4)
 #define RK3568_PHYREG32_SSC_DIR_MASK		GENMASK(5, 4)
@@ -474,6 +478,10 @@ static int rk3562_combphy_cfg(struct rockchip_combphy_priv *priv)
 	case REF_CLOCK_100MHz:
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_100m, true);
 		if (priv->type == PHY_TYPE_PCIE) {
+			/* Gate_tx_pck_sel length select for L1ss support */
+			rockchip_combphy_updatel(priv, RK3568_PHYREG30_GATE_TX_PCK_SEL,
+						 RK3568_PHYREG30_GATE_TX_PCK_DLY_PLL_OFF,
+						 RK3568_PHYREG30);
 			/* PLL KVCO tuning fine */
 			val = FIELD_PREP(RK3568_PHYREG33_PLL_KVCO_MASK,
 					 RK3568_PHYREG33_PLL_KVCO_VALUE);
-- 
2.51.0



