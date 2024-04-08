Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B8E4D5AB;
	Mon,  8 Apr 2024 13:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583870; cv=none; b=GIByrTZFiNG+scxE95dFl0XKeg9LZXIKa+FENQPcTe5b87gIEmw7Ae1OYxl6LrzO7bvgVkgt0n82YPemirSXvzwcCqyIm+LzdbdEFbNepF3LBw9eEC8QKhlhGyoFVyzVtoMdHyWS5xrMQtzT+hoqQoom1BPn4+f5Ai2XCgoag4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583870; c=relaxed/simple;
	bh=95Uza7XXIOnxaHo5+HLpX607gbQbTGZpx4BRddNQ+DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+SpWgIAaRx5cu3t2+XovAY0N8BbfAlycAXyzc1td43b+9zQb9PWEs4lR/h5GvyEdbl2I+s7Wz5bd7nIG4NUOkj9wXpliPhvhFVfLRjs5xnfH98Lb/VKLan8GHoBX4RKL8uxAuKUdqPyN8eoH3LErGR6beb0qcfX+dDUaPhz2EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6PRm12B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6PRm12B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8E9C433C7;
	Mon,  8 Apr 2024 13:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583870;
	bh=95Uza7XXIOnxaHo5+HLpX607gbQbTGZpx4BRddNQ+DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6PRm12B2L9+lVQ2I9vCGXuaPXb7Ga3udeEejUYNtaHrmcbDTU9OqTfPkSc64DR9W
	 2eB6jXZ11NS+FkJLu4O/6klc5rb3ZUFsuC0AP9al+nNvSt3CoYqMEeB+n6Us5qv59D
	 2vpkkbsnL0aajeEt1mtMUC8fTiT5i7rIkhjRHaHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 244/252] mptcp: dont overwrite sock_ops in mptcp_is_tcpsk()
Date: Mon,  8 Apr 2024 14:59:03 +0200
Message-ID: <20240408125314.225890434@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davide Caratti <dcaratti@redhat.com>

commit 8e2b8a9fa512709e6fee744dcd4e2a20ee7f5c56 upstream.

Eric Dumazet suggests:

 > The fact that mptcp_is_tcpsk() was able to write over sock->ops was a
 > bit strange to me.
 > mptcp_is_tcpsk() should answer a question, with a read-only argument.

re-factor code to avoid overwriting sock_ops inside that function. Also,
change the helper name to reflect the semantics and to disambiguate from
its dual, sk_is_mptcp(). While at it, collapse mptcp_stream_accept() and
mptcp_accept() into a single function, where fallback / non-fallback are
separated into a single sk_is_mptcp() conditional.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/432
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |  108 ++++++++++++++++++++-------------------------------
 1 file changed, 44 insertions(+), 64 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -55,28 +55,14 @@ static u64 mptcp_wnd_end(const struct mp
 	return READ_ONCE(msk->wnd_end);
 }
 
-static bool mptcp_is_tcpsk(struct sock *sk)
+static const struct proto_ops *mptcp_fallback_tcp_ops(const struct sock *sk)
 {
-	struct socket *sock = sk->sk_socket;
-
-	if (unlikely(sk->sk_prot == &tcp_prot)) {
-		/* we are being invoked after mptcp_accept() has
-		 * accepted a non-mp-capable flow: sk is a tcp_sk,
-		 * not an mptcp one.
-		 *
-		 * Hand the socket over to tcp so all further socket ops
-		 * bypass mptcp.
-		 */
-		WRITE_ONCE(sock->ops, &inet_stream_ops);
-		return true;
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	} else if (unlikely(sk->sk_prot == &tcpv6_prot)) {
-		WRITE_ONCE(sock->ops, &inet6_stream_ops);
-		return true;
+	if (sk->sk_prot == &tcpv6_prot)
+		return &inet6_stream_ops;
 #endif
-	}
-
-	return false;
+	WARN_ON_ONCE(sk->sk_prot != &tcp_prot);
+	return &inet_stream_ops;
 }
 
 static int __mptcp_socket_create(struct mptcp_sock *msk)
@@ -3328,44 +3314,6 @@ void mptcp_rcv_space_init(struct mptcp_s
 		msk->rcvq_space.space = TCP_INIT_CWND * TCP_MSS_DEFAULT;
 }
 
