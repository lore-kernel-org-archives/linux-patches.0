Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3BD18EFEC;
	Mon, 28 Oct 2024 06:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097866; cv=none; b=qS4qxhND7Ur6RUGUcc7/dgllB0Z/HCKnfyTBZ+zBpLV8QPO6tw4lH4w4R39lv1MjEeebanT/pD3wnSi4jZnI0XrjAj5nVdzKZYbvCU4j8krMOEh4qiRNsUcorrtA/mtO1SwomYATdSwfpOJBTedLy86EDv+FERJmzCQf1ooKlzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097866; c=relaxed/simple;
	bh=rxdyxGGrgWWkgUM/GaIoujI9V9577ZLkIoPkolxYAaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rY0khwddXPC1QfT3CeN0m9CVYcv27T2DsrGyjHN7Z9d2HjZo8zF0V8OcfL+vZJFPDXVXe/sTObzOVyaOTP8AAZfPv3izGFy3y3lmfUBMO4c1KKwy8ki+lg1UnnJFkwwFUXTyBzqG1Q9+/UnehvAfxfHJ3BuFXrZ7gSsGExPcOQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLjPWoDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLjPWoDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2F4C4CEC7;
	Mon, 28 Oct 2024 06:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097866;
	bh=rxdyxGGrgWWkgUM/GaIoujI9V9577ZLkIoPkolxYAaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLjPWoDWtR/oQP+Sl7XqMI6T+rQrzDzKu2+DXrtIFknjNgfmVN43lraKrNsb7YfNo
	 vTCTtToroh7GojBwP5CmC6ecKtsALD8GVBg92OJYyLxzr0OB20w/PZ5vESY6oRtLKq
	 zcrdmRq44ECyRYvQ1MJ0GYce8McQVcunauit2i4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 147/208] net: fix races in netdev_tx_sent_queue()/dev_watchdog()
Date: Mon, 28 Oct 2024 07:25:27 +0100
Message-ID: <20241028062310.249909425@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 95ecba62e2fd201bcdcca636f5d774f1cd4f1458 ]

Some workloads hit the infamous dev_watchdog() message:

"NETDEV WATCHDOG: eth0 (xxxx): transmit queue XX timed out"

It seems possible to hit this even for perfectly normal
BQL enabled drivers:

1) Assume a TX queue was idle for more than dev->watchdog_timeo
   (5 seconds unless changed by the driver)

2) Assume a big packet is sent, exceeding current BQL limit.

3) Driver ndo_start_xmit() puts the packet in TX ring,
   and netdev_tx_sent_queue() is called.

4) QUEUE_STATE_STACK_XOFF could be set from netdev_tx_sent_queue()
   before txq->trans_start has been written.

5) txq->trans_start is written later, from netdev_start_xmit()

    if (rc == NETDEV_TX_OK)
          txq_trans_update(txq)

dev_watchdog() running on another cpu could read the old
txq->trans_start, and then see QUEUE_STATE_STACK_XOFF, because 5)
did not happen yet.

To solve the issue, write txq->trans_start right before one XOFF bit
is set :

- _QUEUE_STATE_DRV_XOFF from netif_tx_stop_queue()
- __QUEUE_STATE_STACK_XOFF from netdev_tx_sent_queue()

>From dev_watchdog(), we have to read txq->state before txq->trans_start.

Add memory barriers to enforce correct ordering.

In the future, we could avoid writing over txq->trans_start for normal
operations, and rename this field to txq->xoff_start_time.

Fixes: bec251bc8b6a ("net: no longer stop all TX queues in dev_watchdog()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20241015194118.3951657-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 12 ++++++++++++
 net/sched/sch_generic.c   |  8 +++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8f5ac20b4c03d..1576e7443eee5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3363,6 +3363,12 @@ static inline void netif_tx_wake_all_queues(struct net_device *dev)
 
 static __always_inline void netif_tx_stop_queue(struct netdev_queue *dev_queue)
 {
+	/* Paired with READ_ONCE() from dev_watchdog() */
+	WRITE_ONCE(dev_queue->trans_start, jiffies);
+
+	/* This barrier is paired with smp_mb() from dev_watchdog() */
+	smp_mb__before_atomic();
+
 	/* Must be an atomic op see netif_txq_try_stop() */
 	set_bit(__QUEUE_STATE_DRV_XOFF, &dev_queue->state);
 }
@@ -3479,6 +3485,12 @@ static inline void netdev_tx_sent_queue(struct netdev_queue *dev_queue,
 	if (likely(dql_avail(&dev_queue->dql) >= 0))
 		return;
 
+	/* Paired with READ_ONCE() from dev_watchdog() */
+	WRITE_ONCE(dev_queue->trans_start, jiffies);
+
+	/* This barrier is paired with smp_mb() from dev_watchdog() */
+	smp_mb__before_atomic();
+
 	set_bit(__QUEUE_STATE_STACK_XOFF, &dev_queue->state);
 
 	/*
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 7f0c8df7b63e0..b51af871a621c 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -511,9 +511,15 @@ static void dev_watchdog(struct timer_list *t)
 				struct netdev_queue *txq;
 
 				txq = netdev_get_tx_queue(dev, i);
-				trans_start = READ_ONCE(txq->trans_start);
 				if (!netif_xmit_stopped(txq))
 					continue;
+
+				/* Paired with WRITE_ONCE() + smp_mb...() in
+				 * netdev_tx_sent_queue() and netif_tx_stop_queue().
+				 */
+				smp_mb();
+				trans_start = READ_ONCE(txq->trans_start);
+
 				if (time_after(jiffies, trans_start + dev->watchdog_timeo)) {
 					timedout_ms = jiffies_to_msecs(jiffies - trans_start);
 					atomic_long_inc(&txq->trans_timeout);
-- 
2.43.0



