Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460D31DF74F;
	Tue,  8 Jul 2025 16:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992045; cv=none; b=LMS4uCmZxuKGkH6jBqAKZW5f21+eT/9NTx2CGwDGj3p2AlepCz2bem9DYW4VJ8lII+tCD9oS4Cc31MmxdWsuOq0jx0WOgwYib1tpH/ko3U3w/oUMXJEb+66pNePsIo3mzHNTqe4/OCDPjrE0UhbPcJ1HPTvakmqLX6W41CIHsfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992045; c=relaxed/simple;
	bh=tK+VUVA+gbuOVTUr6jielqtG2ci9Srz0V+m0DiJyeRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1481mi66p8Otj0tIqKPduU44Y583zuiB0sCIrbQA0btji2mxzffpeSu61Clo7OIBIXqlBHmMknAsjl4i+mKriEjzOjZaTlowan8nLoY7dgL4BvYPgr+Bpcze41KQmHHIBzcUlUMzEJ/7YXUI8l9xwkWGkX+vh/X7/hBJMWpsLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+Ptw+ps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+Ptw+ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710BAC4CEED;
	Tue,  8 Jul 2025 16:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992044;
	bh=tK+VUVA+gbuOVTUr6jielqtG2ci9Srz0V+m0DiJyeRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+Ptw+pspCiQgvW1ofQ/NJKVFcPpbatLc6uhN4ZLJAwePn8EbYe1l4ExHGE7iBs6Q
	 9CUnfJ/LxrQZv7pCaUq7FYDsWAldJ8c/iJAkFfKsSMFBuCZ+wyTgHeo6yw9fEKk/2Y
	 Mi8N2sVWfEVgIhwBznltJeGxbmyQNnDtxNYIkNUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 41/81] nui: Fix dma_mapping_error() check
Date: Tue,  8 Jul 2025 18:23:33 +0200
Message-ID: <20250708162226.300274851@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 561aa0e22b70a5e7246b73d62a824b3aef3fc375 ]

dma_map_XXX() functions return values DMA_MAPPING_ERROR as error values
which is often ~0.  The error value should be tested with
dma_mapping_error().

This patch creates a new function in niu_ops to test if the mapping
failed.  The test is fixed in niu_rbr_add_page(), added in
niu_start_xmit() and the successfully mapped pages are unmaped upon error.

Fixes: ec2deec1f352 ("niu: Fix to check for dma mapping errors.")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/niu.c | 31 ++++++++++++++++++++++++++++++-
 drivers/net/ethernet/sun/niu.h |  4 ++++
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 4bbf011d53e69..2b38cb4fdaeb8 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3336,7 +3336,7 @@ static int niu_rbr_add_page(struct niu *np, struct rx_ring_info *rp,
 
 	addr = np->ops->map_page(np->device, page, 0,
 				 PAGE_SIZE, DMA_FROM_DEVICE);
-	if (!addr) {
+	if (np->ops->mapping_error(np->device, addr)) {
 		__free_page(page);
 		return -ENOMEM;
 	}
@@ -6672,6 +6672,8 @@ static netdev_tx_t niu_start_xmit(struct sk_buff *skb,
 	len = skb_headlen(skb);
 	mapping = np->ops->map_single(np->device, skb->data,
 				      len, DMA_TO_DEVICE);
+	if (np->ops->mapping_error(np->device, mapping))
+		goto out_drop;
 
 	prod = rp->prod;
 
@@ -6713,6 +6715,8 @@ static netdev_tx_t niu_start_xmit(struct sk_buff *skb,
 		mapping = np->ops->map_page(np->device, skb_frag_page(frag),
 					    skb_frag_off(frag), len,
 					    DMA_TO_DEVICE);
+		if (np->ops->mapping_error(np->device, mapping))
+			goto out_unmap;
 
 		rp->tx_buffs[prod].skb = NULL;
 		rp->tx_buffs[prod].mapping = mapping;
@@ -6737,6 +6741,19 @@ static netdev_tx_t niu_start_xmit(struct sk_buff *skb,
 out:
 	return NETDEV_TX_OK;
 
+out_unmap:
+	while (i--) {
+		const skb_frag_t *frag;
+
+		prod = PREVIOUS_TX(rp, prod);
+		frag = &skb_shinfo(skb)->frags[i];
+		np->ops->unmap_page(np->device, rp->tx_buffs[prod].mapping,
+				    skb_frag_size(frag), DMA_TO_DEVICE);
+	}
+
+	np->ops->unmap_single(np->device, rp->tx_buffs[rp->prod].mapping,
+			      skb_headlen(skb), DMA_TO_DEVICE);
+
 out_drop:
 	rp->tx_errors++;
 	kfree_skb(skb);
@@ -9636,6 +9653,11 @@ static void niu_pci_unmap_single(struct device *dev, u64 dma_address,
 	dma_unmap_single(dev, dma_address, size, direction);
 }
 
+static int niu_pci_mapping_error(struct device *dev, u64 addr)
+{
+	return dma_mapping_error(dev, addr);
+}
+
 static const struct niu_ops niu_pci_ops = {
 	.alloc_coherent	= niu_pci_alloc_coherent,
 	.free_coherent	= niu_pci_free_coherent,
@@ -9643,6 +9665,7 @@ static const struct niu_ops niu_pci_ops = {
 	.unmap_page	= niu_pci_unmap_page,
 	.map_single	= niu_pci_map_single,
 	.unmap_single	= niu_pci_unmap_single,
+	.mapping_error	= niu_pci_mapping_error,
 };
 
 static void niu_driver_version(void)
@@ -10009,6 +10032,11 @@ static void niu_phys_unmap_single(struct device *dev, u64 dma_address,
 	/* Nothing to do.  */
 }
 
+static int niu_phys_mapping_error(struct device *dev, u64 dma_address)
+{
+	return false;
+}
+
 static const struct niu_ops niu_phys_ops = {
 	.alloc_coherent	= niu_phys_alloc_coherent,
 	.free_coherent	= niu_phys_free_coherent,
@@ -10016,6 +10044,7 @@ static const struct niu_ops niu_phys_ops = {
 	.unmap_page	= niu_phys_unmap_page,
 	.map_single	= niu_phys_map_single,
 	.unmap_single	= niu_phys_unmap_single,
+	.mapping_error	= niu_phys_mapping_error,
 };
 
 static int niu_of_probe(struct platform_device *op)
diff --git a/drivers/net/ethernet/sun/niu.h b/drivers/net/ethernet/sun/niu.h
index 04c215f91fc08..0b169c08b0f2d 100644
--- a/drivers/net/ethernet/sun/niu.h
+++ b/drivers/net/ethernet/sun/niu.h
@@ -2879,6 +2879,9 @@ struct tx_ring_info {
 #define NEXT_TX(tp, index) \
 	(((index) + 1) < (tp)->pending ? ((index) + 1) : 0)
 
+#define PREVIOUS_TX(tp, index) \
+	(((index) - 1) >= 0 ? ((index) - 1) : (((tp)->pending) - 1))
+
 static inline u32 niu_tx_avail(struct tx_ring_info *tp)
 {
 	return (tp->pending -
@@ -3140,6 +3143,7 @@ struct niu_ops {
 			  enum dma_data_direction direction);
 	void (*unmap_single)(struct device *dev, u64 dma_address,
 			     size_t size, enum dma_data_direction direction);
+	int (*mapping_error)(struct device *dev, u64 dma_address);
 };
 
 struct niu_link_config {
-- 
2.39.5



