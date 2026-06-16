Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3EB3A5E91;
	Tue, 16 Jun 2026 17:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632578; cv=none; b=JBLIowJWS7cz953SP9NRiOE0qtU/VCev83nhFSZIXODKw5xOsx9mSsmljIHt7joJ6rxmEh6Z/i0XwNjGbnL5BIYUB6ojW0/p2n06FgUuFE6b8d4DhowIvu+6a/UdGsLB60QWfdL2jR2utDYnQ960d92fRQyCLn79LkSGd7yb2js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632578; c=relaxed/simple;
	bh=OL8MRCW6eQZBtoO7eOeAQ6Yv/tQSIthB45l03ujLyoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsqWVn2H8RT/P7B0jUwRRQxTfuTPYNYo1fwCfrdGMVbkLZ1edwGqOwq11cnaFvVMevF8By8sL+/zHWZKTGsJGeb6xUpqRv7AIXeuhocHMQ9ibnjc/cAQZKBqOTxbnks7pN1f/RD/yZ41uqGwVbk6Coafs8jqehuyZshRg4b8tsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsXLILoT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsXLILoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7021F000E9;
	Tue, 16 Jun 2026 17:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632576;
	bh=s2vlNjgDQxEGmM7p7pcsacTeoWj/GxIbZ0v3xZhe0io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsXLILoTP6tpgUn4sL22F00GRxgGBY1TH7SfO2M5SesV2A/F396+UvYOUpulXJuM5
	 dkkbZ3vNnrSNL32o+K7bj38M93PX2xPGzxiHHM+xqTJsHrNWZl0zukJ8yGOJ9Sl+Gz
	 BYmlghunE9DEZl7fciYdkRxsb16TEFUIQ8HlUXLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 436/522] Bluetooth: Init sk_peer_* on bt_sock_alloc
Date: Tue, 16 Jun 2026 20:29:43 +0530
Message-ID: <20260616145146.353727620@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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
@@ -157,6 +157,14 @@ struct sock *bt_sock_alloc(struct net *n
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
@@ -201,6 +209,9 @@ EXPORT_SYMBOL(bt_sock_linked);
 
 void bt_accept_enqueue(struct sock *parent, struct sock *sk, bool bh)
 {
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
 	BT_DBG("parent %p, sk %p", parent, sk);
 
 	sock_hold(sk);
@@ -213,6 +224,19 @@ void bt_accept_enqueue(struct sock *pare
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
@@ -256,21 +256,13 @@ static int hidp_sock_create(struct net *
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
@@ -178,21 +178,6 @@ done:
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
@@ -268,8 +253,6 @@ static int l2cap_sock_connect(struct soc
 	    chan->mode != L2CAP_MODE_EXT_FLOWCTL)
 		chan->mode = L2CAP_MODE_LE_FLOWCTL;
 
-	l2cap_sock_init_pid(sk);
-
 	err = l2cap_chan_connect(chan, la.l2_psm, __le16_to_cpu(la.l2_cid),
 				 &la.l2_bdaddr, la.l2_bdaddr_type);
 	if (err)
@@ -325,8 +308,6 @@ static int l2cap_sock_listen(struct sock
 		goto done;
 	}
 
-	l2cap_sock_init_pid(sk);
-
 	sk->sk_max_ack_backlog = backlog;
 	sk->sk_ack_backlog = 0;
 


