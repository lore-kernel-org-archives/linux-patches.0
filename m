Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209931D2F42;
	Wed,  6 Nov 2024 13:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898728; cv=none; b=EpkrnS33F8IpaDsOKDrk2CvSijWZp/qcu27YOAckwhp2ZSGGDtwZEs4Pj2gELsGNVKkAenQ+F9+UyO963VslQoMrMYIiN2UC+rzxm8aei21gObJI1pDGhfcaSIbIBwf3k/YX6SqUZiAXmHgLOVMzVPVTQdXt4V2SyYz8qo+Wapw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898728; c=relaxed/simple;
	bh=W4CGri/3lqB7qIXPIKoTexyc83loRUII9s2WyJvsQzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdSyrD6Gqc2yyTDKBDRDIgCwnNEfOD7gOFYaY6bUwxJZKFO+QpDnvu7zDRA8cBLwYSCHN5yN4ltE7ps57HtXaMeWcKTZhl2x88uXYjA7wTNb2R4pthyUNPLsRXnWhWLG8aZj2iTCP+K3cM3j0Lds/Zz8nwr9XYa8Im1HRaRSlmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWljVX9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWljVX9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF75C4CECD;
	Wed,  6 Nov 2024 13:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898728;
	bh=W4CGri/3lqB7qIXPIKoTexyc83loRUII9s2WyJvsQzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWljVX9AwvZOK3Y2PTrQSTSf6l77FoQlmVl8FLKQ4zwXP2bbvElLop7IxqK25Ssyp
	 BSu35kutEyTH8AQP+G+60v8AcNNdIzpPRtDUuGH5V9g5mwnYmX+VLBNqHZuhatfdYd
	 mZs6yyEjArw4Gdx9fTpCkBGciepC1TvvMhKmitns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 334/462] net: annotate lockless accesses to sk->sk_max_ack_backlog
Date: Wed,  6 Nov 2024 13:03:47 +0100
Message-ID: <20241106120339.774730403@linuxfoundation.org>
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

[ Upstream commit 099ecf59f05b5f30f42ebac0ab8cb94f9b18c90c ]

sk->sk_max_ack_backlog can be read without any lock being held
at least in TCP/DCCP cases.

We need to use READ_ONCE()/WRITE_ONCE() to avoid load/store tearing
and/or potential KCSAN warnings.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 4d5c70e6155d ("sctp: ensure sk_state is set to CLOSED if hashing fails in sctp_listen_start")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h              | 2 +-
 net/dccp/proto.c                | 2 +-
 net/ipv4/af_inet.c              | 2 +-
 net/ipv4/inet_connection_sock.c | 2 +-
 net/ipv4/tcp.c                  | 2 +-
 net/ipv4/tcp_diag.c             | 2 +-
 net/sched/em_meta.c             | 2 +-
 net/sctp/diag.c                 | 2 +-
 net/sctp/socket.c               | 4 ++--
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c0d5775bc62c0..986f9724da8d0 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -883,7 +883,7 @@ static inline void sk_acceptq_added(struct sock *sk)
 
 static inline bool sk_acceptq_is_full(const struct sock *sk)
 {
-	return READ_ONCE(sk->sk_ack_backlog) > sk->sk_max_ack_backlog;
+	return READ_ONCE(sk->sk_ack_backlog) > READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 /*
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 491b148afa8f0..add742af1c8b9 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -960,7 +960,7 @@ int inet_dccp_listen(struct socket *sock, int backlog)
 	if (!((1 << old_state) & (DCCPF_CLOSED | DCCPF_LISTEN)))
 		goto out;
 
-	sk->sk_max_ack_backlog = backlog;
+	WRITE_ONCE(sk->sk_max_ack_backlog, backlog);
 	/* Really, if the socket is already in listen state
 	 * we can only allow the backlog to be adjusted.
 	 */
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index e0d0aae343ac8..be2b786cee2bd 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -208,7 +208,7 @@ int inet_listen(struct socket *sock, int backlog)
 	if (!((1 << old_state) & (TCPF_CLOSE | TCPF_LISTEN)))
 		goto out;
 
-	sk->sk_max_ack_backlog = backlog;
+	WRITE_ONCE(sk->sk_max_ack_backlog, backlog);
 	/* Really, if the socket is already in listen state
 	 * we can only allow the backlog to be adjusted.
 	 */
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 091999dbef335..6766a154ff854 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -767,7 +767,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 	 * ones are about to clog our table.
 	 */
 	qlen = reqsk_queue_len(queue);
-	if ((qlen << 1) > max(8U, sk_listener->sk_max_ack_backlog)) {
+	if ((qlen << 1) > max(8U, READ_ONCE(sk_listener->sk_max_ack_backlog))) {
 		int young = reqsk_queue_len_young(queue) << 1;
 
 		while (thresh > 2) {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4800422169f95..55754bf176d99 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3281,7 +3281,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 		 * tcpi_sacked  -> max backlog
 		 */
 		info->tcpi_unacked = READ_ONCE(sk->sk_ack_backlog);
-		info->tcpi_sacked = sk->sk_max_ack_backlog;
+		info->tcpi_sacked = READ_ONCE(sk->sk_max_ack_backlog);
 		return;
 	}
 
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index edfbab54c46f4..0d08f9e2d8d03 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -22,7 +22,7 @@ static void tcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 
 	if (inet_sk_state_load(sk) == TCP_LISTEN) {
 		r->idiag_rqueue = READ_ONCE(sk->sk_ack_backlog);
-		r->idiag_wqueue = sk->sk_max_ack_backlog;
+		r->idiag_wqueue = READ_ONCE(sk->sk_max_ack_backlog);
 	} else if (sk->sk_type == SOCK_STREAM) {
 		const struct tcp_sock *tp = tcp_sk(sk);
 
diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index c4c297627feac..46254968d390f 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -532,7 +532,7 @@ META_COLLECTOR(int_sk_max_ack_bl)
 		*err = -1;
 		return;
 	}
-	dst->value = sk->sk_max_ack_backlog;
+	dst->value = READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 META_COLLECTOR(int_sk_prio)
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index e0785592fdd63..2fcfb8cc8bd12 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -417,7 +417,7 @@ static void sctp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 		r->idiag_wqueue = infox->asoc->sndbuf_used;
 	} else {
 		r->idiag_rqueue = READ_ONCE(sk->sk_ack_backlog);
-		r->idiag_wqueue = sk->sk_max_ack_backlog;
+		r->idiag_wqueue = READ_ONCE(sk->sk_max_ack_backlog);
 	}
 	if (infox->sctpinfo)
 		sctp_get_sctp_info(sk, infox->asoc, infox->sctpinfo);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index eef807edd61da..efc9981481c5f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8407,7 +8407,7 @@ static int sctp_listen_start(struct sock *sk, int backlog)
 		}
 	}
 
-	sk->sk_max_ack_backlog = backlog;
+	WRITE_ONCE(sk->sk_max_ack_backlog, backlog);
 	return sctp_hash_endpoint(ep);
 }
 
@@ -8461,7 +8461,7 @@ int sctp_inet_listen(struct socket *sock, int backlog)
 
 	/* If we are already listening, just update the backlog */
 	if (sctp_sstate(sk, LISTENING))
-		sk->sk_max_ack_backlog = backlog;
+		WRITE_ONCE(sk->sk_max_ack_backlog, backlog);
 	else {
 		err = sctp_listen_start(sk, backlog);
 		if (err)
-- 
2.43.0



