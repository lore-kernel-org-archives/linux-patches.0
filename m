Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C13835C1A0;
	Wed, 20 May 2026 17:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296428; cv=none; b=nzm5UTZr/RAlzNOel58eEHbamqWunHuX65Cuy+VwDzToJiVx06nyqDLrS5nuvJwMogoZTLl8UuG5+lhqm/U6PkqPDjuOsGQVwpHy8WOpuz/Y0yFTEv6voIdw4qbqgyqC0TVm11g3E/9gQXEsU/KqgxnCh/3hVXu0zf2SW2O58s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296428; c=relaxed/simple;
	bh=bI+PmAh2zb6QwxFT11pdQiQA/kFuC/zxEu7t6v2yG+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAGSKvgknIHBKARrww9aqleYzhvMKfMueIqA6463fKt4vYCYXwoKkwcvkmQgmKxZPi7O0YcW4l9BI1apW3sjrXLHvWpAAdshSx1wa6Zl9YUWeE9lNoTOJVyOrhbqdYDuEtEm9WiTvmborNgbc33Mc3juaKidW4MFzrF1drC76qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2mlcVu1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2mlcVu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFFF1F000E9;
	Wed, 20 May 2026 17:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296427;
	bh=v6zLduhtqxOSNLBkFVlmQPj1jPqWmFDIRgiRR3G2xQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2mlcVu116K58eY5PyaAQ6ZNV9AwVixtBIreKiyqDCmrQ74lLBQWEgjEi/iRO0GRg
	 YF+6E6w3TjWJ84M42Q14inSVpYTS4+gRi2LrI3PhKGhoD/NVvSl+FhUIJG2S2ijDUY
	 id6D3w0mpdc4LYM/Gaf0W8Z3/MduEjjeKq4SSnvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0796/1146] ice: fix double-free of tx_buf skb
Date: Wed, 20 May 2026 18:17:26 +0200
Message-ID: <20260520162206.241179053@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index a2cd4cf377348..7be9c062949b8 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2158,6 +2158,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
+	/* record the location of the first descriptor for this packet */
+	first = &tx_ring->tx_buf[tx_ring->next_to_use];
+
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
@@ -2183,8 +2186,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	offload.tx_ring = tx_ring;
 
-	/* record the location of the first descriptor for this packet */
-	first = &tx_ring->tx_buf[tx_ring->next_to_use];
 	first->skb = skb;
 	first->type = ICE_TX_BUF_SKB;
 	first->bytecount = max_t(unsigned int, skb->len, ETH_ZLEN);
@@ -2249,6 +2250,7 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 out_drop:
 	ice_trace(xmit_frame_ring_drop, tx_ring, skb);
 	dev_kfree_skb_any(skb);
+	first->type = ICE_TX_BUF_EMPTY;
 	return NETDEV_TX_OK;
 }
 
-- 
2.53.0



