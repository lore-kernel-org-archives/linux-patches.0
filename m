Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525C9341056;
	Tue, 16 Dec 2025 12:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887816; cv=none; b=iTBWusG/8fCK64huwOA0NlTjXFIHXsFGRk2njKTgYr5LvW2FMH+ApNcj+G84/EeNo4Pb2jA+7ar8LGcRannweAj1wIjJuNnnIhQEFEgBakX5O0jXczHYSyrRKpA4YZqYTHO4pdT0jl6E73ALvVYbB4uxa1mdqc+/JL+uopuB8eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887816; c=relaxed/simple;
	bh=cNs8KzJPglsL8tUzGFWmFY+2HXN6PmrrrTK6E5+ZFEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSWkH0Uw26Wq68G2zuUr2bXwkdVji6RqpOTUksRRSAPQyT/xCZH7su+Tn1a1ieTUJbsjaDsDxirjzq1KCn/xSV0RAmVM+k3JbsGTMVJ5L4j5baAEU8x1FTPcMpCyFIeMP+A92+xeAXFRs3yI3s5ii6TCii8mAEPN6I14f3KZUDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6eaOJCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6eaOJCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD45C4CEF1;
	Tue, 16 Dec 2025 12:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887816;
	bh=cNs8KzJPglsL8tUzGFWmFY+2HXN6PmrrrTK6E5+ZFEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6eaOJCzLOylCqLGVOUpwpW8jhv9rFB2yssKAEPkmSctlcDh8Inh5o45Uu05hpTV5
	 Cp6o6sZj14HWhw+FGx+VOyMiK6oTk3ty9zWvL//MrOgNlBKe7STYJrdAY8izEZHFKk
	 cvS44P3OKyFkDxrPrkaOMc+tQkH8eJIHV4El2Ue8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 345/614] phy: rockchip: naneng-combphy: Fix PCIe L1ss support RK3528
Date: Tue, 16 Dec 2025 12:11:52 +0100
Message-ID: <20251216111413.863098994@linuxfoundation.org>
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

[ Upstream commit a2a18e5da64f8da306fa97c397b4c739ea776f37 ]

When PCIe link enters L1 PM substates, the PHY will turn off its
PLL for power-saving. However, it turns off the PLL too fast which
leads the PHY to be broken. According to the PHY document, we need
to delay PLL turnoff time.

Fixes: bbcca4fac873 ("phy: rockchip: naneng-combphy: Add RK3528 support")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/1763459526-35004-1-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
index a3ef19807b9ef..e303bec8a996f 100644
--- a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
@@ -21,6 +21,9 @@
 #define REF_CLOCK_100MHz		(100 * HZ_PER_MHZ)
 
 /* RK3528 COMBO PHY REG */
+#define RK3528_PHYREG5				0x14
+#define RK3528_PHYREG5_GATE_TX_PCK_SEL		BIT(3)
+#define RK3528_PHYREG5_GATE_TX_PCK_DLY_PLL_OFF	BIT(3)
 #define RK3528_PHYREG6				0x18
 #define RK3528_PHYREG6_PLL_KVCO			GENMASK(12, 10)
 #define RK3528_PHYREG6_PLL_KVCO_VALUE		0x2
@@ -504,6 +507,10 @@ static int rk3528_combphy_cfg(struct rockchip_combphy_priv *priv)
 	case REF_CLOCK_100MHz:
 		rockchip_combphy_param_write(priv->phy_grf, &cfg->pipe_clk_100m, true);
 		if (priv->type == PHY_TYPE_PCIE) {
+			/* Gate_tx_pck_sel length select for L1ss support */
+			rockchip_combphy_updatel(priv, RK3528_PHYREG5_GATE_TX_PCK_SEL,
+						 RK3528_PHYREG5_GATE_TX_PCK_DLY_PLL_OFF, RK3528_PHYREG5);
+
 			/* PLL KVCO tuning fine */
 			val = FIELD_PREP(RK3528_PHYREG6_PLL_KVCO, RK3528_PHYREG6_PLL_KVCO_VALUE);
 			rockchip_combphy_updatel(priv, RK3528_PHYREG6_PLL_KVCO, val,
-- 
2.51.0



