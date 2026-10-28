Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215555;
	b=WtooqcPjj8X3F8hxSbY02nKhcjOt2m039SANKHmPUHkEp8rWWC6iaSb7dZCtlR//+3AU
	 C1klrAvlc6Au331BbNwVtthoN/CZsm2R9xL0kXwbHE5zkmkly0uUAax6NNpFHvLbZy37S
	 nWZU4wm81s/tS5VVnDUPc87pJKNn6bY5unFbtlvcPdSk2MGS/kc21doykrxNIX5yD6xED
	 /lRvdj9ypC6mk6KaeSBo9H3gT5Q2lVG1nk+wwuUq/LiU5I0DeWkFyc3q1SDF49YYrGjbo
	 vutIuqZNNX70/e02O1PY+oqgVrPp9WixuivN383FHzet7GeldXVg+DPqzug7HqyHw3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YWwUQBB5xp6A+18ISPYvqvKvckPxujic6LDSVbBQH7o=;
	b=u6Mbjj2DqUgfRl4dBYOb+6/ugubj8iBn+qKURqwWYuqt8PYsJr8oNtEVwZBc52Ct+RiZ
	 NLFLntt7fkAZ17W2JsDNjXnkpz8bu5Phmijxf9D6uW6kxHoFcAkZcHq7GpmB+Leth64L7
	 cl3Hw/Yns2gxxoD0FON2QFArrgUi3pTko4KlEe5/VBxgHE2N9XEKmf2v7OtEmizAjZcsq
	 2aQntTHgCfBlDXujrHBM/tCeOZgd2AfFl1dmqZm/y8os9u8ElPG3t3OXzTH8c8W9sSPbD
	 paqnX1nOSFOtxeo8aC24erfO/QNPFEz32FB/WZzwwdtmhzOTDzZdilglBomzvC5JbRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+TGdHff;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD36606A31E;
	Wed, 28 Oct 2026 19:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+TGdHff
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFDF1F01825;
	Wed, 28 Oct 2026 19:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215555;
	bh=YWwUQBB5xp6A+18ISPYvqvKvckPxujic6LDSVbBQH7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+TGdHff7GyBsGY0pB+ozrAdF2rC+9ba0kWG2dHe4V8Qmig0IgFYOwD8tSJo2pUEC
	 W6nLvGIFVvPoXwErcmc9sFpeYLdMund/M9UPoHycvkuhZvu6o3RYhfayqHXX07q/Dq
	 iuu3Aex5ZcQjc83F4dyZL9JAQnuHRI+CblmarxBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1251/1887] bnxt: fix head underflow on XDP head-grow
Date: Wed, 28 Oct 2026 17:55:47 +0100
Message-ID: <20261028170527.893065131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <joe@dama.to>

[ Upstream commit e26657fe3b85c068b01f42bb0c602f242d643ba9 ]

The xdp.py test test_xdp_native_adjst_head_grow_data crashes when run on
a bnxt machine (and also crashes in NIPA).

It seems that the bug is an underflow in bnxt_rx_multi_page_skb, which
builds the skb head:

  napi_build_skb(data_ptr - bp->rx_offset, rxr->rx_page_size);

The problem with this expression is that in page mode, rx_offset is:

  bp->rx_offset = NET_IP_ALIGN + XDP_PACKET_HEADROOM;

Which evaluates (at least on x86_64) to 258.

The test test_xdp_native_adjst_head_grow_data tests a case where the
head is adjusted by -256.

When this test runs, data_ptr is shifted to frag_start + 2 (where
frag_start = page_address(page) + offset).

Then, bnxt_rx_multi_page_skb is invoked and the napi_build_skb
expression subtracts 258, landing at an address before frag_start. This
could be either the previous fragment or the previous physical page when
the offset is < 256 (e.g. if the fragment started at offset 0).

When the skb is freed, the page pool fragment reference is dropped on
either the wrong page or the wrong frag of the right page. In either
case, the corrupted reference count can lead to the page being
prematurely recycled while still in use. Once (incorrectly) recycled, it
can be handed out again and on driver teardown this would result in a
double free.

