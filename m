Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0DD370ACE;
	Sat, 17 Oct 2026 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252578; cv=none; b=OZhEgzYqAaISJstAz5s5tcJns2j/O875srtq83FJG3D1BOHdtdg5izPc23Y5dz1YEHuYCBmyczFr+XU6S2nxbGugypSzy1LKR6DHEo/6+kbmsMf5iuhYQROLTW7LuziM3mqJsRdb+5bX0YA6UB0g40CtX3EliRz2JGRjlO0Wvts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252578; c=relaxed/simple;
	bh=ip/39hTnBN+htPLvH1SIk8I0l0EK+34xCIIcbNGSNEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJFJrpg4Kx+FYos3BcJq/4xhmq89SZ0efx084TuxVIEwo54DadKtmVc3QdMOmkDqZzSgOdulEIel06ZNGlNIGZds24RwjxOj7/YfEFC5FZq1mf9ONcl4Gopl0GQRVE/evP3zi1heEPrVRj71BvWFi+SF6ukjnjO9ftHdebuCw+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhUvFbEC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhUvFbEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C911F000C4;
	Sat, 17 Oct 2026 15:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252577;
	bh=yWIsDw0OB3ts5FM5tjssPXmYaY0xaGvWTlAZ1KZSX8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BhUvFbECnBiVYiRGnAuTl1IDpQU+MkETcfRwrRI47Xg4BGdgYj499QfFIriifC+5M
	 ro1/8KrUkLfrq+M8wo0WAZ7UPfGTV/eqIKITbv3u2XGpNFOx15gZATjn8n66wKXJOh
	 kcsBbwq9XoyOAbJF+/7Pu8Lv3FfcVSaukyIfP4FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 19/52] net: mana: reserve RX buffer headroom to fix forwarding performance
Date: Sat, 17 Oct 2026 17:54:20 +0200
Message-ID: <20261017155105.477328445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>

[ Upstream commit 259c4a519100e9182f264f8009ee212b32774277 ]

Commit 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers
instead of full pages to improve memory efficiency.") started handing
out RX buffers with zero headroom so that two buffers fit into one page
at the default MTU.

The MANA TX path, however, stores the per scatter-gather entry DMA
mappings in `struct mana_skb_head` at skb->head, and mana_start_xmit()
therefore calls skb_cow_head(skb, MANA_HEADROOM). The port advertises
this requirement as ndev->needed_headroom = MANA_HEADROOM.

As a result every packet that is received and then forwarded out of a
MANA port fails the skb_cow() in ip_forward() and gets reallocated and
copied by pskb_expand_head(). This is invisible to a plain RX or TX
workload, but it puts a full skb reallocation plus memcpy on the hot
path of every single forwarded packet, which is exactly what a
router/NVA workload does.

Restore the headroom. Note that reserving MANA_HEADROOM (232) is not
enough: ip_forward() asks for LL_RESERVED_SPACE(dev), which rounds
hard_header_len + needed_headroom up to HH_DATA_MOD and is 256 bytes on
ethernet. Use LL_RESERVED_SPACE() directly so the value keeps tracking
both constants. Also, since LL_RESERVED_SPACE() tracks MANA_HEADROOM,
it grows with MAX_SKB_FRAGS and for MAX_SKB_FRAGS >= 19 it is greater
than 256, so we have to account for that by using the headroom the RX
queue actually uses (instead of assuming XDP_PACKET_HEADROOM) and
turning MANA_XDP_MTU_MAX into MANA_XDP_MTU_MAX(ndev) (note that at the
default CONFIG_MAX_SKB_FRAGS=17 they are equivalent).

At the default MTU on a 4K page this means a buffer no longer fits twice
into a page (SKB_DATA_ALIGN(1500 + MANA_RXBUF_PAD + 256) = 2112), so the
frag-vs-single decision is now made by computing the real buffer size
instead of comparing the MTU against PAGE_SIZE / 2. The page_pool
fragment path is still used wherever at least two buffers genuinely fit,
e.g. on 16K and 64K page sizes.

