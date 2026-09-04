Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE543F0A9E;
	Fri,  4 Sep 2026 06:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501611; cv=none; b=kG2t2dnvx0cLTqR90xZ+iGYmVGsX64Ll2c2XiyuiQ2mK325O2v24enn2WctYxdsyyieHft9mnz86AAwawg+Oiq7r0N3nv+496UePEXKQ14X940J94+bk648n/Znv8tTHnyIlfyxO4pTgtGPaCasxuEOgFtoOgySfIwNm++gSX68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501611; c=relaxed/simple;
	bh=iQhUWROFZDpXP/h/8W2qRSVkp3E/9wfE/nLswYXt4pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMRBNwhKL8cPYOZMyPR+wPAAU9v303TgY94N1vKgqANy50lJa3PPAkQEf8DqNHV3Crlb8wRHZOBUTZhx8KpLXDIh1WECn49oslnTQvKPhakAbTXfLOJ+a9jmWCMJOjZbTi8BUdcyAllFK1gnvy911dNGPtz6kzKgDNL4XxYCBRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJJxbq7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJJxbq7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A496F1F00A3D;
	Fri,  4 Sep 2026 06:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501610;
	bh=X4bTK7W0cWqFMn4ABtZxHBMu4AyY0e/sfi34wcI53KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kJJxbq7RbjRorTjCvNwrT6XH1W6a+EXfZw5qnMKcTmL8NE/rgbxf1J4qtcN/Os2UC
	 EPRuZxs9kw/8tLHgu6/kGWqN61OWvcKQTt4c7DqjKRlvNksvaUe8szIe/OrZ1k9+hS
	 EjuK+SP0+HWBGKVvGBF7/D0BBOHCCTRuZHU4n4V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 469/552] net: ntb_netdev: Fix TX busy and drop handling
Date: Fri,  4 Sep 2026 07:00:26 +0200
Message-ID: <20260904045801.326176289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -187,8 +187,10 @@ static int __ntb_netdev_maybe_stop_tx(st
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
@@ -237,21 +239,30 @@ static netdev_tx_t ntb_netdev_start_xmit
 
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


