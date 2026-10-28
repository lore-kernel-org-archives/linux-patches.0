Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209631;
	b=avrerNPDIh+BMnCkt1T4KGY52QxOk4kxQPcU7xrR0dD3pl3fBOH574LCml3uRbUAz0rc
	 Dt7CUnWvV+07naZOGqxJENQGKvZ9rR21v+4o4H9trsXiaR/Qrr4S4lw7ZVNOWpwDcjpu4
	 E5PgxRb5VCFiCwszS0V0lyDh2huoBEiq9+8g1j8HchiwhxtMMoyXTB+1d+hluAz6LX5pE
	 ACSYdZyXxDW0H66fyG8wZaXQTCnHmTjcgggT9HLYVGXgQj+rOLtC+rlJGw+50a/gQ+rfY
	 ce1mTG7keFY8zFuOrp7r113wXcxRNndFx2GnK0cJx6s2kFacqSF1kOINP9ECE5QoGiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Zp8eqvIqq3Al+wnSqu939tHKbvY+XN3Ej0r23WAb8s=;
	b=3llnJqaDElnK/d9AoEzLhpjGhFf2xZ9nFuSCaR9X0Ljy//7+lSI90Idh/8QXb9nvA4EX
	 3KH3WGKhMiMvITKt03np6+DQodqM8c+YYsWlWjKQl3y3Jo8HH1N9dsUhrD6TrIlb3w8Lv
	 dgBu+hQWW8NHcY/yf8i6SiS7h5Rk0LUsBoNDW76LZ++t1kA5VhKS9z6v47mEe2BWJpvJj
	 gdyLuwHKfUYlY5AkrRLXKFsOXUejyX8oKQHZGbBjokJgL3WpedHqd0J3w75Mn/D4Neffd
	 NosyTIND+wemsoa7eEY4+fHZFEgEdIbu5q4Pku0z9WObH//QrVpgwL4sup2N/OwOEhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mvERXhiR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67670606A31C;
	Wed, 28 Oct 2026 17:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mvERXhiR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87BE1F01828;
	Wed, 28 Oct 2026 17:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209631;
	bh=+Zp8eqvIqq3Al+wnSqu939tHKbvY+XN3Ej0r23WAb8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvERXhiRn5spsO/IfmIstsv/9o/awEMOT81rRtjGIhOSDuo1t0pprvb2EQZXu/TTf
	 c31hePFbSd3QYPkyQa2WEKKvxZKiMk1Ezjxx1rhwhNR8ZzLrGH2iF9P1x4BBj514ZI
	 Fa9xC6nLazep1SRIKKGFmDhaGcVyBVBkey21IzPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/109] ax25: dont create two connections for the same link in ax25_send_frame()
Date: Wed, 28 Oct 2026 18:00:06 +0100
Message-ID: <20261028165942.888351509@linuxfoundation.org>
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

ax25_send_frame() looks for an existing connection with ax25_find_cb()
and, when there is none, creates one and adds it to the list. The
lookup and the insertion are not done under the same lock, so two
callers sending to a neighbour at the same time both find nothing and
both create a control block: the same link ends up with several
connections, each sending its own SABM, and the frames queued on the
ones that lose are never delivered.

ROSE and NET/ROM call ax25_send_frame() for every frame they send to a
neighbour, from process context and from softirq context, so this
happens as soon as several circuits start together on a link that is
not established yet.

Add ax25_cb_add_unique(), which searches the list and inserts the new
control block under ax25_list_lock, and returns the existing connection
when another sender got there first; ax25_send_frame() then drops its
own control block and queues the frame on that connection. The SABM is
only sent once the control block is known to be the one in the list.

