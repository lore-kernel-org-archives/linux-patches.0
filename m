Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5590D1C68C;
	Sun,  1 Sep 2024 16:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208844; cv=none; b=M1Nq5B8IepETJzncnB5b+gnRvcmJoERhtF/2cAU/qYYhs/wqyFfyTMb4lGfTZoHOQYdbKiL6J/mMKIXOrRLJh9PTxOWZJ2n8jfKEAG/FS+9opKl4Q7cH+ZsswXTRP9cxvjzffpftgyFbjJb7P+9k3eyEldg/TVprC93pVn0/kT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208844; c=relaxed/simple;
	bh=mVyjbKCdjSLLVFe9w+32V4JkoXAMWOeYj5+aD3D0bcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYldkNALFA7PmjVAvmJYkMbSjCSFiCfSsxuECtEq7t94kZxTgduSuOWAEdZB8JkGOHEX5mLCnibNxXOxR6PFIwWaoN/ZncoZkbDKHsBWwLKAuCqGAQ5Lmp1B8fxZU+A907TWuNlc362qkeOd7QU5+gUHDzXWH5lxZkvygPR2NMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ik7vLuUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ik7vLuUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A56C4CEC3;
	Sun,  1 Sep 2024 16:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208844;
	bh=mVyjbKCdjSLLVFe9w+32V4JkoXAMWOeYj5+aD3D0bcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ik7vLuUaAmS7TeNn4CHajWBYXmV+9HZyGnyrCZsyxkILI5t6XBF6Pb8Qm1aWiQ5Ed
	 3cRP2tfQ5MiTC7bH4J+qCJaI/A3iHEigHEWOJQJNxcasWw/gtzAcD6JYe3kwG0T//B
	 SDaGps0zwvF1icx3O1bIO2jc9qUsMq3S9HfMpJwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/134] net: axienet: Wrap DMA pointer writes to prepare for 64 bit
Date: Sun,  1 Sep 2024 18:16:10 +0200
Message-ID: <20240901160811.018736874@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 6a00d0dd3fcfa2ef200973479fbeee62f3681130 ]

Newer versions of the Xilink DMA IP support busses with more than 32
address bits, by introducing an MSB word for the registers holding DMA
pointers (tail/current, RX/TX descriptor addresses).
On IP configured for more than 32 bits, it is also *required* to write
both words, to let the IP recognise this as a start condition for an
MM2S request, for instance.

Wrap the DMA pointer writes with a separate function, to add this
functionality later. For now we stick to the lower 32 bits.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9ff2f816e2aa ("net: axienet: Fix register defines comment description")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 26 ++++++++++++-------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 76f719c28355c..bd03a6d66e122 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -148,6 +148,12 @@ static inline void axienet_dma_out32(struct axienet_local *lp,
 	iowrite32(value, lp->dma_regs + reg);
 }
 
+static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
+				 dma_addr_t addr)
+{
+	axienet_dma_out32(lp, reg, lower_32_bits(addr));
+}
+
 /**
  * axienet_dma_bd_release - Release buffer descriptor rings
  * @ndev:	Pointer to the net_device structure
@@ -286,18 +292,18 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
 	 * halted state. This will make the Rx side ready for reception.
 	 */
-	axienet_dma_out32(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
+	axienet_dma_out_addr(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
 	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
 	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
-	axienet_dma_out32(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
-			  (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
+	axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
+			     (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
 
 	/* Write to the RS (Run-stop) bit in the Tx channel control register.
 	 * Tx channel is now ready to run. But only after we write to the
 	 * tail pointer register that the Tx channel will start transmitting.
 	 */
-	axienet_dma_out32(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
+	axienet_dma_out_addr(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
 	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
@@ -758,7 +764,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	/* Start the transfer */
-	axienet_dma_out32(lp, XAXIDMA_TX_TDESC_OFFSET, tail_p);
+	axienet_dma_out_addr(lp, XAXIDMA_TX_TDESC_OFFSET, tail_p);
 	if (++lp->tx_bd_tail >= lp->tx_bd_num)
 		lp->tx_bd_tail = 0;
 
@@ -850,7 +856,7 @@ static void axienet_recv(struct net_device *ndev)
 	ndev->stats.rx_bytes += size;
 
 	if (tail_p)
-		axienet_dma_out32(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
+		axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, tail_p);
 }
 
 /**
@@ -1683,18 +1689,18 @@ static void axienet_dma_err_handler(struct work_struct *work)
 	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
 	 * halted state. This will make the Rx side ready for reception.
 	 */
-	axienet_dma_out32(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
+	axienet_dma_out_addr(lp, XAXIDMA_RX_CDESC_OFFSET, lp->rx_bd_p);
 	cr = axienet_dma_in32(lp, XAXIDMA_RX_CR_OFFSET);
 	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
-	axienet_dma_out32(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
-			  (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
+	axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET, lp->rx_bd_p +
+			     (sizeof(*lp->rx_bd_v) * (lp->rx_bd_num - 1)));
 
 	/* Write to the RS (Run-stop) bit in the Tx channel control register.
 	 * Tx channel is now ready to run. But only after we write to the
 	 * tail pointer register that the Tx channel will start transmitting
 	 */
-	axienet_dma_out32(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
+	axienet_dma_out_addr(lp, XAXIDMA_TX_CDESC_OFFSET, lp->tx_bd_p);
 	cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET,
 			  cr | XAXIDMA_CR_RUNSTOP_MASK);
-- 
2.43.0



