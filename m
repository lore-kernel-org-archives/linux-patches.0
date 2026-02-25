Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9C72D7810;
	Wed, 25 Feb 2026 06:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002742; cv=none; b=YA5+9JqiNElUybiPsZ762gcr7yqhrneKytx2JeWUtPzk63n9zQpD77HTUuK660DkfFDGtaad7a4wbhyqZABNDsz64hAlztLAhtOZ3Q0r/qnZ6NFQuONl7a8TmH8G1shfub1JanqUhFtBc1wuO7hJgYBOaN4E9ZOqgxRemjpjF4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002742; c=relaxed/simple;
	bh=xxD3+bxgtfG1G9HHffAIyXHzq1b2MfVX7ssVHtNL5nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FejZyZ0SY0ivtNONL3V081kV7Fc73AChEZruDcdASHqv5qVnGox8pZCJv8Ev2mW/shwVeejrhdwKbcypOhYYREZ0kqykIs/CGAirzSJ9DnGPG2tzi2tRW+lek5GhVa464DYUeVw+6BndZuzsxmdMqyAQheHFt7mmgu9pQp1jyu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0W2/KxvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0W2/KxvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F1BC116D0;
	Wed, 25 Feb 2026 06:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002742;
	bh=xxD3+bxgtfG1G9HHffAIyXHzq1b2MfVX7ssVHtNL5nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0W2/KxvGvz1VuvYfrBo8t4/feSzTLEYKEQXGJwrZ3MWFEZcuO3dyx22mac+tZu1K1
	 AaWPXWz2iI/WhVGdhofds/vrA3db+JfAHd9S3+JgMmK2L8deXTT2Bo2mfwYCcOxSyA
	 3IuTiH3kpo+rjyX6cnKKwaRSUk8Ka7MN4v0b1cyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 510/641] ovpn: set sk_user_data before overriding callbacks
Date: Tue, 24 Feb 2026 17:23:56 -0800
Message-ID: <20260225012400.881307472@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit 93686c472eb7b09a51b97a096449e7092fefcd1f ]

