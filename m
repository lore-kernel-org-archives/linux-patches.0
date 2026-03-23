Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EE63BB9F0;
	Mon, 23 Mar 2026 16:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282816; cv=none; b=gX93+7eDrm9xeNjmhF5iMfTxnf0H0L4dUdQsl6fmm6n+JzR6zhkQAYQr91Be8mkLLTSvyKfhF6BXa87oHPcnzSB9G0JgkW5oR+4FWMTbAUDCiVQuIHtGQQfb0TKYSex2V/VBKE9SkOm5AeCMu61BS+JshQf7hfpUoI3Yu1y205g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282816; c=relaxed/simple;
	bh=bvnmXEIKaym+KN6GPDx7xt/VP0gY/Rh6SZRCtRML6Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BeaIxugdLXg4/hmIxIk7NBMy087cZF+CaKiMQhPofdt3vTpldlFYAHK21DYl/i+QHAzcS6EekWVONgIZAKKfhbfobG7mNO3Gu2G7LrcwmQvokUtAN8e8C10sU6LQeAp6EZqpuf7F3l2jSfkYLvO8addFpZJGT3jXeHD613F11AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyWGWcy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyWGWcy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859EBC4CEF7;
	Mon, 23 Mar 2026 16:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282815;
	bh=bvnmXEIKaym+KN6GPDx7xt/VP0gY/Rh6SZRCtRML6Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyWGWcy8siDiG+LgSA4FQd1DfwG/HQ3HiUhjQPMokle6IOFCqaie3EJd+Xmgi2xbP
	 3Isi0ix+nePP7CWK7/U29lM34kiygEKQvem/38T8tLXX4/Aazp0FK43Mem2I+/NJsx
	 +QIkRU+J0c1nYzgc9t42FbvvkqgP8mTue2bQBJ54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	James Chapman <jchapman@katalix.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Qingfang Deng <dqfext@gmail.com>
Subject: [PATCH 6.1 279/481] l2tp: do not use sock_hold() in pppol2tp_session_get_sock()
Date: Mon, 23 Mar 2026 14:44:21 +0100
Message-ID: <20260323134531.917194364@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 9b8c88f875c04d4cb9111bd5dd9291c7e9691bf5 upstream.

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
Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ppp.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -130,22 +130,12 @@ static const struct ppp_channel_ops pppo
 
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
 
-	rcu_read_lock();
-	sk = rcu_dereference(ps->sk);
-	if (sk)
-		sock_hold(sk);
-	rcu_read_unlock();
-
-	return sk;
+	return rcu_dereference(ps->sk);
 }
 
 /* Helpers to obtain tunnel/session contexts from sockets.
@@ -211,14 +201,13 @@ end:
 
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
 
@@ -528,13 +517,14 @@ static void pppol2tp_show(struct seq_fil
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
@@ -1540,6 +1530,7 @@ static void pppol2tp_seq_session_show(st
 		port = ntohs(inet->inet_sport);
 	}
 
+	rcu_read_lock();
 	sk = pppol2tp_session_get_sock(session);
 	if (sk) {
 		state = sk->sk_state;
@@ -1575,8 +1566,8 @@ static void pppol2tp_seq_session_show(st
 		struct pppox_sock *po = pppox_sk(sk);
 
 		seq_printf(m, "   interface %s\n", ppp_dev_name(&po->chan));
-		sock_put(sk);
 	}
+	rcu_read_unlock();
 }
 
 static int pppol2tp_seq_show(struct seq_file *m, void *v)


