Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207795;
	b=d4uRL6TYW8qLncx3zY5/fa3ix3lfViULfjy2uX9ppXY2eeKwWWEry7osrrUyardkSR7f
	 SN2sFvT/iTCx0ZauMgWVv3IxyfHEw3+Mo7IOwWhW5FgW3xzmj57oQEXsmd216ensvx0HO
	 vm3ZQFL512Z4bZPg0PZV4dDfjKBketGrCAb25NBNku512Yy/36dTtnkWYxw8HZZfOkXwc
	 feJHHA/xzqq8PXSsE7xlvWt3rIzhW6WQaBxittMmoKGy7ROiYEfKDTy52a71GRosiVP0C
	 wSEbxby3g8sKCrLXsG8z5VBHimpdkImKtdjMIKEfyIwbrWsn+vFXf2xS8gnile/vUSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tl3CW1QuIs6wSj61PMBCAD8faYmu8jGOcIC17TONp0w=;
	b=vqu3vWLTTgY33iDJbEZ4fseV4hVGCFHcwAY0P+UVy8F3p8Aql97CuubYHUayKZGfVqvh
	 CzBcs+M2SSvetcMtOHlwpUcLzmP7J+jY8cTjDTdacVWWPTT4ihMrZo5fxE4iauctqhZsT
	 p3atoeH7sso5CphXSkTAQLkJPcfgyksLv6ZiAweHwFFPs469MQ0hOJv/1rVbtlFnXX0KW
	 7Ps6YDQcVoEFHhnWZ/O8HZsnkZSLRKj6s01DnyyCX1fcJotVTYSwXJUQRFdowu1QHlUiY
	 zmAsJStqV0lNVl945sIbnjA96/KWhz+DHFg37hSBjL7cA1HuYvBjexk/6E/O1bC+c0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wTExaGoC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7954C606A31D;
	Wed, 28 Oct 2026 17:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wTExaGoC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FBF1F01825;
	Wed, 28 Oct 2026 17:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207795;
	bh=Tl3CW1QuIs6wSj61PMBCAD8faYmu8jGOcIC17TONp0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wTExaGoC9dbSU04cHqCVj8GH8jIdvo3oaHN+I3jPrhBaNXXFaT2kyeuxTk9Q85dEo
	 4Pw8oKbVnp3HQ+Twy4ALuE9u4Lc/Q+K78xtC3fZpeoQWbGe/Uo4lnpvN0nNPtQlXXM
	 l/stb/1arfNKdlqDzKsV8IGMxxXolvCzSJivMkq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/247] vsock/virtio: validate packet source for connected sockets
Date: Wed, 28 Oct 2026 17:59:06 +0100
Message-ID: <20261028165950.796121054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit dee44f41f206becb41c492899c1996cfd7f82a1b ]

virtio_transport_recv_pkt() looks up sockets first by the full source and
destination tuple, then by destination only in the bound table. The
fallback is needed for listening and connecting sockets, but sockets remain
in the bound table after connect(), so it can also return a non-listening
socket.

The fallback does not validate the source address. In TCP_SYN_SENT, a
RESPONSE from an unrelated source can transition the victim socket to
TCP_ESTABLISHED while its stored remote address remains unchanged.
Subsequent RW packets from that source are delivered through the same
destination-only fallback.

This was reproduced with capability-empty processes under different UIDs.
The attacker discovered the target tuple through unprivileged AF_VSOCK
sock_diag and caused the victim socket to read 16 attacker-chosen bytes;
the intended peer-side socket read 0 of those 16 bytes.

Add vsock_check_source() to validate the transport, source port and source
CID against the peer stored in a non-listening socket. The local transport
is the CID exception because its packets are generated internally with
VMADDR_CID_LOCAL as their source, including connections using CID aliases.

Use the helper after lock_sock() in the virtio receive path.

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Closes: https://lore.kernel.org/netdev/20260813121236.2328599-1-4ncienth@gmail.com/
Cc: stable@vger.kernel.org
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20260826003929.966160-2-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: adjusted context for socket lookup and reset helpers without network namespace parameters ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/af_vsock.h                  |  3 +++
 net/vmw_vsock/af_vsock.c                | 32 +++++++++++++++++++++++++
 net/vmw_vsock/virtio_transport_common.c |  3 ++-
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 70302c92d329f..20bbe02d2cfc5 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -216,6 +216,9 @@ void vsock_remove_connected(struct vsock_sock *vsk);
 struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
 struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
 					 struct sockaddr_vm *dst);
+bool vsock_check_source(const struct vsock_sock *vsk,
+			const struct vsock_transport *transport,
+			const struct sockaddr_vm *src);
 void vsock_remove_sock(struct vsock_sock *vsk);
 void vsock_for_each_connected_socket(struct vsock_transport *transport,
 				     void (*fn)(struct sock *sk));
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 228e45bf2d769..999cccb323f79 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -335,6 +335,38 @@ struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
 }
 EXPORT_SYMBOL_GPL(vsock_find_connected_socket);
 
+/**
+ * vsock_check_source - validate a packet source against a socket peer
+ * @vsk: socket receiving the packet
+ * @transport: transport receiving the packet
+ * @src: source address from the packet
+ *
+ * Return: true if the packet arrived on the socket's assigned transport and
+ * its source matches the stored peer. Loopback packets are generated
+ * internally and always use the local CID as their source, including
+ * connections using a valid CID alias.
+ *
+ * The caller must hold the socket lock and must not call this for listening
+ * sockets, which accept packets from any source and have no assigned
+ * transport.
+ */
+bool vsock_check_source(const struct vsock_sock *vsk,
+			const struct vsock_transport *transport,
+			const struct sockaddr_vm *src)
+{
+	if (vsk->transport != transport)
+		return false;
+
+	if (src->svm_port != vsk->remote_addr.svm_port)
+		return false;
+
+	if (src->svm_cid == vsk->remote_addr.svm_cid)
+		return true;
+
+	return transport->get_local_cid() == VMADDR_CID_LOCAL;
+}
+EXPORT_SYMBOL_GPL(vsock_check_source);
+
 void vsock_remove_sock(struct vsock_sock *vsk)
 {
 	/* Transport reassignment must not remove the binding. */
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 75df280bcc81f..cf7f3dcc075c7 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1837,7 +1837,8 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 	 * lock_sock (note: listener sockets are not assigned to any transport)
 	 */
 	if (sock_flag(sk, SOCK_DONE) ||
-	    (sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {
+	    (sk->sk_state != TCP_LISTEN &&
+	     !vsock_check_source(vsk, &t->transport, &src))) {
 		(void)virtio_transport_reset_no_sock(t, skb);
 		release_sock(sk);
 		sock_put(sk);
-- 
2.53.0



