Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB064BEE32;
	Sat, 12 Sep 2026 11:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212056; cv=none; b=hoVctrgRBuHRRjpPcUSncZv3R34opYGgNV56HA1jtdIwp4rn8+TghchP+FjC8XMiof/+nu5lowNqxX19Zte6ocT1eKRvOZjZdzZAz5q+0o53JUVj4YzUK50UW7+Ns/ZgYYBEJ+bld0RCNoxp8GsGIu63WHp9E6oHuTfcQllOOsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212056; c=relaxed/simple;
	bh=tU4K+hLn6TFr7AAiFeomXU5LFCZZBLWYJzthuGOeo+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+N7qXh3NPc3ToeBHLawGcb8ynpZRnVYSGPkhonLvCis7F2Yp9qHDgFlLfq+5f0Znwdan+hxoFJXycDJWpmqc71B68HK/T+lRAiK3uo4mDAZyQcmjPREzTcbGedFRxCbQUDNbdPiCTzTRv324deGImoMR0UNyZu1r8ShJrs/tzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTINouz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTINouz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765DE1F00893;
	Sat, 12 Sep 2026 11:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212055;
	bh=9FpQk+w/A2Jtyp7AgdpSqfC0Niw64weR+n6j+CAFs8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTINouz0KlG3CcWa67HfcnVn0rPCfhAG5ktedz70B3BlmZv1qJl7nGisD9G+mnixk
	 Nt3XvWFLD+wkSGzmZPJEkxTYUK9X2JrXNxRAikABAZCks5IOfs3sAryb+z0JDUEVq7
	 4y3LVkAX7yCwgj5T4VPa46B1HoCAoXqaf6jOVkEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1358/1518] net: change sock_queue_rcv_skb_reason() to return a drop_reason
Date: Sat, 12 Sep 2026 08:58:47 +0200
Message-ID: <20260912065654.253055357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 900f27fb797c7eaf0b84b7a6516613e19746bc4e ]

Change sock_queue_rcv_skb_reason() to return the drop_reason directly
instead of using a reference.

This is part of an effort to remove stack canaries and reduce bloat.

$ scripts/bloat-o-meter -t vmlinux.old vmlinux.new
add/remove: 0/0 grow/shrink: 3/7 up/down: 79/-301 (-222)
Function                                     old     new   delta
vsock_queue_rcv_skb                           50      79     +29
ipmr_cache_report                           1290    1315     +25
ip6mr_cache_report                          1322    1347     +25
packet_rcv_spkt                              329     327      -2
sock_queue_rcv_skb_reason                    166     128     -38
raw_rcv_skb                                  122      80     -42
ping_queue_rcv_skb                           109      61     -48
ping_rcv                                     215     162     -53
rawv6_rcv_skb                                278     224     -54
raw_rcv                                      591     527     -64
Total: Before=29722890, After=29722668, chg -0.00%

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260409145625.2306224-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 235b42b58601 ("ip6mr: do not clone dst in ip6mr_cache_report()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h     | 17 ++++++++++++++---
 net/can/bcm.c          |  5 ++---
 net/can/isotp.c        |  3 ++-
 net/can/j1939/socket.c |  3 ++-
 net/can/raw.c          |  3 ++-
 net/core/sock.c        | 20 ++++++--------------
 net/ipv4/ping.c        |  3 ++-
 net/ipv4/raw.c         |  3 ++-
 net/ipv6/raw.c         |  3 ++-
 9 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 9637ee4f55ee1..50b9178cc827f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2468,12 +2468,23 @@ int __sk_queue_drop_skb(struct sock *sk, struct sk_buff_head *sk_queue,
 					   struct sk_buff *skb));
 int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
 
-int sock_queue_rcv_skb_reason(struct sock *sk, struct sk_buff *skb,
-			      enum skb_drop_reason *reason);
+enum skb_drop_reason
+sock_queue_rcv_skb_reason(struct sock *sk, struct sk_buff *skb);
 
 static inline int sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
-	return sock_queue_rcv_skb_reason(sk, skb, NULL);
+	enum skb_drop_reason drop_reason = sock_queue_rcv_skb_reason(sk, skb);
+
+	switch (drop_reason) {
+	case SKB_DROP_REASON_SOCKET_RCVBUFF:
+		return -ENOMEM;
+	case SKB_DROP_REASON_PROTO_MEM:
+		return -ENOBUFS;
+	case 0:
+		return 0;
+	default:
+		return -EPERM;
+	}
 }
 
 int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb);
