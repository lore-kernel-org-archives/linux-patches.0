Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621155;
	b=OHHwfQO4SiuGZK3n1a8x4ngY6pfNnSKDJ/thud0s9mdNkDp3KRrKzUDk3bToi4QkKjoM
	 L6JnO2C+cr4hBpNwNCweAGePu2T/hE01sic5mIZVnjZWfTfIJ7Gfnpi+8iQaMQpAy1WFz
	 /BeK78540Y6axBDbBGQpppi+CWnyaZC4oEJn5nO7HfApdmYKm5mOVw/Ueet5mN1Yvg9Cp
	 HGeEl5ErMt+gixL/x7yIIcxkpf2+s+xhMpWLNFwQmgpq2A3hDgn3+x4hds7e45Y3jZf8L
	 wzOm7E0MbFg0jvxFJqlRP5QYKTOkPD47HJies7hwHgABoBdA+5Xt8Iut9hTRnladzUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RTV9VBPcymzydLyFAdMksXkecriucQT3gz3exNrEOJo=;
	b=1oOCMzxq1V5mS2RXg2VohUx7VfrZfEf5JUEI4m8Jj94MWJ7ctJGo7qpH+7yfr0RfnvPb
	 XdBrBLbd6qRM0L4TI+oMfvM7FNjbC52F2Ija8B1HByHy9Ui6Si36oguVqt2GCaI71FK62
	 1bVuFdsVlVRHik6FkQe90dRLWCLO4r2NZ+h7DACTMzIYa/euNakCluYIdPno723K6vxH4
	 Hz4AKIKzNmsI4XRLY4IGbbfq8XnsZC6skf7WNWehZ3Ff/wt7H15G+7mTE+oTZRBKNfHVW
	 xUvr2NxhbLKO3CkNIrNZVxr+EEPOpz4I4MpAOfUpDFhp5vk6MKHtxXt3/siOcUAMLgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNXoxmyX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28ED606A32A;
	Wed, 25 Nov 2026 15:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNXoxmyX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9011F000C4;
	Wed, 25 Nov 2026 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621155;
	bh=RTV9VBPcymzydLyFAdMksXkecriucQT3gz3exNrEOJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNXoxmyXitNJzUTqEHXMo2MLe173DES8yhAGaYeHqOWwoosIqqOyctwyhCXhRfHWP
	 2x6dWED+htEbbOB2gcxU1JYGj8/1ou/HJtEC/61g/vqRF5sYQVd5cXyimILYD078Lg
	 O+hImEEAXQi27LCkKU2QQHqppfZ7F2x+9MuL0XCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 139/990] net: stmmac: drop multi-buffer frames in XDP mode
Date: Wed, 25 Nov 2026 15:25:06 +0100
Message-ID: <20261125143825.340298953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 52ffd771e0029c5ad0504b1b4a8b7f932b65eea3 ]

stmmac_rx() runs the XDP program once per descriptor buffer and uses
skb == NULL as the only marker for the start of a frame. A frame larger
than one buffer is split by the hardware across several descriptors;
GMAC4 enables jumbo frames unconditionally (GMAC_CONFIG_JE in
GMAC_CORE_INIT), so an on-link peer can deliver such a frame even when
the interface MTU is left at 1500.

When an XDP verdict ends a non-last descriptor, skb is cleared and the
next descriptor of the same hardware frame is parsed as a new frame.
For XDP_CONSUMED this happens via read_again with len preserved, so
stmmac_rx_buf1_len() then returns min(dma_buf_sz, plen - len) for the
last descriptor, which can be as small as 0-3 bytes. buf1_len -=
ETH_FCS_LEN underflows and xdp_prepare_buff() puts data_end far past
data; on XDP_PASS this produces an skb whose length is close to 4G that
reaches the network stack (skb->tail and skb->len are 32-bit and wrap
below skb->end, so skb_over_panic() does not fire). A 4+ byte tail is
instead offered to the XDP program and delivered as a standalone
mid-payload Ethernet frame on XDP_PASS. XDP_TX/XDP_REDIRECT instead
falls through to the next iteration, resetting the running length, so
the tail is re-parsed as a full-size new frame.

