Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8793557F3;
	Fri,  7 Aug 2026 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114642; cv=none; b=SENuk5kaQw5pL81EO3oS2xepmiIF76+U0vuWsbsFxiIDXqsGL74lizza/FhhIglVacCfnAtm00VzAPnd8GpKQ7tqwLy9XXr79JXfvD6tS0XaAvH4/fNlHTLFp2F/KH4ZYagq1Ivnd3Mf5DnJhDAexBdJSBdogubHrA1gCQgJfbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114642; c=relaxed/simple;
	bh=txYgJr6suTCZ8beOSuYgPApQ6lSqs5nuPQZryIjJq50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALTx+1KRidVcEATa1LyGCGnh9qr2G2f7X3bAS4IdMwZo++Uk8b+NwKaeENogNBGLBXeDNq/S/rsVVti1cfREWkKG0ULd1XmM+hazMOdJ8olm7nX8C8vEA6kLs5c4/vP3Vu3rN/Vu7tXiCwmPE/cJXg44Dt9MXbmh+xO6hs+0mHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saqXsCte; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saqXsCte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B931F000E9;
	Fri,  7 Aug 2026 14:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114636;
	bh=h6fp8tRJly0AddQDjbTHB56tguGoyEv+TI/NJbZZ5Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=saqXsCteX0BFeVaHnfCbZeykbVAQ8rmh483MJQfYgoo/NAd6irs7LvdO33YxJKzpR
	 TjcT4GHaWZjjAapuJCwy15Nffi03dCnDPbi4wv74DrpJI7o2/HUgBBAyNi6khSr9QG
	 /3yrez6LLsa1r5t/xcYg0eiT+qHTOhkDLO15jvGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 333/337] can: use skb hash instead of private variable in headroom
Date: Fri,  7 Aug 2026 16:38:56 +0200
Message-ID: <20260807143425.759326450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit d4fb6514ff8ed6912a71294e6b66a5d59ee88007 upstream.

The can_skb_priv::skbcnt variable is used to identify CAN skbs in the RX
path analogue to the skb->hash.

As the skb hash is not filled in CAN skbs move the private skbcnt value to
skb->hash and set skb->sw_hash accordingly. The skb->hash is a value used
for RPS to identify skbs. Use it as intended.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260201-can_skb_ext-v8-1-3635d790fe8b@hartkopp.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/dev/skb.c |    2 --
 include/linux/can/core.h  |    1 +
 include/linux/can/skb.h   |    2 --
 net/can/af_can.c          |   14 +++++++++++---
 net/can/bcm.c             |    2 --
 net/can/isotp.c           |    3 ---
 net/can/j1939/socket.c    |    1 -
 net/can/j1939/transport.c |    2 --
 net/can/raw.c             |    7 +++----
 9 files changed, 15 insertions(+), 19 deletions(-)

--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -202,7 +202,6 @@ static void init_can_skb_reserve(struct
 	skb_reset_transport_header(skb);
 
 	can_skb_reserve(skb);
-	can_skb_prv(skb)->skbcnt = 0;
 }
 
 struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf)
