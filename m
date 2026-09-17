Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FB74CDDFE;
	Thu, 17 Sep 2026 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665428; cv=none; b=u3UDKkJKRhEfd/MrOiqRCJPeqiTdWw8TEDuHYL4Ny29+8cwInSrXmLun4x3MkR6TO9qbvxb5GSB4oNnxoJr/ol/u/uGSpjMLGHJbredg+9JCc2YiZAOHQ/4oRK8p92CprZs6G7R87gPWN8JM3JQkBicYYwZ75c7sT81je2JSz9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665428; c=relaxed/simple;
	bh=SVAUOKDtbenfPau40qmTulRd/RrnN13v4UB5Z3e9hRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZV6wZGEI8hg946yOrC7biXEQxCLbN22Q47jc1xVHDjI/SQxDrVkKZUpwIO5ZmE43wkXPYM5yaVKyAN6Hdhfj2FPyasTA9hfV+fFtqx9x5uBs1K2wSpc0y9EvqgjlTlzWGNkgNSfmHGTIb04Mua93t6tKG+1k81NTMBLx7/96y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcf1HTRu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcf1HTRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75FB1F000FF;
	Thu, 17 Sep 2026 17:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665427;
	bh=su9i9XRMF1jAtOjgOth/Ygx/6VM2LKFJio4d086MI9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcf1HTRuzvyhmWHcIeGwRY4gvtQjgYE0zdJ9k+SVGucAEMkY0W/LLPU1zQWkJQnMN
	 dLF4R/gW+AjGGpDGp/H6w/3ZfpzKPEkrBHLnTRGxSoDa05+LHDi1QILwz5upCIT+1y
	 CPqLmXayOCQpUBuTjeXSl9ZyM2UTo+a2wNeCfRwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0702/1250] bonding: alb: fix uninitialized transport header access in alb_determine_nd()
Date: Thu, 17 Sep 2026 16:08:17 +0100
Message-ID: <20260917151610.922319072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 70f3995830d3f1e79faa14eb0605914f778feca9 ]

alb_determine_nd() uses icmp6_hdr(skb) to inspect ICMPv6 headers.
However, in xmit paths (e.g. packets sent via AF_PACKET / raw sockets
or forwarded packets), skb->transport_header is not guaranteed to be
initialized. While pskb_network_may_pull() ensures the packet data is
linear starting from the network header, it does not set or adjust the
transport header offset.

Dereferencing icmp6_hdr(skb) can therefore access out-of-bounds memory.

Fetch the icmp6hdr directly after ipv6hdr following pskb_network_may_pull(),
and reload ipv6hdr in case pskb_may_pull() reallocated skb->head.
Also remove the unused bond argument from alb_determine_nd().

Fixes: 0da8aa00bfcf ("net: bonding: Add support for IPV6 ns/na to balance-alb/balance-tlb mode")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260831194626.119371-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_alb.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 839f7482dc182..5073aeeba6c97 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1281,10 +1281,10 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
 }
 
 /* determine if the packet is NA or NS */
-static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
+static bool alb_determine_nd(struct sk_buff *skb)
 {
-	struct ipv6hdr *ip6hdr;
-	struct icmp6hdr *hdr;
+	const struct ipv6hdr *ip6hdr;
+	const struct icmp6hdr *hdr;
 
 	if (!pskb_network_may_pull(skb, sizeof(*ip6hdr)))
 		return true;
@@ -1296,7 +1296,8 @@ static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
 	if (!pskb_network_may_pull(skb, sizeof(*ip6hdr) + sizeof(*hdr)))
 		return true;
 
-	hdr = icmp6_hdr(skb);
+	ip6hdr = ipv6_hdr(skb);
+	hdr = (const struct icmp6hdr *)(ip6hdr + 1);
 	return hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
 		hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION;
 }
@@ -1381,7 +1382,7 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
 	if (!is_multicast_ether_addr(eth_data->h_dest)) {
 		switch (skb->protocol) {
 		case htons(ETH_P_IPV6):
-			if (alb_determine_nd(skb, bond))
+			if (alb_determine_nd(skb))
 				break;
 			fallthrough;
 		case htons(ETH_P_IP):
@@ -1467,7 +1468,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 			break;
 		}
 
-		if (alb_determine_nd(skb, bond)) {
+		if (alb_determine_nd(skb)) {
 			do_tx_balance = false;
 			break;
 		}
-- 
2.53.0



