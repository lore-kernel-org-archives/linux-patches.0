Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209628;
	b=aPH/lTPMIDl3XdaiLlDv5d9QwWoinBxnIEQsP3Cs9WT48PXsrOV3YiqZ6v5USn2tmRO7
	 8t5s5emqFShJ4ZHAbwxtGCbBi4VHn6z+EHumI/ZYjeiwhfiKD1dV4hCO+JwL/dxa/doe9
	 /FFUPfAtT8hFwl/Y6r+zwPq/+zIqqrw5D0w1wFbj8cSXeWBwSZ1BMpBN4AroMdht14+M2
	 +Rbohb2JsF4vucQSx3ILO7eJ63PqkWWkL93uKXMwIcIj0KFHM2b0NuSYWbZ2S5eNUUZat
	 V4Xav8eFm1nmmLOBJPLKc4DsPfwtrUMeIJ8gkqo7ZEdXz7pk7GoWtPceStVoQRvoEKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kKR2e+FecvE1q0ekjcAqZ3XomuR5dHAV+GZubEhTZe0=;
	b=ANYNhjJaXL9mikBfoixNJVX7/0fs/SV8Dr6erjA/osWeKgRHUwNq2ikAHOKOGxKJnIfA
	 yWMP8sxDj0/QqdnEiZcA1mZvHedKLN1kpH+H5z6NBEVokQYE7lHxICeDSKlmsPILPMDt2
	 BkHjzr/AHjEdxgggJC9TmwrdAib0fKUMFpq6VpvL510rOPzYfogO8Qxdjo39DJQDSDQ4k
	 JgS795pChDtvhW4C+6TdiZBfbEVWF1syg3VQxwixjMntknsuajsGRSNy+R3KWFxS0Lum7
	 UjdHf2WGQxVDBKxGCK3eXBFYs8LLxpZD4t3Gl1wjHO57Lp5RsO+iFWFCOo674puHa1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=APUu1fuI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3F0606A31A;
	Wed, 28 Oct 2026 17:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=APUu1fuI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0251F01828;
	Wed, 28 Oct 2026 17:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209628;
	bh=kKR2e+FecvE1q0ekjcAqZ3XomuR5dHAV+GZubEhTZe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APUu1fuIdss99GKYv8tCmwo5rb8u+vekh+bBtmdI3XSQZ45IoIxb3vRj1NU5N82qN
	 eCR4rvU8L2Hk99UN/JRh2pKxUyI6etAi1w7H3A/15YScnMNcs7On7AG6lkTIGJuelF
	 x9WrljkzGd/sH1lvfMOUnqxRKxNdlMobd2RvM6xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/109] rose: process received frames and send with the socket locked
Date: Wed, 28 Oct 2026 18:00:05 +0100
Message-ID: <20261028165942.864846381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 48b82fe3bee18..4fca64156640e 100644
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
index ac20f318008d4..4eec54b24afb0 100644
--- a/net/rose/rose_in.c
+++ b/net/rose/rose_in.c
@@ -310,3 +310,34 @@ int rose_process_rx_frame(struct sock *sk, struct sk_buff *skb)
 
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



