Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C1A40757A;
	Wed, 20 May 2026 18:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302584; cv=none; b=ZM9taVJJUIJyI20k0pMPWbKx358pfkf2toyx2uaSbkSmREGxqrf1F9WP4mWf1B2LyXDPrl8H+ycpWG5ZoR/Z7gz/15cynJdSrSNxgHTyploe198AGbIZT6swk/01Duu2bbE0/koYJ6B4YXyyBunQm4EAtwwEhIruRWp6OfQMXI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302584; c=relaxed/simple;
	bh=R8zfV337DM1pBus8ujPZ2eWNpECL+Msi1yt5aRaEwVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlj49N1N1ACkzZsS2JCKL4KGTxj9qOT3jDLv8Oh53YPQ6izEkE99egwNIYAu0r4EH3DQBTX/ms/znodHOYh/dqyV8fsyin5ZN2k//AiWZF9rzdLiB58LRhOCx0iAGCGXyP04Kq6cLexGiSznYpUAvgbMLDlqrgXwfCPxfAXsl6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VltIfx1P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VltIfx1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65311F000E9;
	Wed, 20 May 2026 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302583;
	bh=D03DfUYVm0OULc/LF0ZrCiYjhsAnMK9+VxagNSs6Kkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VltIfx1PLehSbv8iGKRMbItFmuGY1XkTcURiQ0NSx27X6e2vRkerb1H3faQDt3hHw
	 jffobK1oTy16d7ZKgcQCHTO+ctvaF4VHDXd+R1kzIEx4cw0qnIzrgsggrZKBpSgGLF
	 8J8FLIQeKo+Z2ujgUq94dybcy5xt6Cpz8hMS36EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 322/508] ice: fix double-free of tx_buf skb
Date: Wed, 20 May 2026 18:22:25 +0200
Message-ID: <20260520162105.614124332@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 66da8a34be0f1..4e110a008a257 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2364,6 +2364,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
+	/* record the location of the first descriptor for this packet */
+	first = &tx_ring->tx_buf[tx_ring->next_to_use];
+
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
@@ -2389,8 +2392,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	offload.tx_ring = tx_ring;
 
-	/* record the location of the first descriptor for this packet */
-	first = &tx_ring->tx_buf[tx_ring->next_to_use];
 	first->skb = skb;
 	first->type = ICE_TX_BUF_SKB;
 	first->bytecount = max_t(unsigned int, skb->len, ETH_ZLEN);
@@ -2452,6 +2453,7 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 out_drop:
 	ice_trace(xmit_frame_ring_drop, tx_ring, skb);
 	dev_kfree_skb_any(skb);
+	first->type = ICE_TX_BUF_EMPTY;
 	return NETDEV_TX_OK;
 }
 
-- 
2.53.0



