Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209134;
	b=xOGw5IUBeIbp4XqIpxQOjbEFFtwOch9A5t68b/TaST74M62Dye9Woiior79osBwNX0Aa
	 mJ2nEOOV7+EfURxuPil4dsY4jWMNMtvkJx71dpS2QffGBhC84phXwe2sdN6JCWTJMty2+
	 YjzvC5KcbQxuQfHOvCDz++V71PrZ7IdFIUwPlRsAcLb/9KO+jONZtXXphomNV1tvEhetv
	 6fy+iCAFDJyRRHYhyu08+VNHjXbe/lxeN2hZKMSSOCadzGBfTzb9O/twnRBaa2CUPjQPk
	 ORfZ4msNLLGG3FnX0SMFjrGYx4DoRJtF03R+n6Z5dGaJKgU4BpPwyqMcVb8AikTDEfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cT8QpHdRWmuPWAuWsctv1BvyyWrFRuol69qeZbhXOFI=;
	b=yBPy2tFEvpZEgeB+LjZvktOUeF8ejs82qLdyOSDMiiJ4RZs5bVG2nonA21MZum3IxK3R
	 9j7fhwDQRjynMaaR3/c7Lj+ESYoaVafSIGRXJGzCxy78+/umQbKKUmBBEnYDbVaUigg6k
	 w0yMv9dErD1yVy7EBMea01RcWu0pssWdcIsUBPvP7DjJY3Sexs0PkgnN2OudiWfbgrzhf
	 W6umn6CAcJNm9VVuutFXUCbTRjbQVEowRfsAVXYxTH2tE6a71e2uCfz9VFd4R0+TQ/e1F
	 Tcho5iK6ZlnZJ7tskaetIPl1gKvJ9sCvdale3C8r+A7SOoi8Tptxj/4XLMqbKfqwTfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pefz0B9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EFF606A31E;
	Wed, 28 Oct 2026 17:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pefz0B9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240411F01825;
	Wed, 28 Oct 2026 17:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209133;
	bh=cT8QpHdRWmuPWAuWsctv1BvyyWrFRuol69qeZbhXOFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pefz0B9E7UxY2110jQTUi6YZGdyQEC99ZcsAT4C880M3vOXaCg0OLOfqpVE1pGrkA
	 56aEmBAf3bJH/AfrlQep3cGhQEgfLx8L5Frlj+NKAfELBA7TUsLyy0mlV82bX9H7jP
	 J8cxJMWnxhTuDWZDA4S27jEaFhMAjR+rSWhuaL+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joerg Willmann <joe@clnt.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 363/516] can: fix unique skb identifier regression under RPS
Date: Wed, 28 Oct 2026 17:58:35 +0100
Message-ID: <20261028170012.085372792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 7093c3b8314a4ef7405c4066a2521398c455efe7 upstream.

