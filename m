Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526421E764A;
	Tue, 15 Oct 2024 11:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993126; cv=none; b=n6r7blkuI/A6wjEHo+CyVeJRbo1G9eMAnTz/SOeOSkVukl/Sv22ZiNlOS8PamRFE/Nnli4nZGmxn2khZfY+34jWOVBOuODvP8JiLCIW1Jmw14r2KDBDtIuryZfX7Kxonjyj5AYgKhsJPxu+QTo4QgvpSrGnScO2ofU2Ypsc1/pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993126; c=relaxed/simple;
	bh=s5bWYtySKIoJtuUoEVmyEhxrFUyGAPkT+T7lDIKTH7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMZSExXXvYGxXWhxKOFy/VJZhAiCc7dP3OXWvxIcGHk8Q4T8Oj57ync6tdLylu16HbQPMtXeoiadMZP7GrqzxRWMrEFXBdKF2ucWcmJy55rwx2X1SPfAKrmioYfsqWKuLi84sFQVH5RCABp08zOikkm8mbkynTy0irHqJnMHm5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zy35CDo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zy35CDo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67FCC4CECF;
	Tue, 15 Oct 2024 11:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993126;
	bh=s5bWYtySKIoJtuUoEVmyEhxrFUyGAPkT+T7lDIKTH7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zy35CDo6OQJYQFdQN0ColaRBFnej7pw38wU9oPvVRFoH481SWPEj/plnL47/Q5xCm
	 NWFUKVuGTDmYcqT+WsOibCzb9V4lfH7efD9YTM47JCyElTToTH1xeMjz7FFxc+H2IA
	 XNs4lnGF0LoX9cGQdJKUtncXiQPRDExdxohRxA0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 287/691] net: axienet: Be more careful about updating tx_bd_tail
Date: Tue, 15 Oct 2024 13:23:55 +0200
Message-ID: <20241015112451.737170912@linuxfoundation.org>
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

[ Upstream commit f0cf4000f5867ec4325d19d32bd83cf583065667 ]

The axienet_start_xmit function was updating the tx_bd_tail variable
multiple times, with potential rollbacks on error or invalid
intermediate positions, even though this variable is also used in the
TX completion path. Use READ_ONCE where this variable is read and
WRITE_ONCE where it is written to make this update more atomic, and
move the write before the MMIO write to start the transfer, so it is
protected by that implicit write barrier.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5a6caa2cfabb ("net: xilinx: axienet: Fix packet counting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 26 +++++++++++--------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index fd5f7ac7f4a6b..bcecf4b7308c1 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -747,7 +747,8 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 
 	/* Ensure we see all descriptor updates from device or TX IRQ path */
 	rmb();
-	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
+	cur_p = &lp->tx_bd_v[(READ_ONCE(lp->tx_bd_tail) + num_frag) %
+			     lp->tx_bd_num];
 	if (cur_p->cntrl)
 		return NETDEV_TX_BUSY;
 	return 0;
@@ -808,12 +809,15 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	u32 csum_index_off;
 	skb_frag_t *frag;
 	dma_addr_t tail_p, phys;
+	u32 orig_tail_ptr, new_tail_ptr;
 	struct axienet_local *lp = netdev_priv(ndev);
 	struct axidma_bd *cur_p;
-	u32 orig_tail_ptr = lp->tx_bd_tail;
+
+	orig_tail_ptr = lp->tx_bd_tail;
+	new_tail_ptr = orig_tail_ptr;
 
 	num_frag = skb_shinfo(skb)->nr_frags;
-	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
+	cur_p = &lp->tx_bd_v[orig_tail_ptr];
 
 	if (axienet_check_tx_bd_space(lp, num_frag + 1)) {
 		/* Should not happen as last start_xmit call should have
@@ -853,9 +857,9 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
 
 	for (ii = 0; ii < num_frag; ii++) {
-		if (++lp->tx_bd_tail >= lp->tx_bd_num)
-			lp->tx_bd_tail = 0;
-		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
+		if (++new_tail_ptr >= lp->tx_bd_num)
+			new_tail_ptr = 0;
+		cur_p = &lp->tx_bd_v[new_tail_ptr];
 		frag = &skb_shinfo(skb)->frags[ii];
 		phys = dma_map_single(lp->dev,
 				      skb_frag_address(frag),
@@ -867,8 +871,6 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			ndev->stats.tx_dropped++;
 			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
 					      NULL);
-			lp->tx_bd_tail = orig_tail_ptr;
-
 			return NETDEV_TX_OK;
 		}
 		desc_set_phys_addr(lp, phys, cur_p);
@@ -878,11 +880,13 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	cur_p->cntrl |= XAXIDMA_BD_CTRL_TXEOF_MASK;
 	cur_p->skb = skb;
 
-	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
+	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * new_tail_ptr;
+	if (++new_tail_ptr >= lp->tx_bd_num)
+		new_tail_ptr = 0;
+	WRITE_ONCE(lp->tx_bd_tail, new_tail_ptr);
+
 	/* Start the transfer */
 	axienet_dma_out_addr(lp, XAXIDMA_TX_TDESC_OFFSET, tail_p);
-	if (++lp->tx_bd_tail >= lp->tx_bd_num)
-		lp->tx_bd_tail = 0;
 
 	/* Stop queue if next transmit may not have space */
 	if (axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
-- 
2.43.0



