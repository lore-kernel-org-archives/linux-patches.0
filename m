Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512A5265602;
	Tue,  8 Apr 2025 11:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111930; cv=none; b=s89lOkClHL/xBdrM2Q/aVtjx4OQjgRqwrTZlzgoMcx+f/61Da+rtbbliCJai1KACxTaWKAgzXpEIK6phnhf4xQMg+M/Aj+ySlP5X/mwYzOKnd9aAYiwT1gXlNmvzJvFCn2wcGKQoN3qNo19MD/srRQp5sR9ITZCiK4fJNnkal78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111930; c=relaxed/simple;
	bh=flDltspZppSkBKjW55PMGnJlpPIR3p5CZKgIRb71JPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpms94nU1hJPWpGzhOhLG5j7YqJRNipsQyBC6cUUtdrBptobzajC3ANyUX/z0B9+bFUQdMDHAljkJ7EzC3H3b7F0kl+ojOdm8a2XQg1QgxnjhS7fN7RE7J1JHF38zoAQjzw8vKYhUhEZQYKPyFj79Sm89zF+4SupRolfsNSegmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3yGbOpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3yGbOpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7345BC4CEE5;
	Tue,  8 Apr 2025 11:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111929;
	bh=flDltspZppSkBKjW55PMGnJlpPIR3p5CZKgIRb71JPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3yGbOpEIxvGz2EE3StZQQ37i8+19oSdN74JrvCE8d2aBDbyFgcSsKpllivE/H6gg
	 tMiKBoCRytnaZYCo4UgRu2V0TBebyA0TJ31bumlT892sQLUzRbkqaVWhx9NFx/I0ey
	 XMViL9FBkNHTZXfNrUeo6KcUu5itbyfcntzyhuUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Faizal Rahim <faizal.abdul.rahim@linux.intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 612/731] igc: Refactor empty frame insertion for launch time support
Date: Tue,  8 Apr 2025 12:48:29 +0200
Message-ID: <20250408104928.507168542@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Yoong Siang <yoong.siang.song@intel.com>

[ Upstream commit f9b53bb13923f0a6ed2e784a35301cfb4c28f4f4 ]

Refactor the code for inserting an empty frame into a new function
igc_insert_empty_frame(). This change extracts the logic for inserting
an empty packet from igc_xmit_frame_ring() into a separate function,
allowing it to be reused in future implementations, such as the XDP
zero copy transmit function.

Remove the igc_desc_unused() checking in igc_init_tx_empty_descriptor()
because the number of descriptors needed is guaranteed.

Ensure that skb allocation and DMA mapping work for the empty frame,
before proceeding to fill in igc_tx_buffer info, context descriptor,
and data descriptor.

Rate limit the error messages for skb allocation and DMA mapping failures.

Update the comment to indicate that the 2 descriptors needed by the empty
frame are already taken into consideration in igc_xmit_frame_ring().

