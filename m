Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC8F1DDF5;
	Tue, 16 Jul 2024 15:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144604; cv=none; b=a6iCfrEywzJaN75bvDpRdqo1vtxtKYllBaFU7ngM4Ck2Y7x8ZtE8OD44KXYevh/T2qTEIbI7NRt3w1L4bMfWjVIfn86YyvpQ8VjSF0I9nzePUV7/B1FmqMNysA0bKnkRszxdoerzJRSFT8OyJXuUEvE71F/tXK12JitFyBp+CzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144604; c=relaxed/simple;
	bh=/t2FIKcjR/yeOHdQu2YmkdJ68f9ke2Zqgll74zA9aVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgLaRIWIBh2AQt/p63Itu7Zy69j88QuhJT/HCESOIFM3c1SE+Ka09G9bvkTvbkVLlzmryD7pq3TwT4bXcQl0TotzVOh6P2B98PHJMoNJP9XL7oPKTEVvLhQOUNbVoMOz3YqP8dsSrtuTF8b04ZWnRlnrmOsJYbjkTTaA3p1oouk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvKc/1tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvKc/1tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A0FC116B1;
	Tue, 16 Jul 2024 15:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144604;
	bh=/t2FIKcjR/yeOHdQu2YmkdJ68f9ke2Zqgll74zA9aVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvKc/1two6wibrGfj9p5X/m/dpWObUNwd8uNR+k2KDkYwFJcASyDZZ8H4Z4MsM+sa
	 rkdH3N7DwDpB3zOkwjVzIJ0w9K7i1xKcPdI6evip5AOAuqXwYYYCl7J5+MVSC6n5WZ
	 q1eHMKp12yV/d/DiIzxHsOUhPXaDAOhvsQXVzBd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Wen Gu <guwen@linux.alibaba.com>
Subject: [PATCH 5.10 046/108] bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues
Date: Tue, 16 Jul 2024 17:31:01 +0200
Message-ID: <20240716152747.760086844@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yufen <wangyufen@huawei.com>

commit d8616ee2affcff37c5d315310da557a694a3303d upstream.

During TCP sockmap redirect pressure test, the following warning is triggered:

WARNING: CPU: 3 PID: 2145 at net/core/stream.c:205 sk_stream_kill_queues+0xbc/0xd0
CPU: 3 PID: 2145 Comm: iperf Kdump: loaded Tainted: G        W         5.10.0+ #9
Call Trace:
 inet_csk_destroy_sock+0x55/0x110
 inet_csk_listen_stop+0xbb/0x380
 tcp_close+0x41b/0x480
 inet_release+0x42/0x80
 __sock_release+0x3d/0xa0
 sock_close+0x11/0x20
 __fput+0x9d/0x240
 task_work_run+0x62/0x90
 exit_to_user_mode_prepare+0x110/0x120
 syscall_exit_to_user_mode+0x27/0x190
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The reason we observed is that:

When the listener is closing, a connection may have completed the three-way
handshake but not accepted, and the client has sent some packets. The child
sks in accept queue release by inet_child_forget()->inet_csk_destroy_sock(),
but psocks of child sks have not released.

To fix, add sock_map_destroy to release psocks.

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20220524075311.649153-1-wangyufen@huawei.com
[ Conflict in include/linux/bpf.h due to function declaration position
  and remove non-existed sk_psock_stop helper from sock_map_destroy.  ]
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h   |    1 +
 include/linux/skmsg.h |    1 +
 net/core/skmsg.c      |    1 +
 net/core/sock_map.c   |   22 ++++++++++++++++++++++
 net/ipv4/tcp_bpf.c    |    1 +
 5 files changed, 26 insertions(+)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1800,6 +1800,7 @@ int sock_map_get_from_fd(const union bpf
 int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype);
 int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value, u64 flags);
 void sock_map_unhash(struct sock *sk);
+void sock_map_destroy(struct sock *sk);
 void sock_map_close(struct sock *sk, long timeout);
 #else
 static inline int sock_map_prog_update(struct bpf_map *map,
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -98,6 +98,7 @@ struct sk_psock {
 	spinlock_t			link_lock;
 	refcount_t			refcnt;
 	void (*saved_unhash)(struct sock *sk);
+	void (*saved_destroy)(struct sock *sk);
 	void (*saved_close)(struct sock *sk, long timeout);
 	void (*saved_write_space)(struct sock *sk);
 	struct proto			*sk_proto;
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -599,6 +599,7 @@ struct sk_psock *sk_psock_init(struct so
 	psock->eval = __SK_NONE;
 	psock->sk_proto = prot;
 	psock->saved_unhash = prot->unhash;
+	psock->saved_destroy = prot->destroy;
 	psock->saved_close = prot->close;
 	psock->saved_write_space = sk->sk_write_space;
 
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1566,6 +1566,28 @@ void sock_map_unhash(struct sock *sk)
 	saved_unhash(sk);
 }
 
+void sock_map_destroy(struct sock *sk)
+{
+	void (*saved_destroy)(struct sock *sk);
+	struct sk_psock *psock;
+
+	rcu_read_lock();
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock)) {
+		rcu_read_unlock();
+		if (sk->sk_prot->destroy)
+			sk->sk_prot->destroy(sk);
+		return;
+	}
+
+	saved_destroy = psock->saved_destroy;
+	sock_map_remove_links(sk, psock);
+	rcu_read_unlock();
+	sk_psock_put(sk, psock);
+	saved_destroy(sk);
+}
+EXPORT_SYMBOL_GPL(sock_map_destroy);
+
 void sock_map_close(struct sock *sk, long timeout)
 {
 	void (*saved_close)(struct sock *sk, long timeout);
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -582,6 +582,7 @@ static void tcp_bpf_rebuild_protos(struc
 				   struct proto *base)
 {
 	prot[TCP_BPF_BASE]			= *base;
+	prot[TCP_BPF_BASE].destroy		= sock_map_destroy;
 	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
 	prot[TCP_BPF_BASE].stream_memory_read	= tcp_bpf_stream_read;


