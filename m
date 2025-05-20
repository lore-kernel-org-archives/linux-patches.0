Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2451D8E07;
	Tue, 20 May 2025 14:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749780; cv=none; b=tC6JbTB5gvn5lmSQhARW5xfOUzUWE51lTEnv7/JnEralchCz1g3Ulu5pWHomzwSR7jazR3Jw9Bpb68z0ARzpz+kCdgUFacs4ye1VxYRxTobCM4RR3Ei38H3eHUJ6HZ0eGx2vVn8FdJP17tULFjhXA/CK7aYiCqUKCQrpjHhp7fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749780; c=relaxed/simple;
	bh=exlffXgTo03ahXQ95k3d5ZgYaqgtd6NXx3UJRvhZZJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LW0MhrG9yl/SvXt9jJaOYw1vsP2jCeNKl7ccHSsOFi+Wm56WAjJ5Y6Vhn9jzw9VO88SWefcRPvYI/5s4/meZJyx9WlXNlFyszsS3pUztYoc4m/GQQtml6Df/SnymIrfpwRRLmCwGdHaSN1+60eoAPzkBfcCJayWhw2UhXnSb32c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAPG4YdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAPG4YdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C90C4CEE9;
	Tue, 20 May 2025 14:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749779;
	bh=exlffXgTo03ahXQ95k3d5ZgYaqgtd6NXx3UJRvhZZJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAPG4YdKiHBTNjKnEOp4q1mrsY1HKbMs38FH8KIwOZp7zwTUYC/nWro3VLWsk+Czh
	 7bCqHdJ6lCfouHpuTlu0Kg00krkXzAX70SZWzI/krfzW2ImvP8P78YwQozJlfSZNIo
	 jpQuM7XUmA9re8y3J37GNVNfmmAFxegIamAF0VNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/117] tsnep: Inline small fragments within TX descriptor
Date: Tue, 20 May 2025 15:50:23 +0200
Message-ID: <20250520125806.287568804@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit dccce1d7c04051bc25d3abbe7716d0ae7af9c28a ]

The tsnep network controller is able to extend the descriptor directly
with data to be transmitted. In this case no TX data DMA address is
necessary. Instead of the TX data DMA address the TX data buffer is
placed at the end of the descriptor.

The descriptor is read with a 64 bytes DMA read by the tsnep network
controller. If the sum of descriptor data and TX data is less than or
equal to 64 bytes, then no additional DMA read is necessary to read the
TX data. Therefore, it makes sense to inline small fragments up to this
limit within the descriptor ring.

Inlined fragments need to be copied to the descriptor ring. On the other
hand DMA mapping is not necessary. At most 40 bytes are copied, so
copying should be faster than DMA mapping.

For A53 1.2 GHz copying takes <100ns and DMA mapping takes >200ns. So
inlining small fragments should result in lower CPU load. Performance
improvement is small. Thus, comparision of CPU load with and without
inlining of small fragments did not show any significant difference.
With this optimization less DMA reads will be done, which decreases the
load of the interconnect.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b3ca9eef6646 ("tsnep: fix timestamping with a stacked DSA driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep_hw.h   |   2 +
 drivers/net/ethernet/engleder/tsnep_main.c | 103 +++++++++++++++------
 2 files changed, 79 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_hw.h b/drivers/net/ethernet/engleder/tsnep_hw.h
index 55e1caf193a69..64c97eb66f671 100644
--- a/drivers/net/ethernet/engleder/tsnep_hw.h
+++ b/drivers/net/ethernet/engleder/tsnep_hw.h
@@ -181,6 +181,8 @@ struct tsnep_gcl_operation {
 #define TSNEP_DESC_SIZE 256
 #define TSNEP_DESC_SIZE_DATA_AFTER 2048
 #define TSNEP_DESC_OFFSET 128
+#define TSNEP_DESC_SIZE_DATA_AFTER_INLINE (64 - sizeof(struct tsnep_tx_desc) + \
+					   sizeof_field(struct tsnep_tx_desc, tx))
 #define TSNEP_DESC_OWNER_COUNTER_MASK 0xC0000000
 #define TSNEP_DESC_OWNER_COUNTER_SHIFT 30
 #define TSNEP_DESC_LENGTH_MASK 0x00003FFF
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 4f36b29d66c86..d8711e1511e47 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -51,12 +51,22 @@
 #define TSNEP_COALESCE_USECS_MAX     ((ECM_INT_DELAY_MASK >> ECM_INT_DELAY_SHIFT) * \
 				      ECM_INT_DELAY_BASE_US + ECM_INT_DELAY_BASE_US - 1)
 
