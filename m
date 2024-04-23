Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A5214388A;
	Tue, 23 Apr 2024 21:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908481; cv=none; b=adz2sh5Z326D6yK2LfgRgqVfKJj7CYaIwN5UIe9g2N081EcuR5Kq26vhK33dEu2n52M52qJS8Bctat1gNKyF4Oquy5Is6JXf3zKfM0YnBBTJDSQCu895g3bdxVLoqEvadvPJlaTDq+9OlewVgLM+281JJFwr5AX61OI6zgwnbjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908481; c=relaxed/simple;
	bh=y+Z+XwPFoAnP8Db4Qh7ARj0I/vWPkr991sGcPSTz7pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pdk6De+GWBN7Rks1q5rMF8gKtpfUztOWqvuQzyHf9AcdEe0R9Y0tBIXkVhPtQLFScB+CL9jriZiDe0FYtGPZbrWn9xwrLzu6yDw8AA35oSa+V2WuRkwizxv9fPzVO8MEM0lcAEELS+L60X12kngMfRjI6QzFscl4clRj+fx2ogs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TfrXPOmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TfrXPOmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF45DC3277B;
	Tue, 23 Apr 2024 21:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908480;
	bh=y+Z+XwPFoAnP8Db4Qh7ARj0I/vWPkr991sGcPSTz7pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfrXPOmQV5PpPAP6eRJUjkVkT4kDHHs/HBgYqghH1hY35ihlHuY15l0EC54XCKViO
	 ZZXL/XMmly3QpfVmJH2+nifpF7y9y18BAxucGM/CmMqzuqzGnIibEBZQa8dbSZHTb9
	 LZBd3V9W78S8VDvx54jIPO0XPAl8kkVtLqG2dq/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 050/158] ravb: Group descriptor types used in Rx ring
Date: Tue, 23 Apr 2024 14:37:52 -0700
Message-ID: <20240423213857.537678352@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 4123c3fbf8632e5c553222bf1c10b3a3e0a8dc06 ]

The Rx ring can either be made up of normal or extended descriptors, not
a mix of the two at the same time. Make this explicit by grouping the
two variables in a rx_ring union.

The extension of the storage for more than one queue of normal
descriptors from a single to NUM_RX_QUEUE queues have no practical
effect. But aids in making the code readable as the code that uses it
already piggyback on other members of struct ravb_private that are
arrays of max length NUM_RX_QUEUE, e.g. rx_desc_dma. This will also make
further refactoring easier.

While at it, rename the normal descriptor Rx ring to make it clear it's
not strictly related to the GbEthernet E-MAC IP found in RZ/G2L, normal
descriptors could be used on R-Car SoCs too.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: def52db470df ("net: ravb: Count packets instead of descriptors in R-Car RX path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb.h      |  6 ++-
 drivers/net/ethernet/renesas/ravb_main.c | 57 ++++++++++++------------
 2 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index e0f8276cffedd..fd59155a70e1f 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1060,8 +1060,10 @@ struct ravb_private {
 	struct ravb_desc *desc_bat;
 	dma_addr_t rx_desc_dma[NUM_RX_QUEUE];
 	dma_addr_t tx_desc_dma[NUM_TX_QUEUE];
-	struct ravb_rx_desc *gbeth_rx_ring;
-	struct ravb_ex_rx_desc *rx_ring[NUM_RX_QUEUE];
+	union {
+		struct ravb_rx_desc *desc;
+		struct ravb_ex_rx_desc *ex_desc;
+	} rx_ring[NUM_RX_QUEUE];
 	struct ravb_tx_desc *tx_ring[NUM_TX_QUEUE];
 	void *tx_align[NUM_TX_QUEUE];
 	struct sk_buff *rx_1st_skb;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 1bdf0abb256cf..e97c98d5eb19c 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -250,11 +250,11 @@ static void ravb_rx_ring_free_gbeth(struct net_device *ndev, int q)
 	unsigned int ring_size;
 	unsigned int i;
 
-	if (!priv->gbeth_rx_ring)
+	if (!priv->rx_ring[q].desc)
 		return;
 
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
-		struct ravb_rx_desc *desc = &priv->gbeth_rx_ring[i];
+		struct ravb_rx_desc *desc = &priv->rx_ring[q].desc[i];
 
 		if (!dma_mapping_error(ndev->dev.parent,
 				       le32_to_cpu(desc->dptr)))
@@ -264,9 +264,9 @@ static void ravb_rx_ring_free_gbeth(struct net_device *ndev, int q)
 					 DMA_FROM_DEVICE);
 	}
 	ring_size = sizeof(struct ravb_rx_desc) * (priv->num_rx_ring[q] + 1);
