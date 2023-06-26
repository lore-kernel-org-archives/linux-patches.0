Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0348C8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0A0C433C9;
	Mon, 26 Jun 2023 18:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687805007;
	bh=1UEem9+E1Ke7px4AOB820028SD0me/udWEw4Cncwyn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0MngFFRqsO7kX+ZeZ6Ccymkpo7HTV9Oe197jMu64wAXckegDm0EKJ+e4Xp3oVvyE
	 PURk6dRrCpGp4JAt/KdRA85+DDqJiPNQMbRwlMra6x9yXRT+oWkm1BpOq88XeUExRg
	 BuXZ0FSnnpPsxmbJhcddzFH/FMEvo7Lpt3OSshcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias May <matthias.may@westermo.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH 5.10 19/81] ip_tunnels: allow VXLAN/GENEVE to inherit TOS/TTL from VLAN
Date: Mon, 26 Jun 2023 20:12:01 +0200
Message-ID: <20230626180745.256990713@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
References: <20230626180744.453069285@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthias May <matthias.may@westermo.com>

commit 7074732c8faee201a245a6f983008a5789c0be33 upstream.

The current code allows for VXLAN and GENEVE to inherit the TOS
respective the TTL when skb-protocol is ETH_P_IP or ETH_P_IPV6.
However when the payload is VLAN encapsulated, then this inheriting
does not work, because the visible skb-protocol is of type
ETH_P_8021Q or ETH_P_8021AD.

Instead of skb->protocol use skb_protocol().

Signed-off-by: Matthias May <matthias.may@westermo.com>
Link: https://lore.kernel.org/r/20220721202718.10092-1-matthias.may@westermo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip_tunnels.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -378,9 +378,11 @@ static inline int ip_tunnel_encap(struct
 static inline u8 ip_tunnel_get_dsfield(const struct iphdr *iph,
 				       const struct sk_buff *skb)
 {
-	if (skb->protocol == htons(ETH_P_IP))
+	__be16 payload_protocol = skb_protocol(skb, true);
+
+	if (payload_protocol == htons(ETH_P_IP))
 		return iph->tos;
-	else if (skb->protocol == htons(ETH_P_IPV6))
+	else if (payload_protocol == htons(ETH_P_IPV6))
 		return ipv6_get_dsfield((const struct ipv6hdr *)iph);
 	else
 		return 0;
@@ -389,9 +391,11 @@ static inline u8 ip_tunnel_get_dsfield(c
 static inline u8 ip_tunnel_get_ttl(const struct iphdr *iph,
 				       const struct sk_buff *skb)
 {
-	if (skb->protocol == htons(ETH_P_IP))
+	__be16 payload_protocol = skb_protocol(skb, true);
+
+	if (payload_protocol == htons(ETH_P_IP))
 		return iph->ttl;
-	else if (skb->protocol == htons(ETH_P_IPV6))
+	else if (payload_protocol == htons(ETH_P_IPV6))
 		return ((const struct ipv6hdr *)iph)->hop_limit;
 	else
 		return 0;


