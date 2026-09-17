Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8471B3AA4E8;
	Thu, 17 Sep 2026 18:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668825; cv=none; b=o8AByrGulYvBKRqSZ9BkT4kEdjDnMCUiSGmtkcXIvWkkL1DbBWvLFjOyUTyS6Ds00xzcajuIr1zaSAQxhSJYKWoY9fTX+XaBBOwTs/7YVvdJGjK7THmEUGmejWcvXgct62GLlLFkBTx5R3lPU4La+hCRaA2CnThcIPJIJpcebJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668825; c=relaxed/simple;
	bh=XvwiyU1LXWfFlMpw2vi4al8RodNjQ909ecBS5t0//pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGdk+dyFhyRuR3lKo/skvLfg/5XGXt1CJGQs2Y4HwLltRqVveaeY151b8M/SnbT6vvgavMcY67NvopePVIUbKikkfKiuoOiaU6dMXLSM0mEz+EwKHzNpMP3dMJrnw86e7Od8HWfHk4HeuC+WSL8aIkm9D+EO6aRxyfRC0YTjwO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXjto2Ot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXjto2Ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5621F00893;
	Thu, 17 Sep 2026 18:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668824;
	bh=aG2USVduMO1dsDCMrkTg4au/CgftxqW5pWrCbOch/zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXjto2OtbsrMRE2IWSi5Vftg2JahJ8kCHOplawfJiDnNiRx8SaSA7pLo+grKUBIt/
	 IMGRjrhATXIr+2tn/mAqobDjlM1zie6QXVQ4j2G0z10kML0FI3qzh9wAG64XfvbdeR
	 U65mIMvnKx56uoe6JE+SRFmL1pE3sy7dMBQExp0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0516/1102] tcp: use GFP_ATOMIC in tcp_send_active_reset()
Date: Thu, 17 Sep 2026 16:07:39 +0100
Message-ID: <20260917151552.715451157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

[ Upstream commit 18666c73afe95eeca8707c699b63f96ce3acda42 ]

tcp_send_active_reset() can be called from contexts where gfp_any()
(in tcp_disconnect()) or sk->sk_allocation (in __tcp_close() and
mptcp_do_fastclose()) evaluates to GFP_KERNEL, which includes
__GFP_FS and __GFP_DIRECT_RECLAIM.

Allocating with GFP_KERNEL while holding the socket lock (sk_lock) creates
a lockdep dependency:
  sk_lock -> fs_reclaim

This causes false-positive lockdep circular locking warnings with storage
subsystems (such as nvme-tcp) that acquire socket locks in block I/O paths
and invoke tcp_disconnect() or close sockets upon teardown:
  set->srcu -> sk_lock -> fs_reclaim -> elevator_lock -> set->srcu

Active resets are small RST packet headers that should never
enter direct reclaim or block while holding socket locks.

Use sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN) inside tcp_send_active_reset()
and remove its priority argument. This preserves __GFP_MEMALLOC access
for SOCK_MEMALLOC sockets, suppresses allocation failure warnings,
and aligns with other control packet allocations (e.g. tcp_send_fin(),
__tcp_send_ack(), tcp_xmit_probe_skb()).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260827095936.551524-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h     |  3 +--
 net/ipv4/tcp.c        | 14 ++++++--------
 net/ipv4/tcp_output.c |  4 ++--
 net/ipv4/tcp_timer.c  |  6 +++---
 net/mptcp/protocol.c  |  3 +--
 net/mptcp/protocol.h  |  2 +-
 6 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 8ebaeed6217b9..aea44a4362a80 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -666,8 +666,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 void tcp_send_probe0(struct sock *);
 int tcp_write_wakeup(struct sock *, int mib);
 void tcp_send_fin(struct sock *sk);
-void tcp_send_active_reset(struct sock *sk, gfp_t priority,
-			   enum sk_rst_reason reason);
+void tcp_send_active_reset(struct sock *sk, enum sk_rst_reason reason);
 int tcp_send_synack(struct sock *);
 void tcp_push_one(struct sock *, unsigned int mss_now);
 void __tcp_send_ack(struct sock *sk, u32 rcv_nxt, u16 flags);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e44e2c97274b4..e89f9f8e32823 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3111,8 +3111,7 @@ void __tcp_close(struct sock *sk, long timeout)
 		/* Unread data was tossed, zap the connection. */
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONCLOSE);
 		tcp_set_state(sk, TCP_CLOSE);
