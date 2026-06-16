Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8613DA5A8;
	Tue, 16 Jun 2026 19:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636716; cv=none; b=q2TbgjfI1nlToYpS4IwSA7dA3f9y1AX/2c9D4uM0AgqmJ8waGsArgEAhsrLHAElTUWEaONY8IFZ4vTuqqpU9m7XpWlfEDqTM6CtR98bO8zq4nLDkbQ8e5kxqS9d7pt7ucVhuL+r1QSOHbQgEQNKnS2ivYFzOL0OlCuKmqVo6fRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636716; c=relaxed/simple;
	bh=cOKmtjqLETH7CFIeTranu1CrqlIcA1G3tVHVTK31U2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqt0D+zueoMKXnu141a5xRDOd1GmY5hkbhYoxp0M+BpuBNOrYH1rTpFMADEL7h/p5eGoRbbr32hfC9h09HLZHFAw2mZ8gMSgIJL0kE1aCJ0kax/z5h/Xp0lvwdCs1R26CIqoN6xp8Y6usQA1afSJ9mSV/370obuAG6U7faEfTRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAJpB2Le; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAJpB2Le"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2A81F000E9;
	Tue, 16 Jun 2026 19:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636715;
	bh=7C1IT9mdaG3Gk064FTpq1V4QHb+InuQ3JGGKj2/+nIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fAJpB2Le2/EJjUE8LIxB0lwnu6duJZcQZQB6NZTN6ft9Qh5EoHX0+G8qCx9563Bqa
	 Tfo7HM81DqG7AEZ6xJOdYiuHnL2CZyE9MW4FrNZqIjYMjwUAnusGMad8BYrICcktlq
	 bujfPaSZjJ6y4+mEmfGISpggC914Nsl9SSOT28gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 284/342] Bluetooth: Consolidate code around sk_alloc into a helper function
Date: Tue, 16 Jun 2026 20:29:40 +0530
Message-ID: <20260616145101.637450836@linuxfoundation.org>
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

[ Upstream commit 6bfa273e533d7b25eee3d74e28a7fe8e6a8e7a93 ]

