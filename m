Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056402;
	b=OUymi6D/vfsHtqJ0E5CYyln1Ux/dficZdd1LZtx9ssdDp1pS0+8xz48Gkg0Bt4W6FhLg
	 dl1EUZVIxKSdqSNzH5n1wgEbj20z7Xf49nlL5SZQiKDczFjasAoOS4G9w5lHlcSj+B+22
	 NWPDse68wSIS/GghQQR5Wiujbs/KC5JqAQNcJHTUVodHrXzryUJFJq2pRvkUJY6mj0rDe
	 fvwqHAfYwVl98JMz7rUeJBM861YmiWCLdgGL3TtlqaZZZ1a3Q2gG8TTnRMInYWrs75+lD
	 e3eDjLNStsSh7wNpgl6liHnB7RpRavr/4BSwPsQNqwA63yQZ30HK1+IyFBHj17IR1hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zciFjFTKUEv6K8+Y6NODBmzGmZfsGcB/nSYRim96X34=;
	b=oLIIIh4l9+tV35+bQ0huVntokn/l8YG+4WoGtcUCrZCXGL40mdb3HY2DUgsf89+ZlarU
	 1XA9bhM7sul/jBlt3BhAZTDlVpJb59T8Hzo13a584x8dTT4AsZNsnpy8n7gM3ggex+XZt
	 /AF2ngq2S749AaC3Mxa9gNa9m9AxkEmpo3JI++cS+kJT9Jg+xCQR59eeX/Nm748frQFFt
	 aLMQfvCbW44O/U/8Ttb8P7KozYkZDWV7jlBRwX3RUuj83G3/X42XsttBwWpSN/DlpLFzv
	 pELZLPIKCNk34rmfwwlmvDg9qHYCZRuGLvQ4IHs3f6iYPSkhDt4lG03eu7/CAyOJsaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxwt0xsK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F416606A325;
	Thu, 19 Nov 2026 02:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxwt0xsK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18BE1F000C4;
	Thu, 19 Nov 2026 02:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056402;
	bh=zciFjFTKUEv6K8+Y6NODBmzGmZfsGcB/nSYRim96X34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxwt0xsKHudp4UPcZKaEAoMX9u+whKDR6jSivqDSf6jq1vfFjFZUNl1Zv7pkC6RCo
	 FODjoQZ010qLdC+xNGivxBfY4VtFGtcRjUzQX8IBFoYA/Yg52cZ3NDPL+RZSNS8c1M
	 02gw1DvCGAfOVtJTQYhD4weCHjY6jCy0ZlBUilTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Sagi Maimon <maimon.sagi@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1948/2214] net: axienet: free outstanding TX buffers in axienet_dma_bd_release()
Date: Wed, 18 Nov 2026 16:00:24 +0100
Message-ID: <20261118150128.917938570@linuxfoundation.org>
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

From: Sagi Maimon <maimon.sagi@gmail.com>

[ Upstream commit 0c20cb4cfb40cf270d6c4c2c2ff5e5d72322644a ]

axienet_dma_bd_release() walks the RX ring to unmap and free every
receive buffer before releasing it, but frees the TX descriptor ring
with dma_free_coherent() alone.  Any descriptor that
axienet_free_tx_chain() had not yet reclaimed still holds its skb and
its streaming DMA mapping, and both are lost.

axienet_stop() disables TX NAPI and stops the DMA engine before calling
it, so nothing reclaims those descriptors afterwards.  Bringing the
interface down while frames are in flight therefore leaks up to
lp->tx_bd_num skbs and mappings each time.

axienet_dma_err_handler() already walks the TX ring this way before it
restarts the DMA engine: it unmaps every descriptor whose cntrl is still
set - axienet_free_tx_chain() clears it on reclaim - frees any skb still
attached, and clears the descriptor.  Move that loop into a helper,
axienet_free_tx_bufs(), and call it from axienet_dma_bd_release() too.
This relies on axienet_stop() having stopped the DMA engine first, as
the RX walk in the same function already does.  The helper frees the
skbs with dev_kfree_skb_any(), as drops: in the error handler, which
runs from a workqueue, that frees them directly rather than deferring
them to softirq as dev_kfree_skb_irq() did.

The walk must not run on a ring that is not there.  axienet_open() does
not check the result of the reset that runs axienet_dma_bd_init(), so
when that reset fails tx_bd_v is either still NULL or, after an earlier
close, points at the ring that close freed.  Clear tx_bd_v and rx_bd_v
once their rings are freed, and skip the walk when tx_bd_v is NULL.
That also ends the second dma_free_coherent() of a stale ring which the
same path already did.  On the axienet_dma_bd_init() error path the TX
ring has just been allocated zeroed, so the walk does nothing.

This was reported by the Sashiko AI review bot.

