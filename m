Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9934432C92A;
	Mon, 27 Oct 2025 19:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593218; cv=none; b=L6qOfVMniAKGZ9RPd+xTXM7kKysG5jP25SU9sNhsiiSDR5Jk6Utj4fAPQlRMkzBb7E0wJLz54iJfXR/8al5+u/hiATcDvupg4H/uoRPNVS63lFqSvIU8Nt/mtyadinB0XnyvTxzPyiALBbMhM66rxDbLu2v/HpEfFWw76MQXNsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593218; c=relaxed/simple;
	bh=TTqXzHdkxqhJS6z0N22hTR1wGSijiSuAg/TtkKdOR9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgiO29oOLswFuo/KrnbccuzeG95HaHtpgDI0OpXZka0Eug07XiKTWHZKpYT6HgQxHJTsVsy6nnbfYtg8CxQjI/1jd6rtzRZ4HhpeklWJ6JB0FBLMNcR6Djkb7N4dVbtNwJ2ehH7iaLDiB9hJjjmsTa/kXwq35YgbV17R46jhpB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7A9Tgt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7A9Tgt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7D6C4CEF1;
	Mon, 27 Oct 2025 19:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593218;
	bh=TTqXzHdkxqhJS6z0N22hTR1wGSijiSuAg/TtkKdOR9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7A9Tgt9M9ZtE9nICXkoF6FND5gSx6VhEXe/n1KK/TAFktm19wN0Rhi2cnbiq9NTv
	 NFv7P25joscagMfXqCEBUz/qDEHQLjYNE/5Zx+xNkSZcr6f2HQICDBPXF7ARK5BRsp
	 0aZrkkhLHSAdjHsRE0qv4hZ0voYGlfE2z1m4KdVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Ralf Lici <ralf@mandelbit.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 058/184] ovpn: use datagram_poll_queue for socket readiness in TCP
Date: Mon, 27 Oct 2025 19:35:40 +0100
Message-ID: <20251027183516.458557333@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit efd729408bc7d57e0c8d027b9ff514187fc1a05b ]

openvpn TCP encapsulation uses a custom queue to deliver packets to
userspace. Currently it relies on datagram_poll, which checks
sk_receive_queue, leading to false readiness signals when that queue
contains non-userspace packets.

Switch ovpn_tcp_poll to use datagram_poll_queue with the peer's
user_queue, ensuring poll only signals readiness when userspace data is
actually available. Also refactor ovpn_tcp_poll in order to enforce the
assumption we can make on the lifetime of ovpn_sock and peer.

Fixes: 11851cbd60ea ("ovpn: implement TCP transport")
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20251021100942.195010-4-ralf@mandelbit.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/tcp.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ovpn/tcp.c b/drivers/net/ovpn/tcp.c
index 289f62c5d2c70..0d7f30360d874 100644
--- a/drivers/net/ovpn/tcp.c
+++ b/drivers/net/ovpn/tcp.c
@@ -560,16 +560,34 @@ static void ovpn_tcp_close(struct sock *sk, long timeout)
 static __poll_t ovpn_tcp_poll(struct file *file, struct socket *sock,
 			      poll_table *wait)
 {
-	__poll_t mask = datagram_poll(file, sock, wait);
+	struct sk_buff_head *queue = &sock->sk->sk_receive_queue;
 	struct ovpn_socket *ovpn_sock;
+	struct ovpn_peer *peer = NULL;
+	__poll_t mask;
 
 	rcu_read_lock();
 	ovpn_sock = rcu_dereference_sk_user_data(sock->sk);
-	if (ovpn_sock && ovpn_sock->peer &&
-	    !skb_queue_empty(&ovpn_sock->peer->tcp.user_queue))
-		mask |= EPOLLIN | EPOLLRDNORM;
+	/* if we landed in this callback, we expect to have a
+	 * meaningful state. The ovpn_socket lifecycle would
+	 * prevent it otherwise.
+	 */
+	if (WARN(!ovpn_sock || !ovpn_sock->peer,
+		 "ovpn: null state in ovpn_tcp_poll!")) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	if (ovpn_peer_hold(ovpn_sock->peer)) {
+		peer = ovpn_sock->peer;
+		queue = &peer->tcp.user_queue;
+	}
 	rcu_read_unlock();
 
+	mask = datagram_poll_queue(file, sock, wait, queue);
+
+	if (peer)
+		ovpn_peer_put(peer);
+
 	return mask;
 }
 
-- 
2.51.0



