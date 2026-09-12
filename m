Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA6B38398F;
	Sat, 12 Sep 2026 18:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237284; cv=none; b=dm72J7uBKj1KDUXhpYxLJ6fqdn3Jr2VFcTLlYtOIxk3MMVijQoVmdekVxCZq/rtSTxxEEyNZpq8apcWoA00+9blmtz/qvGc8TutQR5wMoQP0LFaMBHkGXV8Gu1Hl9pkma1J5gDhf/aCRcyXVEP6tEHYTEc637m0Z699qoJzifKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237284; c=relaxed/simple;
	bh=1bYSAxCz440VSfDPsQ6t4StfoQ9AUXqRHVtBDHd9UU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKD+UkPyKGVXqTtWt5mBcwnpQq9cnu1fpGkN3OH7ON1TDmRAXSz1pOHJ8AygNsV3V0IYq6xWct482bF/YZyQEaBbO2Z6LcApIY7raKg/oKrzkFVD3y9TNGX5uRbVOZ91LvaFbkwl3l5FAtPrYSY3mvK5ubYSBMMTasYAPVfPcfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rz2OJZK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rz2OJZK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F841F000FF;
	Sat, 12 Sep 2026 18:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237282;
	bh=uuaDj+gFHyqFsrXBX5QM/6wGypKn7SaxA7HfkGS7S1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rz2OJZK/pvnjrGMiAACqMUNkx9eBQnRWAWMmi+4lkIgXWjWTe4lBvbi47yAntHfYG
	 qnxl8LIvUv7vYeH9zlzxpIjWiI6No4Qrly3AujNtJijtPdTzff+D7NGdyWNyjON1Q7
	 LqAtqGEH+pIbQPdTYxuU08a4bx1vFyv0aqeJOdBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/935] net: ntb_netdev: Fix TX busy and drop handling
Date: Sat, 12 Sep 2026 08:54:18 +0200
Message-ID: <20260912065532.056274932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[den: adapt to the single-queue implementation, as 5.15.y lacks commit:
 ee970634c777 ("net: ntb_netdev: Introduce per-queue context")]
Stable-dep-of: 873ce713fef5 ("NTB: ntb_transport: Fail TX enqueue when the QP link is down")
Stable-dep-of: a4f2387db6f1 ("NTB: ntb_transport: Reject oversized TX buffers")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ntb_netdev.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index ed698f05c537d..af6230da5e008 100644
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



