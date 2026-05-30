Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36906263F44;
	Sat, 30 May 2026 17:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161659; cv=none; b=OUUYCbacgTkEMleuVlnCdKtA1o397+8QyZ50uQlzZEPC3cQbypM5WKu/JBwucb7O6thMgVyTqq++t4DMzbbiRgS3g13Z+vuPXuhM1oq6gKCCxSCUmKF3hjl/RWndQTDxzletG0WsZUoDqymtS7Qwx8jvu9SGNq4HghO8fbAxvc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161659; c=relaxed/simple;
	bh=Kd8WpOkqlgqAbVngnm8kJjRmWHr4/USFK0r7wpfXiq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryBiQzOcs/oCfVLGcJwkCSxlGQxuOznos5v0Gfx2GjaDJ5CNcSYEXpThh84a9M8y1xRrpJqK6FdWmoo/BbDwzYwlqzYJkTgqSk1gAO/hiOusV4Tig5qRRjWIhi0P7ta3HlTSmhOr1RjVW6/WK7MvY5YuLQxVjJ8HaxfJLGhqbFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vs3JHjoA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vs3JHjoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B58F1F00893;
	Sat, 30 May 2026 17:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161658;
	bh=CzNbCDIQ4NCSLHh8yBEAoWT15RE2ucJ6KoHCpXVBPNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vs3JHjoAJyqoiATyrACJT+T67ROh96zn5D2WZwCfswv4nTXQLiVUcVoZNG+1jUECG
	 b8iK1AYm7hQma0kFLi1+9CXb3civ9YfPEysRR/kQ9nTDMGxZhYv00jMSST8AKJTvNh
	 WZ/WHdPv4u8NHLxnU9q1LVoMNPPCKTHR1XojVxUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 688/969] tcp: preserve const qualifier in tcp_sk()
Date: Sat, 30 May 2026 18:03:32 +0200
Message-ID: <20260530160319.506329280@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e9d9da91548b21e189fcd0259a0f2d26d1afc509 ]

We can change tcp_sk() to propagate its argument const qualifier,
thanks to container_of_const().

We have two places where a const sock pointer has to be upgraded
to a write one. We have been using const qualifier for lockless
listeners to clearly identify points where writes could happen.

Add tcp_sk_rw() helper to better document these.

tcp_inbound_md5_hash(), __tcp_grow_window(), tcp_reset_check()
and tcp_rack_reo_wnd() get an additional const qualififer
for their @tp local variables.

smc_check_reset_syn_req() also needs a similar change.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 21e92a38cfd8 ("tcp: add data-race annotations around tp->data_segs_out and tp->total_retrans")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tcp.h      | 10 ++++++----
 include/net/tcp.h        |  2 +-
 net/ipv4/tcp.c           |  2 +-
 net/ipv4/tcp_input.c     |  4 ++--
 net/ipv4/tcp_minisocks.c |  5 +++--
 net/ipv4/tcp_output.c    |  9 +++++++--
 net/ipv4/tcp_recovery.c  |  2 +-
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 9cd289ad3f5b5..3ac0b55a6bc7b 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -471,10 +471,12 @@ enum tsq_flags {
 	TCPF_MTU_REDUCED_DEFERRED	= (1UL << TCP_MTU_REDUCED_DEFERRED),
 };
 
-static inline struct tcp_sock *tcp_sk(const struct sock *sk)
-{
-	return (struct tcp_sock *)sk;
-}
+#define tcp_sk(ptr) container_of_const(ptr, struct tcp_sock, inet_conn.icsk_inet.sk)
+
+/* Variant of tcp_sk() upgrading a const sock to a read/write tcp socket.
+ * Used in context of (lockless) tcp listeners.
+ */
+#define tcp_sk_rw(ptr) container_of(ptr, struct tcp_sock, inet_conn.icsk_inet.sk)
 
 struct tcp_timewait_sock {
 	struct inet_timewait_sock tw_sk;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 83e0362e3b721..9632ac801e016 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -535,7 +535,7 @@ static inline void tcp_synq_overflow(const struct sock *sk)
 
 	last_overflow = READ_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp);
 	if (!time_between32(now, last_overflow, last_overflow + HZ))
