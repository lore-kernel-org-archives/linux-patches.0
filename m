Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800673DD51C;
	Tue, 16 Jun 2026 19:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636773; cv=none; b=jMUspuEocB3uhvhrH3yAs9wLCkSpDac/XHrIkG9rGnxJ8VCtqGjbHTNpsWCY3f/Z7N9qDlgiP+qPCAWD2WKaBoqS/2U0B4HAzp9AbUnHOcqjuDVKK9m1IuPARMbbm/VANlcA3A50LhZc+BWkIupELoAEd6GVAoMrdazLT6lVu1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636773; c=relaxed/simple;
	bh=x2EkrbdnC5AjLGo1lchO1smrrbSOXgNHuNxMoLBosdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c++LSrnY/6vw/3/aeauTiJs3VcFhyJ3Co1st4lzcCMnMTN609aIu6z6TgWW8tQKXAW/aWqJddJ0f2nFmwQZtIMo0llTB8Y2Q/3oigcoiqalgi6LqKD3TdaXmOolO81PiHBRso/5vyATgXa8B+vqotfSgFKrJ34FARRjsBqzAPtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zobC8bC5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zobC8bC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DEA1F000E9;
	Tue, 16 Jun 2026 19:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636772;
	bh=9VbOwgRxOi/gVD395v4YCFmTr8aTn3Ulp0KLSPov4/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zobC8bC50BK3L9r/vjb1xFLzxMr6pSOEJ++HK6dulPlIMiiD6n0GWKWROVcbZgtle
	 tEfC3EClEDxIm2eRVD1bMFgilg6c/De2MvFAViBrXipkSBS9v7q8fCND3Rv/LzAdvh
	 VZ+j7G3g9rA6bJOUUdK61htZUgPG4K+2L3KKlBN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/342] Bluetooth: Init sk_peer_* on bt_sock_alloc
Date: Tue, 16 Jun 2026 20:29:41 +0530
Message-ID: <20260616145101.685199363@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 464c702fb9374ff8f3f816f24fb7ac719dd20e1e ]

This makes sure peer information is always available via sock when using
bt_sock_alloc.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: e83f5e24da74 ("Bluetooth: serialize accept_q access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/af_bluetooth.c |   24 ++++++++++++++++++++++++
 net/bluetooth/hidp/sock.c    |   10 +---------
 net/bluetooth/l2cap_sock.c   |   19 -------------------
 3 files changed, 25 insertions(+), 28 deletions(-)

--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -155,6 +155,14 @@ struct sock *bt_sock_alloc(struct net *n
 	sk->sk_protocol = proto;
 	sk->sk_state    = BT_OPEN;
 
+	/* Init peer information so it can be properly monitored */
+	if (!kern) {
+		spin_lock(&sk->sk_peer_lock);
+		sk->sk_peer_pid  = get_pid(task_tgid(current));
+		sk->sk_peer_cred = get_current_cred();
+		spin_unlock(&sk->sk_peer_lock);
+	}
+
 	return sk;
 }
 EXPORT_SYMBOL(bt_sock_alloc);
@@ -177,6 +185,9 @@ EXPORT_SYMBOL(bt_sock_unlink);
 
 void bt_accept_enqueue(struct sock *parent, struct sock *sk, bool bh)
 {
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
 	BT_DBG("parent %p, sk %p", parent, sk);
 
 	sock_hold(sk);
@@ -189,6 +200,19 @@ void bt_accept_enqueue(struct sock *pare
 	list_add_tail(&bt_sk(sk)->accept_q, &bt_sk(parent)->accept_q);
 	bt_sk(sk)->parent = parent;
 
+	/* Copy credentials from parent since for incoming connections the
+	 * socket is allocated by the kernel.
+	 */
+	spin_lock(&sk->sk_peer_lock);
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
+	sk->sk_peer_pid = get_pid(parent->sk_peer_pid);
+	sk->sk_peer_cred = get_cred(parent->sk_peer_cred);
+	spin_unlock(&sk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
+
 	if (bh)
 		bh_unlock_sock(sk);
 	else
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -255,21 +255,13 @@ static int hidp_sock_create(struct net *
 	if (sock->type != SOCK_RAW)
 		return -ESOCKTNOSUPPORT;
 
-	sk = sk_alloc(net, PF_BLUETOOTH, GFP_ATOMIC, &hidp_proto, kern);
+	sk = bt_sock_alloc(net, sock, &hidp_proto, protocol, GFP_ATOMIC, kern);
 	if (!sk)
 		return -ENOMEM;
 
-	sock_init_data(sock, sk);
-
 	sock->ops = &hidp_sock_ops;
-
 	sock->state = SS_UNCONNECTED;
 
-	sock_reset_flag(sk, SOCK_ZAPPED);
-
-	sk->sk_protocol = protocol;
-	sk->sk_state	= BT_OPEN;
-
 	bt_sock_link(&hidp_sk_list, sk);
 
 	return 0;
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -177,21 +177,6 @@ done:
 	return err;
 }
 
-static void l2cap_sock_init_pid(struct sock *sk)
-{
-	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
-
-	/* Only L2CAP_MODE_EXT_FLOWCTL ever need to access the PID in order to
-	 * group the channels being requested.
-	 */
-	if (chan->mode != L2CAP_MODE_EXT_FLOWCTL)
-		return;
-
-	spin_lock(&sk->sk_peer_lock);
-	sk->sk_peer_pid = get_pid(task_tgid(current));
-	spin_unlock(&sk->sk_peer_lock);
-}
-
 static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr,
 			      int alen, int flags)
 {
@@ -267,8 +252,6 @@ static int l2cap_sock_connect(struct soc
 	    chan->mode != L2CAP_MODE_EXT_FLOWCTL)
 		chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
-	l2cap_sock_init_pid(sk);
-
 	err = l2cap_chan_connect(chan, la.l2_psm, __le16_to_cpu(la.l2_cid),
 				 &la.l2_bdaddr, la.l2_bdaddr_type);
 	if (err)
@@ -324,8 +307,6 @@ static int l2cap_sock_listen(struct sock
 		goto done;
 	}
 
-	l2cap_sock_init_pid(sk);
-
 	sk->sk_max_ack_backlog = backlog;
 	sk->sk_ack_backlog = 0;
 


