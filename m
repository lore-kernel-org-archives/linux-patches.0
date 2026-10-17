Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113AD397929;
	Sat, 17 Oct 2026 16:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254521; cv=none; b=DHUZ2g1/IRjLJ3qEJhdCfA0LfENi2MeIvQOOMMS72AWKgEy0/ReHeCaWuiV27U9tXlHToZ9QVmpIXXuPsHbIqvEgljpm2YJFHVxKiIJQW+GVim1pfcGyPkOpi3S5G0q2ZF8EWmmVlI4U/J65sLiIlrcVrdD3NTTQuVZ0HIBwiVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254521; c=relaxed/simple;
	bh=GRKwUiT99NwwRn97Li4qtVkzCrj5VRqT7yNHh91xHy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIPAo7EdfDB0nkg4UGd05cMMzxDWNIJ6es7tnsPk4KcjDKHvZhukSnDrxSjyW4TqlYHLh1RmalPu4hCacg3hFAtSSpByW7FFWSDgehCsvMRPN9D998XBxe2oByaXjAe3f0qovpTeM0VJtNHJ9ZF+b9962L1K1O5xFizEfUfRH+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kP0zBulw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kP0zBulw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D891F000C4;
	Sat, 17 Oct 2026 16:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254519;
	bh=wdKItl2vzDTAuMG7tMDdA7+KQ5up0qe6sGw3yeb60NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kP0zBulw+k2eA3JfpXZr8U6j0Sk+6RJ32hXIT28Nkbh6x9Qt6LYXwvGtrRBW8REjJ
	 Q+tc8T131aY0jpf2zma12ObmT3EpjDJSWfcrZkdAWfSNbBeHM+r4wqWkYIW3HL5yV0
	 2CEya/DFgpwlkq5UkYhcQLRDPpEdsnjWXXtQD6Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 467/869] bnxt: fix head underflow on XDP head-grow
Date: Sat, 17 Oct 2026 17:55:08 +0200
Message-ID: <20261017160049.103404272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4749119180c4b..497799b089ce2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -924,6 +924,7 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 		mapping += bp->rx_dma_offset;
 		rx_buf->data = page;
 		rx_buf->data_ptr = page_address(page) + offset + bp->rx_offset;
+		rx_buf->offset = offset;
 	} else {
 		u8 *data = __bnxt_alloc_rx_frag(bp, &mapping, rxr, gfp);
 
@@ -932,6 +933,7 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 
 		rx_buf->data = data;
 		rx_buf->data_ptr = data + bp->rx_offset;
+		rx_buf->offset = 0;
 	}
 	rx_buf->mapping = mapping;
 
@@ -953,6 +955,7 @@ void bnxt_reuse_rx_data(struct bnxt_rx_ring_info *rxr, u16 cons, void *data)
 	prod_rx_buf->data_ptr = cons_rx_buf->data_ptr;
 
 	prod_rx_buf->mapping = cons_rx_buf->mapping;
+	prod_rx_buf->offset = cons_rx_buf->offset;
 
 	prod_bd = &rxr->rx_desc_ring[RX_RING(bp, prod)][RX_IDX(prod)];
 	cons_bd = &rxr->rx_desc_ring[RX_RING(bp, cons)][RX_IDX(cons)];
@@ -1090,8 +1093,11 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
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
@@ -1100,13 +1106,13 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
 	dma_addr -= bp->rx_dma_offset;
 	dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, rxr->rx_page_size,
 				bp->rx_dir);
-	skb = napi_build_skb(data_ptr - bp->rx_offset, rxr->rx_page_size);
+	skb = napi_build_skb(frag_start, rxr->rx_page_size);
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
index 105945aa3ffcc..1c094dd2ad25e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -894,6 +894,7 @@ struct bnxt_sw_rx_bd {
 	void			*data;
 	u8			*data_ptr;
 	dma_addr_t		mapping;
+	unsigned int		offset;
 };
 
 struct bnxt_sw_rx_agg_bd {
-- 
2.53.0