-#define TSNEP_TX_TYPE_SKB	BIT(0)
-#define TSNEP_TX_TYPE_SKB_FRAG	BIT(1)
-#define TSNEP_TX_TYPE_XDP_TX	BIT(2)
-#define TSNEP_TX_TYPE_XDP_NDO	BIT(3)
-#define TSNEP_TX_TYPE_XDP	(TSNEP_TX_TYPE_XDP_TX | TSNEP_TX_TYPE_XDP_NDO)
-#define TSNEP_TX_TYPE_XSK	BIT(4)
+/* mapping type */
+#define TSNEP_TX_TYPE_MAP		BIT(0)
+#define TSNEP_TX_TYPE_MAP_PAGE		BIT(1)
+#define TSNEP_TX_TYPE_INLINE		BIT(2)
+/* buffer type */
+#define TSNEP_TX_TYPE_SKB		BIT(8)
+#define TSNEP_TX_TYPE_SKB_MAP		(TSNEP_TX_TYPE_SKB | TSNEP_TX_TYPE_MAP)
+#define TSNEP_TX_TYPE_SKB_INLINE	(TSNEP_TX_TYPE_SKB | TSNEP_TX_TYPE_INLINE)
+#define TSNEP_TX_TYPE_SKB_FRAG		BIT(9)
+#define TSNEP_TX_TYPE_SKB_FRAG_MAP_PAGE	(TSNEP_TX_TYPE_SKB_FRAG | TSNEP_TX_TYPE_MAP_PAGE)
+#define TSNEP_TX_TYPE_SKB_FRAG_INLINE	(TSNEP_TX_TYPE_SKB_FRAG | TSNEP_TX_TYPE_INLINE)
+#define TSNEP_TX_TYPE_XDP_TX		BIT(10)
+#define TSNEP_TX_TYPE_XDP_NDO		BIT(11)
+#define TSNEP_TX_TYPE_XDP_NDO_MAP_PAGE	(TSNEP_TX_TYPE_XDP_NDO | TSNEP_TX_TYPE_MAP_PAGE)
+#define TSNEP_TX_TYPE_XDP		(TSNEP_TX_TYPE_XDP_TX | TSNEP_TX_TYPE_XDP_NDO)
+#define TSNEP_TX_TYPE_XSK		BIT(12)
 
 #define TSNEP_XDP_TX		BIT(0)
 #define TSNEP_XDP_REDIRECT	BIT(1)
@@ -416,6 +426,8 @@ static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
 		entry->properties |= TSNEP_TX_DESC_OWNER_USER_FLAG;
 	entry->desc->more_properties =
 		__cpu_to_le32(entry->len & TSNEP_DESC_LENGTH_MASK);
