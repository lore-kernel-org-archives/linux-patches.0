Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256C33D565F;
	Fri,  9 Oct 2026 14:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555703; cv=none; b=jh3NRHViwGyg8mDps3qEDa1Dh3/Ci0mejwLct5i33ZxERfuyUVVnp5qsgcHNHWYQOUVXjxs2OVBgTjIVXwx4dQdns+P5Jbkg61H6l0Jbq0if0GtI/EYxQ0gxkfRXj/ArrGmrRbCF1/d2xUEB8J0Wgp+ns+Zhe4Y2d1V5buiqY1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555703; c=relaxed/simple;
	bh=0bCpvBNQO6Rg+etwiHHkVmKh1cW7gsOpo53tH9AQyE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jM6A66LUE9ESf00QSKInsv9jtELSkbTXdXm9hYfEQRI1hkr/rMFVzMhYBDFdPyHGtbH0Ug22ZXetuizyBussiBuOrhz4r5WLGO7MKDd8mt2HuIF/+Po2SYxXxQdo8BRqVzATsjMcVO+lpcSLpS4blu53x1Ug6B/9yANsfH8Q4Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0G/0WXKB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0G/0WXKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E971F000FF;
	Fri,  9 Oct 2026 14:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555702;
	bh=v5PFHRj6Dsl6i4rJxsMJXvcNieTv6UDP2Pn4DefYb/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0G/0WXKB0eZhj4Nb/uOECT1pEwrwU/sDcZ6bRJ3gdJS4zy9JayCG2dHBocph84UEI
	 G8E/2KIOCGQQj4QD1+2JspBzt/qBJeeQTbJ+XBD0+L2PmYrutl2utjyo1dtIGeBdsg
	 8emXzBT9Jcx/FYoGPQQVhz57voZKPdZVrkz0BYBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/403] net: stmmac: fix rx Scatter-Gather support
Date: Fri,  9 Oct 2026 16:07:43 +0200
Message-ID: <20261009140954.471236950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 88095728511e0df9c89528944f5a1762ad298983 ]

When a received frame is larger than dma_buf_sz, the DMA scatters it
across multiple RX descriptors (rx Scatter-Gather). The secondary RX
buffer (sec_page) was only allocated and programmed when split-header
(SPH) was active, so for regular frames buffer2 was neither allocated
nor backed by a valid mapping. As soon as an incoming frame overflowed
buffer1, the DMA wrote the overflow into the unmapped secondary-buffer
address, triggering an SMMU translation fault on IOMMU-based platforms:

arm-smmu 15000000.iommu: Unhandled context fault: fsr=0x402, iova=0x00000000, fsynr=0x7f0011, cbfrsynra=0x1c90, cb=11
arm-smmu 15000000.iommu: FSR    = 00000402 [Format=2 TF], SID=0x1c90
arm-smmu 15000000.iommu: FSYNR0 = 007f0011 [S1CBNDX=127 WNR PLVL=1]

Enable scatter-gather for non-SPH frames on cores that can program an
independent secondary RX buffer (GMAC4/XGMAC): allocate and mark buffer2
as valid in stmmac_init_rx_buffers() and stmmac_rx_refill(), and account
for it in the buffer length computation. Legacy cores have no set_sec_addr
op, so they keep buffer2 disabled.

Since buffer2 is handed to the DMA at page offset 0, the page pool sync
window is widened to cover both buffers in every mode: offset is set to 0
and max_len to dma_buf_sz + stmmac_rx_offset().

The FCS can straddle the buffer1/buffer2 boundary and a descriptor
boundary, so it is now stripped from the tail of the assembled frame with
pskb_trim() instead of from a single buffer, avoiding an unsigned underflow
for frames that overflow a buffer by 1..3 bytes. For single-buffer frames
the XDP program must not see the FCS, so it is removed from the XDP buffer
before the program runs.

Native XDP currently only supports single-buffer (linear) frames. An
oversized frame accepted by the MAC (jumbo enabled) is received via
buffer2; the XDP program only sees buffer1, so on a TX/REDIRECT verdict
the frame is forwarded truncated. XDP multi-buffer support to handle
this case is planned as a follow-up.

