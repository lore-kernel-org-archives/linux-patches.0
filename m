Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046506;
	b=ls0HMNLqXbstt5xcgqi0sn4ICT4YnKYQ0OTTkvEdTV3PeWPlx3LyN/RIBKc3qeemgGxE
	 1TfU0JT7zywGemlvOafpvUtoMuzc8lQTVttZVHHukhdsNXdhX6N6sAao+nV3dCxi5TGeK
	 gs7ivmpY1OicF9jsT8U3kztDWfnhS+XbkYKxmtZkKwRO2CEutviFPRUlsz0e7d1E4ZUh/
	 5JAP081Qr4dcC0ozjFyDBAh5Ykl/gT7LZEV7uM0ynzbNGvGbdICnuheqVN/MjzKPnJqc1
	 WNgFf9rPS7QuI/bVdCYqLDz2PJ/Ag8BkafG14sNZfAJn527eChS+TRmCFXn6eu/tJfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r/QjOrSdIJRJP0rakn/9JYz5kyDqAa5u8/t6SFQ3Gh4=;
	b=0STNcyChVPbC5uIHlSrP09npReTjugdGGCECoOH7jey1JzeDadckGTXrFVI4vAKbyP6v
	 avL2raKxBp7qred4LFa80BdySSGzLz3GsxwCurqOVwXVqmT+SBkuIT46qAVjqd/5uCoLq
	 lJRW9voTim8QYd3HNYHoePQBgbA6xQyppbcqMXdEQsUMKbuA+5ioXskvOeB+RL+/HzFZA
	 W4kfPjAXB6JE5gkasoFr/YbrPQoMdOYSO4ohyvz9UKgIlhdTgtuJU18pTnjd/zsgaiYTY
	 23srEyJo0NBnHtBmOUijKRzR2pq3+3Zgw3RBSZEEdABtGD0Z6BMvJP99WE+1/Oh5Knw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQgqLUBn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BB2606A31C;
	Thu, 19 Nov 2026 00:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQgqLUBn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442761F000C4;
	Thu, 19 Nov 2026 00:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046505;
	bh=r/QjOrSdIJRJP0rakn/9JYz5kyDqAa5u8/t6SFQ3Gh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQgqLUBnI1Qep4SLs9rDS7WMvJVjMXwGGgSyA2zAGzFY8kSg34QiWDw1V/Vyy80b+
	 vrRIEvXr5jEIUPG9B8bOumFLjNSProQ/45iLT/GxhTrUVfrrkfDNvQxTM/2+ygJueh
	 eFQrU0YwZdq8QjAVbE+6lEKfFjagwo3OvT28OEGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Zhang <sgzhang@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1306/2857] net: count last skb of each sk_backlog pass in __release_sock()
Date: Wed, 18 Nov 2026 15:39:00 +0100
Message-ID: <20261118150248.495398821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ray Zhang <sgzhang@google.com>

[ Upstream commit c4e4056b21355356f6a95bcdf03a850edd9f49e7 ]

Running 500 concurrent TCPv6 streams (neper "tcp_stream -6 -T 1 -F 500")
on a 2-core Cortex-A53 (CONFIG_PREEMPT_NONE=y, HZ=1000, LATENCY_WARN)
triggers resched_latency_warn() in __release_sock():

  [ 3655.311821] sched: CPU 0 need_resched set for > 100006892 ns (100 ticks) without schedule
  [ 3655.311889] Call trace:
  ...
  [ 3655.311944]  resched_latency_warn+0x7c/0x88
  [ 3655.311958]  sched_tick+0x1c0/0x418
  ...
  [ 3655.312578]  net_rx_action+0x238/0x438
  ...
  [ 3655.312641]  do_softirq+0x4c/0x90
  [ 3655.312651]  __local_bh_enable_ip+0x84/0x90
  [ 3655.312663]  local_bh_enable+0x1c/0x28
  [ 3655.312674]  __dev_queue_xmit+0x4a8/0xb00
  ...
  [ 3655.312782]  tcp_v6_do_rcv+0x240/0x5f8
  [ 3655.312793]  __release_sock+0x9c/0x188
  [ 3655.312806]  release_sock+0x150/0x168
  [ 3655.312817]  tcp_sendmsg+0x4c/0x70

__release_sock() can loop past 100 ms without calling cond_resched():

- Each outer-loop pass drains sk_backlog, but "if (!skb) break;" runs
  before "++nb", so a pass of B skbs only adds B - 1 to nb (0 for 1 skb).
- With 500 TCPv6 streams and NAPI sharing two Cortex-A53 cores, runnable
  tasks keep TIF_NEED_RESCHED set on CPU 0.
- During spin_unlock_bh() and TX softirqs (__dev_queue_xmit() ->
  local_bh_enable()), tcp_add_backlog() coalesces arriving pure ACKs into
  a single tail skb.
- Repeated 1-skb passes never advance nb or call cond_resched(),
  triggering resched_latency_warn() after 100 ticks.

Restore the do-while loop and drop "if (!skb) break;" so every skb
increments nb across passes and calls cond_resched() every 16 skbs.

Reproduced the issue and verified the fix on two 2-core Cortex-A53 hosts
(CONFIG_PREEMPT_NONE=y, HZ=1000, LATENCY_WARN, latency_warn_once=0) with
a userspace reproducer over /dev/net/tun:

- CPU 0 runs a TCPv6 sender and a second runnable task while CPU 1 writes
  pure ACKs to /dev/net/tun (~30k TCPBacklogCoalesce/run), sustaining
  1-skb sk_backlog refills in __release_sock() for ~400 ms (ftrace).
- Before: CPU 0 stayed unscheduled in __release_sock(), hitting
  resched_latency_warn() 293 and 275 times on the two hosts (> 100.9 ms).
- After: cond_resched() yielded CPU 0 inside __release_sock(), with
  0 resched_latency_warn() hits on both hosts.
- Also observed no regression with the workload from
  commit 16c610162d1f ("net: call cond_resched() less often in
  __release_sock()"), "super_netperf 4 -H srv -T,10 -l 3000 &".

Fixes: 16c610162d1f ("net: call cond_resched() less often in __release_sock()")
Cc: stable@vger.kernel.org
Signed-off-by: Ray Zhang <sgzhang@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261101075145.698399-1-sgzhang@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index d05c0cb1e52e2..211eb9ba9a29a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2968,7 +2968,7 @@ void __release_sock(struct sock *sk)
 
 		spin_unlock_bh(&sk->sk_lock.slock);
 
-		while (1) {
+		do {
 			next = skb->next;
 			prefetch(next);
 			DEBUG_NET_WARN_ON_ONCE(skb_dst_is_noref(skb));
@@ -2976,12 +2976,10 @@ void __release_sock(struct sock *sk)
 			sk_backlog_rcv(sk, skb);
 
 			skb = next;
-			if (!skb)
-				break;
 
 			if (!(++nb & 15))
 				cond_resched();
-		}
+		} while (skb);
 
 		spin_lock_bh(&sk->sk_lock.slock);
 	}
-- 
2.53.0



