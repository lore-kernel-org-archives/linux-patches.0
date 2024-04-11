Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DC4146D7E;
	Thu, 11 Apr 2024 10:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832047; cv=none; b=UuT+w/K6WxddgcPSQqT3tSWovsyN+70SJR2WH6boz1cAu+WPN8Hc9OV7aF6n0GJLkY1n9Eu3DhCJom5DSsMob8wAoNg/jMN/cf+io6akgvOBxt82VAEk4DuugtCmtJvoZNBDeaKscpAL5raazERmttWSe3Ny/WmE8LkQcrlkT9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832047; c=relaxed/simple;
	bh=C7Sk73tK9eVD27Efq6jQI0HXqlKX03FaUNwHl7edxD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJpEXumIMGLXflFPgK29ADuWKlYTb/KvSM/mBa/FqwjehBhbYT3k/+P8Onb8PtuGhvRonzMA1HIx157jiHyaKYpYtD/2Y17xvjcxU7rMJrc0IXRq/OdtrGbOH7YWSoI0Tkq484cELbAGKjDPtv1zLOiv1FXofw/vwjHlmEDSmls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUm3d6SL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUm3d6SL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC7DC433F1;
	Thu, 11 Apr 2024 10:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832047;
	bh=C7Sk73tK9eVD27Efq6jQI0HXqlKX03FaUNwHl7edxD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUm3d6SLn0/w0G3s7lfPy3PmajdG5qLNbFF1OPUPJyA5B4QfQ5g/tnjqrDMrf4gul
	 dHX9T54LgG6uHejgQJakSPE4+9f9pihYbpXXWQWnWhcJtjuNxtbs/VDY9HDq95Z5y0
	 P/kSq0mhp7W3ZCAA85DzbEs8KcgqBj6Xs275vDRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Wejman <piotrwejman90@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 213/294] net: stmmac: fix rx queue priority assignment
Date: Thu, 11 Apr 2024 11:56:16 +0200
Message-ID: <20240411095442.007723718@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

From: Piotr Wejman <piotrwejman90@gmail.com>

commit b3da86d432b7cd65b025a11f68613e333d2483db upstream.

The driver should ensure that same priority is not mapped to multiple
rx queues. From DesignWare Cores Ethernet Quality-of-Service
Databook, section 17.1.29 MAC_RxQ_Ctrl2:
"[...]The software must ensure that the content of this field is
mutually exclusive to the PSRQ fields for other queues, that is,
the same priority is not mapped to multiple Rx queues[...]"

Previously rx_queue_priority() function was:
- clearing all priorities from a queue
- adding new priorities to that queue
After this patch it will:
- first assign new priorities to a queue
- then remove those priorities from all other queues
- keep other priorities previously assigned to that queue

