Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF4554706A;
	Thu, 17 Sep 2026 17:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665098; cv=none; b=U6Q08EzqDjY9U5ghe34tXSjy0+1pG7ouBxkWycTnrr7uCD/4QC8ShTsQJYN2xqJ0imNlbXdDEMCvdRDW5OU+cUPccZKuPH8bfi3XeadJYGdEjwmSKKDaUZ5RZmXNJU5NfsRm01RAIt4auvfVYAsCeHD1/YtEIB3WaJFLEZ3at4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665098; c=relaxed/simple;
	bh=m4qmnZc5g5SIE0Dm8E7mzMResQTpsnln7L//9F+tNzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBrrxCFg/OHXBocPGrPgQUFmEk8BNb7eWPa1s/Bl8wfHk22/UHmSyQyR3mpQ+eKrsZGUtC7wbmn2d/97Ve9d2xupqfGfOjqNTSzsXGRO730ug3wY7AQOGJe7jboZQsh6ZOZZImuZgHCrHT/TYU/YvDzdCPYrLbORio16p35r910=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uA2YiviV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uA2YiviV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157811F000FF;
	Thu, 17 Sep 2026 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665096;
	bh=mxIbIPIBAQ+LMIGnThjD7Y90xLdcwnKQIZYhulrv4WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uA2YiviVY5XT6K7zXHrC+1H91nDgDKNKiwHEWG7+ETIab7yE4HLtSlhbOKaihsL3t
	 bctI6ALzO+mr4iDK1EYMdgBooTywREQJKuq8mtDzIfW37L+3WDyLJHjoysksQwfGHv
	 v522Bd8+O/ktdmUEygBf1U1i/v0uJAg+SLTLZrjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0590/1250] bnxt: fix head underflow on XDP head-grow
Date: Thu, 17 Sep 2026 16:06:25 +0100
Message-ID: <20260917151607.874960444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index e2bceec96932b..ca14bb1dabc5d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -981,6 +981,7 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 		mapping += bp->rx_dma_offset;
 		rx_buf->data = page;
 		rx_buf->data_ptr = page_address(page) + offset + bp->rx_offset;
+		rx_buf->offset = offset;
 	} else {
 		u8 *data = __bnxt_alloc_rx_frag(bp, &mapping, rxr, gfp);
 
@@ -989,6 +990,7 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 
 		rx_buf->data = data;
 		rx_buf->data_ptr = data + bp->rx_offset;
+		rx_buf->offset = 0;
 	}
 	rx_buf->mapping = mapping;
 
@@ -1010,6 +1012,7 @@ void bnxt_reuse_rx_data(struct bnxt_rx_ring_info *rxr, u16 cons, void *data)
 	prod_rx_buf->data_ptr = cons_rx_buf->data_ptr;
 
 	prod_rx_buf->mapping = cons_rx_buf->mapping;
+	prod_rx_buf->offset = cons_rx_buf->offset;
 
 	prod_bd = &rxr->rx_desc_ring[RX_RING(bp, prod)][RX_IDX(prod)];
 	cons_bd = &rxr->rx_desc_ring[RX_RING(bp, cons)][RX_IDX(cons)];
@@ -1145,8 +1148,11 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
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
@@ -1155,13 +1161,13 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
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
index 9d9ad2be3239b..f02508600c1d2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -902,6 +902,7 @@ struct bnxt_sw_rx_bd {
 	void			*data;
 	u8			*data_ptr;
 	dma_addr_t		mapping;
+	unsigned int		offset;
 };
 
 struct bnxt_sw_rx_agg_bd {
-- 
2.53.0