This consolidates code around sk_alloc into bt_sock_alloc which does
take care of common initialization.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: e83f5e24da74 ("Bluetooth: serialize accept_q access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/bluetooth.h |    2 ++
 net/bluetooth/af_bluetooth.c      |   21 +++++++++++++++++++++
 net/bluetooth/bnep/sock.c         |   10 +---------
 net/bluetooth/hci_sock.c          |   10 ++--------
 net/bluetooth/l2cap_sock.c        |   10 +---------
 net/bluetooth/rfcomm/sock.c       |   13 +++----------
 net/bluetooth/sco.c               |   10 +---------
 7 files changed, 31 insertions(+), 45 deletions(-)

--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -314,6 +314,8 @@ int  bt_sock_register(int proto, const s
 void bt_sock_unregister(int proto);
 void bt_sock_link(struct bt_sock_list *l, struct sock *s);
 void bt_sock_unlink(struct bt_sock_list *l, struct sock *s);
+struct sock *bt_sock_alloc(struct net *net, struct socket *sock,
+			   struct proto *prot, int proto, gfp_t prio, int kern);
 int  bt_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		     int flags);
 int  bt_sock_stream_recvmsg(struct socket *sock, struct msghdr *msg,
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -138,6 +138,27 @@ static int bt_sock_create(struct net *ne
 	return err;
 }
 
+struct sock *bt_sock_alloc(struct net *net, struct socket *sock,
+			   struct proto *prot, int proto, gfp_t prio, int kern)
+{
+	struct sock *sk;
+
+	sk = sk_alloc(net, PF_BLUETOOTH, prio, prot, kern);
+	if (!sk)
+		return NULL;
+
+	sock_init_data(sock, sk);
+	INIT_LIST_HEAD(&bt_sk(sk)->accept_q);
+
+	sock_reset_flag(sk, SOCK_ZAPPED);
+
+	sk->sk_protocol = proto;
+	sk->sk_state    = BT_OPEN;
+
+	return sk;
+}
+EXPORT_SYMBOL(bt_sock_alloc);
+
 void bt_sock_link(struct bt_sock_list *l, struct sock *sk)
 {
 	write_lock(&l->lock);
--- a/net/bluetooth/bnep/sock.c
+++ b/net/bluetooth/bnep/sock.c
@@ -204,21 +204,13 @@ static int bnep_sock_create(struct net *
 	if (sock->type != SOCK_RAW)
 		return -ESOCKTNOSUPPORT;
 
-	sk = sk_alloc(net, PF_BLUETOOTH, GFP_ATOMIC, &bnep_proto, kern);
+	sk = bt_sock_alloc(net, sock, &bnep_proto, protocol, GFP_ATOMIC, kern);
 	if (!sk)
 		return -ENOMEM;
 
-	sock_init_data(sock, sk);
-
 	sock->ops = &bnep_sock_ops;
-
 	sock->state = SS_UNCONNECTED;
 
-	sock_reset_flag(sk, SOCK_ZAPPED);
-
-	sk->sk_protocol = protocol;
-	sk->sk_state	= BT_OPEN;
-
 	bt_sock_link(&bnep_sk_list, sk);
 	return 0;
 }
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -2091,18 +2091,12 @@ static int hci_sock_create(struct net *n
 
 	sock->ops = &hci_sock_ops;
 
-	sk = sk_alloc(net, PF_BLUETOOTH, GFP_ATOMIC, &hci_sk_proto, kern);
+	sk = bt_sock_alloc(net, sock, &hci_sk_proto, protocol, GFP_ATOMIC,
+			   kern);
 	if (!sk)
 		return -ENOMEM;
 
-	sock_init_data(sock, sk);
-
-	sock_reset_flag(sk, SOCK_ZAPPED);
-
-	sk->sk_protocol = protocol;
-
 	sock->state = SS_UNCONNECTED;
-	sk->sk_state = BT_OPEN;
 	sk->sk_destruct = hci_sock_destruct;
 
 	bt_sock_link(&hci_sk_list, sk);
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1901,21 +1901,13 @@ static struct sock *l2cap_sock_alloc(str
 	struct sock *sk;
 	struct l2cap_chan *chan;
 
-	sk = sk_alloc(net, PF_BLUETOOTH, prio, &l2cap_proto, kern);
+	sk = bt_sock_alloc(net, sock, &l2cap_proto, proto, prio, kern);
 	if (!sk)
 		return NULL;
 
-	sock_init_data(sock, sk);
-	INIT_LIST_HEAD(&bt_sk(sk)->accept_q);
-
 	sk->sk_destruct = l2cap_sock_destruct;
 	sk->sk_sndtimeo = L2CAP_CONN_TIMEOUT;
 
-	sock_reset_flag(sk, SOCK_ZAPPED);
-
-	sk->sk_protocol = proto;
-	sk->sk_state = BT_OPEN;
-
 	chan = l2cap_chan_create();
 	if (!chan) {
 		sk_free(sk);
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -280,18 +280,16 @@ static struct proto rfcomm_proto = {
 	.obj_size	= sizeof(struct rfcomm_pinfo)
 };
 
-static struct sock *rfcomm_sock_alloc(struct net *net, struct socket *sock, int proto, gfp_t prio, int kern)
+static struct sock *rfcomm_sock_alloc(struct net *net, struct socket *sock,
+				      int proto, gfp_t prio, int kern)
 {
 	struct rfcomm_dlc *d;
 	struct sock *sk;
 
-	sk = sk_alloc(net, PF_BLUETOOTH, prio, &rfcomm_proto, kern);
+	sk = bt_sock_alloc(net, sock, &rfcomm_proto, proto, prio, kern);
 	if (!sk)
 		return NULL;
 
-	sock_init_data(sock, sk);
-	INIT_LIST_HEAD(&bt_sk(sk)->accept_q);
-
 	d = rfcomm_dlc_alloc(prio);
 	if (!d) {
 		sk_free(sk);
@@ -310,11 +308,6 @@ static struct sock *rfcomm_sock_alloc(st
 	sk->sk_sndbuf = RFCOMM_MAX_CREDITS * RFCOMM_DEFAULT_MTU * 10;
 	sk->sk_rcvbuf = RFCOMM_MAX_CREDITS * RFCOMM_DEFAULT_MTU * 10;
 
-	sock_reset_flag(sk, SOCK_ZAPPED);
-
-	sk->sk_protocol = proto;
-	sk->sk_state    = BT_OPEN;
-
 	bt_sock_link(&rfcomm_sk_list, sk);
 
 	BT_DBG("sk %p", sk);
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -491,21 +491,13 @@ static struct sock *sco_sock_alloc(struc
 {
 	struct sock *sk;
 
-	sk = sk_alloc(net, PF_BLUETOOTH, prio, &sco_proto, kern);
+	sk = bt_sock_alloc(net, sock, &sco_proto, proto, prio, kern);
 	if (!sk)
 		return NULL;
 
-	sock_init_data(sock, sk);
-	INIT_LIST_HEAD(&bt_sk(sk)->accept_q);
-
 	sk->sk_destruct = sco_sock_destruct;
 	sk->sk_sndtimeo = SCO_CONN_TIMEOUT;
 
-	sock_reset_flag(sk, SOCK_ZAPPED);
-
-	sk->sk_protocol = proto;
-	sk->sk_state    = BT_OPEN;
-
 	sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
 
 	bt_sock_link(&sco_sk_list, sk);


