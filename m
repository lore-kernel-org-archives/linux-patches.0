Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C906B7F7E8;
	Wed, 21 Feb 2024 14:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524560; cv=none; b=H2Kj0BUpNk4XVP2dnpOIBU81nEIEXLkvCJJGHab8iV4v8JmkvClbWwpBuxbPGt9wzmRcmRRncm2Ii3JJZF+4GhkkkBHWLfD8jh1trB1SZBea3ngX3iHhck5jGvMihj+pCbZd0oRp2y7SfEJpUxcIx9YpBGKdrEHq6XmV/vESJXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524560; c=relaxed/simple;
	bh=AXBjoEjSgqiyTPeS9144b8xeTuAsyOAHf5kUR0T7JpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmPzXO5vOJK5DmCjoiFj/Kege1eCD25ujvUL0snLISAALd37ruMenlu0qF2424LTF/86aeDy9yib7aKUrgdu39ulCVl4Ad4st6EvN8nz2q+dPLeZAdafkQe/z0rayDnVgtxQ1OaMFBgFaHmqMQRR74ecOw4VqjR60Vuowu+tLKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbCPFn3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbCPFn3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD28C433F1;
	Wed, 21 Feb 2024 14:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524560;
	bh=AXBjoEjSgqiyTPeS9144b8xeTuAsyOAHf5kUR0T7JpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbCPFn3WNvPwX8LXXC8gunSLHkFT91Vo0zvSUSMUhLINorYHLntPNS95Jnr90yx36
	 mf63CexnemGDhbi8Qu36kMgLLjSoxzoFjhX0/wEN8XRP7eMuZjKLhcWnx5lAlUIH94
	 ma93FuUzV09Hd4VErYlutJaxsM8WK6M1/hY7MScY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furong Xu <0x1207@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/379] net: stmmac: xgmac: fix handling of DPP safety error for DMA channels
Date: Wed, 21 Feb 2024 14:07:13 +0100
Message-ID: <20240221130002.430551019@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Furong Xu <0x1207@gmail.com>

[ Upstream commit 46eba193d04f8bd717e525eb4110f3c46c12aec3 ]

Commit 56e58d6c8a56 ("net: stmmac: Implement Safety Features in
XGMAC core") checks and reports safety errors, but leaves the
Data Path Parity Errors for each channel in DMA unhandled at all, lead to
a storm of interrupt.
Fix it by checking and clearing the DMA_DPP_Interrupt_Status register.

Fixes: 56e58d6c8a56 ("net: stmmac: Implement Safety Features in XGMAC core")
Signed-off-by: Furong Xu <0x1207@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  1 +
 .../net/ethernet/stmicro/stmmac/dwxgmac2.h    |  3 +
 .../ethernet/stmicro/stmmac/dwxgmac2_core.c   | 57 ++++++++++++++++++-
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index af4303523929..0bc345aff1cb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -189,6 +189,7 @@ struct stmmac_safety_stats {
 	unsigned long mac_errors[32];
 	unsigned long mtl_errors[32];
 	unsigned long dma_errors[32];
+	unsigned long dma_dpp_errors[32];
 };
 
 /* Number of fields in Safety Stats */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index eee58e051387..c9e9e40747d0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -282,6 +282,8 @@
 #define XGMAC_RXCEIE			BIT(4)
 #define XGMAC_TXCEIE			BIT(0)
 #define XGMAC_MTL_ECC_INT_STATUS	0x000010cc
+#define XGMAC_MTL_DPP_CONTROL		0x000010e0
+#define XGMAC_DDPP_DISABLE		BIT(0)
 #define XGMAC_MTL_TXQ_OPMODE(x)		(0x00001100 + (0x80 * (x)))
 #define XGMAC_TQS			GENMASK(25, 16)
 #define XGMAC_TQS_SHIFT			16
@@ -364,6 +366,7 @@
 #define XGMAC_DCEIE			BIT(1)
 #define XGMAC_TCEIE			BIT(0)
 #define XGMAC_DMA_ECC_INT_STATUS	0x0000306c
+#define XGMAC_DMA_DPP_INT_STATUS	0x00003074
 #define XGMAC_DMA_CH_CONTROL(x)		(0x00003100 + (0x80 * (x)))
 #define XGMAC_SPH			BIT(24)
 #define XGMAC_PBLx8			BIT(16)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index b06066746302..a5344fcf77e1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -788,6 +788,43 @@ static const struct dwxgmac3_error_desc dwxgmac3_dma_errors[32]= {
 	{ false, "UNKNOWN", "Unknown Error" }, /* 31 */
 };
 