-		WRITE_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp, now);
+		WRITE_ONCE(tcp_sk_rw(sk)->rx_opt.ts_recent_stamp, now);
 }
 
 /* syncookies: no recent synqueue overflow on this listening socket? */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index fd81976d4beb7..44ddb82621300 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4642,7 +4642,7 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 	const __u8 *hash_location = NULL;
 	struct tcp_md5sig_key *hash_expected;
 	const struct tcphdr *th = tcp_hdr(skb);
-	struct tcp_sock *tp = tcp_sk(sk);
+	const struct tcp_sock *tp = tcp_sk(sk);
 	int genhash, l3index;
 	u8 newhash[16];
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e1334be1feba1..9b40204248488 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -484,7 +484,7 @@ static void tcp_sndbuf_expand(struct sock *sk)
 static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb,
 			     unsigned int skbtruesize)
 {
-	struct tcp_sock *tp = tcp_sk(sk);
+	const struct tcp_sock *tp = tcp_sk(sk);
 	/* Optimize this! */
 	int truesize = tcp_win_from_space(sk, skbtruesize) >> 1;
 	int window = tcp_win_from_space(sk, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2])) >> 1;
@@ -5783,7 +5783,7 @@ static void tcp_urg(struct sock *sk, struct sk_buff *skb, const struct tcphdr *t
  */
 static bool tcp_reset_check(const struct sock *sk, const struct sk_buff *skb)
 {
-	struct tcp_sock *tp = tcp_sk(sk);
+	const struct tcp_sock *tp = tcp_sk(sk);
 
 	return unlikely(TCP_SKB_CB(skb)->seq == (tp->rcv_nxt - 1) &&
 			(1 << sk->sk_state) & (TCPF_CLOSE_WAIT | TCPF_LAST_ACK |
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index bc94df0140bfd..0b934b6ebb55b 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -441,7 +441,7 @@ void tcp_ca_openreq_child(struct sock *sk, const struct dst_entry *dst)
 }
 EXPORT_SYMBOL_GPL(tcp_ca_openreq_child);
 
-static void smc_check_reset_syn_req(struct tcp_sock *oldtp,
+static void smc_check_reset_syn_req(const struct tcp_sock *oldtp,
 				    struct request_sock *req,
 				    struct tcp_sock *newtp)
 {
@@ -470,7 +470,8 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	const struct inet_request_sock *ireq = inet_rsk(req);
 	struct tcp_request_sock *treq = tcp_rsk(req);
 	struct inet_connection_sock *newicsk;
-	struct tcp_sock *oldtp, *newtp;
+	const struct tcp_sock *oldtp;
+	struct tcp_sock *newtp;
 	u32 seq;
 
 	if (!newsk)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a8d8e2f294ff2..0a27d89dcc731 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4203,8 +4203,13 @@ int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
 	if (!res) {
 		TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
-		if (unlikely(tcp_passive_fastopen(sk)))
-			tcp_sk(sk)->total_retrans++;
+		if (unlikely(tcp_passive_fastopen(sk))) {
+			/* sk has const attribute because listeners are lockless.
+			 * However in this case, we are dealing with a passive fastopen
+			 * socket thus we can change total_retrans value.
+			 */
+			tcp_sk_rw(sk)->total_retrans++;
+		}
 		trace_tcp_retransmit_synack(sk, req);
 	}
 	return res;
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index c085793691102..bba10110fbbc1 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -4,7 +4,7 @@
 
 static u32 tcp_rack_reo_wnd(const struct sock *sk)
 {
-	struct tcp_sock *tp = tcp_sk(sk);
+	const struct tcp_sock *tp = tcp_sk(sk);
 
 	if (!tp->reord_seen) {
 		/* If reordering has not been observed, be aggressive during
-- 
2.53.0



