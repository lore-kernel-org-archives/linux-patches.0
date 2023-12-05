Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11816FAF;
	Tue,  5 Dec 2023 03:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhjOi9Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E97C433C7;
	Tue,  5 Dec 2023 03:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746649;
	bh=1ao1cm80mEc/y2aSm3hSW/Ew32LD6TUeVFkcuLxHYxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhjOi9Fm8Gxkj8/PpltB5DFUBcWQ/QW3W8ykQb7tdequI6j+GKnbzOGiAvF++9NrB
	 lI4JFTl7EQC1QtYzqcmMUnuiUILCHxQFt+wi2nO0M4tNXjH/QUWjXj3WTa/ckL31Tf
	 y27UlLK2u36//I2n2WG6BnIYQV0vIi+Ng+AxbHR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/134] bpf, sockmap: af_unix stream sockets need to hold ref for pair sock
Date: Tue,  5 Dec 2023 12:16:16 +0900
Message-ID: <20231205031542.015181008@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 8866730aed5100f06d3d965c22f1c61f74942541 ]

AF_UNIX stream sockets are a paired socket. So sending on one of the pairs
will lookup the paired socket as part of the send operation. It is possible
however to put just one of the pairs in a BPF map. This currently increments
the refcnt on the sock in the sockmap to ensure it is not free'd by the
stack before sockmap cleans up its state and stops any skbs being sent/recv'd
to that socket.

But we missed a case. If the peer socket is closed it will be free'd by the
stack. However, the paired socket can still be referenced from BPF sockmap
side because we hold a reference there. Then if we are sending traffic through
BPF sockmap to that socket it will try to dereference the free'd pair in its
send logic creating a use after free. And following splat:

   [59.900375] BUG: KASAN: slab-use-after-free in sk_wake_async+0x31/0x1b0
   [59.901211] Read of size 8 at addr ffff88811acbf060 by task kworker/1:2/954
   [...]
   [59.905468] Call Trace:
   [59.905787]  <TASK>
   [59.906066]  dump_stack_lvl+0x130/0x1d0
   [59.908877]  print_report+0x16f/0x740
   [59.910629]  kasan_report+0x118/0x160
   [59.912576]  sk_wake_async+0x31/0x1b0
   [59.913554]  sock_def_readable+0x156/0x2a0
   [59.914060]  unix_stream_sendmsg+0x3f9/0x12a0
   [59.916398]  sock_sendmsg+0x20e/0x250
   [59.916854]  skb_send_sock+0x236/0xac0
   [59.920527]  sk_psock_backlog+0x287/0xaa0

To fix let BPF sockmap hold a refcnt on both the socket in the sockmap and its
paired socket. It wasn't obvious how to contain the fix to bpf_unix logic. The
primarily problem with keeping this logic in bpf_unix was: In the sock close()
we could handle the deref by having a close handler. But, when we are destroying
the psock through a map delete operation we wouldn't have gotten any signal
thorugh the proto struct other than it being replaced. If we do the deref from
the proto replace its too early because we need to deref the sk_pair after the
backlog worker has been stopped.

Given all this it seems best to just cache it at the end of the psock and eat 8B
for the af_unix and vsock users. Notice dgram sockets are OK because they handle
locking already.

Fixes: 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20231129012557.95371-2-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h | 1 +
 include/net/af_unix.h | 1 +
 net/core/skmsg.c      | 2 ++
 net/unix/af_unix.c    | 2 --
 net/unix/unix_bpf.c   | 5 +++++
 5 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index c1637515a8a41..c953b8c0d2f43 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -106,6 +106,7 @@ struct sk_psock {
 	struct mutex			work_mutex;
 	struct sk_psock_work_state	work_state;
 	struct delayed_work		work;
+	struct sock			*sk_pair;
 	struct rcu_work			rwork;
 };
 
diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 824c258143a3a..49c4640027d8a 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -75,6 +75,7 @@ struct unix_sock {
 };
 
 #define unix_sk(ptr) container_of_const(ptr, struct unix_sock, sk)
+#define unix_peer(sk) (unix_sk(sk)->peer)
 
 #define peer_wait peer_wq.wait
 
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 6c31eefbd7778..93ecfceac1bc4 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -826,6 +826,8 @@ static void sk_psock_destroy(struct work_struct *work)
 
 	if (psock->sk_redir)
 		sock_put(psock->sk_redir);
+	if (psock->sk_pair)
+		sock_put(psock->sk_pair);
 	sock_put(psock->sk);
 	kfree(psock);
 }
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 3e6eeacb13aec..1e1a88bd4e688 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -212,8 +212,6 @@ static inline bool unix_secdata_eq(struct scm_cookie *scm, struct sk_buff *skb)
 }
 #endif /* CONFIG_SECURITY_NETWORK */
 
-#define unix_peer(sk) (unix_sk(sk)->peer)
-
 static inline int unix_our_peer(struct sock *sk, struct sock *osk)
 {
 	return unix_peer(osk) == sk;
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index 2f9d8271c6ec7..7ea7c3a0d0d06 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -159,12 +159,17 @@ int unix_dgram_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool re
 
 int unix_stream_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 {
+	struct sock *sk_pair;
+
 	if (restore) {
 		sk->sk_write_space = psock->saved_write_space;
 		sock_replace_proto(sk, psock->sk_proto);
 		return 0;
 	}
 
+	sk_pair = unix_peer(sk);
+	sock_hold(sk_pair);
+	psock->sk_pair = sk_pair;
 	unix_stream_bpf_check_needs_rebuild(psock->sk_proto);
 	sock_replace_proto(sk, &unix_stream_bpf_prot);
 	return 0;
-- 
2.42.0



