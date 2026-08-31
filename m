Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFE147A873;
	Mon, 31 Aug 2026 13:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184461; cv=none; b=FC9rDcJuC5KX/NfP+UqTkPg7WThzcG1EXFtRdG5EZjGjHpCy+CqrwRJhPr/Wsy4K7AUAFWBgRBje4g5nhUtjqnso9GKSUCMCT5AvUO0j+yp1mGRy7eX64r5GRZfjdYuPxoiDZnmSkCtRbZZ2TeO1bngXQZ0dZZp9Li92o2LBAck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184461; c=relaxed/simple;
	bh=QYZlg4R0vXA6WCx8QhwBowSC2IwvSgCFVOzdEIXMnYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnnO/QtYuMdzItK914/AjB1k6C8uN4fFr+dnmxZtU/9zPxJfP/cN2Lrsrjf7jI88PGwc25qIVpYAIT2KW/PpNOBWtRLVQZd9YuRtawCjKP5R4rWuSiYy3+vj6t7+I7W4boKh8ZgwZ4Rdlf1c7Rn2h66aJ+Hh1OseN8Zehgf4Tfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qi2WMwqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qi2WMwqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF641F000E9;
	Mon, 31 Aug 2026 13:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184459;
	bh=vG16OSh0aKjNFDWNGReBEADjN/y7Y912mx+Ro3LSKho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qi2WMwqz2PljBvygZ1Pmc1Y5zS8TQVioIu3sKe7JViaVTY4wglBBpKzmk4/UlFxAY
	 iNFtR0k5Uoo1zGQxw4MXUxrSGS2WcyW2BsfaDQ3mflw5cdHFF4ekwYNSW9OzuZjJ0S
	 veN1azAMNo03vVhyNNQhItUhQ4JTamImCxKSeazg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 16/91] can: j1939: implement NETDEV_UNREGISTER notification handler
Date: Mon, 31 Aug 2026 15:34:04 +0200
Message-ID: <20260831133400.404593559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 7fcbe5b2c6a4b5407bf2241fdb71e0a390f6ab9a ]

syzbot is reporting

  unregister_netdevice: waiting for vcan0 to become free. Usage count = 2

problem, for j1939 protocol did not have NETDEV_UNREGISTER notification
handler for undoing changes made by j1939_sk_bind().

Commit 25fe97cb7620 ("can: j1939: move j1939_priv_put() into sk_destruct
callback") expects that a call to j1939_priv_put() can be unconditionally
delayed until j1939_sk_sock_destruct() is called. But we need to call
j1939_priv_put() against an extra ref held by j1939_sk_bind() call
(as a part of undoing changes made by j1939_sk_bind()) as soon as
NETDEV_UNREGISTER notification fires (i.e. before j1939_sk_sock_destruct()
is called via j1939_sk_release()). Otherwise, the extra ref on "struct
j1939_priv" held by j1939_sk_bind() call prevents "struct net_device" from
dropping the usage count to 1; making it impossible for
unregister_netdevice() to continue.

Reported-by: syzbot <syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=881d65229ca4f9ae8c84
Tested-by: syzbot <syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com>
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Fixes: 25fe97cb7620 ("can: j1939: move j1939_priv_put() into sk_destruct callback")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/ac9db9a4-6c30-416e-8b94-96e6559d55b2@I-love.SAKURA.ne.jp
[mkl: remove space in front of label]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/j1939-priv.h |  1 +
 net/can/j1939/main.c       |  3 +++
 net/can/j1939/socket.c     | 49 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/net/can/j1939/j1939-priv.h b/net/can/j1939/j1939-priv.h
index 1d3d5d0551e0f..cf26352d1d8ce 100644
--- a/net/can/j1939/j1939-priv.h
+++ b/net/can/j1939/j1939-priv.h
@@ -214,6 +214,7 @@ void j1939_priv_get(struct j1939_priv *priv);
 
 /* notify/alert all j1939 sockets bound to ifindex */
 void j1939_sk_netdev_event_netdown(struct j1939_priv *priv);
+void j1939_sk_netdev_event_unregister(struct j1939_priv *priv);
 int j1939_cancel_active_session(struct j1939_priv *priv, struct sock *sk);
 void j1939_tp_init(struct j1939_priv *priv);
 
diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index b45f834ff2cf6..6bbe75d2211d5 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -377,6 +377,9 @@ static int j1939_netdev_notify(struct notifier_block *nb,
 		j1939_sk_netdev_event_netdown(priv);
 		j1939_ecu_unmap_all(priv);
 		break;
+	case NETDEV_UNREGISTER:
+		j1939_sk_netdev_event_unregister(priv);
+		break;
 	}
 
 	j1939_priv_put(priv);
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 4a76f7434e1e7..eeff9b84fba81 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -1300,6 +1300,55 @@ void j1939_sk_netdev_event_netdown(struct j1939_priv *priv)
 	read_unlock_bh(&priv->j1939_socks_lock);
 }
 
+void j1939_sk_netdev_event_unregister(struct j1939_priv *priv)
+{
+	struct sock *sk;
+	struct j1939_sock *jsk;
+	bool wait_rcu = false;
+
+rescan: /* The caller is holding a ref on this "priv" via j1939_priv_get_by_ndev(). */
+	read_lock_bh(&priv->j1939_socks_lock);
+	list_for_each_entry(jsk, &priv->j1939_socks, list) {
+		/* Skip if j1939_jsk_add() is not called on this socket. */
+		if (!(jsk->state & J1939_SOCK_BOUND))
+			continue;
+		sk = &jsk->sk;
+		sock_hold(sk);
+		read_unlock_bh(&priv->j1939_socks_lock);
+		/* Check if j1939_jsk_del() is not yet called on this socket after holding
+		 * socket's lock, for both j1939_sk_bind() and j1939_sk_release() call
+		 * j1939_jsk_del() with socket's lock held.
+		 */
+		lock_sock(sk);
+		if (jsk->state & J1939_SOCK_BOUND) {
+			/* Neither j1939_sk_bind() nor j1939_sk_release() called j1939_jsk_del().
+			 * Make this socket no longer bound, by pretending as if j1939_sk_bind()
+			 * dropped old references but did not get new references.
+			 */
+			j1939_jsk_del(priv, jsk);
+			j1939_local_ecu_put(priv, jsk->addr.src_name, jsk->addr.sa);
+			j1939_netdev_stop(priv);
+			/* Call j1939_priv_put() now and prevent j1939_sk_sock_destruct() from
+			 * calling the corresponding j1939_priv_put().
+			 *
+			 * j1939_sk_sock_destruct() is supposed to call j1939_priv_put() after
+			 * an RCU grace period. But since the caller is holding a ref on this
+			 * "priv", we can defer synchronize_rcu() until immediately before
+			 * the caller calls j1939_priv_put().
+			 */
+			j1939_priv_put(priv);
+			jsk->priv = NULL;
+			wait_rcu = true;
+		}
+		release_sock(sk);
+		sock_put(sk);
+		goto rescan;
+	}
+	read_unlock_bh(&priv->j1939_socks_lock);
+	if (wait_rcu)
+		synchronize_rcu();
+}
+
 static int j1939_sk_no_ioctlcmd(struct socket *sock, unsigned int cmd,
 				unsigned long arg)
 {
-- 
2.53.0



