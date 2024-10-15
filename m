Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8DC1D90CD;
	Tue, 15 Oct 2024 11:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993123; cv=none; b=kZneQvg+zid50BRQ4sRPzl4anY34mQvQU3gT95QtWsjPdLHHCdOKH/sdUY/uwhNtViUOMIWl4m5k4JrjxU6epzjlk9VeJTcAw1LGzHZQOqE7ATri/T11tSzy+YI1EejOee2xaiLXHmsBCWMVVZ9BlWDbSMoSqwqhtzotzXXFvkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993123; c=relaxed/simple;
	bh=iE3W9ud+u/z26N6ewCqEeW5VO0c33ynbNc2/JOJ2fh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJaA8BSHUdnOTyDl8m5YAiOPn2KJZT6iGxtHhPwu67y6CL9RVOXW0gqi7MspG0kfOAdimHh1Hr8+iTqCH7bPUO/dNY9oG7X+/S9uV/meAiI+DaXmyYlCz7YDRzlqJvb0Tl0PqIdMLjFndgBaislog/PQ+J2Fmw2k3KoGzsuGIu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4ZgZLF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4ZgZLF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DBAC4CECE;
	Tue, 15 Oct 2024 11:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993122;
	bh=iE3W9ud+u/z26N6ewCqEeW5VO0c33ynbNc2/JOJ2fh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4ZgZLF4Ut0cjpsuMgvdo1R9WHARYSSVKnuRbInLxdc9/dcu1qOdPUfVk1uFrRxHH
	 cNNbKQleO5zQLYOtuyIDNYik0Ws4LfToR5GGp1vGFJktRjfwlQj3gxAP9EMVYPYyvh
	 yF2BxfUeH0qm7MC/g6auUkrstSj1j9K1y+catVy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/691] net: axienet: add coalesce timer ethtool configuration
Date: Tue, 15 Oct 2024 13:23:54 +0200
Message-ID: <20241015112451.697391931@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 0b79b8dc97b9df4f873f63161e3050bafc4c4237 ]

