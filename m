Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407072E266C;
	Sat, 17 Oct 2026 17:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257448; cv=none; b=kDqMz14uv5PRdY7WMFQI0MckWI0LnAJjczjmICe8Q3jjGfHiyaZVpNkYoYBA8QUdSszuTsZ1GRdzLi5S7x0y4VQZ/edDSjE2/+q6mCGb1qMjYRjEJ5ndZYKv5bYQq7zKmVSOFQsL/SKiwJ1peSIOAd6thgvFrUaXh6GI+9+D528=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257448; c=relaxed/simple;
	bh=Cb1IRA8W1xcFC5ir5sgYkCo/DP7yoYts9dpIwP0GZoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSO4dj2dq6fQvyxVfoupySgzyVNShXxHFVqwjPlsFSsMlDbhU6sIvAbNUXuqRTm3uUmsLQjchlwLaT6lCY+PEX8kPe43Q1Vr43kuXKduSEH+qPFQ7+r8X/esXhXutLZIGp8ARKeoaOH4fAk/X8Q301qrNbihwedLeqKrviJFd6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTv1Litu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTv1Litu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8194A1F000C4;
	Sat, 17 Oct 2026 17:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257447;
	bh=wreTs1y7NsOJvJQ67etP68aS//Wkt7jfnUyA+fCrQy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTv1LitutSwZ8rrhYMcSs7m4Ov6dQHwUDo4O8XSS+z8eehDLphTra7BFx54/UO7W4
	 zhbkLH3etTnXJ+YXq2uqkncPfV6F6zLj9fkoDC1xwLnBtiqyaur2tkaC+APs0Rb/Tt
	 e5ueTcN/JexYFikuXufBsmJGM+S149cwPl9B/f2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joerg Willmann <joe@clnt.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0561/1674] can: fix unique skb identifier regression under RPS
Date: Sat, 17 Oct 2026 17:47:13 +0200
Message-ID: <20261017160445.494736703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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

[ backport to 6.6: no CAN skb extensions available, so the UID is kept
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
 include/linux/can/skb.h   |  2 ++
 net/can/af_can.c          |  6 ++----
 net/can/bcm.c             |  2 ++
 net/can/isotp.c           | 11 +++++++----
 net/can/j1939/socket.c    |  1 +
 net/can/j1939/transport.c |  2 ++
 net/can/raw.c             |  7 ++++---
 8 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 0da615afa04de..3ebd4f779b9bd 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -202,6 +202,7 @@ static void init_can_skb_reserve(struct sk_buff *skb)
 	skb_reset_transport_header(skb);
 
 	can_skb_reserve(skb);
+	can_skb_prv(skb)->skbcnt = 0;
 }
 
 struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf)
