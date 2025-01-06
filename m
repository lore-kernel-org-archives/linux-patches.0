Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD501DA631;
	Mon,  6 Jan 2025 15:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177590; cv=none; b=jRZmxiFX4VAMsPYJsQFBgtHAgZEXjvZFO8pAZdpDUWanp2XMKkDY8LTy3TQ/ApkSd+AjL3k4NukUYIKNuSMgmH5j3IWrQgUchIVNwWPp1aoVC21qwSRdv7wWtBRbgZ8GwbanyeDToh9y4wQTmjwd0FvAk72bg4272UnpBaatEVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177590; c=relaxed/simple;
	bh=gtU6ZTo7CV2JxD2Po+P0Ub3eYFOw7dQG0kmR6KogHlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsftVtpfIPCfJ+X7lwm/xPjpsdu0IZloKOLnANPADqeWdGAGhojjBqxesR8gQJmvJnIGKcppxhAn8AwU7IvhYBNjbAaRsrK9OdssJ+RvJ3sKSXsKXKt2dOKgOOv5K2t6RWxMhtSVxhERFPbV9FbOJtFKPbbobPw9d5U0Ak0cDm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=km4WO/F/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="km4WO/F/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9966C4CED2;
	Mon,  6 Jan 2025 15:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177590;
	bh=gtU6ZTo7CV2JxD2Po+P0Ub3eYFOw7dQG0kmR6KogHlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=km4WO/F/gSN1yH0BpxmMpZpxT3ZpO/rNXUJWzXeIGyXJXdY1JJUvSEbuo5wdEVLMh
	 RbAZ4nHG3jN70qOQxb8/7zm2zDfms80x8AYu+ALAkya1fBf6vYfsniw32z1vHOde1B
	 xXNZTPavqFeCCCW74rHAt2frDK+hFV6z0mHBOjUo=
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
Subject: [PATCH 6.6 213/222] gve: guard XSK operations on the existence of queues
Date: Mon,  6 Jan 2025 16:16:57 +0100
Message-ID: <20250106151158.829897172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1528,8 +1528,8 @@ static int gve_xsk_pool_enable(struct ne
 	if (err)
 		return err;
 
-	/* If XDP prog is not installed, return */
-	if (!priv->xdp_prog)
+	/* If XDP prog is not installed or interface is down, return. */
+	if (!priv->xdp_prog || !netif_running(dev))
 		return 0;
 
 	rx = &priv->rx[qid];
@@ -1574,21 +1574,16 @@ static int gve_xsk_pool_disable(struct n
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
 
@@ -1616,6 +1611,9 @@ static int gve_xsk_wakeup(struct net_dev
 	struct gve_priv *priv = netdev_priv(dev);
 	int tx_queue_id = gve_xdp_tx_queue_id(priv, queue_id);
 
+	if (!gve_get_napi_enabled(priv))
+		return -ENETDOWN;
+
 	if (queue_id >= priv->rx_cfg.num_queues || !priv->xdp_prog)
 		return -EINVAL;
 