diff --git a/net/can/bcm.c b/net/can/bcm.c
index a819872fddeff..67d5e3ecc04fb 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -396,7 +396,6 @@ static void bcm_send_to_user(struct bcm_op *op, struct bcm_msg_head *head,
 	struct sockaddr_can *addr;
 	struct sock *sk = op->sk;
 	unsigned int datalen = head->nframes * op->cfsiz;
-	int err;
 	unsigned int *pflags;
 	enum skb_drop_reason reason;
 
@@ -453,8 +452,8 @@ static void bcm_send_to_user(struct bcm_op *op, struct bcm_msg_head *head,
 	addr->can_family  = AF_CAN;
 	addr->can_ifindex = op->rx_ifindex;
 
-	err = sock_queue_rcv_skb_reason(sk, skb, &reason);
-	if (err < 0) {
+	reason = sock_queue_rcv_skb_reason(sk, skb);
+	if (reason) {
 		struct bcm_sock *bo = bcm_sk(sk);
 
 		sk_skb_reason_drop(sk, skb, reason);
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 720b911fe1ede..a77ac3954e410 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -357,7 +357,8 @@ static void isotp_rcv_skb(struct sk_buff *skb, struct sock *sk)
 	addr->can_family = AF_CAN;
 	addr->can_ifindex = skb->dev->ifindex;
 
-	if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0)
+	reason = sock_queue_rcv_skb_reason(sk, skb);
+	if (reason)
 		sk_skb_reason_drop(sk, skb, reason);
 }
 
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index e56d8134938e8..70a57afdef1a2 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -332,7 +332,8 @@ static void j1939_sk_recv_one(struct j1939_sock *jsk, struct sk_buff *oskb)
 	if (skb->sk)
 		skcb->msg_flags |= MSG_DONTROUTE;
 
-	if (sock_queue_rcv_skb_reason(&jsk->sk, skb, &reason) < 0)
+	reason = sock_queue_rcv_skb_reason(&jsk->sk, skb);
+	if (reason)
 		sk_skb_reason_drop(&jsk->sk, skb, reason);
 }
 
diff --git a/net/can/raw.c b/net/can/raw.c
index c397071bfa8b9..dc02defa560d6 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -206,7 +206,8 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 	if (oskb->sk == sk)
 		*pflags |= MSG_CONFIRM;
 
-	if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0)
+	reason = sock_queue_rcv_skb_reason(sk, skb);
+	if (reason)
 		sk_skb_reason_drop(sk, skb, reason);
 }
 
diff --git a/net/core/sock.c b/net/core/sock.c
index b69c574c20ad3..1b64ac35073db 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -520,32 +520,24 @@ int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(__sock_queue_rcv_skb);
 
-int sock_queue_rcv_skb_reason(struct sock *sk, struct sk_buff *skb,
-			      enum skb_drop_reason *reason)
+enum skb_drop_reason
+sock_queue_rcv_skb_reason(struct sock *sk, struct sk_buff *skb)
 {
 	enum skb_drop_reason drop_reason;
 	int err;
 
 	err = sk_filter_reason(sk, skb, &drop_reason);
 	if (err)
-		goto out;
+		return drop_reason;
 
 	err = __sock_queue_rcv_skb(sk, skb);
 	switch (err) {
 	case -ENOMEM:
-		drop_reason = SKB_DROP_REASON_SOCKET_RCVBUFF;
-		break;
+		return SKB_DROP_REASON_SOCKET_RCVBUFF;
 	case -ENOBUFS:
-		drop_reason = SKB_DROP_REASON_PROTO_MEM;
-		break;
-	default:
-		drop_reason = SKB_NOT_DROPPED_YET;
-		break;
+		return SKB_DROP_REASON_PROTO_MEM;
 	}
-out:
-	if (reason)
-		*reason = drop_reason;
-	return err;
+	return SKB_NOT_DROPPED_YET;
 }
 EXPORT_SYMBOL(sock_queue_rcv_skb_reason);
 
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 7f32753a16f41..21ced929cc9c1 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -944,7 +944,8 @@ static enum skb_drop_reason __ping_queue_rcv_skb(struct sock *sk,
 
 	pr_debug("ping_queue_rcv_skb(sk=%p,sk->num=%d,skb=%p)\n",
 		 inet_sk(sk), inet_sk(sk)->inet_num, skb);
-	if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
+	reason = sock_queue_rcv_skb_reason(sk, skb);
+	if (reason) {
 		sk_skb_reason_drop(sk, skb, reason);
 		pr_debug("ping_queue_rcv_skb -> failed\n");
 		return reason;
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index c10cf41a365dc..5735ae7cba01a 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -308,7 +308,8 @@ static int raw_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	/* Charge it to the socket. */
 
 	ipv4_pktinfo_prepare(sk, skb, true);
-	if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
+	reason = sock_queue_rcv_skb_reason(sk, skb);
+	if (reason) {
 		sk_skb_reason_drop(sk, skb, reason);
 		return NET_RX_DROP;
 	}
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 6cb8e32a3061f..b796d84db5ce2 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -368,7 +368,8 @@ static inline int rawv6_rcv_skb(struct sock *sk, struct sk_buff *skb)
 
 	/* Charge it to the socket. */
 	skb_dst_drop(skb);
-	if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
+	reason = sock_queue_rcv_skb_reason(sk, skb);
+	if (reason) {
 		sk_skb_reason_drop(sk, skb, reason);
 		return NET_RX_DROP;
 	}
-- 
2.53.0



