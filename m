Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211624;
	b=StN8VdRZYLfuLj8xlc1K8KpeR6xj3LKcXEXd9dIGJhZ1tQyth0uv+drUy+i7AmntlyBV
	 ztYhUC8WiwqqLTYjSoYVZaPDGQxXXvYEfzbbGSi/S6P5iIgVN6T/WmMxqBwrVwgnT+/BM
	 MWHhpI0ulmQsZAu/nhdd62k5fHcVc2ErtdeD9ncRsBeI/PcUoLyuxCis59KIKsvIOfHfJ
	 7blzsBFfczSz0uXmuvCSamwM26XRGSnRRaVmjHjZI3X8qEOADJo/DIRxqyat7eCGxvN9L
	 tswy6zdWxYoXxfAzt4HYsdJzWGrPdGGcwwFTt5IsQVJwV30eDcthZxbuN4G4HIY7SDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wo5NyrA+wrB2LYok+BD/QlCUhrVqPkqwaAZJk09GzK0=;
	b=PfAdEt1fqcpD9B4oKM+f1Ljjhq6U3CAF8HouBaYqb84V4n3mFtW5B9AZCM0EWlWkhyCE
	 7jwARLMTmbN6ZwQ3sWCoJXW/wEjkgX4qf7/OeZpILIkV6tt5qBmA+ASD0CgDL9hbtObZQ
	 bJJSu3bee333wN8GGm9L2ORx8YDydz8cMfg78WgHSYXAhiXKieCbfI3mv+K44rwjhsRGf
	 lL63mo3flSQR/95s/0pojafD1MV4wT903s0hob84W5TIDkS0DjuJKVxa8N6L9sLMW7+7s
	 C09U+XGEs73eEnw2584OSOi8rov6jpYx0KinM2EdkUF4RoRFZ05XY/f4vD+jsTmEzgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dkZAL4uc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2840D606A31A;
	Wed, 28 Oct 2026 18:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dkZAL4uc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9381F01829;
	Wed, 28 Oct 2026 18:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211624;
	bh=Wo5NyrA+wrB2LYok+BD/QlCUhrVqPkqwaAZJk09GzK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkZAL4ucf6STXP1yh6Q5kcfQzrvOUiHjfMgjejl7hW1P95rBBXWKfEWfRRqhksCpx
	 OwmSS46AWVX83UMQOCH+q2SeKxmxtDPmS2wu2rD9ERYg6nksq807W2GSvSrLVGmILc
	 3epMx6ifxoqc5+w6sNCggn9PJCrxiiwUNrahl3B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joerg Willmann <joe@clnt.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 416/571] can: fix unique skb identifier regression under RPS
Date: Wed, 28 Oct 2026 17:59:23 +0100
Message-ID: <20261028170017.882097967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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

[ backport to 5.15: no CAN skb extensions available, so the UID is kept
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
 drivers/net/can/dev/skb.c |  2 ++
 drivers/net/can/slcan.c   |  1 +
 include/linux/can/skb.h   |  3 +++
 net/can/af_can.c          |  6 ++----
 net/can/bcm.c             |  2 ++
 net/can/isotp.c           | 11 +++++++----
 net/can/j1939/socket.c    |  1 +
 net/can/j1939/transport.c |  2 ++
 net/can/raw.c             |  7 ++++---
 9 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index ec624cfc1b071..e59d5cbb644a1 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -203,6 +203,7 @@ struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	*cf = skb_put_zero(skb, sizeof(struct can_frame));
 
@@ -233,6 +234,7 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	*cfd = skb_put_zero(skb, sizeof(struct canfd_frame));
 
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 0b2403e9853e7..012da4b8abe0a 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -213,6 +213,7 @@ static void slc_bump(struct slcan *sl)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = sl->dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	skb_put_data(skb, &cf, sizeof(struct can_frame));
 
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index f887eb21e178b..a7d2283d49960 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -43,11 +43,13 @@ struct sk_buff *alloc_can_err_skb(struct net_device *dev,
 /**
  * struct can_skb_priv - private additional data inside CAN sk_buffs
  * @ifindex:	ifindex of the first interface the CAN frame appeared on
+ * @skbcnt:	atomic counter to have an unique id together with skb pointer
  * @frame_len:	length of CAN frame in data link layer
  * @cf:		align to the following CAN frame at skb->data
  */
 struct can_skb_priv {
 	int ifindex;
+	u32 skbcnt;
 	unsigned int frame_len;
 	struct can_frame cf[];
 };
@@ -105,6 +107,7 @@ static inline bool can_skb_headroom_valid(struct net_device *dev,
 	if (skb->ip_summed == CHECKSUM_NONE) {
 		/* init headroom */
 		can_skb_prv(skb)->ifindex = dev->ifindex;
+		can_skb_prv(skb)->skbcnt = 0;
 
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 95b7cc548675e..cd31c4e014d1f 100644
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
index 2351562233943..2cf63940f6a9b 100644
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
index 1037d2c2e61a5..46b71e2bded2c 100644
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
index c088f1d8150f0..585de1dad6f4f 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -895,6 +895,7 @@ static struct sk_buff *j1939_sk_alloc_skb(struct net_device *ndev,
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = ndev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	skb_reserve(skb, offsetof(struct can_frame, data));
 
 	ret = memcpy_from_msg(skb_put(skb, size), msg, size);
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 74638cf04172e..55bbcf73c8732 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -612,6 +612,7 @@ sk_buff *j1939_tp_tx_dat_new(struct j1939_priv *priv,
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	/* reserve CAN header */
 	skb_reserve(skb, offsetof(struct can_frame, data));
 
@@ -1550,6 +1551,7 @@ j1939_session *j1939_session_fresh_new(struct j1939_priv *priv,
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	skcb = j1939_skb_to_cb(skb);
 	memcpy(skcb, rel_skcb, sizeof(*skcb));
 
diff --git a/net/can/raw.c b/net/can/raw.c
index ffbb622f88422..fccc2904bb181 100644
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
 
@@ -136,7 +136,7 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 
 	/* eliminate multiple filter matches for the same skb */
 	if (this_cpu_ptr(ro->uniq)->skb == oskb &&
-	    this_cpu_ptr(ro->uniq)->hash == oskb->hash) {
+	    this_cpu_ptr(ro->uniq)->skbcnt == can_skb_prv(oskb)->skbcnt) {
 		if (ro->join_filters) {
 			this_cpu_inc(ro->uniq->join_rx_count);
 			/* drop frame until all enabled filters matched */
@@ -147,7 +147,7 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 		}
 	} else {
 		this_cpu_ptr(ro->uniq)->skb = oskb;
-		this_cpu_ptr(ro->uniq)->hash = oskb->hash;
+		this_cpu_ptr(ro->uniq)->skbcnt = can_skb_prv(oskb)->skbcnt;
 		this_cpu_ptr(ro->uniq)->join_rx_count = 1;
 		/* drop first frame to check all enabled filters? */
 		if (ro->join_filters && ro->count > 1)
@@ -829,6 +829,7 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	err = memcpy_from_msg(skb_put(skb, size), msg, size);
 	if (err < 0)
-- 
2.53.0



