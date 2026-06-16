Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72B13101A7;
	Tue, 16 Jun 2026 17:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631665; cv=none; b=PS6/3L2eNg141IZ4oOkwLdhUxk/29qXKCnHKXtGKFO6RmMUTJqvkvs61Hr0EIXK0ZV2+Y+0KbtlTW18h74VB87zLauMp5xhoGB5dGWzz1NjFQj5hlvEyFxvQHqzTqkQLqqMfGJGs3jDr57PoPAleuLYLliCwV2r/ifX4bwlZ5Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631665; c=relaxed/simple;
	bh=YpHJXZz0LNhdl5Q4/psBhDM3CrynDCzWIQHM/eXttLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QS3xxBim9pG7FYl33S7oQGqC2Q0/vOl9ZVP777Ie93/tXWQbGDOUr8iYgvCewVVkSalnzxLg1diD7bfKlAtKJYjBHhTBdbELYA0kwfBgXZ8F6vlvCll6zlxpbhP2BmeoJhNP/kbqdu1ZvQzTOe+6NvA3tPgwfxicSqx5EyOccTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNPmx2x/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNPmx2x/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F9B1F000E9;
	Tue, 16 Jun 2026 17:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631663;
	bh=0AI1zpyTtRkNzkoGjfwbGg0vgM+HS83j4XUac2mJO5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNPmx2x/Xe59Uy7VYs59/srsRvdMukQXZBOf6hp/Vzc2s8kOYjp2NVEMd4HVbqrgW
	 AKnAOB+7QG1NbCZaFIxsImbRuf/Tx8uoKKhrQsS68TQ+X/KellLHVPMvfyCHXb6zm3
	 gyxJ+pNJQwRT+a+jm7SwfP9RYLSwaCSe5ZX67/10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Til Kaiser <mail@tk154.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 263/522] net: mvpp2: refill RX buffers before XDP or skb use
Date: Tue, 16 Jun 2026 20:26:50 +0530
Message-ID: <20260616145138.245215436@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Til Kaiser <mail@tk154.de>

[ Upstream commit 5e8e2a9624df72fca7c736b2966b2cbf6c9c3ff6 ]

The RX error path returns the current descriptor buffer to the hardware
BM pool. That is only valid while the driver still owns the buffer.

mvpp2_rx_refill() can fail after the current buffer has been handed to
XDP or attached to an skb. In those cases mvpp2_run_xdp() may have
recycled, redirected, or queued the page for XDP_TX, and an skb free also
retires the data buffer. Returning such a buffer to BM lets hardware DMA
into memory that is no longer owned by the RX ring.

Refill the BM pool before handing the current buffer to XDP or to the
skb. If the allocation fails there, drop the packet and return the
still-owned current buffer to BM, preserving the pool depth. Once the
refill succeeds, later local drops retire/free the current buffer instead
of returning it to BM.

Fixes: 07dd0a7aae7f ("mvpp2: add basic XDP support")
Fixes: d6526926de73 ("net: mvpp2: fix memory leak in mvpp2_rx")
Signed-off-by: Til Kaiser <mail@tk154.de>
Link: https://patch.msgid.link/20260607134943.21996-4-mail@tk154.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 77a6b90ce56b ("net: mvpp2: build skb from XDP-adjusted data on XDP_PASS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 43 +++++++++++--------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 4c299d8bb2392c..fc16e577a10376 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3973,6 +3973,12 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		else
 			frag_size = bm_pool->frag_size;
 
+		err = mvpp2_rx_refill(port, bm_pool, pp, pool);
+		if (err) {
+			netdev_err(port->dev, "failed to refill BM pools\n");
+			goto err_drop_frame;
+		}
+
 		if (xdp_prog) {
 			struct xdp_rxq_info *xdp_rxq;
 
@@ -3990,12 +3996,6 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 
 			if (ret) {
 				xdp_ret |= ret;
-				err = mvpp2_rx_refill(port, bm_pool, pp, pool);
-				if (err) {
-					netdev_err(port->dev, "failed to refill BM pools\n");
-					goto err_drop_frame;
-				}
-
 				ps.rx_packets++;
 				ps.rx_bytes += rx_bytes;
 				continue;
@@ -4007,8 +4007,21 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		skb = build_skb(data, frag_size);
 		if (!skb) {
 			netdev_warn(port->dev, "skb build failed\n");
-			goto err_drop_frame;
+			if (pp) {
+				page_pool_put_page(pp, virt_to_head_page(data),
+						   rx_bytes + MVPP2_MH_SIZE,
+						   true);
+			} else {
+				dma_unmap_single_attrs(dev->dev.parent, dma_addr,
+						       bm_pool->buf_size,
+						       DMA_FROM_DEVICE,
+						       DMA_ATTR_SKIP_CPU_SYNC);
+				mvpp2_frag_free(bm_pool, pp, data);
+			}
+			goto err_drop_frame_retired;
 		}
+		if (pp)
+			skb_mark_for_recycle(skb);
 
 		/* If we have RX hardware timestamping enabled, grab the
 		 * timestamp from the queue and convert.
@@ -4019,16 +4032,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 					 skb_hwtstamps(skb));
 		}
 
-		err = mvpp2_rx_refill(port, bm_pool, pp, pool);
-		if (err) {
-			netdev_err(port->dev, "failed to refill BM pools\n");
-			dev_kfree_skb_any(skb);
-			goto err_drop_frame;
-		}
-
-		if (pp)
-			skb_mark_for_recycle(skb);
-		else
+		if (!pp)
 			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
 					       bm_pool->buf_size, DMA_FROM_DEVICE,
 					       DMA_ATTR_SKIP_CPU_SYNC);
@@ -4047,13 +4051,14 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		continue;
 
 err_drop_frame:
-		dev->stats.rx_errors++;
-		mvpp2_rx_error(port, rx_desc);
 		/* Return the buffer to the pool */
 		if (rx_status & MVPP2_RXD_BUF_HDR)
 			mvpp2_buff_hdr_pool_put(port, rx_desc, pool, rx_status);
 		else
 			mvpp2_bm_pool_put(port, pool, dma_addr, phys_addr);
+err_drop_frame_retired:
+		dev->stats.rx_errors++;
+		mvpp2_rx_error(port, rx_desc);
 	}
 
 	if (xdp_ret & MVPP2_XDP_REDIR)
-- 
2.53.0



