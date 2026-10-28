Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207886;
	b=cM0IeNLLDL0yQeelbtKGYQbswrLIno/KrM1hgH/l2G2EDUTGYE6reHxGSko+3tfyFTBG
	 uWaacEZCFePMke4GMOVXyMHFMEfTcLzg/DmBmJQemWTdhyoTCom7pEQN+IEE6m5mBNJwJ
	 6CieME2WSDdSaf5o9OzPCuifigFbDVT8YgqQHrI4XxjhKbJgXnCuoxFehBG9HPOC4Eyo9
	 jrz2yFZw71ym8v+oxOBDqMy9GEKrw0bfdn4w7/Bf7jq/B0evuYNaJyzoxoz8hqazQIpf0
	 IYuHIQTHFFNEn2Aems6eFvqnT6XjphCgQyMKeomtYU55oftohWkGDW9C1hGnMr/hjlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ru0ZaIFd7o8EzSqTDOkTcuvZvGNAsu3l+irm9fJ7x3k=;
	b=kdJcOi142E+TcuGqLLZyaQa/EfTBLmgyPOU73D3sN+NBXNCvYp1ZfFHMAZ8rFSh2twqC
	 t3dHrSE0YpqJ3nAsxBQbgxvT+4vZ9ShXFMp7GLu9eLYbiputjoaRm1dg8ofsG+cu+d3/l
	 C1FruJnDds2Sq2usPd5mhiAPm1E/+qSSjsk+RTcNuHsCCp53D0DgeCgm08Evc9jaH87B5
	 O7ls+4fRD0lPsj0hf8XAVl4cWCi1WK2vhk6EYCV/HX9IjgNfHlsTeh/lxja93DAyoWNer
	 /ck9iWTxPmpp14cDm0zRgG6GVe45PY8t05X5IFVHoiinomyXpTDzBQFRzyio8jC72jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cgbEMYYs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1C5606A334;
	Wed, 28 Oct 2026 17:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cgbEMYYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDC21F01828;
	Wed, 28 Oct 2026 17:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207886;
	bh=ru0ZaIFd7o8EzSqTDOkTcuvZvGNAsu3l+irm9fJ7x3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cgbEMYYsjRoih5v1JADrH+pcu4m+iIssRCEVOcwbydD+rA2/eX5ptU1oekzkm0/l1
	 OwTgEa+Gfri7c5Bb8z7iO4RRDVGcPUI4zOdXIgZHVm/ArTdxsIOWCDuhA7ZCKNDa7n
	 IP4vXcuaxDmPNITOD99sTsQZ0lX7XONJGtBwFi+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 172/247] rose: process received frames and send with the socket locked
Date: Wed, 28 Oct 2026 17:59:35 +0100
Message-ID: <20261028165951.494631056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

rose_kick() takes frames off the write queue, numbers them from V(S)
and moves them to the ack queue. It runs from rose_sendmsg() in process
context and from rose_process_rx_frame() in softirq context, and neither
holds the socket lock. When a frame for the socket is received on one
CPU while a process is sending on another, both read the same V(S) and
two different frames go out under the same N(S), or the queues and
V(S)/V(A) are updated by one while the other walks them. The peer drops
the frames it sees as out of sequence, and since ROSE has no REJ and no
retransmission in state 3 the data is lost for good: messages go
missing from the stream, or the window fills and the circuit freezes.

The timers already take the socket lock and retry when a process owns
it. Do the same for the two remaining paths: rose_sendmsg() calls
rose_kick() under lock_sock(), and received frames go through
rose_rcv_frame(), which takes bh_lock_sock() and queues the frame on the
socket backlog when a process owns the socket, as NET/ROM and X.25 do.

Tested in QEMU, two 4-CPU nodes with lockdep and KASAN over a KISS
serial link, four ROSE circuits each sending 400 numbered messages at
the same time (together with the AX.25 fix "ax25: serialise the
transmission of I frames on a connection", without which the same
happens one layer down): before, 60 to 90 of the 1600 messages are
missing from the streams; after, 1600/1600 delivered in order on six
runs out of six. No lockdep, KASAN or refcount report.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 831b23b977e1fdf14e51dd9652fd27f30965ecb0)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rose.h       |  2 ++
 net/rose/af_rose.c       |  5 +++++
 net/rose/rose_in.c       | 31 +++++++++++++++++++++++++++++++
 net/rose/rose_loopback.c |  2 +-
 net/rose/rose_route.c    |  2 +-
 5 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/net/rose.h b/include/net/rose.h
