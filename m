Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D3130BF6D;
	Sat, 25 Oct 2025 16:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409087; cv=none; b=SXk2Itqy+EVoN1my7NlhrQuCq6yPHpUIBKZMZXBnJWzckap8MExBe15dMVf2NzZRMLAFKPhG8gm8r3/3hfsI8P6AAotepnexFodxsomRA+WCZrLCZmLFCoymRnabi2sa3H6EfpEif8s0NirGRimomK6N7XvmULi6JAo1Bm2iadk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409087; c=relaxed/simple;
	bh=F8AsG/4+XfCTQJf0HBAxhqf0XZKc4nx3Wo8S/ayfLr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l4/RPx7sNC/dPUCpLJoHfyyMHLdp0CfF9FnNHppFeFHVVFUiMsw6TZfjOboy9KVB5bvr9K5q6VzMcujZlrouNgEfL/obm6VwbRc6KVRCooX6Xt5R+LOvf3hgeipz7SnB3G0NKBoFMKI4YSw0M/06COvJJxU+el3PUj/LunC3Jso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjjkv7y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjjkv7y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A107CC113D0;
	Sat, 25 Oct 2025 16:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409087;
	bh=F8AsG/4+XfCTQJf0HBAxhqf0XZKc4nx3Wo8S/ayfLr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjjkv7y/KvQ1VDIqaXsrQvFueXmRBL0HGNDsh3GFwKUrUO3Wffozm6c+cZ8oC1NU5
	 jml0vrCwQ1JcxZiiOsR41XtNu25F+eMWiphP3obpyedp178HTTL6Rbt62jWeky8AfB
	 qSlpWVjrKGGaw2EdAVrAY41Vm58ldlBv/y+TJ80wiw7QEWIwu/KhnPDHrKRXdbQRCL
	 gR+MdqbEcTRClS/oZJN+ao9EzQK5xYxUrKh1hu+RUiPsFYnD1sUEQmk9FejW8CTsv2
	 i179+Pcaj5WMEsXKCPq5CWwRDh0TWO/SkfBVlYRjWrrGKRE0WjIC770Ul+BOvq82aI
	 DFHOvMHnPdTDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	pabeni@redhat.com,
	willemb@google.com
Subject: [PATCH AUTOSEL 6.17-5.4] net: call cond_resched() less often in __release_sock()
Date: Sat, 25 Oct 2025 11:57:09 -0400
Message-ID: <20251025160905.3857885-198-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 16c610162d1f1c332209de1c91ffb09b659bb65d ]

While stress testing TCP I had unexpected retransmits and sack packets
when a single cpu receives data from multiple high-throughput flows.

super_netperf 4 -H srv -T,10 -l 3000 &

Tcpdump extract:

 00:00:00.000007 IP6 clnt > srv: Flags [.], seq 26062848:26124288, ack 1, win 66, options [nop,nop,TS val 651460834 ecr 3100749131], length 61440
 00:00:00.000006 IP6 clnt > srv: Flags [.], seq 26124288:26185728, ack 1, win 66, options [nop,nop,TS val 651460834 ecr 3100749131], length 61440
 00:00:00.000005 IP6 clnt > srv: Flags [P.], seq 26185728:26243072, ack 1, win 66, options [nop,nop,TS val 651460834 ecr 3100749131], length 57344
 00:00:00.000006 IP6 clnt > srv: Flags [.], seq 26243072:26304512, ack 1, win 66, options [nop,nop,TS val 651460844 ecr 3100749141], length 61440
 00:00:00.000005 IP6 clnt > srv: Flags [.], seq 26304512:26365952, ack 1, win 66, options [nop,nop,TS val 651460844 ecr 3100749141], length 61440
 00:00:00.000007 IP6 clnt > srv: Flags [P.], seq 26365952:26423296, ack 1, win 66, options [nop,nop,TS val 651460844 ecr 3100749141], length 57344
 00:00:00.000006 IP6 clnt > srv: Flags [.], seq 26423296:26484736, ack 1, win 66, options [nop,nop,TS val 651460853 ecr 3100749150], length 61440
 00:00:00.000005 IP6 clnt > srv: Flags [.], seq 26484736:26546176, ack 1, win 66, options [nop,nop,TS val 651460853 ecr 3100749150], length 61440
 00:00:00.000005 IP6 clnt > srv: Flags [P.], seq 26546176:26603520, ack 1, win 66, options [nop,nop,TS val 651460853 ecr 3100749150], length 57344
 00:00:00.003932 IP6 clnt > srv: Flags [P.], seq 26603520:26619904, ack 1, win 66, options [nop,nop,TS val 651464844 ecr 3100753141], length 16384
 00:00:00.006602 IP6 clnt > srv: Flags [.], seq 24862720:24866816, ack 1, win 66, options [nop,nop,TS val 651471419 ecr 3100759716], length 4096
 00:00:00.013000 IP6 clnt > srv: Flags [.], seq 24862720:24866816, ack 1, win 66, options [nop,nop,TS val 651484421 ecr 3100772718], length 4096
 00:00:00.000416 IP6 srv > clnt: Flags [.], ack 26619904, win 1393, options [nop,nop,TS val 3100773185 ecr 651484421,nop,nop,sack 1 {24862720:24866816}], length 0

After analysis, it appears this is because of the cond_resched()
call from  __release_sock().

When current thread is yielding, while still holding the TCP socket lock,
it might regain the cpu after a very long time.

