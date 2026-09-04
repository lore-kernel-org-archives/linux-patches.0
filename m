Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0EB3B19BC;
	Fri,  4 Sep 2026 05:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500000; cv=none; b=SaPgihHbxsgDvThMifbfHezDZVoKHNW33D3iY7CGgw6JqgBQdu03/ySQV8lkIrVL8Zc6WcZcxdh3WcR5hvlOOzPyOgOfLh5mI6TxmnWaUINzqBi4wiG+0HnWL/uOV74Mce8U5JOZCMdx6X5uMmpD0ynEZzDekmGnoUc8CYSXKek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500000; c=relaxed/simple;
	bh=/FmvxkYNJGQlI3bNFqJQHgGakdqGtlNt95djNFf9lcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWVnvPnGGvu3PcSiXM+LPAWXkVcT4wautbCXfgH+k9fzvv8guOX02VDs/mCzv4XTg2b1EaW/iN9tcSmHGg0MCjQ7je5XVM9X3mgP5s598L7TB4Tk9d88v3k2CmoZ1C6kG2TQBwf8i3kmd0BLZLoIqfL513VS+z7xFLMF4YRWcTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYQqGLrf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYQqGLrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411A61F00A3D;
	Fri,  4 Sep 2026 05:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499998;
	bh=iTOTF+GvHpyUKhZchuThICHYETWV5KVFGqfxEUjKzk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QYQqGLrffjTqnSCqmK5/Cw5Qu5ofG9wTzaIGQaJ3eK0egdUDxEkR8PFgMinATd11z
	 5vrKcGYMGEQYLSwBWOOzKq/hsJLHT0hWVAPem9gdhcDC/ruzVLnSXmzywk31ZLmiJj
	 Ou7AX5W2nu6TD0JWe5VapnmvBlkN6NYkKJrDljz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 615/713] net: ntb_netdev: Fix TX busy and drop handling
Date: Fri,  4 Sep 2026 06:59:43 +0200
Message-ID: <20260904045817.613713070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit 8aaa47351db0f93a5c5297fbafdfa8bc75e8ae49 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ntb_netdev.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -199,8 +199,10 @@ static int __ntb_netdev_maybe_stop_tx(st
 static int ntb_netdev_maybe_stop_tx(struct net_device *ndev,
 				    struct ntb_netdev_queue *q, int size)
 {
-	if (__netif_subqueue_stopped(ndev, q->qid) ||
-	    (ntb_transport_tx_free_entry(q->qp) >= size))
+	if (__netif_subqueue_stopped(ndev, q->qid))
+		return -EBUSY;
+
+	if (ntb_transport_tx_free_entry(q->qp) >= size)
 		return 0;
 
 	return __ntb_netdev_maybe_stop_tx(ndev, q, size);
@@ -256,21 +258,30 @@ static netdev_tx_t ntb_netdev_start_xmit
 
 	q = &dev->queues[qid];
 
-	ntb_netdev_maybe_stop_tx(ndev, q, tx_stop);
+	if (unlikely(ntb_netdev_maybe_stop_tx(ndev, q, tx_stop)))
+		return NETDEV_TX_BUSY;
 
 	rc = ntb_transport_tx_enqueue(q->qp, skb, skb->data, skb->len);
-	if (rc)
-		goto err;
+	if (rc) {
+		if (rc == -EAGAIN || rc == -EBUSY) {
+			netif_stop_subqueue(ndev, q->qid);
+			mod_timer(&q->tx_timer,
+				  jiffies + usecs_to_jiffies(tx_time));
+			return NETDEV_TX_BUSY;
+		}
+
+		goto drop;
+	}
 
 	/* check for next submit */
 	ntb_netdev_maybe_stop_tx(ndev, q, tx_stop);
 
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


