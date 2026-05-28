Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9997330B32;
	Thu, 28 May 2026 20:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001126; cv=none; b=MrQRRd6d4geVwU6MS5fImXf/XiRCRJtfXYyctcD9LcLrPmaFuUkmPTJBU2RgMexj76to7HppBmlirqVTg92c0vM+sMuzeMxMpJCbAjEiKh6SYHLdgQCm6LvVDYEx9chfq3aaOwpsA3tTOoxl0A7dnlzax+tQKmhwLXDq0j5ZJVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001126; c=relaxed/simple;
	bh=+2HWuENrQEyGTlhtEKaw0RuaYju8vvsYa42hQYvFAGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xcg3XI4CNLYqRVf1lNj6Yp8eoLc4vbzpHTg2uEo/c5GsSMAVuSIkB7nr2m2eS68gYv6CD3XgNCBpHS1uSgErS4Va4X/TUbcivhRXJN98Ge2H1yCutxSeMIzePcIHK2WSOPvdeBldGIHt0KV5572Lb3USVHuL3YG/FoqtApEa2Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DXXd/Xj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DXXd/Xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442CA1F000E9;
	Thu, 28 May 2026 20:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001125;
	bh=WcTHLy/idnv7H5Uvq6euhv1mn/CxLQRfwudbvrflyvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1DXXd/XjG/NMGiIk3ZqTwnuz7uf952AxtYzn6Liqvczvj6EPWb/8z/Trhm3hTzIzm
	 OfNdTwG0mENJygZdxb+aoc3b0bfZatUxigFM9FU7DNLahanu1QY/UJysfFGKicJxWg
	 X8DGJrYerxz9bBC+jgLKnQi3iFs8hGLetzG2Jdxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/186] Revert "ice: fix double-free of tx_buf skb"
Date: Thu, 28 May 2026 21:48:17 +0200
Message-ID: <20260528194929.420019031@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit ca6f9d9aee5408c47e6c0fac10955cb6825ecd96.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 4e110a008a257..66da8a34be0f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2364,9 +2364,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
-	/* record the location of the first descriptor for this packet */
-	first = &tx_ring->tx_buf[tx_ring->next_to_use];
-
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
@@ -2392,6 +2389,8 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	offload.tx_ring = tx_ring;
 
+	/* record the location of the first descriptor for this packet */
+	first = &tx_ring->tx_buf[tx_ring->next_to_use];
 	first->skb = skb;
 	first->type = ICE_TX_BUF_SKB;
 	first->bytecount = max_t(unsigned int, skb->len, ETH_ZLEN);
@@ -2453,7 +2452,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 out_drop:
 	ice_trace(xmit_frame_ring_drop, tx_ring, skb);
 	dev_kfree_skb_any(skb);
-	first->type = ICE_TX_BUF_EMPTY;
 	return NETDEV_TX_OK;
 }
 
-- 
2.53.0