@@ -312,7 +311,6 @@ static bool can_skb_headroom_valid(struc
 	if (skb->ip_summed == CHECKSUM_NONE) {
 		/* init headroom */
 		can_skb_prv(skb)->ifindex = dev->ifindex;
-		can_skb_prv(skb)->skbcnt = 0;
 
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
--- a/include/linux/can/core.h
+++ b/include/linux/can/core.h
@@ -58,6 +58,7 @@ extern void can_rx_unregister(struct net
 			      void *data);
 
 extern int can_send(struct sk_buff *skb, int loop);
+void can_set_skb_uid(struct sk_buff *skb);
 void can_sock_destruct(struct sock *sk);
 
 #endif /* !_CAN_CORE_H */
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -49,13 +49,11 @@ bool can_dropped_invalid_skb(struct net_
 /**
  * struct can_skb_priv - private additional data inside CAN sk_buffs
  * @ifindex:	ifindex of the first interface the CAN frame appeared on
- * @skbcnt:	atomic counter to have an unique id together with skb pointer
  * @frame_len:	length of CAN frame in data link layer
  * @cf:		align to the following CAN frame at skb->data
  */
 struct can_skb_priv {
 	int ifindex;
-	int skbcnt;
 	unsigned int frame_len;
 	struct can_frame cf[];
 };
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -639,6 +639,16 @@ static int can_rcv_filter(struct can_dev
 	return matches;
 }
 
+void can_set_skb_uid(struct sk_buff *skb)
+{
+	/* create non-zero unique skb identifier together with *skb */
+	while (!(skb->hash))
+		skb->hash = atomic_inc_return(&skbcounter);
+
+	skb->sw_hash = 1;
+}
+EXPORT_SYMBOL(can_set_skb_uid);
+
 static void can_receive(struct sk_buff *skb, struct net_device *dev)
 {
 	struct can_dev_rcv_lists *dev_rcv_lists;
@@ -650,9 +660,7 @@ static void can_receive(struct sk_buff *
 	atomic_long_inc(&pkg_stats->rx_frames);
 	atomic_long_inc(&pkg_stats->rx_frames_delta);
 
-	/* create non-zero unique skb identifier together with *skb */
-	while (!(can_skb_prv(skb)->skbcnt))
-		can_skb_prv(skb)->skbcnt = atomic_inc_return(&skbcounter);
+	can_set_skb_uid(skb);
 
 	rcu_read_lock();
 
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -350,7 +350,6 @@ static void bcm_can_tx(struct bcm_op *op
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	skb_put_data(skb, cf, op->cfsiz);
 
@@ -1624,7 +1623,6 @@ static int bcm_tx_send(struct msghdr *ms
 	}
 
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 	skb->dev = dev;
 	can_skb_set_owner(skb, sk);
 	err = can_send(skb, 1); /* send with loopback */
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -232,7 +232,6 @@ static int isotp_send_fc(struct sock *sk
 
 	can_skb_reserve(nskb);
 	can_skb_prv(nskb)->ifindex = dev->ifindex;
-	can_skb_prv(nskb)->skbcnt = 0;
 
 	nskb->dev = dev;
 	can_skb_set_owner(nskb, sk);
@@ -798,7 +797,6 @@ static void isotp_send_cframe(struct iso
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	cf = (struct canfd_frame *)skb->data;
 	skb_put_zero(skb, so->ll.mtu);
@@ -1104,7 +1102,6 @@ static int isotp_sendmsg(struct socket *
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	so->tx.len = size;
 	so->tx.idx = 0;
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -889,7 +889,6 @@ static struct sk_buff *j1939_sk_alloc_sk
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = ndev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 	skb_reserve(skb, offsetof(struct can_frame, data));
 
 	ret = memcpy_from_msg(skb_put(skb, size), msg, size);
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -613,7 +613,6 @@ sk_buff *j1939_tp_tx_dat_new(struct j193
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 	/* reserve CAN header */
 	skb_reserve(skb, offsetof(struct can_frame, data));
 
@@ -1553,7 +1552,6 @@ j1939_session *j1939_session_fresh_new(s
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 	skcb = j1939_skb_to_cb(skb);
 	memcpy(skcb, rel_skcb, sizeof(*skcb));
 
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -75,8 +75,8 @@ MODULE_ALIAS("can-proto-1");
  */
 
 struct uniqframe {
-	int skbcnt;
 	const struct sk_buff *skb;
+	u32 hash;
 	unsigned int join_rx_count;
 };
 
@@ -163,7 +163,7 @@ static void raw_rcv(struct sk_buff *oskb
 
 	/* eliminate multiple filter matches for the same skb */
 	if (this_cpu_ptr(ro->uniq)->skb == oskb &&
-	    this_cpu_ptr(ro->uniq)->skbcnt == can_skb_prv(oskb)->skbcnt) {
+	    this_cpu_ptr(ro->uniq)->hash == oskb->hash) {
 		if (!ro->join_filters)
 			return;
 
@@ -173,7 +173,7 @@ static void raw_rcv(struct sk_buff *oskb
 			return;
 	} else {
 		this_cpu_ptr(ro->uniq)->skb = oskb;
-		this_cpu_ptr(ro->uniq)->skbcnt = can_skb_prv(oskb)->skbcnt;
+		this_cpu_ptr(ro->uniq)->hash = oskb->hash;
 		this_cpu_ptr(ro->uniq)->join_rx_count = 1;
 		/* drop first frame to check all enabled filters? */
 		if (ro->join_filters && ro->count > 1)
@@ -945,7 +945,6 @@ static int raw_sendmsg(struct socket *so
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	/* fill the skb before testing for valid CAN frames */
 	err = memcpy_from_msg(skb_put(skb, size), msg, size);


