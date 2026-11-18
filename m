Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042179;
	b=Y/mXJXl8vf3F9uPv62f+RFaI56KZ0u0pKPuCXyZVvKlgbFISyr6q/k6FK6NAZIZxiu8W
	 wIfZr0s0HoqNWYHmv4YgnKuhltnxzfothJugAtSVs5oBiUaO+ShbQe+K9fw8toY5T9+Fi
	 VK277Rmtihbf5R4nbBCeVWo7slL51Yh+w2pgEpH4z6ztnMsI/Mhc24aYeT0AO28PSXt2i
	 By5TtdaDhclsMUC5D/j6q3sl5QM/VdiPq4l38CDNZAk1GXTmyu+pIBSE+fcZxCfemRnhc
	 lacIdmIf1JlRH7DeoBCjeg7nbbhBaPzctiA7tQ3gQSvI5y+aDXWYGnRFEDO2uWm148Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UXq1R8+Is2xwscRZoG+dAYnsUVm0DuekyNvHxwOHrXE=;
	b=x/0V+1z6cGHPhK9yEwFJtX2pMV/TWf7rigqBLZ2Tn8x55wlo3i/lYVe+m9x3L5tMUHmY
	 fVUpoNxxYeYkRvzUkCkvWBuFOTRUAQjWcXLhzTMZ9ZNLyMY0F8ywWqVjX52hpsvBs6tTX
	 XdvBMlXCGJfKl0M8hXdy2Gy3SLFpQgzolVS7SctSVbqfQVsdXfkdgoshjMCaNfvJ4G36X
	 xuJ/Q8RCbp62H6c3wX4AXuzHaaQ9UjrH6UCiYCJNciJA7BGP1zHJa3apsAYFAotpGyGE6
	 3DhLZo9hajsZqAd6ngW7PjCpKTSrwxQ/q1CiRq5O/OqzuO7L7ksJA7/WZByAvEqkhLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="W6Ic6/dG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6261606A325;
	Wed, 18 Nov 2026 22:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W6Ic6/dG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307CF1F000C4;
	Wed, 18 Nov 2026 22:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042179;
	bh=UXq1R8+Is2xwscRZoG+dAYnsUVm0DuekyNvHxwOHrXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6Ic6/dG0qCzreF02RqSNuO2/yoVrK4Wqv59CO/1a8UV9sZSlTY5XnQohEaWz49H6
	 lQx4/niTdqCEkuZoEpoa4rwjA9vxn65LXof7jnBnV5nFycR1SCoCbmZhvpNjxj2RZB
	 tti++NRpAZa5GYBaHxmlcr5hj71bPjzaK4P8D+yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Maimon <maimon.sagi@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3079/3318] net: axienet: release every RX buffer in axienet_dma_bd_release()
Date: Wed, 18 Nov 2026 16:01:41 +0100
Message-ID: <20261118150452.446296277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e6f313414262d..3461a3da18747 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -225,13 +225,13 @@ static void axienet_dma_bd_release(struct net_device *ndev)
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
@@ -242,6 +242,8 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 			dma_unmap_single(lp->dev, phys,
 					 lp->max_frm_size, DMA_FROM_DEVICE);
 		}
+
+		dev_kfree_skb(lp->rx_bd_v[i].skb);
 	}
 
 	dma_free_coherent(lp->dev,
-- 
2.53.0



