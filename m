Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585825;
	b=tVDscRvBubMDOfeNZk1yOhKDTDrMzrQI5wv+VaY93xQw/gz3Ozbgr03dzfnLH5d0o/bt
	 leIznnxrvb8O3QHIExz+VdJyOEFahP2dveMgRJNPEEoCOvD9UuVb4TAjmaVFFvuWXZn4o
	 Xr5S5cFr3ir7qPbSDbS5pwUFuIArCn+gnbzC3H8kdQrxzWTSrIj/j7uosyrRNSOhs+6xu
	 esnV8W/B5kxBC1+4fyOaf3/IvVMc0km9xsXZ+iioIjRrO9yqGqQH9vvcB7/n/zK1Gc9d6
	 RZm336ML64kjxzoeu+7R3A75XYSzB7XqNvkJZRp1IwUvk3JlBKswCcuxxX3VRJnvd/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ANOu1gY07qxrEE9rVPgAVzdvI1bCdjD+jP2To0FCjE0=;
	b=eoSpAStkZcMaj2gMgjjk9h8BX24lEMhT51GZNnpgraajNmJ1twbUeng0BttMDRNKhLf/
	 prwcEgIjqv+odgIEwvKNxiYqNRdr6qHyIJgtmrH9QxIYPn+Yzu8sKgiwja4CvX22zcIaS
	 +qyhM5/7SMHI8flOqWAdeNR8M/eii2Zt+jHBAUiXzGI5wB7b2TG7et2NZR86hwFg5WqBz
	 Y/Z5DmboinJRYngaVjB1Q2w7g0uQtowGmUq7HaqmU/TXYYdVSqgsIC7p6esLRYA6169Ay
	 N0tvsAaOF0YwAG2IzfLVGPJ0weKJJTFS1zB9x0LUkjjcXMAJMooWlIuE28xa7y4e9VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L7eEtTdP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535CC606BAA6;
	Fri, 13 Nov 2026 16:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L7eEtTdP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40B71F000C5;
	Fri, 13 Nov 2026 16:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585825;
	bh=ANOu1gY07qxrEE9rVPgAVzdvI1bCdjD+jP2To0FCjE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7eEtTdPcROIbg7LeAoYvBJ4cqFJOjQCWbqGoN6vP+IyI3YARFq4Yrt/HVFVfisQs
	 Q1dNfA/gAXbVEuj+25Oj6bJcEWHsRvO0hEnhfkuf2bX+CeY5NTRqRfakOOLujRUIPB
	 FSBowVc2T80gcomhMHdaRIAFOf0clrgqDeS//LY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Zhang <sgzhang@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 405/507] net: count last skb of each sk_backlog pass in __release_sock()
Date: Fri, 13 Nov 2026 10:51:49 -0500
Message-ID: <20261113153810.468306181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e8551df8330ff..1108543f9fec5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3262,7 +3262,7 @@ void __release_sock(struct sock *sk)
 
 		spin_unlock_bh(&sk->sk_lock.slock);
 
-		while (1) {
+		do {
 			next = skb->next;
 			prefetch(next);
 			DEBUG_NET_WARN_ON_ONCE(skb_dst_is_noref(skb));
@@ -3270,12 +3270,10 @@ void __release_sock(struct sock *sk)
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