The same fault exists when a single descriptor uses its second buffer:
buffer2 is now handed to the hardware for non-SPH frames on GMAC4/XGMAC,
so a frame up to 2 * dma_buf_sz can land on a single descriptor while the
XDP program still only sees the first buffer. XDP_TX then transmits a
truncated frame, and XDP_PASS appends the second buffer only after the
program has already run over the first one.

XDP does not support scatter-gather frames until the multi-buffer
rework, so drop the whole frame instead. When a non-last descriptor is
seen while an XDP program is attached, mark the frame as errored and
drain the remaining descriptors, including the last. A descriptor that
uses its second buffer is dropped directly before the program runs as
well; in XDP mode it is necessarily the last descriptor of the frame,
so it does not need the error marker. Removing the re-parse lets both
XDP verdict branches simply complete the packet via next.

The buffers consumed by the discard path are no longer returned to the
page pool, and the new SG and second-buffer drops do not return them
either. They stay in rx_q->buf_pool[] and stmmac_rx_refill() reuses them
in place, allocating only when a slot is empty. This is safe because the
drop checks run before the buffer is synced for CPU access or
prefetched. The discard-path change and the in-place reuse apply with or
without an XDP program attached.

The !error guard on the discard check also changes the accounting for
errored multi-descriptor frames on dwmac100/dwmac1000: rx_errors is
incremented once per frame instead of once per descriptor. This too is
independent of XDP mode.

Note: the subsequent "net: stmmac: rework stmmac_rx to support XDP rx
multi-buff" accumulates the whole frame into a single xdp_buff and
supersedes this patch; the fix is kept so the net portion of the series
stands on its own.

Fixes: 5fabb01207a2 ("net: stmmac: Add initial XDP support")
Fixes: 88095728511e ("net: stmmac: fix rx Scatter-Gather support")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-stmmac-xdp-fixes-v2-3-10eae8a093a8@oss.qualcomm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 35 ++++++++++---------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 022d308bb95f6..a79332f92be79 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5631,18 +5631,23 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 							   status);
 		}
 
-		if (unlikely(status & discard_frame)) {
-			page_pool_put_page(rx_q->page_pool, buf->page, 0, true);
-			buf->page = NULL;
+		if (unlikely(!error && (status & discard_frame))) {
 			error = 1;
 			if (!priv->hwts_rx_en)
 				rx_errors++;
 		}
 
-		if (unlikely(error && (status & rx_not_ls)))
-			goto read_again;
+		/* We do not support SG in XDP mode */
+		if (unlikely(!error && (status & rx_not_ls) &&
+			     stmmac_xdp_is_enabled(priv))) {
+			rx_dropped++;
+			error = 1;
+		}
 
 		if (unlikely(error)) {
+			if (status & rx_not_ls)
+				goto read_again;
+
 			dev_kfree_skb(skb);
 			goto next;
 		}
@@ -5654,6 +5659,14 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		buf2_len = stmmac_rx_buf2_len(priv, p, status, len);
 		len += buf2_len;
 
+		/* Drop the packet if it is split over buf1 and buf2 on a
+		 * single descriptor if the interface is running in XDP mode.
+		 */
+		if (unlikely(stmmac_xdp_is_enabled(priv) && buf2_len)) {
+			rx_dropped++;
+			goto next;
+		}
+
 		/* ACS is disabled; strip manually. */
 		if (likely(!(status & rx_not_ls)))
 			len -= ETH_FCS_LEN;
@@ -5703,17 +5716,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 							   sync_len, true);
 					buf->page = NULL;
 					rx_dropped++;
-
-					/* Clear skb as it was set as
-					 * status by XDP program.
-					 */
-					skb = NULL;
-
-					if (unlikely((status & rx_not_ls)))
-						goto read_again;
-
-					count++;
-					continue;
+					goto next;
 				} else if (xdp_res & (STMMAC_XDP_TX |
 						      STMMAC_XDP_REDIRECT)) {
 					xdp_status |= xdp_res;
-- 
2.53.0



