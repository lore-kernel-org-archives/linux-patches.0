Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D696A1CAA8F;
	Tue, 11 Mar 2025 15:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707668; cv=none; b=jWQT6AYjJeURimxqpTMuILcBY4XrulAK1lHunEDuoAE75AezQkpwRcB9g0j+cAUasgz0dkKYxti4X3sHZa/qdPI1xob5hJGmcowY+ZqaPnpThXcM//1riXteaSGliQesIB3TZ7u1+jQmOCj54rDRs6evMKJ8BnFJi14oG5WA+Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707668; c=relaxed/simple;
	bh=Toer6gC3n7xNWYzUP3dHVZSIq16Nh1OcrBJhq/JmxCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+40vzVmpuI+9LUixfxksNINcSBdw1vN32Lb6rVWu+9rOXr5UJV9Tt2GhT6xXapHRQOoYl9LPtVy5yGev1Z4ZiOfN6YUABNFtNN9KbRUwB+OIdaS6Q9eVAdMpCHUL7+BoWycp1PpstLWhUf98HOZT513DPoUF0HzPfDQxAHGUK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKveZo1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKveZo1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55930C4CEE9;
	Tue, 11 Mar 2025 15:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707668;
	bh=Toer6gC3n7xNWYzUP3dHVZSIq16Nh1OcrBJhq/JmxCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKveZo1Zc8MQ0oiMnmkPAF4Y5ejXiA8FDp1tPZLsjlSCwfLt1CUA1ura0Jt0Y++eN
	 h05Qa9UAxBz7ZPZVlzAww9DkQhrseexg+x2CosIkEqQrUc35zXxgXdj5KHca45qHMf
	 3a/7vm9mFIqv0zWK2h1k3ohXxAzEAKTX52dgQows=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 5.10 452/462] bpf, vsock: Invoke proto::close on close()
Date: Tue, 11 Mar 2025 16:01:58 +0100
Message-ID: <20250311145816.176686114@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Michal Luczaj <mhal@rbox.co>

commit 135ffc7becc82cfb84936ae133da7969220b43b2 upstream.

vsock defines a BPF callback to be invoked when close() is called. However,
this callback is never actually executed. As a result, a closed vsock
socket is not automatically removed from the sockmap/sockhash.

Introduce a dummy vsock_close() and make vsock_release() call proto::close.

Note: changes in __vsock_release() look messy, but it's only due to indent
level reduction and variables xmas tree reorder.

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Link: https://lore.kernel.org/r/20241118-vsock-bpf-poll-close-v1-3-f1b9669cacdc@rbox.co
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
[LL: There is no sockmap support for this kernel version. This patch has
been backported because it helps reduce conflicts on future backports]
Signed-off-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |   71 +++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 29 deletions(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -113,12 +113,14 @@
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
 static void vsock_sk_destruct(struct sock *sk);
 static int vsock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
+static void vsock_close(struct sock *sk, long timeout);
 
 /* Protocol family. */
 static struct proto vsock_proto = {
 	.name = "AF_VSOCK",
 	.owner = THIS_MODULE,
 	.obj_size = sizeof(struct vsock_sock),
+	.close = vsock_close,
 };
 
 /* The default peer timeout indicates how long we will wait for a peer response
@@ -767,39 +769,37 @@ static struct sock *__vsock_create(struc
 
 static void __vsock_release(struct sock *sk, int level)
 {
-	if (sk) {
-		struct sock *pending;
-		struct vsock_sock *vsk;
+	struct vsock_sock *vsk;
+	struct sock *pending;
 
-		vsk = vsock_sk(sk);
-		pending = NULL;	/* Compiler warning. */
+	vsk = vsock_sk(sk);
+	pending = NULL;	/* Compiler warning. */
 
-		/* When "level" is SINGLE_DEPTH_NESTING, use the nested
-		 * version to avoid the warning "possible recursive locking
-		 * detected". When "level" is 0, lock_sock_nested(sk, level)
-		 * is the same as lock_sock(sk).
-		 */
-		lock_sock_nested(sk, level);
+	/* When "level" is SINGLE_DEPTH_NESTING, use the nested
+	 * version to avoid the warning "possible recursive locking
+	 * detected". When "level" is 0, lock_sock_nested(sk, level)
+	 * is the same as lock_sock(sk).
+	 */
+	lock_sock_nested(sk, level);
 
-		if (vsk->transport)
-			vsk->transport->release(vsk);
-		else if (sk->sk_type == SOCK_STREAM)
-			vsock_remove_sock(vsk);
-
-		sock_orphan(sk);
-		sk->sk_shutdown = SHUTDOWN_MASK;
-
-		skb_queue_purge(&sk->sk_receive_queue);
-
-		/* Clean up any sockets that never were accepted. */
-		while ((pending = vsock_dequeue_accept(sk)) != NULL) {
-			__vsock_release(pending, SINGLE_DEPTH_NESTING);
-			sock_put(pending);
-		}
+	if (vsk->transport)
+		vsk->transport->release(vsk);
+	else if (sk->sk_type == SOCK_STREAM)
+		vsock_remove_sock(vsk);
 
-		release_sock(sk);
-		sock_put(sk);
+	sock_orphan(sk);
+	sk->sk_shutdown = SHUTDOWN_MASK;
+
+	skb_queue_purge(&sk->sk_receive_queue);
+
+	/* Clean up any sockets that never were accepted. */
+	while ((pending = vsock_dequeue_accept(sk)) != NULL) {
+		__vsock_release(pending, SINGLE_DEPTH_NESTING);
+		sock_put(pending);
 	}
+
+	release_sock(sk);
+	sock_put(sk);
 }
 
 static void vsock_sk_destruct(struct sock *sk)
@@ -853,9 +853,22 @@ s64 vsock_stream_has_space(struct vsock_
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_space);
 
+/* Dummy callback required by sockmap.
+ * See unconditional call of saved_close() in sock_map_close().
+ */
+static void vsock_close(struct sock *sk, long timeout)
+{
+}
+
 static int vsock_release(struct socket *sock)
 {
-	__vsock_release(sock->sk, 0);
+	struct sock *sk = sock->sk;
+
+	if (!sk)
+		return 0;
+
+	sk->sk_prot->close(sk, 0);
+	__vsock_release(sk, 0);
 	sock->sk = NULL;
 	sock->state = SS_FREE;
 