-	dma_free_coherent(ndev->dev.parent, ring_size, priv->gbeth_rx_ring,
+	dma_free_coherent(ndev->dev.parent, ring_size, priv->rx_ring[q].desc,
 			  priv->rx_desc_dma[q]);
-	priv->gbeth_rx_ring = NULL;
+	priv->rx_ring[q].desc = NULL;
 }
 
 static void ravb_rx_ring_free_rcar(struct net_device *ndev, int q)
@@ -275,11 +275,11 @@ static void ravb_rx_ring_free_rcar(struct net_device *ndev, int q)
 	unsigned int ring_size;
 	unsigned int i;
 
-	if (!priv->rx_ring[q])
+	if (!priv->rx_ring[q].ex_desc)
 		return;
 
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
-		struct ravb_ex_rx_desc *desc = &priv->rx_ring[q][i];
+		struct ravb_ex_rx_desc *desc = &priv->rx_ring[q].ex_desc[i];
 
 		if (!dma_mapping_error(ndev->dev.parent,
 				       le32_to_cpu(desc->dptr)))
@@ -290,9 +290,9 @@ static void ravb_rx_ring_free_rcar(struct net_device *ndev, int q)
 	}
 	ring_size = sizeof(struct ravb_ex_rx_desc) *
 		    (priv->num_rx_ring[q] + 1);
-	dma_free_coherent(ndev->dev.parent, ring_size, priv->rx_ring[q],
+	dma_free_coherent(ndev->dev.parent, ring_size, priv->rx_ring[q].ex_desc,
 			  priv->rx_desc_dma[q]);
-	priv->rx_ring[q] = NULL;
+	priv->rx_ring[q].ex_desc = NULL;
 }
 
 /* Free skb's and DMA buffers for Ethernet AVB */
@@ -344,11 +344,11 @@ static void ravb_rx_ring_format_gbeth(struct net_device *ndev, int q)
 	unsigned int i;
 
 	rx_ring_size = sizeof(*rx_desc) * priv->num_rx_ring[q];
-	memset(priv->gbeth_rx_ring, 0, rx_ring_size);
+	memset(priv->rx_ring[q].desc, 0, rx_ring_size);
 	/* Build RX ring buffer */
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
 		/* RX descriptor */
-		rx_desc = &priv->gbeth_rx_ring[i];
+		rx_desc = &priv->rx_ring[q].desc[i];
 		rx_desc->ds_cc = cpu_to_le16(GBETH_RX_DESC_DATA_SIZE);
 		dma_addr = dma_map_single(ndev->dev.parent, priv->rx_skb[q][i]->data,
 					  GBETH_RX_BUFF_MAX,
@@ -361,7 +361,7 @@ static void ravb_rx_ring_format_gbeth(struct net_device *ndev, int q)
 		rx_desc->dptr = cpu_to_le32(dma_addr);
 		rx_desc->die_dt = DT_FEMPTY;
 	}
-	rx_desc = &priv->gbeth_rx_ring[i];
+	rx_desc = &priv->rx_ring[q].desc[i];
 	rx_desc->dptr = cpu_to_le32((u32)priv->rx_desc_dma[q]);
 	rx_desc->die_dt = DT_LINKFIX; /* type */
 }
@@ -374,11 +374,11 @@ static void ravb_rx_ring_format_rcar(struct net_device *ndev, int q)
 	dma_addr_t dma_addr;
 	unsigned int i;
 
-	memset(priv->rx_ring[q], 0, rx_ring_size);
+	memset(priv->rx_ring[q].ex_desc, 0, rx_ring_size);
 	/* Build RX ring buffer */
 	for (i = 0; i < priv->num_rx_ring[q]; i++) {
 		/* RX descriptor */
-		rx_desc = &priv->rx_ring[q][i];
+		rx_desc = &priv->rx_ring[q].ex_desc[i];
 		rx_desc->ds_cc = cpu_to_le16(RX_BUF_SZ);
 		dma_addr = dma_map_single(ndev->dev.parent, priv->rx_skb[q][i]->data,
 					  RX_BUF_SZ,
@@ -391,7 +391,7 @@ static void ravb_rx_ring_format_rcar(struct net_device *ndev, int q)
 		rx_desc->dptr = cpu_to_le32(dma_addr);
 		rx_desc->die_dt = DT_FEMPTY;
 	}
-	rx_desc = &priv->rx_ring[q][i];
+	rx_desc = &priv->rx_ring[q].ex_desc[i];
 	rx_desc->dptr = cpu_to_le32((u32)priv->rx_desc_dma[q]);
 	rx_desc->die_dt = DT_LINKFIX; /* type */
 }
