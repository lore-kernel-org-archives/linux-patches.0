Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619201;
	b=pIF6+rUr6vlOO4jPzo8Rtg0d9HQsyEbIpYUt/m7NyC2QS9Ta/zAf8PYit6VTLlFJBzdD
	 0FSB5V66PzNjeJ0OoWKYRMCU3c3q90NW+Hd+MxC4SYtfCDdMsP10eDC4+XylHV3ApD0BN
	 CKh/YzWBh3DcJeljieFFX4dnSaZq+/2JzuxU5I74Kt5X5KG2zGEdrdXHIoC8UTh+sPUoy
	 TqViFP8k78GOd+3Jj1lgMczLOqoli1nZEtRhlgIwuLmNO/KGBlFsZ2uIGfYRwcirTPmYy
	 apHAbl7upBI133TEYncsx75VV6a2kyiGWsx6qIRm99VFQE3t0QI0CJtgbD/KkvsWC0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zIjGoKqQa+8MY+n1pREUlTeK9SPSb6VKYq6G63bv7qc=;
	b=RxcnhLLb+Tl3S+eXeHC8cKO65vCgRc7y+5ANA/JVG1WmbrrKSmw9Z7PXWTH2LN53D8tk
	 RFwtVSvTyM0xX0cuEUFKNzxMojGdCV15StP2xZYgGgQNbPInMKWNeuMHGB7zby0Qcsw9i
	 VoJeZ9O2RnS5uFl3lg3zVyd6cJqg975UxF+JqjWp6bIW2rrKuctW/PANGY4Pd2TkIKdSD
	 H8wwG08ZsUbtD6mluF6xhxHJxbwrnzRv9O77n4nPiJb0DcbOW+eOVGPG2oso9749LWpgy
	 SnJ/AEiNDjrXdCSp5aXdFRx6ZbuMMwbnDH+M5Y7dfYdSnv+EbmEn2q7xuNTn7icE7xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvC3qHkC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B74A606A321;
	Wed, 25 Nov 2026 15:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvC3qHkC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E251F0089F;
	Wed, 25 Nov 2026 15:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619201;
	bh=zIjGoKqQa+8MY+n1pREUlTeK9SPSb6VKYq6G63bv7qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SvC3qHkCcoNMUIicvUsgVRd5Ofcl2nP7xRbud8oLBy7As1TM4UFvO2sD5fMLnzJCV
	 eYhiimOcGxCv4swR9qENemKtNpMmfBK/AJHXp1wSxwQnhMc3g7jF0EJ8P91rm2YTOz
	 NlaKZW5aaCnaR06RDe8u3YYFtCSWj7yFb9SW8bIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0522/1005] net: ena: Keep the RX buffer mapped if skb allocation fails
Date: Wed, 25 Nov 2026 15:31:00 +0100
Message-ID: <20261125143833.973521016@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7eb6456ed0d55..15e5cfeb0abe7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1009,6 +1009,10 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 
 	buf_len = SKB_DATA_ALIGN(len + buf_offset + tailroom);
 
+	skb = ena_alloc_skb(rx_ring, buf_addr, buf_len);
+	if (unlikely(!skb))
+		return NULL;
+
 	/* If XDP isn't loaded try to reuse part of the RX buffer */
 	reuse_rx_buf_page = !is_xdp_loaded &&
 			    ena_try_rx_buf_page_reuse(rx_info, buf_len, len, pkt_offset);
@@ -1016,10 +1020,6 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
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



