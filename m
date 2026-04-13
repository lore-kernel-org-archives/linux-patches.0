Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D9D32ABC0;
	Mon, 13 Apr 2026 17:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099731; cv=none; b=roZQ1yijwss2OE9GeJ1BkPl2+lqROrzKrFD77XrinnK4uE17wHs6jSiBvKmGFpk87RWXE3xR3OvsgMT7qazLPGD7ixGc6Oz+/V10wEtwelXzwNXvq9dg/Z94oA+IZnrIEpBFWeRw6/6euz8p3llTJa8f72FFa2+XHfyyBd/76iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099731; c=relaxed/simple;
	bh=5g18jgowgC6T00fqUmbAYOeB8qR8oiuhGoJMsFoDrIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swrZnYFMu2GP+I1YFLlTKZ2WD6hv1QlknXiZLqswl4MyilQI0tRcLW83y0SxuWQMGRcjmDHFZe7NA36DJZoXLMR+Bfm6TJ8VercTlbYMNB/kWMqWYZxydLnwTyjxszrJ60ie2WSR0oa4uRLe40ntgT8ok8dazecnFOGwIz5/p/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xY/c6sB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xY/c6sB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84331C2BCAF;
	Mon, 13 Apr 2026 17:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099731;
	bh=5g18jgowgC6T00fqUmbAYOeB8qR8oiuhGoJMsFoDrIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xY/c6sB4IVJ6LThlGgP6RHUY/gmQmsaq4VJRgcmHkFgMvyfBGcMneZzIwLgow7DcJ
	 j8zxYgrNEkdKY+/+NbP6ngJmDeGZ1rYyw7Vsv/fZySwy8JUaBTVIVX7cFQTN4juDg+
	 E22wSXKKL5EiOQy2KTBL5WZwD23XwVLHSa0C3R6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyllis Xu <LivelyCarpet87@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 451/491] net: stmmac: fix integer underflow in chain mode
Date: Mon, 13 Apr 2026 18:01:36 +0200
Message-ID: <20260413155835.921102312@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyllis Xu <livelycarpet87@gmail.com>

commit 51f4e090b9f87b40c21b6daadb5c06e6c0a07b67 upstream.

The jumbo_frm() chain-mode implementation unconditionally computes

    len = nopaged_len - bmax;

where nopaged_len = skb_headlen(skb) (linear bytes only) and bmax is
BUF_SIZE_8KiB or BUF_SIZE_2KiB.  However, the caller stmmac_xmit()
decides to invoke jumbo_frm() based on skb->len (total length including
page fragments):

    is_jumbo = stmmac_is_jumbo_frm(priv, skb->len, enh_desc);

When a packet has a small linear portion (nopaged_len <= bmax) but a
large total length due to page fragments (skb->len > bmax), the
subtraction wraps as an unsigned integer, producing a huge len value
(~0xFFFFxxxx).  This causes the while (len != 0) loop to execute
hundreds of thousands of iterations, passing skb->data + bmax * i
pointers far beyond the skb buffer to dma_map_single().  On IOMMU-less
SoCs (the typical deployment for stmmac), this maps arbitrary kernel
memory to the DMA engine, constituting a kernel memory disclosure and
potential memory corruption from hardware.

Fix this by introducing a buf_len local variable clamped to
min(nopaged_len, bmax).  Computing len = nopaged_len - buf_len is then
always safe: it is zero when the linear portion fits within a single
descriptor, causing the while (len != 0) loop to be skipped naturally,
and the fragment loop in stmmac_xmit() handles page fragments afterward.

Fixes: 286a83721720 ("stmmac: add CHAINED descriptor mode support (V4)")
Cc: stable@vger.kernel.org
Signed-off-by: Tyllis Xu <LivelyCarpet87@gmail.com>
Link: https://patch.msgid.link/20260401044708.1386919-1-LivelyCarpet87@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
+++ b/drivers/net/ethernet/stmicro/stmmac/chain_mode.c
@@ -20,7 +20,7 @@ static int jumbo_frm(void *p, struct sk_
 	unsigned int nopaged_len = skb_headlen(skb);
 	struct stmmac_priv *priv = tx_q->priv_data;
 	unsigned int entry = tx_q->cur_tx;
-	unsigned int bmax, des2;
+	unsigned int bmax, buf_len, des2;
 	unsigned int i = 1, len;
 	struct dma_desc *desc;
 
@@ -31,17 +31,18 @@ static int jumbo_frm(void *p, struct sk_
 	else
 		bmax = BUF_SIZE_2KiB;
 
-	len = nopaged_len - bmax;
+	buf_len = min_t(unsigned int, nopaged_len, bmax);
+	len = nopaged_len - buf_len;
 
 	des2 = dma_map_single(priv->device, skb->data,
-			      bmax, DMA_TO_DEVICE);
+			      buf_len, DMA_TO_DEVICE);
 	desc->des2 = cpu_to_le32(des2);
 	if (dma_mapping_error(priv->device, des2))
 		return -1;
 	tx_q->tx_skbuff_dma[entry].buf = des2;
-	tx_q->tx_skbuff_dma[entry].len = bmax;
+	tx_q->tx_skbuff_dma[entry].len = buf_len;
 	/* do not close the descriptor and do not set own bit */
-	stmmac_prepare_tx_desc(priv, desc, 1, bmax, csum, STMMAC_CHAIN_MODE,
+	stmmac_prepare_tx_desc(priv, desc, 1, buf_len, csum, STMMAC_CHAIN_MODE,
 			0, false, skb->len);
 
 	while (len != 0) {


