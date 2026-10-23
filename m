Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774932;
	b=MzsOC8dW5gAMGrD+SArwq4zFUiVb3WzE9LjqmXM9keL1aL8xCmFKhFrAdfEdFAq2LYXn
	 1cq2t+hhP1fOzDvSrDOpJDZiGMWGV2aXAepf2UnNhQzS3J0DD4d6UB6PsiWiUnOd5fIGQ
	 tb0cFWx9TSnfLWWAXuhs+U0tqtrhcT7RbdC4sZx21S935va4kbLw5gQtis97K0uKVl7I2
	 9EE5uTxuCZZVjeH6EjMNIhVoxclX065fpXuKd0P6UBzXeV6GchLIkg3/lwdauifciLTuA
	 7BVyKDc1p6rSnnrxOII7LnQEcLn5bZEc255ze/kxx6D7z+GMGYuT9K3U/ELl/gcwIQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HehGh+4qyowZu+n6l8w7LPNT6yAd1dpjSTLhTd9VWQA=;
	b=ZL+R+iq3SpigtMG8PPCWYwBHW6ZCZkP7j1J77Vbb1j/lQYD/Dt1rWUYFdIqmI4OHC60E
	 g6ciF9qkqw1gzeLgWyBtVMEeM5L6x7ZEcsdWxnLjI+NGn09HNl+2W0K6sJAmTyb1r5AFE
	 hyTm6pQ06xh3ndhdL/JjIWsTVTAiGcf/6oZvrBht6J4JF15ctn0K+ELf+aN3tUjoIaSXR
	 sqY8XPbRq082LVU9AI0qvBTDRmVsgnFFZCA1FBu34O1jIFRMJxp++W/KmCSjvD1JVj5Yy
	 PY986qJIDtQH9ha5UvXN5AbemIqKCtPYF+Ci7wELqW16ATA+xRiKt+m/N3K1ZqeVBlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h/9l9x56";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B78E606A31A;
	Fri, 23 Oct 2026 17:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h/9l9x56
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4081F01825;
	Fri, 23 Oct 2026 17:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774932;
	bh=HehGh+4qyowZu+n6l8w7LPNT6yAd1dpjSTLhTd9VWQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/9l9x56DLknZZGCnnNnOYVA0yHSrFr7irAndomMYZBNHKv7M6BRfulYU04gRLsbQ
	 OJ82zjlzt3bw0sT2r17gXnZtSHEMwxL7TdjdXtz1VwILGaGUWhp3JRO+vWNJTbGSgS
	 zm38E0BqTdci1zoSHiyPPZHLHj4E8e5nrSGuYbck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 205/242] vsock/virtio: validate packet source for connected sockets
Date: Fri, 23 Oct 2026 18:40:47 +0200
Message-ID: <20261023163718.642780772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit dee44f41f206becb41c492899c1996cfd7f82a1b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/af_vsock.h                  |    3 +++
 net/vmw_vsock/af_vsock.c                |   32 ++++++++++++++++++++++++++++++++
 net/vmw_vsock/virtio_transport_common.c |    3 ++-
 3 files changed, 37 insertions(+), 1 deletion(-)

--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -232,6 +232,9 @@ struct sock *vsock_find_bound_socket_net
 struct sock *vsock_find_connected_socket_net(struct sockaddr_vm *src,
 					     struct sockaddr_vm *dst,
 					     struct net *net);
+bool vsock_check_source(const struct vsock_sock *vsk,
+			const struct vsock_transport *transport,
+			const struct sockaddr_vm *src);
 void vsock_remove_sock(struct vsock_sock *vsk);
 void vsock_for_each_connected_socket(struct vsock_transport *transport,
 				     void (*fn)(struct sock *sk));
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -441,6 +441,38 @@ struct sock *vsock_find_connected_socket
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
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1826,7 +1826,8 @@ void virtio_transport_recv_pkt(struct vi
 	 * lock_sock (note: listener sockets are not assigned to any transport)
 	 */
 	if (sock_flag(sk, SOCK_DONE) ||
-	    (sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {
+	    (sk->sk_state != TCP_LISTEN &&
+	     !vsock_check_source(vsk, &t->transport, &src))) {
 		(void)virtio_transport_reset_no_sock(t, skb, net);
 		release_sock(sk);
 		sock_put(sk);


