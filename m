Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB0B30EF7E;
	Tue, 21 Jul 2026 19:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663638; cv=none; b=Jnsuoj12HyVZEspjfaMSl+KzI+i12olGKZ6rLjsFMkEXzBYqCJJS4vXhEvR3E/5HdPWXlonMBcRzqvsQOUhZMmBniL4ikZfjoxtvf1M3SkXWTenMVWZIY1UZCXmiIcl17MeY7VT46vdxJXTdfgJ/s3Htj7U8f3r5mdgn408KKXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663638; c=relaxed/simple;
	bh=ls0dpcbYeTYdz94TKwhVjZ7LMbpHQpM5Zk6aJVHX9+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaIQoUwZYYIUIH4d5PfLHMZRD/SXu8KDtJCvaegk2/vJIILJZ2Plafr1Mqs1ApxLDlRiRDMsniEcCadoN+vBUJii23fzFjDKK5n/q0lT6D57cqbAFTnx4HalZveB/i7NiEV96Iqt7l0Ce4Ul8/GLIzz/x4UxxW2aMrW7l8WZRbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qniYYRY+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qniYYRY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5321F000E9;
	Tue, 21 Jul 2026 19:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663637;
	bh=ZrJPsO6DlPMQR1Ll1z6iN8qR8BwoD0FbYWePbcREx3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qniYYRY+f9EqNfUxD6CS1fsXgD8mmciC2RSF3opbI3ykEm4f7uJ8Q83Om7OfTq/HM
	 KdwRG2sSNmhZPqFnp5dUxkfumrvnl2A3aFVvFcGPTB66Wm6081PXeEbAeHlIW/QpVJ
	 eZEbdHc2ZCCVyuo/dmNXBsSi5+MAWsOw30ulXs0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 0898/1276] Bluetooth: SCO: hold sk properly in sco_conn_ready
Date: Tue, 21 Jul 2026 17:22:21 +0200
Message-ID: <20260721152506.138617209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

commit 4e37f6452d586b95c346a9abdd2fb80b67794f39 upstream.

sk deref in sco_conn_ready must be done either under conn->lock, or
holding a refcount, to avoid concurrent close. conn->sk and parent sk is
currently accessed without either, and without checking parent->sk_state:

    [Task 1]            [Task 2]
                        sco_sock_release
    sco_conn_ready
      sk = conn->sk
                          lock_sock(sk)
                            conn->sk = NULL
      lock_sock(sk)
                          release_sock(sk)
                          sco_sock_kill(sk)
       UAF on sk deref

and similarly for access to sco_get_sock_listen() return value.

Fix possible UAF by holding sk refcount in sco_conn_ready() and making
sco_get_sock_listen() increase refcount. Also recheck after lock_sock
that the socket is still valid.  Adjust conn->sk locking so it's
protected also by lock_sock() of the associated socket if any.

Fixes: 27c24fda62b60 ("Bluetooth: switch to lock_sock in SCO")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/sco.c |   44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -410,9 +410,13 @@ static struct sock *sco_get_sock_listen(
 			sk1 = sk;
 	}
 
+	sk = sk ? sk : sk1;
+	if (sk)
+		sock_hold(sk);
+
 	read_unlock(&sco_sk_list.lock);
 
-	return sk ? sk : sk1;
+	return sk;
 }
 
 static void sco_sock_destruct(struct sock *sk)
@@ -452,11 +456,13 @@ static void sco_sock_kill(struct sock *s
 	BT_DBG("sk %p state %d", sk, sk->sk_state);
 
 	/* Sock is dead, so set conn->sk to NULL to avoid possible UAF */
+	lock_sock(sk);
 	if (sco_pi(sk)->conn) {
 		sco_conn_lock(sco_pi(sk)->conn);
 		sco_pi(sk)->conn->sk = NULL;
 		sco_conn_unlock(sco_pi(sk)->conn);
 	}
+	release_sock(sk);
 
 	/* Kill poor orphan */
 	bt_sock_unlink(&sco_sk_list, sk);
@@ -1305,17 +1311,28 @@ static int sco_sock_release(struct socke
 
 static void sco_conn_ready(struct sco_conn *conn)
 {
-	struct sock *parent;
-	struct sock *sk = conn->sk;
+	struct sock *parent, *sk;
+
+	sco_conn_lock(conn);
+	sk = sco_sock_hold(conn);
+	sco_conn_unlock(conn);
 
 	BT_DBG("conn %p", conn);
 
 	if (sk) {
 		lock_sock(sk);
-		sco_sock_clear_timer(sk);
-		sk->sk_state = BT_CONNECTED;
-		sk->sk_state_change(sk);
+
+		/* conn->sk may have become NULL if racing with sk close, but
+		 * due to held hdev->lock, it can't become different sk.
+		 */
+		if (conn->sk) {
+			sco_sock_clear_timer(sk);
+			sk->sk_state = BT_CONNECTED;
+			sk->sk_state_change(sk);
+		}
+
 		release_sock(sk);
+		sock_put(sk);
 	} else {
 		if (!conn->hcon)
 			return;
@@ -1330,13 +1347,15 @@ static void sco_conn_ready(struct sco_co
 
 		sco_conn_lock(conn);
 
+		/* hdev->lock guarantees conn->sk == NULL still here */
+
+		if (parent->sk_state != BT_LISTEN)
+			goto release;
+
 		sk = sco_sock_alloc(sock_net(parent), NULL,
 				    BTPROTO_SCO, GFP_ATOMIC, 0);
-		if (!sk) {
-			sco_conn_unlock(conn);
-			release_sock(parent);
-			return;
-		}
+		if (!sk)
+			goto release;
 
 		sco_sock_init(sk, parent);
 
@@ -1354,9 +1373,10 @@ static void sco_conn_ready(struct sco_co
 		/* Wake up parent */
 		parent->sk_data_ready(parent);
 
+release:
 		sco_conn_unlock(conn);
-
 		release_sock(parent);
+		sock_put(parent);
 	}
 }
 


