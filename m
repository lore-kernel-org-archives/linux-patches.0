Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B88D47CC85;
	Sat, 12 Sep 2026 12:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217899; cv=none; b=DYUSEJ8Pd7C46C/zk0aKrjP06EzTE09c5I918/TwyKMdwmM1Ld47CuABXa1xUiiqVqdjhYunVRO6KrerZbtE7ZQuvrKGfMCXqzi/QKlfc90XBq6Oe/EMkQgupjqUeSQxOyTwQPk/5Y37/y0HX4tsfupCaehWUPhooAtpnNrGkCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217899; c=relaxed/simple;
	bh=mFOIXMylb5UwhzlQxw8fKwfotCiztYrEzP97BoMNRJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPp5BxXCKbt13cozt3JLNDtQScQ0aFj3UGsbeqV06DbrHMduOn2uQpwxmwQ2LAcPpxM3XExx/nHgHFsyoe/P7M+w/MWzVL3yJXwLw9wTK1UTEs8vfjz9pBsJyCqeaaP+za2YbdvZ0zI8eOesKRQZOfVDYmPrd55YTE/JpHYaDNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuMm18/o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuMm18/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE151F000FF;
	Sat, 12 Sep 2026 12:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217898;
	bh=9WKFxoHuDzjII/V+pZCIrhBTPTb6WMEFQBPUS0Qi2jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuMm18/oC29pSXcHXKCtbhLHy069vITiUVCzVvTaNyb9+PgFAGR/fih/yxto9Cm3Y
	 wdPoAEwRuwMd8QvLcMg2jVLU7S9L1hxIrnSC0SvZAz9MWJMtPsEFJek7J5OzNFju4W
	 AMzme0mnkYO33mexmmXKUOHt6GK/WY4B840f0IVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1035/1376] sunrpc: xprtsock: annotate shared socket callbacks with READ_ONCE/WRITE_ONCE
Date: Sat, 12 Sep 2026 08:57:41 +0200
Message-ID: <20260912065630.627124035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 33930840b5f0a79f826e7c69dc6cd78f72a67481 ]

xprtsock replaces and restores sk->sk_data_ready and
sk->sk_write_space on live sockets with plain stores, and
xs_udp_do_set_buffer_size() invokes sk->sk_write_space via a plain
load. These callback pointers are shared with generic socket and
protocol paths that may read or invoke them concurrently, so xprtsock
needs the same READ_ONCE()/WRITE_ONCE() callback visibility contract
that the validated 4022 family applied elsewhere.

When SUNRPC takes over an AF_LOCAL, UDP, or TCP socket and later
restores the lower-socket callbacks during teardown, another CPU may
still hold an earlier callback snapshot. The plain replace/restore
pattern leaves the same visibility hole as the validated 4022 family,
so a stale snapshot can still invoke xs_data_ready() or
xs_udp_write_space() after the live callback fields have already been
restored to the lower-socket handlers.

Use WRITE_ONCE() for the shared sk_data_ready and sk_write_space
stores in xs_local_finish_connecting(), xs_udp_finish_connecting(),
xs_tcp_finish_connecting(), and xs_restore_old_callbacks(). Use
READ_ONCE() for the direct sk_write_space invocation in
xs_udp_do_set_buffer_size(). This matches the required callback
visibility contract while leaving adjacent sk_state_change and
sk_error_report handling unchanged.

Fixes: a246b0105bbd ("[PATCH] RPC: introduce client-side transport switch")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 1901f397b4908..b021c9b8477c1 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1202,9 +1202,9 @@ static void xs_save_old_callbacks(struct sock_xprt *transport, struct sock *sk)
 
 static void xs_restore_old_callbacks(struct sock_xprt *transport, struct sock *sk)
 {
-	sk->sk_data_ready = transport->old_data_ready;
+	WRITE_ONCE(sk->sk_data_ready, transport->old_data_ready);
 	sk->sk_state_change = transport->old_state_change;
-	sk->sk_write_space = transport->old_write_space;
+	WRITE_ONCE(sk->sk_write_space, transport->old_write_space);
 	sk->sk_error_report = transport->old_error_report;
 }
 
@@ -1663,6 +1663,7 @@ static void xs_udp_do_set_buffer_size(struct rpc_xprt *xprt)
 {
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
 	struct sock *sk = transport->inet;
+	void (*write_space)(struct sock *sock);
 
 	if (transport->rcvsize) {
 		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
@@ -1671,7 +1672,8 @@ static void xs_udp_do_set_buffer_size(struct rpc_xprt *xprt)
 	if (transport->sndsize) {
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 		sk->sk_sndbuf = transport->sndsize * xprt->max_reqs * 2;
-		sk->sk_write_space(sk);
+		write_space = READ_ONCE(sk->sk_write_space);
+		write_space(sk);
 	}
 }
 
@@ -1987,8 +1989,8 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 		xs_save_old_callbacks(transport, sk);
 
 		sk->sk_user_data = xprt;
-		sk->sk_data_ready = xs_data_ready;
-		sk->sk_write_space = xs_udp_write_space;
+		WRITE_ONCE(sk->sk_data_ready, xs_data_ready);
+		WRITE_ONCE(sk->sk_write_space, xs_udp_write_space);
 		sk->sk_state_change = xs_local_state_change;
 		sk->sk_error_report = xs_error_report;
 		sk->sk_use_task_frag = false;
@@ -2190,8 +2192,8 @@ static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		xs_save_old_callbacks(transport, sk);
 
 		sk->sk_user_data = xprt;
-		sk->sk_data_ready = xs_data_ready;
-		sk->sk_write_space = xs_udp_write_space;
+		WRITE_ONCE(sk->sk_data_ready, xs_data_ready);
+		WRITE_ONCE(sk->sk_write_space, xs_udp_write_space);
 		sk->sk_use_task_frag = false;
 
 		xprt_set_connected(xprt);
@@ -2377,9 +2379,9 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		xs_save_old_callbacks(transport, sk);
 
 		sk->sk_user_data = xprt;
-		sk->sk_data_ready = xs_data_ready;
+		WRITE_ONCE(sk->sk_data_ready, xs_data_ready);
 		sk->sk_state_change = xs_tcp_state_change;
-		sk->sk_write_space = xs_tcp_write_space;
+		WRITE_ONCE(sk->sk_write_space, xs_tcp_write_space);
 		sk->sk_error_report = xs_error_report;
 		sk->sk_use_task_frag = false;
 
-- 
2.53.0



