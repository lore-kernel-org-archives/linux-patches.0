Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215239;
	b=kFe1YKeaQyq+1eWa5U4Or/SmXzhMu597twFFQ+EVJGnTWFOy944+VK45ahTGj3RRUhJ2
	 uEkl0nK1jh9TqK2g73lVEAtVnMfuDcEEiUKiWZWBwUSvi5MfzXTEXgicKwEmumOpG/0Ap
	 xrNs5RrsZRS3gIOMvW+I85rnIL0qPY2Rku6bug3Qj86Df18JwRQraU39Cb/uA2+d8B4ve
	 s1vml7NgD5h7TQBojIe8uaBAW+/AUXELB4G74KKLk/YyY3qDkwB1R32VHBEwwMT7m92zs
	 1fM+EKt/Z5IU0xamt8Wdne8L7MfoeuMMEnQoMqf+8vUAzNaL3qcpsrKr6GRJOWleU7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7+27MriC8M3M4/j6MdlP4mKZcOVmVZsUXQLpglrn8+U=;
	b=OpIHPTturRS2hhiIolrOwEYI0qp2AZH/ai2UY2p/fcIti6mjENOI4FO6jqedG7Cc867D
	 EaPODt8CXbplLl7Sq/5aO77d6+/IieVaDO+tTdIMgC24GzgooZLQQpk7Zqh2ek7nAlsk4
	 cLLe7vXbuNdyODxZiMcBNyz30kuhpaFIXdwfrDdjyJyiH90F2MAkEESsLw62zLyaKZ/M+
	 zoPyAtMyvqdjVoNNL1HBfhjXU2h5MyzrwgVHqycbyvEy7+flI59RwniUabZnDALRY218I
	 xWveQanf9neEjzs3adx+V1w0ep9LMYKjHVUWsaJDOooG6ar9CF5QOnITR3CnXdG2eFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3Tp4PFr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEA2606A31A;
	Wed, 28 Oct 2026 19:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3Tp4PFr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DE41F01825;
	Wed, 28 Oct 2026 19:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215238;
	bh=7+27MriC8M3M4/j6MdlP4mKZcOVmVZsUXQLpglrn8+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3Tp4PFrdf23VFB1+vlfZHKnLG9trH2gg81OORk32S8oj39IpLnqCFpRX9nWLE4k/
	 3a3STOoEmuyd6crIOcY2KL/EVl8dt2K2B2VAmXYDZOPIxEsNvh+jg7ZI3ICCu4EC+2
	 F9gKYm2Rqgh2HhoEXijgjulBKVI1WKxYy4QODKwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingwang Xiang <v3rdant.xiang@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1134/1887] bpf, skmsg: fix verdict sk_data_ready racing with ktls rx
Date: Wed, 28 Oct 2026 17:53:50 +0100
Message-ID: <20261028170525.210326672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingwang Xiang <v3rdant.xiang@gmail.com>

[ Upstream commit ddf8029623a1af20e984c040e89ff918158397ab ]

sk_psock_strp_data_ready() already checks tls_sw_has_ctx_rx() and
defers to psock->saved_data_ready when a TLS RX context is present,
avoiding a conflict with the TLS strparser's ownership of the receive
queue (commit e91de6afa81c, "bpf: Fix running sk_skb program types
with ktls").

sk_psock_verdict_data_ready() has no equivalent guard.  When a socket
is inserted into a sockmap (BPF_SK_SKB_VERDICT) before TLS RX is
configured, tls_sw_strparser_arm() saves sk_psock_verdict_data_ready
as rx_ctx->saved_data_ready.  On data arrival:

  tls_data_ready -> tls_strp_data_ready -> tls_rx_msg_ready
    -> saved_data_ready() = sk_psock_verdict_data_ready()
      -> tcp_read_skb() drains sk_receive_queue via __skb_unlink()
         without calling tcp_eat_skb(), so copied_seq is not advanced.

tls_strp_msg_load() then finds tcp_inq() >= full_len (stale), calls
tcp_recv_skb() on the now-empty queue, hits WARN_ON_ONCE(!first), and
returns with rx_ctx->strp.anchor.frag_list pointing at a psock-owned
(potentially freed) skb.  tls_decrypt_sg() subsequently walks that
frag_list: use-after-free.

Apply the same fix as sk_psock_strp_data_ready(): if a TLS RX context
is present, call psock->saved_data_ready (sock_def_readable) to wake
recv() waiters and return immediately, leaving the receive queue
untouched.  TLS retains sole ownership of the queue and decrypts the
record normally through tls_sw_recvmsg().

Fixes: ef5659280eb1 ("bpf, sockmap: Allow skipping sk_skb parser program")
Signed-off-by: Xingwang Xiang <v3rdant.xiang@gmail.com>
Link: https://patch.msgid.link/20260517145630.20521-2-v3rdant.xiang@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 8163bcf574f01..02d3f2ddd25d0 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1267,10 +1267,17 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 static void sk_psock_verdict_data_ready(struct sock *sk)
 {
 	const struct proto_ops *ops = NULL;
+	struct sk_psock *psock;
 	struct socket *sock;
 	int copied;
 
 	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (psock && tls_sw_has_ctx_rx(sk)) {
+		psock->saved_data_ready(sk);
+		rcu_read_unlock();
+		return;
+	}
 	sock = READ_ONCE(sk->sk_socket);
 	if (likely(sock))
 		ops = READ_ONCE(sock->ops);
@@ -1280,8 +1287,6 @@ static void sk_psock_verdict_data_ready(struct sock *sk)
 
 	copied = ops->read_skb(sk, sk_psock_verdict_recv);
 	if (copied >= 0) {
-		struct sk_psock *psock;
-
 		rcu_read_lock();
 		psock = sk_psock(sk);
 		if (psock)
-- 
2.53.0



