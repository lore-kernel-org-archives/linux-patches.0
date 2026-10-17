Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DC138654F;
	Sat, 17 Oct 2026 16:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254464; cv=none; b=ATYJLrba9GK3sckfJX5Q8Az+T21EOfE3eC5UkxiPG1Hf6jlynGKBosf9aKVot/tZlObg225e5oYDmfmS/C7N+cZxkVu2GRvFrvm6U4VxH88vOpG8afdskMTqCew3er8TyVK/psfahAL3PgMKHfrXtDRgTm+RNCknPCHMfq5YmQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254464; c=relaxed/simple;
	bh=owSUUUUcRSPdd6FTgX/qSeZD1o6ak25Moa/V7y2Bsq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZBA/UX/xaE/z8/8PPW35iPEKHX4c4OhzIDalwkdXf2+1kG4p3SieX4EO8CJsFG/m33q+Lf20RjSaGHskk7v63SQ0y3wrQLss+KixKrt/gPI/hTzTj3cn9Ak+c1zcoCk+J53azOck60BUVfsXA6zNhPtFpP/5ZJqwUIn/MnHlWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZN3QCnaY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZN3QCnaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867631F000C4;
	Sat, 17 Oct 2026 16:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254463;
	bh=dobHPcC+J+X+KufTTUmXrxkBVtwCNdAOtLhqzvLbaOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZN3QCnaYzXyr/ThpXBG4QHbwUJ/S1ukxDHG6Lij33qPFrUOtQqZe3xMh5U0fy0mIa
	 81gX+5cPUAP3M7Y1Z2Xdx3+TZ8UU8RiVCZZ6uxCu9jfvax+w5eklMegOi6kL4INuTv
	 jBU7ooIhZPd0MehOfauOi4Oces+kDXiP28OibW5c=
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
Subject: [PATCH 6.12 454/869] net: serialize netif_running() check in enqueue_to_backlog()
Date: Sat, 17 Oct 2026 17:54:55 +0200
Message-ID: <20261017160048.778513519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 net/core/dev.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 388770b88b449..2c058f6a59159 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5041,10 +5041,6 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	int max_backlog;
 	u32 tail;
 
-	reason = SKB_DROP_REASON_DEV_READY;
-	if (!netif_running(skb->dev))
-		goto bad_dev;
-
 	reason = SKB_DROP_REASON_CPU_BACKLOG;
 	sd = &per_cpu(softnet_data, cpu);
 
@@ -5055,6 +5051,11 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	backlog_lock_irq_save(sd, &flags);
 	qlen = skb_queue_len(&sd->input_pkt_queue);
 	if (qlen <= max_backlog && !skb_flow_limit(skb, qlen)) {
+		if (unlikely(!netif_running(skb->dev))) {
+			backlog_unlock_irq_restore(sd, &flags);
+			reason = SKB_DROP_REASON_DEV_READY;
+			goto bad_dev;
+		}
 		if (!qlen) {
 			/* Schedule NAPI for backlog device. We can use
 			 * non atomic operation as we own the queue lock.
-- 
2.53.0



