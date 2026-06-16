Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845A93BFE5A;
	Tue, 16 Jun 2026 18:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634138; cv=none; b=PVdyutYXq7FNiSN4YVC/W5AmVWeKfILPXrHoH0zNp8dzwtPkgNAt6W+41Rc+/t+zp4JYlpov3+4dUZfFSBZXt16Vhus4RU/cHN2X+YNXE0nQfA/LkvRRZrqJPJhr/0KXCYl2ZboAzvl9iz/Q/Qa/tZWi+bvwqIPUk2WHXd5mYm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634138; c=relaxed/simple;
	bh=pU2douOwGB0YpfSwUb6/lY6KPwsoOQGj11pK4jz9jYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UB9PcCQnIjYNB1MyeStwH4azqwkdEQHt8CrURrT2Nw11nLmpU61ZNwreVXOKMpd8900PqidYrxlkMmVeLJPOtUyjSjypMEVw+nBw5tM46FojhE7w6opKv+xDCozA1b8qIgtfFexX/Z+7CDOiPE0KaCmbSWGbMXbZEIHjMItQFtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTXdydq5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTXdydq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8216F1F000E9;
	Tue, 16 Jun 2026 18:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634137;
	bh=jz3HRdropGBD2mtwP9WNdfxpo94xB7u92JBSj9oZWzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTXdydq5HkwFXlDVlohgrx+V+YP6GDRFfA1NwS/redRkNWcBObYy02M2gvvAfd09o
	 UFNOLhi55nZvcgtheIvohaia+Gj58rzwySgN8eY1pve3GQQoyyKnj9JDFPrmd+adws
	 PqG1XnMi3N6xifZA1bYiVrttLbqjGhr3prdk76Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Til Kaiser <mail@tk154.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 198/411] net: mvpp2: refill RX buffers before XDP or skb use
Date: Tue, 16 Jun 2026 20:27:16 +0530
Message-ID: <20260616145111.244297445@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d55c3f1526c38b..04002548a46327 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3970,6 +3970,12 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
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
 
@@ -3987,12 +3993,6 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 
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
@@ -4004,8 +4004,21 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
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
@@ -4016,16 +4029,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
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
@@ -4044,13 +4048,14 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
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



