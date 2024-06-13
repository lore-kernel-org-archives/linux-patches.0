Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26A7143892;
	Thu, 13 Jun 2024 12:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282616; cv=none; b=OIBfhTCdmk0+k7+4SD6xLKJMrLJg+TpM+dJjTzBA3J4KiXuiwdAWzZtqgOWkQ5De7BKopUmfyWAmsHWepEFMBcepRUgmAhnwi2Dsio6Qrrl6BkkdDCr0QY8L5m0XJI5owy73WLjl8py21eRU8i6UjyWU9nXT1+l2TBwmVDcFbsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282616; c=relaxed/simple;
	bh=4+5jPSfSO7claWTvAypu6qirncl7qW8fSNRLL+ERpII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqOXlPS6+UxQ0w3SUxOUv+BZZvVYPnKag3B5tycNLYO55XEHkNuOI6u2+mbvnmt7U0kWPg7LGCndCAOeyotDRho0UvHSVbkjRebRZO1YYLYimFrZApkwWW83Bx9AG9MQn9XQv2ywAgxEHLxSAp0nRdowDVoSDNjIq5jsNg/AWfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOP0uwaa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOP0uwaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36537C4AF1C;
	Thu, 13 Jun 2024 12:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282616;
	bh=4+5jPSfSO7claWTvAypu6qirncl7qW8fSNRLL+ERpII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOP0uwaaYWkuQM3CSPEf+mS1JTltOMwgYhg8cZzll3UFzg9/EsA+zqAwiOv8HYsza
	 SbrXSQZRPN5eQc72NJBj6Ou8wJGCSgm8GVeNSCGXfU5TLXZxb2uslTL1zRcxFv0sxE
	 DnOCmwaxNDi7JUFlddsYdWFYSCWyQv3z/X29vZLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Kiyanovski <akiyano@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 337/402] net: ena: Fix DMA syncing in XDP path when SWIOTLB is on
Date: Thu, 13 Jun 2024 13:34:54 +0200
Message-ID: <20240613113315.280983904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Arinzon <darinzon@amazon.com>

commit d760117060cf2e90b5c59c5492cab179a4dbce01 upstream.

This patch fixes two issues:

Issue 1
-------
Description
```````````
Current code does not call dma_sync_single_for_cpu() to sync data from
the device side memory to the CPU side memory before the XDP code path
uses the CPU side data.
This causes the XDP code path to read the unset garbage data in the CPU
side memory, resulting in incorrect handling of the packet by XDP.

Solution
````````
1. Add a call to dma_sync_single_for_cpu() before the XDP code starts to
   use the data in the CPU side memory.
2. The XDP code verdict can be XDP_PASS, in which case there is a
   fallback to the non-XDP code, which also calls
   dma_sync_single_for_cpu().
   To avoid calling dma_sync_single_for_cpu() twice:
2.1. Put the dma_sync_single_for_cpu() in the code in such a place where
     it happens before XDP and non-XDP code.
2.2. Remove the calls to dma_sync_single_for_cpu() in the non-XDP code
     for the first buffer only (rx_copybreak and non-rx_copybreak
     cases), since the new call that was added covers these cases.
     The call to dma_sync_single_for_cpu() for the second buffer and on
     stays because only the first buffer is handled by the newly added
     dma_sync_single_for_cpu(). And there is no need for special
     handling of the second buffer and on for the XDP path since
     currently the driver supports only single buffer packets.

Issue 2
-------
Description
```````````
In case the XDP code forwarded the packet (ENA_XDP_FORWARDED),
ena_unmap_rx_buff_attrs() is called with attrs set to 0.
This means that before unmapping the buffer, the internal function
dma_unmap_page_attrs() will also call dma_sync_single_for_cpu() on
the whole buffer (not only on the data part of it).
This sync is both wasteful (since a sync was already explicitly
called before) and also causes a bug, which will be explained
using the below diagram.

The following diagram shows the flow of events causing the bug.
The order of events is (1)-(4) as shown in the diagram.

CPU side memory area

     (3)convert_to_xdp_frame() initializes the
        headroom with xdpf metadata
                      ||
                      \/
          ___________________________________
         |                                   |
 0       |                                   V                       4K
 ---------------------------------------------------------------------
 | xdpf->data      | other xdpf       |   < data >   | tailroom ||...|
 |                 | fields           |              | GARBAGE  ||   |
 ---------------------------------------------------------------------

                   /\                        /\
                   ||                        ||
   (4)ena_unmap_rx_buff_attrs() calls     (2)dma_sync_single_for_cpu()
      dma_sync_single_for_cpu() on the       copies data from device
      whole buffer page, overwriting         side to CPU side memory
      the xdpf->data with GARBAGE.           ||
 0                                                                   4K
 ---------------------------------------------------------------------
 | headroom                           |   < data >   | tailroom ||...|
 | GARBAGE                            |              | GARBAGE  ||   |
 ---------------------------------------------------------------------