-static struct sock *mptcp_accept(struct sock *ssk, int flags, int *err,
-				 bool kern)
-{
-	struct sock *newsk;
-
-	pr_debug("ssk=%p, listener=%p", ssk, mptcp_subflow_ctx(ssk));
-	newsk = inet_csk_accept(ssk, flags, err, kern);
-	if (!newsk)
-		return NULL;
-
-	pr_debug("newsk=%p, subflow is mptcp=%d", newsk, sk_is_mptcp(newsk));
-	if (sk_is_mptcp(newsk)) {
-		struct mptcp_subflow_context *subflow;
-		struct sock *new_mptcp_sock;
-
-		subflow = mptcp_subflow_ctx(newsk);
-		new_mptcp_sock = subflow->conn;
-
-		/* is_mptcp should be false if subflow->conn is missing, see
-		 * subflow_syn_recv_sock()
-		 */
-		if (WARN_ON_ONCE(!new_mptcp_sock)) {
-			tcp_sk(newsk)->is_mptcp = 0;
-			goto out;
-		}
-
-		newsk = new_mptcp_sock;
-		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPCAPABLEPASSIVEACK);
-	} else {
-		MPTCP_INC_STATS(sock_net(ssk),
-				MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK);
-	}
-
-out:
-	newsk->sk_kern_sock = kern;
-	return newsk;
-}
-
 void mptcp_destroy_common(struct mptcp_sock *msk, unsigned int flags)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
@@ -3802,7 +3750,6 @@ static struct proto mptcp_prot = {
 	.connect	= mptcp_connect,
 	.disconnect	= mptcp_disconnect,
 	.close		= mptcp_close,
-	.accept		= mptcp_accept,
 	.setsockopt	= mptcp_setsockopt,
 	.getsockopt	= mptcp_getsockopt,
 	.shutdown	= mptcp_shutdown,
@@ -3912,18 +3859,36 @@ static int mptcp_stream_accept(struct so
 	if (!ssk)
 		return -EINVAL;
 
-	newsk = mptcp_accept(ssk, flags, &err, kern);
+	pr_debug("ssk=%p, listener=%p", ssk, mptcp_subflow_ctx(ssk));
+	newsk = inet_csk_accept(ssk, flags, &err, kern);
 	if (!newsk)
 		return err;
 
-	lock_sock(newsk);
-
-	__inet_accept(sock, newsock, newsk);
-	if (!mptcp_is_tcpsk(newsock->sk)) {
-		struct mptcp_sock *msk = mptcp_sk(newsk);
+	pr_debug("newsk=%p, subflow is mptcp=%d", newsk, sk_is_mptcp(newsk));
+	if (sk_is_mptcp(newsk)) {
 		struct mptcp_subflow_context *subflow;
+		struct sock *new_mptcp_sock;
+
+		subflow = mptcp_subflow_ctx(newsk);
+		new_mptcp_sock = subflow->conn;
+
+		/* is_mptcp should be false if subflow->conn is missing, see
+		 * subflow_syn_recv_sock()
+		 */
+		if (WARN_ON_ONCE(!new_mptcp_sock)) {
+			tcp_sk(newsk)->is_mptcp = 0;
+			goto tcpfallback;
+		}
+
+		newsk = new_mptcp_sock;
+		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_MPCAPABLEPASSIVEACK);
+
+		newsk->sk_kern_sock = kern;
+		lock_sock(newsk);
+		__inet_accept(sock, newsock, newsk);
 
 		set_bit(SOCK_CUSTOM_SOCKOPT, &newsock->flags);
+		msk = mptcp_sk(newsk);
 		msk->in_accept_queue = 0;
 
 		/* set ssk->sk_socket of accept()ed flows to mptcp socket.
@@ -3945,6 +3910,21 @@ static int mptcp_stream_accept(struct so
 			if (unlikely(list_is_singular(&msk->conn_list)))
 				mptcp_set_state(newsk, TCP_CLOSE);
 		}
+	} else {
+		MPTCP_INC_STATS(sock_net(ssk),
+				MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK);
+tcpfallback:
+		newsk->sk_kern_sock = kern;
+		lock_sock(newsk);
+		__inet_accept(sock, newsock, newsk);
+		/* we are being invoked after accepting a non-mp-capable
+		 * flow: sk is a tcp_sk, not an mptcp one.
+		 *
+		 * Hand the socket over to tcp so all further socket ops
+		 * bypass mptcp.
+		 */
+		WRITE_ONCE(newsock->sk->sk_socket->ops,
+			   mptcp_fallback_tcp_ops(newsock->sk));
 	}
 	release_sock(newsk);
 


