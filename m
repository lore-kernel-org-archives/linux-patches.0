Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D97217F40;
	Thu, 12 Dec 2024 17:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024475; cv=none; b=mSuL7JhCdo7WALdTN2Ord8nFO0cvJYFM4FQVPRKkY2MRjJERnCph1/ow7J1Ca6JRB1nAhxaDdv3JO34pH5C6Re3c26QD+RFw22/XW3PC5d6uM+Y/7mS0sLwX+Vm3KAyxzG8XcY5WBD6KIY/kR1jk6FxkSWEQs0/FCIn+Kt5He3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024475; c=relaxed/simple;
	bh=Ws7HaOAx6Y5pVuolDF0CH31rEkOYNHVBox+VrMfF3v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GY9Gn/Gmdj82ZXR/YGuPcIIOQ1ov8Q2VySnESXqwTgNOB/4khFucrBwRS31aMSOSx0gK9H7+revJM6yP/T7G8bkjS/6vd+gAyp1O645E2kMi8tqtN9yoCWjr60t0Kl8eGc/DsTTnMVLr1Hqf7u7tKlmPeAl7M3UX6+KU1jnSptQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSISjClB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSISjClB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75D9C4CED3;
	Thu, 12 Dec 2024 17:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024475;
	bh=Ws7HaOAx6Y5pVuolDF0CH31rEkOYNHVBox+VrMfF3v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSISjClBFvj2IdhHDHlqfBnw4ZnYL7HY79DE9LBVGVE6hJ96or/d/21kc2tXeUenM
	 1BdtVYwAYWwHxd2C1V1U6FyEWRAMot1AZe3SbIkKO3PVqFVOn48I5LGSDqeL6NxVYr
	 Fs31V8/aRcqT5Y3xVbNP9ZFLy2MLNEaj5rf86HTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 308/459] SUNRPC: Replace internal use of SOCKWQ_ASYNC_NOSPACE
Date: Thu, 12 Dec 2024 16:00:46 +0100
Message-ID: <20241212144305.811502279@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 2790a624d43084de590884934969e19c7a82316a ]

The socket's SOCKWQ_ASYNC_NOSPACE can be cleared by various actors in
the socket layer, so replace it with our own flag in the transport
sock_state field.

Reported-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 4db9ad82a6c8 ("sunrpc: clear XPRT_SOCK_UPD_TIMEOUT when reset transport")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xprtsock.h |  1 +
 net/sunrpc/xprtsock.c           | 22 ++++------------------
 2 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
index 689062afdd610..3eb0079669c50 100644
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -90,5 +90,6 @@ struct sock_xprt {
 #define XPRT_SOCK_WAKE_PENDING	(6)
 #define XPRT_SOCK_WAKE_DISCONNECT	(7)
 #define XPRT_SOCK_CONNECT_SENT	(8)
+#define XPRT_SOCK_NOSPACE	(9)
 
 #endif /* _LINUX_SUNRPC_XPRTSOCK_H */
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 93e59d5a363d0..278d044e1fd4a 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -770,14 +770,8 @@ static int xs_nospace(struct rpc_rqst *req, struct sock_xprt *transport)
 
 	/* Don't race with disconnect */
 	if (xprt_connected(xprt)) {
-		struct socket_wq *wq;
-
-		rcu_read_lock();
-		wq = rcu_dereference(sk->sk_wq);
-		set_bit(SOCKWQ_ASYNC_NOSPACE, &wq->flags);
-		rcu_read_unlock();
-
 		/* wait for more buffer space */
+		set_bit(XPRT_SOCK_NOSPACE, &transport->sock_state);
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		sk->sk_write_pending++;
 		xprt_wait_for_buffer_space(xprt);
@@ -1134,6 +1128,7 @@ static void xs_sock_reset_state_flags(struct rpc_xprt *xprt)
 	clear_bit(XPRT_SOCK_WAKE_ERROR, &transport->sock_state);
 	clear_bit(XPRT_SOCK_WAKE_WRITE, &transport->sock_state);
 	clear_bit(XPRT_SOCK_WAKE_DISCONNECT, &transport->sock_state);
+	clear_bit(XPRT_SOCK_NOSPACE, &transport->sock_state);
 }
 
 static void xs_run_error_worker(struct sock_xprt *transport, unsigned int nr)
@@ -1497,7 +1492,6 @@ static void xs_tcp_state_change(struct sock *sk)
 
 static void xs_write_space(struct sock *sk)
 {
-	struct socket_wq *wq;
 	struct sock_xprt *transport;
 	struct rpc_xprt *xprt;
 
@@ -1508,15 +1502,10 @@ static void xs_write_space(struct sock *sk)
 	if (unlikely(!(xprt = xprt_from_sock(sk))))
 		return;
 	transport = container_of(xprt, struct sock_xprt, xprt);
-	rcu_read_lock();
-	wq = rcu_dereference(sk->sk_wq);
-	if (!wq || test_and_clear_bit(SOCKWQ_ASYNC_NOSPACE, &wq->flags) == 0)
-		goto out;
-
+	if (!test_and_clear_bit(XPRT_SOCK_NOSPACE, &transport->sock_state))
+		return;
 	xs_run_error_worker(transport, XPRT_SOCK_WAKE_WRITE);
 	sk->sk_write_pending--;
-out:
-	rcu_read_unlock();
 }
 
 /**
@@ -1860,7 +1849,6 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 		sk->sk_user_data = xprt;
 		sk->sk_data_ready = xs_data_ready;
 		sk->sk_write_space = xs_udp_write_space;
-		sock_set_flag(sk, SOCK_FASYNC);
 		sk->sk_error_report = xs_error_report;
 
 		xprt_clear_connected(xprt);
@@ -2058,7 +2046,6 @@ static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_user_data = xprt;
 		sk->sk_data_ready = xs_data_ready;
 		sk->sk_write_space = xs_udp_write_space;
-		sock_set_flag(sk, SOCK_FASYNC);
 
 		xprt_set_connected(xprt);
 
@@ -2214,7 +2201,6 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_data_ready = xs_data_ready;
 		sk->sk_state_change = xs_tcp_state_change;
 		sk->sk_write_space = xs_tcp_write_space;
-		sock_set_flag(sk, SOCK_FASYNC);
 		sk->sk_error_report = xs_error_report;
 
 		/* socket options */
-- 
2.43.0



