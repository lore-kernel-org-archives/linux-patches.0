Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625523;
	b=IxSCqgczX7GKXrgPUYrOJbcll/Toe6kPGpJ6n6IDydcXIaIyNwL0OREWt3D7mxYdYTJa
	 exUH2+kBefoe08+4Bch94GSX2pw6PKo4le3/lbGYAMxE9z9HUsH43N+CDP/Jw5+zu/+dF
	 HIQ3GJUJ8Cpu8vga3CQFYn/CZHNvj4ehEA3PXk8PoHDty8N0Yfkd2duSkbbyPcA7BSbkc
	 +5OoIhFR8gX4jjzX7EJ4GB+gmhOrYSNwQnpLvDMGHGbUyGykOxYJOwZv5RbDZHgWc2EL+
	 hfI3qZF+9EzFgX1PzWOkhCsiJqPEOGrlgLhqt/XnfgV3y4rz17jw5SU5dHL2P2mTD2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n6zCrV/Hfqu3DqXEQwmOeDEI89xnWoXN/AER1v6ypWw=;
	b=0/RFf9/F1nyuDJjBesroFfywM7fDpdZbpUs9QSRcedRSiyxYX1/GTypvcuU7hN/s7zfu
	 E/BdxTMGnXVPpaly/1Kf4IGn0Oodlx55g8N9t7T/LIsfFt4p/aPJYHZK3VchhALJwM19Q
	 AxbE5M56SMEsQSkTbzJeyxRFNVm/HDbf6/IW2Pq/676kYmnMoYrVu5f8UVJh5Mvpv4p+O
	 V+JcP7RjmU8IaiUD7GpG7a+Dj5pWztDmTcnt1gByx4N9gtTR0+1cDc+oUuKruEtq9NBnX
	 zus+7QEv0/Mqfx7YM0tJVaRWZ4fiIONxjsO2Uxd4UvVupaxII3YQLw2LJx5yl6DyIig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wC2r+YMO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E99606A31E;
	Wed, 25 Nov 2026 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wC2r+YMO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87C61F000CA;
	Wed, 25 Nov 2026 16:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625523;
	bh=n6zCrV/Hfqu3DqXEQwmOeDEI89xnWoXN/AER1v6ypWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wC2r+YMOYffY9Zoi2R2ucyh2yu1jIS50ZQdrHgpEYUc6KhAQwrI/IQA0UlkkzE+72
	 M78/yuxLd3FXY9eF9LTHlM1UVi5lSkMmvWkvNk51puW+yyXX7Dgna+MX/oW0WwWJuU
	 M8KHW3Tp/X2DTYpHJPwHc4f0VogUEdIS3oaX2Rbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 544/816] ppp: linearize and segment bridged packets when required
Date: Wed, 25 Nov 2026 15:34:52 +0100
Message-ID: <20261125143901.778378743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 0de4e69cd021c99d0aa13e1f30aafd13ad74a2a5 ]

