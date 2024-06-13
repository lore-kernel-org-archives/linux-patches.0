Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508C83209;
	Thu, 13 Jun 2024 12:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280927; cv=none; b=tiavP7rdP/A7ANXktlrjzzHVwzqNGNxl+0JZabI7ec4UwQueyPMaGJpBzd4n0dRJvVLsh6rBHEyOEW411rUaN9JDyG1QSU3qq+dFKdwIe8AdaDeoMyhWLA/culkJi64Xe96HrHqcNznUksLtTITk4vsK4CJlAVtfFvRucgmHEYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280927; c=relaxed/simple;
	bh=zIuC1EdHESffXf2dgZoQJc+hDvoJ6ouC4jq/IWm+pn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gK/Hn9vpf++CYcGM8zEaIR9E1AUdBo6n8KQPD1w3f4IV/oF8rvJW4+4KElruVWhSg3/WkWw1LmTuRgL8A1IDTPTO1AJ+lfWhaFEZna4G7ttdRtFC7Z9BRZ6SJRIu8e7N7bu+OfoSm3CpLXCb2B3MPp39yfB19HIlMmN0xFvLZOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LMFxgg9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LMFxgg9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA14BC2BBFC;
	Thu, 13 Jun 2024 12:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280927;
	bh=zIuC1EdHESffXf2dgZoQJc+hDvoJ6ouC4jq/IWm+pn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMFxgg9zKrsHtZL1Y1IcyydHN6e2lsgGc3qOXTBEFBu7c+Fq0aAtNs6KzGwI8UZy+
	 qa/ButC7mVEUAwmfIGKLFLL+8VJo/RJzSpwnx7VZ1rFyhXlM+pSbrLfTUljF6ESUpo
	 dyFipovwqnXDOQnhwvkbFzDIlIqWVM36zI6OQq3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/317] net: ethernet: cortina: Locking fixes
Date: Thu, 13 Jun 2024 13:31:40 +0200
Message-ID: <20240613113250.721296631@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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
index c78587ddb32fd..fa46854fd697c 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1109,10 +1109,13 @@ static void gmac_tx_irq_enable(struct net_device *netdev,
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
@@ -1121,6 +1124,8 @@ static void gmac_tx_irq_enable(struct net_device *netdev,
 	val = readl(geth->base + GLOBAL_INTERRUPT_ENABLE_0_REG);
 	val = en ? val | mask : val & ~mask;
 	writel(val, geth->base + GLOBAL_INTERRUPT_ENABLE_0_REG);
+
+	spin_unlock_irqrestore(&geth->irq_lock, flags);
 }
 
 static void gmac_tx_irq(struct net_device *netdev, unsigned int txq_num)
@@ -1427,15 +1432,19 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
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
 
@@ -1738,10 +1747,9 @@ static irqreturn_t gmac_irq(int irq, void *data)
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



