Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9548286415;
	Tue, 25 Aug 2026 14:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666475; cv=none; b=rHN9KjRXiUi93KIeyycd9puiVneqloCjdEPsuJinDQKttiNDZGOqzEmCGxSt7XzZ/lRphKMCe9wi0136UyVeKmBMdcAcEOf1P9Sz0uJ96gu2j6GViTTbEXNg1q4uALavsHGhXXj0E+/jJVbjgFklDcWK/MYV8dpC9ez+K8wPiEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666475; c=relaxed/simple;
	bh=1Ul27ofsWbeH6A2bFk80bjEaA0NJQvdcSWbIDH94w5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFEbUGq9RPL+JDD5JSr/EYb8IqtkTLxzUofZhpnHhxOps0yPD2yjctg28hH9cPl78A6CNN/H1VxetLf1dmmc8+Saz3+PpsLo2yI0LSU5gwSlijM3fbH4TFefojLsEHq7z3693hDO3WfoLF/TYAMzMjhuJQlaBFA6aMuIHSO309M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZRRnw4J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZRRnw4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16631F000E9;
	Tue, 25 Aug 2026 14:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666473;
	bh=tdI9dPcEX+YYPPxER8b44XtQ7xEX3lY4Txl7ZAbLz0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZRRnw4J/+dYs0v/bb8+vk8q0nzXfzCbw/jb/aoeJMuLLgrleRPUIm9cuwjvgzc7r
	 eYGz5Yk25m47/Pxa7jjkGOo405O0Syqq/i51lRDaRqZVqfacX56d4QMwOKdJE78D2T
	 irBU2XHflsj/gGvb4hKVuYg9t+0OpoX+7dsnjpXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 53/57] can: use skb hash instead of private variable in headroom
Date: Tue, 25 Aug 2026 15:27:15 +0200
Message-ID: <20260825132543.414661213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/can/dev/dev.c |    2 --
 drivers/net/can/slcan.c   |    1 -
 include/linux/can/core.h  |    1 +
 include/linux/can/dev.h   |    1 -
 include/linux/can/skb.h   |    2 --
 net/can/af_can.c          |   14 +++++++++++---
 net/can/bcm.c             |    2 --
 net/can/isotp.c           |    3 ---
 net/can/j1939/socket.c    |    1 -
 net/can/j1939/transport.c |    2 --
 net/can/raw.c             |    7 +++----
 11 files changed, 15 insertions(+), 21 deletions(-)

