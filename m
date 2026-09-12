Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC6528B4FA;
	Sat, 12 Sep 2026 08:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202992; cv=none; b=len0IU9BTgEWLMF0KKA5Gesy1A7SLlqkFpNU2mkA2vrDyH4O8Y/E5je+WWNqUFvw0mBLmKzBLkn3ihjLHnsV7J0nfeiNHkIT2vHEHmGnhDmA8sNLFvbg3S5BT53Cd+qAe7qdlZJXiPujxKbyKKjl5ttcXeO7herdgSlg2sPJjss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202992; c=relaxed/simple;
	bh=WiswbM8rjDyua33eam/FFbBK0toqHn+L8LrKPznIyhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jamfr8GZPK3E6agrTks8k872TH4YPQPHASPCoGRgVa953JapSLdY0dfbwLsLosmXqQ+tnVQLtmWQXJaYnMdgYs6/tVpPrK6j8oQSMw4X5fEXhDU1hTtzMzDUQbHC5BJy9SKwohFlTI3REwyLSCIr9pHxy/7vaQQCW8I/fkcBrh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4QDYLok; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4QDYLok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15861F000FF;
	Sat, 12 Sep 2026 08:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202991;
	bh=nfoZ1gEQO08OGYItliXClkR0OhA5N0umldOqJGJKPLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4QDYLokG4Zoy4jaaDOaKOLjLcs/WMo1TBKEY61CbWcZFtkVjd/cpdUNq9J0LuRAu
	 ncn962Vpqli2hY1uZ3XuoA2E0zD628Exmb+mQaRuUjvOhX5XFxSe0DP2jcXw7kdbxq
	 fUSemhg74ewSk+qihGrdqWubrnVRwB2ifOT7sYtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1316/1815] sunrpc: xprtsock: annotate shared socket callbacks with READ_ONCE/WRITE_ONCE
Date: Sat, 12 Sep 2026 08:51:06 +0200
Message-ID: <20260912065719.915836254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5f7955e4c4045..7f60723fa64d8 100644
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
 
@@ -1664,6 +1664,7 @@ static void xs_udp_do_set_buffer_size(struct rpc_xprt *xprt)
 {
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
 	struct sock *sk = transport->inet;
+	void (*write_space)(struct sock *sock);
 
 	if (transport->rcvsize) {
 		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
@@ -1672,7 +1673,8 @@ static void xs_udp_do_set_buffer_size(struct rpc_xprt *xprt)
 	if (transport->sndsize) {
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 		sk->sk_sndbuf = transport->sndsize * xprt->max_reqs * 2;
-		sk->sk_write_space(sk);
+		write_space = READ_ONCE(sk->sk_write_space);
+		write_space(sk);
 	}
 }
 
@@ -1988,8 +1990,8 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 		xs_save_old_callbacks(transport, sk);
 
 		sk->sk_user_data = xprt;
-		sk->sk_data_ready = xs_data_ready;
-		sk->sk_write_space = xs_udp_write_space;
+		WRITE_ONCE(sk->sk_data_ready, xs_data_ready);
+		WRITE_ONCE(sk->sk_write_space, xs_udp_write_space);
 		sk->sk_state_change = xs_local_state_change;
 		sk->sk_error_report = xs_error_report;
 		sk->sk_use_task_frag = false;
@@ -2191,8 +2193,8 @@ static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		xs_save_old_callbacks(transport, sk);
 
 		sk->sk_user_data = xprt;
-		sk->sk_data_ready = xs_data_ready;
-		sk->sk_write_space = xs_udp_write_space;
+		WRITE_ONCE(sk->sk_data_ready, xs_data_ready);
+		WRITE_ONCE(sk->sk_write_space, xs_udp_write_space);
 		sk->sk_use_task_frag = false;
 
 		xprt_set_connected(xprt);
@@ -2378,9 +2380,9 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
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



