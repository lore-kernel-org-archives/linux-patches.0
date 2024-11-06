Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C8E1E25F8;
	Wed,  6 Nov 2024 12:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896968; cv=none; b=liUVOSAXL9cBupFKantEFa3oA8IhvsU0LvAUoJWxwkcsiEljxk2dIOAkI/UosKC/mepzw306ii93Ku7wdXSiLNLClbMzBJyJDEgIEcC6hOAVk8imTCcsCYrnVxVtVaQN1y1lW5abXwDLUtlszv3FZXPTAApBDA5XyXP1b3yTO0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896968; c=relaxed/simple;
	bh=HS6+UJ4aHwUjwZE9j/9tAMsV1BfBDJAbNnlSH/hvnng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKcfJCtILicfG5pJ7CIvoyk1gTaTG8vmG66GYMa99JxFZilTuIO9jx6lBdWdIGsVSnt2gzHIoGV4FoOEXveVR2m/uSjvYxdoYlW4dhe6bhWhuC9jkcvsR8s/H+OuWdfz+atCRpmv4uYYrGbphmOKTypUwIufXAACLZGBR62OBbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=st2LfaJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="st2LfaJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEBDC4CED4;
	Wed,  6 Nov 2024 12:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896968;
	bh=HS6+UJ4aHwUjwZE9j/9tAMsV1BfBDJAbNnlSH/hvnng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=st2LfaJ9/tIdOcnytRMVzujWf686uFFhehj3YHzNAU0NWCvYDqUWj2HJOakwoS21v
	 NrAGM72qd6DvS5+SFK225qwleeoOtnfXAoMm1VhkGY5V9vPAU3KqFe7TqJDELiCnic
	 MmuB/iru02ovjwA+Ek2x8NGtE7t3CrMpAU3NR/UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Jaiswal <quic_jsuraj@quicinc.com>,
	Furong Xu <0x1207@gmail.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/126] net: stmmac: TSO: Fix unbalanced DMA map/unmap for non-paged SKB data
Date: Wed,  6 Nov 2024 13:03:43 +0100
Message-ID: <20241106120306.695722994@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Furong Xu <0x1207@gmail.com>

[ Upstream commit 66600fac7a984dea4ae095411f644770b2561ede ]

In case the non-paged data of a SKB carries protocol header and protocol
payload to be transmitted on a certain platform that the DMA AXI address
width is configured to 40-bit/48-bit, or the size of the non-paged data
is bigger than TSO_MAX_BUFF_SIZE on a certain platform that the DMA AXI
address width is configured to 32-bit, then this SKB requires at least
two DMA transmit descriptors to serve it.

For example, three descriptors are allocated to split one DMA buffer
mapped from one piece of non-paged data:
    dma_desc[N + 0],
    dma_desc[N + 1],
    dma_desc[N + 2].
Then three elements of tx_q->tx_skbuff_dma[] will be allocated to hold
extra information to be reused in stmmac_tx_clean():
    tx_q->tx_skbuff_dma[N + 0],
    tx_q->tx_skbuff_dma[N + 1],
    tx_q->tx_skbuff_dma[N + 2].
Now we focus on tx_q->tx_skbuff_dma[entry].buf, which is the DMA buffer
address returned by DMA mapping call. stmmac_tx_clean() will try to
unmap the DMA buffer _ONLY_IF_ tx_q->tx_skbuff_dma[entry].buf
is a valid buffer address.

The expected behavior that saves DMA buffer address of this non-paged
data to tx_q->tx_skbuff_dma[entry].buf is:
    tx_q->tx_skbuff_dma[N + 0].buf = NULL;
    tx_q->tx_skbuff_dma[N + 1].buf = NULL;
    tx_q->tx_skbuff_dma[N + 2].buf = dma_map_single();
Unfortunately, the current code misbehaves like this:
    tx_q->tx_skbuff_dma[N + 0].buf = dma_map_single();
    tx_q->tx_skbuff_dma[N + 1].buf = NULL;
    tx_q->tx_skbuff_dma[N + 2].buf = NULL;

On the stmmac_tx_clean() side, when dma_desc[N + 0] is closed by the
DMA engine, tx_q->tx_skbuff_dma[N + 0].buf is a valid buffer address
obviously, then the DMA buffer will be unmapped immediately.
There may be a rare case that the DMA engine does not finish the
pending dma_desc[N + 1], dma_desc[N + 2] yet. Now things will go
horribly wrong, DMA is going to access a unmapped/unreferenced memory
region, corrupted data will be transmited or iommu fault will be
triggered :(

In contrast, the for-loop that maps SKB fragments behaves perfectly
as expected, and that is how the driver should do for both non-paged
data and paged frags actually.

This patch corrects DMA map/unmap sequences by fixing the array index
for tx_q->tx_skbuff_dma[entry].buf when assigning DMA buffer address.

Tested and verified on DWXGMAC CORE 3.20a

Reported-by: Suraj Jaiswal <quic_jsuraj@quicinc.com>
Fixes: f748be531d70 ("stmmac: support new GMAC4")
Signed-off-by: Furong Xu <0x1207@gmail.com>
Reviewed-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241021061023.2162701-1-0x1207@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 22 ++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 93630840309e7..045e57c444fd7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4183,11 +4183,6 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (dma_mapping_error(priv->device, des))
 		goto dma_map_err;
 
-	tx_q->tx_skbuff_dma[first_entry].buf = des;
-	tx_q->tx_skbuff_dma[first_entry].len = skb_headlen(skb);
-	tx_q->tx_skbuff_dma[first_entry].map_as_page = false;
-	tx_q->tx_skbuff_dma[first_entry].buf_type = STMMAC_TXBUF_T_SKB;
-
 	if (priv->dma_cap.addr64 <= 32) {
 		first->des0 = cpu_to_le32(des);
 
@@ -4206,6 +4201,23 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	stmmac_tso_allocator(priv, des, tmp_pay_len, (nfrags == 0), queue);
 
+	/* In case two or more DMA transmit descriptors are allocated for this
+	 * non-paged SKB data, the DMA buffer address should be saved to
+	 * tx_q->tx_skbuff_dma[].buf corresponding to the last descriptor,
+	 * and leave the other tx_q->tx_skbuff_dma[].buf as NULL to guarantee
+	 * that stmmac_tx_clean() does not unmap the entire DMA buffer too early
+	 * since the tail areas of the DMA buffer can be accessed by DMA engine
+	 * sooner or later.
+	 * By saving the DMA buffer address to tx_q->tx_skbuff_dma[].buf
+	 * corresponding to the last descriptor, stmmac_tx_clean() will unmap
+	 * this DMA buffer right after the DMA engine completely finishes the
+	 * full buffer transmission.
+	 */
+	tx_q->tx_skbuff_dma[tx_q->cur_tx].buf = des;
+	tx_q->tx_skbuff_dma[tx_q->cur_tx].len = skb_headlen(skb);
+	tx_q->tx_skbuff_dma[tx_q->cur_tx].map_as_page = false;
+	tx_q->tx_skbuff_dma[tx_q->cur_tx].buf_type = STMMAC_TXBUF_T_SKB;
+
 	/* Prepare fragments */
 	for (i = 0; i < nfrags; i++) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-- 
2.43.0



