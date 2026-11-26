Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705317;
	b=HwL5TxwNw4vFvtAX7xSnSpXz3VG+lPFW7prUvb1iixAXhbTG7OvORlxjdQ8tQgv+N1RG
	 ynRdxNA2KmjbjJ6I7gbSNugebfdL0kYiPoy71bqqb3S7cjbDfl4aAI7KX2h2UH2PqYesc
	 D8u7+92zUGWrrX8Tv08g4IimKnaKAMXUomQ1DsRiQ2dSHWdXjK+lGgrI6IS4BpEHIKyrp
	 dngEI7yTru73FaZTJrIDpdfnlJKOdaUtL/SVzC+HRHvh1FA7i1UFriUicbTuV8+3xPs9r
	 ZN4VKv9VZOkmhpmj7JtvXr3thsv+AX08VMh3IBfde/Ts2ABXCDxRWYd6/So/aoxEDuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NJ24W3SRtZuntqW+U3L3D76kyhH6potoCtyFWT6yzCo=;
	b=wjB7mn3V+uNK4BqeYaviKaEd2LUACSt430CD+nK/76oCMqRVlA5bm8Xs/F/91dPtThbj
	 rt47uDNg6RyGTy88L2YQEXtN2dAEFTntT4fdOXjLMUOuZNK4472cXABVz4ov+LWVxvJu8
	 BuwB2maCfow8PePn53DLVxnsAkSprc621y7fOt4GZnIK2hSCZspJCGlGczKyVlqw7FL24
	 N5K10fJvQGaexR/obVl5gFYtPPnDrXkl9ffd4Y09qG9Hz5wwzhJxCHsDjKX9ubbpoOOyi
	 tqSpDJ/Wdkpy48gSuIWMmXFdTpIXdflBvwsQP4CdGOE2njWiRIj6jZDbFsro080X0jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGzE9sYZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD7F606A32A;
	Thu, 26 Nov 2026 15:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGzE9sYZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234641F000C0;
	Thu, 26 Nov 2026 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705316;
	bh=NJ24W3SRtZuntqW+U3L3D76kyhH6potoCtyFWT6yzCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGzE9sYZmIHGzeATz9Pfq8hbGN78mfJkrSJMeJ2OwSqAUrt1TpVy32Oie7n99YK5N
	 m1lQyMRYlf7zm0gz8HpUYh9nmSevjVKb9X/xnYt2I7QgcJzSAtnEWdPz2SxWTC54wB
	 ASaqvTUd0SHt/zx3f2QYyNSpH2DFQdr4ej09aY5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/319] net: ena: Keep the RX buffer mapped if skb allocation fails
Date: Thu, 26 Nov 2026 15:38:44 +0100
Message-ID: <20261126144010.267303873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 3e8e22a1007a6337ba2400b3ea87077947005c20 ]

We are seeing the following issue in production on arm64 EC2 hosts
(m8g.metal-24xl, 64K pages, SMMUv3 in strict mode, 6.18 based kernel).
Right after a global OOM, the SMMU reports F_TRANSLATION write faults
from the ENA device, followed by a burst of:

  WARNING: CPU: 48 PID: 1656834 at drivers/iommu/dma-iommu.c:1242 iommu_dma_unmap_phys+0xf4/0x108
  Call trace:
   iommu_dma_unmap_phys+0xf4/0x108 (P)
   dma_unmap_phys+0x194/0x2a8
   dma_unmap_page_attrs+0x1c/0x38
   ena_io_poll+0x7bc/0x1790 [ena]
   __napi_poll+0x54/0x220
   net_rx_action+0x250/0x520

ena_rx_skb() unmaps the RX buffer, or takes an extra page reference to
reuse it, before napi_build_skb() allocates the skb. If the allocation
fails, it returns NULL with rx_info->page still set. ena_clean_rx_irq()
then puts the req_id back on the free list, and ena_alloc_rx_buffer()
treats the buffer as still mapped and posts its old DMA address to the
device again.

With the IOMMU in strict mode, the device then writes to an unmapped
IOVA, and the next completion of that buffer unmaps it a second time.
If the IOVA was handed to a new mapping in between, the device can
write into that buffer instead. On the reuse path, the extra page
reference is never dropped.

Allocate the skb before touching rx_info, so that a failed allocation
leaves the buffer mapped and unchanged for the refill.

Fixes: 9e5269a915a8 ("net: ena: use build_skb() in RX path")
Fixes: f7d625adeb7b ("net: ena: Add dynamic recycling mechanism for rx buffers")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20261109-ena-rx-skb-alloc-fail-v1-1-aee2927cb51f@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 5831f7bd81c23..999aa8abc3e9a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1525,6 +1525,10 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 
 	buf_len = SKB_DATA_ALIGN(len + buf_offset + tailroom);
 
+	skb = ena_alloc_skb(rx_ring, buf_addr, buf_len);
+	if (unlikely(!skb))
+		return NULL;
+
 	/* If XDP isn't loaded try to reuse part of the RX buffer */
 	reuse_rx_buf_page = !is_xdp_loaded &&
 			    ena_try_rx_buf_page_reuse(rx_info, buf_len, len, pkt_offset);
@@ -1532,10 +1536,6 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 	if (!reuse_rx_buf_page)
 		ena_unmap_rx_buff_attrs(rx_ring, rx_info, DMA_ATTR_SKIP_CPU_SYNC);
 
-	skb = ena_alloc_skb(rx_ring, buf_addr, buf_len);
-	if (unlikely(!skb))
-		return NULL;
-
 	/* Populate skb's linear part */
 	skb_reserve(skb, buf_offset);
 	skb_put(skb, len);
-- 
2.53.0



