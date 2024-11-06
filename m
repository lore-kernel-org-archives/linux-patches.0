Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDD11DED58;
	Wed,  6 Nov 2024 12:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895922; cv=none; b=Dk7oitLE2bEKYXVHckxOUF3ohtC6aLOba4cH7EG7YLqZfSq8R3KFP7AkTqK491woAfX0VdffZBwADtMeFNbAJB/ribmrZjd+ovfp8hb1TIHHjWc80KZrTC+5N3+P4fWQShAd28QSFt9pfoBqcj98mvKD/MP/RB4VJVeEt9t1M38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895922; c=relaxed/simple;
	bh=PFqrgztoZvKhNZWiPu4spzZhkfalEhwX2bGIHTIO+KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qf9mltr83USPJxyqjKsrt01jwCCEezHyjEqbxAiDaFruMFGeCfLahvRDv3RTno7o+dUmM26rXDVm01rqUFAqVI92v+BWPio7a80dHUV5B73rn7zetPIbrY4x5poKG1DZOkMeUJrmB34ldn4lBuaD9DF4XZScVxo748Gx+G6ICAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2Z+lsz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2Z+lsz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18318C4CECD;
	Wed,  6 Nov 2024 12:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895921;
	bh=PFqrgztoZvKhNZWiPu4spzZhkfalEhwX2bGIHTIO+KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2Z+lsz+J6SOL848wS01yDeimIdqdRspcX49SUKgGol8JF4lnHG4wjJtzPdobxJ0b
	 kb7vC1s+T9V6GbY7WRW1Kexh5GjP+XBuQEEMOtGCsyo9AeaV8Vy84r2KPlvx75kyE2
	 gdTHYE4rpBE2ZH4+dK+vCI5INzWPXxr9KpNlCZe0=
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
Subject: [PATCH 6.11 029/245] net: stmmac: TSO: Fix unbalanced DMA map/unmap for non-paged SKB data
Date: Wed,  6 Nov 2024 13:01:22 +0100
Message-ID: <20241106120319.947727365@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f3a1b179aaeac..02368917efb4a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4330,11 +4330,6 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (dma_mapping_error(priv->device, des))
 		goto dma_map_err;
 
-	tx_q->tx_skbuff_dma[first_entry].buf = des;
-	tx_q->tx_skbuff_dma[first_entry].len = skb_headlen(skb);
-	tx_q->tx_skbuff_dma[first_entry].map_as_page = false;
-	tx_q->tx_skbuff_dma[first_entry].buf_type = STMMAC_TXBUF_T_SKB;
-
 	if (priv->dma_cap.addr64 <= 32) {
 		first->des0 = cpu_to_le32(des);
 
@@ -4353,6 +4348,23 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
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



