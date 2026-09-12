Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4FD37FF50;
	Sat, 12 Sep 2026 18:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237993; cv=none; b=YJDHAahQPN9Z4lMyqB73ovtjEajg+7p5J6/T9GwFOIIwSNx5W/tZXu9BZASCv221/Gl9K0ktbFeZpxD++hQFX741xjEu53s/tUudf+qIpMoOBGmkNV++AEnCrjsMGT9pcKOp4ygzfVlOpp1f2nGMXmMmWSOaUfRluZ+VS3PxYGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237993; c=relaxed/simple;
	bh=9GT6t9HVBABFN2Nk6xPa/WKhh3HFHkKhaaEYA8qgoiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEYYkSFFufFvJ7TmJ1gEI+TaB6wagaaRPUmsw9GLY39Du5P7435xDAAuwuXLZtpk7aNAEJ8mjMeKleNdALL/nnZ+XBbf+JlaDHtLV6aMYnoRy+JQ7QhtG/Kgp+WsmgA7pXtonjWi5bfhXUYh85aTOXN/RSc4aU+mCWhy6QbYmjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ywVZAF6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ywVZAF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800D51F000FF;
	Sat, 12 Sep 2026 18:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237992;
	bh=CpgUFEQIsoGezYs2X1l5O4AgTzHfdlWI2qhuKyTaZrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ywVZAF6W2bUHVw8/5cbsFlZ42UIx1yOdHJDtVx/IEv5RsR7vjUZV5gg4As5vGQio
	 XOaiR7xdfDPLmpcY+zK2hAy+IAWWqvwkYx5Y8kv7G7v4lCU8G/59EEJo/ba9f66PEC
	 xuXkdXq7WklFCu82jYoPu/Teto37807u6556m0WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.15 371/935] tcp: clear sock_ops cb flags before force-closing a child socket
Date: Sat, 12 Sep 2026 08:56:41 +0200
Message-ID: <20260912065535.322250144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sechang Lim <rhkrqnwk98@gmail.com>

[ Upstream commit 990348e5bb457697c2f1f7f7b65154a3334d9d2b ]

A child socket inherits the listener's bpf_sock_ops_cb_flags via
sk_clone_lock(). If its setup fails in tcp_v4_syn_recv_sock() /
tcp_v6_syn_recv_sock(), the child is freed through put_and_exit, where
inet_csk_prepare_forced_close() drops the socket lock and tcp_done() runs
without it.

If BPF_SOCK_OPS_STATE_CB_FLAG was inherited, tcp_done() -> tcp_set_state()
calls tcp_call_bpf(), which expects the lock and trips sock_owned_by_me():

  WARNING: include/net/sock.h:1799 at tcp_set_state+0x433/0x550
  RIP: 0010:tcp_set_state+0x433/0x550 include/net/sock.h:1799
  Call Trace:
   <IRQ>
   tcp_done+0xba/0x250 net/ipv4/tcp.c:5095
   tcp_v4_syn_recv_sock+0x850/0xa50 net/ipv4/tcp_ipv4.c:1787
   tcp_check_req+0xf30/0x1360 net/ipv4/tcp_minisocks.c:926
   tcp_v4_rcv+0x1047/0x1b50 net/ipv4/tcp_ipv4.c:2164
   </IRQ>

The child is freed before it is ever established, so it should run no
sock_ops callback. Clear its cb flags in inet_csk_prepare_for_destroy_sock(),
the common point for the IPv4, IPv6 and chtls forced-close paths and for the
MPTCP ->syn_recv_sock() failure path (dispose_child), which reaches tcp_done()
on a child that was never established too.

Suggested-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Fixes: d44874910a26 ("bpf: Add BPF_SOCK_OPS_STATE_CB")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260611092923.1895982-1-rhkrqnwk98@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>

[ Moved inet_csk_prepare_for_destroy_sock() to inet_connection_sock.c due to header dependency,
  Added a guard arount the call to tcp_clear_sock_ops_cb_flags to avoid
  calling it for DDCP sockets.]

Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
---
 include/net/inet_connection_sock.h | 8 +-------
 include/net/tcp.h                  | 9 +++++++++
 net/ipv4/inet_connection_sock.c    | 9 +++++++++
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 97e8969b37967..041f164c98b9f 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -294,14 +294,8 @@ reqsk_timeout(struct request_sock *req, unsigned long max_timeout)
 	return (unsigned long)min_t(u64, timeout, max_timeout);
 }
 
-static inline void inet_csk_prepare_for_destroy_sock(struct sock *sk)
-{
-	/* The below has to be done to allow calling inet_csk_destroy_sock */
-	sock_set_flag(sk, SOCK_DEAD);
-	this_cpu_inc(*sk->sk_prot->orphan_count);
-}
-
 void inet_csk_destroy_sock(struct sock *sk);
+void inet_csk_prepare_for_destroy_sock(struct sock *sk);
 void inet_csk_prepare_forced_close(struct sock *sk);
 
 /*
diff --git a/include/net/tcp.h b/include/net/tcp.h
index dc532cbde05e2..a0f3dd3faf60c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2355,6 +2355,11 @@ static inline int tcp_call_bpf_3arg(struct sock *sk, int op, u32 arg1, u32 arg2,
 	return tcp_call_bpf(sk, op, 3, args);
 }
 
+static inline void tcp_clear_sock_ops_cb_flags(struct sock *sk)
+{
+	tcp_sk(sk)->bpf_sock_ops_cb_flags = 0;
+}
+
 #else
 static inline int tcp_call_bpf(struct sock *sk, int op, u32 nargs, u32 *args)
 {
@@ -2372,6 +2377,10 @@ static inline int tcp_call_bpf_3arg(struct sock *sk, int op, u32 arg1, u32 arg2,
 	return -EPERM;
 }
 
+static inline void tcp_clear_sock_ops_cb_flags(struct sock *sk)
+{
+}
+
 #endif
 
 static inline u32 tcp_timeout_init(struct sock *sk)
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 042982aaf9704..ac9f18861aa7a 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1074,6 +1074,15 @@ void inet_csk_destroy_sock(struct sock *sk)
 }
 EXPORT_SYMBOL(inet_csk_destroy_sock);
 
+void inet_csk_prepare_for_destroy_sock(struct sock *sk)
+{
+	/* The below has to be done to allow calling inet_csk_destroy_sock */
+	if (sk->sk_protocol == IPPROTO_TCP)
+		tcp_clear_sock_ops_cb_flags(sk);
+	sock_set_flag(sk, SOCK_DEAD);
+	this_cpu_inc(*sk->sk_prot->orphan_count);
+}
+
 /* This function allows to force a closure of a socket after the call to
  * tcp/dccp_create_openreq_child().
  */
-- 
2.53.0



