Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C516E33F5BE;
	Thu, 28 May 2026 20:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999272; cv=none; b=UpaLoZoUrPm//4FxUu/JizQkVuIZsws6PIis0/1Ux6L4iorb1iK0AS7oHz5D9pWVmfKYtATBk6RcWXj6bVdRBhZyZJSmU0i4XvSo8s9AGFVWYR39YYUyAGF1fLi021glfYpHRG2Xse+5UX76MCHZ3DEBSt1x/OBrSUYR2oL3oqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999272; c=relaxed/simple;
	bh=UK04WdMjVz9Ubx0SSqQIJBjvMLzYLjg1iywcf8B9USA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bfswa9nKiTrbL9IzWfC6g7Jky+1u6FDqw+VKj9Tm0jwQzZfHIvq5aguf5fTsLBPQEDma1Mc5rBm+i1i9Soc+0a7W/LPW06pZGxP/eriPtuWelbq3RYhKrPjaiaDH5W1pNpCjotX9MQ28xzmqEMZsIu+UPOZlLJyR7kd88M5eNHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n0zzuEAH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0zzuEAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2321F000E9;
	Thu, 28 May 2026 20:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999271;
	bh=e5vMLpaIF5sbPAGKjfLimh1wPu/x2h/8oGaceZjQ7Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n0zzuEAHMCEVw+RLYxM7J2UhPAcT9CPV6URc0eDS3tm68nx/xW0ArX5ZT30f3+/Cz
	 cZGDo9q/2NjuYmxO/HP/kuzP74BI0r+ywvZCWkrW6UqHdYl8TcDsI9kOadARX+VOGk
	 gn6Q1fbTnpLS5a78iJhXLJjwPpc1OH4mlISBUO6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingwang Xiang <v3rdant.xiang@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 430/461] bpf, skmsg: fix verdict sk_data_ready racing with ktls rx
Date: Thu, 28 May 2026 21:49:19 +0200
Message-ID: <20260528194659.968930922@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 6187a83bd7411..e1850caf1a71a 100644
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



