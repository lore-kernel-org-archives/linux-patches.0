Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590490;
	b=l70HuNntjV+pFoq0hJuzdqDjkp0z66X9sUKHNQGlEcjMsHTb3HMFhlvHrvinvsq1fkXX
	 jU9j6vdqpJVwB2cBdYO+vXUei3/VPoxg/bfaO8SPy4o5uhECXJY6s/KMXQUjXrTTFrFO0
	 +pQV78PDLmrMQ1fM8Dg4EnjDW4YV84vijjcclBGugMi0EY5WcUNI9/PYFx55Vz2rONkX1
	 MyIQSXIVUkqeFDTV7003ejC7X1XtyUaPIDiBXHjv0vyYbQZBwITXKDcfkE83LZfzL+Bqv
	 DBBuEuSYwCi3a6HQ9+GZHzwfIDda+Boaogqh9pCb58SCwzOKc6fpuJaai5JcQWp4RDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IJ6AO+k4gvREq4WVT3cAF/j/r+YWRexswUUZeqqwBVo=;
	b=ULP3RJOfj8r8kEtwQa4fCjQFOJUaxS9KuglW5b+oxnUParuJTQF6wx5wQtDDX8fwoMDK
	 dL4WWUowd27Hwd5mYDJ3vo2BPc3Z6eLBWy9V0taphgP2o0El7WV6N5Q6Awb1VNN7PUxvn
	 0fsrwpGh6EM4F8T9IlOfbN//jp2HR9KCNZQTKnhwYJPm5qzr91wyri08fw5BbbmdoH+cU
	 EMsHnbpVan5T8oKLf6tNnL7A8N8SJgzi8mkgLK0MaGP3VAsG89m2jaie5D7EN9LknUFi0
	 pouM4i8I8oFhu9MLKPTYSO2bY4qAx/vBUAnr4QN35DiV4SgLNIRq8Vax89aj1x/VhCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0duAbvqw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3A3606B833;
	Fri, 13 Nov 2026 17:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0duAbvqw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2811F000C6;
	Fri, 13 Nov 2026 17:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590490;
	bh=IJ6AO+k4gvREq4WVT3cAF/j/r+YWRexswUUZeqqwBVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0duAbvqwE8Sssry7U3VDIRlUTZNgOeYLrGwBnzr6LbbyG53nRLFMea5J8oANTEDuZ
	 R7q218zj6xLySDUlGKvQTKjp3jDK+GrHUaoCQsXIl+rAeZZv5AcGtEcG6Z7oC6n5cQ
	 lE9Ze7TZQ94gxAWPrk2CoPosOv5F2hrBm0JjbAls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Zhang <sgzhang@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 439/686] net: count last skb of each sk_backlog pass in __release_sock()
Date: Fri, 13 Nov 2026 10:49:32 -0500
Message-ID: <20261113153835.771261661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 03136176c7d0f..486989dfaaeee 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3185,7 +3185,7 @@ void __release_sock(struct sock *sk)
 
 		spin_unlock_bh(&sk->sk_lock.slock);
 
-		while (1) {
+		do {
 			next = skb->next;
 			prefetch(next);
 			DEBUG_NET_WARN_ON_ONCE(skb_dst_is_noref(skb));
@@ -3193,12 +3193,10 @@ void __release_sock(struct sock *sk)
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