PPP channel bridging hands packets received on one channel directly to
the start_xmit() of another. Packets received by PPPoE can be
non-linear, GSO since commit 55a5d8fca836 ("net: pppoe: implement
GRO/GSO support"), or CHECKSUM_PARTIAL when injected with a
virtio_net_hdr. The regular transmit path never sees such packets, and
only PPPoE, which uses dev_queue_xmit(), handles them:

- PPP Async reads the whole packet through skb->data, transmitting
  unrelated memory for non-linear packets.
- PPP Async and Sync send GSO packets as single frames of up to 64KB,
  and CHECKSUM_PARTIAL packets with a bad L4 checksum.
- PPTP and L2TP cannot segment a TCP GSO packet once their GRE or UDP
  header is pushed, and do not finish pending checksums.

Add a xmit_offload flag to struct ppp_channel, set for PPPoE. For other
channels, segment GSO packets in software, using the PPP protocol field
as the L2 header, finish CHECKSUM_PARTIAL checksums (including SCTP
CRC32c), and linearize packets for channels without direct_xmit, as
ppp_push() does. Packets are dropped if any step fails, or if the
channel is busy, as before.

skb->dev is NULL at this point for PPPoE (cleared by __sk_receive_skb()),
and tunnel and IPv6 UFO GSO handlers dereference it: only TCP, UDP L4
and fraglist GSO packets without encapsulation are segmented, others
are dropped.

Receive paths like L2TP pull headers without updating the checksum
state, possibly leaving a CHECKSUM_PARTIAL state with csum_start before
skb->data. Reset it to CHECKSUM_NONE, as skb_postpull_rcsum() does, so
that skb_checksum_help() does not warn, and so that PPPoE does not
offload a checksum at a wrong offset.

Tested in a VM by bridging PPPoE (on a TAP with IFF_NAPI_FRAGS, or on
veth) to PPP Async on a PTY, PPPoL2TP and PPPoE: non-linear packets no
longer leak garbage, GSO packets (including fraglist GRO) are sent as
valid segments for IPv4 and IPv6, CHECKSUM_PARTIAL packets get a valid
checksum, and PPPoE still receives GSO packets unchanged.

Fixes: 4cf476ced45d ("ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls")
Fixes: 55a5d8fca836 ("net: pppoe: implement GRO/GSO support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260908072135.877364-1-qingfang.deng@linux.dev
Co-developed-by: Qingfang Deng <qingfang.deng@linux.dev>
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261026155927.707655-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Dropped SKB_GSO_TCP_ACCECN from the GSO whitelist because it isn't defined here, and adjusted includes and the pppoe_connect() prototype context (struct sockaddr). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 95 ++++++++++++++++++++++++++++++++++-
 drivers/net/ppp/pppoe.c       |  1 +
 include/linux/ppp_channel.h   |  1 +
 3 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 4d4591ea443a9..84212fd05968b 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -46,6 +46,7 @@
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/unaligned.h>
+#include <net/gso.h>
 #include <net/slhc_vj.h>
 #include <linux/atomic.h>
 #include <linux/refcount.h>
@@ -2274,6 +2275,73 @@ static bool ppp_decompress_proto(struct sk_buff *skb)
 	return pskb_may_pull(skb, 2);
 }
 
+#define PPP_BRIDGE_GSO_TYPES (SKB_GSO_TCPV4 | SKB_GSO_TCPV6 |		\
+			      SKB_GSO_TCP_ECN |					\
+			      SKB_GSO_TCP_FIXEDID | SKB_GSO_UDP_L4 |	\
+			      SKB_GSO_FRAGLIST | SKB_GSO_DODGY)
+
+/* Segment a GSO packet (built by PPPoE GRO, or injected with a
+ * virtio_net_hdr) before sending it to a bridged channel that does
+ * not accept GSO packets.
+ * skb->data points to the PPP protocol field, which is replicated
+ * in front of each segment.
+ * Returns a list of segments, or NULL if the packet was dropped.
+ */
+static struct sk_buff *ppp_bridge_gso_segment(struct sk_buff *skb,
+					      netdev_features_t features)
+{
+	struct sk_buff *segs;
+
+	/* skb->dev is NULL here (cleared by __sk_receive_skb() for PPPoE),
+	 * and some GSO handlers (tunnels, IPv6 UFO) dereference it.
+	 */
+	if (skb->encapsulation ||
+	    (skb_shinfo(skb)->gso_type & ~PPP_BRIDGE_GSO_TYPES))
+		goto drop;
+
+	if (!pskb_may_pull(skb, PPP_PROTO_LEN))
+		goto drop;
+
+	switch (get_unaligned((__be16 *)skb->data)) {
+	case htons(PPP_IP):
+		skb->protocol = htons(ETH_P_IP);
+		break;
+	case htons(PPP_IPV6):
+		skb->protocol = htons(ETH_P_IPV6);
+		break;
+	default:
+		goto drop;
+	}
+	skb_set_network_header(skb, PPP_PROTO_LEN);
+
+	/* No checksum offload: skb_segment() computes the checksums. */
+	segs = skb_gso_segment(skb, features);
+	if (IS_ERR_OR_NULL(segs))
+		goto drop;
+
+	consume_skb(skb);
+	return segs;
+
+drop:
+	kfree_skb(skb);
+	return NULL;
+}
+
+static void ppp_bridge_xmit(struct ppp_channel *chan, struct sk_buff *skb)
+{
+	if (!chan->direct_xmit && skb_linearize(skb))
+		goto drop;
+
+	if (!chan->xmit_offload && skb->ip_summed == CHECKSUM_PARTIAL &&
+	    skb_csum_hwoffload_help(skb, 0))
+		goto drop;
+
+	if (chan->ops->start_xmit(chan, skb))
+		return;
+drop:
+	kfree_skb(skb);
+}
+
 /* Attempt to handle a frame via. a bridged channel, if one exists.
  * If the channel is bridged, the frame is consumed by the bridge.
  * If not, the caller must handle the frame by normal recv mechanisms.
@@ -2281,6 +2349,8 @@ static bool ppp_decompress_proto(struct sk_buff *skb)
  */
 static bool ppp_channel_bridge_input(struct channel *pch, struct sk_buff *skb)
 {
+	struct sk_buff *segs, *next;
+	struct ppp_channel *chan;
 	struct channel *pchb;
 
 	rcu_read_lock();
@@ -2296,8 +2366,29 @@ static bool ppp_channel_bridge_input(struct channel *pch, struct sk_buff *skb)
 	}
 
 	skb_scrub_packet(skb, !net_eq(pch->chan_net, pchb->chan_net));
