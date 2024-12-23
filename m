Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B98188006;
	Mon, 23 Dec 2024 16:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970194; cv=none; b=Kc8uqS0Nckdh1YL2LtIxGYTtTRW3JWkjLwoxP69e5rMgrmo+FboR7JEEGyn8OqiN3YVRy61wB4jT4d1/NU9H02iXtO36BtTRbBMDGWvCepHPg0ObNDNuQAuOjxNV1pXKQt1x0unlTQ+2Tdc0khDjZZTaETNssQCpjPTWI7o4pqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970194; c=relaxed/simple;
	bh=xpnWgIH8A/ORAikqCTgK8+LUQnPFhsBKIimy6p/D660=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9vIQC/jZ970MTkvRgeBNpLDoPIlJ/EsDqzuAMwrjaQ8xKJ1Y0Dof9VOn8uS/3NRekx5BuxWUw26hyk5XBxLhw+Q5MrC4q8c63iSxpxKedSGIlZavHl8rU74hVfnZSmHBJm8nsl68JN5wAVRk36heYGx7u5YpZ6KUJbb4O6kim4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4Xd2115; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4Xd2115"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BA1C4CED3;
	Mon, 23 Dec 2024 16:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970194;
	bh=xpnWgIH8A/ORAikqCTgK8+LUQnPFhsBKIimy6p/D660=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4Xd2115Fznopl68pLDdTMqnFOa2XPrPnQ/0FoNHGWN15wXX+874f+t0GnJEkD0hY
	 H5S2U4LuQwkfCUi6et/3sKZbv82I4k7iZHYGCByfuCXP+3j+XG5Tm7uYPfNk095zDk
	 ZTLSc28BVC4NCEs9Z7bZ/Q7hIez8Hs93STcXReBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Furong Xu <0x1207@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/116] net: stmmac: fix TSO DMA API usage causing oops
Date: Mon, 23 Dec 2024 16:58:02 +0100
Message-ID: <20241223155400.018050371@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 4c49f38e20a57f8abaebdf95b369295b153d1f8e ]

Commit 66600fac7a98 ("net: stmmac: TSO: Fix unbalanced DMA map/unmap
for non-paged SKB data") moved the assignment of tx_skbuff_dma[]'s
members to be later in stmmac_tso_xmit().

The buf (dma cookie) and len stored in this structure are passed to
dma_unmap_single() by stmmac_tx_clean(). The DMA API requires that
the dma cookie passed to dma_unmap_single() is the same as the value
returned from dma_map_single(). However, by moving the assignment
later, this is not the case when priv->dma_cap.addr64 > 32 as "des"
is offset by proto_hdr_len.

This causes problems such as:

  dwc-eth-dwmac 2490000.ethernet eth0: Tx DMA map failed

and with DMA_API_DEBUG enabled:

  DMA-API: dwc-eth-dwmac 2490000.ethernet: device driver tries to +free DMA memory it has not allocated [device address=0x000000ffffcf65c0] [size=66 bytes]

Fix this by maintaining "des" as the original DMA cookie, and use
tso_des to pass the offset DMA cookie to stmmac_tso_allocator().

Full details of the crashes can be found at:
https://lore.kernel.org/all/d8112193-0386-4e14-b516-37c2d838171a@nvidia.com/
https://lore.kernel.org/all/klkzp5yn5kq5efgtrow6wbvnc46bcqfxs65nz3qy77ujr5turc@bwwhelz2l4dw/

Reported-by: Jon Hunter <jonathanh@nvidia.com>
Reported-by: Thierry Reding <thierry.reding@gmail.com>
Fixes: 66600fac7a98 ("net: stmmac: TSO: Fix unbalanced DMA map/unmap for non-paged SKB data")
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Furong Xu <0x1207@gmail.com>
Link: https://patch.msgid.link/E1tJXcx-006N4Z-PC@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 853851d5f362..d6ee90fef2ec 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4119,9 +4119,9 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	int tmp_pay_len = 0, first_tx;
 	struct stmmac_tx_queue *tx_q;
 	bool has_vlan, set_ic;
+	dma_addr_t tso_des, des;
 	u8 proto_hdr_len, hdr;
 	u32 pay_len, mss;
-	dma_addr_t des;
 	int i;
 
 	tx_q = &priv->dma_conf.tx_queue[queue];
@@ -4206,14 +4206,15 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		/* If needed take extra descriptors to fill the remaining payload */
 		tmp_pay_len = pay_len - TSO_MAX_BUFF_SIZE;
+		tso_des = des;
 	} else {
 		stmmac_set_desc_addr(priv, first, des);
 		tmp_pay_len = pay_len;
-		des += proto_hdr_len;
+		tso_des = des + proto_hdr_len;
 		pay_len = 0;
 	}
 
-	stmmac_tso_allocator(priv, des, tmp_pay_len, (nfrags == 0), queue);
+	stmmac_tso_allocator(priv, tso_des, tmp_pay_len, (nfrags == 0), queue);
 
 	/* In case two or more DMA transmit descriptors are allocated for this
 	 * non-paged SKB data, the DMA buffer address should be saved to
-- 
2.39.5