Measured on an Azure VM with a MANA NIC acting as a forwarding NVA (UDP,
1400 byte payload, 4 streams, 8 Gbps offered, only the forwarding
node's kernel differs), 8 runs each, median:

                  forwarded pps    throughput
  before              272,830       3.06 Gbps
  after               390,560       4.37 Gbps   (+43%)

perf on the forwarding node, same workload:

                  memset_orig   __pi_memcpy   pskb_expand_head
  before             10.07%         3.96%         present
  after               0.94%         0.64%         gone

Cc: stable@vger.kernel.org
Fixes: 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers instead of full pages to improve memory efficiency.")
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261003013647.2051416-1-hamzamahfooz@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Kept headroom and buffer-sizing calculations in mana_get_rxbuf_cfg() because full-page RX flag support is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microsoft/mana/mana_bpf.c    |  8 +++---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 26 +++++++++----------
 include/net/mana/mana.h                       |  4 ++-
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 7bb8382940b38..caf77991a54e9 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -91,7 +91,7 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 		goto out;
 
 	xdp_init_buff(xdp, PAGE_SIZE, &rxq->xdp_rxq);
-	xdp_prepare_buff(xdp, buf_va, XDP_PACKET_HEADROOM, pkt_len, true);
+	xdp_prepare_buff(xdp, buf_va, rxq->headroom, pkt_len, true);
 
 	act = bpf_prog_run_xdp(prog, xdp);
 
@@ -183,9 +183,9 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 	if (!old_prog && !prog)
 		return 0;
 
-	if (prog && ndev->mtu > MANA_XDP_MTU_MAX) {
+	if (prog && ndev->mtu > MANA_XDP_MTU_MAX(ndev)) {
 		netdev_err(ndev, "XDP: mtu:%u too large, mtu_max:%lu\n",
-			   ndev->mtu, MANA_XDP_MTU_MAX);
+			   ndev->mtu, MANA_XDP_MTU_MAX(ndev));
 		NL_SET_ERR_MSG_MOD(extack, "XDP: mtu too large");
 
 		return -EOPNOTSUPP;
@@ -238,7 +238,7 @@ static int mana_xdp_set(struct net_device *ndev, struct bpf_prog *prog,
 		bpf_prog_put(old_prog);
 
 	if (prog)
-		ndev->max_mtu = MANA_XDP_MTU_MAX;
+		ndev->max_mtu = MANA_XDP_MTU_MAX(ndev);
 	else
 		ndev->max_mtu = gc->adapter_mtu - ETH_HLEN;
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 5cbe24a1596c8..befeb20fb7d59 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -749,7 +749,7 @@ static void *mana_get_rxbuf_pre(struct mana_rxq *rxq, dma_addr_t *da)
 	return va;
 }
 
-/* Get RX buffer's data size, alloc size, XDP headroom based on MTU */
+/* Get RX buffer's data size, alloc size, headroom and frag count based on MTU */
 static void mana_get_rxbuf_cfg(struct mana_port_context *apc,
 			       int mtu, u32 *datasize, u32 *alloc_size,
 			       u32 *headroom, u32 *frag_count)
@@ -759,16 +759,20 @@ static void mana_get_rxbuf_cfg(struct mana_port_context *apc,
 	/* Calculate datasize first (consistent across all cases) */
 	*datasize = mtu + ETH_HLEN;
 
-	/* For xdp and jumbo frames make sure only one packet fits per page */
-	if (mtu + MANA_RXBUF_PAD > PAGE_SIZE / 2 || mana_xdp_get(apc)) {
-		if (mana_xdp_get(apc)) {
-			*headroom = XDP_PACKET_HEADROOM;
+	*headroom = LL_RESERVED_SPACE(apc->ndev);
+	if (mana_xdp_get(apc))
+		*headroom = max_t(u32, *headroom, XDP_PACKET_HEADROOM);
+
+	len = SKB_DATA_ALIGN(mtu + MANA_RXBUF_PAD + *headroom);
+	buf_size = ALIGN(len, MANA_RX_FRAG_ALIGNMENT);
+
+	/* For xdp and large buffers make sure only one packet fits per page */
+	if (PAGE_SIZE / buf_size < 2 || mana_xdp_get(apc)) {
+		if (mana_xdp_get(apc))
 			*alloc_size = PAGE_SIZE;
-		} else {
-			*headroom = 0; /* no support for XDP */
+		else
 			*alloc_size = SKB_DATA_ALIGN(mtu + MANA_RXBUF_PAD +
 						     *headroom);
-		}
 
 		*frag_count = 1;
 
@@ -782,12 +786,6 @@ static void mana_get_rxbuf_cfg(struct mana_port_context *apc,
 	}
 
 	/* Standard MTU case - optimize for multiple packets per page */
-	*headroom = 0;
-
-	/* Calculate base buffer size needed */
-	len = SKB_DATA_ALIGN(mtu + MANA_RXBUF_PAD + *headroom);
-	buf_size = ALIGN(len, MANA_RX_FRAG_ALIGNMENT);
-
 	/* Calculate how many packets can fit in a page */
 	*frag_count = PAGE_SIZE / buf_size;
 	*alloc_size = buf_size;
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index a134b12352797..f03438a4b1dbd 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -325,7 +325,9 @@ struct mana_recv_buf_oob {
 #define MANA_RXBUF_PAD (SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) \
 			+ ETH_HLEN)
 
-#define MANA_XDP_MTU_MAX (PAGE_SIZE - MANA_RXBUF_PAD - XDP_PACKET_HEADROOM)
+#define MANA_XDP_MTU_MAX(ndev) \
+	(PAGE_SIZE - MANA_RXBUF_PAD - \
+	 max_t(u32, LL_RESERVED_SPACE(ndev), XDP_PACKET_HEADROOM))
 
 struct mana_rxq {
 	struct gdma_queue *gdma_rq;
-- 
2.53.0



