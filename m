Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2308C36EA89;
	Tue, 10 Mar 2026 11:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141202; cv=none; b=NWtNZ4bRA49UQHzJa2DDT92glM8zILLBqi/RRGeAog4u7sQKzaDKaCRmCq3Hx4f0SvbTeE4apa9MktfMcDtp2k+AQHQvMSyZj+kRinlSsSxb/XYwz7sbM5FBoWhljxIiNIS7xqZyFKRewg26kCpu2LDlq1Gm10dY2XN/P5kvRYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141202; c=relaxed/simple;
	bh=xkyg0wkOGpk7G87h9Q4X3kdhnrSo5Hph5Z/SNXTOATU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sm6l3xyyJPgHqPYDGa6drpzgqQIJKN0pDYid6KJsBnUS5AWg5cUIMn848mSIKEl13faGIMWU3m9SYBYL7FcU4jZOkxDNeWWbhYrlZY0QwCRjwL3I9H8pOB62D4u0VgpCvTcVgYo0oIeN0PITGbBvXt8Z5OUMinAq/5VKWmLo31I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UzQgz334; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UzQgz334"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DF5C19423;
	Tue, 10 Mar 2026 11:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141202;
	bh=xkyg0wkOGpk7G87h9Q4X3kdhnrSo5Hph5Z/SNXTOATU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzQgz334uvyRsITSEjdMNF+AxQqOWrCgdPAeDuctzsUnjOHO6Or1bvRiMegAfCS0y
	 8vaXk2gMPDF77erokM9mZytCIf58PN78STd52C7JOhcR9KGdlcWYAFSEb1MkCXDHTm
	 NtN67GsUlZ57tCYLxj789nf6c+2vMAqu8jmqHDsZenX0ds2QFf6bLfjUKhu5l0JnWL
	 TRtQlLVOrlmBLACqiEqEDhJpaWTMe09vL5U0LI5AolKl0OHo7nFMszeH3YOBIepDxH
	 E4pd0m5auErIgfcKAyg6FZLoTm0Jc+4eMcqYLfoiSTFDoxzuVLXWBXpkMhgARlvyrv
	 NuX23ah/YrHqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	syzbot+87f770387a9e5dc6b79b@syzkaller.appspotmail.com,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 202/311] net: annotate data-races around sk->sk_{data_ready,write_space}
Date: Tue, 10 Mar 2026 07:04:09 -0400
Message-ID: <a5239932b6bf7816dce69731db117f432f9e5801.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index ddde93dd8bc6d..12fbb0545c712 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1205,8 +1205,8 @@ void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
 		return;
 
 	psock->saved_data_ready = sk->sk_data_ready;
-	sk->sk_data_ready = sk_psock_strp_data_ready;
-	sk->sk_write_space = sk_psock_write_space;
+	WRITE_ONCE(sk->sk_data_ready, sk_psock_strp_data_ready);
+	WRITE_ONCE(sk->sk_write_space, sk_psock_write_space);
 }
 
 void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
@@ -1216,8 +1216,8 @@ void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
 	if (!psock->saved_data_ready)
 		return;
 
-	sk->sk_data_ready = psock->saved_data_ready;
-	psock->saved_data_ready = NULL;
+	WRITE_ONCE(sk->sk_data_ready, psock->saved_data_ready);
+	WRITE_ONCE(psock->saved_data_ready, NULL);
 	strp_stop(&psock->strp);
 }
 
@@ -1296,8 +1296,8 @@ void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock)
 		return;
 
 	psock->saved_data_ready = sk->sk_data_ready;
-	sk->sk_data_ready = sk_psock_verdict_data_ready;
-	sk->sk_write_space = sk_psock_write_space;
+	WRITE_ONCE(sk->sk_data_ready, sk_psock_verdict_data_ready);
+	WRITE_ONCE(sk->sk_write_space, sk_psock_write_space);
 }
 
 void sk_psock_stop_verdict(struct sock *sk, struct sk_psock *psock)
@@ -1308,6 +1308,6 @@ void sk_psock_stop_verdict(struct sock *sk, struct sk_psock *psock)
 	if (!psock->saved_data_ready)
 		return;
 
-	sk->sk_data_ready = psock->saved_data_ready;
+	WRITE_ONCE(sk->sk_data_ready, psock->saved_data_ready);
 	psock->saved_data_ready = NULL;
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 81666571ecfb5..699212cd6c226 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1397,7 +1397,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	err = sk_stream_error(sk, flags, err);
 	/* make sure we wake any epoll edge trigger waiter */
 	if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
-		sk->sk_write_space(sk);
+		READ_ONCE(sk->sk_write_space)(sk);
 		tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED);
 	}
 	if (binding)
@@ -4131,7 +4131,7 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 		break;
 	case TCP_NOTSENT_LOWAT:
 		WRITE_ONCE(tp->notsent_lowat, val);
-		sk->sk_write_space(sk);
+		READ_ONCE(sk->sk_write_space)(sk);
 		break;
 	case TCP_INQ:
 		if (val > 1 || val < 0)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ca8a5cb8e569d..d3d6a47af5270 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -725,7 +725,7 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 			WRITE_ONCE(sk->sk_prot->unhash, psock->saved_unhash);
 			tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
 		} else {
-			sk->sk_write_space = psock->saved_write_space;
+			WRITE_ONCE(sk->sk_write_space, psock->saved_write_space);
 			/* Pairs with lockless read in sk_clone_lock() */
 			sock_replace_proto(sk, psock->sk_proto);
 		}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index aa4f5bf765596..adec44313772b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5167,7 +5167,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
