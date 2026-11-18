Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062199;
	b=PTNS3HYRthtJ8rJHb6ufKFJPb6x+zFHMJVqSp4NpZdw9Jw6gb6FTLWd9KTjRKGsDwgwz
	 Wk6liJ9CceVoFGlnHn0oU9fzMqdRhqC1KSEIW7R0RtNi1LFDSq9V02hx+W3AeL65oAs03
	 3u7dBwsP5XXqKhm8uh1FnssoB95UVCyybIqy1A8XhWthwkXfAybL9lw4p8jRel14oxLFg
	 fMi1V+ddHXoJD4TPeFgd6DesoJMMnf679hOgcGVQZGIFPZO2Tltd0wGicn3kUDh5V+0wD
	 MYXSkcKitYPLyXB6nlQmxjMt14A9Ql8IlXZx/cLI5u3CM8WTrLSymn2XGOLp1rAB96A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D4SmyaJ0VqygRAOlZWTKg1mN+dEF/Qr/vW0f89PwB18=;
	b=XSIMBWDSV/p+Bemi7KggaIX4zOI4ExF3azqajgWd0lwfNz6pQ8kc5ofSyM7aW/tb/kzA
	 aU8asw2sKy+q7EkUwAykatgsJvQiEHLartix+uj5/A//UHGV/Lvt0TvT9yAGGdIEx94CZ
	 x0UJzEEm/pKY1x0M7BWLM1kwkLllnCQN3z7CMuINJRMWZc5Cp8gyj3agyqv0SFw6jidov
	 MckH/khyaZoeVD7woc7UlPfXlp1RMRyync01ORywxJ41LW0kXKdOan1eJcj47epAiGPJ7
	 XEVwX7JyQFnyy39BgiGX5gzN+qvTfe4DK/zuXVOi58C4QvpRifl+55MAj/wIGYVgFrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=karlSESS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89996606A325;
	Thu, 19 Nov 2026 04:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=karlSESS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E491F000C7;
	Thu, 19 Nov 2026 04:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062199;
	bh=D4SmyaJ0VqygRAOlZWTKg1mN+dEF/Qr/vW0f89PwB18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=karlSESSQYZopKRDuQsNXlQQWyiPQRTxwtcdhApWnl/sDaCJdRra9t6GGMDF26B7P
	 p2OPp6FBHuOeF9gHav1GVXITzQ3Zn2eMO+rNui69HVPBpPUG5S/DEYO5+TiiqdCZqF
	 REE3mlJyvoMxRPHTGbfjGhRdQ/U+QNUKke6yhmjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1818/1848] net: bgmac: fix TX DMA unmapping and slot cleanup
Date: Wed, 18 Nov 2026 16:04:16 +0100
Message-ID: <20261118150035.647928861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 19177f90c2329..34d260637c49f 100644
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



