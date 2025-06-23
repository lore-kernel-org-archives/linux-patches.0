Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F39E1DF98B;
	Mon, 23 Jun 2025 21:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713177; cv=none; b=r+EqRJlvUcqib1AoNZd99bfgY+OGWjQtm1GCG9AVt0wJaLo9Whi88iyNloMGdE8KXrQnuAuluQWqZV92336j/k6+CWQREzZcNmQUeO+ucCul4MEGHqG66OH+eZAqk4ebOl4NA6B7pbkuqLk/41lKVDaMvzXenaUcyM7PIEhSBIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713177; c=relaxed/simple;
	bh=4m/SnLSAZX86Tk2WVNEw2CdLstplH1U8cot/FMHT/Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmYVOeLtjblah52C30M3A0xPtVgUEXRFt/t6D53H9K6XLBaB2u4l3sqecJNdpDRvbZu+aPZpoQVBdxYdZqjl6wkXzQd2fU/COV8JuuvXdj2a8L/qjwqq4+fpx+L7+rKsjw8tpytgDNehVfRctOLtwJqVFWG+QsVE79fFEP5bZPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1b/rEYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1b/rEYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B72C4CEEA;
	Mon, 23 Jun 2025 21:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713177;
	bh=4m/SnLSAZX86Tk2WVNEw2CdLstplH1U8cot/FMHT/Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1b/rEYDtafRv1wK4kBSKPgJOzyVgoiRP2+czgwekVHlgSbho3cemZ4oC8Tiy84fM
	 XhMV1GTR4uokUzyd0aBwgjledk5dwxBdRu9K16qK8ACrLm+3uCf0a7jnZf2dHNalZo
	 zVh90HppcFZW5su0Sv5i7wTqDCkVa6VCB3xqHcIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Arjun Roy <arjunroy@google.com>,
	Wei Wang <weiwan@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/355] tcp: factorize logic into tcp_epollin_ready()
Date: Mon, 23 Jun 2025 15:05:26 +0200
Message-ID: <20250623130630.505328050@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 05dc72aba364d374a27de567fac58c199ff5ee97 ]

Both tcp_data_ready() and tcp_stream_is_readable() share the same logic.

Add tcp_epollin_ready() helper to avoid duplication.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Wei Wang <weiwan@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 2660a544fdc0 ("net: Fix TOCTOU issue in sk_is_readable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h    | 12 ++++++++++++
 net/ipv4/tcp.c       | 18 +++++-------------
 net/ipv4/tcp_input.c | 11 ++---------
 3 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 2aad2e79ac6ad..41f535dcaa3f9 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1445,6 +1445,18 @@ static inline bool tcp_rmem_pressure(const struct sock *sk)
 	return atomic_read(&sk->sk_rmem_alloc) > threshold;
 }
 
+static inline bool tcp_epollin_ready(const struct sock *sk, int target)
+{
+	const struct tcp_sock *tp = tcp_sk(sk);
+	int avail = READ_ONCE(tp->rcv_nxt) - READ_ONCE(tp->copied_seq);
+
+	if (avail <= 0)
+		return false;
+
+	return (avail >= target) || tcp_rmem_pressure(sk) ||
+	       (tcp_receive_window(tp) <= inet_csk(sk)->icsk_ack.rcv_mss);
+}
+
 extern void tcp_openreq_init_rwin(struct request_sock *req,
 				  const struct sock *sk_listener,
 				  const struct dst_entry *dst);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 24ebd51c5e0b8..0332fdab942db 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -476,19 +476,11 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
 	}
 }
 
-static inline bool tcp_stream_is_readable(const struct tcp_sock *tp,
-					  int target, struct sock *sk)
+static bool tcp_stream_is_readable(struct sock *sk, int target)
 {
-	int avail = READ_ONCE(tp->rcv_nxt) - READ_ONCE(tp->copied_seq);
-
-	if (avail > 0) {
-		if (avail >= target)
-			return true;
-		if (tcp_rmem_pressure(sk))
-			return true;
-		if (tcp_receive_window(tp) <= inet_csk(sk)->icsk_ack.rcv_mss)
-			return true;
-	}
+	if (tcp_epollin_ready(sk, target))
+		return true;
+
 	if (sk->sk_prot->stream_memory_read)
 		return sk->sk_prot->stream_memory_read(sk);
 	return false;
@@ -565,7 +557,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		    tp->urg_data)
 			target++;
 
-		if (tcp_stream_is_readable(tp, target, sk))
+		if (tcp_stream_is_readable(sk, target))
 			mask |= EPOLLIN | EPOLLRDNORM;
 
 		if (!(shutdown & SEND_SHUTDOWN)) {
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7c2e714527f68..318fdeb1deef3 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5028,15 +5028,8 @@ int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
 
 void tcp_data_ready(struct sock *sk)
 {
-	const struct tcp_sock *tp = tcp_sk(sk);
-	int avail = tp->rcv_nxt - tp->copied_seq;
-
-	if (avail < sk->sk_rcvlowat && !tcp_rmem_pressure(sk) &&
-	    !sock_flag(sk, SOCK_DONE) &&
-	    tcp_receive_window(tp) > inet_csk(sk)->icsk_ack.rcv_mss)
-		return;
-
-	sk->sk_data_ready(sk);
+	if (tcp_epollin_ready(sk, sk->sk_rcvlowat))
+		sk->sk_data_ready(sk);
 }
 
 static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
-- 
2.39.5



