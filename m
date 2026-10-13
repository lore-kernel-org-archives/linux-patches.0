Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7224FC8DC;
	Tue, 13 Oct 2026 12:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893670; cv=none; b=hNX/wRK6sUdvzEgm9kAuOG1q9Wr2MmNyjDhaKySGfoXulIYJZj6/7hJZQVHBXB03ablF9Z+KlBPVsIuhd2pB4/W53k1/3w0QsiXgnqU7bah9y0ApgY4+pKX07hUUW3O4ZzO+s20YLOp9Er98rjgfSO8q4sgFWkFfiBAzaol9Ssg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893670; c=relaxed/simple;
	bh=a72rBHzO/tX8QC0oeQmT+OLf4y22LxPNR7f/QIpAaGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pah2NDgCBamZDV+hBFPAfD6yRPVLRXn6R1AJyKlTwDkVfvvzCHyPR7w0ZeTkWPHvJW9m2m8j74yN/QIiJBu01ocA8xw+6aXzBaQH7UnJz6Jc+TLl4DlKN6/RF1XQ7ahPGiQcl0Qj+LN0JwDAHPhPkdsmE2TTnwfNMEBb0/6XSPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4Yq9b4e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4Yq9b4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839AE1F000FF;
	Tue, 13 Oct 2026 12:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893669;
	bh=xyjlBkYmS2/4mzZT83IazWFG5O7wrbCn3m+QDEWWCUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4Yq9b4eUd0fHqyncpvnXVU0+rwwyE6XqkaCDsvXk93UGillhqPSn1ZljsW/UhggI
	 A9TbJG8qFN2gbJJwLgjlCmxzTKIg6OqEKHf1brb12VEfur1zolzr2GdZ9dL9TqrnVl
	 f2KUAafpuiIpzAmgkZzJuVfANrzgo9ESYB7wwYmg=
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
Subject: [PATCH 6.18 296/621] net: serialize netif_running() check in enqueue_to_backlog()
Date: Tue, 13 Oct 2026 13:34:51 +0200
Message-ID: <20261013112927.880672853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 922c4794b8403..b963fe9bd73ec 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5334,8 +5334,6 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	u32 tail;
 
 	reason = SKB_DROP_REASON_DEV_READY;
-	if (unlikely(!netif_running(skb->dev)))
-		goto bad_dev;
 
 	sd = &per_cpu(softnet_data, cpu);
 
@@ -5347,6 +5345,10 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
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



