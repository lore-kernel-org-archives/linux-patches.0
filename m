Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FE735C684;
	Tue, 21 Jul 2026 21:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668658; cv=none; b=C6q6rwp8Y2z9WfIE+v/1InC5o//5zXOHb0BjKgkUd6dcGWaPFJ+SLX8eKsEdzAuQTIlomfrWcjlT6fBe/X9hLRi3b/kS+3pT8Hqb6xI7hB7srzmTk9wUn3OS5Wv7X0XkoEMxCBfwJtlS2P7PAe/RWUVqAT0S+ISuS3AlVj+E6xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668658; c=relaxed/simple;
	bh=hFVV7p0K9KNuEb/4lsfeGTO0rmEVZ6eW0V0s7cJsYvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDXkMoeohnlIXWVTfsYSpnbfkj8Q2YDchArAkvwEsBaIOxF6UUGfLtcoADpPGHT6M5WdXYRTCYSAj15eP5Iup/W2wwt0OPQSF89EmQYYHy4pibjOc7jgIX3CWAI6C8qtE+v8mdwVLskZFubin5/NYHWlcfwfV5JEUw8e2A2VhoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQ8UDzL+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQ8UDzL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E3B1F000E9;
	Tue, 21 Jul 2026 21:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668657;
	bh=XNEHCvtJdnnz3j2WE3E9Ft/YexmRY9zxGUgU9RYV0H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQ8UDzL+0d/JOmukKkk7R8u2JtA3YfA+nWHM8Y81IEv+kjXxoo2r01x7x4ZLGGnOC
	 1b4b0KCE1fToqC4HYh47z7NabsUogk2ZyN6c9eIWcGrv/ArbXni9j+CRm97+juafY+
	 D6u/g2x6+UgtPGAJCxiYR0QUg6ejT4EPFTzDu5dc=
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
Subject: [PATCH 6.1 0259/1067] net: dsa: tag_ksz: do not rely on skb_mac_header() in TX paths
Date: Tue, 21 Jul 2026 17:14:20 +0200
Message-ID: <20260721152430.392523751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
[ sashal: adjusted context in ksz9477_xmit() and ksz9893_xmit() for
  missing tail tag PRIO support in 6.1 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_ksz.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index d58bcd16d597d6..459f688cdbf898 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -50,18 +50,18 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
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
@@ -118,8 +118,8 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct ethhdr *hdr;
 	__be16 *tag;
-	u8 *addr;
 	u16 val;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
@@ -127,11 +127,11 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 
 	/* Tag encoding */
 	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
-	addr = skb_mac_header(skb);
+	hdr = skb_eth_hdr(skb);
 
 	val = BIT(dp->index);
 
-	if (is_link_local_ether_addr(addr))
+	if (is_link_local_ether_addr(hdr->h_dest))
 		val |= KSZ9477_TAIL_TAG_OVERRIDE;
 
 	*tag = cpu_to_be16(val);
@@ -177,7 +177,7 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	u8 *addr;
+	struct ethhdr *hdr;
 	u8 *tag;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL && skb_checksum_help(skb))
@@ -185,11 +185,11 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 
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



