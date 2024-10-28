Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FADA8837;
	Mon, 28 Oct 2024 06:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098283; cv=none; b=c5YRQv8tpLC8QmRTQ7BZCJ+1NPVAPW10JL9fy3WRFh3KrHnJGAlZtl3itwGIip66yby1gWXKEZNne6jeN/V+Qe8l9T02nm4CWncxA7c4OMmG9p3ReemwSBZAVycIDGjaxqKH9fsZpew7odAMSpQWv09Ry6hfNhiKtMArYGhDzXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098283; c=relaxed/simple;
	bh=mwin5plFwmAI2PsiO29dY8ZH2KmN8Y60zhB4kBa1+Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4orzA611wIFHxv2JxJKu0My9iuGLDOArGkJnefuXIvYk5NArzIuZeP3TcGbH2snQn64M0woV5pjrHT8Bel14fw5JfuG9cu5/VcnY5dlF4ijZTvhlc9rTZxeyRg7cX2xPofvORm4WOb9IsNPGtVH7eFxuVRdkF72F264sUCsHsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNDfTr7L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNDfTr7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB75FC4CEC3;
	Mon, 28 Oct 2024 06:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098283;
	bh=mwin5plFwmAI2PsiO29dY8ZH2KmN8Y60zhB4kBa1+Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNDfTr7LCfpzXn1MBytJNFJ8EEJVnQvCs/ElHn5PydCSN5bhHnmv01G3UHavlLXEn
	 M4nSDO5MAvqpj10aRiAGQ/zK5sfwO4nny5KS/nEIhN4SEaTFmpj4rEehGsb1/TYZVz
	 oFXv6V3iZgSRdW9uWxu8/WIiWbVMlJqoVQVJouBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 158/261] net: fix races in netdev_tx_sent_queue()/dev_watchdog()
Date: Mon, 28 Oct 2024 07:25:00 +0100
Message-ID: <20241028062315.975052857@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index b26954dc9ed77..93548d71cf697 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3336,6 +3336,12 @@ static inline void netif_tx_wake_all_queues(struct net_device *dev)
 
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
@@ -3462,6 +3468,12 @@ static inline void netdev_tx_sent_queue(struct netdev_queue *dev_queue,
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
index 2af24547a82c4..38ec18f73de43 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -512,9 +512,15 @@ static void dev_watchdog(struct timer_list *t)
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



