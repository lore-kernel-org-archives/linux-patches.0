Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18BA1F582A;
	Mon, 23 Jun 2025 21:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713312; cv=none; b=IQ1MFq2c6ZEfuATdBmWNSllAsVgOQmcJqUm1JH/Wfkdc/8VF9oVkUI3VHB1tUJsSccbYP1piZzDXbnWGya6zAmZdZVDu5ucKHiNVCXoSO9lwhD+AOx6Gep+a298IBwxBpbvNtKdK5EbKid4iJrebno2l5cM9kZRHCPZFsUvBvYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713312; c=relaxed/simple;
	bh=aiWfr1LnjfDxyfLC44AZXe9NFF7dnJ7UeXfj/i/X00A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LT6QyRdI49Clxmga8Ddz1p9gvoryYV2MKIrokzS19CleB6G6NHgCaJeIHHHazNJ5EUpcW2Dhjz28kBpU0neUNUQaypspAX6MNQWHvCOYCOHp+vlUq82t+JDNDqX5keMr+yqBsqQNVWkisxUhmMiBe6FHs8L4hbqTZW5jF5GJVC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGeGi0P3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGeGi0P3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6491C4CEEA;
	Mon, 23 Jun 2025 21:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713312;
	bh=aiWfr1LnjfDxyfLC44AZXe9NFF7dnJ7UeXfj/i/X00A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGeGi0P32COdl8pOq3QE3n4/8DyaBM0/wmDxR8FyfWYi1ZCRBdfKPehe+9NgRqoI+
	 uRymyhgu1Ovk5ohiX5/tP9jkE3UIsYJgZxilNUcfXsm/XFKMqzrB78+uNNkD/J3HH4
	 s/YFLwlsemNJ9DYdsOA/nbyy87VYN/SGUs4NyQyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <cong.wang@bytedance.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/355] net: Rename ->stream_memory_read to ->sock_is_readable
Date: Mon, 23 Jun 2025 15:05:28 +0200
Message-ID: <20250623130630.562053732@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 7b50ecfcc6cdfe87488576bc3ed443dc8d083b90 ]

The proto ops ->stream_memory_read() is currently only used
by TCP to check whether psock queue is empty or not. We need
to rename it before reusing it for non-TCP protocols, and
adjust the exsiting users accordingly.

Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20211008203306.37525-2-xiyou.wangcong@gmail.com
Stable-dep-of: 2660a544fdc0 ("net: Fix TOCTOU issue in sk_is_readable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 8 +++++++-
 include/net/tls.h  | 2 +-
 net/ipv4/tcp.c     | 5 +----
 net/ipv4/tcp_bpf.c | 4 ++--
 net/tls/tls_main.c | 4 ++--
 net/tls/tls_sw.c   | 2 +-
 6 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 548f9aab9aa10..b9e34b955c561 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1226,7 +1226,7 @@ struct proto {
 #endif
 
 	bool			(*stream_memory_free)(const struct sock *sk, int wake);
-	bool			(*stream_memory_read)(const struct sock *sk);
+	bool			(*sock_is_readable)(struct sock *sk);
 	/* Memory pressure */
 	void			(*enter_memory_pressure)(struct sock *sk);
 	void			(*leave_memory_pressure)(struct sock *sk);
@@ -2825,4 +2825,10 @@ void sock_set_sndtimeo(struct sock *sk, s64 secs);
 
 int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
 
+static inline bool sk_is_readable(struct sock *sk)
+{
+	if (sk->sk_prot->sock_is_readable)
+		return sk->sk_prot->sock_is_readable(sk);
+	return false;
+}
 #endif	/* _SOCK_H */
diff --git a/include/net/tls.h b/include/net/tls.h
index d9cb597cab46a..c76a827a678ae 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -377,7 +377,7 @@ void tls_sw_release_resources_rx(struct sock *sk);
 void tls_sw_free_ctx_rx(struct tls_context *tls_ctx);
 int tls_sw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		   int nonblock, int flags, int *addr_len);
-bool tls_sw_stream_read(const struct sock *sk);
+bool tls_sw_sock_is_readable(struct sock *sk);
 ssize_t tls_sw_splice_read(struct socket *sock, loff_t *ppos,
 			   struct pipe_inode_info *pipe,
 			   size_t len, unsigned int flags);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 0332fdab942db..2d870d5e31cfb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -480,10 +480,7 @@ static bool tcp_stream_is_readable(struct sock *sk, int target)
 {
 	if (tcp_epollin_ready(sk, target))
 		return true;
-
-	if (sk->sk_prot->stream_memory_read)
-		return sk->sk_prot->stream_memory_read(sk);
-	return false;
+	return sk_is_readable(sk);
 }
 
 /*
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 9765fda6cc378..f97e357e2644d 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -233,7 +233,7 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
 EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir);
 
 #ifdef CONFIG_BPF_SYSCALL
-static bool tcp_bpf_stream_read(const struct sock *sk)
+static bool tcp_bpf_sock_is_readable(struct sock *sk)
 {
 	struct sk_psock *psock;
 	bool empty = true;
@@ -582,7 +582,7 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 	prot[TCP_BPF_BASE].destroy		= sock_map_destroy;
 	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
-	prot[TCP_BPF_BASE].stream_memory_read	= tcp_bpf_stream_read;
+	prot[TCP_BPF_BASE].sock_is_readable	= tcp_bpf_sock_is_readable;
 
 	prot[TCP_BPF_TX]			= prot[TCP_BPF_BASE];
 	prot[TCP_BPF_TX].sendmsg		= tcp_bpf_sendmsg;
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 9d7b52370155b..63517995c692a 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -731,12 +731,12 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 
 	prot[TLS_BASE][TLS_SW] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_BASE][TLS_SW].recvmsg		  = tls_sw_recvmsg;
-	prot[TLS_BASE][TLS_SW].stream_memory_read = tls_sw_stream_read;
+	prot[TLS_BASE][TLS_SW].sock_is_readable   = tls_sw_sock_is_readable;
 	prot[TLS_BASE][TLS_SW].close		  = tls_sk_proto_close;
 
 	prot[TLS_SW][TLS_SW] = prot[TLS_SW][TLS_BASE];
 	prot[TLS_SW][TLS_SW].recvmsg		= tls_sw_recvmsg;
-	prot[TLS_SW][TLS_SW].stream_memory_read	= tls_sw_stream_read;
+	prot[TLS_SW][TLS_SW].sock_is_readable   = tls_sw_sock_is_readable;
 	prot[TLS_SW][TLS_SW].close		= tls_sk_proto_close;
 
 #ifdef CONFIG_TLS_DEVICE
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0723b3a4f6d91..7a448fd96f81c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2047,7 +2047,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	return copied ? : err;
 }
 
-bool tls_sw_stream_read(const struct sock *sk)
+bool tls_sw_sock_is_readable(struct sock *sk)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
-- 
2.39.5



