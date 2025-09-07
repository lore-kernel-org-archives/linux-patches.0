Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9015D27FB21;
	Sun,  7 Sep 2025 20:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275870; cv=none; b=q/XOXRXgYdjWIdmcURpm38WdHQNRJqz7Kpbzm9U2v2eFs0Gybd64wCzjHYDb29T0NWCFJjxqyn7uWYPv2pofBQ0dHrfJQ1ZRFFKP5vcyTRNo0gDs/lKF2g8Hi6n/TAJijX5woHKPbioT0djmLmJzUrGkj5Q1d/58AtoYehV5970=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275870; c=relaxed/simple;
	bh=yGsoDEdZsIaAYp+W5afWhePvo1zDxLgxI4RJkZxgqtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAC10vLCQFZKasuZULoJSuXusblYBijM3GO2ueoswSjIi5uL5rGB/B3FRecDHOa6rg1tWaLYPuzBArlqDrClmbyt5qT00lWpwVnt4ftPR7gcC4SPN9gGyPqj+fDyR9OWgzR67j4ZI9PKcTdLqfg1u+C4coKTn5M//pH0XAIrr4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sS7zHCTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sS7zHCTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3431C4CEF0;
	Sun,  7 Sep 2025 20:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275870;
	bh=yGsoDEdZsIaAYp+W5afWhePvo1zDxLgxI4RJkZxgqtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sS7zHCTdCyvBfadW/naeFsFAnqAj0ZypJ4GhTQ23KfNjlwOAxQAuwa/+dZ7Wrz0l+
	 zxE7vYnYBY9sVQ5mDg92ajDEL1Jej0sh+byHtnV7xoJriVJBNIgVReAHamgZrnPNDL
	 uUlCG/LzuMrcBinpclbW14AuUn6NPNQ6Prc3OHxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/45] net: dsa: microchip: linearize skb for tail-tagging switches
Date: Sun,  7 Sep 2025 21:58:21 +0200
Message-ID: <20250907195602.006991306@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakob Unterwurzacher <jakobunt@gmail.com>

[ Upstream commit ba54bce747fa9e07896c1abd9b48545f7b4b31d2 ]

The pointer arithmentic for accessing the tail tag only works
for linear skbs.

For nonlinear skbs, it reads uninitialized memory inside the
skb headroom, essentially randomizing the tag. I have observed
it gets set to 6 most of the time.

Example where ksz9477_rcv thinks that the packet from port 1 comes from port 6
(which does not exist for the ksz9896 that's in use), dropping the packet.
Debug prints added by me (not included in this patch):

	[  256.645337] ksz9477_rcv:323 tag0=6
	[  256.645349] skb len=47 headroom=78 headlen=0 tailroom=0
	               mac=(64,14) mac_len=14 net=(78,0) trans=78
	               shinfo(txflags=0 nr_frags=1 gso(size=0 type=0 segs=0))
	               csum(0x0 start=0 offset=0 ip_summed=0 complete_sw=0 valid=0 level=0)
	               hash(0x0 sw=0 l4=0) proto=0x00f8 pkttype=1 iif=3
	               priority=0x0 mark=0x0 alloc_cpu=0 vlan_all=0x0
	               encapsulation=0 inner(proto=0x0000, mac=0, net=0, trans=0)
	[  256.645377] dev name=end1 feat=0x0002e10200114bb3
	[  256.645386] skb headroom: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	[  256.645395] skb headroom: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	[  256.645403] skb headroom: 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	[  256.645411] skb headroom: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	[  256.645420] skb headroom: 00000040: ff ff ff ff ff ff 00 1c 19 f2 e2 db 08 06
	[  256.645428] skb frag:     00000000: 00 01 08 00 06 04 00 01 00 1c 19 f2 e2 db 0a 02
	[  256.645436] skb frag:     00000010: 00 83 00 00 00 00 00 00 0a 02 a0 2f 00 00 00 00
	[  256.645444] skb frag:     00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01
	[  256.645452] ksz_common_rcv:92 dsa_conduit_find_user returned NULL

Call skb_linearize before trying to access the tag.

This patch fixes ksz9477_rcv which is used by the ksz9896 I have at
hand, and also applies the same fix to ksz8795_rcv which seems to have
the same problem.

Signed-off-by: Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>
CC: stable@vger.kernel.org
Fixes: 016e43a26bab ("net: dsa: ksz: Add KSZ8795 tag code")
Fixes: 8b8010fb7876 ("dsa: add support for Microchip KSZ tail tagging")
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20250515072920.2313014-1-jakob.unterwurzacher@cherry.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/tag_ksz.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -115,7 +115,12 @@ static struct sk_buff *ksz8795_xmit(stru
 static struct sk_buff *ksz8795_rcv(struct sk_buff *skb, struct net_device *dev,
 				  struct packet_type *pt)
 {
-	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
+	u8 *tag;
+
+	if (skb_linearize(skb))
+		return NULL;
+
+	tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
 
 	return ksz_common_rcv(skb, dev, tag[0] & 7, KSZ_EGRESS_TAG_LEN);
 }
@@ -184,10 +189,16 @@ static struct sk_buff *ksz9477_xmit(stru
 static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev,
 				   struct packet_type *pt)
 {
-	/* Tag decoding */
-	u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
-	unsigned int port = tag[0] & KSZ9477_TAIL_TAG_EG_PORT_M;
 	unsigned int len = KSZ_EGRESS_TAG_LEN;
+	unsigned int port;
+	u8 *tag;
+
+	if (skb_linearize(skb))
+		return NULL;
+
+	/* Tag decoding */
+	tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
+	port = tag[0] & KSZ9477_TAIL_TAG_EG_PORT_M;
 
 	/* Extra 4-bytes PTP timestamp */
 	if (tag[0] & KSZ9477_PTP_TAG_INDICATION)


