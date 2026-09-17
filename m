Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A354ABBC6;
	Thu, 17 Sep 2026 17:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665178; cv=none; b=Y1Wki3+E372/5/v7/txJQX145gNpHtH5DE1Aur74spkihCn9SDl0WFH+mmu/5bJV2JvvNt5Vm5Qfda4UvhN7iHQctYxsOfD9TcKTnyrWnYWZVES+hiB9BHFu1eGkqdp2flGMWmzrwYM1VfbItBcT8UbL28vyD2IpN/kiFb/p22c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665178; c=relaxed/simple;
	bh=jZRvSB5HffgYqR8zT8NJfwGqJJdz++M+YabvYrxBiko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABdKtglVX2wvBFsz0w0T59VCEVNe1DMK2fde1iRrCk5WWp7tI97J6hueivsurXo6HC8SMzBe+BIaFdGuI6Qc2WqFGNHfO95LLYgMhwbb7Es6JxriAvOSpu+kfWwiFHtZygJarPZY9Syn11HdmFdmv4EzCiErSsBuKLZfJ7E+txk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mG8kHICk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mG8kHICk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A3B1F00893;
	Thu, 17 Sep 2026 17:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665177;
	bh=mL61xkG/+b4EgGgdtuUqf0LpQC2an0ZUNhul3KLJoS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mG8kHICkKxxnhblSoj+Us5wND8OUsB5qIETy+seaby1+8W465A0lVEElMa5ZMiCAw
	 S9hfiBdtXAQhBIG3KPD5uyxY61ePzAd+apgyy5fFgKZe5GF0R5TeT26bAIbt1TJ1oF
	 zyqR4Dyq39PNoRQfArEkhLU9NouBiJWdcGgqYWWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0619/1250] tcp: use GFP_ATOMIC in tcp_send_active_reset()
Date: Thu, 17 Sep 2026 16:06:54 +0100
Message-ID: <20260917151608.652168239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 25bb67e28ad47..12a9672f56eb5 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -731,8 +731,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
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
index 53700d6f6f280..8c0ffe50ae5d0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3166,8 +3166,7 @@ void __tcp_close(struct sock *sk, long timeout)
 		/* Unread data was tossed, zap the connection. */
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPABORTONCLOSE);
 		tcp_set_state(sk, TCP_CLOSE);
-		tcp_send_active_reset(sk, sk->sk_allocation,
-				      SK_RST_REASON_TCP_ABORT_ON_CLOSE);
+		tcp_send_active_reset(sk, SK_RST_REASON_TCP_ABORT_ON_CLOSE);
 	} else if (sock_flag(sk, SOCK_LINGER) && !sk->sk_lingertime) {
 		/* Check zero linger _after_ checking for unread data. */
 		sk->sk_prot->disconnect(sk, 0);
@@ -3241,7 +3240,7 @@ void __tcp_close(struct sock *sk, long timeout)
 		struct tcp_sock *tp = tcp_sk(sk);
 		if (READ_ONCE(tp->linger2) < 0) {
 			tcp_set_state(sk, TCP_CLOSE);
-			tcp_send_active_reset(sk, GFP_ATOMIC,
+			tcp_send_active_reset(sk,
 					      SK_RST_REASON_TCP_ABORT_ON_LINGER);
 			__NET_INC_STATS(sock_net(sk),
 					LINUX_MIB_TCPABORTONLINGER);
@@ -3260,7 +3259,7 @@ void __tcp_close(struct sock *sk, long timeout)
 	if (sk->sk_state != TCP_CLOSE) {
 		if (tcp_check_oom(sk, 0)) {
 			tcp_set_state(sk, TCP_CLOSE);
-			tcp_send_active_reset(sk, GFP_ATOMIC,
+			tcp_send_active_reset(sk,
 					      SK_RST_REASON_TCP_ABORT_ON_MEMORY);
 			__NET_INC_STATS(sock_net(sk),
 					LINUX_MIB_TCPABORTONMEMORY);
@@ -3361,14 +3360,14 @@ int tcp_disconnect(struct sock *sk, int flags)
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
@@ -5088,8 +5087,7 @@ int tcp_abort(struct sock *sk, int err)
 	bh_lock_sock(sk);
 
 	if (tcp_need_reset(sk->sk_state))
-		tcp_send_active_reset(sk, GFP_ATOMIC,
-				      SK_RST_REASON_TCP_STATE);
+		tcp_send_active_reset(sk, SK_RST_REASON_TCP_STATE);
 	tcp_done_with_error(sk, err);
 
 	bh_unlock_sock(sk);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 8c10b7d18218f..0cd46896e7983 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3784,9 +3784,9 @@ void tcp_send_fin(struct sock *sk)
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
index 9ebce13fa8ad8..6aa852c64a811 100644
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
@@ -809,7 +809,7 @@ static void tcp_keepalive_timer(struct timer_list *t)
 				goto out;
 			}
 		}
-		tcp_send_active_reset(sk, GFP_ATOMIC, SK_RST_REASON_TCP_STATE);
+		tcp_send_active_reset(sk, SK_RST_REASON_TCP_STATE);
 		goto death;
 	}
 
@@ -836,7 +836,7 @@ static void tcp_keepalive_timer(struct timer_list *t)
 		    icsk->icsk_probes_out > 0) ||
 		    (user_timeout == 0 &&
 		    icsk->icsk_probes_out >= keepalive_probes(tp))) {
-			tcp_send_active_reset(sk, GFP_ATOMIC,
+			tcp_send_active_reset(sk,
 					      SK_RST_REASON_TCP_KEEPALIVE_TIMEOUT);
 			tcp_write_err(sk);
 			goto out;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1bf9b1dfc431c..20c449fd74102 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2851,8 +2851,7 @@ static void mptcp_do_fastclose(struct sock *sk)
 		 */
 		inet_csk(ssk)->icsk_ack.rcv_mss = TCP_MIN_MSS;
 
-		tcp_send_active_reset(ssk, ssk->sk_allocation,
-				      SK_RST_REASON_TCP_ABORT_ON_CLOSE);
+		tcp_send_active_reset(ssk, SK_RST_REASON_TCP_ABORT_ON_CLOSE);
 unlock:
 		release_sock(ssk);
 	}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 3e0ad5de09585..899f0034cdbd2 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -647,7 +647,7 @@ mptcp_send_active_reset_reason(struct sock *sk)
 	enum sk_rst_reason reason;
 
 	reason = sk_rst_convert_mptcp_reason(subflow->reset_reason);
-	tcp_send_active_reset(sk, GFP_ATOMIC, reason);
+	tcp_send_active_reset(sk, reason);
 }
 
 /* Made the fwd mem carried by the given skb available to the msk,
-- 
2.53.0



