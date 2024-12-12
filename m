Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8B3222D72;
	Thu, 12 Dec 2024 17:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022932; cv=none; b=hWeRiW0jt+DFA6oPIXIWTRmVxE5JEFjE4HYxzmWkccpdAvUxpbOXALF3MPTtMm+HZYLE1ZXNWgvhtIeD7aYbahioRcHbVIWoQgBIPm4ZeSFbcnO/AOk62LyoDUbZI4Ea7Zr2uXMxtqOvawmJU8A+Yg6svABhJY8q1QU5+JWucsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022932; c=relaxed/simple;
	bh=jRDZW6kSo2OBSaDtqhKmq7TFzsmRarhmhoS7dKDzvcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCVoH5wkmy72vDwSv9Auy0rfuVWZh1O5SHsTXjQPcO5Mc3+hQZu6Ha8kWGctKcxvUTS/39cxLZ9bE+W1CegkCyldvzTzYhag6poJzn/G3hMN+IdaNp309FuoxrVqRBfUjkDsjPLpURqeQ8vfuxm6q1kMs6LXa0qfMGsPG/3JB1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CedcCwea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CedcCwea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9634C4CECE;
	Thu, 12 Dec 2024 17:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022932;
	bh=jRDZW6kSo2OBSaDtqhKmq7TFzsmRarhmhoS7dKDzvcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CedcCweaSdQsLk/m8DG/WiEGwdoVJT9rZ5DZZgP+cOnW4pQ12MQSRWMYzPS3Kfqxq
	 QfXL0btjIARObrtQKHCwMKtp46iP58qw8VQCudmUyP/2qfJXQhcIjq0J/Za++q+Nhu
	 kTD+G/2BolzxUXc9k0Z735Xd6rcg9WZW2/dQduOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 372/565] SUNRPC: Replace internal use of SOCKWQ_ASYNC_NOSPACE
Date: Thu, 12 Dec 2024 15:59:27 +0100
Message-ID: <20241212144326.329008874@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5601217febaa3..06ea4fb2d4532 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -779,14 +779,8 @@ static int xs_nospace(struct rpc_rqst *req, struct sock_xprt *transport)
 
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
@@ -1148,6 +1142,7 @@ static void xs_sock_reset_state_flags(struct rpc_xprt *xprt)
 	clear_bit(XPRT_SOCK_WAKE_ERROR, &transport->sock_state);
 	clear_bit(XPRT_SOCK_WAKE_WRITE, &transport->sock_state);
 	clear_bit(XPRT_SOCK_WAKE_DISCONNECT, &transport->sock_state);
+	clear_bit(XPRT_SOCK_NOSPACE, &transport->sock_state);
 }
 
 static void xs_run_error_worker(struct sock_xprt *transport, unsigned int nr)
@@ -1511,7 +1506,6 @@ static void xs_tcp_state_change(struct sock *sk)
 
 static void xs_write_space(struct sock *sk)
 {
-	struct socket_wq *wq;
 	struct sock_xprt *transport;
 	struct rpc_xprt *xprt;
 
@@ -1522,15 +1516,10 @@ static void xs_write_space(struct sock *sk)
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
@@ -1874,7 +1863,6 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 		sk->sk_user_data = xprt;
 		sk->sk_data_ready = xs_data_ready;
 		sk->sk_write_space = xs_udp_write_space;
-		sock_set_flag(sk, SOCK_FASYNC);
 		sk->sk_error_report = xs_error_report;
 
 		xprt_clear_connected(xprt);
@@ -2072,7 +2060,6 @@ static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_user_data = xprt;
 		sk->sk_data_ready = xs_data_ready;
 		sk->sk_write_space = xs_udp_write_space;
-		sock_set_flag(sk, SOCK_FASYNC);
 
 		xprt_set_connected(xprt);
 
@@ -2237,7 +2224,6 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		sk->sk_data_ready = xs_data_ready;
 		sk->sk_state_change = xs_tcp_state_change;
 		sk->sk_write_space = xs_tcp_write_space;
-		sock_set_flag(sk, SOCK_FASYNC);
 		sk->sk_error_report = xs_error_report;
 
 		/* socket options */
-- 
2.43.0



