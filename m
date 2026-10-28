Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211901;
	b=EdbUsRv+6/uITmxzhGYIGGWEgiMg3jgjxcI+48naZpFsFIbrzR2zRimVL4tq17b9bU91
	 AWm+wej35y4qATxCv1KkRzDhn9+PK8Lhs3syE90Yh1Fy7GybZ7sGQ5WAvtvWjoIe4nMxX
	 xttrBLGsaPsddoh4CdzpZTOBf6IQlZMTPSFVjHgygeL3K3IIev9V+o2mYbJhoBM6oIVSz
	 efcuvU5dmkuZhdy+DZud2GKf1zpnsf+IMJvqL+llp/uEKXtpytEjsqriAP5b9xq4jzCrn
	 b1gPQ5oIxP5ls9W8iyKXxqKoqUgH4NyWHV3T6YXsciqlraFJ65tM0RBS+YW4Fb0vYug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cAb24yEAAaFH7UL60abRAVxEN3DXknwHzxpfC0sDKDM=;
	b=Nde6CZsp1Isf30J041ZtNUpoNL+2RjVu6fs5BkQefE0+QHVwZ4jXZ/pU2iL7+PZc/4s+
	 1/e/aC/bCA9RrSI0DJzMy9vAOKnAwp0W4BY4LlEnTq7QFyiutAex9Su2nfDfVnaFV1tE6
	 QgEZooz7VPGCly2Gj4IXbL5Y/lUuUmMGP5R+ZRZHgGAU2vRnORTNWzagCeCNmkhFcUZB3
	 Z7JyLyx6WxWuMWRqi9OcWaqzgHpniZbzM42Zm7wwFx4A+GiNSBsWy3XTWZca5QnaUdEf3
	 YDHgT2tDXrsaX4DC+evH18tYAlLrlEbGRIxHOOJdkzaErpVjkbORtRtemuWPPnquU+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IXWmDFOE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37F9606A321;
	Wed, 28 Oct 2026 18:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IXWmDFOE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064691F01825;
	Wed, 28 Oct 2026 18:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211900;
	bh=cAb24yEAAaFH7UL60abRAVxEN3DXknwHzxpfC0sDKDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IXWmDFOEqSYKS6aJPC+VK4xwGWikLDmMO55Pbbar6RidjfKB1toc+BlvGDnXdH7ZM
	 FUNlLysob1lczaBqgn4MFR8BbdtSWnE7pRLo2+pakPfR0oie4O5NHlHGzIrSpEPOKl
	 8Tilr8LjW38qpEur5Eblxu+qLUFunOyy3KDUeueA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 540/571] vsock/virtio: validate packet source for connected sockets
Date: Wed, 28 Oct 2026 18:01:27 +0100
Message-ID: <20261028170020.848361538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted receive-path context to retain virtio_transport_reset_no_sock(t, pkt). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/af_vsock.h                  |  3 +++
 net/vmw_vsock/af_vsock.c                | 32 +++++++++++++++++++++++++
 net/vmw_vsock/virtio_transport_common.c |  3 ++-
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index f742e50207fbd..2b5dd17cb58a5 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -204,6 +204,9 @@ void vsock_remove_connected(struct vsock_sock *vsk);
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
index c89f7b2df4ec1..0712c8339f927 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -328,6 +328,38 @@ struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
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
index 12eb365c1603d..9216ffe6a88a6 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1320,7 +1320,8 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 	 * lock_sock (note: listener sockets are not assigned to any transport)
 	 */
 	if (sock_flag(sk, SOCK_DONE) ||
-	    (sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {
+	    (sk->sk_state != TCP_LISTEN &&
+	     !vsock_check_source(vsk, &t->transport, &src))) {
 		(void)virtio_transport_reset_no_sock(t, pkt);
 		release_sock(sk);
 		sock_put(sk);
-- 
2.53.0



