Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033362;
	b=Gj1Y2sr0qHiidTdvncvxXrW+GH4tjagj1LAb/8QqQ0El6whTG7O7S1w5Fqoci2kQduwh
	 d48oBy664SShqkVKncyvyrXwJ9yrlVo5ABw/ycd9NaIQVNMw9NPVAMojsG1N8Pue8thEL
	 02wLZrzFyHnmJX60lqKgT4yD5S090H3iTLzhCNx1FCBDd2VipZk6pFcKm1+VfT5g9KwgG
	 qmTem4n449+V/oCnyLqb34W27KiasgWyzmPMGpPgU7jZ3HXjqUAtOhE+uweiF4mKFKMX8
	 7TsWF2MEuw2N1Iwn/5iGF7/7+ZqR/asMiLZteaiAL09yim8BOIoke4XDl8G654pr/ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qdWcKWAEWj3NlHrGwcKEmkuVttBu+39OMIOPd+UpYJM=;
	b=l8LZhVrkASudmOIqG8e+8/o83QVb4sECN7VdsxSl+Q6fw8PFC/8XYShMxSgbVBV1ojAV
	 4n56fasYIWppr2HVWueYo9C+2s4AQtMm0KEUIMWrtDV0kJ5c09y9UNxzz3bxm0JLLXayr
	 6q3mX2Hl4XnHUn8NAoc1/FSBEhd5vl18cmyHi7ELOOoifDoClaWBYzSfNBjbm2S057HGR
	 7/nN1N1SNz0+TC6ju/53oA4JFteLj+vcxpBs+VVRDRdhMkF9yWbqu6fc7Q9wZ1PmAblv2
	 gnW46V4imnc68XhYOrMC2mqXl3Gg2lg+DpD9yXy+9oqUjU4ZNq9aYrUqE466ow+znfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOPZOKem;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E83606A32A;
	Wed, 18 Nov 2026 20:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOPZOKem
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAADF1F000D1;
	Wed, 18 Nov 2026 20:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033362;
	bh=qdWcKWAEWj3NlHrGwcKEmkuVttBu+39OMIOPd+UpYJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOPZOKemUI/60zm5Xs+UeNt18wLIuNcIEwdKrVjdqm9yVBmIGsNrYN6lP/OITA9jc
	 2RXAf+vR6rUm6RUyC3UMyraMzZpydgpyF106KNR5dftju91TUrotJS98FEqLFPWZ0O
	 oQn+VFbVUPPT4JGrMfIT9NqBCSe6uK34KNZtKWsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1699/1756] net: bgmac: fix TX DMA unmapping and slot cleanup
Date: Wed, 18 Nov 2026 16:03:46 +0100
Message-ID: <20261118150117.292215583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 4f45e97b3aac2282f2b436d97338c9c2c484d093 ]

When mapping a fragment fails, bgmac_dma_tx_add() unwinds with the
wrong slots. It passes the failed fragment's slot->dma_addr, which
holds the mapping error, to dma_unmap_single() for the head. The
fragment loop indexes from ring->end instead of ring->end + 1, so it
unmaps the head a second time as a page and leaves the last mapped
fragment mapped. None of the affected slots get their dma_addr cleared
either, which includes the head slot when mapping the head fails.

bgmac_dma_tx_ring_free() unmaps every slot with a non-zero dma_addr,
so tearing down the ring unmaps these addresses again. It also frees
the skbs of pending TX slots but leaves slot->skb and slot->dma_addr
set. The slots survive a down/up cycle, and bgmac_dma_tx_add() only
sets slot->skb on the last slot of a packet. If a slot with a stale
pointer is later used for the head or a fragment of a scatter/gather
packet, bgmac_dma_tx_free() frees the old skb a second time when that
slot completes.

bgmac_dma_tx_ring_free() also picks dma_unmap_single() or
dma_unmap_page() by looking at slot->skb, which is set on the last slot
of a packet, while the head was mapped with dma_map_single() and the
fragments with skb_frag_dma_map().