-	if (!pchb->chan->ops->start_xmit(pchb->chan, skb))
-		kfree_skb(skb);
+
+	/* Receive paths such as L2TP pull headers without updating
+	 * the checksum state: drop a stale CHECKSUM_PARTIAL state
+	 * pointing before skb->data, as skb_postpull_rcsum() does.
+	 */
+	if (skb->ip_summed == CHECKSUM_PARTIAL &&
+	    skb_checksum_start_offset(skb) < 0)
+		skb->ip_summed = CHECKSUM_NONE;
+
+	chan = pchb->chan;
+	if (!chan->xmit_offload && skb_is_gso(skb)) {
+		/* Channels needing linear packets get linear segments,
+		 * others keep references to the original pages.
+		 */
+		segs = ppp_bridge_gso_segment(skb, chan->direct_xmit ?
+						   NETIF_F_SG : 0);
+		skb_list_walk_safe(segs, skb, next) {
+			skb_mark_not_on_list(skb);
+			ppp_bridge_xmit(chan, skb);
+		}
+	} else {
+		ppp_bridge_xmit(chan, skb);
+	}
 
 outl:
 	spin_unlock_bh(&pchb->downl);
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 97eb18dbc312e..0a7d5f756f41a 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -698,6 +698,7 @@ static int pppoe_connect(struct socket *sock, struct sockaddr *uservaddr,
 		po->chan.private = sk;
 		po->chan.ops = &pppoe_chan_ops;
 		po->chan.direct_xmit = true;
+		po->chan.xmit_offload = true;
 
 		error = ppp_register_net_channel(dev_net(dev), &po->chan);
 		if (error) {
diff --git a/include/linux/ppp_channel.h b/include/linux/ppp_channel.h
index f73fbea0dbc23..d0646c2518b2a 100644
--- a/include/linux/ppp_channel.h
+++ b/include/linux/ppp_channel.h
@@ -43,6 +43,7 @@ struct ppp_channel {
 	void		*ppp;		/* opaque to channel */
 	int		speed;		/* transfer rate (bytes/second) */
 	bool		direct_xmit;	/* no qdisc, xmit directly */
+	bool		xmit_offload;	/* accepts GSO and CHECKSUM_PARTIAL skbs */
 };
 
 #ifdef __KERNEL__
-- 
2.53.0



