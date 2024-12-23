Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8842EAE6;
	Mon, 23 Dec 2024 16:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969630; cv=none; b=jahyp/quY30VWOlbLKn7JoNdnZCP0mBqzJ/xgcWwh/SBRol7m1Sa9or3rilvsu22ATCo8ZpWkYeEJbl7mqaS3fTrFUkyYh7kjdD37KHcvSZPifQvlz2wqyMQ+JAQghzWsRyAA/NuOWp9LsYtZbv1WEdhDZU/8CRwrXzbKqTEB5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969630; c=relaxed/simple;
	bh=ZxtRQUxYhISmks6XQQZA9YMcu3KRKMm2J2UFOLWq37w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkNeQhW8O6EmpyAkBvbDKafkITwBGdeGePm+WvUFIQyoI1Cz1aQ+4YEW6VJF1oZomh+Zy0qPOoieQJI/71nLKVbRKALBHCMz45HHk9rXA1teAxcJAbqHE22jKGbwwIk3I9Z+fVDR7AWlNZOWX89uvwQ8HxYYCYrhFdXdGIHbs5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPgq6UNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPgq6UNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8368C4CED4;
	Mon, 23 Dec 2024 16:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969630;
	bh=ZxtRQUxYhISmks6XQQZA9YMcu3KRKMm2J2UFOLWq37w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPgq6UNafRfNSjd5zO40J4tZqU5FFcaeryY8nmmE+ayyaK5JcwhIbdytu3b45llhN
	 ueSpn1pmsYkclkvaJJjSpcxp/OPI72BETOqCGbCfw+tK+QlnUmR8Amf94MqK2KWUYe
	 zfG5MCD42+qj9/UvDdkxqFzSlAR4ryjfbWTcO1II=
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
Subject: [PATCH 6.12 002/160] net: stmmac: fix TSO DMA API usage causing oops
Date: Mon, 23 Dec 2024 16:56:53 +0100
Message-ID: <20241223155408.695093775@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 766213ee82c1..cf7b59b8cc64 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4220,8 +4220,8 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct stmmac_txq_stats *txq_stats;
 	struct stmmac_tx_queue *tx_q;
 	u32 pay_len, mss, queue;
+	dma_addr_t tso_des, des;
 	u8 proto_hdr_len, hdr;
-	dma_addr_t des;
 	bool set_ic;
 	int i;
 
@@ -4317,14 +4317,15 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
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



