Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621168;
	b=2Ht4CACxlfFkRxuN78uDCcmw5ovsB4WVQk2hJ3ZdqzX4jyg2KF2ZTs54UlvbzT6p6HV4
	 QM2Cu7LxkPCtczdTLXnUjx2jepM3nObMbRVocas2xD/iGKNzBcPpDOc7M4R/j/QPaPs0T
	 lq0I/xkZtPES17Uvm99F4qzG0NRSAN5XQP1WqIKp3oq7tvo2FDadny9mAvWwQmF+i7Uu/
	 Zsqf+7W+cYl29op33D0+kQ4atl7Pvos8fjtzt3wB4fhqLqjL7Cezn5+ANQ9nlh0rAWaRa
	 hs04qHJKVK+/D2KZ/KEUFG22fRxvCGb1Yp1COF9H6VlB7l3y/eiLeJvkIuq7S8KF17A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aVY4TMBUnhLgCx+TgIk+tQpT9jD735rZc4QECHz/IH0=;
	b=FsC1IX4CicQQy60D1YWP5XugLKD+/g/fL5p5eFOnEHQB9ou3Z8Y+qEQ6RMGJ8GkDlqyI
	 0AAXM3zWknsGZnxW14vnLvVkajKRJn2jEGnnPul3JlSlLiIktWl6X7QzZSwh2gFhNor7G
	 RTXjyGL3ikOBVVXW1U4XNG32SI1tu3OyJjKmzAKQn/EAedshQ2mPVqaFTk8UW7mJDw9jN
	 Uoj2dlf6pk4kvP16WRcs5BRqS8kNUIqmKPFi7+JhNTVnurH+PfdcSfvL53CVtns3kAGO1
	 Ez9jNTgAALnMlygGrloVQT8nA0iyVFYq8qKJJnLyGVx3n2Lb+29nGaQlTeCVuFS50xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HLlQ7r5w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3AE606A31E;
	Wed, 25 Nov 2026 15:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HLlQ7r5w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4868B1F000C6;
	Wed, 25 Nov 2026 15:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621167;
	bh=aVY4TMBUnhLgCx+TgIk+tQpT9jD735rZc4QECHz/IH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HLlQ7r5wAF9Qz4UxPuvGoQYXdyYBTFKxWiehoRAJKVDFl8RJSBSSVNJUtCFtgryI8
	 LnUwFgj8Grib+gg6wZLWQE8CZVIlVeet/dwKFR4fg/yul77WNGZyr/nwLx2m1GLUuJ
	 paOmn8oKFuxqNgQdWOGr3s799kdQXEnlfHIOXBVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 142/990] net: stmmac: fix XDP RX buffer DMA sync length
Date: Wed, 25 Nov 2026 15:25:09 +0100
Message-ID: <20261125143825.411362908@linuxfoundation.org>
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

[ Upstream commit 363ff816277d4c7064514b160e655bed1dfb3ed8 ]

stmmac_rx() bounded the DMA sync length by the largest data_end seen
before and after the XDP program and passed it to page_pool_put_page()
on the XDP_CONSUMED path. bpf_xdp_adjust_tail() zeroes the grown area,
which dirties the CPU cache, but a later negative adjust only moves
data_end back. If the program grows and then shrinks the tail, both
endpoints miss the zeroed range, so those dirty cache lines are not
written back before the page is reused.

The length was also wrong since commit 88095728511e ("net: stmmac: fix
rx Scatter-Gather support") moved the page_pool DMA window to offset 0
and set max_len to dma_buf_sz + page_offset: the driver still
subtracted buf->page_offset, so it synced [base, data_end - page_offset)
instead of [base, data_end).

On a non-coherent platform those dirty lines can be evicted after the
device has DMA'd the next frame into the recycled page and corrupt it.

Sync the whole page_pool DMA window on the XDP_CONSUMED path with
page_pool_recycle_direct(), as the PASS path and page_pool allocation
already do. The device only writes [page_offset, page_offset +
dma_buf_sz), so syncing [base, base + max_len) covers every cache line
it can touch, regardless of how the program adjusted the packet.

Fixes: be8b38a722e6 ("net: stmmac: Add support for XDP_TX action")
Fixes: 88095728511e ("net: stmmac: fix rx Scatter-Gather support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-stmmac-xdp-fixes-v2-6-10eae8a093a8@oss.qualcomm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c   | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 123f2415e745e..2e7b146895ba8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5689,8 +5689,6 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			len -= ETH_FCS_LEN;
 
 		if (!skb) {
-			unsigned int pre_len, sync_len;
-
 			/* Each frame starts here: reset the FCS handling */
 			fcs_stripped = false;
 
@@ -5708,29 +5706,18 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
 					 buf->page_offset, buf1_len, true);
 
-			pre_len = ctx.xdp.data_end - ctx.xdp.data_hard_start -
-				  buf->page_offset;
-
 			ctx.priv = priv;
 			ctx.desc = p;
 			ctx.ndesc = np;
 
 			skb = stmmac_xdp_run_prog(priv, &ctx.xdp);
-			/* Due xdp_adjust_tail: DMA sync for_device
-			 * cover max len CPU touch
-			 */
-			sync_len = ctx.xdp.data_end - ctx.xdp.data_hard_start -
-				   buf->page_offset;
-			sync_len = max(sync_len, pre_len);
-
 			/* For Not XDP_PASS verdict */
 			if (IS_ERR(skb)) {
 				unsigned int xdp_res = -PTR_ERR(skb);
 
 				if (xdp_res & STMMAC_XDP_CONSUMED) {
-					page_pool_put_page(rx_q->page_pool,
-							   virt_to_head_page(ctx.xdp.data),
-							   sync_len, true);
+					page_pool_recycle_direct(rx_q->page_pool,
+								 virt_to_head_page(ctx.xdp.data));
 					buf->page = NULL;
 					rx_dropped++;
 					goto next;
-- 
2.53.0



