Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE94A1DFED;
	Mon, 27 May 2024 19:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836928; cv=none; b=MnZMYgnzhFJJfml/NE8vW7E/paM/C56/IH81eJxnm6CJ7AbbP7aWDtYnPZYToBzk2iOxBQOGMjV/q9HDJHuXQD7+eAGHDrObKzubgiLzvN7n9FWg0qhn4kRW16SWo8Z83nSp0ZVgFrTWuB83rUl9Umf4Zo+AvFvc5CEtUpHbB3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836928; c=relaxed/simple;
	bh=RsdPAnxZQX41zbbSWAshGbtGFB38mP7fRyT7nXnGjf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbdpCn7LqCqrSULtXbElKaTFO0pYZR5cowpIrEZPNziEYG/sU/eo+nvvKPCkWkzJxwxD2vtTwq1/SYAm9tp+q0WLooxKn4AqC+MOpRHvraJdA4mcM/6WRzXtLKuRY/Gf9HWR3OrIXY1+b99LOfxl81sjBPVrB4KcvrGFgTCrFak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTX75EGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTX75EGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E5FC2BBFC;
	Mon, 27 May 2024 19:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836928;
	bh=RsdPAnxZQX41zbbSWAshGbtGFB38mP7fRyT7nXnGjf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTX75EGPCef0m/IT3FHzizjtRsZSg8u+fR8Eai3PBH7sJfasU+/uxy2JBfYkb4khR
	 CYlcf7OioMCc3UWTENFNoQgDsEuo2TBTOC4PYzyno71VoBBrI+2ZiGK6Ytm/kifZxw
	 W8fKEQR6OcIdRj9yLCo0rnNyzLidAOh1YMQ9NNSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 244/427] net: ethernet: cortina: Locking fixes
Date: Mon, 27 May 2024 20:54:51 +0200
Message-ID: <20240527185625.373677580@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 812552808f7ff71133fc59768cdc253c5b8ca1bf ]

This fixes a probably long standing problem in the Cortina
Gemini ethernet driver: there are some paths in the code
where the IRQ registers are written without taking the proper
locks.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240509-gemini-ethernet-locking-v1-1-afd00a528b95@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 705c3eb19cd3f..d1fbadbf86d4a 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1107,10 +1107,13 @@ static void gmac_tx_irq_enable(struct net_device *netdev,
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
 	struct gemini_ethernet *geth = port->geth;
+	unsigned long flags;
 	u32 val, mask;
 
 	netdev_dbg(netdev, "%s device %d\n", __func__, netdev->dev_id);
 
+	spin_lock_irqsave(&geth->irq_lock, flags);
+
 	mask = GMAC0_IRQ0_TXQ0_INTS << (6 * netdev->dev_id + txq);
 
 	if (en)
@@ -1119,6 +1122,8 @@ static void gmac_tx_irq_enable(struct net_device *netdev,
 	val = readl(geth->base + GLOBAL_INTERRUPT_ENABLE_0_REG);
 	val = en ? val | mask : val & ~mask;
 	writel(val, geth->base + GLOBAL_INTERRUPT_ENABLE_0_REG);
+
+	spin_unlock_irqrestore(&geth->irq_lock, flags);
 }
 
 static void gmac_tx_irq(struct net_device *netdev, unsigned int txq_num)
@@ -1415,15 +1420,19 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 	union gmac_rxdesc_3 word3;
 	struct page *page = NULL;
 	unsigned int page_offs;
+	unsigned long flags;
 	unsigned short r, w;
 	union dma_rwptr rw;
 	dma_addr_t mapping;
 	int frag_nr = 0;
 
+	spin_lock_irqsave(&geth->irq_lock, flags);
 	rw.bits32 = readl(ptr_reg);
 	/* Reset interrupt as all packages until here are taken into account */
 	writel(DEFAULT_Q0_INT_BIT << netdev->dev_id,
 	       geth->base + GLOBAL_INTERRUPT_STATUS_1_REG);
+	spin_unlock_irqrestore(&geth->irq_lock, flags);
+
 	r = rw.bits.rptr;
 	w = rw.bits.wptr;
 
@@ -1726,10 +1735,9 @@ static irqreturn_t gmac_irq(int irq, void *data)
 		gmac_update_hw_stats(netdev);
 
 	if (val & (GMAC0_RX_OVERRUN_INT_BIT << (netdev->dev_id * 8))) {
+		spin_lock(&geth->irq_lock);
 		writel(GMAC0_RXDERR_INT_BIT << (netdev->dev_id * 8),
 		       geth->base + GLOBAL_INTERRUPT_STATUS_4_REG);
-
-		spin_lock(&geth->irq_lock);
 		u64_stats_update_begin(&port->ir_stats_syncp);
 		++port->stats.rx_fifo_errors;
 		u64_stats_update_end(&port->ir_stats_syncp);
-- 
2.43.0