The commit under fixes updated this code to handle the case where the
native page size is >= 64k, but it unintentionally broke the head grow
case.

To fix this, add an offset field to struct bnxt_sw_rx_bd, mirroring the
existing offset field in struct bnxt_sw_rx_agg_bd. Populate it on
allocation and preserve it on reuse.

In bnxt_rx_multi_page_skb, use the newly added offset field to compute
the fragment start and pass that to napi_build_skb. Adjust the layout
with skb_reserve.

There are two cases, the non-adjustment case and the adjustment case.

In both cases, the skb is built at page_address(page) + offset to
account for the case where the native page size >= 64K and skb_reserve
is called with data_ptr - (page_address(page) + offset). That
difference equals bp->rx_offset when data_ptr was not moved, or
bp->rx_offset + xdp_adjust when XDP adjusted the head.

Re-running the failing test with this commit applied causes the test to
run successfully to completion.

The other rx_skb_func implementations don't have this issue.

Fixes: f6974b4c2d8e ("bnxt_en: Fix page pool logic for page size >= 64K")
Signed-off-by: Joe Damato <joe@dama.to>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260609204458.2237787-2-joe@dama.to
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 ++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7da32225cc165..7328697c016ca 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -816,6 +816,7 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 		mapping += bp->rx_dma_offset;
 		rx_buf->data = page;
 		rx_buf->data_ptr = page_address(page) + offset + bp->rx_offset;
+		rx_buf->offset = offset;
 	} else {
 		u8 *data = __bnxt_alloc_rx_frag(bp, &mapping, gfp);
 
@@ -824,6 +825,7 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 
 		rx_buf->data = data;
 		rx_buf->data_ptr = data + bp->rx_offset;
+		rx_buf->offset = 0;
 	}
 	rx_buf->mapping = mapping;
 
@@ -844,6 +846,7 @@ void bnxt_reuse_rx_data(struct bnxt_rx_ring_info *rxr, u16 cons, void *data)
 	prod_rx_buf->data_ptr = cons_rx_buf->data_ptr;
 
 	prod_rx_buf->mapping = cons_rx_buf->mapping;
+	prod_rx_buf->offset = cons_rx_buf->offset;
 
 	prod_bd = &rxr->rx_desc_ring[RX_RING(prod)][RX_IDX(prod)];
 	cons_bd = &rxr->rx_desc_ring[RX_RING(cons)][RX_IDX(cons)];
@@ -1014,8 +1017,11 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
 	struct page *page = data;
 	u16 prod = rxr->rx_prod;
 	struct sk_buff *skb;
+	void *frag_start;
 	int err;
 
+	frag_start = page_address(page) + rxr->rx_buf_ring[cons].offset;
+
 	err = bnxt_alloc_rx_data(bp, rxr, prod, GFP_ATOMIC);
 	if (unlikely(err)) {
 		bnxt_reuse_rx_data(rxr, cons, data);
@@ -1024,13 +1030,13 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
 	dma_addr -= bp->rx_dma_offset;
 	dma_unmap_page_attrs(&bp->pdev->dev, dma_addr, BNXT_RX_PAGE_SIZE,
 			     bp->rx_dir, DMA_ATTR_WEAK_ORDERING);
-	skb = build_skb(data_ptr - bp->rx_offset, BNXT_RX_PAGE_SIZE);
+	skb = build_skb(frag_start, BNXT_RX_PAGE_SIZE);
 	if (!skb) {
 		page_pool_recycle_direct(rxr->page_pool, page);
 		return NULL;
 	}
 	skb_mark_for_recycle(skb);
-	skb_reserve(skb, bp->rx_offset);
+	skb_reserve(skb, data_ptr - (u8 *)frag_start);
 	__skb_put(skb, len);
 
 	return skb;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 006987d3caa1a..86d8d837fb10f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -728,6 +728,7 @@ struct bnxt_sw_rx_bd {
 	void			*data;
 	u8			*data_ptr;
 	dma_addr_t		mapping;
+	unsigned int		offset;
 };
 
 struct bnxt_sw_rx_agg_bd {
-- 
2.53.0



