Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27671E520;
	Tue, 27 Aug 2024 15:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771175; cv=none; b=XF2v9/+ilzsovUQT155SZq5vlA4oORu5t4q/8xojjfZpLW0VwzAAJula/CghWDN0HKOeUJm2Kqesro/5GV7+ODbpIdY5uhCvfyGZnu6Qk618ZNxhHNv6zX2SJgvyTI9kjc/AA52bdMq9Q9RoJ1/tNQtOXABf5Gu7ZP7rMvSCNAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771175; c=relaxed/simple;
	bh=mwamkJ7s57EpLYcmPHp0+zTMdzOorQKeN4c+rK0QXl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StzrwJ95RZQU45DUS0sRj8k6DWn2Nhns2xI/nTtx6p9smKiUP2hAzMTlwvCZeQL7AS5MyKalNoWv/1LDynO+hywAn15jjW6fy2ZCh4wqPJaoFG3TmOyixZCQUwfgoxEf0EVYb6oaSpulXF045Jc8mmsdphZabRvk05Z1yIoq7FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UG7lZ/3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UG7lZ/3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62259C6107C;
	Tue, 27 Aug 2024 15:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771174;
	bh=mwamkJ7s57EpLYcmPHp0+zTMdzOorQKeN4c+rK0QXl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UG7lZ/3WAjfc2bpAR+B99PSkhGnahtOUdjuO2M8W5BjnLc9HWo9GZ2iYQJBwJcKOZ
	 yTjA4vyJYOaXmPccKztsfVGwDy+mTvhafuWvqGN+qLw1oHnQh9sZ5yqPfrJPY1M+Wm
	 fhR/BiUg5Tvrz/noxeogBT0nDZFbuNE7IZ+7niTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bdb4bd87b5e22058e2a4@syzkaller.appspotmail.com,
	Bobby Eshleman <bobby.eshleman@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Cong Wang <cong.wang@bytedance.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 110/273] vsock: fix recursive ->recvmsg calls
Date: Tue, 27 Aug 2024 16:37:14 +0200
Message-ID: <20240827143837.595675557@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 69139d2919dd4aa9a553c8245e7c63e82613e3fc ]

After a vsock socket has been added to a BPF sockmap, its prot->recvmsg
has been replaced with vsock_bpf_recvmsg(). Thus the following
recursiion could happen:

vsock_bpf_recvmsg()
 -> __vsock_recvmsg()
  -> vsock_connectible_recvmsg()
   -> prot->recvmsg()
    -> vsock_bpf_recvmsg() again

We need to fix it by calling the original ->recvmsg() without any BPF
sockmap logic in __vsock_recvmsg().

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Reported-by: syzbot+bdb4bd87b5e22058e2a4@syzkaller.appspotmail.com
Tested-by: syzbot+bdb4bd87b5e22058e2a4@syzkaller.appspotmail.com
Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20240812022153.86512-1-xiyou.wangcong@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/af_vsock.h    |  4 ++++
 net/vmw_vsock/af_vsock.c  | 50 +++++++++++++++++++++++----------------
 net/vmw_vsock/vsock_bpf.c |  4 ++--
 3 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 535701efc1e5c..24d970f7a4fa2 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -230,8 +230,12 @@ struct vsock_tap {
 int vsock_add_tap(struct vsock_tap *vt);
 int vsock_remove_tap(struct vsock_tap *vt);
 void vsock_deliver_tap(struct sk_buff *build_skb(void *opaque), void *opaque);
+int __vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
+				int flags);
 int vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			      int flags);
+int __vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
+			  size_t len, int flags);
 int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 			size_t len, int flags);
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 4b040285aa78c..0ff9b2dd86bac 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1270,25 +1270,28 @@ static int vsock_dgram_connect(struct socket *sock,
 	return err;
 }
 
+int __vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
+			  size_t len, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct vsock_sock *vsk = vsock_sk(sk);
+
+	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
+}
+
 int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 			size_t len, int flags)
 {
 #ifdef CONFIG_BPF_SYSCALL
+	struct sock *sk = sock->sk;
 	const struct proto *prot;
-#endif
-	struct vsock_sock *vsk;
-	struct sock *sk;
 
-	sk = sock->sk;
-	vsk = vsock_sk(sk);
-
-#ifdef CONFIG_BPF_SYSCALL
 	prot = READ_ONCE(sk->sk_prot);
 	if (prot != &vsock_proto)
 		return prot->recvmsg(sk, msg, len, flags, NULL);
 #endif
 
-	return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
+	return __vsock_dgram_recvmsg(sock, msg, len, flags);
 }
 EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
 
@@ -2174,15 +2177,12 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 }
 
 int
-vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
-			  int flags)
+__vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
+			    int flags)
 {
 	struct sock *sk;
 	struct vsock_sock *vsk;
 	const struct vsock_transport *transport;
-#ifdef CONFIG_BPF_SYSCALL
-	const struct proto *prot;
-#endif
 	int err;
 
 	sk = sock->sk;
@@ -2233,14 +2233,6 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		goto out;
 	}
 
-#ifdef CONFIG_BPF_SYSCALL
-	prot = READ_ONCE(sk->sk_prot);
-	if (prot != &vsock_proto) {
-		release_sock(sk);
-		return prot->recvmsg(sk, msg, len, flags, NULL);
-	}
-#endif
-
 	if (sk->sk_type == SOCK_STREAM)
 		err = __vsock_stream_recvmsg(sk, msg, len, flags);
 	else
@@ -2250,6 +2242,22 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	release_sock(sk);
 	return err;
 }
+
+int
+vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
+			  int flags)
+{
+#ifdef CONFIG_BPF_SYSCALL
+	struct sock *sk = sock->sk;
+	const struct proto *prot;
+
+	prot = READ_ONCE(sk->sk_prot);
+	if (prot != &vsock_proto)
+		return prot->recvmsg(sk, msg, len, flags, NULL);
+#endif
+
+	return __vsock_connectible_recvmsg(sock, msg, len, flags);
+}
 EXPORT_SYMBOL_GPL(vsock_connectible_recvmsg);
 
 static int vsock_set_rcvlowat(struct sock *sk, int val)
diff --git a/net/vmw_vsock/vsock_bpf.c b/net/vmw_vsock/vsock_bpf.c
index a3c97546ab84a..c42c5cc18f324 100644
--- a/net/vmw_vsock/vsock_bpf.c
+++ b/net/vmw_vsock/vsock_bpf.c
@@ -64,9 +64,9 @@ static int __vsock_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int
 	int err;
 
 	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
-		err = vsock_connectible_recvmsg(sock, msg, len, flags);
+		err = __vsock_connectible_recvmsg(sock, msg, len, flags);
 	else if (sk->sk_type == SOCK_DGRAM)
-		err = vsock_dgram_recvmsg(sock, msg, len, flags);
+		err = __vsock_dgram_recvmsg(sock, msg, len, flags);
 	else
 		err = -EPROTOTYPE;
 
-- 
2.43.0



