Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F5837473A;
	Tue, 21 Jul 2026 22:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671326; cv=none; b=lm4x035AvT1WPEQAVze8cNlfhtzX67Wo0I4G32xxXJ0gHjbJIsejBEt/Z7OZU1m/JhsythHCLhSWSayZRr/zKqGIHenLNMmvI12Vr8wdtoJXMYryUPTgqPf6U0iQtygH474Att47Pr0IIqWyFIrvzMMiRL4KAjSS5hKNQt9+E8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671326; c=relaxed/simple;
	bh=fs0GXkUBd9CBtig4eGQYqwA/t36vRa9jwIiEvNqx/cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8I/NVutmKEn4mw0ECG5eptsKyEMS4a0dZBbFjdG8BRlSugnYyD5rqXt5KW9baFmsHzKTZ4UK78mDfczuSjitn2TJNGf04I0jXz0Ilae4klSwYQeHKUiRSpI4XlF2l04IlcMyHWRg9e7ncQgKi8Ch6O3ALNxrGj/gTFQPJqdKec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXKdgpsp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXKdgpsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A836C1F000E9;
	Tue, 21 Jul 2026 22:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671324;
	bh=aOWZkIvBVE9z/ExCFxdmhEZPV9P9v4IiNNP27Di1h4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXKdgpsplNE0wEamIuSdR5NrA8XcPHj/lYg7QfDUudw3Cm71YSVETNNP9urnlvo6n
	 2wRvqSwC8Dfvf/gHydPf//a43L3Jz10G78ZwOh67rDS9np0OwMTPQco3XcaBWmcERl
	 iiXo6gOmmZWfW/q/qIAXcGS6EfauTc8uMJXZQuGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 202/843] net: dsa: tag_ksz: do not rely on skb_mac_header() in TX paths
Date: Tue, 21 Jul 2026 17:17:17 +0200
Message-ID: <20260721152410.559735204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 499b2491d550677b824b828ff431e4ef4d1d3b9d ]

skb_mac_header() will no longer be available in the TX path when
reverting commit 6d1ccff62780 ("net: reset mac header in
dev_start_xmit()"). As preparation for that, let's use skb_eth_hdr() to
get to the Ethernet header's MAC DA instead, helper which assumes this
header is located at skb->data (assumption which holds true here).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ sashal: adjusted for missing tail tag PRIO (FIELD_PREP) and PTP tail
  tag support in 5.15 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_ksz.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 00e4f40716dcbd..7c6c76254874aa 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -51,18 +51,18 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 static struct sk_buff *ksz8795_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct ethhdr *hdr;
 	u8 *tag;
-	u8 *addr;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
 		return NULL;
 
 	/* Tag encoding */
 	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(skb);
+	hdr = skb_eth_hdr(skb);
 
 	*tag = 1 << dp->index;
-	if (is_link_local_ether_addr(addr))
+	if (is_link_local_ether_addr(hdr->h_dest))
 		*tag |= KSZ8795_TAIL_TAG_OVERRIDE;
 
 	return skb;
@@ -119,8 +119,8 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct ethhdr *hdr;
 	__be16 *tag;
-	u8 *addr;
 	u16 val;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
@@ -128,11 +128,11 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 
 	/* Tag encoding */
 	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
-	addr = skb_mac_header(skb);
+	hdr = skb_eth_hdr(skb);
 
 	val = BIT(dp->index);
 
-	if (is_link_local_ether_addr(addr))
+	if (is_link_local_ether_addr(hdr->h_dest))
 		val |= KSZ9477_TAIL_TAG_OVERRIDE;
 
 	*tag = cpu_to_be16(val);
@@ -178,7 +178,7 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	u8 *addr;
+	struct ethhdr *hdr;
 	u8 *tag;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
@@ -186,11 +186,11 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 
 	/* Tag encoding */
 	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
-	addr = skb_mac_header(skb);
+	hdr = skb_eth_hdr(skb);
 
 	*tag = BIT(dp->index);
 
-	if (is_link_local_ether_addr(addr))
+	if (is_link_local_ether_addr(hdr->h_dest))
 		*tag |= KSZ9893_TAIL_TAG_OVERRIDE;
 
 	return skb;
-- 
2.53.0



