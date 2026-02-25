Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54A02494FE;
	Wed, 25 Feb 2026 01:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983551; cv=none; b=S27BItJJKZ2MgBCOWbn4nW8fGzcbdv8f471nVTRsMTV1CfCeyS8HWVPHpR4oZ8oSXXjKdkLI8ubOAWxMASz/ZIE8gh2ACSiIKTkI8gRo+mSK8R5xLH4fp4c2A1QkKk+DX/7a1+JvYPnzvriZ08AXkwc4Hj/qMD5mQobrP4QMOjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983551; c=relaxed/simple;
	bh=wsg4bld1gZkr04FZgRjj0OzXqESvndAcQ4qloLNy23Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyO0cFHC2I9KFzVU6It69z5DRLb57xjM1vE7+xlYL7TDHWtqqJlhMIc3nCZT9sB975CnP30zTvdXzwLk3f3FHxkzWbtB/Uc31AS1sHoSt+2nhpSigRLCziGtgoEYi/kgvcd+/RWci+P660cVqCLXtPT/zBi5M+/EkLQkNpBM21o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2KS8WIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2KS8WIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B32BC116D0;
	Wed, 25 Feb 2026 01:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983551;
	bh=wsg4bld1gZkr04FZgRjj0OzXqESvndAcQ4qloLNy23Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2KS8WIRZbNqlXAdpLQ4UxDCiQVYH8pPUN9UCksogpjVuzVomBFN6JVJncuxQi06J
	 TTMOTlhthExYve4NudCZYYnMwnhr2f8bhjK7zOWKp8rib3PY2kY9LalklCjkTRAAp6
	 002IFGhge08NPlbHVA0c+uoQl9UwrP6flrXgt27Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 653/781] ovpn: tcp - dont deref NULL sk_socket member after tcp_close()
Date: Tue, 24 Feb 2026 17:22:42 -0800
Message-ID: <20260225012415.807844492@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@openvpn.net>

[ Upstream commit 94560267d6c41b1ff3fafbab726e3f8a55a6af34 ]

When deleting a peer in case of keepalive expiration, the peer is
removed from the OpenVPN hashtable and is temporary inserted in a
"release list" for further processing.

This happens in:
ovpn_peer_keepalive_work()
  unlock_ovpn(release_list)

This processing includes detaching from the socket being used to
talk to this peer, by restoring its original proto and socket
ops/callbacks.

In case of TCP it may happen that, while the peer is sitting in
the release list, userspace decides to close the socket.
This will result in a concurrent execution of:

tcp_close(sk)
  __tcp_close(sk)
    sock_orphan(sk)
      sk_set_socket(sk, NULL)

The last function call will set sk->sk_socket to NULL.

When the releasing routine is resumed, ovpn_tcp_socket_detach()
will attempt to dereference sk->sk_socket to restore its original
ops member. This operation will crash due to sk->sk_socket being NULL.

Fix this race condition by testing-and-accessing
sk->sk_socket atomically under sk->sk_callback_lock.

Link: https://lore.kernel.org/netdev/176996279620.3109699.15382994681575380467@eldamar.lan/
Link: https://github.com/OpenVPN/ovpn-net-next/issues/29
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Fixes: 11851cbd60ea ("ovpn: implement TCP transport")
Link: https://patch.msgid.link/20260212213130.11497-1-antonio@openvpn.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/tcp.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ovpn/tcp.c b/drivers/net/ovpn/tcp.c
index f0b4e07ba9245..ec2bbc28c1966 100644
--- a/drivers/net/ovpn/tcp.c
+++ b/drivers/net/ovpn/tcp.c
@@ -199,7 +199,19 @@ void ovpn_tcp_socket_detach(struct ovpn_socket *ovpn_sock)
 	sk->sk_data_ready = peer->tcp.sk_cb.sk_data_ready;
 	sk->sk_write_space = peer->tcp.sk_cb.sk_write_space;
 	sk->sk_prot = peer->tcp.sk_cb.prot;
-	sk->sk_socket->ops = peer->tcp.sk_cb.ops;
+
+	/* tcp_close() may race this function and could set
+	 * sk->sk_socket to NULL. It does so by invoking
+	 * sock_orphan(), which holds sk_callback_lock before
+	 * doing the assignment.
+	 *
+	 * For this reason we acquire the same lock to avoid
+	 * sk_socket to disappear under our feet
+	 */
+	write_lock_bh(&sk->sk_callback_lock);
+	if (sk->sk_socket)
+		sk->sk_socket->ops = peer->tcp.sk_cb.ops;
+	write_unlock_bh(&sk->sk_callback_lock);
 
 	rcu_assign_sk_user_data(sk, NULL);
 }
-- 
2.51.0



