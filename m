Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D841190072;
	Mon, 10 Mar 2025 17:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628578; cv=none; b=cFdeZwfmWX+E6piV8OCG3+y1EhLJEZMT1jnnwJpBBpncPFfLLx1gFHzgIw/AYAWP4uF3BhLtebokYkHkSR9GddCLwL0mzZRh3ETSc/kFqGHeFWXZSfmmX8uCwcXNXqkUOzG3z3lMUmt5VSsnsWRWVVLcYd4jEp1qGv7vxL6itn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628578; c=relaxed/simple;
	bh=aiXc5oGF1qnfswJ00QD5OMbbjrQBnB8HFCBbRjjexKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4aNmyNkC+tQtSdm/vwvxamS0K4rSfGXRn3aVOLzzEjLJ9M73WonMTgnkRKFDecEvn8gTQcfit2k20Hz/fHXS1B3UMIXXL8xR+ceIGNQ3FObrwZGiCjSeQY62q4i0fRCZkqCTGX4eGeTJLBw4fzs+ngJ7ILE+8zfLmHTNvPY8LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9q4yUmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9q4yUmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9442C4CEE5;
	Mon, 10 Mar 2025 17:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628578;
	bh=aiXc5oGF1qnfswJ00QD5OMbbjrQBnB8HFCBbRjjexKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9q4yUmZ32Kg82rteEqd+k0GlQk+ump1+OGXGqQyP2888bJhIyyXqLzw2E2ImoB49
	 l/jXL1sCO5LRO1xkI6zx6kUk8jhfDm+Qdb0XpAFZ9enr35PZNvqTE6MKEBn2yz3R8B
	 v6kjFx1KdxmtS6zQXgAbtMwGd9jp2jeN7taS2+Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 6.1 106/109] bpf, vsock: Invoke proto::close on close()
Date: Mon, 10 Mar 2025 18:07:30 +0100
Message-ID: <20250310170431.775062731@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -116,12 +116,14 @@
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
@@ -803,39 +805,37 @@ static bool sock_type_connectible(u16 ty
 
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
-		else if (sock_type_connectible(sk->sk_type))
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
+	else if (sock_type_connectible(sk->sk_type))
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
@@ -912,9 +912,22 @@ void vsock_data_ready(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(vsock_data_ready);
 
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
 