Tested in QEMU, two 4-CPU nodes with lockdep and KASAN over a KISS
serial link, eight ROSE calls started at the same instant with no AX.25
connection up: before, /proc/net/ax25 shows four connections for the
same pair of callsigns on three runs out of three; after, one. No
lockdep, KASAN or refcount report.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 2649f91b6dd2c48348975d03e8f94d8e6a09cf71)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ax25.h  |  1 +
 net/ax25/af_ax25.c  | 49 ++++++++++++++++++++++++++++++++++++++-------
 net/ax25/ax25_out.c | 16 ++++++++++++---
 3 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 0fe92fa6ef075..e3c10a9395944 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -311,6 +311,7 @@ static inline __be16 ax25_type_trans(struct sk_buff *skb, struct net_device *dev
 extern struct hlist_head ax25_list;
 extern spinlock_t ax25_list_lock;
 void ax25_cb_add(ax25_cb *);
+ax25_cb *ax25_cb_add_unique(ax25_cb *ax25);
 struct sock *ax25_find_listener(ax25_address *, int, struct net_device *, int);
 struct sock *ax25_get_socket(ax25_address *, ax25_address *, int);
 ax25_cb *ax25_find_cb(const ax25_address *, ax25_address *, ax25_digi *,
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index d76fe0cbc57b3..28b7a89afaf6e 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -222,12 +222,12 @@ struct sock *ax25_get_socket(ax25_address *my_addr, ax25_address *dest_addr,
  *	Find an AX.25 control block given both ends. It will only pick up
  *	floating AX.25 control blocks or non Raw socket bound control blocks.
  */
-ax25_cb *ax25_find_cb(const ax25_address *src_addr, ax25_address *dest_addr,
-	ax25_digi *digi, struct net_device *dev)
+static ax25_cb *__ax25_find_cb(const ax25_address *src_addr,
+			       ax25_address *dest_addr, ax25_digi *digi,
+			       struct net_device *dev)
 {
 	ax25_cb *s;
 
-	spin_lock_bh(&ax25_list_lock);
 	ax25_for_each(s, &ax25_list) {
 		if (s->sk && s->sk->sk_type != SOCK_SEQPACKET)
 			continue;
@@ -243,19 +243,54 @@ ax25_cb *ax25_find_cb(const ax25_address *src_addr, ax25_address *dest_addr,
 				if (s->digipeat != NULL && s->digipeat->ndigi != 0)
 					continue;
 			}
-			ax25_cb_hold(s);
-			spin_unlock_bh(&ax25_list_lock);
-
 			return s;
 		}
 	}
-	spin_unlock_bh(&ax25_list_lock);
 
 	return NULL;
 }
 
+ax25_cb *ax25_find_cb(const ax25_address *src_addr, ax25_address *dest_addr,
+		      ax25_digi *digi, struct net_device *dev)
+{
+	ax25_cb *s;
+
+	spin_lock_bh(&ax25_list_lock);
+	s = __ax25_find_cb(src_addr, dest_addr, digi, dev);
+	if (s)
+		ax25_cb_hold(s);
+	spin_unlock_bh(&ax25_list_lock);
+
+	return s;
+}
+
 EXPORT_SYMBOL(ax25_find_cb);
 
+/*
+ *	Add a new connection to the list unless one already exists for the
+ *	same addresses, path and device. Returns NULL when the control block
+ *	has been added, or the existing one, held, when there is one: looking
+ *	it up and adding it are done under the same lock, so that two senders
+ *	cannot both create a connection for the same link.
+ */
+ax25_cb *ax25_cb_add_unique(ax25_cb *ax25)
+{
+	ax25_cb *s;
+
+	spin_lock_bh(&ax25_list_lock);
+	s = __ax25_find_cb(&ax25->source_addr, &ax25->dest_addr,
+			   ax25->digipeat, ax25->ax25_dev->dev);
+	if (s) {
+		ax25_cb_hold(s);
+	} else {
+		ax25_cb_hold(ax25);
+		hlist_add_head(&ax25->ax25_node, &ax25_list);
+	}
+	spin_unlock_bh(&ax25_list_lock);
+
+	return s;
+}
+
 void ax25_send_to_raw(ax25_address *addr, struct sk_buff *skb, int proto)
 {
 	ax25_cb *s;
diff --git a/net/ax25/ax25_out.c b/net/ax25/ax25_out.c
index 1b9a91b9c9831..eeb2aa1e2186f 100644
--- a/net/ax25/ax25_out.c
+++ b/net/ax25/ax25_out.c
@@ -32,7 +32,7 @@ static DEFINE_SPINLOCK(ax25_frag_lock);
 ax25_cb *ax25_send_frame(struct sk_buff *skb, int paclen, const ax25_address *src, ax25_address *dest, ax25_digi *digi, struct net_device *dev)
 {
 	ax25_dev *ax25_dev;
-	ax25_cb *ax25;
+	ax25_cb *ax25, *existing;
 
 	/*
 	 * Take the default packet length for the device if zero is
@@ -82,6 +82,18 @@ ax25_cb *ax25_send_frame(struct sk_buff *skb, int paclen, const ax25_address *sr
 		}
 	}
 
+	/*
+	 * Another sender may have created the connection since the lookup
+	 * above: the list is searched again and the new control block added
+	 * under one lock. If we lost, use the other one.
+	 */
+	existing = ax25_cb_add_unique(ax25);
+	if (existing) {
+		ax25_cb_put(ax25);
+		ax25_output(existing, paclen, skb);
+		return existing;
+	}
+
 	switch (ax25->ax25_dev->values[AX25_VALUES_PROTOCOL]) {
 	case AX25_PROTO_STD_SIMPLEX:
 	case AX25_PROTO_STD_DUPLEX:
@@ -104,8 +116,6 @@ ax25_cb *ax25_send_frame(struct sk_buff *skb, int paclen, const ax25_address *sr
 	 */
 	ax25_cb_hold(ax25);
 
-	ax25_cb_add(ax25);
-
 	ax25->state = AX25_STATE_1;
 
 	ax25_start_heartbeat(ax25);
-- 
2.53.0



