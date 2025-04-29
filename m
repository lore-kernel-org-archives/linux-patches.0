Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF312512E8;
	Tue, 29 Apr 2025 16:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945896; cv=none; b=W+xZXBBG1NqAPfw9Yf5FVFVVKn8JCawB/UEz7PsFjoHutx3Q0IGE8VDwMZAxC7XHArJc91hkcIBN1rNEZN1/M2c+xgpL0UNXyszS0tR8FYkpz+L+ttxqvyi74vN05W/JEBRW+VmopWtXSUqXfJGiKLzkc+y2NFh/wUwKa1esxVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945896; c=relaxed/simple;
	bh=ma4wY5pYTEj0UmXrOfJ2XIU4GA7R12fmiMi7i6WchMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PszxBGU2TF2SD3pIeu5X+9t+NkpmS5f/aE07/cC92rbE6qwOw65y+XcC0tWop2AMoVYs6pdhnWi5OR6rrTnza70lSDYazYzShD3y+l9cffdfciV1MSfJ7/nwL+TNs0TYnjpe8g2ivMwqpo2YnH2oTnn7xfU6C2q2Vb5h9YhLBmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ow5pySf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ow5pySf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF782C4CEE9;
	Tue, 29 Apr 2025 16:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945896;
	bh=ma4wY5pYTEj0UmXrOfJ2XIU4GA7R12fmiMi7i6WchMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ow5pySf3UWfJwTL4I36wd7Xo3OeoLUvfSRUOCbpCR/RbnTfEDgbpl6xNbLDpRjyEq
	 3IcC6LYMwamZwHZTofIj0GfzKcc2bAuNSg0vpvKaygwBjQnFGW25bheN8w+7OTB1O2
	 MpA8KjHrmQMlBgCzkqX5yuDDc/iq1eV4gnsRpf4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlatko Markovikj <vlatko.markovikj@etas.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 056/311] net: enetc: fix frame corruption on bpf_xdp_adjust_head/tail() and XDP_PASS
Date: Tue, 29 Apr 2025 18:38:13 +0200
Message-ID: <20250429161123.336066509@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 020f0c8b3d396ec8190948f86063e1c45133f839 ]

Vlatko Markovikj reported that XDP programs attached to ENETC do not
work well if they use bpf_xdp_adjust_head() or bpf_xdp_adjust_tail(),
combined with the XDP_PASS verdict. A typical use case is to add or
remove a VLAN tag.

The resulting sk_buff passed to the stack is corrupted, because the
algorithm used by the driver for XDP_PASS is to unwind the current
buffer pointer in the RX ring and to re-process the current frame with
enetc_build_skb() as if XDP hadn't run. That is incorrect because XDP
may have modified the geometry of the buffer, which we then are
completely unaware of. We are looking at a modified buffer with the
original geometry.

The initial reaction, both from me and from Vlatko, was to shop around
the kernel for code to steal that would calculate a delta between the
old and the new XDP buffer geometry, and apply that to the sk_buff too.
We noticed that veth and generic xdp have such code.

The headroom adjustment is pretty uncontroversial, but what turned out
severely problematic is the tailroom.

veth has this snippet:

		__skb_put(skb, off); /* positive on grow, negative on shrink */

which on first sight looks decent enough, except __skb_put() takes an
"unsigned int" for the second argument, and the arithmetic seems to only
work correctly by coincidence. Second issue, __skb_put() contains a
SKB_LINEAR_ASSERT(). It's not a great pattern to make more widespread.
The skb may still be nonlinear at that point - it only becomes linear
later when resetting skb->data_len to zero.

To avoid the above, bpf_prog_run_generic_xdp() does this instead:

		skb_set_tail_pointer(skb, xdp->data_end - xdp->data);
		skb->len += off; /* positive on grow, negative on shrink */

which is more open-coded, uses lower-level functions and is in general a
bit too much to spread around in driver code.

Then there is the snippet:

	if (xdp_buff_has_frags(xdp))
		skb->data_len = skb_shinfo(skb)->xdp_frags_size;
	else
		skb->data_len = 0;

One would have expected __pskb_trim() to be the function of choice for
this task. But it's not used in veth/xdpgeneric because the extraneous
fragments were _already_ freed by bpf_xdp_adjust_tail() ->
bpf_xdp_frags_shrink_tail() -> ... -> __xdp_return() - the backing
memory for the skb frags and the xdp frags is the same, but they don't
keep individual references.

In fact, that is the biggest reason why this snippet cannot be reused
as-is, because ENETC temporarily constructs an skb with the original len
and the original number of frags. Because the extraneous frags are
already freed by bpf_xdp_adjust_tail() and returned to the page
allocator, it means the entire approach of using enetc_build_skb() is
questionable for XDP_PASS. To avoid that, one would need to elevate the
page refcount of all frags before calling bpf_prog_run_xdp() and drop it
after XDP_PASS.

There are other things that are missing in ENETC's handling of XDP_PASS,
like for example updating skb_shinfo(skb)->meta_len.

These are all handled correctly and cleanly in commit 539c1fba1ac7
("xdp: add generic xdp_build_skb_from_buff()"), added to net-next in
Dec 2024, and in addition might even be quicker that way. I have a very
strong preference towards backporting that commit for "stable", and that
is what is used to fix the handling bugs. It is way too messy to go
this deep into the guts of an sk_buff from the code of a device driver.

Fixes: d1b15102dd16 ("net: enetc: add support for XDP_DROP and XDP_PASS")
Reported-by: Vlatko Markovikj <vlatko.markovikj@etas.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20250417120005.3288549-4-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 26 +++++++++++---------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 74721995cb1f9..3ee52f4b11660 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1878,11 +1878,10 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 
 	while (likely(rx_frm_cnt < work_limit)) {
 		union enetc_rx_bd *rxbd, *orig_rxbd;
-		int orig_i, orig_cleaned_cnt;
 		struct xdp_buff xdp_buff;
 		struct sk_buff *skb;
+		int orig_i, err;
 		u32 bd_status;
-		int err;
 
 		rxbd = enetc_rxbd(rx_ring, i);
 		bd_status = le32_to_cpu(rxbd->r.lstatus);
@@ -1897,7 +1896,6 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 			break;
 
 		orig_rxbd = rxbd;
-		orig_cleaned_cnt = cleaned_cnt;
 		orig_i = i;
 
 		enetc_build_xdp_buff(rx_ring, bd_status, &rxbd, &i,
@@ -1925,15 +1923,21 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 			rx_ring->stats.xdp_drops++;
 			break;
 		case XDP_PASS:
-			rxbd = orig_rxbd;
-			cleaned_cnt = orig_cleaned_cnt;
-			i = orig_i;
-
-			skb = enetc_build_skb(rx_ring, bd_status, &rxbd,
-					      &i, &cleaned_cnt,
-					      ENETC_RXB_DMA_SIZE_XDP);
-			if (unlikely(!skb))
+			skb = xdp_build_skb_from_buff(&xdp_buff);
+			/* Probably under memory pressure, stop NAPI */
+			if (unlikely(!skb)) {
+				enetc_xdp_drop(rx_ring, orig_i, i);
+				rx_ring->stats.xdp_drops++;
 				goto out;
+			}
+
+			enetc_get_offloads(rx_ring, orig_rxbd, skb);
+
+			/* These buffers are about to be owned by the stack.
+			 * Update our buffer cache (the rx_swbd array elements)
+			 * with their other page halves.
+			 */
+			enetc_bulk_flip_buff(rx_ring, orig_i, i);
 
 			napi_gro_receive(napi, skb);
 			break;
-- 
2.39.5



