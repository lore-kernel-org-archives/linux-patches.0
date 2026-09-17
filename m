Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301104DDB59;
	Thu, 17 Sep 2026 15:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659297; cv=none; b=FuQl4g8Qxx+r8Bm8kJX4IxhlHYbP+OxWjAgE5S9aZ6nX2SR7fHwhFfSlD63MjGTAumHpnFVpxFoAAGd6rolCglz4xmH4NIFvV2FUCdNW7CyzfuENKjbnNOpNuU7OnygmFYSeAU5ivwoFzwXW65iulY+tiH0bpLBR++D8xVCFl/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659297; c=relaxed/simple;
	bh=RbQWIC2uHuDdm3ePXqyKHyotIDX5Y76m0yzkpHsZzQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gD7QlNmTPteiWhKUcQR9NJp6d1ofDLSXdcFNX9NlEdzmg/4DYzyHtQzFW+r6t+V1igjquiEQ7G7oVyeQYP0ldTyWqWrnw0YQL3cW7pZEpUdLarVpTtiwT+XdbafLxsC5ZwGImQYcfQVfdsmtq9JKyEMPMQo5QTxxZD5u0bXvQPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvlX0W2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvlX0W2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0344E1F00899;
	Thu, 17 Sep 2026 15:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659282;
	bh=vpF6PiRpMATSJ2Y1tV7fGQQ/PhLpiYqRwGMrUmkTrd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvlX0W2hUGaHNF/njc4+otZXxOkkzzV+wVNZTNCoP/6QkUciQMSKyyL1a4pqU8La6
	 Bpajwxvb7wcLBO/uEGuQ7Rd+SeHb7tEOpGGgN/W7EXO6l5Nyq4xGPUbHbLi/5hSiO9
	 AWUVRF5p+yp+LXd5znoyYM5e7J4GPfkUAl50dNk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 166/733] bonding: alb: fix uninitialized transport header access in alb_determine_nd()
Date: Thu, 17 Sep 2026 16:07:54 +0100
Message-ID: <20260917151355.226755804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d2fb67a47cf99..654f051d00239 100644
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



