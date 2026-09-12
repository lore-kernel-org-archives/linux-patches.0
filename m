Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7863264F9;
	Sat, 12 Sep 2026 13:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221111; cv=none; b=b0BqbowOISJbdoi2EtfQD7MH/DXGfE1v7Ut6JbLea9H3LZkEt5fC/DOySNfuSOM7Z+LD+xA0cTF1zMYJIx+wZ9a+savDg0dyJD+OSpAxxabBEH3ANkgXsYuNSIpdDEMGDeaxwSN51kRD8Syj4QM4d5tXtukXeULLz7W2Ku1MA4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221111; c=relaxed/simple;
	bh=r61Q1IRbtC+Turw96bZUQNM6H5FA5aPXItkF0V+XDNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MX5E2V5sUO5cUPQPr0Kzl7PMB/OsHptDH+5xm4rXFSqerznh5RvhWg7A8qcAmZGRVEtJJYR/y+jo9+zacLd334P5fUgATVxxGC+OqGGJXXShS2g+kG0kWyZe1LrhTn1rf8JRmYgFyaVJeW3KETwF5yjL9iWHuHhdYNQEh+HAW/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5dM2ZSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5dM2ZSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDE01F000FF;
	Sat, 12 Sep 2026 13:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221110;
	bh=s4p6zEzNxQwx/2xRinearo/CrJqjTlP2OeReGSxHGmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C5dM2ZSsxKpNOJfUl2D7RegrmowrndCybgOZcz6hiJpdYoLPu+/8fl1BNTiDAWPMB
	 II1jsN1eXGSbEE3DlaNk6LPBW3o08/TSbX9cEXXU4411Pd34/UC966xcOXlhgIL29W
	 Dg7e9oIJAzQvvTzPxc3Wujm2LwJnYHIF22Fi+TWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0317/1424] net: ntb_netdev: Fix TX busy and drop handling
Date: Sat, 12 Sep 2026 08:45:49 +0200
Message-ID: <20260912065614.383340427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

[ Upstream commit 8aaa47351db0f93a5c5297fbafdfa8bc75e8ae49 ]

Currently, ntb_netdev returns NETDEV_TX_BUSY for every enqueue error. It
also increments the drop and error counters while leaving the skb owned
by the qdisc, and may return BUSY with the subqueue still awake.
Retrying a permanent error cannot succeed either.

The unconditional BUSY return and premature accounting date back to the
initial driver. The error-path queue stop was later removed without
changing that return value. The current flow-control code includes a
resource check, but ntb_netdev does not honor its result before enqueue.

Honor the resource check before enqueue. For -EAGAIN and -EBUSY, stop
the subqueue, arm the existing reaper timer, and return BUSY without
touching the skb. For other errors, free the skb, increment tx_dropped,
and return NETDEV_TX_OK.

Fixes: 548c237c0a99 ("net: Add support for NTB virtual ethernet device")
Fixes: d723485cb4ca ("ntb_netdev: remove tx timeout")
Fixes: e74bfeedad08 ("NTB: Add flow control to the ntb_netdev")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260817053519.4135287-3-den@valinux.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[den: adapt to the single-queue implementation, as 6.6.y lacks commit:
 ee970634c777 ("net: ntb_netdev: Introduce per-queue context")]
Stable-dep-of: 873ce713fef5 ("NTB: ntb_transport: Fail TX enqueue when the QP link is down")
Stable-dep-of: a4f2387db6f1 ("NTB: ntb_transport: Reject oversized TX buffers")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ntb_netdev.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 886b3a54f8f86..525040622f679 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -164,8 +164,10 @@ static int __ntb_netdev_maybe_stop_tx(struct net_device *netdev,
 static int ntb_netdev_maybe_stop_tx(struct net_device *ndev,
 				    struct ntb_transport_qp *qp, int size)
 {
-	if (netif_queue_stopped(ndev) ||
-	    (ntb_transport_tx_free_entry(qp) >= size))
+	if (netif_queue_stopped(ndev))
+		return -EBUSY;
+
+	if (ntb_transport_tx_free_entry(qp) >= size)
 		return 0;
 
 	return __ntb_netdev_maybe_stop_tx(ndev, qp, size);
@@ -208,21 +210,30 @@ static netdev_tx_t ntb_netdev_start_xmit(struct sk_buff *skb,
 	struct ntb_netdev *dev = netdev_priv(ndev);
 	int rc;
 
-	ntb_netdev_maybe_stop_tx(ndev, dev->qp, tx_stop);
+	if (unlikely(ntb_netdev_maybe_stop_tx(ndev, dev->qp, tx_stop)))
+		return NETDEV_TX_BUSY;
 
 	rc = ntb_transport_tx_enqueue(dev->qp, skb, skb->data, skb->len);
-	if (rc)
-		goto err;
+	if (rc) {
+		if (rc == -EAGAIN || rc == -EBUSY) {
+			netif_stop_queue(ndev);
+			mod_timer(&dev->tx_timer,
+				  jiffies + usecs_to_jiffies(tx_time));
+			return NETDEV_TX_BUSY;
+		}
+
+		goto drop;
+	}
 
 	/* check for next submit */
 	ntb_netdev_maybe_stop_tx(ndev, dev->qp, tx_stop);
 
 	return NETDEV_TX_OK;
 
-err:
+drop:
+	dev_kfree_skb_any(skb);
 	ndev->stats.tx_dropped++;
-	ndev->stats.tx_errors++;
-	return NETDEV_TX_BUSY;
+	return NETDEV_TX_OK;
 }
 
 static void ntb_netdev_tx_timer(struct timer_list *t)
-- 
2.53.0