index f5b23c8a11e4d..6ce065480a4e6 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -227,6 +227,8 @@ void rose_setup(struct net_device *);
 
 /* rose_in.c */
 int rose_process_rx_frame(struct sock *, struct sk_buff *);
+int rose_rcv_frame(struct sock *sk, struct sk_buff *skb);
+int rose_backlog_rcv(struct sock *sk, struct sk_buff *skb);
 
 /* rose_link.c */
 void rose_start_ftimer(struct rose_neigh *);
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 420408a5ad61c..d8a86006c7448 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -598,6 +598,7 @@ static int rose_create(struct net *net, struct socket *sock, int protocol,
 	rose = rose_sk(sk);
 
 	sock_init_data(sock, sk);
+	sk->sk_backlog_rcv = rose_backlog_rcv;
 
 	skb_queue_head_init(&rose->ack_queue);
 #ifdef M_BIT
@@ -637,6 +638,7 @@ static struct sock *rose_make_new(struct sock *osk)
 	rose = rose_sk(sk);
 
 	sock_init_data(NULL, sk);
+	sk->sk_backlog_rcv = rose_backlog_rcv;
 
 	skb_queue_head_init(&rose->ack_queue);
 #ifdef M_BIT
@@ -1326,7 +1328,10 @@ static int rose_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	skb_queue_tail(&sk->sk_write_queue, skb);	/* Shove it onto the queue */
 #endif
 
+	/* The receive path and the timers run rose_kick() too */
+	lock_sock(sk);
 	rose_kick(sk);
+	release_sock(sk);
 
 	return len;
 }
diff --git a/net/rose/rose_in.c b/net/rose/rose_in.c
index 69b2af24e85a6..7a556254ee790 100644
--- a/net/rose/rose_in.c
+++ b/net/rose/rose_in.c
@@ -309,3 +309,34 @@ int rose_process_rx_frame(struct sock *sk, struct sk_buff *skb)
 
 	return queued;
 }
+
+/*
+ * Frames for a socket are processed with the socket locked, as the timers
+ * already do: rose_kick() may be running in rose_sendmsg() on another CPU,
+ * and two of them reading the same V(S) send two different frames under the
+ * same N(S). If a process owns the socket the frame goes to its backlog and
+ * is processed when the socket is released. Returns non-zero if the skb has
+ * been consumed.
+ */
+int rose_rcv_frame(struct sock *sk, struct sk_buff *skb)
+{
+	int queued;
+
+	bh_lock_sock(sk);
+	if (!sock_owned_by_user(sk))
+		queued = rose_process_rx_frame(sk, skb);
+	else
+		queued = !sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf) +
+						  READ_ONCE(sk->sk_sndbuf));
+	bh_unlock_sock(sk);
+
+	return queued;
+}
+
+int rose_backlog_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	if (!rose_process_rx_frame(sk, skb))
+		kfree_skb(skb);
+
+	return 0;
+}
diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
index fd4e4795776a3..4e4a473910cc8 100644
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -107,7 +107,7 @@ static void rose_loopback_timer(struct timer_list *unused)
 
 		sk = rose_find_socket(lci_o, rose_loopback_neigh);
 		if (sk) {
-			if (rose_process_rx_frame(sk, skb) == 0)
+			if (rose_rcv_frame(sk, skb) == 0)
 				kfree_skb(skb);
 			continue;
 		}
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 7ae3552c19267..883b204121566 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -1017,7 +1017,7 @@ int rose_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 		}
 		else {
 			skb_reset_transport_header(skb);
-			res = rose_process_rx_frame(sk, skb);
+			res = rose_rcv_frame(sk, skb);
 			goto out;
 		}
 	}
-- 
2.53.0



