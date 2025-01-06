Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F07A1DACBB;
	Mon,  6 Jan 2025 15:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178054; cv=none; b=OkiWkWWQJGL7XKD6TxTMn9BLmaNh/56CayJsH8WRPI+LKN9TJBx9ZtBIppPgsmnrqiQCSCiOHO4ngBhc5p+YXY9RsQzR6MXOI3pZJqavx2kYHjp6kQRs0Jxqq+WBJH1YCtMa+Ija5suMpOG0a/TbPeO64IGyhjXa5zjdf6K3BVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178054; c=relaxed/simple;
	bh=pApsc5N1adOkT7epJvQX/vh508eBuRvFncwtjDzycGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9ale3zbKgXlH7Z9Sv8Stm0vy8t6ccxDTuHamiAfpVFNMqhZ8vZ8BXiXLrLBZ+ok3o9deebtAVcYTWZ0dHzUqAaFfURxoCLJ8CY0+nnBwBsiJYdtSPYaF7+AsE6qkaDUbwiR9c+Pi1QRgUfehVXjNRC1jcRnFu9C6iqPRTK0/bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4IxmqVp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4IxmqVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275F5C4CED2;
	Mon,  6 Jan 2025 15:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178054;
	bh=pApsc5N1adOkT7epJvQX/vh508eBuRvFncwtjDzycGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4IxmqVpEq2oI2xn4/1tORO4AWIdKjFENgFDRigv3xmcuRCHmYIWhONjFTm7JNKf+
	 hdpLHZdMteWn+dyCf6Tj8NmSFXS7uTQ6fZiFbOEzqS/f1cfqT44pW9mPOWWWr69VJY
	 vmv2A4o+qnAxhLn3ywbnfDHBqgP+oA4CG4UEj774=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Shailend Chand <shailend@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.12 145/156] gve: guard XSK operations on the existence of queues
Date: Mon,  6 Jan 2025 16:17:11 +0100
Message-ID: <20250106151147.189983041@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Washington <joshwash@google.com>

commit 40338d7987d810fcaa95c500b1068a52b08eec9b upstream.

This patch predicates the enabling and disabling of XSK pools on the
existence of queues. As it stands, if the interface is down, disabling
or enabling XSK pools would result in a crash, as the RX queue pointer
would be NULL. XSK pool registration will occur as part of the next
interface up.

Similarly, xsk_wakeup needs be guarded against queues disappearing
while the function is executing, so a check against the
GVE_PRIV_FLAGS_NAPI_ENABLED flag is added to synchronize with the
disabling of the bit and the synchronize_net() in gve_turndown.

Fixes: fd8e40321a12 ("gve: Add AF_XDP zero-copy support for GQI-QPL format")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Shailend Chand <shailend@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_main.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1631,8 +1631,8 @@ static int gve_xsk_pool_enable(struct ne
 	if (err)
 		return err;
 
-	/* If XDP prog is not installed, return */
-	if (!priv->xdp_prog)
+	/* If XDP prog is not installed or interface is down, return. */
+	if (!priv->xdp_prog || !netif_running(dev))
 		return 0;
 
 	rx = &priv->rx[qid];
@@ -1677,21 +1677,16 @@ static int gve_xsk_pool_disable(struct n
 	if (qid >= priv->rx_cfg.num_queues)
 		return -EINVAL;
 
-	/* If XDP prog is not installed, unmap DMA and return */
-	if (!priv->xdp_prog)
+	/* If XDP prog is not installed or interface is down, unmap DMA and
+	 * return.
+	 */
+	if (!priv->xdp_prog || !netif_running(dev))
 		goto done;
 
-	tx_qid = gve_xdp_tx_queue_id(priv, qid);
-	if (!netif_running(dev)) {
-		priv->rx[qid].xsk_pool = NULL;
-		xdp_rxq_info_unreg(&priv->rx[qid].xsk_rxq);
-		priv->tx[tx_qid].xsk_pool = NULL;
-		goto done;
-	}
-
 	napi_rx = &priv->ntfy_blocks[priv->rx[qid].ntfy_id].napi;
 	napi_disable(napi_rx); /* make sure current rx poll is done */
 
+	tx_qid = gve_xdp_tx_queue_id(priv, qid);
 	napi_tx = &priv->ntfy_blocks[priv->tx[tx_qid].ntfy_id].napi;
 	napi_disable(napi_tx); /* make sure current tx poll is done */
 
@@ -1719,6 +1714,9 @@ static int gve_xsk_wakeup(struct net_dev
 	struct gve_priv *priv = netdev_priv(dev);
 	int tx_queue_id = gve_xdp_tx_queue_id(priv, queue_id);
 
+	if (!gve_get_napi_enabled(priv))
+		return -ENETDOWN;
+
 	if (queue_id >= priv->rx_cfg.num_queues || !priv->xdp_prog)
 		return -EINVAL;
 


