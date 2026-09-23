Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF92340A6F;
	Wed, 23 Sep 2026 14:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174514; cv=none; b=QOhmohUb7tLdWvfQMbqZKuvhAm/v75mvbCnXXIZVYlNyedCscw5iSi6jRHxR27zXDYdYmsYfjyemktiFiR/OdjbLOSOLXZmd97IEZyzjlWr7JyOPFAyGjGN1qpDUQy4wjJ0sQ9eywYEA1KglSHK2/4GEhQV8AEZRVIHFiOEOvG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174514; c=relaxed/simple;
	bh=0v57/b3hNIX3oKUL3SYn4zuWZ0bmSz4dbYT6UQhlv/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzqPB2N5L4bJhmAgJadGXIKWLpTj7lbPljWeJjxUFegbW5IfqVrShR4Zt/a3UiKRZ89RUUE/Ed1CoaLBFnAkTHVQkmyGuLXekkrIQYYgMvJUpcnRdO7mNTU27PChJxEWRRypV1rNMbMswZp1jtWER1T75pPCoTMYyc60ohQtfpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMdOup16; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMdOup16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCCC1F000FF;
	Wed, 23 Sep 2026 14:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174513;
	bh=RR9OGdAF4v714CDNlT3UwVouuHQ3luSCV/XKt+B2k4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMdOup16pW3CKQ0vzkXrHW+l+wu02+sO7VjFDZKj7jEzGiV+3L0N/zXnq6PuEYKaF
	 6ahWZB3g50S+l50+HYqplD7fbKzVwK+sQPlhFHvGrjUNKIn4en7f04tYJOzZ+QXbn5
	 YQZ+OzIL7dnmnQbcDCuaDPdFmrywPe6kup9lFcMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/398] phy: mediatek: phy-mtk-hdmi-mt8195: Fix TMDS clk bit ratio setting
Date: Wed, 23 Sep 2026 16:03:00 +0200
Message-ID: <20260923140646.187028150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index 829d329af1732..2f03c4e66d6fe 100644
--- a/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c
+++ b/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c
@@ -36,7 +36,7 @@ mtk_phy_tmds_clk_ratio(struct mtk_hdmi_phy *hdmi_phy, bool enable)
 	 * clock bit ratio 1:40, under 3.4Gbps, clock bit ratio 1:10
 	 */
 	if (enable)
-		mtk_phy_update_field(regs + HDMI20_CLK_CFG, REG_TXC_DIV, 3);
+		mtk_phy_update_field(regs + HDMI20_CLK_CFG, REG_TXC_DIV, VAL_TXC_DIV4);
 	else
 		mtk_phy_clear_bits(regs + HDMI20_CLK_CFG, REG_TXC_DIV);
 }
diff --git a/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.h b/drivers/phy/mediatek/phy-mtk-hdmi-mt8195.h
index e26caaf4d104c..58800d7659ca0 100644
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



