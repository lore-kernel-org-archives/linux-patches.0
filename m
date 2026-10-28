Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217171;
	b=ecLujbtnw0ssf1fNTxigVvyPo7D3dad+2FT0xhRzheB1dPhHRb4p+JRz8Tb4264LO1nM
	 IKIPx1dKAGvtssqytEPhaA6cJ5hezUt1WBH+MMxEVoswPbpkZ/QEyM1GSHIQVtvewjULn
	 kDtzWhTbmNRetF4rGDQHsgM7AHKU3RUJj0LbfJ5NwED/oe5Ieyji192vk/MYfht6Nnxj6
	 bEr3GtZS1K6LfZLU8zn55yluR5Lyx4n8kZnsOc6w1i/yMoursmsUeGXVHpXX7AvhtqPok
	 GSuz2BHmSX26MSWKS4Ub7Wv0qrtabbFSG7VHLRd43FZ/4UuHJEsVfMuU3YOgynyIUJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DtpTqaMY63hvy2f3QpCF3HuHP7x5ZoIt0mDEDZAE78w=;
	b=y4v+wrYPwKbzYBBQVWaQV0kXqTySTWo045GZ7AutsMB3pABUZ2n8n2yJMgjvaDEUbSXk
	 OJuOyCTTVobraUlHKlecp4rtO33ET1WnuWIBKvL76ws4Nr7lS0ZFQaRwORR2gYemw+qmP
	 aCcBrrs+U4oYxtXDjiMMyBPURceOYLqY4ELta+yWVJOzHhQqgkLoZoe9pYfE5KAlEyT2/
	 UaEr0ZNEJWGGLOOTewjgEq4g7OXj3LlUx84BbIyuVejFFwi219HmRga4lq2BdB3bmGWGb
	 YSgtrWu9u0WlzdSEUNdFzWz8kmnpMFv4hqokm84NVwtvWzZtx6v6+D2HsZ/mFGKdNHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A5sQRf6N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAA4606A31C;
	Wed, 28 Oct 2026 19:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A5sQRf6N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93BF1F01825;
	Wed, 28 Oct 2026 19:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217171;
	bh=DtpTqaMY63hvy2f3QpCF3HuHP7x5ZoIt0mDEDZAE78w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5sQRf6Nad8UBxMcdBBAX6CzwycTqOhhiM6U5KZm/OPDXS4C+fC/oz5l/WWIIS3Im
	 87Uu8Przk1KwAAS8KMleys081lp3JuvkaIXYz81UWpUz1+n3EsMGcHpU9DO/P6xWNW
	 jV8SR2IsxLOeoX1N8q5Vx0ChHs2CuSOCd2G6BGtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1786/1887] vsock/virtio: validate packet source for connected sockets
Date: Wed, 28 Oct 2026 18:04:42 +0100
Message-ID: <20261028170540.093865259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context for socket lookup and reset helpers without network namespace arguments. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/af_vsock.h                  |  3 +++
 net/vmw_vsock/af_vsock.c                | 32 +++++++++++++++++++++++++
 net/vmw_vsock/virtio_transport_common.c |  3 ++-
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 568a87c5e0d0f..a1aebfa14a3ef 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -207,6 +207,9 @@ void vsock_remove_connected(struct vsock_sock *vsk);
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
index 893893869fd45..5675f224ea7d8 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -331,6 +331,38 @@ struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
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
index 6ea00b8630351..81bb95875f203 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1372,7 +1372,8 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
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