-		tcp_send_active_reset(sk, sk->sk_allocation,
-				      SK_RST_REASON_TCP_ABORT_ON_CLOSE);
+		tcp_send_active_reset(sk, SK_RST_REASON_TCP_ABORT_ON_CLOSE);
 	} else if (sock_flag(sk, SOCK_LINGER) && !sk->sk_lingertime) {
 		/* Check zero linger _after_ checking for unread data. */
 		sk->sk_prot->disconnect(sk, 0);
@@ -3186,7 +3185,7 @@ void __tcp_close(struct sock *sk, long timeout)
 		struct tcp_sock *tp = tcp_sk(sk);
 		if (READ_ONCE(tp->linger2) < 0) {
 			tcp_set_state(sk, TCP_CLOSE);
-			tcp_send_active_reset(sk, GFP_ATOMIC,
+			tcp_send_active_reset(sk,
 					      SK_RST_REASON_TCP_ABORT_ON_LINGER);
 			__NET_INC_STATS(sock_net(sk),
 					LINUX_MIB_TCPABORTONLINGER);
@@ -3205,7 +3204,7 @@ void __tcp_close(struct sock *sk, long timeout)
 	if (sk->sk_state != TCP_CLOSE) {
 		if (tcp_check_oom(sk, 0)) {
 			tcp_set_state(sk, TCP_CLOSE);
-			tcp_send_active_reset(sk, GFP_ATOMIC,
+			tcp_send_active_reset(sk,
 					      SK_RST_REASON_TCP_ABORT_ON_MEMORY);
 			__NET_INC_STATS(sock_net(sk),
 					LINUX_MIB_TCPABORTONMEMORY);
@@ -3306,14 +3305,14 @@ int tcp_disconnect(struct sock *sk, int flags)
 	} else if (unlikely(tp->repair)) {
 		WRITE_ONCE(sk->sk_err, ECONNABORTED);
 	} else if (tcp_need_reset(old_state)) {
-		tcp_send_active_reset(sk, gfp_any(), SK_RST_REASON_TCP_STATE);
+		tcp_send_active_reset(sk, SK_RST_REASON_TCP_STATE);
 		WRITE_ONCE(sk->sk_err, ECONNRESET);
 	} else if (tp->snd_nxt != tp->write_seq &&
 		   (1 << old_state) & (TCPF_CLOSING | TCPF_LAST_ACK)) {
 		/* The last check adjusts for discrepancy of Linux wrt. RFC
 		 * states
 		 */
-		tcp_send_active_reset(sk, gfp_any(),
+		tcp_send_active_reset(sk,
 				      SK_RST_REASON_TCP_DISCONNECT_WITH_DATA);
 		WRITE_ONCE(sk->sk_err, ECONNRESET);
 	} else if (old_state == TCP_SYN_SENT)
@@ -4945,8 +4944,7 @@ int tcp_abort(struct sock *sk, int err)
 	bh_lock_sock(sk);
 
 	if (tcp_need_reset(sk->sk_state))
-		tcp_send_active_reset(sk, GFP_ATOMIC,
-				      SK_RST_REASON_TCP_STATE);
+		tcp_send_active_reset(sk, SK_RST_REASON_TCP_STATE);
 	tcp_done_with_error(sk, err);
 
 	bh_unlock_sock(sk);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index d08b50b858756..e41ce37747930 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3642,9 +3642,9 @@ void tcp_send_fin(struct sock *sk)
  * was unread data in the receive queue.  This behavior is recommended
  * by RFC 2525, section 2.17.  -DaveM
  */
-void tcp_send_active_reset(struct sock *sk, gfp_t priority,
-			   enum sk_rst_reason reason)
+void tcp_send_active_reset(struct sock *sk, enum sk_rst_reason reason)
 {
+	gfp_t priority = sk_gfp_mask(sk, GFP_ATOMIC | __GFP_NOWARN);
 	struct sk_buff *skb;
 
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTRSTS);
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index a58094b0acd4f..1af9235fe5aec 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -125,7 +125,7 @@ static int tcp_out_of_resources(struct sock *sk, bool do_reset)
 		    (!tp->snd_wnd && !tp->packets_out))
 			do_reset = true;
 		if (do_reset)
-			tcp_send_active_reset(sk, GFP_ATOMIC,
+			tcp_send_active_reset(sk,
 					      SK_RST_REASON_TCP_ABORT_ON_MEMORY);
 		tcp_done(sk);
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONMEMORY);
@@ -783,7 +783,7 @@ static void tcp_keepalive_timer (struct timer_list *t)
 				goto out;
 			}
 		}
-		tcp_send_active_reset(sk, GFP_ATOMIC, SK_RST_REASON_TCP_STATE);
+		tcp_send_active_reset(sk, SK_RST_REASON_TCP_STATE);
 		goto death;
 	}
 
@@ -810,7 +810,7 @@ static void tcp_keepalive_timer (struct timer_list *t)
 		    icsk->icsk_probes_out > 0) ||
 		    (user_timeout == 0 &&
 		    icsk->icsk_probes_out >= keepalive_probes(tp))) {
-			tcp_send_active_reset(sk, GFP_ATOMIC,
+			tcp_send_active_reset(sk,
 					      SK_RST_REASON_TCP_KEEPALIVE_TIMEOUT);
 			tcp_write_err(sk);
 			goto out;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8b61fe656ec66..a4054ed246052 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2900,8 +2900,7 @@ static void mptcp_do_fastclose(struct sock *sk)
 		 */
 		inet_csk(ssk)->icsk_ack.rcv_mss = TCP_MIN_MSS;
 
-		tcp_send_active_reset(ssk, ssk->sk_allocation,
-				      SK_RST_REASON_TCP_ABORT_ON_CLOSE);
+		tcp_send_active_reset(ssk, SK_RST_REASON_TCP_ABORT_ON_CLOSE);
 unlock:
 		release_sock(ssk);
 	}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 36f3f5b34a5d6..2ac28f6ddff5b 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -646,7 +646,7 @@ mptcp_send_active_reset_reason(struct sock *sk)
 	enum sk_rst_reason reason;
 
 	reason = sk_rst_convert_mptcp_reason(subflow->reset_reason);
-	tcp_send_active_reset(sk, GFP_ATOMIC, reason);
+	tcp_send_active_reset(sk, reason);
 }
 
 static inline u64
-- 
2.53.0



