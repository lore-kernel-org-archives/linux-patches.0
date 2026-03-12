Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBD23B19AC;
	Thu, 12 Mar 2026 20:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347308; cv=none; b=UNLzoBOV2zkKSmegtrfYFwxHzTdjGwIZHIIxvPZ01exdAd/4Q37tEbLxXEByoJnk0otnp3kzSYdELHQJg92O4Hv+JH78VoqCfIxUUgoHTvxyjTMpFnYoWDKxhelnaIY8vRe3KkOjYFKSZ9rgQ2owM2gw8eAQmNWdyfIAcR0Aopg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347308; c=relaxed/simple;
	bh=xc4KSKhXLgMuid6gJzs/flRHGMxkN0+w6K2evOxTJro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHY/HaSXBRJ/myv4WHJwF/Ci34A4cl4hH95g5MwW16Kl9XDBoiyXfMGld6nxbwjuZnBFDUosJ/j270LQw9P1OdFsCIUWxn0Ic8ceBgOq1Ri/4z0pIamRuoJq9Y+LBbzQSQ2QkJ2Kp72+80zspw91dCDUI2L72Y+sjWwBOjpF0TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJi/ZQaa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJi/ZQaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEFCC4CEF7;
	Thu, 12 Mar 2026 20:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347308;
	bh=xc4KSKhXLgMuid6gJzs/flRHGMxkN0+w6K2evOxTJro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJi/ZQaaBGqzETsoggyDV6gsUF5TBoCRNrgojzJCXoGzwOmCwapchw2y7RIObEwla
	 v9dxmeZTRXFl0ggeo0LlOaV/qImvTlIEOv17gk9t/52ljG7WXITp218+60uhJlaOWq
	 gi/786yyFRehvsPh1UmCXB446eVC7VAycESiLM80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 227/265] net: sched: avoid qdisc_reset_all_tx_gt() vs dequeue race for lockless qdiscs
Date: Thu, 12 Mar 2026 21:10:14 +0100
Message-ID: <20260312201026.527155733@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 7f083faf59d14c04e01ec05a7507f036c965acf8 ]

When shrinking the number of real tx queues,
netif_set_real_num_tx_queues() calls qdisc_reset_all_tx_gt() to flush
qdiscs for queues which will no longer be used.

qdisc_reset_all_tx_gt() currently serializes qdisc_reset() with
qdisc_lock(). However, for lockless qdiscs, the dequeue path is
serialized by qdisc_run_begin/end() using qdisc->seqlock instead, so
qdisc_reset() can run concurrently with __qdisc_run() and free skbs
while they are still being dequeued, leading to UAF.

This can easily be reproduced on e.g. virtio-net by imposing heavy
traffic while frequently changing the number of queue pairs:

  iperf3 -ub0 -c $peer -t 0 &
  while :; do
    ethtool -L eth0 combined 1
    ethtool -L eth0 combined 2
  done

With KASAN enabled, this leads to reports like:

  BUG: KASAN: slab-use-after-free in __qdisc_run+0x133f/0x1760
  ...
  Call Trace:
   <TASK>
   ...
   __qdisc_run+0x133f/0x1760
   __dev_queue_xmit+0x248f/0x3550
   ip_finish_output2+0xa42/0x2110
   ip_output+0x1a7/0x410
   ip_send_skb+0x2e6/0x480
   udp_send_skb+0xb0a/0x1590
   udp_sendmsg+0x13c9/0x1fc0
   ...
   </TASK>

  Allocated by task 1270 on cpu 5 at 44.558414s:
   ...
   alloc_skb_with_frags+0x84/0x7c0
   sock_alloc_send_pskb+0x69a/0x830
   __ip_append_data+0x1b86/0x48c0
   ip_make_skb+0x1e8/0x2b0
   udp_sendmsg+0x13a6/0x1fc0
   ...

  Freed by task 1306 on cpu 3 at 44.558445s:
   ...
   kmem_cache_free+0x117/0x5e0
   pfifo_fast_reset+0x14d/0x580
   qdisc_reset+0x9e/0x5f0
   netif_set_real_num_tx_queues+0x303/0x840
   virtnet_set_channels+0x1bf/0x260 [virtio_net]
   ethnl_set_channels+0x684/0xae0
   ethnl_default_set_doit+0x31a/0x890
   ...

Serialize qdisc_reset_all_tx_gt() against the lockless dequeue path by
taking qdisc->seqlock for TCQ_F_NOLOCK qdiscs, matching the
serialization model already used by dev_reset_queue().

Additionally clear QDISC_STATE_NON_EMPTY after reset so the qdisc state
reflects an empty queue, avoiding needless re-scheduling.

Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260228145307.3955532-1-den@valinux.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 1e002b1dea629..75a0d6095d2eb 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -758,13 +758,23 @@ static inline bool skb_skip_tc_classify(struct sk_buff *skb)
 static inline void qdisc_reset_all_tx_gt(struct net_device *dev, unsigned int i)
 {
 	struct Qdisc *qdisc;
+	bool nolock;
 
 	for (; i < dev->num_tx_queues; i++) {
 		qdisc = rtnl_dereference(netdev_get_tx_queue(dev, i)->qdisc);
 		if (qdisc) {
+			nolock = qdisc->flags & TCQ_F_NOLOCK;
+
+			if (nolock)
+				spin_lock_bh(&qdisc->seqlock);
 			spin_lock_bh(qdisc_lock(qdisc));
 			qdisc_reset(qdisc);
 			spin_unlock_bh(qdisc_lock(qdisc));
+			if (nolock) {
+				clear_bit(__QDISC_STATE_MISSED, &qdisc->state);
+				clear_bit(__QDISC_STATE_DRAINING, &qdisc->state);
+				spin_unlock_bh(&qdisc->seqlock);
+			}
 		}
 	}
 }
-- 
2.51.0



