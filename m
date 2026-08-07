Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B70333DEF7;
	Fri,  7 Aug 2026 15:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115793; cv=none; b=Bc4R1q7p5yYFmPdpArwCWqZFWP0W5hrXhoHAYxhEIkTLhonNTgeX6JxKxDjiCUlewlHAgbHzSH61Qw3+71tMcCLPAHaCUaZrqPMtzv/2p+QD6HqQGzp3gcJKBorgpdsvKhSnfeYOnmZQe0o+R3Iy90cj9AkAZMUH8S0T5sP+ofo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115793; c=relaxed/simple;
	bh=D3cvk+kjtYbPxdt1e57RyzyNdkyDB5hk485DNjt/pSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGrhfiVTGATL1bxcykShQFtiDAcXDs8jeFM8xe6T4XnMETnadM/Z2XhK7QlKbspdb6HKq3IMznGGc3sTpyhzJfliTfPQT3DU1qWmpHm2gfF9TaLFTV1aELjhvPqFaWQDYvl0RBnOdKy4dURnjDVC8LAmNRTy5SRb+tVQlm6DP6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0KsmnOW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0KsmnOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76761F000E9;
	Fri,  7 Aug 2026 15:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115792;
	bh=HhmLpw2q7FG+MX0RpRVbfz+dHVHWpmg6z4Ap3dlco+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0KsmnOW2J92V+K+PaZwpT5P2pRIcyNI+TEK2ryZ3zjD6jO4dLF4JfOVDl8iXVTfm
	 /cOvwvFA3AI9+ltqI53Kb5zTUo+tqO6l7inlXuNKjlhHi9d+YXrlGHp4L3g7Ps852y
	 8/G2oV+DcTDEpZiV/kW9kcNYRRL0+VpRv6MjV9kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 392/396] can: use skb hash instead of private variable in headroom
Date: Fri,  7 Aug 2026 16:39:12 +0200
Message-ID: <20260807143432.729595415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -350,7 +350,6 @@ static void bcm_can_tx(struct bcm_op *op
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	skb_put_data(skb, cf, op->cfsiz);
 
@@ -1621,7 +1620,6 @@ static int bcm_tx_send(struct msghdr *ms
 	}
 
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 	skb->dev = dev;
 	can_skb_set_owner(skb, sk);
 	err = can_send(skb, 1); /* send with loopback */
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -233,7 +233,6 @@ static int isotp_send_fc(struct sock *sk
 
 	can_skb_reserve(nskb);
 	can_skb_prv(nskb)->ifindex = dev->ifindex;
-	can_skb_prv(nskb)->skbcnt = 0;
 
 	nskb->dev = dev;
 	can_skb_set_owner(nskb, sk);
@@ -800,7 +799,6 @@ static void isotp_send_cframe(struct iso
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	cf = (struct canfd_frame *)skb->data;
 	skb_put_zero(skb, so->ll.mtu);
@@ -1106,7 +1104,6 @@ static int isotp_sendmsg(struct socket *
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	so->tx.len = size;
 	so->tx.idx = 0;
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -897,7 +897,6 @@ static struct sk_buff *j1939_sk_alloc_sk
 
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
 
@@ -1549,7 +1548,6 @@ j1939_session *j1939_session_fresh_new(s
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 	skcb = j1939_skb_to_cb(skb);
 	memcpy(skcb, rel_skcb, sizeof(*skcb));
 
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -76,7 +76,7 @@ MODULE_ALIAS("can-proto-1");
 
 struct uniqframe {
 	const struct sk_buff *skb;
-	int skbcnt;
+	u32 hash;
 	unsigned int join_rx_count;
 };
 
@@ -164,7 +164,7 @@ static void raw_rcv(struct sk_buff *oskb
 
 	/* eliminate multiple filter matches for the same skb */
 	if (this_cpu_ptr(ro->uniq)->skb == oskb &&
-	    this_cpu_ptr(ro->uniq)->skbcnt == can_skb_prv(oskb)->skbcnt) {
+	    this_cpu_ptr(ro->uniq)->hash == oskb->hash) {
 		if (!ro->join_filters)
 			return;
 
@@ -174,7 +174,7 @@ static void raw_rcv(struct sk_buff *oskb
 			return;
 	} else {
 		this_cpu_ptr(ro->uniq)->skb = oskb;
-		this_cpu_ptr(ro->uniq)->skbcnt = can_skb_prv(oskb)->skbcnt;
+		this_cpu_ptr(ro->uniq)->hash = oskb->hash;
 		this_cpu_ptr(ro->uniq)->join_rx_count = 1;
 		/* drop first frame to check all enabled filters? */
 		if (ro->join_filters && ro->count > 1)
@@ -954,7 +954,6 @@ static int raw_sendmsg(struct socket *so
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
-	can_skb_prv(skb)->skbcnt = 0;
 
 	/* fill the skb before testing for valid CAN frames */
 	err = memcpy_from_msg(skb_put(skb, size), msg, size);


