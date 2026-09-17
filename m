Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8B13921DC;
	Thu, 17 Sep 2026 18:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668953; cv=none; b=l1Neg9UZLPlQQAaC7ZHHK6nETngS3DrUuZ7nzBqXPPv3BWzb/2jzjjBJXa4bY26CcrrN929+x/UHKkSvOxDgF7VonkE1Ox14SoKmCUEFlTZjcPcQjrBvhHvoirDyXcfP/KKgEmUpQHHM/NpUI8qAEy2D7H02PBI6abMdhN2CnYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668953; c=relaxed/simple;
	bh=PtkzS4ht/3rxFHzAAxvwp316EMGkLYwYnHj51mfZjvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/3DiwqxLEdNvHJvaqeqW6MSUBAqYvcp6numSTF1AoAsclSd6bAPRyeEEDGnup+KC7HFZTG/v4tYL7i8FDByYdHFGNu9s7qANlwrtYK+dxbzXjSbY1p+BBg2njYPPQQM5Rc6tLvqW7UZCwdqb+9x/gbr7dbo95s6uz/oGq+6Rbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gASa9e+R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gASa9e+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF391F000FF;
	Thu, 17 Sep 2026 18:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668952;
	bh=J/qXGUJbM6IRzHhZUBr2Uur8cr6OHx1O8+6dXlGBYDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gASa9e+RclqNCAR52akevqavU+yBkADNZltvePXBhSneG57GYsNpfDfyWA/VVTU2l
	 psS0mvAAIRI1wG0HtAhqm0V02l5DxPRE9jcZI59s8yCyfHslkp+WRZsyaflIYicy0Z
	 INFa4hVo/va8srNOQ/c2dBoXf5Y1Bamh3eP4X5Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0593/1102] bonding: alb: fix uninitialized transport header access in alb_determine_nd()
Date: Thu, 17 Sep 2026 16:08:56 +0100
Message-ID: <20260917151554.864079270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ce6a3a0a2e153..5a7148c515c21 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1282,10 +1282,10 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
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
@@ -1297,7 +1297,8 @@ static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
 	if (!pskb_network_may_pull(skb, sizeof(*ip6hdr) + sizeof(*hdr)))
 		return true;
 
-	hdr = icmp6_hdr(skb);
+	ip6hdr = ipv6_hdr(skb);
+	hdr = (const struct icmp6hdr *)(ip6hdr + 1);
 	return hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
 		hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION;
 }
@@ -1382,7 +1383,7 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
 	if (!is_multicast_ether_addr(eth_data->h_dest)) {
 		switch (skb->protocol) {
 		case htons(ETH_P_IPV6):
-			if (alb_determine_nd(skb, bond))
+			if (alb_determine_nd(skb))
 				break;
 			fallthrough;
 		case htons(ETH_P_IP):
@@ -1468,7 +1469,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 			break;
 		}
 
-		if (alb_determine_nd(skb, bond)) {
+		if (alb_determine_nd(skb)) {
 			do_tx_balance = false;
 			break;
 		}
-- 
2.53.0