Handle the case where the insertion of an empty frame fails and explain
the reason behind this handling.

Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://patch.msgid.link/20250216093430.957880-5-yoong.siang.song@intel.com
Stable-dep-of: d931cf9b38da ("igc: Fix TX drops in XDP ZC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 82 ++++++++++++++---------
 1 file changed, 50 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 84307bb7313e0..1bfa71545e371 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1092,7 +1092,8 @@ static int igc_init_empty_frame(struct igc_ring *ring,
 
 	dma = dma_map_single(ring->dev, skb->data, size, DMA_TO_DEVICE);
 	if (dma_mapping_error(ring->dev, dma)) {
-		netdev_err_once(ring->netdev, "Failed to map DMA for TX\n");
+		net_err_ratelimited("%s: DMA mapping error for empty frame\n",
+				    netdev_name(ring->netdev));
 		return -ENOMEM;
 	}
 
@@ -1108,20 +1109,12 @@ static int igc_init_empty_frame(struct igc_ring *ring,
 	return 0;
 }
 
-static int igc_init_tx_empty_descriptor(struct igc_ring *ring,
-					struct sk_buff *skb,
-					struct igc_tx_buffer *first)
+static void igc_init_tx_empty_descriptor(struct igc_ring *ring,
+					 struct sk_buff *skb,
+					 struct igc_tx_buffer *first)
 {
 	union igc_adv_tx_desc *desc;
 	u32 cmd_type, olinfo_status;
-	int err;
-
-	if (!igc_desc_unused(ring))
-		return -EBUSY;
-
-	err = igc_init_empty_frame(ring, first, skb);
-	if (err)
-		return err;
 
 	cmd_type = IGC_ADVTXD_DTYP_DATA | IGC_ADVTXD_DCMD_DEXT |
 		   IGC_ADVTXD_DCMD_IFCS | IGC_TXD_DCMD |
@@ -1140,8 +1133,6 @@ static int igc_init_tx_empty_descriptor(struct igc_ring *ring,
 	ring->next_to_use++;
 	if (ring->next_to_use == ring->count)
 		ring->next_to_use = 0;
-
-	return 0;
 }
 
 #define IGC_EMPTY_FRAME_SIZE 60
@@ -1567,6 +1558,40 @@ static bool igc_request_tx_tstamp(struct igc_adapter *adapter, struct sk_buff *s
 	return false;
 }
 
+static int igc_insert_empty_frame(struct igc_ring *tx_ring)
+{
+	struct igc_tx_buffer *empty_info;
+	struct sk_buff *empty_skb;
+	void *data;
+	int ret;
+
+	empty_info = &tx_ring->tx_buffer_info[tx_ring->next_to_use];
+	empty_skb = alloc_skb(IGC_EMPTY_FRAME_SIZE, GFP_ATOMIC);
+	if (unlikely(!empty_skb)) {
+		net_err_ratelimited("%s: skb alloc error for empty frame\n",
+				    netdev_name(tx_ring->netdev));
+		return -ENOMEM;
+	}
+
+	data = skb_put(empty_skb, IGC_EMPTY_FRAME_SIZE);
+	memset(data, 0, IGC_EMPTY_FRAME_SIZE);
+
+	/* Prepare DMA mapping and Tx buffer information */
+	ret = igc_init_empty_frame(tx_ring, empty_info, empty_skb);
+	if (unlikely(ret)) {
+		dev_kfree_skb_any(empty_skb);
+		return ret;
+	}
+
+	/* Prepare advanced context descriptor for empty packet */
+	igc_tx_ctxtdesc(tx_ring, 0, false, 0, 0, 0);
+
+	/* Prepare advanced data descriptor for empty packet */
+	igc_init_tx_empty_descriptor(tx_ring, empty_skb, empty_info);
+
+	return 0;
+}
+
 static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 				       struct igc_ring *tx_ring)
 {
@@ -1586,6 +1611,7 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	 *	+ 1 desc for skb_headlen/IGC_MAX_DATA_PER_TXD,
 	 *	+ 2 desc gap to keep tail from touching head,
 	 *	+ 1 desc for context descriptor,
+	 *	+ 2 desc for inserting an empty packet for launch time,
 	 * otherwise try next time
 	 */
 	for (f = 0; f < skb_shinfo(skb)->nr_frags; f++)
@@ -1605,24 +1631,16 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	launch_time = igc_tx_launchtime(tx_ring, txtime, &first_flag, &insert_empty);
 
 	if (insert_empty) {
-		struct igc_tx_buffer *empty_info;
-		struct sk_buff *empty;
-		void *data;
-
-		empty_info = &tx_ring->tx_buffer_info[tx_ring->next_to_use];
-		empty = alloc_skb(IGC_EMPTY_FRAME_SIZE, GFP_ATOMIC);
-		if (!empty)
-			goto done;
-
-		data = skb_put(empty, IGC_EMPTY_FRAME_SIZE);
-		memset(data, 0, IGC_EMPTY_FRAME_SIZE);
-
-		igc_tx_ctxtdesc(tx_ring, 0, false, 0, 0, 0);
-
-		if (igc_init_tx_empty_descriptor(tx_ring,
-						 empty,
-						 empty_info) < 0)
-			dev_kfree_skb_any(empty);
+		/* Reset the launch time if the required empty frame fails to
+		 * be inserted. However, this packet is not dropped, so it
+		 * "dirties" the current Qbv cycle. This ensures that the
+		 * upcoming packet, which is scheduled in the next Qbv cycle,
+		 * does not require an empty frame. This way, the launch time
+		 * continues to function correctly despite the current failure
+		 * to insert the empty frame.
+		 */
+		if (igc_insert_empty_frame(tx_ring))
+			launch_time = 0;
 	}
 
 done:
-- 
2.39.5