+	if (entry->type & TSNEP_TX_TYPE_INLINE)
+		entry->properties |= TSNEP_TX_DESC_DATA_AFTER_DESC_FLAG;
 
 	/* descriptor properties shall be written last, because valid data is
 	 * signaled there
@@ -433,39 +445,79 @@ static int tsnep_tx_desc_available(struct tsnep_tx *tx)
 		return tx->read - tx->write - 1;
 }
 
+static int tsnep_tx_map_frag(skb_frag_t *frag, struct tsnep_tx_entry *entry,
+			     struct device *dmadev, dma_addr_t *dma)
+{
+	unsigned int len;
+	int mapped;
+
+	len = skb_frag_size(frag);
+	if (likely(len > TSNEP_DESC_SIZE_DATA_AFTER_INLINE)) {
+		*dma = skb_frag_dma_map(dmadev, frag, 0, len, DMA_TO_DEVICE);
+		if (dma_mapping_error(dmadev, *dma))
+			return -ENOMEM;
+		entry->type = TSNEP_TX_TYPE_SKB_FRAG_MAP_PAGE;
+		mapped = 1;
+	} else {
+		void *fragdata = skb_frag_address_safe(frag);
+
+		if (likely(fragdata)) {
+			memcpy(&entry->desc->tx, fragdata, len);
+		} else {
+			struct page *page = skb_frag_page(frag);
+
+			fragdata = kmap_local_page(page);
+			memcpy(&entry->desc->tx, fragdata + skb_frag_off(frag),
+			       len);
+			kunmap_local(fragdata);
+		}
+		entry->type = TSNEP_TX_TYPE_SKB_FRAG_INLINE;
+		mapped = 0;
+	}
+
+	return mapped;
+}
+
 static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
 {
 	struct device *dmadev = tx->adapter->dmadev;
 	struct tsnep_tx_entry *entry;
 	unsigned int len;
-	dma_addr_t dma;
 	int map_len = 0;
-	int i;
+	dma_addr_t dma;
+	int i, mapped;
 
 	for (i = 0; i < count; i++) {
 		entry = &tx->entry[(tx->write + i) & TSNEP_RING_MASK];
 
 		if (!i) {
 			len = skb_headlen(skb);
-			dma = dma_map_single(dmadev, skb->data, len,
-					     DMA_TO_DEVICE);
-
-			entry->type = TSNEP_TX_TYPE_SKB;
+			if (likely(len > TSNEP_DESC_SIZE_DATA_AFTER_INLINE)) {
+				dma = dma_map_single(dmadev, skb->data, len,
+						     DMA_TO_DEVICE);
+				if (dma_mapping_error(dmadev, dma))
+					return -ENOMEM;
+				entry->type = TSNEP_TX_TYPE_SKB_MAP;
+				mapped = 1;
+			} else {
+				memcpy(&entry->desc->tx, skb->data, len);
+				entry->type = TSNEP_TX_TYPE_SKB_INLINE;
+				mapped = 0;
+			}
 		} else {
-			len = skb_frag_size(&skb_shinfo(skb)->frags[i - 1]);
-			dma = skb_frag_dma_map(dmadev,
-					       &skb_shinfo(skb)->frags[i - 1],
-					       0, len, DMA_TO_DEVICE);
+			skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
-			entry->type = TSNEP_TX_TYPE_SKB_FRAG;
+			len = skb_frag_size(frag);
+			mapped = tsnep_tx_map_frag(frag, entry, dmadev, &dma);
+			if (mapped < 0)
+				return mapped;
 		}
-		if (dma_mapping_error(dmadev, dma))
-			return -ENOMEM;
 
 		entry->len = len;
-		dma_unmap_addr_set(entry, dma, dma);
-
-		entry->desc->tx = __cpu_to_le64(dma);
+		if (likely(mapped)) {
+			dma_unmap_addr_set(entry, dma, dma);
+			entry->desc->tx = __cpu_to_le64(dma);
+		}
 
 		map_len += len;
 	}
@@ -484,13 +536,12 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
 		entry = &tx->entry[(index + i) & TSNEP_RING_MASK];
 
 		if (entry->len) {
-			if (entry->type & TSNEP_TX_TYPE_SKB)
+			if (entry->type & TSNEP_TX_TYPE_MAP)
 				dma_unmap_single(dmadev,
 						 dma_unmap_addr(entry, dma),
 						 dma_unmap_len(entry, len),
 						 DMA_TO_DEVICE);
-			else if (entry->type &
-				 (TSNEP_TX_TYPE_SKB_FRAG | TSNEP_TX_TYPE_XDP_NDO))
+			else if (entry->type & TSNEP_TX_TYPE_MAP_PAGE)
 				dma_unmap_page(dmadev,
 					       dma_unmap_addr(entry, dma),
 					       dma_unmap_len(entry, len),
@@ -586,7 +637,7 @@ static int tsnep_xdp_tx_map(struct xdp_frame *xdpf, struct tsnep_tx *tx,
 			if (dma_mapping_error(dmadev, dma))
 				return -ENOMEM;
 
-			entry->type = TSNEP_TX_TYPE_XDP_NDO;
+			entry->type = TSNEP_TX_TYPE_XDP_NDO_MAP_PAGE;
 		} else {
 			page = unlikely(frag) ? skb_frag_page(frag) :
 						virt_to_page(xdpf->data);
-- 
2.39.5



