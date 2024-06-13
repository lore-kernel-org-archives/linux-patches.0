Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CB3145B10;
	Thu, 13 Jun 2024 12:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280780; cv=none; b=As8LJeSi69Ng35IMqHy4U8cVRJ7wpCutNi4J3z6bVUU3XMA9Pe64y6c22e2UpdIBF0SXu0kPnSuon6nQxluqCmdnEqOGq9FEr5EWIf36hFKPWDTrffrfzDxku2m/TkSa6hJOkdYofqcCKd5u8MseZVsW+i+UxUBzUeBLRmFk5L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280780; c=relaxed/simple;
	bh=O/2PyNTHBCEuzMcrmaLa62ZOvS93B5zCNFSAIvPMb0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTcUSgcfdjMj2trcJYUQ5Kr4QxVcWkLNNivemCZv+SkIsEg2rYlxKN9mZJAz++Hg9FbmbVjeh+9hJUJ0SA76IeDVh76ZXjxzrgEVmveBOMhrHwaD1sQrknKwS/oS6Ic4j+xAvT5Z9bLDS6RwlAp2A7/FZlecL+meAtNLqCheQaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvlBqNpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvlBqNpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED56C2BBFC;
	Thu, 13 Jun 2024 12:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280779;
	bh=O/2PyNTHBCEuzMcrmaLa62ZOvS93B5zCNFSAIvPMb0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvlBqNptPQ/6vdu4UddTKNvN6SyAcGyIjkQotD8QcBL9AIOtx462Y6+tzCu0hJaYf
	 BjuSEC466MZj5qOa1vVcDC+9vSTssotfGzdmsKLfQ+wg9n7nUYKtR7C+RhtR+pffrm
	 TMPadtbr9It5knNkyuA9KV6NV/oO9EjrdLRG0ASw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Milmore <ken.milmore@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 004/317] r8169: Fix possible ring buffer corruption on fragmented Tx packets.
Date: Thu, 13 Jun 2024 13:30:22 +0200
Message-ID: <20240613113247.702462647@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ken Milmore <ken.milmore@gmail.com>

commit c71e3a5cffd5309d7f84444df03d5b72600cc417 upstream.

An issue was found on the RTL8125b when transmitting small fragmented
packets, whereby invalid entries were inserted into the transmit ring
buffer, subsequently leading to calls to dma_unmap_single() with a null
address.

This was caused by rtl8169_start_xmit() not noticing changes to nr_frags
which may occur when small packets are padded (to work around hardware
quirks) in rtl8169_tso_csum_v2().

To fix this, postpone inspecting nr_frags until after any padding has been
applied.

Fixes: 9020845fb5d6 ("r8169: improve rtl8169_start_xmit")
Cc: stable@vger.kernel.org
Signed-off-by: Ken Milmore <ken.milmore@gmail.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/27ead18b-c23d-4f49-a020-1fc482c5ac95@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4279,11 +4279,11 @@ static void rtl8169_doorbell(struct rtl8
 static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 				      struct net_device *dev)
 {
-	unsigned int frags = skb_shinfo(skb)->nr_frags;
 	struct rtl8169_private *tp = netdev_priv(dev);
 	unsigned int entry = tp->cur_tx % NUM_TX_DESC;
 	struct TxDesc *txd_first, *txd_last;
 	bool stop_queue, door_bell;
+	unsigned int frags;
 	u32 opts[2];
 
 	txd_first = tp->TxDescArray + entry;
@@ -4309,6 +4309,7 @@ static netdev_tx_t rtl8169_start_xmit(st
 				    entry, false)))
 		goto err_dma_0;
 
+	frags = skb_shinfo(skb)->nr_frags;
 	if (frags) {
 		if (rtl8169_xmit_frags(tp, skb, opts, entry))
 			goto err_dma_1;