AF_XDP zero-copy RX is not covered by this change: a ZC queue still
programs buffer2 at DMA address 0 (and XGMAC has no buffer2-valid bit),
so an oversized frame overflowing buffer1 can still trigger the same
SMMU translation fault. Handling is planned as a follow-up.

Fixes: 88ebe2cf7f3f ("net: stmmac: Rework stmmac_rx()")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260923-stmmac-rx-sg-fix-v3-1-ed26fea7180d@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 83 +++++++++++--------
 1 file changed, 49 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index be7406fbb5fea..8fa378bd591da 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1432,6 +1432,16 @@ static void stmmac_clear_descriptors(struct stmmac_priv *priv,
 		stmmac_clear_tx_descriptors(priv, dma_conf, queue);
 }
 
+static bool stmmac_rx_check_buf2_cap(struct stmmac_priv *priv)
+{
+	/* Only cores that can program an independent secondary RX buffer
+	 * (used for scatter-gather overflow or split-header payload) back
+	 * buffer2. Legacy cores have no set_sec_addr op, so buffer2 is
+	 * never handed to the hardware there.
+	 */
+	return priv->hw->desc && priv->hw->desc->set_sec_addr;
+}
+
 /**
  * stmmac_init_rx_buffers - init the RX descriptor buffer.
  * @priv: driver private structure
@@ -1462,16 +1472,13 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv,
 		buf->page_offset = stmmac_rx_offset(priv);
 	}
 
-	if (priv->sph_active && !buf->sec_page) {
+	if (stmmac_rx_check_buf2_cap(priv) && !buf->sec_page) {
 		buf->sec_page = page_pool_alloc_pages(rx_q->page_pool, gfp);
 		if (!buf->sec_page)
 			return -ENOMEM;
 
 		buf->sec_addr = page_pool_get_dma_addr(buf->sec_page);
 		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, true);
-	} else {
-		buf->sec_page = NULL;
-		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, false);
 	}
 
 	buf->addr = page_pool_get_dma_addr(buf->page) + buf->page_offset;
@@ -2045,13 +2052,8 @@ static int __alloc_dma_rx_desc_resources(struct stmmac_priv *priv,
 	pp_params.nid = dev_to_node(priv->device);
 	pp_params.dev = priv->device;
 	pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
-	pp_params.offset = stmmac_rx_offset(priv);
-	pp_params.max_len = dma_conf->dma_buf_sz;
-
-	if (priv->sph_active) {
-		pp_params.offset = 0;
-		pp_params.max_len += stmmac_rx_offset(priv);
-	}
+	pp_params.offset = 0;
+	pp_params.max_len = dma_conf->dma_buf_sz + stmmac_rx_offset(priv);
 
 	rx_q->page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(rx_q->page_pool)) {
@@ -4846,7 +4848,7 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 				break;
 		}
 
-		if (priv->sph_active && !buf->sec_page) {
+		if (stmmac_rx_check_buf2_cap(priv) && !buf->sec_page) {
 			buf->sec_page = page_pool_alloc_pages(rx_q->page_pool, gfp);
 			if (!buf->sec_page)
 				break;
@@ -4857,10 +4859,8 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 		buf->addr = page_pool_get_dma_addr(buf->page) + buf->page_offset;
 
 		stmmac_set_desc_addr(priv, p, buf->addr);
-		if (priv->sph_active)
-			stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, true);
-		else
-			stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, false);
+		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr,
+					 stmmac_rx_check_buf2_cap(priv));
 		stmmac_refill_desc3(priv, rx_q, p);
 
 		rx_q->rx_count_frames++;
@@ -4891,7 +4891,9 @@ static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
 	unsigned int plen = 0, hlen = 0;
 	int coe = priv->hw->rx_csum;
 
-	/* Not first descriptor, buffer is always zero */
+	/* Not first descriptor, SPH enabled: buffer1 only carries the
+	 * split header of the first descriptor, so it is zero here.
+	 */
 	if (priv->sph_active && len)
 		return 0;
 