@@ -446,10 +446,10 @@ static void *ravb_alloc_rx_desc_gbeth(struct net_device *ndev, int q)
 
 	ring_size = sizeof(struct ravb_rx_desc) * (priv->num_rx_ring[q] + 1);
 
-	priv->gbeth_rx_ring = dma_alloc_coherent(ndev->dev.parent, ring_size,
-						 &priv->rx_desc_dma[q],
-						 GFP_KERNEL);
-	return priv->gbeth_rx_ring;
+	priv->rx_ring[q].desc = dma_alloc_coherent(ndev->dev.parent, ring_size,
+						   &priv->rx_desc_dma[q],
+						   GFP_KERNEL);
+	return priv->rx_ring[q].desc;
 }
 
 static void *ravb_alloc_rx_desc_rcar(struct net_device *ndev, int q)
@@ -459,10 +459,11 @@ static void *ravb_alloc_rx_desc_rcar(struct net_device *ndev, int q)
 
 	ring_size = sizeof(struct ravb_ex_rx_desc) * (priv->num_rx_ring[q] + 1);
 
-	priv->rx_ring[q] = dma_alloc_coherent(ndev->dev.parent, ring_size,
-					      &priv->rx_desc_dma[q],
-					      GFP_KERNEL);
-	return priv->rx_ring[q];
+	priv->rx_ring[q].ex_desc = dma_alloc_coherent(ndev->dev.parent,
+						      ring_size,
+						      &priv->rx_desc_dma[q],
+						      GFP_KERNEL);
+	return priv->rx_ring[q].ex_desc;
 }
 
 /* Init skb and descriptor buffer for Ethernet AVB */
@@ -784,7 +785,7 @@ static bool ravb_rx_gbeth(struct net_device *ndev, int *quota, int q)
 	limit = priv->dirty_rx[q] + priv->num_rx_ring[q] - priv->cur_rx[q];
 	stats = &priv->stats[q];
 
-	desc = &priv->gbeth_rx_ring[entry];
+	desc = &priv->rx_ring[q].desc[entry];
 	for (i = 0; i < limit && rx_packets < *quota && desc->die_dt != DT_FEMPTY; i++) {
 		/* Descriptor type must be checked before all other reads */
 		dma_rmb();
@@ -851,13 +852,13 @@ static bool ravb_rx_gbeth(struct net_device *ndev, int *quota, int q)
 		}
 
 		entry = (++priv->cur_rx[q]) % priv->num_rx_ring[q];
-		desc = &priv->gbeth_rx_ring[entry];
+		desc = &priv->rx_ring[q].desc[entry];
 	}
 
 	/* Refill the RX ring buffers. */
 	for (; priv->cur_rx[q] - priv->dirty_rx[q] > 0; priv->dirty_rx[q]++) {
 		entry = priv->dirty_rx[q] % priv->num_rx_ring[q];
-		desc = &priv->gbeth_rx_ring[entry];
+		desc = &priv->rx_ring[q].desc[entry];
 		desc->ds_cc = cpu_to_le16(GBETH_RX_DESC_DATA_SIZE);
 
 		if (!priv->rx_skb[q][entry]) {
@@ -907,7 +908,7 @@ static bool ravb_rx_rcar(struct net_device *ndev, int *quota, int q)
 
 	boguscnt = min(boguscnt, *quota);
 	limit = boguscnt;
-	desc = &priv->rx_ring[q][entry];
+	desc = &priv->rx_ring[q].ex_desc[entry];
 	while (desc->die_dt != DT_FEMPTY) {
 		/* Descriptor type must be checked before all other reads */
 		dma_rmb();
@@ -967,13 +968,13 @@ static bool ravb_rx_rcar(struct net_device *ndev, int *quota, int q)
 		}
 
 		entry = (++priv->cur_rx[q]) % priv->num_rx_ring[q];
-		desc = &priv->rx_ring[q][entry];
+		desc = &priv->rx_ring[q].ex_desc[entry];
 	}
 
 	/* Refill the RX ring buffers. */
 	for (; priv->cur_rx[q] - priv->dirty_rx[q] > 0; priv->dirty_rx[q]++) {
 		entry = priv->dirty_rx[q] % priv->num_rx_ring[q];
-		desc = &priv->rx_ring[q][entry];
+		desc = &priv->rx_ring[q].ex_desc[entry];
 		desc->ds_cc = cpu_to_le16(RX_BUF_SZ);
 
 		if (!priv->rx_skb[q][entry]) {
-- 
2.43.0



