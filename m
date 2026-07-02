Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2366348C71;
	Thu,  2 Jul 2026 16:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009864; cv=none; b=reraJdPb5PLGwvsXW+cfTd0auQMF72zjGnu1irxoGTYQFfj0A+3UR3WKV7K+9ylhErgZQ+YJkwHMEIstoFGJWTCyrzQ/OZt9KZcI+mfznH3jclLUfwbLzVKkFcT1QVyB59VZbcMt5dBBeMWiYpqSHih18JfmxiV3CJ8Pv1Jk2l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009864; c=relaxed/simple;
	bh=aN0NxbxaYO1qp4NPuDCfXbgbBy7ycooaVwMvGcLvf0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFJcQtZcSGuy/76JmSOEYpZj9FJTAnvjtk04zzC2bXZ9GftE6YjX+/HOITkMFkHiAhQwwZXt96efWP7oJ7LWMHddTVnROT5NELN9mlRWNWD9KyhLSeiaLaSvxw3HWO0lZvOVyJrJsiHqz3h2GLRk2jcL7vp0s7wWPPs0zZs5XAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXPQ4bWB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXPQ4bWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4351F000E9;
	Thu,  2 Jul 2026 16:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009862;
	bh=KQlQbAC/r+npsS06K/NgkrIngYDx2FqS4/+R/XviWY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXPQ4bWBRJaOP9YOwJywsqndRc3RUEolJlugyxA22KMIgcPY4wPqsTZyCATfN38u1
	 +s/A/EpLyYCRc1w1yH9R4daLyYo+Y17wKZmqp8no2qdceCXaWA7/ekRvk6YB1qAxLF
	 2ErpPvLLASIdfc1EHAcKoKF3C/Wa54EvWVHGuBOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+87f770387a9e5dc6b79b@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/129] net: annotate data-races around sk->sk_{data_ready,write_space}
Date: Thu,  2 Jul 2026 18:19:00 +0200
Message-ID: <20260702155112.599590447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2ef2b20cf4e04ac8a6ba68493f8780776ff84300 ]

skmsg (and probably other layers) are changing these pointers
while other cpus might read them concurrently.

Add corresponding READ_ONCE()/WRITE_ONCE() annotations
for UDP, TCP and AF_UNIX.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Reported-by: syzbot+87f770387a9e5dc6b79b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/699ee9fc.050a0220.1cd54b.0009.GAE@google.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260225131547.1085509-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c         | 14 +++++++-------
 net/ipv4/tcp.c           |  4 ++--
 net/ipv4/tcp_bpf.c       |  2 +-
 net/ipv4/tcp_input.c     | 14 ++++++++------
 net/ipv4/tcp_minisocks.c |  2 +-
 net/ipv4/udp.c           |  2 +-
 net/ipv4/udp_bpf.c       |  2 +-
 net/unix/af_unix.c       |  8 ++++----
 8 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 444b9b25ade28d..fd1a2464db0aab 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1198,8 +1198,8 @@ void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
 		return;
 
 	psock->saved_data_ready = sk->sk_data_ready;
-	sk->sk_data_ready = sk_psock_strp_data_ready;
-	sk->sk_write_space = sk_psock_write_space;
+	WRITE_ONCE(sk->sk_data_ready, sk_psock_strp_data_ready);
+	WRITE_ONCE(sk->sk_write_space, sk_psock_write_space);
 }
 
 void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
@@ -1209,8 +1209,8 @@ void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
 	if (!psock->saved_data_ready)
 		return;
 
-	sk->sk_data_ready = psock->saved_data_ready;
-	psock->saved_data_ready = NULL;
+	WRITE_ONCE(sk->sk_data_ready, psock->saved_data_ready);
+	WRITE_ONCE(psock->saved_data_ready, NULL);
 	strp_stop(&psock->strp);
 }
 
@@ -1283,8 +1283,8 @@ void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)
 		return;
 
 	psock->saved_data_ready = sk->sk_data_ready;
-	sk->sk_data_ready = sk_psock_verdict_data_ready;
-	sk->sk_write_space = sk_psock_write_space;
+	WRITE_ONCE(sk->sk_data_ready, sk_psock_verdict_data_ready);
+	WRITE_ONCE(sk->sk_write_space, sk_psock_write_space);
 }
 
 void sk_psock_stop_verdict(struct sock *sk, struct sk_psock *psock)
@@ -1295,6 +1295,6 @@ void sk_psock_stop_verdict(struct sock *sk, struct sk_psock *psock)
 	if (!psock->saved_data_ready)
 		return;
 
-	sk->sk_data_ready = psock->saved_data_ready;
+	WRITE_ONCE(sk->sk_data_ready, psock->saved_data_ready);
 	psock->saved_data_ready = NULL;
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 076aa73c99fa81..82d6c01c7885c2 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1479,7 +1479,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	err = sk_stream_error(sk, flags, err);
 	/* make sure we wake any epoll edge trigger waiter */
 	if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
-		sk->sk_write_space(sk);
+		READ_ONCE(sk->sk_write_space)(sk);
 		tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
 	}
 	return err;
@@ -3844,7 +3844,7 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 	case TCP_NOTSENT_LOWAT:
 		WRITE_ONCE(tp->notsent_lowat, val);