During initialization, we override socket callbacks and set sk_user_data
to an ovpn_socket instance. Currently, these two operations are
decoupled: callbacks are overridden before sk_user_data is set. While
existing callbacks perform safety checks for NULL or non-ovpn
sk_user_data, this condition causes a "half-formed" state where valid
packets arriving during attachment trigger error logs (e.g., "invoked on
non ovpn socket").

Set sk_user_data before overriding the callbacks so that it can be
accessed safely from them. Since we already check that the socket has no
sk_user_data before setting it, this remains safe even if an interrupt
accesses the socket after sk_user_data is set but before the callbacks
are overridden.

This also requires initializing all protocol-specific fields (such as
tcp_tx_work and peer links) before calling ovpn_socket_attach, ensuring
the ovpn_socket is fully formed before it becomes visible to any
callback.

Fixes: f6226ae7a0cd ("ovpn: introduce the ovpn_socket object")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/socket.c | 39 +++++++++++++++++++++------------------
 drivers/net/ovpn/tcp.c    |  9 +++++++--
 drivers/net/ovpn/udp.c    |  1 +
 3 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ovpn/socket.c b/drivers/net/ovpn/socket.c
index 9750871ab65ce..448cee3b3f9fa 100644
--- a/drivers/net/ovpn/socket.c
+++ b/drivers/net/ovpn/socket.c
@@ -200,6 +200,22 @@ struct ovpn_socket *ovpn_socket_new(struct socket *sock, struct ovpn_peer *peer)
 	ovpn_sock->sk = sk;
 	kref_init(&ovpn_sock->refcount);
 
+	/* TCP sockets are per-peer, therefore they are linked to their unique
+	 * peer
+	 */
+	if (sk->sk_protocol == IPPROTO_TCP) {
+		INIT_WORK(&ovpn_sock->tcp_tx_work, ovpn_tcp_tx_work);
+		ovpn_sock->peer = peer;
+		ovpn_peer_hold(peer);
+	} else if (sk->sk_protocol == IPPROTO_UDP) {
+		/* in UDP we only link the ovpn instance since the socket is
+		 * shared among multiple peers
+		 */
+		ovpn_sock->ovpn = peer->ovpn;
+		netdev_hold(peer->ovpn->dev, &ovpn_sock->dev_tracker,
+			    GFP_KERNEL);
+	}
+
 	/* the newly created ovpn_socket is holding reference to sk,
 	 * therefore we increase its refcounter.
 	 *
@@ -212,29 +228,16 @@ struct ovpn_socket *ovpn_socket_new(struct socket *sock, struct ovpn_peer *peer)
 
 	ret = ovpn_socket_attach(ovpn_sock, sock, peer);
 	if (ret < 0) {
+		if (sk->sk_protocol == IPPROTO_TCP)
+			ovpn_peer_put(peer);
+		else if (sk->sk_protocol == IPPROTO_UDP)
+			netdev_put(peer->ovpn->dev, &ovpn_sock->dev_tracker);
+
 		sock_put(sk);
 		kfree(ovpn_sock);
 		ovpn_sock = ERR_PTR(ret);
-		goto sock_release;
-	}
-
-	/* TCP sockets are per-peer, therefore they are linked to their unique
-	 * peer
-	 */
-	if (sk->sk_protocol == IPPROTO_TCP) {
-		INIT_WORK(&ovpn_sock->tcp_tx_work, ovpn_tcp_tx_work);
-		ovpn_sock->peer = peer;
-		ovpn_peer_hold(peer);
-	} else if (sk->sk_protocol == IPPROTO_UDP) {
-		/* in UDP we only link the ovpn instance since the socket is
-		 * shared among multiple peers
-		 */
-		ovpn_sock->ovpn = peer->ovpn;
-		netdev_hold(peer->ovpn->dev, &ovpn_sock->dev_tracker,
-			    GFP_KERNEL);
 	}
 
-	rcu_assign_sk_user_data(sk, ovpn_sock);
 sock_release:
 	release_sock(sk);
 	return ovpn_sock;
diff --git a/drivers/net/ovpn/tcp.c b/drivers/net/ovpn/tcp.c
index 0d7f30360d874..f0b4e07ba9245 100644
--- a/drivers/net/ovpn/tcp.c
+++ b/drivers/net/ovpn/tcp.c
@@ -487,6 +487,7 @@ int ovpn_tcp_socket_attach(struct ovpn_socket *ovpn_sock,
 	/* make sure no pre-existing encapsulation handler exists */
 	if (ovpn_sock->sk->sk_user_data)
 		return -EBUSY;
+	rcu_assign_sk_user_data(ovpn_sock->sk, ovpn_sock);
 
 	/* only a fully connected socket is expected. Connection should be
 	 * handled in userspace
@@ -495,13 +496,14 @@ int ovpn_tcp_socket_attach(struct ovpn_socket *ovpn_sock,
 		net_err_ratelimited("%s: provided TCP socket is not in ESTABLISHED state: %d\n",
 				    netdev_name(peer->ovpn->dev),
 				    ovpn_sock->sk->sk_state);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	ret = strp_init(&peer->tcp.strp, ovpn_sock->sk, &cb);
 	if (ret < 0) {
 		DEBUG_NET_WARN_ON_ONCE(1);
-		return ret;
+		goto err;
 	}
 
 	INIT_WORK(&peer->tcp.defer_del_work, ovpn_tcp_peer_del_work);
@@ -536,6 +538,9 @@ int ovpn_tcp_socket_attach(struct ovpn_socket *ovpn_sock,
 	strp_check_rcv(&peer->tcp.strp);
 
 	return 0;
+err:
+	rcu_assign_sk_user_data(ovpn_sock->sk, NULL);
+	return ret;
 }
 
 static void ovpn_tcp_close(struct sock *sk, long timeout)
diff --git a/drivers/net/ovpn/udp.c b/drivers/net/ovpn/udp.c
index d6a0f7a0b75d7..272b535ecaad4 100644
--- a/drivers/net/ovpn/udp.c
+++ b/drivers/net/ovpn/udp.c
@@ -386,6 +386,7 @@ int ovpn_udp_socket_attach(struct ovpn_socket *ovpn_sock, struct socket *sock,
 			   struct ovpn_priv *ovpn)
 {
 	struct udp_tunnel_sock_cfg cfg = {
+		.sk_user_data = ovpn_sock,
 		.encap_type = UDP_ENCAP_OVPNINUDP,
 		.encap_rcv = ovpn_udp_encap_recv,
 		.encap_destroy = ovpn_udp_encap_destroy,
-- 
2.51.0