Other peer TLP/RTO is firing (multiple times) and packets are retransmit,
while the initial copy is waiting in the socket backlog or receive queue.

In this patch, I call cond_resched() only once every 16 packets.

Modern TCP stack now spends less time per packet in the backlog,
especially because ACK are no longer sent (commit 133c4c0d3717
"tcp: defer regular ACK while processing socket backlog")

Before:

clnt:/# nstat -n;sleep 10;nstat|egrep "TcpOutSegs|TcpRetransSegs|TCPFastRetrans|TCPTimeouts|Probes|TCPSpuriousRTOs|DSACK"
TcpOutSegs                      19046186           0.0
TcpRetransSegs                  1471               0.0
TcpExtTCPTimeouts               1397               0.0
TcpExtTCPLossProbes             1356               0.0
TcpExtTCPDSACKRecv              1352               0.0
TcpExtTCPSpuriousRTOs           114                0.0
TcpExtTCPDSACKRecvSegs          1352               0.0

After:

clnt:/# nstat -n;sleep 10;nstat|egrep "TcpOutSegs|TcpRetransSegs|TCPFastRetrans|TCPTimeouts|Probes|TCPSpuriousRTOs|DSACK"
TcpOutSegs                      19218936           0.0

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250903174811.1930820-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Addresses real-world retransmits, TLP/RTO timeouts, SACK/DSACK
    bursts under load when a single CPU handles multiple high-throughput
    TCP flows. The root cause is overly frequent voluntary scheduling in
    the socket backlog flush path while the socket remains “owned by
    user,” delaying backlog/receive-queue draining and provoking peer
    timeouts. This is a user-visible correctness/performance issue, not
    a pure optimization.

- Scope and change details
  - Single, small adjustment confined to `__release_sock()` in
    `net/core/sock.c`.
  - Before: `cond_resched()` runs after every packet in the backlog
    processing loop, which can cause long delays if the task does not
    get CPU back promptly while still holding the socket ownership.
    - Reference: `net/core/sock.c:3165-3187` (pre-change), unconditional
      `cond_resched()` between `sk_backlog_rcv()` and advancing `skb`.
  - After: throttle voluntary reschedule to once per 16 packets.
    - Adds a local counter: `int nb = 0;` at `net/core/sock.c:3165`.
    - Replaces the `do { ... } while (skb != NULL);` with a `while (1) {
      ... if (!skb) break; }` loop (`net/core/sock.c:3170`).
    - Gates rescheduling: `if (!(++nb & 15)) cond_resched();`
      (`net/core/sock.c:3181`).
    - The `cond_resched()` remains correctly placed outside the spinlock
      region (the code still `spin_unlock_bh()` before the loop and
      `spin_lock_bh()` after), so there is no locking semantic change.
    - `sk->sk_backlog.len = 0;` zeroing remains unchanged to ensure no
      unbounded loops (`net/core/sock.c:3185-3187` vicinity).

- Why it’s safe
  - Minimal behavioral change: still voluntarily yields in long loops,
    just less frequently (once per 16 SKBs) to avoid pathological delays
    that leave the socket owned and backlog unprocessed.
  - No API or architectural changes; no protocol semantics touched. The
    processing order and lock/unlock pattern around the backlog remain
    the same.
  - `cond_resched()` has no effect unless needed; reducing its frequency
    only affects voluntary yield cadence, not correctness. Preemption-
    enabled kernels are largely unaffected; non-preemptible builds still
    get periodic relief.
  - Generic applicability: while motivated by TCP, `__release_sock()` is
    generic and the change is neutral/beneficial for other protocols
    using the backlog path.

- Stable backport criteria
  - Fixes an important user-visible bug (spurious
    retransmits/RTOs/DSACK) under realistic load.
  - Touches a critical path but with a very small, contained change.
  - No new features or interfaces; no architectural refactor.
  - Low regression risk; preserves fairness via periodic
    `cond_resched()`.

- Dependencies and interactions
  - The commit references “tcp: defer regular ACK while processing
    socket backlog” as context; the throttling of `cond_resched()` does
    not depend on that change to be correct and remains beneficial
    independently.
  - Call sites like `__sk_flush_backlog()` remain unchanged and continue
    to call into `__release_sock()` with the same locking protocol
    (`net/core/sock.c:3189-3199`).

Given the above, this is a focused, low-risk bug fix with clear impact
on correctness/performance under load and should be backported to stable
trees.

 net/core/sock.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 1382bddcbaff4..bdeea7cc134df 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3162,23 +3162,27 @@ void __release_sock(struct sock *sk)
 	__acquires(&sk->sk_lock.slock)
 {
 	struct sk_buff *skb, *next;
+	int nb = 0;
 
 	while ((skb = sk->sk_backlog.head) != NULL) {
 		sk->sk_backlog.head = sk->sk_backlog.tail = NULL;
 
 		spin_unlock_bh(&sk->sk_lock.slock);
 
-		do {
+		while (1) {
 			next = skb->next;
 			prefetch(next);
 			DEBUG_NET_WARN_ON_ONCE(skb_dst_is_noref(skb));
 			skb_mark_not_on_list(skb);
 			sk_backlog_rcv(sk, skb);
 
-			cond_resched();
-
 			skb = next;
-		} while (skb != NULL);
+			if (!skb)
+				break;
+
+			if (!(++nb & 15))
+				cond_resched();
+		}
 
 		spin_lock_bh(&sk->sk_lock.slock);
 	}
-- 
2.51.0

