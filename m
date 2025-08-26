Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E34320330;
	Tue, 26 Aug 2025 11:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208144; cv=none; b=R9SeDaLjKrftu9cqO1CpwnAl7AqHTjtfEJrbn/BwT8ccjx22UBXe6B6QWYGP762B3f0T8dBgoeTak4L8jK2RdOYdK9jHHiZFRIpByFczXMhrw3XqNRgbgP0vbXukwOwXZ4g9REkSsK8DNE4b0850z1iHX9dj4Rb6F6ff6UGyGfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208144; c=relaxed/simple;
	bh=wnFd3va8o1lOkU4Mz7/rQyJ7/1A8Mn9key71JuqBsIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Va302UVlw3MZfaXaDU0YiA3VLETpTRjc2FwCPQQUNWchXzOcABAlnWy9jO8dkpTepsdUD5kOQi4eSQrLOTA4KyrMQ5W+C0OreRc7js9CIRVmuKXmXq1x8fOC/+VAaRUlMjx9xKClvCsZ3/WDzqjY+yapXdbMZ9AtTrDqx2/qW94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usnk5XgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usnk5XgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354C6C4CEF1;
	Tue, 26 Aug 2025 11:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208144;
	bh=wnFd3va8o1lOkU4Mz7/rQyJ7/1A8Mn9key71JuqBsIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usnk5XgP/yB42zo2AzQdaRv2cCEOgkjaIrHqDcFvzZnEtmfbHEfUxDIa+YE4C3DuT
	 ihTDpNp/t49qN58F9qI+cXKFw31awR6AFqOqnEUgXho5yZPaqV3W5GxiFCefumnp9f
	 tpvQKjk99fD/RwQbfH5dDNLFptY7kOkBJdgtVOEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Drew Fustini <fustini@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 414/457] net: stmmac: thead: Enable TX clock before MAC initialization
Date: Tue, 26 Aug 2025 13:11:38 +0200
Message-ID: <20250826110947.526191615@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit 6d6714bf0c4e8eb2274081b4b023dfa01581c123 ]

The clk_tx_i clock must be supplied to the MAC for successful
initialization. On TH1520 SoC, the clock is provided by an internal
divider configured through GMAC_PLLCLK_DIV register when using RGMII
interface. However, currently we don't setup the divider before
initialization of the MAC, resulting in DMA reset failures if the
bootloader/firmware doesn't enable the divider,

[    7.839601] thead-dwmac ffe7060000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
[    7.938338] thead-dwmac ffe7060000.ethernet eth0: PHY [stmmac-0:02] driver [RTL8211F Gigabit Ethernet] (irq=POLL)
[    8.160746] thead-dwmac ffe7060000.ethernet eth0: Failed to reset the dma
[    8.170118] thead-dwmac ffe7060000.ethernet eth0: stmmac_hw_setup: DMA engine initialization failed
[    8.179384] thead-dwmac ffe7060000.ethernet eth0: __stmmac_open: Hw setup failed

Let's simply write GMAC_PLLCLK_DIV_EN to GMAC_PLLCLK_DIV to enable the
divider before MAC initialization. Note that for reconfiguring the
divisor, the divider must be disabled first and re-enabled later to make
sure the new divisor take effect.

The exact clock rate doesn't affect MAC's initialization according to my
test. It's set to the speed required by RGMII when the linkspeed is
1Gbps and could be reclocked later after link is up if necessary.

Fixes: 33a1a01e3afa ("net: stmmac: Add glue layer for T-HEAD TH1520 SoC")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Reviewed-by: Drew Fustini <fustini@kernel.org>
Link: https://patch.msgid.link/20250815104803.55294-1-ziyao@disroot.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-thead.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-thead.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-thead.c
index f2946bea0bc2..6c6c49e4b66f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-thead.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-thead.c
@@ -152,7 +152,7 @@ static int thead_set_clk_tx_rate(void *bsp_priv, struct clk *clk_tx_i,
 static int thead_dwmac_enable_clk(struct plat_stmmacenet_data *plat)
 {
 	struct thead_dwmac *dwmac = plat->bsp_priv;
-	u32 reg;
+	u32 reg, div;
 
 	switch (plat->mac_interface) {
 	case PHY_INTERFACE_MODE_MII:
@@ -164,6 +164,13 @@ static int thead_dwmac_enable_clk(struct plat_stmmacenet_data *plat)
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 		/* use pll */
+		div = clk_get_rate(plat->stmmac_clk) / rgmii_clock(SPEED_1000);
+		reg = FIELD_PREP(GMAC_PLLCLK_DIV_EN, 1) |
+		      FIELD_PREP(GMAC_PLLCLK_DIV_NUM, div);
+
+		writel(0, dwmac->apb_base + GMAC_PLLCLK_DIV);
+		writel(reg, dwmac->apb_base + GMAC_PLLCLK_DIV);
+
 		writel(GMAC_GTXCLK_SEL_PLL, dwmac->apb_base + GMAC_GTXCLK_SEL);
 		reg = GMAC_TX_CLK_EN | GMAC_TX_CLK_N_EN | GMAC_TX_CLK_OUT_EN |
 		      GMAC_RX_CLK_EN | GMAC_RX_CLK_N_EN;
-- 
2.50.1



