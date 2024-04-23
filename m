Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9E9144D3A;
	Tue, 23 Apr 2024 21:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908507; cv=none; b=KN5X7CStim24CPn/AS6fvG29rgbupbJtSDDdoLpMS9mpMLcyJ/RTzdTNRRaBnyQCNBSd1W5nAnC/FPplxUc0fVUdmSkrbaoARvpU2fu6ArMLpJKpSiQOkg4j5haUKmKjGaX+cdBFz/2QfaypuypKcHjOf7XDGJjTAhllh7jHTf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908507; c=relaxed/simple;
	bh=qc9utWjZtW8UIMHMG8EKUV1TxzrI4vQ2FHaC+BJNZjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B153mhnaSsSFKSlR8U6kj75ZfkQeHPHyEbRWSy+2MOFUV5XS4gidxOsr2LPgsPfboYrlfqxGfNdv5m85Z1LF4pq0JAU8dwkmRNmYw0GdmS0304q47IosgklnhYucg6OeOzzoin5PP/zk41cideM1LgEyp7sNo91qC8IY7RSE+B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GY9NcvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GY9NcvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5858CC116B1;
	Tue, 23 Apr 2024 21:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908507;
	bh=qc9utWjZtW8UIMHMG8EKUV1TxzrI4vQ2FHaC+BJNZjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GY9NcvDTIh4hAxj3LCucDQLexzwqHsGXv+f+ACUchln2/G3KCgIdFTTU+kpAmWj+
	 9zHAK3ZpPsvzmBBVCNGaTa2gJVxU9+mGXV+h06zc5bQvuLdTsYNNkH6xM+wGx+nk2i
	 IRPq4OE/eo7gy2BK77G5DLG0+YSChrHOj+RRYqnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 052/158] net: ravb: Allow RX loop to move past DMA mapping errors
Date: Tue, 23 Apr 2024 14:37:54 -0700
Message-ID: <20240423213857.618693899@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Barker <paul.barker.ct@bp.renesas.com>

[ Upstream commit a892493a343494bd6bab9d098593932077ff3c43 ]

The RX loops in ravb_rx_gbeth() and ravb_rx_rcar() skip to the next loop
iteration if a zero-length descriptor is seen (indicating a DMA mapping
error). However, the current RX descriptor index `priv->cur_rx[q]` was
incremented at the end of the loop and so would not be incremented when
we skip to the next loop iteration. This would cause the loop to keep
seeing the same zero-length descriptor instead of moving on to the next
descriptor.

As the loop counter `i` still increments, the loop would eventually
terminate so there is no risk of being stuck here forever - but we
should still fix this to avoid wasting cycles.

To fix this, the RX descriptor index is incremented at the top of the
loop, in the for statement itself. The assignments of `entry` and `desc`
are brought into the loop to avoid the need for duplication.

Fixes: d8b48911fd24 ("ravb: fix ring memory allocation")
Signed-off-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 25 ++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 60c1cfc501304..853c2a0d4e259 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -781,12 +781,15 @@ static bool ravb_rx_gbeth(struct net_device *ndev, int *quota, int q)
 	int limit;
 	int i;
 
-	entry = priv->cur_rx[q] % priv->num_rx_ring[q];
 	limit = priv->dirty_rx[q] + priv->num_rx_ring[q] - priv->cur_rx[q];
 	stats = &priv->stats[q];
 
-	desc = &priv->rx_ring[q].desc[entry];
-	for (i = 0; i < limit && rx_packets < *quota && desc->die_dt != DT_FEMPTY; i++) {
+	for (i = 0; i < limit; i++, priv->cur_rx[q]++) {
+		entry = priv->cur_rx[q] % priv->num_rx_ring[q];
+		desc = &priv->rx_ring[q].desc[entry];
+		if (rx_packets == *quota || desc->die_dt == DT_FEMPTY)
+			break;
+
 		/* Descriptor type must be checked before all other reads */
 		dma_rmb();
 		desc_status = desc->msc;
@@ -850,9 +853,6 @@ static bool ravb_rx_gbeth(struct net_device *ndev, int *quota, int q)
 				break;
 			}
 		}
-
-		entry = (++priv->cur_rx[q]) % priv->num_rx_ring[q];
-		desc = &priv->rx_ring[q].desc[entry];
 	}
 
 	/* Refill the RX ring buffers. */
@@ -894,7 +894,6 @@ static bool ravb_rx_rcar(struct net_device *ndev, int *quota, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
-	int entry = priv->cur_rx[q] % priv->num_rx_ring[q];
 	struct net_device_stats *stats = &priv->stats[q];
 	struct ravb_ex_rx_desc *desc;
 	unsigned int limit, i;
@@ -904,10 +903,15 @@ static bool ravb_rx_rcar(struct net_device *ndev, int *quota, int q)
 	int rx_packets = 0;
 	u8  desc_status;
 	u16 pkt_len;
+	int entry;
 
 	limit = priv->dirty_rx[q] + priv->num_rx_ring[q] - priv->cur_rx[q];
-	desc = &priv->rx_ring[q].ex_desc[entry];
-	for (i = 0; i < limit && rx_packets < *quota && desc->die_dt != DT_FEMPTY; i++) {
+	for (i = 0; i < limit; i++, priv->cur_rx[q]++) {
+		entry = priv->cur_rx[q] % priv->num_rx_ring[q];
+		desc = &priv->rx_ring[q].ex_desc[entry];
+		if (rx_packets == *quota || desc->die_dt == DT_FEMPTY)
+			break;
+
 		/* Descriptor type must be checked before all other reads */
 		dma_rmb();
 		desc_status = desc->msc;
@@ -961,9 +965,6 @@ static bool ravb_rx_rcar(struct net_device *ndev, int *quota, int q)
 			rx_packets++;
 			stats->rx_bytes += pkt_len;
 		}
-
-		entry = (++priv->cur_rx[q]) % priv->num_rx_ring[q];
-		desc = &priv->rx_ring[q].ex_desc[entry];
 	}
 
 	/* Refill the RX ring buffers. */
-- 
2.43.0