In the error path, unmap the head and each mapped fragment from their
own slots, and clear dma_addr on every slot the failed packet touched.
In bgmac_dma_tx_ring_free(), choose the unmap function by the SOF flag
of the descriptor like bgmac_dma_tx_free() does, unmap every slot
before freeing any skb, since a packet can wrap around the end of the
ring with its skb on the last slot, and clear both fields.

This was found through code inspection by an LLM while hitting other
bugs on an Asus RT-N16. It did not hit these ones specifically.

Fixes: 9cde94506eac ("bgmac: implement scatter/gather support")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261028164839.28605-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac.c | 47 +++++++++++++++++----------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 258b3b5a1cdb7..ece93043c506e 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -208,19 +208,24 @@ static netdev_tx_t bgmac_dma_tx_add(struct bgmac *bgmac,
 	return NETDEV_TX_OK;
 
 err_dma:
-	dma_unmap_single(dma_dev, slot->dma_addr, skb_headlen(skb),
-			 DMA_TO_DEVICE);
+	slot->dma_addr = 0;
 
 	while (i-- > 0) {
-		int index = (ring->end + i) % BGMAC_TX_RING_SLOTS;
-		struct bgmac_slot_info *slot = &ring->slots[index];
-		u32 ctl1 = le32_to_cpu(ring->cpu_base[index].ctl1);
-		int len = ctl1 & BGMAC_DESC_CTL1_LEN;
-
-		dma_unmap_page(dma_dev, slot->dma_addr, len, DMA_TO_DEVICE);
+		index = (ring->end + 1 + i) % BGMAC_TX_RING_SLOTS;
+		slot = &ring->slots[index];
+		dma_unmap_page(dma_dev, slot->dma_addr,
+			       skb_frag_size(&skb_shinfo(skb)->frags[i]),
+			       DMA_TO_DEVICE);
+		slot->dma_addr = 0;
 	}
 
+	slot = &ring->slots[ring->end % BGMAC_TX_RING_SLOTS];
+	dma_unmap_single(dma_dev, slot->dma_addr, skb_headlen(skb),
+			 DMA_TO_DEVICE);
+
 err_dma_head:
+	slot->dma_addr = 0;
+
 	netdev_err(bgmac->net_dev, "Mapping error of skb on ring 0x%X\n",
 		   ring->mmio_base);
 
@@ -535,17 +540,25 @@ static void bgmac_dma_tx_ring_free(struct bgmac *bgmac,
 		unsigned int len = ctl1 & BGMAC_DESC_CTL1_LEN;
 
 		slot = &ring->slots[i];
-		dev_kfree_skb(slot->skb);
 
-		if (!slot->dma_addr)
-			continue;
+		if (slot->dma_addr) {
+			if (le32_to_cpu(dma_desc[i].ctl0) & BGMAC_DESC_CTL0_SOF)
+				dma_unmap_single(dma_dev, slot->dma_addr,
+						 len, DMA_TO_DEVICE);
+			else
+				dma_unmap_page(dma_dev, slot->dma_addr,
+					       len, DMA_TO_DEVICE);
+			slot->dma_addr = 0;
+		}
+	}
 
-		if (slot->skb)
-			dma_unmap_single(dma_dev, slot->dma_addr,
-					 len, DMA_TO_DEVICE);
-		else
-			dma_unmap_page(dma_dev, slot->dma_addr,
-				       len, DMA_TO_DEVICE);
+	/* A packet can wrap around the end of the ring with its skb on the
+	 * last slot, so free the skbs only once every slot is unmapped.
+	 */
+	for (i = 0; i < BGMAC_TX_RING_SLOTS; i++) {
+		slot = &ring->slots[i];
+		dev_kfree_skb(slot->skb);
+		slot->skb = NULL;
 	}
 }
 
-- 
2.53.0



