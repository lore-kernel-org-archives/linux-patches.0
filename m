Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D28332EA7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301234; cv=none; b=gPkeCOshK9gHJs6mS5OiWccE2Rewf4nnyb+uyPdwUMUhQRp3QWeN9w/X3XO1RBmC2W5W4nYxEjP17ZLx/DB8OJRoKs7YpfW3cJwf5Wt/ggRDIf2K4eZcbZ4K4TMnjFlXEzLO7OxQQwv86mvlCsq7vKKicS1ZXFMcHxr3rJ2CUks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301234; c=relaxed/simple;
	bh=Jb5ywi24OQ8pNIhxv/M9crNwVllSRmKpFUIzwjBM088=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2r480Ub8ADbzH4AqDMWAq8MucGHXSFCH25wiPh5TMxDZyq9DJjjJ5Oaz/mnYGRCJJcH5aEaVWOhOWLsOZTQC1pFwLRsHgpIYxEFgTv8vu77ds21uZu+30mKf0Vlf5fVqGVwowB+IwHvBBXQ45zyJ4N2vW4Xjjr1beRtzikAnrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m50ijqee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m50ijqee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E72C116D0;
	Sat, 28 Feb 2026 17:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301234;
	bh=Jb5ywi24OQ8pNIhxv/M9crNwVllSRmKpFUIzwjBM088=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m50ijqeeDzECs61XTe9A2/AMK3ReocGAEPAAYEANVQj4Ke+9ipWot0P8k0ZRqdt72
	 g/DpmwhwdKxhG5otj0WNStUL5WcEjSlXvibqJgD48CfyzK1gVrfvvVA+T7wm8RDMer
	 lGUMVVfA7nSpUIGtZygy+kBfTAMIalHxeDjh2ChOE4XZkA0qHE1ADULEUCnmy3NNnd
	 C6fESXR0OuXwjfMjj5KI6rEmnoLWk5Tij1w4GBG2EgZaJx5bNRSjzDcL/SSvPTncwb
	 VCQBSvcA5i7NGxf2yhJ1dIlVvFtQwmdUOe0jP4N9RyqeQLbe8blHk22DdJ6nKEidmX
	 /ab9kElmDv7Kw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 413/752] ovpn: tcp - fix packet extraction from stream
Date: Sat, 28 Feb 2026 12:42:04 -0500
Message-ID: <20260228174750.1542406-413-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit d4f687fbbce45b5e88438e89b5e26c0c15847992 ]

When processing TCP stream data in ovpn_tcp_recv, we receive large
cloned skbs from __strp_rcv that may contain multiple coalesced packets.
The current implementation has two bugs:

1. Header offset overflow: Using pskb_pull with large offsets on
   coalesced skbs causes skb->data - skb->head to exceed the u16 storage
   of skb->network_header. This causes skb_reset_network_header to fail
   on the inner decapsulated packet, resulting in packet drops.

2. Unaligned protocol headers: Extracting packets from arbitrary
   positions within the coalesced TCP stream provides no alignment
   guarantees for the packet data causing performance penalties on
   architectures without efficient unaligned access. Additionally,
   openvpn's 2-byte length prefix on TCP packets causes the subsequent
   4-byte opcode and packet ID fields to be inherently misaligned.

Fix both issues by allocating a new skb for each openvpn packet and
using skb_copy_bits to extract only the packet content into the new
buffer, skipping the 2-byte length prefix. Also, check the length before
invoking the function that performs the allocation to avoid creating an
invalid skb.

If the packet has to be forwarded to userspace the 2-byte prefix can be
pushed to the head safely, without misalignment.

As a side effect, this approach also avoids the expensive linearization
that pskb_pull triggers on cloned skbs with page fragments. In testing,
this resulted in TCP throughput improvements of up to 74%.