-		sk->sk_data_ready(sk);
+		READ_ONCE(sk->sk_data_ready)(sk);
 		tcp_drop_reason(sk, skb, SKB_DROP_REASON_PROTO_MEM);
 		return;
 	}
@@ -5377,7 +5377,7 @@ int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
 void tcp_data_ready(struct sock *sk)
 {
 	if (tcp_epollin_ready(sk, sk->sk_rcvlowat) || sock_flag(sk, SOCK_DONE))
-		sk->sk_data_ready(sk);
+		READ_ONCE(sk->sk_data_ready)(sk);
 }
 
 static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
@@ -5433,7 +5433,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 			inet_csk(sk)->icsk_ack.pending |=
 					(ICSK_ACK_NOMEM | ICSK_ACK_NOW);
 			inet_csk_schedule_ack(sk);
-			sk->sk_data_ready(sk);
+			READ_ONCE(sk->sk_data_ready)(sk);
 
 			if (skb_queue_len(&sk->sk_receive_queue) && skb->len) {
 				reason = SKB_DROP_REASON_PROTO_MEM;
@@ -5875,7 +5875,9 @@ static void tcp_new_space(struct sock *sk)
 		tp->snd_cwnd_stamp = tcp_jiffies32;
 	}
 
-	INDIRECT_CALL_1(sk->sk_write_space, sk_stream_write_space, sk);
+	INDIRECT_CALL_1(READ_ONCE(sk->sk_write_space),
+			sk_stream_write_space,
+			sk);
 }
 
 /* Caller made space either from:
@@ -6091,7 +6093,7 @@ static void tcp_urg(struct sock *sk, struct sk_buff *skb, const struct tcphdr *t
 				BUG();
 			WRITE_ONCE(tp->urg_data, TCP_URG_VALID | tmp);
 			if (!sock_flag(sk, SOCK_DEAD))
-				sk->sk_data_ready(sk);
+				READ_ONCE(sk->sk_data_ready)(sk);
 		}
 	}
 }
@@ -7557,7 +7559,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 			sock_put(fastopen_sk);
 			goto drop_and_free;
 		}
-		sk->sk_data_ready(sk);
+		READ_ONCE(sk->sk_data_ready)(sk);
 		bh_unlock_sock(fastopen_sk);
 		sock_put(fastopen_sk);
 	} else {
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0742a41687ffc..12f69cc285577 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -988,7 +988,7 @@ enum skb_drop_reason tcp_child_process(struct sock *parent, struct sock *child,
 		reason = tcp_rcv_state_process(child, skb);
 		/* Wakeup parent, send SIGIO */
 		if (state == TCP_SYN_RECV && child->sk_state != state)
-			parent->sk_data_ready(parent);
+			READ_ONCE(parent->sk_data_ready)(parent);
 	} else {
 		/* Alas, it is possible again, because we do lookup
 		 * in main socket hash table and lock on listening
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index ee63af0ef42cc..37258b54a357e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1786,7 +1786,7 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 		 * using prepare_to_wait_exclusive().
 		 */
 		while (nb) {
-			INDIRECT_CALL_1(sk->sk_data_ready,
+			INDIRECT_CALL_1(READ_ONCE(sk->sk_data_ready),
 					sock_def_readable, sk);
 			nb--;
 		}
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 91233e37cd97a..779a3a03762f1 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -158,7 +158,7 @@ int udp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 	int family = sk->sk_family == AF_INET ? UDP_BPF_IPV4 : UDP_BPF_IPV6;
 
 	if (restore) {
-		sk->sk_write_space = psock->saved_write_space;
+		WRITE_ONCE(sk->sk_write_space, psock->saved_write_space);
 		sock_replace_proto(sk, psock->sk_proto);
 		return 0;
 	}
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f6d56e70c7a2c..6965b9a49d68a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1785,7 +1785,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr_unsized *uad
 	__skb_queue_tail(&other->sk_receive_queue, skb);
 	spin_unlock(&other->sk_receive_queue.lock);
 	unix_state_unlock(other);
-	other->sk_data_ready(other);
+	READ_ONCE(other->sk_data_ready)(other);
 	sock_put(other);
 	return 0;
 
@@ -2278,7 +2278,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	scm_stat_add(other, skb);
 	skb_queue_tail(&other->sk_receive_queue, skb);
 	unix_state_unlock(other);
-	other->sk_data_ready(other);
+	READ_ONCE(other->sk_data_ready)(other);
 	sock_put(other);
 	scm_destroy(&scm);
 	return len;
@@ -2351,7 +2351,7 @@ static int queue_oob(struct sock *sk, struct msghdr *msg, struct sock *other,
 
 	sk_send_sigurg(other);
 	unix_state_unlock(other);
-	other->sk_data_ready(other);
+	READ_ONCE(other->sk_data_ready)(other);
 
 	return 0;
 out_unlock:
@@ -2477,7 +2477,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		spin_unlock(&other->sk_receive_queue.lock);
 
 		unix_state_unlock(other);
-		other->sk_data_ready(other);
+		READ_ONCE(other->sk_data_ready)(other);
 		sent += size;
 	}
 
-- 
2.51.0

