Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057003;
	b=BN2utGA+m8vS7QboOYcVWmI7tB5z0Y4StvTcglswHQua5Wwi//JmC44y0qyBlnr1N/+E
	 /6GRj5UiZXPoLRQRV5JxRQy0boeGbGooSsHeQLeUdLrrqYODauafphoS+RTN+6uUh9QWA
	 UjnplBjo2XtMd0lm5LlUQ+StG2iSSUVQNBrTmwuulfrH4jh/2f5mV5GMnWq4Wj6A9P+Hh
	 k8p2aCXcrr6tgmDWfopt4rDnDp2WH2wWLqQt5fkM6T5b30IuGxXz/ddKTNZAE2rEqTp6P
	 xm54wWURASYUslFFZhHqr/AXJvATgxTGSToxSQQG8QzjIukIPeZQWlk+zhAL2fQQTZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=muJqfGWiy6bLUqcxukZSiPNb14J9UxSUaqS6ZAyOOI0=;
	b=TP8Suh6zWNmtCUAcKvyZ7jAnAZqnYonvyI/M27pOVJUmZTPCY/pXRuvh+7g0BK9hweX4
	 eilH++/6IOiHxLwqWM6kiSjK/asrvQKq8RHRvxw4LJDs+u1pO1ON4ClW8zg69MH0+Jrg6
	 mDHbnlTK/S2dO/Z6B9KBNadEcWuaKleAzFjksTtnMrEnV+sN/lmQhlvx8mV7HQWKV/+pU
	 a3jxWWJzhgvtDM/lC+cLeRhjCx9Hmq89RRpBQ0hmAIIoCsa1ThBIsTMnPtbC/kWw414RA
	 L/+cLIcuH3i+NR8AdXUEngap6bbD0O4nNvpfqJQ0X/C1UM0resSuPe39L7Fik8KQl7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6y3TREm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12510606A32A;
	Thu, 19 Nov 2026 02:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6y3TREm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6321F000C4;
	Thu, 19 Nov 2026 02:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057002;
	bh=muJqfGWiy6bLUqcxukZSiPNb14J9UxSUaqS6ZAyOOI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6y3TREmnB7a9UFzxX7tf8KXAsngg6Q46Nn9Exm4UCV/qlK41RiboszZ3AbCjImSi
	 HYnJ+qu8ZAvy6fMfRJkRgq9Ded88K10eXqBMdDXq1qmg+x4DkiIXnRUnM/zhymEDIj
	 HqWSwKdeToQVPNyYnWD6Udm+TW1CAS87aQDZM2Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2189/2214] net: bgmac: fix TX DMA unmapping and slot cleanup
Date: Wed, 18 Nov 2026 16:04:25 +0100
Message-ID: <20261118150137.899342372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4239fbb866fd3..8abb8179ecc27 100644
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



