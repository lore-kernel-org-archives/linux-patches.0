Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66F5483BCD;
	Tue, 25 Aug 2026 13:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665653; cv=none; b=XkSStwZFLgPcoXTlwDyRX8OAszqWwxLArA/79x9PwsIpceZ0SqkWfVES7cGcgKfO+T3dQtfs5n0KNVyUaRIV1FkStmiv4pbJCV+VU4xmIhSTIZJa1YS0n8ZRdYBa70ONFza0MOkY/xiJ0BM7dTAESOAUqUPcj0Z6mir+Sxl6Pu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665653; c=relaxed/simple;
	bh=ZB6vEJYCCc4b6MRRXL9ZUxfeUz2/PxozQ+MXCdBM8vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXvhnLKsp32P5XuzvoMDAqaf9Y4icfW39VmRCVz8aLmR88gzYk3po/c3IKmU6sqVgGNiystCie1SRz244mXdOg8TtnzEtbPKUDbp1SYqhDxrkMXITKkweqFQj1HSg+M7UDgi4O0Faa2e1L2xj6kJzKYwMUxI1YjdCXSX31lZ87Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjjP8V6X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjjP8V6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8681F00A3E;
	Tue, 25 Aug 2026 13:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665651;
	bh=JmQxOolE5U+zvNntCzCYJnGOkQHW2oyXMj26CrrEnRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjjP8V6XLtSBoqgHanRFTwOY9J1py6f9g3/gArWkOttFdPOKGRhvRI//29kWhWPmQ
	 +gptbWdw+JLimlxukLkpoAiOoasBXdijS1rcFiJavCRJ1t8UI6xjnRgbTHG+WffVnv
	 TNf+OYhB7eWhfgv2Tqj7Vac8Rw2v5YhQbBSus4Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 04/87] NTB: ntb_netdev: Preserve RX queue depth on allocation failure
Date: Tue, 25 Aug 2026 15:25:27 +0200
Message-ID: <20260825132541.983606745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit d2121faf133ac3bf9531b53a7e21273649a08517 ]

ntb_netdev_rx_handler() hands the received skb to the network stack
before allocating its replacement. If the allocation fails, nothing is
reposted. Every failure therefore takes one buffer out of the RX queue
while the interface remains up, and enough failures eventually stall
reception.

A retry path could refill the queue later, but ntb_netdev has none.
Allocate the replacement first instead. If that fails, drop the packet
and repost the same skb. This keeps the queue full and lets packet
delivery resume as soon as memory is available again.

Fixes: 548c237c0a99 ("net: Add support for NTB virtual ethernet device")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260806032537.3526498-1-den@valinux.co.jp
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ kept HEAD's `struct net_device *ndev = qp_data;` declaration instead of the per-queue context variables, adding only `new_skb` to the existing `skb` declaration ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ntb_netdev.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -100,7 +100,7 @@ static void ntb_netdev_rx_handler(struct
 				  void *data, int len)
 {
 	struct net_device *ndev = qp_data;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *new_skb;
 	int rc;
 
 	skb = data;
@@ -115,6 +115,12 @@ static void ntb_netdev_rx_handler(struct
 		goto enqueue_again;
 	}
 
+	new_skb = netdev_alloc_skb(ndev, ndev->mtu + ETH_HLEN);
+	if (!new_skb) {
+		ndev->stats.rx_dropped++;
+		goto enqueue_again;
+	}
+
 	skb_put(skb, len);
 	skb->protocol = eth_type_trans(skb, ndev);
 	skb->ip_summed = CHECKSUM_NONE;
@@ -127,12 +133,7 @@ static void ntb_netdev_rx_handler(struct
 		ndev->stats.rx_bytes += len;
 	}
 
-	skb = netdev_alloc_skb(ndev, ndev->mtu + ETH_HLEN);
-	if (!skb) {
-		ndev->stats.rx_errors++;
-		ndev->stats.rx_frame_errors++;
-		return;
-	}
+	skb = new_skb;
 
 enqueue_again:
 	rc = ntb_transport_rx_enqueue(qp, skb, skb->data, ndev->mtu + ETH_HLEN);


