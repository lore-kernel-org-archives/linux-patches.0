Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5FF1DF75A;
	Wed,  6 Nov 2024 13:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898722; cv=none; b=o9Jp6Dh5ORSCFxgCHIdbtH7j6yEhK+/V0JQnZDk9gRP6oV78QHMDxk5BWmicpFtT2pw2hZ3gdVw6c79zVBmInOyRWOrRzKXjy+BitDi+Ubywhe6Vrgk2J1A7CBGRIEPXpJRbCm3DSkP821U7R1F4/r9i/UlGvppmoLMm1jM5bXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898722; c=relaxed/simple;
	bh=Gn9cf16XJc9sUBgcqHiK9NzlSG/Eh44S9x3UMzPNBhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOpguBBZUOBVySuisy27t9/42Wg+T0HI4xyPCl3YqrTrxvMT9TpdCjzbLOGVdkxc7LYMLr0g93RjivqEPb3Fi6/5SVmU7YYSTL46upqUxM9jD7havC+KvFBL0902AVnHp7keMZPEdhlm7IRiOOJhO61+8OiEHyif637sOdlRMMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUONbJHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUONbJHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FACC4CECD;
	Wed,  6 Nov 2024 13:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898722;
	bh=Gn9cf16XJc9sUBgcqHiK9NzlSG/Eh44S9x3UMzPNBhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUONbJHLZCS3y/UWF6WH4C/sMYZWP9MzMH3wTzikGX4+be57BDdoTPajIB/By7Iko
	 arbE/41dqojVBrBCMmmAG1tVQ/BDxP4glF8/opc4DourmnK0tLyJgN92Nl/DO4V1AN
	 FW/Z9MwTbhRaE/OQfL274SI9ZcHWPeTt95dTGAcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 333/462] net: annotate lockless accesses to sk->sk_ack_backlog
Date: Wed,  6 Nov 2024 13:03:46 +0100
Message-ID: <20241106120339.750700601@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 288efe8606b62d0753ba6722b36ef241877251fd ]

sk->sk_ack_backlog can be read without any lock being held.
We need to use READ_ONCE()/WRITE_ONCE() to avoid load/store tearing
and/or potential KCSAN warnings.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 4d5c70e6155d ("sctp: ensure sk_state is set to CLOSED if hashing fails in sctp_listen_start")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h  | 6 +++---
 net/ipv4/tcp.c      | 2 +-
 net/ipv4/tcp_diag.c | 2 +-
 net/ipv4/tcp_ipv4.c | 2 +-
 net/ipv6/tcp_ipv6.c | 2 +-
 net/sched/em_meta.c | 2 +-
 net/sctp/diag.c     | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 250d5a6c508cb..c0d5775bc62c0 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -873,17 +873,17 @@ static inline gfp_t sk_gfp_mask(const struct sock *sk, gfp_t gfp_mask)
 
 static inline void sk_acceptq_removed(struct sock *sk)
 {
-	sk->sk_ack_backlog--;
+	WRITE_ONCE(sk->sk_ack_backlog, sk->sk_ack_backlog - 1);
 }
 
 static inline void sk_acceptq_added(struct sock *sk)
 {
-	sk->sk_ack_backlog++;
+	WRITE_ONCE(sk->sk_ack_backlog, sk->sk_ack_backlog + 1);
 }
 
 static inline bool sk_acceptq_is_full(const struct sock *sk)
 {
-	return sk->sk_ack_backlog > sk->sk_max_ack_backlog;
+	return READ_ONCE(sk->sk_ack_backlog) > sk->sk_max_ack_backlog;
 }
 
 /*
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 54399256a4380..4800422169f95 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3280,7 +3280,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 		 * tcpi_unacked -> Number of children ready for accept()
 		 * tcpi_sacked  -> max backlog
 		 */
-		info->tcpi_unacked = sk->sk_ack_backlog;
+		info->tcpi_unacked = READ_ONCE(sk->sk_ack_backlog);
 		info->tcpi_sacked = sk->sk_max_ack_backlog;
 		return;
 	}
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index 549506162ddec..edfbab54c46f4 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -21,7 +21,7 @@ static void tcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 	struct tcp_info *info = _info;
 
 	if (inet_sk_state_load(sk) == TCP_LISTEN) {
-		r->idiag_rqueue = sk->sk_ack_backlog;
+		r->idiag_rqueue = READ_ONCE(sk->sk_ack_backlog);
 		r->idiag_wqueue = sk->sk_max_ack_backlog;
 	} else if (sk->sk_type == SOCK_STREAM) {
 		const struct tcp_sock *tp = tcp_sk(sk);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a0a4dbcf8c12f..1f8a9b323a0dd 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2500,7 +2500,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 
 	state = inet_sk_state_load(sk);
 	if (state == TCP_LISTEN)
-		rx_queue = sk->sk_ack_backlog;
+		rx_queue = READ_ONCE(sk->sk_ack_backlog);
 	else
 		/* Because we don't lock the socket,
 		 * we might find a transient negative value.
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 81b7ef21180bf..8be41d6c4278b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1921,7 +1921,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 
 	state = inet_sk_state_load(sp);
 	if (state == TCP_LISTEN)
-		rx_queue = sp->sk_ack_backlog;
+		rx_queue = READ_ONCE(sp->sk_ack_backlog);
 	else
 		/* Because we don't lock the socket,
 		 * we might find a transient negative value.
diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index ad007cdcec978..c4c297627feac 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -521,7 +521,7 @@ META_COLLECTOR(int_sk_ack_bl)
 		*err = -1;
 		return;
 	}
-	dst->value = sk->sk_ack_backlog;
+	dst->value = READ_ONCE(sk->sk_ack_backlog);
 }
 
 META_COLLECTOR(int_sk_max_ack_bl)
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index 2d0318a7352c2..e0785592fdd63 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -416,7 +416,7 @@ static void sctp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 		r->idiag_rqueue = atomic_read(&infox->asoc->rmem_alloc);
 		r->idiag_wqueue = infox->asoc->sndbuf_used;
 	} else {
-		r->idiag_rqueue = sk->sk_ack_backlog;
+		r->idiag_rqueue = READ_ONCE(sk->sk_ack_backlog);
 		r->idiag_wqueue = sk->sk_max_ack_backlog;
 	}
 	if (infox->sctpinfo)
-- 
2.43.0



