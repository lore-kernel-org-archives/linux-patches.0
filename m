Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19CF4C10C4;
	Thu, 17 Sep 2026 15:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659415; cv=none; b=GjbZAAbDf8I3OGilHOzKYTNECsy9BsLK8dYR50JcxaS4q9of6Kf5o5KSZAKVbtrektqao2BsClWpsZ3D0RM5LshAUIfNuj5OPrGVVXzTNGcf+eD0IPj2FM7xB6hXqhC6n843EBN19ldLkd/rT50J2GEwLSLruSJBFed0uBjrpeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659415; c=relaxed/simple;
	bh=JFI6u6QKj9Yo6WNIJOByjOuiq8lM5OnivOP+aWqKJ/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eS7v73veVVoBRlcMQSUIjmxE8ZFhlCno37G88fLNXwkVe35c5gvwdY0pWkbJBdBdDWeB27WrR9TYoA14pheYcf5aFQ/8zSIb1EYgUAwu/xl1bySwVTMuz4Mr2jWK4qTQmHxmS+Y7v34OjVCoxOj75IgHbtYFD8uLu4zE2PuZcbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDSUA2xY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDSUA2xY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CBD1F000FF;
	Thu, 17 Sep 2026 15:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659407;
	bh=wvUxYgY0v21BhCKcOc/WKk85yaIHupMvS2fG0F8XJc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDSUA2xYxWvYTUAJRNnxHjdvdx6PPLNkrG/mxNGEz9RfOtgIthNG10ZaiZIknUMYw
	 7XrwuuwJfTHSvN/lSU95l4b8sjO6b5Eu+EAyoOy7RnDjp9gt9ANk0lEL/3xg0KK53y
	 TjK6GMyzAyZjXLJNjycXTZZCWYN1F7cDHOi3MlaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 207/733] net: macb: exclude software FCS from TX byte statistics
Date: Thu, 17 Sep 2026 16:08:35 +0100
Message-ID: <20260917151356.341258247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit d85f521a9afb786b1d95bbcb218d3afdf3fe73ab ]

Frames for which macb_pad_and_fcs() supplies the FCS have four FCS
bytes appended, and TX completion then accounts the grown skb->len.
tx_bytes is defined to exclude the FCS, so these frames are reported
four bytes too large.

Track only the number of FCS bytes appended in software, 0 or
ETH_FCS_LEN, and subtract that from skb->len at completion. skb->len
already reflects the padded length by then, so there is nothing else
to store. macb_pad_and_fcs() already returns 0 on every non-error
path. Return the FCS length from there instead, rather than
recomputing the same check in the caller. BQL stays on the padded
skb->len that netdev_tx_sent_queue() saw.

Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260831113128.1678674-1-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb.h      |  3 +++
 drivers/net/ethernet/cadence/macb_main.c | 21 +++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 9857df5b57f09..f8bff3e71b682 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -974,6 +974,8 @@ struct macb_dma_desc_ptp {
  *       of the frame
  * @mapping: DMA address of the skb's fragment buffer
  * @size: size of the DMA mapped buffer
+ * @fcs_len: FCS bytes appended in software, 0 or ETH_FCS_LEN, only
+ *           set for the last buffer of the frame
  * @mapped_as_page: true when buffer was mapped with skb_frag_dma_map(),
  *                  false when buffer was mapped with dma_map_single()
  */
@@ -981,6 +983,7 @@ struct macb_tx_skb {
 	struct sk_buff		*skb;
 	dma_addr_t		mapping;
 	size_t			size;
+	u8			fcs_len;
 	bool			mapped_as_page;
 };
 
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 02d10490b8adb..05eda2545597b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1323,8 +1323,8 @@ static void macb_tx_error_task(struct work_struct *work)
 				bp->netdev->stats.tx_packets++;
 				queue->stats.tx_packets++;
 				packets++;
-				bp->netdev->stats.tx_bytes += skb->len;
-				queue->stats.tx_bytes += skb->len;
+				bp->netdev->stats.tx_bytes += skb->len - tx_skb->fcs_len;
+				queue->stats.tx_bytes += skb->len - tx_skb->fcs_len;
 				bytes += skb->len;
 			}
 		} else {
@@ -1451,8 +1451,8 @@ static int macb_tx_complete(struct macb_queue *queue, int budget)
 					    skb->data);
 				bp->netdev->stats.tx_packets++;
 				queue->stats.tx_packets++;
-				bp->netdev->stats.tx_bytes += skb->len;
-				queue->stats.tx_bytes += skb->len;
+				bp->netdev->stats.tx_bytes += skb->len - tx_skb->fcs_len;
+				queue->stats.tx_bytes += skb->len - tx_skb->fcs_len;
 				packets++;
 				bytes += skb->len;
 			}
@@ -2200,7 +2200,8 @@ static void macb_poll_controller(struct net_device *netdev)
 static unsigned int macb_tx_map(struct macb *bp,
 				struct macb_queue *queue,
 				struct sk_buff *skb,
-				unsigned int hdrlen)
+				unsigned int hdrlen,
+				u8 fcs_len)
 {
 	unsigned int f, nr_frags = skb_shinfo(skb)->nr_frags;
 	unsigned int len, i, tx_head = queue->tx_head;
@@ -2285,6 +2286,7 @@ static unsigned int macb_tx_map(struct macb *bp,
 
 	/* This is the last buffer of the frame: save socket buffer */
 	tx_skb->skb = skb;
+	tx_skb->fcs_len = fcs_len;
 
 	/* Update TX ring: update buffer descriptors in reverse order
 	 * to avoid race condition
@@ -2418,6 +2420,7 @@ static inline int macb_clear_csum(struct sk_buff *skb)
 	return 0;
 }
 
+/* Returns a negative errno, or the FCS bytes appended (0 or ETH_FCS_LEN). */
 static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *netdev)
 {
 	bool cloned = skb_cloned(*skb) || skb_header_cloned(*skb) ||
@@ -2466,7 +2469,7 @@ static int macb_pad_and_fcs(struct sk_buff **skb, struct net_device *netdev)
 	skb_put_u8(*skb, (fcs >> 16)	& 0xff);
 	skb_put_u8(*skb, (fcs >> 24)	& 0xff);
 
-	return 0;
+	return ETH_FCS_LEN;
 }
 
 static netdev_tx_t macb_start_xmit(struct sk_buff *skb,
@@ -2478,6 +2481,7 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb,
 	unsigned int desc_cnt, nr_frags, frag_size, f;
 	unsigned int hdrlen;
 	unsigned long flags;
+	int fcs_len;
 	bool is_lso;
 	netdev_tx_t ret = NETDEV_TX_OK;
 
@@ -2486,7 +2490,8 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb,
 		return ret;
 	}
 
-	if (macb_pad_and_fcs(&skb, netdev)) {
+	fcs_len = macb_pad_and_fcs(&skb, netdev);
+	if (fcs_len < 0) {
 		dev_kfree_skb_any(skb);
 		return ret;
 	}
@@ -2549,7 +2554,7 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb,
 	}
 
 	/* Map socket buffer for DMA transfer */
-	if (macb_tx_map(bp, queue, skb, hdrlen)) {
+	if (macb_tx_map(bp, queue, skb, hdrlen, fcs_len)) {
 		dev_kfree_skb_any(skb);
 		goto unlock;
 	}
-- 
2.53.0



