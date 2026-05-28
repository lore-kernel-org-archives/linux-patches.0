Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CE7223328;
	Thu, 28 May 2026 20:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000397; cv=none; b=G5FW37If88o0D9Ahn0BLLIRtDj5bbVCDzMxQoaRGg44yVsQjvN/4QrISYW9XhjN1577GZzmq+9G8THz1mqKY1rLrOFDmDF0GPySjWuqeLvJ0XdsasvIfNxkgsU1IyYPlmd8vB0o60jgJXHvgRbS2VVSj4W0SDAufNjg47ni/ZJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000397; c=relaxed/simple;
	bh=6KIQPaQHV/8B6BGVJDmIlbA2Q+n0x5g3QdbeJMXmh3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZjJzZ957N93N0wZdWwpFvrkMAbHgK+7Pjp/yqeP7DvMjYrIgaEvMEGgyN+0G6e6sO23xvVcE6YAfqqXHjh+pBgNIGy6G3e9hDiRsrVIeT7Zygd2agviYX+QWGZ8CO9blXyCRiV+tUF7MrXJmq5iz1OCqBNrdjxDzxrVaFzvmvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSizopRD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSizopRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF9E1F000E9;
	Thu, 28 May 2026 20:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000396;
	bh=oW4uOBZ5oyBKS9MlYidqKqmkoCwM8EE9xRTTK1rPnlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSizopRDOMdIe2ybgA4mrgdOhcfBg+aR+uix7MHFwDyp4+l0TBiMBAtTP3SGcBNN9
	 dvlAIM2ntzfYO4QMUlcWsGeBM4FzLfsm4x3v5FQCLBv6VhrdBl+kMTiyWmlUrzOIRk
	 sKrVuG1rXXJlp6SU1gMM+XOsWbU7uWMJaZs50K3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/272] Revert "ice: fix double-free of tx_buf skb"
Date: Thu, 28 May 2026 21:46:44 +0200
Message-ID: <20260528194630.231806613@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit fd95ef8d0f6dbe2daa95d6488c9e0f8a95a7e048.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 48434a79869cb..08d1757f40888 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2346,9 +2346,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
-	/* record the location of the first descriptor for this packet */
-	first = &tx_ring->tx_buf[tx_ring->next_to_use];
-
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
@@ -2374,6 +2371,8 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	offload.tx_ring = tx_ring;
 
+	/* record the location of the first descriptor for this packet */
+	first = &tx_ring->tx_buf[tx_ring->next_to_use];
 	first->skb = skb;
 	first->type = ICE_TX_BUF_SKB;
 	first->bytecount = max_t(unsigned int, skb->len, ETH_ZLEN);
@@ -2437,7 +2436,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 out_drop:
 	ice_trace(xmit_frame_ring_drop, tx_ring, skb);
 	dev_kfree_skb_any(skb);
-	first->type = ICE_TX_BUF_EMPTY;
 	return NETDEV_TX_OK;
 }
 
-- 
2.53.0