Add the ability to configure the RX/TX coalesce timer with ethtool.
Change default setting to scale with the clock rate rather than being a
fixed number of clock cycles.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5a6caa2cfabb ("net: xilinx: axienet: Fix packet counting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  | 10 ++--
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 51 +++++++++++++++----
 2 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index d2c17def082b4..8b3b414b00113 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -119,11 +119,11 @@
 #define XAXIDMA_IRQ_ERROR_MASK		0x00004000 /* Error interrupt */
 #define XAXIDMA_IRQ_ALL_MASK		0x00007000 /* All interrupts */
 
-/* Default TX/RX Threshold and waitbound values for SGDMA mode */
+/* Default TX/RX Threshold and delay timer values for SGDMA mode */
 #define XAXIDMA_DFT_TX_THRESHOLD	24
-#define XAXIDMA_DFT_TX_WAITBOUND	254
+#define XAXIDMA_DFT_TX_USEC		50
 #define XAXIDMA_DFT_RX_THRESHOLD	1
-#define XAXIDMA_DFT_RX_WAITBOUND	254
+#define XAXIDMA_DFT_RX_USEC		50
 
 #define XAXIDMA_BD_CTRL_TXSOF_MASK	0x08000000 /* First tx packet */
 #define XAXIDMA_BD_CTRL_TXEOF_MASK	0x04000000 /* Last tx packet */
@@ -425,7 +425,9 @@ struct axidma_bd {
  * @csum_offload_on_tx_path:	Stores the checksum selection on TX side.
  * @csum_offload_on_rx_path:	Stores the checksum selection on RX side.
  * @coalesce_count_rx:	Store the irq coalesce on RX side.
+ * @coalesce_usec_rx:	IRQ coalesce delay for RX
  * @coalesce_count_tx:	Store the irq coalesce on TX side.
+ * @coalesce_usec_tx:	IRQ coalesce delay for TX
  */
 struct axienet_local {
 	struct net_device *ndev;
@@ -481,7 +483,9 @@ struct axienet_local {
 	int csum_offload_on_rx_path;
 
 	u32 coalesce_count_rx;
+	u32 coalesce_usec_rx;
 	u32 coalesce_count_tx;
+	u32 coalesce_usec_tx;
 };
 
 /**
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index a33e860861d55..fd5f7ac7f4a6b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -33,7 +33,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
 #include <linux/skbuff.h>
-#include <linux/spinlock.h>
+#include <linux/math64.h>
 #include <linux/phy.h>
 #include <linux/mii.h>
 #include <linux/ethtool.h>
@@ -226,6 +226,28 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 			  lp->rx_bd_p);
 }
 
+/**
+ * axienet_usec_to_timer - Calculate IRQ delay timer value
+ * @lp:		Pointer to the axienet_local structure
+ * @coalesce_usec: Microseconds to convert into timer value
+ */
+static u32 axienet_usec_to_timer(struct axienet_local *lp, u32 coalesce_usec)
+{
+	u32 result;
+	u64 clk_rate = 125000000; /* arbitrary guess if no clock rate set */
+
+	if (lp->axi_clk)
+		clk_rate = clk_get_rate(lp->axi_clk);
+
+	/* 1 Timeout Interval = 125 * (clock period of SG clock) */
+	result = DIV64_U64_ROUND_CLOSEST((u64)coalesce_usec * clk_rate,
+					 (u64)125000000);
+	if (result > 255)
+		result = 255;
+
+	return result;
+}
+
 /**
  * axienet_dma_start - Set up DMA registers and start DMA operation
  * @lp:		Pointer to the axienet_local structure
@@ -241,7 +263,8 @@ static void axienet_dma_start(struct axienet_local *lp)
 	 * the first RX packet. Otherwise leave at 0 to disable delay interrupt.
 	 */
 	if (lp->coalesce_count_rx > 1)
-		lp->rx_dma_cr |= (XAXIDMA_DFT_RX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+		lp->rx_dma_cr |= (axienet_usec_to_timer(lp, lp->coalesce_usec_rx)
+					<< XAXIDMA_DELAY_SHIFT) |
 				 XAXIDMA_IRQ_DELAY_MASK;
 	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
 
@@ -252,7 +275,8 @@ static void axienet_dma_start(struct axienet_local *lp)
 	 * the first TX packet. Otherwise leave at 0 to disable delay interrupt.
 	 */
 	if (lp->coalesce_count_tx > 1)
-		tx_cr |= (XAXIDMA_DFT_TX_WAITBOUND << XAXIDMA_DELAY_SHIFT) |
+		tx_cr |= (axienet_usec_to_timer(lp, lp->coalesce_usec_tx)
+				<< XAXIDMA_DELAY_SHIFT) |
 			 XAXIDMA_IRQ_DELAY_MASK;
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, tx_cr);
 
@@ -1464,14 +1488,12 @@ axienet_ethtools_get_coalesce(struct net_device *ndev,
 			      struct kernel_ethtool_coalesce *kernel_coal,
 			      struct netlink_ext_ack *extack)
 {
-	u32 regval = 0;
 	struct axienet_local *lp = netdev_priv(ndev);
-	regval = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
-	ecoalesce->rx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
-					     >> XAXIDMA_COALESCE_SHIFT;
-	regval = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
-	ecoalesce->tx_max_coalesced_frames = (regval & XAXIDMA_COALESCE_MASK)
-					     >> XAXIDMA_COALESCE_SHIFT;
+
+	ecoalesce->rx_max_coalesced_frames = lp->coalesce_count_rx;
+	ecoalesce->rx_coalesce_usecs = lp->coalesce_usec_rx;
+	ecoalesce->tx_max_coalesced_frames = lp->coalesce_count_tx;
+	ecoalesce->tx_coalesce_usecs = lp->coalesce_usec_tx;
 	return 0;
 }
 
@@ -1504,8 +1526,12 @@ axienet_ethtools_set_coalesce(struct net_device *ndev,
 
 	if (ecoalesce->rx_max_coalesced_frames)
 		lp->coalesce_count_rx = ecoalesce->rx_max_coalesced_frames;
+	if (ecoalesce->rx_coalesce_usecs)
+		lp->coalesce_usec_rx = ecoalesce->rx_coalesce_usecs;
 	if (ecoalesce->tx_max_coalesced_frames)
 		lp->coalesce_count_tx = ecoalesce->tx_max_coalesced_frames;
+	if (ecoalesce->tx_coalesce_usecs)
+		lp->coalesce_usec_tx = ecoalesce->tx_coalesce_usecs;
 
 	return 0;
 }
@@ -1536,7 +1562,8 @@ static int axienet_ethtools_nway_reset(struct net_device *dev)
 }
 
 static const struct ethtool_ops axienet_ethtool_ops = {
-	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
+	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USECS,
 	.get_drvinfo    = axienet_ethtools_get_drvinfo,
 	.get_regs_len   = axienet_ethtools_get_regs_len,
 	.get_regs       = axienet_ethtools_get_regs,
@@ -2091,7 +2118,9 @@ static int axienet_probe(struct platform_device *pdev)
 	}
 
 	lp->coalesce_count_rx = XAXIDMA_DFT_RX_THRESHOLD;
+	lp->coalesce_usec_rx = XAXIDMA_DFT_RX_USEC;
 	lp->coalesce_count_tx = XAXIDMA_DFT_TX_THRESHOLD;
+	lp->coalesce_usec_tx = XAXIDMA_DFT_TX_USEC;
 
 	ret = axienet_mdio_setup(lp);
 	if (ret)
-- 
2.43.0



