Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215060;
	b=yiq6bweR+jYyB2Ymu1BFE2rkVEH8D++E5cUHLEGFwwbcbvrppEwBZIe2KWIvELlKa3j7
	 9TljiYQR2DNEEr/nd8HUuoK0HZxNCC7HOGF1D+nRQJC7gDN2FAuGAvPxengkL7b2U26R3
	 9QOuB7xUlfqYqwWIEUh9qdNNQKaoG2w6tM8YYWteUUDacRi5G9yjhbgLDBdkGpkx9vePk
	 lT8E3GlvHhh/M1mmKdR2Pvhs5LGfZFTNApj5wIVR4YqUB73WkkVG0UZ6rBQ/5PS5KZ2dY
	 tQfIfGvkb0hUfJhBkpAhroj235d1HZhKfbq2xfiTLOq5JC+bE8uwXJZXu2QIpMgsAaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fjhg//POjmXCx9op3CzQ4vnzjObKUsnDNDgXWWQC0YI=;
	b=WToQcNAd0xDh2V0i6+3z/pLUOVCZZGHclHAMO0IBvMv1J8qcPw3uPJ0ahbfnbTV4LZoq
	 MJkjfrsVtMdHhF15+B1mDa9ZGMgNBd0Gv2Sjd16peAE7rPOAVLtu5tlsjbYoSW26mNlSD
	 xYCd2TzT8tW5FKaGfd8x5hfJxz/3aVlHPtsSLuIzRnGawxBcdo5hXvbjLr/549l4jJIie
	 KGh8kPt1IYyYCuIJXWfrvE6XvgQK/ec1uQT77y9TD8W0XthQdNlpMpdZa9l8xPYYk3orm
	 P8JcxjSo+Ki3d/Lx+OHSETlZFGKZ14TN/HcerR0y4bQiU7xrDdpDf3ArG79V1naqbow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EFLRBJX5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EC5606A31A;
	Wed, 28 Oct 2026 19:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EFLRBJX5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A901F01825;
	Wed, 28 Oct 2026 19:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215059;
	bh=Fjhg//POjmXCx9op3CzQ4vnzjObKUsnDNDgXWWQC0YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EFLRBJX5uAZ0Omxjxq+S+0OyeNlySvaUjkFXl9WWUw4IYmIbnya8sBSZGjtJtG8xd
	 ZFLlK79EmmptvJKey0WmnKxR+YSpEGKvjY215DiOdPgFFgd/vTwgR2qtmmi9d3igNi
	 CvY/o1JWU0GleO9QF8dSFd7DZYweG8cO5E2HrxQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1077/1887] ice: fix double-free of tx_buf skb
Date: Wed, 28 Oct 2026 17:52:53 +0100
Message-ID: <20261028170523.914543072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 1a303baa715e6b78d6a406aaf335f87ff35acfcd ]

If ice_tso() or ice_tx_csum() fail, the error path in
ice_xmit_frame_ring() frees the skb, but the 'first' tx_buf still points
to it and is marked as valid (ICE_TX_BUF_SKB).
'next_to_use' remains unchanged, so the potential problem will
likely fix itself when the next packet is transmitted and the tx_buf
gets overwritten. But if there is no next packet and the interface is
brought down instead, ice_clean_tx_ring() -> ice_unmap_and_free_tx_buf()
will find the tx_buf and free the skb for the second time.

The fix is to reset the tx_buf type to ICE_TX_BUF_EMPTY in the error
path, so that ice_unmap_and_free_tx_buf().
Move the initialization of 'first' up, to ensure it's already valid in
case we hit the linearization error path.

The bug was spotted by AI while I had it looking for something else.
It also proposed an initial version of the patch.

I reproduced the bug and tested the fix by adding code to inject
failures, on a build with KASAN.

I looked for similar bugs in related Intel drivers and did not find any.

Fixes: d76a60ba7afb ("ice: Add support for VLANs and offloads")
Assisted-by: Claude:claude-4.6-opus-high Cursor
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260416-iwl-net-submission-2026-04-14-v2-4-686c33c9828d@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 1d64966da1e8a..73c974747ac4a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2277,6 +2277,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
+	/* record the location of the first descriptor for this packet */
+	first = &tx_ring->tx_buf[tx_ring->next_to_use];
+
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
@@ -2302,8 +2305,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	offload.tx_ring = tx_ring;
 
-	/* record the location of the first descriptor for this packet */
-	first = &tx_ring->tx_buf[tx_ring->next_to_use];
 	first->skb = skb;
 	first->bytecount = max_t(unsigned int, skb->len, ETH_ZLEN);
 	first->gso_segs = 1;
@@ -2365,6 +2366,7 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 out_drop:
 	ice_trace(xmit_frame_ring_drop, tx_ring, skb);
 	dev_kfree_skb_any(skb);
+	first->skb = NULL;
 	return NETDEV_TX_OK;
 }
 
-- 
2.53.0