--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -694,7 +694,6 @@ struct sk_buff *alloc_can_skb(struct net
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	*cf = skb_put_zero(skb, sizeof(struct can_frame));
 
@@ -722,7 +721,6 @@ struct sk_buff *alloc_canfd_skb(struct n
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	*cfd = skb_put_zero(skb, sizeof(struct canfd_frame));
 
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -213,7 +213,6 @@ static void slc_bump(struct slcan *sl)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = sl->dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	skb_put_data(skb, &cf, sizeof(struct can_frame));
 
--- a/include/linux/can/core.h
+++ b/include/linux/can/core.h
@@ -58,6 +58,7 @@ extern void can_rx_unregister(struct net
 			      void *data);
 
 extern int can_send(struct sk_buff *skb, int loop);
+void can_set_skb_uid(struct sk_buff *skb);
 void can_sock_destruct(struct sock *sk);
 
 #endif /* !_CAN_CORE_H */
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -119,7 +119,6 @@ static inline bool can_skb_headroom_vali
 	if (skb->ip_summed == CHECKSUM_NONE) {
 		/* init headroom */
 		can_skb_prv(skb)->ifindex = dev->ifindex;
-		can_skb_prv(skb)->skbcnt = 0;
 
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -28,12 +28,10 @@
 /**
  * struct can_skb_priv - private additional data inside CAN sk_buffs
  * @ifindex:	ifindex of the first interface the CAN frame appeared on
- * @skbcnt:	atomic counter to have an unique id together with skb pointer
  * @cf:		align to the following CAN frame at skb->data
  */
 struct can_skb_priv {
 	int ifindex;
-	int skbcnt;
 	struct can_frame cf[];
 };
 
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -641,6 +641,16 @@ static int can_rcv_filter(struct can_dev
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
@@ -652,9 +662,7 @@ static void can_receive(struct sk_buff *
 	atomic_long_inc(&pkg_stats->rx_frames);
 	atomic_long_inc(&pkg_stats->rx_frames_delta);
 
-	/* create non-zero unique skb identifier together with *skb */
-	while (!(can_skb_prv(skb)->skbcnt))
-		can_skb_prv(skb)->skbcnt = atomic_inc_return(&skbcounter);
+	can_set_skb_uid(skb);
 
 	rcu_read_lock();
 
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -338,7 +338,6 @@ static void bcm_can_tx(struct bcm_op *op
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	skb_put_data(skb, cf, op->cfsiz);
 
@@ -1577,7 +1576,6 @@ static int bcm_tx_send(struct msghdr *ms
 	}
 
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 	skb->dev = dev;
 	can_skb_set_owner(skb, sk);
 	err = can_send(skb, 1); /* send with loopback */
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -218,7 +218,6 @@ static int isotp_send_fc(struct sock *sk
 
 	can_skb_reserve(nskb);
 	can_skb_prv(nskb)->ifindex = dev->ifindex;
-	can_skb_prv(nskb)->skbcnt = 0;
 
 	nskb->dev = dev;
 	can_skb_set_owner(nskb, sk);
@@ -773,7 +772,6 @@ static void isotp_send_cframe(struct iso
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	cf = (struct canfd_frame *)skb->data;
 	skb_put_zero(skb, so->ll.mtu);
@@ -1069,7 +1067,6 @@ static int isotp_sendmsg(struct socket *
 
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
@@ -608,7 +608,6 @@ sk_buff *j1939_tp_tx_dat_new(struct j193
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 	/* reserve CAN header */
 	skb_reserve(skb, offsetof(struct can_frame, data));
 
@@ -1535,7 +1534,6 @@ j1939_session *j1939_session_fresh_new(s
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 	skcb = j1939_skb_to_cb(skb);
 	memcpy(skcb, rel_skcb, sizeof(*skcb));
 
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -74,8 +74,8 @@ MODULE_ALIAS("can-proto-1");
  */
 
 struct uniqframe {
-	int skbcnt;
 	const struct sk_buff *skb;
+	u32 hash;
 	unsigned int join_rx_count;
 };
 
@@ -135,7 +135,7 @@ static void raw_rcv(struct sk_buff *oskb
 
 	/* eliminate multiple filter matches for the same skb */
 	if (this_cpu_ptr(ro->uniq)->skb == oskb &&
-	    this_cpu_ptr(ro->uniq)->skbcnt == can_skb_prv(oskb)->skbcnt) {
+	    this_cpu_ptr(ro->uniq)->hash == oskb->hash) {
 		if (ro->join_filters) {
 			this_cpu_inc(ro->uniq->join_rx_count);
 			/* drop frame until all enabled filters matched */
@@ -146,7 +146,7 @@ static void raw_rcv(struct sk_buff *oskb
 		}
 	} else {
 		this_cpu_ptr(ro->uniq)->skb = oskb;
-		this_cpu_ptr(ro->uniq)->skbcnt = can_skb_prv(oskb)->skbcnt;
+		this_cpu_ptr(ro->uniq)->hash = oskb->hash;
 		this_cpu_ptr(ro->uniq)->join_rx_count = 1;
 		/* drop first frame to check all enabled filters? */
 		if (ro->join_filters && ro->count > 1)
@@ -812,7 +812,6 @@ static int raw_sendmsg(struct socket *so
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	err = memcpy_from_msg(skb_put(skb, size), msg, size);
 	if (err < 0)