-		sk->sk_write_space(sk);
+		READ_ONCE(sk->sk_write_space)(sk);
 		break;
 	case TCP_INQ:
 		if (val > 1 || val < 0)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 8e6c0737bfe128..9af7595bf8c452 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -750,7 +750,7 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 			WRITE_ONCE(sk->sk_prot->unhash, psock->saved_unhash);
 			tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
 		} else {
-			sk->sk_write_space = psock->saved_write_space;
+			WRITE_ONCE(sk->sk_write_space, psock->saved_write_space);
 			/* Pairs with lockless read in sk_clone_lock() */
 			sock_replace_proto(sk, psock->sk_proto);
 		}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 645ff379c42544..91b019df7ddf79 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4898,7 +4898,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
-		sk->sk_data_ready(sk);
+		READ_ONCE(sk->sk_data_ready)(sk);
 		tcp_drop_reason(sk, skb, SKB_DROP_REASON_PROTO_MEM);
 		return;
 	}
@@ -5104,7 +5104,7 @@ int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
 void tcp_data_ready(struct sock *sk)
 {
 	if (tcp_epollin_ready(sk, sk->sk_rcvlowat) || sock_flag(sk, SOCK_DONE))
-		sk->sk_data_ready(sk);
+		READ_ONCE(sk->sk_data_ready)(sk);
 }
 
 static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
@@ -5150,7 +5150,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		else if (tcp_try_rmem_schedule(sk, skb, skb->truesize)) {
 			reason = SKB_DROP_REASON_PROTO_MEM;
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRCVQDROP);
-			sk->sk_data_ready(sk);
+			READ_ONCE(sk->sk_data_ready)(sk);
 			goto drop;
 		}
 
@@ -5570,7 +5570,9 @@ static void tcp_new_space(struct sock *sk)
 		tp->snd_cwnd_stamp = tcp_jiffies32;
 	}
 
-	INDIRECT_CALL_1(sk->sk_write_space, sk_stream_write_space, sk);
+	INDIRECT_CALL_1(READ_ONCE(sk->sk_write_space),
+			sk_stream_write_space,
+			sk);
 }
 
 /* Caller made space either from:
@@ -5768,7 +5770,7 @@ static void tcp_urg(struct sock *sk, struct sk_buff *skb, const struct tcphdr *t
 				BUG();
 			WRITE_ONCE(tp->urg_data, TCP_URG_VALID | tmp);
 			if (!sock_flag(sk, SOCK_DEAD))
-				sk->sk_data_ready(sk);
+				READ_ONCE(sk->sk_data_ready)(sk);
 		}
 	}
 }
@@ -7133,7 +7135,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 			sock_put(fastopen_sk);
 			goto drop_and_free;
 		}
-		sk->sk_data_ready(sk);
+		READ_ONCE(sk->sk_data_ready)(sk);
 		bh_unlock_sock(fastopen_sk);
 		sock_put(fastopen_sk);
 	} else {
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0b934b6ebb55b0..22b5748a6ee2c6 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -858,7 +858,7 @@ int tcp_child_process(struct sock *parent, struct sock *child,
 		ret = tcp_rcv_state_process(child, skb);
 		/* Wakeup parent, send SIGIO */
 		if (state == TCP_SYN_RECV && child->sk_state != state)
-			parent->sk_data_ready(parent);
+			READ_ONCE(parent->sk_data_ready)(parent);
 	} else {
 		/* Alas, it is possible again, because we do lookup
 		 * in main socket hash table and lock on listening
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index a8bfab80d66a5f..d1714aaedf1768 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1580,7 +1580,7 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 	spin_unlock(&list->lock);
 
 	if (!sock_flag(sk, SOCK_DEAD))
-		sk->sk_data_ready(sk);
+		READ_ONCE(sk->sk_data_ready)(sk);
 
 	busylock_release(busy);
 	return 0;
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 0735d820e413f3..44271ba1adec15 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -143,7 +143,7 @@ int udp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 	int family = sk->sk_family == AF_INET ? UDP_BPF_IPV4 : UDP_BPF_IPV6;
 
 	if (restore) {
-		sk->sk_write_space = psock->saved_write_space;
+		WRITE_ONCE(sk->sk_write_space, psock->saved_write_space);
 		sock_replace_proto(sk, psock->sk_proto);
 		return 0;
 	}
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index a268a483efcd3f..f5b215ca76d249 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1610,7 +1610,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	__skb_queue_tail(&other->sk_receive_queue, skb);
 	spin_unlock(&other->sk_receive_queue.lock);
 	unix_state_unlock(other);
-	other->sk_data_ready(other);
+	READ_ONCE(other->sk_data_ready)(other);
 	sock_put(other);
 	return 0;
 
@@ -2082,7 +2082,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	scm_stat_add(other, skb);
 	skb_queue_tail(&other->sk_receive_queue, skb);
 	unix_state_unlock(other);
-	other->sk_data_ready(other);
+	READ_ONCE(other->sk_data_ready)(other);
 	sock_put(other);
 	scm_destroy(&scm);
 	return len;
@@ -2150,7 +2150,7 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 
 	sk_send_sigurg(other);
 	unix_state_unlock(other);
-	other->sk_data_ready(other);
+	READ_ONCE(other->sk_data_ready)(other);
 
 	return err;
 }
@@ -2243,7 +2243,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		scm_stat_add(other, skb);
 		skb_queue_tail(&other->sk_receive_queue, skb);
 		unix_state_unlock(other);
-		other->sk_data_ready(other);
+		READ_ONCE(other->sk_data_ready)(other);
 		sent += size;
 	}
 
-- 
2.53.0