+static const char * const dpp_rx_err = "Read Rx Descriptor Parity checker Error";
+static const char * const dpp_tx_err = "Read Tx Descriptor Parity checker Error";
+static const struct dwxgmac3_error_desc dwxgmac3_dma_dpp_errors[32] = {
+	{ true, "TDPES0", dpp_tx_err },
+	{ true, "TDPES1", dpp_tx_err },
+	{ true, "TDPES2", dpp_tx_err },
+	{ true, "TDPES3", dpp_tx_err },
+	{ true, "TDPES4", dpp_tx_err },
+	{ true, "TDPES5", dpp_tx_err },
+	{ true, "TDPES6", dpp_tx_err },
+	{ true, "TDPES7", dpp_tx_err },
+	{ true, "TDPES8", dpp_tx_err },
+	{ true, "TDPES9", dpp_tx_err },
+	{ true, "TDPES10", dpp_tx_err },
+	{ true, "TDPES11", dpp_tx_err },
+	{ true, "TDPES12", dpp_tx_err },
+	{ true, "TDPES13", dpp_tx_err },
+	{ true, "TDPES14", dpp_tx_err },
+	{ true, "TDPES15", dpp_tx_err },
+	{ true, "RDPES0", dpp_rx_err },
+	{ true, "RDPES1", dpp_rx_err },
+	{ true, "RDPES2", dpp_rx_err },
+	{ true, "RDPES3", dpp_rx_err },
+	{ true, "RDPES4", dpp_rx_err },
+	{ true, "RDPES5", dpp_rx_err },
+	{ true, "RDPES6", dpp_rx_err },
+	{ true, "RDPES7", dpp_rx_err },
+	{ true, "RDPES8", dpp_rx_err },
+	{ true, "RDPES9", dpp_rx_err },
+	{ true, "RDPES10", dpp_rx_err },
+	{ true, "RDPES11", dpp_rx_err },
+	{ true, "RDPES12", dpp_rx_err },
+	{ true, "RDPES13", dpp_rx_err },
+	{ true, "RDPES14", dpp_rx_err },
+	{ true, "RDPES15", dpp_rx_err },
+};
+
 static void dwxgmac3_handle_dma_err(struct net_device *ndev,
 				    void __iomem *ioaddr, bool correctable,
 				    struct stmmac_safety_stats *stats)
@@ -799,6 +836,13 @@ static void dwxgmac3_handle_dma_err(struct net_device *ndev,
 
 	dwxgmac3_log_error(ndev, value, correctable, "DMA",
 			   dwxgmac3_dma_errors, STAT_OFF(dma_errors), stats);
+
+	value = readl(ioaddr + XGMAC_DMA_DPP_INT_STATUS);
+	writel(value, ioaddr + XGMAC_DMA_DPP_INT_STATUS);
+
+	dwxgmac3_log_error(ndev, value, false, "DMA_DPP",
+			   dwxgmac3_dma_dpp_errors,
+			   STAT_OFF(dma_dpp_errors), stats);
 }
 
 static int dwxgmac3_safety_feat_config(void __iomem *ioaddr, unsigned int asp)
@@ -835,6 +879,12 @@ static int dwxgmac3_safety_feat_config(void __iomem *ioaddr, unsigned int asp)
 	value |= XGMAC_TMOUTEN; /* FSM Timeout Feature */
 	writel(value, ioaddr + XGMAC_MAC_FSM_CONTROL);
 
+	/* 5. Enable Data Path Parity Protection */
+	value = readl(ioaddr + XGMAC_MTL_DPP_CONTROL);
+	/* already enabled by default, explicit enable it again */
+	value &= ~XGMAC_DDPP_DISABLE;
+	writel(value, ioaddr + XGMAC_MTL_DPP_CONTROL);
+
 	return 0;
 }
 
@@ -868,7 +918,11 @@ static int dwxgmac3_safety_feat_irq_status(struct net_device *ndev,
 		ret |= !corr;
 	}
 
-	err = dma & (XGMAC_DEUIS | XGMAC_DECIS);
+	/* DMA_DPP_Interrupt_Status is indicated by MCSIS bit in
+	 * DMA_Safety_Interrupt_Status, so we handle DMA Data Path
+	 * Parity Errors here
+	 */
+	err = dma & (XGMAC_DEUIS | XGMAC_DECIS | XGMAC_MCSIS);
 	corr = dma & XGMAC_DECIS;
 	if (err) {
 		dwxgmac3_handle_dma_err(ndev, ioaddr, corr, stats);
@@ -884,6 +938,7 @@ static const struct dwxgmac3_error {
 	{ dwxgmac3_mac_errors },
 	{ dwxgmac3_mtl_errors },
 	{ dwxgmac3_dma_errors },
+	{ dwxgmac3_dma_dpp_errors },
 };
 
 static int dwxgmac3_safety_feat_dump(struct stmmac_safety_stats *stats,
-- 
2.43.0



