Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1621C68C;
	Sun,  1 Sep 2024 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208781; cv=none; b=iXfh1ijRsn8JhZgevII0IpcrMCHn86YkQxe7ABaED6h7bCiVAgP7rE6nG7u6zMzvb3XLxc6phmxWYspUXCkjmTatOPJBfir7Oij/5aWGCt93n/aJFTf+E3iinDpAjLr25Czn/fvwvOmQk4K1PijIssPJLooFo7a1FgGWDCXKO4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208781; c=relaxed/simple;
	bh=xcQGi0PyUXJrMft/UH/4VPtTzIX333fdhJwkmvwPckk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bc3ycxFDAXUonDHGazRmN/Rll+MpXqJcYKT72o452zEyKpG7lsDhdZW2zX0Zzx3kgb+xGvGQlV7tv/LUVgtGhzoWOxfBOeuwfqzkK99klLQ5DVBNaqcznnOZfA6SdAW6SWPv96HWPCKw1TLVR7iaZgUTs4JX+90rdw1uV5tT3w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDEPZDnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDEPZDnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610DBC4CEC3;
	Sun,  1 Sep 2024 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208781;
	bh=xcQGi0PyUXJrMft/UH/4VPtTzIX333fdhJwkmvwPckk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDEPZDnL3hQwWw1vl6wbeXAAcRLt4GWFp5DO9H8yMbNeMSgJejex/5WoHNy2AH0L1
	 STXMaRAFtDjnoMA3TtLfgS7nw/RawI6AnR+7aG4zXP+APcubCcy99nOe3aOERVi0kc
	 nLPyi26X41c/T55hACAlBlmqwhGqFU2mlxz7LEWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/134] net: axienet: Improve DMA error handling
Date: Sun,  1 Sep 2024 18:16:06 +0200
Message-ID: <20240901160810.870303224@linuxfoundation.org>
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

[ Upstream commit e7fea0b9d09e2f7d32776f5198192dfc2572a5b9 ]

Since 0 is a valid DMA address, we cannot use the physical address to
check whether a TX descriptor is valid and is holding a DMA mapping.

Use the "cntrl" member of the descriptor to make this decision, as it
contains at least the length of the buffer, so 0 points to an
uninitialised buffer.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9ff2f816e2aa ("net: axienet: Fix register defines comment description")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 27901bb7cd5b5..22222d79e4902 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -572,7 +572,7 @@ static void axienet_start_xmit_done(struct net_device *ndev)
 				DMA_TO_DEVICE);
 		if (cur_p->skb)
 			dev_consume_skb_irq(cur_p->skb);
-		/*cur_p->phys = 0;*/
+		cur_p->cntrl = 0;
 		cur_p->app0 = 0;
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
@@ -1562,7 +1562,7 @@ static void axienet_dma_err_handler(struct work_struct *work)
 
 	for (i = 0; i < lp->tx_bd_num; i++) {
 		cur_p = &lp->tx_bd_v[i];
-		if (cur_p->phys)
+		if (cur_p->cntrl)
 			dma_unmap_single(ndev->dev.parent, cur_p->phys,
 					 (cur_p->cntrl &
 					  XAXIDMA_BD_CTRL_LENGTH_MASK),
-- 
2.43.0