Device side memory area                      /\
                                             ||
                               (1) device writes RX packet data

After the call to ena_unmap_rx_buff_attrs() in (4), the xdpf->data
becomes corrupted, and so when it is later accessed in
ena_clean_xdp_irq()->xdp_return_frame(), it causes a page fault,
crashing the kernel.

Solution
````````
Explicitly tell ena_unmap_rx_buff_attrs() not to call
dma_sync_single_for_cpu() by passing it the ENA_DMA_ATTR_SKIP_CPU_SYNC
flag.

Fixes: f7d625adeb7b ("net: ena: Add dynamic recycling mechanism for rx buffers")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Link: https://lore.kernel.org/r/20231211062801.27891-4-darinzon@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1495,11 +1495,6 @@ static struct sk_buff *ena_rx_skb(struct
 		if (unlikely(!skb))
 			return NULL;
 
-		/* sync this buffer for CPU use */
-		dma_sync_single_for_cpu(rx_ring->dev,
-					dma_unmap_addr(&rx_info->ena_buf, paddr) + pkt_offset,
-					len,
-					DMA_FROM_DEVICE);
 		skb_copy_to_linear_data(skb, buf_addr + buf_offset, len);
 		dma_sync_single_for_device(rx_ring->dev,
 					   dma_unmap_addr(&rx_info->ena_buf, paddr) + pkt_offset,
@@ -1518,17 +1513,10 @@ static struct sk_buff *ena_rx_skb(struct
 
 	buf_len = SKB_DATA_ALIGN(len + buf_offset + tailroom);
 
-	pre_reuse_paddr = dma_unmap_addr(&rx_info->ena_buf, paddr);
-
 	/* If XDP isn't loaded try to reuse part of the RX buffer */
 	reuse_rx_buf_page = !is_xdp_loaded &&
 			    ena_try_rx_buf_page_reuse(rx_info, buf_len, len, pkt_offset);
 
-	dma_sync_single_for_cpu(rx_ring->dev,
-				pre_reuse_paddr + pkt_offset,
-				len,
-				DMA_FROM_DEVICE);
-
 	if (!reuse_rx_buf_page)
 		ena_unmap_rx_buff_attrs(rx_ring, rx_info, DMA_ATTR_SKIP_CPU_SYNC);
 
@@ -1724,6 +1712,7 @@ static int ena_clean_rx_irq(struct ena_r
 	int xdp_flags = 0;
 	int total_len = 0;
 	int xdp_verdict;
+	u8 pkt_offset;
 	int rc = 0;
 	int i;
 
@@ -1750,13 +1739,19 @@ static int ena_clean_rx_irq(struct ena_r
 
 		/* First descriptor might have an offset set by the device */
 		rx_info = &rx_ring->rx_buffer_info[rx_ring->ena_bufs[0].req_id];
-		rx_info->buf_offset += ena_rx_ctx.pkt_offset;
+		pkt_offset = ena_rx_ctx.pkt_offset;
+		rx_info->buf_offset += pkt_offset;
 
 		netif_dbg(rx_ring->adapter, rx_status, rx_ring->netdev,
 			  "rx_poll: q %d got packet from ena. descs #: %d l3 proto %d l4 proto %d hash: %x\n",
 			  rx_ring->qid, ena_rx_ctx.descs, ena_rx_ctx.l3_proto,
 			  ena_rx_ctx.l4_proto, ena_rx_ctx.hash);
 
+		dma_sync_single_for_cpu(rx_ring->dev,
+					dma_unmap_addr(&rx_info->ena_buf, paddr) + pkt_offset,
+					rx_ring->ena_bufs[0].len,
+					DMA_FROM_DEVICE);
+
 		if (ena_xdp_present_ring(rx_ring))
 			xdp_verdict = ena_xdp_handle_buff(rx_ring, &xdp, ena_rx_ctx.descs);
 
@@ -1782,7 +1777,7 @@ static int ena_clean_rx_irq(struct ena_r
 				if (xdp_verdict & ENA_XDP_FORWARDED) {
 					ena_unmap_rx_buff_attrs(rx_ring,
 								&rx_ring->rx_buffer_info[req_id],
-								0);
+								DMA_ATTR_SKIP_CPU_SYNC);
 					rx_ring->rx_buffer_info[req_id].page = NULL;
 				}
 			}


