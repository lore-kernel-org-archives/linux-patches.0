Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FB02156FF;
	Thu, 12 Dec 2024 15:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015933; cv=none; b=T7yZmzHAnPvhN9IzpYLpn7BrhMABmM1EwSDn56BVS7ncaM1d7AoyvVztHm7yItqvHctSsA0zfjipsyFULgcPykck1+76WtvG3/N74m/kFCaaKQQmiPD2DQps5jDMhxKuladSDt/5WAvCQ+qE+eN4SVYP/csrbtytzADLfIuLUCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015933; c=relaxed/simple;
	bh=nXRya/TI5X2+IUdZX/pLc7cuTc6INtv/9sd04UQtv3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnSR3m3q0GoLvoRgb26WFs3JUyowDxvywFbJlHEJJD8fSX2gq9fJxQzQCwJtw0GYzVqDayAemEDM8oaiS0s0y0bwDxF+G5/Be+aAuOaH5Znh3rXpsh65gntfpTpM5u6uYbT8i+Nyd+kLik9kNNkevyjjE7ADtjZzaj5BoAiC/8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfSEf3Pw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfSEf3Pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90305C4CECE;
	Thu, 12 Dec 2024 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015933;
	bh=nXRya/TI5X2+IUdZX/pLc7cuTc6INtv/9sd04UQtv3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfSEf3PwVL3p7PU1XJ95CITB5VWdM24cfM2a/vpDNqpEqncV5gri3Oa6kUaka5ZYw
	 PwGfuK0bbl96SZOP2wHYs0JvC7fIid/uAXc+IJfj2JXX3i1mYuTrwQmo/2ta77ZMk9
	 eNM+b5JEV1L6+Y2VlZOCxqRkq8a5XQAuB0yLwFmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/466] bpf, vsock: Invoke proto::close on close()
Date: Thu, 12 Dec 2024 15:54:13 +0100
Message-ID: <20241212144310.140287555@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 135ffc7becc82cfb84936ae133da7969220b43b2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 67 ++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 27 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 919da8edd03c8..b52b798aa4c29 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -117,12 +117,14 @@
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
 static void vsock_sk_destruct(struct sock *sk);
 static int vsock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
+static void vsock_close(struct sock *sk, long timeout);
 
 /* Protocol family. */
 struct proto vsock_proto = {
 	.name = "AF_VSOCK",
 	.owner = THIS_MODULE,
 	.obj_size = sizeof(struct vsock_sock),
+	.close = vsock_close,
 #ifdef CONFIG_BPF_SYSCALL
 	.psock_update_sk_prot = vsock_bpf_update_proto,
 #endif
@@ -797,39 +799,37 @@ static bool sock_type_connectible(u16 type)
 
 static void __vsock_release(struct sock *sk, int level)
 {
-	if (sk) {
-		struct sock *pending;
-		struct vsock_sock *vsk;
-
-		vsk = vsock_sk(sk);
-		pending = NULL;	/* Compiler warning. */
+	struct vsock_sock *vsk;
+	struct sock *pending;
 
-		/* When "level" is SINGLE_DEPTH_NESTING, use the nested
-		 * version to avoid the warning "possible recursive locking
-		 * detected". When "level" is 0, lock_sock_nested(sk, level)
-		 * is the same as lock_sock(sk).
-		 */
-		lock_sock_nested(sk, level);
+	vsk = vsock_sk(sk);
+	pending = NULL;	/* Compiler warning. */
 
-		if (vsk->transport)
-			vsk->transport->release(vsk);
-		else if (sock_type_connectible(sk->sk_type))
-			vsock_remove_sock(vsk);
+	/* When "level" is SINGLE_DEPTH_NESTING, use the nested
+	 * version to avoid the warning "possible recursive locking
+	 * detected". When "level" is 0, lock_sock_nested(sk, level)
+	 * is the same as lock_sock(sk).
+	 */
+	lock_sock_nested(sk, level);
 
-		sock_orphan(sk);
-		sk->sk_shutdown = SHUTDOWN_MASK;
+	if (vsk->transport)
+		vsk->transport->release(vsk);
+	else if (sock_type_connectible(sk->sk_type))
+		vsock_remove_sock(vsk);
 
-		skb_queue_purge(&sk->sk_receive_queue);
+	sock_orphan(sk);
+	sk->sk_shutdown = SHUTDOWN_MASK;
 
-		/* Clean up any sockets that never were accepted. */
-		while ((pending = vsock_dequeue_accept(sk)) != NULL) {
-			__vsock_release(pending, SINGLE_DEPTH_NESTING);
-			sock_put(pending);
-		}
+	skb_queue_purge(&sk->sk_receive_queue);
 
-		release_sock(sk);
-		sock_put(sk);
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
@@ -901,9 +901,22 @@ void vsock_data_ready(struct sock *sk)
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
 
-- 
2.43.0



