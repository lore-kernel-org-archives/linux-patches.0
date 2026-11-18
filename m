Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027581;
	b=Gl64CBQjphKVKn6bROjOyiIid1kvDOrC4ChMQCU4SbQ8cafjZO9TVB2+JAQIVeFX+RTI
	 LuWOfGVAaHIAhy1+hEbypxebwsNPSZqyysOuSWXnqn5xnGvoBZhFMaXqhRINlEBZcKhfe
	 SF2HHNfXey7yIQOi6av/rLVqFueZSecH3LXvAhHwrmQ+WEtkvkDhkJpqGal3ezz7T+pGJ
	 +NyEzJzM6y1u2BaGIg7xco/IOhvE8oh8Vow6wM4yMi5es5UyigB2e49JQC8vrFqHaP/Sa
	 KtGdwFxyXtQzBRgrko9YQs5PafDRbwtaVqS39DIHlsCk5ri3v7A3ZBT4xiJFCHMTIeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y0tH9K1YtjtxCcWRTHGvo7SsVGU0+Aua7NFr8NA0vPY=;
	b=43Z+AeOcdxgfK9HJZy/4w+t0rWdnaNxmClxQHnBWIQpYb0kxnUURh/JdXQlh/qt5rgz4
	 huIIbf23l+zUUfE5/Wzi9EbTZHMJuD8ZWXwxVvnSNEm/g3LL0885MhACQgBz0u7ESzkjv
	 SlN4k36lBdC0X11nKhrCY+V/rrvRV2sajEQ3v+Pq/acbxIySrMNX98auf2WmznOKEw3GH
	 sHfcIMMS7YXJZAqKR1nfFJmDdrN4XxZJsGorO2A635NW7oU6OH+vW4Gf6LcuXhXdacI/J
	 GVeHgGcqTNp4t9ZzKdKpifK12n/PajywMIDFzwbGrAlg3tLUhIFdGIGJf6jTOI4qEdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QocOu0V+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF85A60A2613;
	Wed, 18 Nov 2026 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QocOu0V+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3D21F000C4;
	Wed, 18 Nov 2026 18:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027581;
	bh=Y0tH9K1YtjtxCcWRTHGvo7SsVGU0+Aua7NFr8NA0vPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QocOu0V+rGZOiyef/riW0Z5S+7MtYN85atrDgBsq9mzeXjQm0XnoPGp6z2I3abcN2
	 AwXZyl18oiumiwI3aqB0RY6D2QA3jgnWZ8jUaDFWND64LyEXf801rJWTrQ9jKW8L66
	 gykANhSJh6nkyA6hzMD8F5RnHzev00E3DeMghJes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Maimon <maimon.sagi@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1823/2151] net: axienet: release every RX buffer in axienet_dma_bd_release()
Date: Wed, 18 Nov 2026 15:59:18 +0100
Message-ID: <20261118150228.214838545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Maimon <maimon.sagi@gmail.com>

[ Upstream commit b59787892d04a5647a7e662fbb02cd0abdb1a993 ]

The RX walk in axienet_dma_bd_release() stops at the first descriptor
without an skb, assuming that such a slot and all after it were never
filled.  That holds on the axienet_dma_bd_init() error path, but not once
the ring has been running: when axienet_rx_poll() fails to allocate or
map a replacement buffer it leaves the slot it emptied with a NULL skb,
in the middle of a populated ring, until a later poll refills it.
Closing the interface before then leaks the skb and the streaming DMA
mapping of every descriptor after that slot, which can be most of the
ring, and is most likely under memory pressure.

The walk also frees each skb before unmapping it.  With swiotlb, the
DMA_FROM_DEVICE unmap copies the bounce buffer back into the skb data
that was just freed, and on non-coherent platforms it invalidates cache
lines that may already belong to a new owner.

Skip empty slots instead of stopping at the first one.  An emptied slot
still has a non-zero cntrl but its buffer is already unmapped, so the
skip has to cover the unmap too, which it does by coming before it.
Then unmap before freeing, as axienet_rx_poll() does.

This was reported by the Sashiko AI review bot.

Tested on the AXI Ethernet MAC of an ADVA TimeCard X2 (PCIe card, with
the built-in AXI DMA): traffic passes after each of ten down/up cycles,
each running axienet_dma_bd_release(), so the unmap-then-free order is
exercised on every buffer.  A failed RX refill was not reproduced, so
the skip over an empty slot was not exercised.

Fixes: f26667a373f3 ("net: axienet: Fix DMA descriptor cleanup path")
Fixes: 7a7d340ba4d9 ("net: axienet: fix RX ring refill allocation failure handling")
Signed-off-by: Sagi Maimon <maimon.sagi@gmail.com>
Link: https://patch.msgid.link/20261015084743.1798326-1-maimon.sagi@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9bd458f158391..d53b92c30b65a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -245,13 +245,13 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 	for (i = 0; i < lp->rx_bd_num; i++) {
 		dma_addr_t phys;
 
-		/* A NULL skb means this descriptor has not been initialised
-		 * at all.
+		/* A NULL skb means the descriptor holds no buffer: it was
+		 * never filled, or axienet_rx_poll() took its skb and could
+		 * not refill it, having already unmapped the old buffer.
+		 * Such slots can sit anywhere in a ring that has been running.
 		 */
 		if (!lp->rx_bd_v[i].skb)
-			break;
-
-		dev_kfree_skb(lp->rx_bd_v[i].skb);
+			continue;
 
 		/* For each descriptor, we programmed cntrl with the (non-zero)
 		 * descriptor size, after it had been successfully allocated.
@@ -262,6 +262,8 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 			dma_unmap_single(lp->dev, phys,
 					 lp->max_frm_size, DMA_FROM_DEVICE);
 		}
+
+		dev_kfree_skb(lp->rx_bd_v[i].skb);
 	}
 
 	dma_free_coherent(lp->dev,
-- 
2.53.0



