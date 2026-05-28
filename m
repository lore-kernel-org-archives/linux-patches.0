Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E3C248F62;
	Thu, 28 May 2026 20:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000258; cv=none; b=Tyxpt0iA1F9ekDj4g0fI3FeHYm58SjoqIL3QXebDtZldPBe/9HBnNwSDy221brWvsjxdFAHESHyV4k4FPFe3i4m9S57c4rkm9PE7zSjm34T9ZIwQ/TB+94DCvHYVYtKlcjb63uPr3D8/QI6cDBD0F1hNWA/w4VBZtJD0Tq4mCrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000258; c=relaxed/simple;
	bh=/YAtvuEtzypG+lDm6pfTMZYcnmGNBbkzlnScQXpEQtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ia+06a3I31lnCHIzCyOBb8Do7X/6CwAX34FY+/XQxT27J0gXoUI5vQqsgUy6Vl/9A3Ns2V9OHMs4ci+W4rHVsGAwCiEV679Maq4PvcoFguPJA0VH+7QlfhpyMu4pTjUxWGJd87/Pkd76gspnqFU9oRlnumSZZC6NwYuKoao97D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jux5nJMO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jux5nJMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B109B1F000E9;
	Thu, 28 May 2026 20:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000257;
	bh=wgzm6roNsk7A6JIsJ7TM439LsCmnWdhhrQ5Rm08poO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jux5nJMOaKjJC9OWJ3LZO9TmibT0GCxO3RmyDu1NpJDzAf047pVBnuskhFHDAflad
	 QY9fk9OLNmR0wOa7JcIzOnfWUV5GKe4pYqDU4mHCyvlqDUUWuDWFzHYi+SvCIcvDPQ
	 aFO9tTZ7r6vI4CnftZ5soPeq9jsw666Y9Zz1DxE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingwang Xiang <v3rdant.xiang@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 359/377] bpf, skmsg: fix verdict sk_data_ready racing with ktls rx
Date: Thu, 28 May 2026 21:49:57 +0200
Message-ID: <20260528194648.825146032@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
index 35a6acbf9a579..75ea4fdb27642 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1268,12 +1268,19 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 static void sk_psock_verdict_data_ready(struct sock *sk)
 {
 	const struct proto_ops *ops = NULL;
+	struct sk_psock *psock;
 	struct socket *sock;
 	int copied;
 
 	trace_sk_data_ready(sk);
 
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
@@ -1283,8 +1290,6 @@ static void sk_psock_verdict_data_ready(struct sock *sk)
 
 	copied = ops->read_skb(sk, sk_psock_verdict_recv);
 	if (copied >= 0) {
-		struct sk_psock *psock;
-
 		rcu_read_lock();
 		psock = sk_psock(sk);
 		if (psock)
-- 
2.53.0



