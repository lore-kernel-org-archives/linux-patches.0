Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455ED313E04;
	Tue,  2 Sep 2025 13:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819758; cv=none; b=j9RLYsVq4mgmi2LIej6fUokkdvvRy3+2KIq77x3yxU+2T/h/bn9PVE+I986daubvgF5ZhoSlw/JibHztpM03Bq4Tuwb3c2YrrhGi7vlYCfU/AMc4XKSXMbLxPxuT6HAaM2bc9u30TkYBdiX71IfRn457E1cx63aY5TT7e0EXbUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819758; c=relaxed/simple;
	bh=En3w9yI5fXBjunoeS4Ezr2Ic/mhETn7vfgtO463NMjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmELqlObx6ve1endQonrhjSzniYq/lQ/j7Cced+7jnTUvhJkqaiGOzoHyikDsLXqFASTrH6/Foa19qBgbxrQWrfJdsYRtle0yOJwJPHoVhdH9HHBP6n/xLOqr2okGLD0tfL/qZSsfXW1fgZgWwOkW4cwGht7TK1ysbsISvRaey0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tvXAYHG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tvXAYHG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FCBC4CEED;
	Tue,  2 Sep 2025 13:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819758;
	bh=En3w9yI5fXBjunoeS4Ezr2Ic/mhETn7vfgtO463NMjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tvXAYHG7KOeQAwXpDU5+ypz6ekqjIpK4KsTZn8SGj01JP5LuiiICOmZmCAtQFE1kc
	 CA4udVgMyn2z37l3tFYZaM4PSZ6xSVsHVFKTOv6O8V3jnXcPn5V1kJ4BalVHDR6i0w
	 DFquv74oafajCTFTFZ6ZZEas/44YlW19+oqe/vGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	James Chapman <jchapman@katalix.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 098/142] l2tp: do not use sock_hold() in pppol2tp_session_get_sock()
Date: Tue,  2 Sep 2025 15:20:00 +0200
Message-ID: <20250902131952.026445742@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9b8c88f875c04d4cb9111bd5dd9291c7e9691bf5 ]

pppol2tp_session_get_sock() is using RCU, it must be ready
for sk_refcnt being zero.

Commit ee40fb2e1eb5 ("l2tp: protect sock pointer of
struct pppol2tp_session with RCU") was correct because it
had a call_rcu(..., pppol2tp_put_sk) which was later removed in blamed commit.

pppol2tp_recv() can use pppol2tp_session_get_sock() as well.

Fixes: c5cbaef992d6 ("l2tp: refactor ppp socket/session relationship")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: James Chapman <jchapman@katalix.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20250826134435.1683435-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_ppp.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index fc5c2fd8f34c7..5e12e7ce17d8a 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -129,22 +129,12 @@ static const struct ppp_channel_ops pppol2tp_chan_ops = {
 
 static const struct proto_ops pppol2tp_ops;
 
-/* Retrieves the pppol2tp socket associated to a session.
- * A reference is held on the returned socket, so this function must be paired
- * with sock_put().
- */
+/* Retrieves the pppol2tp socket associated to a session. */
 static struct sock *pppol2tp_session_get_sock(struct l2tp_session *session)
 {
 	struct pppol2tp_session *ps = l2tp_session_priv(session);
-	struct sock *sk;
-
-	rcu_read_lock();
-	sk = rcu_dereference(ps->sk);
-	if (sk)
-		sock_hold(sk);
-	rcu_read_unlock();
 
-	return sk;
+	return rcu_dereference(ps->sk);
 }
 
 /* Helpers to obtain tunnel/session contexts from sockets.
@@ -206,14 +196,13 @@ static int pppol2tp_recvmsg(struct socket *sock, struct msghdr *msg,
 
 static void pppol2tp_recv(struct l2tp_session *session, struct sk_buff *skb, int data_len)
 {
-	struct pppol2tp_session *ps = l2tp_session_priv(session);
-	struct sock *sk = NULL;
+	struct sock *sk;
 
 	/* If the socket is bound, send it in to PPP's input queue. Otherwise
 	 * queue it on the session socket.
 	 */
 	rcu_read_lock();
-	sk = rcu_dereference(ps->sk);
+	sk = pppol2tp_session_get_sock(session);
 	if (!sk)
 		goto no_sock;
 
@@ -510,13 +499,14 @@ static void pppol2tp_show(struct seq_file *m, void *arg)
 	struct l2tp_session *session = arg;
 	struct sock *sk;
 
+	rcu_read_lock();
 	sk = pppol2tp_session_get_sock(session);
 	if (sk) {
 		struct pppox_sock *po = pppox_sk(sk);
 
 		seq_printf(m, "   interface %s\n", ppp_dev_name(&po->chan));
-		sock_put(sk);
 	}
+	rcu_read_unlock();
 }
 
 static void pppol2tp_session_init(struct l2tp_session *session)
@@ -1530,6 +1520,7 @@ static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
 		port = ntohs(inet->inet_sport);
 	}
 
+	rcu_read_lock();
 	sk = pppol2tp_session_get_sock(session);
 	if (sk) {
 		state = sk->sk_state;
@@ -1565,8 +1556,8 @@ static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
 		struct pppox_sock *po = pppox_sk(sk);
 
 		seq_printf(m, "   interface %s\n", ppp_dev_name(&po->chan));
-		sock_put(sk);
 	}
+	rcu_read_unlock();
 }
 
 static int pppol2tp_seq_show(struct seq_file *m, void *v)
-- 
2.50.1



