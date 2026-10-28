Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208035;
	b=dZFQBStCR9PQI+kLAIx+cLvJEcI3NS+TnRF+pyhVs09AFQnqhaI/4q5NzNwcOMRCY3B6
	 QBakAXcuUFrycGD2SNGWOV5PNPpvUZtVpZiQcIXfsY2yPq+i+loryES+5MCrnmdYuyWHk
	 IbK5597vGfb4LmWeFbB25yft2zqLpG9BAKr/trvcCVG2mBK0WuP8+dh4S4QmVZRRLb6Y6
	 pEfy3UobvW+7A2ciiuv6y/5rbHCwuKzx5TAMDZy/Io2NvT7Xp/nBtERLAeZYCbI4kiolN
	 qNKbZft1u3MHo3ymwFeKzFwDVfulBQfubUsy7gaRgyurceSlkYQnB5LmncJaEte8WMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fCDdpZZIEhUs/N9meLjaeoB/LZ0RW7NgmjKsWH4zYdg=;
	b=FOqDnjDQxI7BMNiinMar9kkZ1ViwkVdSmomFI8wak5gSQGfufd0bUAwCvIotwkQ4SAKs
	 Gkf+MfCsbdMZGsA0pWt+2Xvb6tHo8C1S1aW8aSAnA5pXWC7OW5rSPFQY8u+ohTihwGAMv
	 zpOf2tcmGA+FEQPMo7SWQXD9y0j8nnlzI6lWOn2CUhceB6l/NPJCjkRyoq5uROAVKj9He
	 w8DWFYYzznWQpW0oK9lG4qGz+AUcfJYaXokZj6Qv83OUp1ZpebwX+2B0mcSU/fcnDjeBj
	 CvyaNgNX3u66rfebDS432X55LlvYJzCJPAn6cdVxjjBXulHLhIgFhEL2qs9EeNcSafg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iv3gAGzb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000C8606A31C;
	Wed, 28 Oct 2026 17:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iv3gAGzb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7A11F01825;
	Wed, 28 Oct 2026 17:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208034;
	bh=fCDdpZZIEhUs/N9meLjaeoB/LZ0RW7NgmjKsWH4zYdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iv3gAGzb3vDY2CoeVhVsqAZl8t6dX7wMCG+/i/ATVzZvtI9UURyGRmDoDQCiAA9ul
	 E2H5FbJuZiDENySNtTN6WfHdPhhX5/+Vmt++jAmiK3rH3fd0lUd8Qr+3+NaT96PYq2
	 pO8BrsMJ+Xjwc2XKn8E0IEIsifm3koZcs/FrBkq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/247] ax25: dont create two connections for the same link in ax25_send_frame()
Date: Wed, 28 Oct 2026 17:59:36 +0100
Message-ID: <20261028165951.518797486@linuxfoundation.org>
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
index 164e9f46f0e77..9f7bda3b511e3 100644
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



