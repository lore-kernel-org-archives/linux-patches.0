Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52D04F30D7;
	Tue, 13 Oct 2026 11:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892787; cv=none; b=mPZxCb0QagoSXJs1ZMEtTPcwbqDDx+sGcy7v2uCYZhv81WNe28LOSZj5Jt70xsxIqSIQQz0NGGFZded7HcPxLTtGfvUTsugBDfQJmB/Y0IZxw6nUmGFOlBkJ9iOtm1rwZcncpNvmbVBbo4bqhUAJUupQT1Vi6NAzsSJXlFnfP3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892787; c=relaxed/simple;
	bh=kygKcoJt1DO3TwU70LGbtLtYpfs+MteIWXrqJXwx/K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGbseeIIFEkIfy7Fq8qg9fnG1b/tFYLb4hOXfeetwxFwTKQDZdkd4BWjM2O7ZrWVUYuwonlZxGCp53F+ldFROXBPdv4nmlbf0hb7a/wokCsO0957Up1XDVncEUz8/JXyRI/43GM9OXXwprjugAMDum1nKHJhqYgEJW7nidw+gu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWvPSMyZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWvPSMyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A16D1F000FF;
	Tue, 13 Oct 2026 11:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892786;
	bh=Mdefv14F68V3lUd4JxLtYdThADifVbZK0W1UTZKyU60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWvPSMyZtJpfM0AyMb9VQ3wTx9/LUu3KszJIotTI0S9Ai3TpRL883cYoh3xjCGfO0
	 cIe/J+TcGypArV4ZRLPySxx6ycbU07nmDgzRjCnj1nP6ZA0RnmmhC4sWnyzRfRUuQc
	 vTUd8KgMhMFGOuQAQTvUdiudGBOiSKPCsZe4U2Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Fleischmann <sfle@kth.se>,
	Eric Dumazet <edumazet@google.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/621] bnxt_en: fix DMA mapping length for padded small packets
Date: Tue, 13 Oct 2026 13:29:56 +0200
Message-ID: <20261013112920.895331917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit a51d233ccd4889aadb71dace863525cc2b00271e ]

Stefan Fleischmann reported Intel IOMMU DMA Read faults on BCM57412
NetXtreme-E NICs when transmitting packets on VLAN/macvlan interfaces:

  DMAR: [DMA Read NO_PASID] Request device [18:00.0] fault addr 0xfc499000
        [fault reason 0x06] PTE Read access is not set
  bnxt_en 0000:18:00.0 eno1np0: Abandoning msg {0xb4 0x41a} len: 0 due to firmware status: 0x2000001
  ...
  NETDEV WATCHDOG: eno1np0 (bnxt_en): transmit queue 0 timed out

The fault address (0xfc499000) is on an exact 4KB page boundary,
pointing to a DMA read buffer overrun.

In bnxt_start_xmit(), packets smaller than BNXT_MIN_PKT_SIZE (52 bytes),
such as 42-byte untagged ARP frames, are padded:

    if (length < BNXT_MIN_PKT_SIZE) {
        pad = BNXT_MIN_PKT_SIZE - length;
        if (skb_pad(skb, pad))
            goto tx_kick_pending;
        length = BNXT_MIN_PKT_SIZE;
    }

    mapping = dma_map_single(&pdev->dev, skb->data, len, DMA_TO_DEVICE);
    ...
    dma_unmap_len_set(tx_buf, len, len);

However, 'len' was initialized earlier to skb_headlen(skb) (e.g. 42 bytes)
and is left unadjusted after padding. Consequently, dma_map_single() and
dma_unmap_len_set() map and track only 42 bytes.

Later, the hardware TX buffer descriptor is programmed with the padded length:

    txbd->tx_bd_len_flags_type =
        cpu_to_le32(((len + pad) << TX_BD_LEN_SHIFT) | flags |
                    TX_BD_FLAGS_PACKET_END);

The NIC DMA engine is thus instructed to read 52 bytes from a region where
only 42 bytes were DMA-mapped. If skb->data ends near the boundary of a 4KB
page (within 'pad' bytes of the next page), the hardware DMA read overruns
into the unmapped adjacent page, triggering an IOMMU fault.

This issue was exposed after commit 447cbe95ebb9 ("vlan: fix skb_under_panic
and races when toggling HW VLAN offload") because reserving extra VLAN
headroom rounded LL_RESERVED_SPACE from 48 up to 64 bytes, shifting skb->data
offsets and potentially causing small frames to land right against page
boundaries.

Fix this by using skb_put_padto(skb, BNXT_MIN_PKT_SIZE) in
bnxt_start_xmit(), before skb_shinfo(skb)->nr_frags is sampled,
because padding might linearize the skb.
This ensures skb->len and skb_headlen(skb) reflect the padded size so
that dma_map_single() maps the full buffer and the descriptor length is
consistent. This also removes the temporary 'pad' variable and masking logic.

The padding is done after the SW USO branch, otherwise
bnxt_sw_udp_gso_xmit() would account the padding as UDP payload
and send it in extra segments.

Note that SW USO segments are still not padded: with IPv4, a segment
carrying less than 10 bytes of UDP payload (small gso_size, or a short
last segment) is sent as a frame shorter than BNXT_MIN_PKT_SIZE.
This is a separate issue, left for a followup patch.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Cc: stable@vger.kernel.org
Reported-by: Stefan Fleischmann <sfle@kth.se>
Closes: https://lore.kernel.org/netdev/20261004122616.56714cbd@nargothrond/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20261007051747.455273-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 52cb2a25600bd..af9bf48100379 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -474,7 +474,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct netdev_queue *txq;
 	int i;
 	dma_addr_t mapping;
-	unsigned int length, pad = 0;
+	unsigned int length;
 	u32 len, free_size, vlan_tag_flags, cfa_action, flags;
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
 	struct pci_dev *pdev = bp->pdev;
@@ -503,6 +503,14 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			goto tx_free;
 	}
 #endif
+	/* Pad before skb_shinfo(skb)->nr_frags is sampled, because
+	 * skb_put_padto() might linearize the skb.
+	 */
+	if (skb_put_padto(skb, BNXT_MIN_PKT_SIZE)) {
+		/* SKB already freed. */
+		goto tx_kick_pending;
+	}
+
 	free_size = bnxt_tx_avail(bp, txr);
 	if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
 		/* We must have raced with NAPI cleanup */
@@ -642,14 +650,6 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 normal_tx:
-	if (length < BNXT_MIN_PKT_SIZE) {
-		pad = BNXT_MIN_PKT_SIZE - length;
-		if (skb_pad(skb, pad))
-			/* SKB already freed. */
-			goto tx_kick_pending;
-		length = BNXT_MIN_PKT_SIZE;
-	}
-
 	mapping = dma_map_single(&pdev->dev, skb->data, len, DMA_TO_DEVICE);
 
 	if (unlikely(dma_mapping_error(&pdev->dev, mapping)))
@@ -732,10 +732,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		txbd->tx_bd_len_flags_type = cpu_to_le32(flags);
 	}
 
-	flags &= ~TX_BD_LEN;
-	txbd->tx_bd_len_flags_type =
-		cpu_to_le32(((len + pad) << TX_BD_LEN_SHIFT) | flags |
-			    TX_BD_FLAGS_PACKET_END);
+	txbd->tx_bd_len_flags_type |= cpu_to_le32(TX_BD_FLAGS_PACKET_END);
 
 	netdev_tx_sent_queue(txq, skb->len);
 
-- 
2.53.0



