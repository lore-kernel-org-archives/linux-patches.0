Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F3B47127A;
	Tue, 21 Jul 2026 18:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660020; cv=none; b=CGtnxzU4/IER1gvp1JtNGjntR8oqsWWAjWLOW9dmNqM52rwCqiG6IuZKvK9Xs3XnLhtFH5X7CgXr9Sxp8NSGxoeJ7OJ+N4RjQo7GMV4X83aQ88XiRYFNo9BYaNiosARQUS4WYAK5Qzsswc94crnmgnYcHqPqSbQ5qw4Xz8ZlYcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660020; c=relaxed/simple;
	bh=3s/Tk4n5DsuNC2X3icPFsNmaCcfaYD3xHp2+duKqbww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dji92WO9POfRiv17IH9TUgA7fbalNA90U0LfSAY/yStGNL3DpZrJ36Km9YWfirpvuhEVcdqC/MAI/pFN4WPksyedFummdmDeTOAxCg+WToVo1e8KVXgb1sq3C+8KlLpN2J/ZXsnI7j0KNnWfpcSgo3VoRyS8Y29QivkhRlS2Whw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6cTvE4q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6cTvE4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3138A1F000E9;
	Tue, 21 Jul 2026 18:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660019;
	bh=bh21kkO1whVqUMpSwLBMpxc/Ns03K49c0nmg6JBgfVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6cTvE4qGt38t5ska6NLJc6u5A32Pe4WlQvocq6FsswrmDFco5VJ/nnBkyX81yatB
	 Kx/TTiVEWEpP1ZpJbisp9kCp3al4QN1LJSE1RjRfgXzI7QhaRH+ultbnxjqUogy2sn
	 bGt1x7bt7MqXHLsIy6UP94uA7ka0Z/FJMIEzDm0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+965506b59a2de0b6905c@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Julian Anastasov <ja@ssi.bg>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0819/2077] net: serialize netif_running() check in enqueue_to_backlog()
Date: Tue, 21 Jul 2026 17:08:12 +0200
Message-ID: <20260721152612.108691717@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 46762cefe7f4e5bffc1eb467810a7bbb02e461d7 ]

Syzbot reported a KASAN slab-use-after-free in fib_rules_lookup().

The root cause is a race condition where packets can escape the backlog
flushing during device unregistration (e.g., during netns exit).

Commit e9e4dd3267d0 ("net: do not process device backlog during unregistration")
introduced a lockless netif_running() check in enqueue_to_backlog() to
prevent queuing packets to an unregistering device.

However, this creates a TOCTOU race window.

A lockless transmitter (like veth_xmit) can pass
the check before dev_close() clears IFF_UP. If the transmitter is then
delayed, flush_all_backlogs() can run and finish before the transmitter
grabs the backlog lock and queues the packet. The packet then escapes
the flush and triggers UAF later when processed.

Fix this by moving the netif_running() check inside the backlog lock.
This serializes the check with the flush work (which also grabs the lock).
We then either queue the packet before the flush runs (so it gets flushed),
or check netif_running() after the flush/close completes (so it gets dropped).

Fixes: e9e4dd3267d0 ("net: do not process device backlog during unregistration")
Reported-by: syzbot+965506b59a2de0b6905c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a315824.b0403584.28d0ff.0000.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Julian Anastasov <ja@ssi.bg>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260616141317.407791-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 731e661d7be657..f81ce83fb3250d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5381,8 +5381,6 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	u32 tail;
 
 	reason = SKB_DROP_REASON_DEV_READY;
-	if (unlikely(!netif_running(skb->dev)))
-		goto bad_dev;
 
 	sd = &per_cpu(softnet_data, cpu);
 
@@ -5394,6 +5392,10 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	backlog_lock_irq_save(sd, &flags);
 	qlen = skb_queue_len(&sd->input_pkt_queue);
 	if (likely(qlen <= max_backlog)) {
+		if (unlikely(!netif_running(skb->dev))) {
+			backlog_unlock_irq_restore(sd, flags);
+			goto bad_dev;
+		}
 		if (!qlen) {
 			/* Schedule NAPI for backlog device. We can use
 			 * non atomic operation as we own the queue lock.
-- 
2.53.0