Fixes: 11851cbd60ea ("ovpn: implement TCP transport")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/tcp.c | 53 ++++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ovpn/tcp.c b/drivers/net/ovpn/tcp.c
index ec2bbc28c1966..5499c1572f3e2 100644
--- a/drivers/net/ovpn/tcp.c
+++ b/drivers/net/ovpn/tcp.c
@@ -70,37 +70,56 @@ static void ovpn_tcp_to_userspace(struct ovpn_peer *peer, struct sock *sk,
 	peer->tcp.sk_cb.sk_data_ready(sk);
 }
 
-static void ovpn_tcp_rcv(struct strparser *strp, struct sk_buff *skb)
+static struct sk_buff *ovpn_tcp_skb_packet(const struct ovpn_peer *peer,
+					   struct sk_buff *orig_skb,
+					   const int pkt_len, const int pkt_off)
 {
-	struct ovpn_peer *peer = container_of(strp, struct ovpn_peer, tcp.strp);
-	struct strp_msg *msg = strp_msg(skb);
-	size_t pkt_len = msg->full_len - 2;
-	size_t off = msg->offset + 2;
-	u8 opcode;
+	struct sk_buff *ovpn_skb;
+	int err;
 
-	/* ensure skb->data points to the beginning of the openvpn packet */
-	if (!pskb_pull(skb, off)) {
-		net_warn_ratelimited("%s: packet too small for peer %u\n",
-				     netdev_name(peer->ovpn->dev), peer->id);
+	/* create a new skb with only the content of the current packet */
+	ovpn_skb = netdev_alloc_skb(peer->ovpn->dev, pkt_len);
+	if (unlikely(!ovpn_skb))
 		goto err;
-	}
 
-	/* strparser does not trim the skb for us, therefore we do it now */
-	if (pskb_trim(skb, pkt_len) != 0) {
-		net_warn_ratelimited("%s: trimming skb failed for peer %u\n",
+	skb_copy_header(ovpn_skb, orig_skb);
+	err = skb_copy_bits(orig_skb, pkt_off, skb_put(ovpn_skb, pkt_len),
+			    pkt_len);
+	if (unlikely(err)) {
+		net_warn_ratelimited("%s: skb_copy_bits failed for peer %u\n",
 				     netdev_name(peer->ovpn->dev), peer->id);
+		kfree_skb(ovpn_skb);
 		goto err;
 	}
 
-	/* we need the first 4 bytes of data to be accessible
+	consume_skb(orig_skb);
+	return ovpn_skb;
+err:
+	kfree_skb(orig_skb);
+	return NULL;
+}
+
+static void ovpn_tcp_rcv(struct strparser *strp, struct sk_buff *skb)
+{
+	struct ovpn_peer *peer = container_of(strp, struct ovpn_peer, tcp.strp);
+	struct strp_msg *msg = strp_msg(skb);
+	int pkt_len = msg->full_len - 2;
+	u8 opcode;
+
+	/* we need at least 4 bytes of data in the packet
 	 * to extract the opcode and the key ID later on
 	 */
-	if (!pskb_may_pull(skb, OVPN_OPCODE_SIZE)) {
+	if (unlikely(pkt_len < OVPN_OPCODE_SIZE)) {
 		net_warn_ratelimited("%s: packet too small to fetch opcode for peer %u\n",
 				     netdev_name(peer->ovpn->dev), peer->id);
 		goto err;
 	}
 
+	/* extract the packet into a new skb */
+	skb = ovpn_tcp_skb_packet(peer, skb, pkt_len, msg->offset + 2);
+	if (unlikely(!skb))
+		goto err;
+
 	/* DATA_V2 packets are handled in kernel, the rest goes to user space */
 	opcode = ovpn_opcode_from_skb(skb, 0);
 	if (unlikely(opcode != OVPN_DATA_V2)) {
@@ -113,7 +132,7 @@ static void ovpn_tcp_rcv(struct strparser *strp, struct sk_buff *skb)
 		/* The packet size header must be there when sending the packet
 		 * to userspace, therefore we put it back
 		 */
-		skb_push(skb, 2);
+		*(__be16 *)__skb_push(skb, sizeof(u16)) = htons(pkt_len);
 		ovpn_tcp_to_userspace(peer, strp->sk, skb);
 		return;
 	}
-- 
2.51.0