Commit d4fb6514ff8e ("can: use skb hash instead of private variable in
headroom") moved the per-skb unique identifier used for raw_rcv()
duplicate detection into skb->hash.

With RPS enabled, get_rps_cpu() calls skb_get_hash() before the frame
reaches the CAN subsystem. Since CAN skbs have no L3/L4 headers, the
flow dissector assigns every CAN frame the same non-zero software
hash. can_set_skb_uid() only generated a new identifier when
skb->hash was 0, so it kept this constant hash. When the SLAB
allocator later reused the same skb address, raw_rcv() mistook the
next legitimate frame for a duplicate and dropped it.

Fix this by storing the CAN UID in the CAN skb extension
(struct can_skb_ext::can_skb_uid) instead of skb->hash, decoupling it
from any hash the network stack may compute. can_set_skb_uid() keeps
its "assign only if unset" behaviour, which preserves UIDs set before
transmission (e.g. by isotp to identify echo frames) across the local
loopback path.

Frames whose extension is shared with another clone (e.g. via tc mirred
or netem duplicate) are given a private extension copy before the UID
is assigned, so that independently received skb clones from real CAN
interfaces (skbcnt = 0) don't end up with the same UID.
The limitation that tc mirred/netem skb duplicates might be dropped in
raw_rcv for looped back isotp echo frame skbs is accepted. There is no
valid use-case for tc mirred or netem together with isotp which is not
capable to operate on different CAN interfaces simultaneously.
For routing and modifying CAN frames together with isotp use can-gw.

can-gw and vxcan additionally clear the UID of forwarded/duplicated
frames so each newly routed frame gets its own unique identifier.

[ backport to 5.10: no CAN skb extensions available, so the UID is kept
  in struct can_skb_priv::skbcnt in the headroom (effectively reverting
  d4fb6514ff8e) and isotp is adapted accordingly. As skb clones share
  the headroom, the private extension copy for tc mirred/netem
  duplicates is not applicable. The UID resets in can-gw and vxcan are
  omitted, as writing to the shared headroom of cloned skbs would also
  alter the UID of the original skb. This keeps the pre-d4fb6514ff8e
  behaviour for routed and vxcan forwarded frames. ]

Fixes: d4fb6514ff8e ("can: use skb hash instead of private variable in headroom")
Reported-by: Joerg Willmann <joe@clnt.de>
Closes: https://lore.kernel.org/linux-can/2859AD3D-C805-41A0-9036-C5E8EE152419@clnt.de/
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/dev.c |  2 ++
 drivers/net/can/slcan.c   |  1 +
 include/linux/can/dev.h   |  1 +
 include/linux/can/skb.h   |  2 ++
 net/can/af_can.c          |  6 ++----
 net/can/bcm.c             |  2 ++
 net/can/isotp.c           | 11 +++++++----
 net/can/j1939/socket.c    |  1 +
 net/can/j1939/transport.c |  2 ++
 net/can/raw.c             |  7 ++++---
 10 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 50fd5befa6f51..b5e79d63d59b5 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -694,6 +694,7 @@ struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	*cf = skb_put_zero(skb, sizeof(struct can_frame));
 
@@ -721,6 +722,7 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	*cfd = skb_put_zero(skb, sizeof(struct canfd_frame));
 
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index d1833aafc40cd..4f1538186c3eb 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -213,6 +213,7 @@ static void slc_bump(struct slcan *sl)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = sl->dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	skb_put_data(skb, &cf, sizeof(struct can_frame));
 
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 83bcb1b8fa5b0..41ff317953201 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -119,6 +119,7 @@ static inline bool can_skb_headroom_valid(struct net_device *dev,
 	if (skb->ip_summed == CHECKSUM_NONE) {
 		/* init headroom */
 		can_skb_prv(skb)->ifindex = dev->ifindex;
+		can_skb_prv(skb)->skbcnt = 0;
 
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index 6399318832cb3..b2c291407d525 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -28,10 +28,12 @@
 /**
  * struct can_skb_priv - private additional data inside CAN sk_buffs
  * @ifindex:	ifindex of the first interface the CAN frame appeared on
+ * @skbcnt:	atomic counter to have an unique id together with skb pointer
  * @cf:		align to the following CAN frame at skb->data
  */
 struct can_skb_priv {
 	int ifindex;
+	u32 skbcnt;
 	struct can_frame cf[];
 };
 
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 5d6022d8c7157..05066662279d9 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -644,10 +644,8 @@ static int can_rcv_filter(struct can_dev_rcv_lists *dev_rcv_lists, struct sk_buf
 void can_set_skb_uid(struct sk_buff *skb)
 {
 	/* create non-zero unique skb identifier together with *skb */
-	while (!(skb->hash))
-		skb->hash = atomic_inc_return(&skbcounter);
-
-	skb->sw_hash = 1;
+	while (!(can_skb_prv(skb)->skbcnt))
+		can_skb_prv(skb)->skbcnt = atomic_inc_return(&skbcounter);
 }
 EXPORT_SYMBOL(can_set_skb_uid);
 
diff --git a/net/can/bcm.c b/net/can/bcm.c
index df81d97e693fa..f655764aae83e 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -338,6 +338,7 @@ static void bcm_can_tx(struct bcm_op *op, struct canfd_frame *cf)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	skb_put_data(skb, cf, op->cfsiz);
 
@@ -1576,6 +1577,7 @@ static int bcm_tx_send(struct msghdr *msg, int ifindex, struct sock *sk,
 	}
 
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	skb->dev = dev;
 	can_skb_set_owner(skb, sk);
 	err = can_send(skb, 1); /* send with loopback */
diff --git a/net/can/isotp.c b/net/can/isotp.c
index b79ba8c22b1a8..01d5a4603663c 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -287,6 +287,7 @@ static int isotp_send_fc(struct sock *sk, int ae, u8 flowstatus)
 
 	can_skb_reserve(nskb);
 	can_skb_prv(nskb)->ifindex = dev->ifindex;
+	can_skb_prv(nskb)->skbcnt = 0;
 
 	nskb->dev = dev;
 	can_skb_set_owner(nskb, sk);
@@ -848,6 +849,7 @@ static void isotp_send_cframe(struct isotp_sock *so)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	/* set uid in tx skb to identify CF echo frames */
 	can_set_skb_uid(skb);
@@ -876,7 +878,7 @@ static void isotp_send_cframe(struct isotp_sock *so)
 		pr_notice_once("can-isotp: cfecho is %08X != 0\n", old_cfecho);
 
 	/* set consecutive frame echo tag */
-	WRITE_ONCE(so->cfecho, skb->hash);
+	WRITE_ONCE(so->cfecho, can_skb_prv(skb)->skbcnt);
 
 	/* send frame with local echo enabled */
 	can_send_ret = can_send(skb, 1);
@@ -939,7 +941,7 @@ static void isotp_rcv_echo(struct sk_buff *skb, void *data)
 	spin_lock(&so->rx_lock);
 
 	/* so->cfecho may since belong to a new transfer; recheck under lock */
-	if (READ_ONCE(so->cfecho) != skb->hash)
+	if (READ_ONCE(so->cfecho) != can_skb_prv(skb)->skbcnt)
 		goto out_unlock;
 
 	/* cancel local echo timeout */
@@ -1161,6 +1163,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	/* set uid in tx skb to identify CF echo frames */
 	can_set_skb_uid(skb);
@@ -1202,7 +1205,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			cf->data[ae] |= size;
 
 		/* set CF echo tag for isotp_rcv_echo() (SF-mode) */
-		WRITE_ONCE(so->cfecho, skb->hash);
+		WRITE_ONCE(so->cfecho, can_skb_prv(skb)->skbcnt);
 	} else {
 		/* send first frame */
 
@@ -1219,7 +1222,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			so->txfc.bs = 0;
 
 			/* set CF echo tag for isotp_rcv_echo() (CF-mode) */
-			WRITE_ONCE(so->cfecho, skb->hash);
+			WRITE_ONCE(so->cfecho, can_skb_prv(skb)->skbcnt);
 		} else {
 			/* standard flow control check */
 			new_state = ISOTP_WAIT_FIRST_FC;
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 551617b761ba1..34cd4792d5d41 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -889,6 +889,7 @@ static struct sk_buff *j1939_sk_alloc_skb(struct net_device *ndev,
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = ndev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	skb_reserve(skb, offsetof(struct can_frame, data));
 
 	ret = memcpy_from_msg(skb_put(skb, size), msg, size);
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index ff1a5fee7b0e9..4116b5150526a 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -608,6 +608,7 @@ sk_buff *j1939_tp_tx_dat_new(struct j1939_priv *priv,
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	/* reserve CAN header */
 	skb_reserve(skb, offsetof(struct can_frame, data));
 
@@ -1534,6 +1535,7 @@ j1939_session *j1939_session_fresh_new(struct j1939_priv *priv,
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	skcb = j1939_skb_to_cb(skb);
 	memcpy(skcb, rel_skcb, sizeof(*skcb));
 
diff --git a/net/can/raw.c b/net/can/raw.c
index db10c87583910..8bbbd9092e3a3 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -74,8 +74,8 @@ MODULE_ALIAS("can-proto-1");
  */
 
 struct uniqframe {
+	u32 skbcnt;
 	const struct sk_buff *skb;
-	u32 hash;
 	unsigned int join_rx_count;
 };
 
@@ -135,7 +135,7 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 
 	/* eliminate multiple filter matches for the same skb */
 	if (this_cpu_ptr(ro->uniq)->skb == oskb &&
-	    this_cpu_ptr(ro->uniq)->hash == oskb->hash) {
+	    this_cpu_ptr(ro->uniq)->skbcnt == can_skb_prv(oskb)->skbcnt) {
 		if (ro->join_filters) {
 			this_cpu_inc(ro->uniq->join_rx_count);
 			/* drop frame until all enabled filters matched */
@@ -146,7 +146,7 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 		}
 	} else {
 		this_cpu_ptr(ro->uniq)->skb = oskb;
-		this_cpu_ptr(ro->uniq)->hash = oskb->hash;
+		this_cpu_ptr(ro->uniq)->skbcnt = can_skb_prv(oskb)->skbcnt;
 		this_cpu_ptr(ro->uniq)->join_rx_count = 1;
 		/* drop first frame to check all enabled filters? */
 		if (ro->join_filters && ro->count > 1)
@@ -812,6 +812,7 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	err = memcpy_from_msg(skb_put(skb, size), msg, size);
 	if (err < 0)
-- 
2.53.0



