Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C694530C343;
	Thu, 28 May 2026 20:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999303; cv=none; b=ftRSbtbxupMNzvzAF1zbkMwgxGHZXHsee35equHHjcP7fHMiGJ4oHiFKVU2jiwCixtWttcQupECU4Lf8WmtW0V2ysJobBqYJ8rJspgD+gJne3xSV8ejtd5Vac34Zr3Aau/KkSfvw7GfVkcbkEC8Gc6iCiIPuv7yIRR6NkMDNRzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999303; c=relaxed/simple;
	bh=SAq2ogMt/AOd2DknmWuYtfFJlxmSNPeYFp4xkJ4MXzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+6mxqpGZnJU8sboik5hRhP7sfZU2TGCwqBdMRWBt0yHtLuQMYuJ6W8lMmxoS6Y6d93MVRHoq7qucbplA882e/2TZZe0vxNIUrCHB2GdPORvRA97/k5hM4oTc+V+AMpmUMgdzRaS23i/hb6swwnbEFnfh9zJtPKgrxX+fFQUjic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EcuW22ZY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EcuW22ZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA0E1F000E9;
	Thu, 28 May 2026 20:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999302;
	bh=+UzBdkKlpTODUch3y0igcSbo01AXOTFVy1CYlf5dY5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EcuW22ZYs5uAVEjwQkcRFyI9E0q4r32bb2nexrIU7ljAFTNKoz6GvWpkdYQXgyFh4
	 SHbkgxfL87ZwCQHvW5FXjo25wgmJsVun4cvXqws+yy0/ePlAif8oGDhDz4SxamoLGM
	 Zd5CeNmmdylN6SKhkeDC5ts0aZv2XsToINqEwpeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/377] Revert "ice: fix double-free of tx_buf skb"
Date: Thu, 28 May 2026 21:44:17 +0200
Message-ID: <20260528194638.943819206@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 7cb19ec8ac087f33bee60f5d6054b284a5b9bb6f.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index e0774a640955d..90dbe5266ce78 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2594,9 +2594,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
-	/* record the location of the first descriptor for this packet */
-	first = &tx_ring->tx_buf[tx_ring->next_to_use];
-
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
@@ -2622,6 +2619,8 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	offload.tx_ring = tx_ring;
 
+	/* record the location of the first descriptor for this packet */
+	first = &tx_ring->tx_buf[tx_ring->next_to_use];
 	first->skb = skb;
 	first->type = ICE_TX_BUF_SKB;
 	first->bytecount = max_t(unsigned int, skb->len, ETH_ZLEN);
@@ -2686,7 +2685,6 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 out_drop:
 	ice_trace(xmit_frame_ring_drop, tx_ring, skb);
 	dev_kfree_skb_any(skb);
-	first->type = ICE_TX_BUF_EMPTY;
 	return NETDEV_TX_OK;
 }
 
-- 
2.53.0



