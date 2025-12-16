Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B92261B9C;
	Tue, 16 Dec 2025 12:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887956; cv=none; b=ICfulYo+d8Bvbf7apt8pNd38LcYP0KqhDC4Ngq8p+W4natQgaTTjMqK9Ob32994Zs+8Jqip8lgapJMmaAzXuypM6C79jWc6fdgz9KTYynF6roAg2HFy3bHCz5XjKzUt4xDBPCtjWraWEnq/OzKgBLZqM+fMKcrta7EBH5Cbgzn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887956; c=relaxed/simple;
	bh=SH431dr5Lb/OP22Z8uTTI2Pezg7ZNRsTqAxB8cuZndg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmxzWpVEMbksKQ5FVd37m7BX9EAkrdMEgL/HTbgmJzZenOSlKb3LxkkuOACgv4P+oXB7IHXKyFNbWmf3XDKwFkoGh/QKA+/PLa01221AvFN5bExjiH88dfaVCK31RtkRUvO2ZoTEtGSepRSdFZoZ4+Py0bzCMr6E8wAo5Kziqag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/xie+sH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/xie+sH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BD3C4CEF1;
	Tue, 16 Dec 2025 12:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887955;
	bh=SH431dr5Lb/OP22Z8uTTI2Pezg7ZNRsTqAxB8cuZndg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/xie+sHW2ccxxPJL+eQYDJxKEAQQpm1L5LsZ4iJHky7d7VDZLz0+xzCUezpT4jst
	 Cj/WWFhroFggPaDBLOPLsvMjrsH7tg4geI1iPBHI+2yKncjmDqpSnyDMEw5NN3lSe+
	 5gR6YBiz9pQKjTi58e7OGeP0IdbeKAvRy4NZlVHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 346/614] phy: rockchip: naneng-combphy: Fix PCIe L1ss support RK3562
Date: Tue, 16 Dec 2025 12:11:53 +0100
Message-ID: <20251216111413.899324518@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e303bec8a996f..7f8fc8e6d4890 100644
--- a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
@@ -106,6 +106,10 @@
 #define RK3568_PHYREG18				0x44
 #define RK3568_PHYREG18_PLL_LOOP		0x32
 
+#define RK3568_PHYREG30				0x74
+#define RK3568_PHYREG30_GATE_TX_PCK_SEL         BIT(7)
+#define RK3568_PHYREG30_GATE_TX_PCK_DLY_PLL_OFF BIT(7)
+
 #define RK3568_PHYREG32				0x7C
 #define RK3568_PHYREG32_SSC_MASK		GENMASK(7, 4)
 #define RK3568_PHYREG32_SSC_DIR_MASK		GENMASK(5, 4)
@@ -664,6 +668,10 @@ static int rk3562_combphy_cfg(struct rockchip_combphy_priv *priv)
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