@@ -4902,14 +4904,16 @@ static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
 		return hlen;
 	}
 
-	/* First descriptor, not last descriptor and not split header */
+	/* Not last descriptor and not split header: buffer1 is fully filled */
 	if (status & rx_not_ls)
 		return priv->dma_conf.dma_buf_sz;
 
 	plen = stmmac_get_rx_frame_len(priv, p, coe);
 
-	/* First descriptor and last descriptor and not split header */
-	return min_t(unsigned int, priv->dma_conf.dma_buf_sz, plen);
+	/* Last descriptor and not split header: buffer1 holds the remaining
+	 * bytes of the frame, up to dma_buf_sz
+	 */
+	return min_t(unsigned int, priv->dma_conf.dma_buf_sz, plen - len);
 }
 
 static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
@@ -4919,8 +4923,7 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 	int coe = priv->hw->rx_csum;
 	unsigned int plen = 0;
 
-	/* Not split header, buffer is not available */
-	if (!priv->sph_active)
+	if (!stmmac_rx_check_buf2_cap(priv))
 		return 0;
 
 	/* For GMAC4, when split header is enabled, in some rare cases, the
@@ -4937,14 +4940,15 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 	 * Thus 'plen - len' always gives the correct length of buf2.
 	 */
 
-	/* Not GMAC4 and not last descriptor */
-	if (priv->plat->core_type != DWMAC_CORE_GMAC4 && (status & rx_not_ls))
+	/* Not GMAC4, or non-SPH and not last descriptor */
+	if ((priv->plat->core_type != DWMAC_CORE_GMAC4 || !priv->sph_active) &&
+	    (status & rx_not_ls))
 		return priv->dma_conf.dma_buf_sz;
 
 	/* GMAC4 or last descriptor */
 	plen = stmmac_get_rx_frame_len(priv, p, coe);
 
-	return plen - len;
+	return plen > len ? plen - len : 0;
 }
 
 static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
@@ -5491,6 +5495,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 	unsigned int desc_size;
 	struct sk_buff *skb = NULL;
 	struct stmmac_xdp_buff ctx;
+	bool fcs_stripped = false;
 	int xdp_status = 0;
 	int bufsz;
 
@@ -5592,24 +5597,25 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		len += buf2_len;
 
 		/* ACS is disabled; strip manually. */
-		if (likely(!(status & rx_not_ls))) {
-			if (buf2_len) {
-				buf2_len -= ETH_FCS_LEN;
-				len -= ETH_FCS_LEN;
-			} else if (buf1_len) {
-				buf1_len -= ETH_FCS_LEN;
-				len -= ETH_FCS_LEN;
-			}
-		}
+		if (likely(!(status & rx_not_ls)))
+			len -= ETH_FCS_LEN;
 
 		if (!skb) {
 			unsigned int pre_len, sync_len;
 
+			/* Each frame starts here: reset the FCS handling */
+			fcs_stripped = false;
+
 			dma_sync_single_for_cpu(priv->device, buf->addr,
 						buf1_len, dma_dir);
 			net_prefetch(page_address(buf->page) +
 				     buf->page_offset);
 
+			if (stmmac_xdp_is_enabled(priv) && !buf2_len) {
+				buf1_len -= ETH_FCS_LEN;
+				fcs_stripped = true;
+			}
+
 			xdp_init_buff(&ctx.xdp, bufsz, &rx_q->xdp_rxq);
 			xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
 					 buf->page_offset, buf1_len, true);
@@ -5710,6 +5716,15 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 		/* Got entire packet into SKB. Finish it. */
 
+		/* Remove FCS if needed */
+		if (!fcs_stripped && pskb_trim(skb, len)) {
+			dev_kfree_skb_any(skb);
+			skb = NULL;
+			rx_dropped++;
+			count++;
+			continue;
+		}
+
 		stmmac_get_rx_hwtstamp(priv, p, np, skb);
 
 		if (priv->hw->hw_vlan_en)
-- 
2.53.0



