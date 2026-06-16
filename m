Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C168F449EA8;
	Tue, 16 Jun 2026 17:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630808; cv=none; b=ZjaHrA8n9ClYQGGVhw2ZcGwy0tyMXSb6D3wp6tJeigrt4M1m8e5ki5BKk4yYhfLPfdMV4UfZjaLsEaZIue5PJMukKmWxSi9NR5xto/ZEsAZCaki4NMceWGjtbRZ2WMB7iCnx2EzRlMohE+q7PCSE+LzJ6HvmECY3TRTRXd04okE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630808; c=relaxed/simple;
	bh=l3nXeCauI26NyrQVGrTz3Zr3R97SsHnE/5mz1N7QDBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pELk2x9ujO2cqPbDqcyX3cNyBPPO8iENYlD1igbH8L8pZzXPheX+vx0JtOOl5R0SI023S1KtR6CCsGk0Y2DXV5UlKUOxIGIa5N6xF9mxY9ZtH+o811WeIe+ftusbWgXfmyuhBR+skg2Gp4Vc/4B5jtuK1kec1ZddCKHKz+Q83zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PD6X7qw5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PD6X7qw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96221F00A3A;
	Tue, 16 Jun 2026 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630807;
	bh=19qC30nvSWZz4NLpR0ePQfiE7Z0vNvPid6+rlEnvyes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PD6X7qw5nMk3V1VF4X5j4gQXu9hg9zvQUShGVRcRmqk2nI/fSG1aNPhf+IEjUCP36
	 YqbvXBwxwnQLkIKIj3jLoL9TW2YNxLrCha4kKhh7/WDrRl919jAhBwOcRs72dMaths
	 2/1Mrn8x4678VdiAZAeIm8w5oYKuoImTjo0BfSio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/522] net/packet: convert po->has_vnet_hdr to an atomic flag
Date: Tue, 16 Jun 2026 20:23:34 +0530
Message-ID: <20260616145128.949770765@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 50d935eafee292fc432d5ac8c8715a6492961abc ]

po->has_vnet_hdr can be read locklessly.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 2c054e17d9d4 ("net/packet: fix TOCTOU race on mmap'd vnet_hdr in tpacket_snd()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 19 ++++++++++---------
 net/packet/diag.c      |  2 +-
 net/packet/internal.h  |  2 +-
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 490bfec158035e..50d9618d85f3c7 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2357,7 +2357,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 		netoff = TPACKET_ALIGN(po->tp_hdrlen +
 				       (maclen < 16 ? 16 : maclen)) +
 				       po->tp_reserve;
-		if (po->has_vnet_hdr) {
+		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
 			netoff += sizeof(struct virtio_net_hdr);
 			do_vnet = true;
 		}
@@ -2831,7 +2831,8 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	size_max = po->tx_ring.frame_size
 		- (po->tp_hdrlen - sizeof(struct sockaddr_ll));
 
-	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
+	if ((size_max > dev->mtu + reserve + VLAN_HLEN) &&
+	    !packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR))
 		size_max = dev->mtu + reserve + VLAN_HLEN;
 
 	timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
@@ -2866,7 +2867,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		status = TP_STATUS_SEND_REQUEST;
 		hlen = LL_RESERVED_SPACE(dev);
 		tlen = dev->needed_tailroom;
-		if (po->has_vnet_hdr) {
+		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
 			vnet_hdr = data;
 			data += sizeof(*vnet_hdr);
 			tp_len -= sizeof(*vnet_hdr);
@@ -2894,7 +2895,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 					  addr, hlen, copylen, &sockc);
 		if (likely(tp_len >= 0) &&
 		    tp_len > dev->mtu + reserve &&
-		    !po->has_vnet_hdr &&
+		    !packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR) &&
 		    !packet_extra_vlan_len_allowed(dev, skb))
 			tp_len = -EMSGSIZE;
 
@@ -2913,7 +2914,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 			}
 		}
 
-		if (po->has_vnet_hdr) {
+		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
 			if (virtio_net_hdr_to_skb(skb, vnet_hdr, vio_le())) {
 				tp_len = -EINVAL;
 				goto tpacket_error;
@@ -3041,7 +3042,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 
 	if (sock->type == SOCK_RAW)
 		reserve = dev->hard_header_len;
-	if (po->has_vnet_hdr) {
+	if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
 		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr);
 		if (err)
 			goto out_unlock;
@@ -3506,7 +3507,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	packet_rcv_try_clear_pressure(pkt_sk(sk));
 
-	if (pkt_sk(sk)->has_vnet_hdr) {
+	if (packet_sock_flag(pkt_sk(sk), PACKET_SOCK_HAS_VNET_HDR)) {
 		err = packet_rcv_vnet(msg, skb, &len);
 		if (err)
 			goto out_free;
@@ -4002,7 +4003,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
 			ret = -EBUSY;
 		} else {
-			po->has_vnet_hdr = !!val;
+			packet_sock_flag_set(po, PACKET_SOCK_HAS_VNET_HDR, val);
 			ret = 0;
 		}
 		release_sock(sk);
@@ -4136,7 +4137,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 		val = packet_sock_flag(po, PACKET_SOCK_ORIGDEV);
 		break;
 	case PACKET_VNET_HDR:
-		val = po->has_vnet_hdr;
+		val = packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR);
 		break;
 	case PACKET_VERSION:
 		val = po->tp_version;
diff --git a/net/packet/diag.c b/net/packet/diag.c
index 677d442cd930fe..a3bd91dba43945 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -27,7 +27,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
 		pinfo.pdi_flags |= PDI_AUXDATA;
 	if (packet_sock_flag(po, PACKET_SOCK_ORIGDEV))
 		pinfo.pdi_flags |= PDI_ORIGDEV;
-	if (po->has_vnet_hdr)
+	if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR))
 		pinfo.pdi_flags |= PDI_VNETHDR;
 	if (packet_sock_flag(po, PACKET_SOCK_TP_LOSS))
 		pinfo.pdi_flags |= PDI_LOSS;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 82a997824e5733..0956e4a934492d 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -118,7 +118,6 @@ struct packet_sock {
 	struct mutex		pg_vec_lock;
 	unsigned long		flags;
 	unsigned int		running;	/* bind_lock must be held */
-	unsigned int		has_vnet_hdr:1; /* writer must hold sock lock */
 	int			pressure;
 	int			ifindex;	/* bound device		*/
 	__be16			num;
@@ -146,6 +145,7 @@ enum packet_sock_flags {
 	PACKET_SOCK_AUXDATA,
 	PACKET_SOCK_TX_HAS_OFF,
 	PACKET_SOCK_TP_LOSS,
+	PACKET_SOCK_HAS_VNET_HDR,
 };
 
 static inline void packet_sock_flag_set(struct packet_sock *po,
-- 
2.53.0