Tested on the AXI Ethernet MAC of an ADVA TimeCard X2 (PCIe card, with
the built-in AXI DMA): traffic passes, and after each of ten down/up
cycles and five module reloads, all made with traffic running and each
running axienet_dma_bd_release(), traffic resumes and nothing is logged.
The leak itself was not measured, and neither the failed-reset paths nor
axienet_dma_err_handler() were exercised.

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Reviewed-by: Joe Damato <joe@dama.to>
Assisted-by: LLM sparse
Signed-off-by: Sagi Maimon <maimon.sagi@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261007034620.1360542-1-maimon.sagi@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 74 +++++++++++++------
 1 file changed, 50 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index f63d2224ba91a..fddf444072ea9 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -176,6 +176,46 @@ static dma_addr_t desc_get_phys_addr(struct axienet_local *lp,
 	return ret;
 }
 
+/**
+ * axienet_free_tx_bufs - Release the buffers still held by the TX ring
+ * @lp:		Pointer to the axienet_local structure
+ *
+ * Unmap every descriptor whose mapping is still live, free any skb still
+ * attached, and clear the descriptor for reuse.  axienet_free_tx_chain()
+ * clears cntrl when it reclaims a descriptor, so a non-zero value means
+ * the mapping is live.  The DMA engine must be stopped.
+ */
+static void axienet_free_tx_bufs(struct axienet_local *lp)
+{
+	struct axidma_bd *cur_p;
+	u32 i;
+
+	for (i = 0; i < lp->tx_bd_num; i++) {
+		cur_p = &lp->tx_bd_v[i];
+		if (cur_p->cntrl) {
+			dma_addr_t addr = desc_get_phys_addr(lp, cur_p);
+
+			dma_unmap_single(lp->dev, addr,
+					 (cur_p->cntrl &
+					  XAXIDMA_BD_CTRL_LENGTH_MASK),
+					 DMA_TO_DEVICE);
+		}
+		/* not reclaimed by axienet_free_tx_chain(), so a drop */
+		if (cur_p->skb)
+			dev_kfree_skb_any(cur_p->skb);
+		cur_p->phys = 0;
+		cur_p->phys_msb = 0;
+		cur_p->cntrl = 0;
+		cur_p->status = 0;
+		cur_p->app0 = 0;
+		cur_p->app1 = 0;
+		cur_p->app2 = 0;
+		cur_p->app3 = 0;
+		cur_p->app4 = 0;
+		cur_p->skb = NULL;
+	}
+}
+
 /**
  * axienet_dma_bd_release - Release buffer descriptor rings
  * @ndev:	Pointer to the net_device structure
@@ -189,11 +229,18 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 	int i;
 	struct axienet_local *lp = netdev_priv(ndev);
 
-	/* If we end up here, tx_bd_v must have been DMA allocated. */
+	/* tx_bd_v is NULL if axienet_dma_bd_init() did not get as far as
+	 * allocating it, and is cleared below once the ring is freed;
+	 * dma_free_coherent() accepts NULL.
+	 */
+	if (lp->tx_bd_v)
+		axienet_free_tx_bufs(lp);
+
 	dma_free_coherent(lp->dev,
 			  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
 			  lp->tx_bd_v,
 			  lp->tx_bd_p);
+	lp->tx_bd_v = NULL;
 
 	if (!lp->rx_bd_v)
 		return;
@@ -224,6 +271,7 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 			  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
 			  lp->rx_bd_v,
 			  lp->rx_bd_p);
+	lp->rx_bd_v = NULL;
 }
 
 /**
@@ -1864,29 +1912,7 @@ static void axienet_dma_err_handler(struct work_struct *work)
 
 	axienet_dma_stop(lp);
 
-	for (i = 0; i < lp->tx_bd_num; i++) {
-		cur_p = &lp->tx_bd_v[i];
-		if (cur_p->cntrl) {
-			dma_addr_t addr = desc_get_phys_addr(lp, cur_p);
-
-			dma_unmap_single(lp->dev, addr,
-					 (cur_p->cntrl &
-					  XAXIDMA_BD_CTRL_LENGTH_MASK),
-					 DMA_TO_DEVICE);
-		}
-		if (cur_p->skb)
-			dev_kfree_skb_irq(cur_p->skb);
-		cur_p->phys = 0;
-		cur_p->phys_msb = 0;
-		cur_p->cntrl = 0;
-		cur_p->status = 0;
-		cur_p->app0 = 0;
-		cur_p->app1 = 0;
-		cur_p->app2 = 0;
-		cur_p->app3 = 0;
-		cur_p->app4 = 0;
-		cur_p->skb = NULL;
-	}
+	axienet_free_tx_bufs(lp);
 
 	for (i = 0; i < lp->rx_bd_num; i++) {
 		cur_p = &lp->rx_bd_v[i];
-- 
2.53.0