Fixes: a8f5102af2a7 ("net: stmmac: TX and RX queue priority configuration")
Fixes: 2142754f8b9c ("net: stmmac: Add MAC related callbacks for XGMAC2")
Signed-off-by: Piotr Wejman <piotrwejman90@gmail.com>
Link: https://lore.kernel.org/r/20240401192239.33942-1-piotrwejman90@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c   |   40 +++++++++++++++-----
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c |   38 +++++++++++++++----
 2 files changed, 62 insertions(+), 16 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -75,19 +75,41 @@ static void dwmac4_rx_queue_priority(str
 				     u32 prio, u32 queue)
 {
 	void __iomem *ioaddr = hw->pcsr;
-	u32 base_register;
-	u32 value;
+	u32 clear_mask = 0;
+	u32 ctrl2, ctrl3;
+	int i;
 
-	base_register = (queue < 4) ? GMAC_RXQ_CTRL2 : GMAC_RXQ_CTRL3;
-	if (queue >= 4)
-		queue -= 4;
+	ctrl2 = readl(ioaddr + GMAC_RXQ_CTRL2);
+	ctrl3 = readl(ioaddr + GMAC_RXQ_CTRL3);
+
+	/* The software must ensure that the same priority
+	 * is not mapped to multiple Rx queues
+	 */
+	for (i = 0; i < 4; i++)
+		clear_mask |= ((prio << GMAC_RXQCTRL_PSRQX_SHIFT(i)) &
+						GMAC_RXQCTRL_PSRQX_MASK(i));
 
-	value = readl(ioaddr + base_register);
+	ctrl2 &= ~clear_mask;
+	ctrl3 &= ~clear_mask;
 
-	value &= ~GMAC_RXQCTRL_PSRQX_MASK(queue);
-	value |= (prio << GMAC_RXQCTRL_PSRQX_SHIFT(queue)) &
+	/* First assign new priorities to a queue, then
+	 * clear them from others queues
+	 */
+	if (queue < 4) {
+		ctrl2 |= (prio << GMAC_RXQCTRL_PSRQX_SHIFT(queue)) &
 						GMAC_RXQCTRL_PSRQX_MASK(queue);
-	writel(value, ioaddr + base_register);
+
+		writel(ctrl2, ioaddr + GMAC_RXQ_CTRL2);
+		writel(ctrl3, ioaddr + GMAC_RXQ_CTRL3);
+	} else {
+		queue -= 4;
+
+		ctrl3 |= (prio << GMAC_RXQCTRL_PSRQX_SHIFT(queue)) &
+						GMAC_RXQCTRL_PSRQX_MASK(queue);
+
+		writel(ctrl3, ioaddr + GMAC_RXQ_CTRL3);
+		writel(ctrl2, ioaddr + GMAC_RXQ_CTRL2);
+	}
 }
 
 static void dwmac4_tx_queue_priority(struct mac_device_info *hw,
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -97,17 +97,41 @@ static void dwxgmac2_rx_queue_prio(struc
 				   u32 queue)
 {
 	void __iomem *ioaddr = hw->pcsr;
-	u32 value, reg;
+	u32 clear_mask = 0;
+	u32 ctrl2, ctrl3;
+	int i;
 
-	reg = (queue < 4) ? XGMAC_RXQ_CTRL2 : XGMAC_RXQ_CTRL3;
-	if (queue >= 4)
+	ctrl2 = readl(ioaddr + XGMAC_RXQ_CTRL2);
+	ctrl3 = readl(ioaddr + XGMAC_RXQ_CTRL3);
+
+	/* The software must ensure that the same priority
+	 * is not mapped to multiple Rx queues
+	 */
+	for (i = 0; i < 4; i++)
+		clear_mask |= ((prio << XGMAC_PSRQ_SHIFT(i)) &
+						XGMAC_PSRQ(i));
+
+	ctrl2 &= ~clear_mask;
+	ctrl3 &= ~clear_mask;
+
+	/* First assign new priorities to a queue, then
+	 * clear them from others queues
+	 */
+	if (queue < 4) {
+		ctrl2 |= (prio << XGMAC_PSRQ_SHIFT(queue)) &
+						XGMAC_PSRQ(queue);
+
+		writel(ctrl2, ioaddr + XGMAC_RXQ_CTRL2);
+		writel(ctrl3, ioaddr + XGMAC_RXQ_CTRL3);
+	} else {
 		queue -= 4;
 
-	value = readl(ioaddr + reg);
-	value &= ~XGMAC_PSRQ(queue);
-	value |= (prio << XGMAC_PSRQ_SHIFT(queue)) & XGMAC_PSRQ(queue);
+		ctrl3 |= (prio << XGMAC_PSRQ_SHIFT(queue)) &
+						XGMAC_PSRQ(queue);
 
-	writel(value, ioaddr + reg);
+		writel(ctrl3, ioaddr + XGMAC_RXQ_CTRL3);
+		writel(ctrl2, ioaddr + XGMAC_RXQ_CTRL2);
+	}
 }
 
 static void dwxgmac2_tx_queue_prio(struct mac_device_info *hw, u32 prio,