@@ -311,6 +312,7 @@ static bool can_skb_headroom_valid(struct net_device *dev, struct sk_buff *skb)
 	if (skb->ip_summed == CHECKSUM_NONE) {
 		/* init headroom */
 		can_skb_prv(skb)->ifindex = dev->ifindex;
+		can_skb_prv(skb)->skbcnt = 0;
 
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index 869ea574a40a1..27d0ca115c6c1 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -49,11 +49,13 @@ bool can_dropped_invalid_skb(struct net_device *dev, struct sk_buff *skb);
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
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 54877f06cd782..69f794e82ca61 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -642,10 +642,8 @@ static int can_rcv_filter(struct can_dev_rcv_lists *dev_rcv_lists, struct sk_buf
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
index 4914958031673..fcd923c223f4b 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -338,6 +338,7 @@ static void bcm_can_tx(struct bcm_op *op, struct canfd_frame *cf)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	skb_put_data(skb, cf, op->cfsiz);
 
@@ -1581,6 +1582,7 @@ static int bcm_tx_send(struct msghdr *msg, int ifindex, struct sock *sk,
 	}
 
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	skb->dev = dev;
 	can_skb_set_owner(skb, sk);
 	err = can_send(skb, 1); /* send with loopback */
diff --git a/net/can/isotp.c b/net/can/isotp.c
index fded419bc34f6..e448cfdb1f07b 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -300,6 +300,7 @@ static int isotp_send_fc(struct sock *sk, int ae, u8 flowstatus)
 
 	can_skb_reserve(nskb);
 	can_skb_prv(nskb)->ifindex = dev->ifindex;
+	can_skb_prv(nskb)->skbcnt = 0;
 
 	nskb->dev = dev;
 	can_skb_set_owner(nskb, sk);
@@ -871,6 +872,7 @@ static void isotp_send_cframe(struct isotp_sock *so)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	/* set uid in tx skb to identify CF echo frames */
 	can_set_skb_uid(skb);
@@ -899,7 +901,7 @@ static void isotp_send_cframe(struct isotp_sock *so)
 		pr_notice_once("can-isotp: cfecho is %08X != 0\n", old_cfecho);
 
 	/* set consecutive frame echo tag */
-	WRITE_ONCE(so->cfecho, skb->hash);
+	WRITE_ONCE(so->cfecho, can_skb_prv(skb)->skbcnt);
 
 	/* send frame with local echo enabled */
 	can_send_ret = can_send(skb, 1);
@@ -962,7 +964,7 @@ static void isotp_rcv_echo(struct sk_buff *skb, void *data)
 	spin_lock(&so->rx_lock);
 
 	/* so->cfecho may since belong to a new transfer; recheck under lock */
-	if (READ_ONCE(so->cfecho) != skb->hash)
+	if (READ_ONCE(so->cfecho) != can_skb_prv(skb)->skbcnt)
 		goto out_unlock;
 
 	/* cancel local echo timeout */
@@ -1194,6 +1196,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	/* set uid in tx skb to identify CF echo frames */
 	can_set_skb_uid(skb);
@@ -1235,7 +1238,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			cf->data[ae] |= size;
 
 		/* set CF echo tag for isotp_rcv_echo() (SF-mode) */
-		WRITE_ONCE(so->cfecho, skb->hash);
+		WRITE_ONCE(so->cfecho, can_skb_prv(skb)->skbcnt);
 	} else {
 		/* send first frame */
 
@@ -1252,7 +1255,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			so->txfc.bs = 0;
 
 			/* set CF echo tag for isotp_rcv_echo() (CF-mode) */
-			WRITE_ONCE(so->cfecho, skb->hash);
+			WRITE_ONCE(so->cfecho, can_skb_prv(skb)->skbcnt);
 		} else {
 			/* standard flow control check */
 			new_state = ISOTP_WAIT_FIRST_FC;
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 4841aae2fcaad..e1d6d57c921b6 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -895,6 +895,7 @@ static struct sk_buff *j1939_sk_alloc_skb(struct net_device *ndev,
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = ndev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	skb_reserve(skb, offsetof(struct can_frame, data));
 
 	ret = memcpy_from_msg(skb_put(skb, size), msg, size);
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index a262a58588c2d..61f0c6b68138b 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -613,6 +613,7 @@ sk_buff *j1939_tp_tx_dat_new(struct j1939_priv *priv,
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	/* reserve CAN header */
 	skb_reserve(skb, offsetof(struct can_frame, data));
 
@@ -1552,6 +1553,7 @@ j1939_session *j1939_session_fresh_new(struct j1939_priv *priv,
 	skb->dev = priv->ndev;
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 	skcb = j1939_skb_to_cb(skb);
 	memcpy(skcb, rel_skcb, sizeof(*skcb));
 
diff --git a/net/can/raw.c b/net/can/raw.c
index ad4b16476743a..517f075a0aecd 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -75,8 +75,8 @@ MODULE_ALIAS("can-proto-1");
  */
 
 struct uniqframe {
+	u32 skbcnt;
 	const struct sk_buff *skb;
-	u32 hash;
 	unsigned int join_rx_count;
 };
 
@@ -140,7 +140,7 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 
 	/* eliminate multiple filter matches for the same skb */
 	if (this_cpu_ptr(ro->uniq)->skb == oskb &&
-	    this_cpu_ptr(ro->uniq)->hash == oskb->hash) {
+	    this_cpu_ptr(ro->uniq)->skbcnt == can_skb_prv(oskb)->skbcnt) {
 		if (!ro->join_filters)
 			return;
 
@@ -150,7 +150,7 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 			return;
 	} else {
 		this_cpu_ptr(ro->uniq)->skb = oskb;
-		this_cpu_ptr(ro->uniq)->hash = oskb->hash;
+		this_cpu_ptr(ro->uniq)->skbcnt = can_skb_prv(oskb)->skbcnt;
 		this_cpu_ptr(ro->uniq)->join_rx_count = 1;
 		/* drop first frame to check all enabled filters? */
 		if (ro->join_filters && ro->count > 1)
@@ -871,6 +871,7 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
+	can_skb_prv(skb)->skbcnt = 0;
 
 	/* fill the skb before testing for valid CAN frames */
 	err = memcpy_from_msg(skb_put(skb, size), msg, size);
-- 
2.53.0



