Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB3F3BBFDD;
	Wed, 30 Sep 2026 19:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796070; cv=none; b=bcozBCBfRHvw3cX3fWoQz7QDWTp7ErO+ZnVdiwtXWmjF1tF+IwG7dXEArQLH1P7bkUaeNZlZQGVllXRrjJpQHBla7dIi+M4vErhTkWULV49E7BbhrUvJg9gZSGrg+IcsNcAFSI151qu0iaU+C6XmwnZEjAUZUjDtNn3/UAuUPUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796070; c=relaxed/simple;
	bh=PmeVKsLc9MjkhIQOLy+aq+rLvs7ce5udXhv3JOx6o3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEd4cnqYWlLCctvtKZ0FtrKcHggxbUqL8cVsiumsFAoAz5ALpxQx+glfEV61aU62bOvxmjsgxBI1KQKlVBWlpQ4KRFhicpgRFGMyx5GgD9ocxU6bwVcalQ/bxOBK1ybLKcYkIeS0jd+DfDzeXcqnKOvHI1MBNmCl/V3LM+fwn9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCV4oOdv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCV4oOdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EED01F000FF;
	Wed, 30 Sep 2026 19:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796068;
	bh=kTw7G8hx0FZRPEECx5JfiCQ9lZUAj/NGnFQ5HWiVUuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCV4oOdv1JVERh9ZmcUJu9iIsgFtcpPfztSXYSUovMZT806797vPKPs1xIEgXR09g
	 D2jnm6DFGRCCfVIIcJ9oqdeieI2VnCmI8MaJ76SOd7LZ8T4dJjz5onWtMaCpy4pfhn
	 oMX/+yOUD6LtHbb8TEMrSjUTqqaFUFbWRrLDZ5LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0783/1193] phy: mediatek: phy-mtk-hdmi-mt8195: Fix TMDS clk bit ratio setting
Date: Wed, 30 Sep 2026 17:24:27 +0200
Message-ID: <20260930152451.645904242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 486a70ef848264dcf9a57f0bb0452848db9537de ]

The comment in the mtk_phy_tmds_clk_ratio() function clearly and
correctly explains that the TMDS ratio has to be 1/10 for data
rates under 3.4Gbps, and 1/40 over that.

Unfortunately though, the TXC_DIV register setting was wrong, as
in value 3 means to divide by 8 and, in order to achieve the in
spec 1/40 (tmds) data rate, this has to divide by 4 instead!

Add definitions for the TXC_DIV register values clearly explaining
the meanings (DIV2, DIV4, DIV8), and program the correct, DIV 4,
value to the register in mtk_phy_tmds_clk_ratio().

This fixes out of spec clocking and, with this change, SoCs using
the MT8195 class HDMI PHYs can now successfully be configured to
output 3840x2160@60Hz over HDMI.

Fixes: 45810d486bb4 ("phy: mediatek: add support for phy-mtk-hdmi-mt8195")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260911074015.9994-3-angelogioacchino.delregno@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c | 2 +-
 drivers/phy/mediatek/phy-mtk-hdmi-mt8195.h | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c b/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c
index 80600b2b6b38d..9f2c4db843479 100644
--- a/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c
+++ b/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c
@@ -34,7 +34,7 @@ mtk_phy_tmds_clk_ratio(struct mtk_hdmi_phy *hdmi_phy, bool enable)
 	 * clock bit ratio 1:40, under 3.4Gbps, clock bit ratio 1:10
 	 */
 	if (enable)
-		mtk_phy_update_field(regs + HDMI20_CLK_CFG, REG_TXC_DIV, 3);
+		mtk_phy_update_field(regs + HDMI20_CLK_CFG, REG_TXC_DIV, VAL_TXC_DIV4);
 	else
 		mtk_phy_clear_bits(regs + HDMI20_CLK_CFG, REG_TXC_DIV);
 }
diff --git a/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.h b/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.h
index 22a68dc9550ca..8e118a10ffbf2 100644
--- a/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.h
+++ b/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.h
@@ -17,6 +17,9 @@
 
 #define HDMI20_CLK_CFG 0x70
 #define REG_TXC_DIV GENMASK(31, 30)
+#define VAL_TXC_DIV2 1
+#define VAL_TXC_DIV4 2
+#define VAL_TXC_DIV8 3
 
 #define HDMI_1_CFG_0 0x00
 #define RG_HDMITX21_DRV_IBIAS_CLK GENMASK(10, 5)
-- 
2.53.0



