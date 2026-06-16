Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AEF4657D0;
	Tue, 16 Jun 2026 17:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630425; cv=none; b=KldEO2DVw5eFFO5ggAByZ5BBoQoq96tP0yXrQ5h6wdlJIFBSVeyI50t49ZuG1rro3KoH31zaWCQfQ7Wfz+0MCrBthPn0zIHtWawY0sS5lV7WDBOM+muFLz/heKqsgkrcRiaboSkY7lLEnsdOLNG9S3apZNTpQ1zLhBB7H+WyOAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630425; c=relaxed/simple;
	bh=nUUW1BrB1qUpNRrHpELDfMsh0bNMr2E6Weu2Ozm28j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecnZ/cr6dkuYZIODiLm+Ta6C6bDhF7u/GD30BDnIpqNmc858wBrghmgn/pk+N3M25xy6R2RosMnZEI/nquIV+RfLej68IIh9KOLUBhJIpfnqdZcbX0MqPTwipC2pNC7bzA1YQ2UesI49aC4YRUmN7t0oUXMhb6vCh5JjI7So0mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V38WbEIP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V38WbEIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7D41F000E9;
	Tue, 16 Jun 2026 17:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630424;
	bh=3encwpfr5YGPRcV2otxd53se654vjHMPHTxpg7VyqOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V38WbEIPTilW5LUepINbGAKUk1t+BxKshVWZJ5j3c18svekXzhWPpVa27SF5wggiZ
	 Bu2k1+WWwFRnZf0nX7A67ZCRKbwmfuso7UTlqaJhEbrFx1I/g6o2YYK3hgLdYPdSeJ
	 oEM2MnRuxFjtwGEOq2hHe+0x3EHZUI17pg4kNjKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/522] vxlan: do not reuse cached ip_hdr() value after skb_tunnel_check_pmtu()
Date: Tue, 16 Jun 2026 20:22:53 +0530
Message-ID: <20260616145126.856380893@linuxfoundation.org>
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

[ Upstream commit 7d9ef0cb271555d8cf39fefe6c981e1493b25ecf ]

skb_tunnel_check_pmtu() can change skb->head.

Reusing old_iph afer skb_tunnel_check_pmtu() can cause an UAF.

Use instead ip_hdr(skb) as done in drivers/net/bareudp.c
and drivers/net/geneve.c.

Found by Sashiko.

Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Link: https://patch.msgid.link/20260525203642.2389723-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 6ad59c8afdcfc1..9d7ebf8aa79f66 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2682,7 +2682,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto out_unlock;
 		}
 
-		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos = ip_tunnel_ecn_encap(tos, ip_hdr(skb), skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct iphdr),
 				      vni, md, flags, udp_sum);
@@ -2745,7 +2745,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto out_unlock;
 		}
 
-		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos = ip_tunnel_ecn_encap(tos, ip_hdr(skb), skb);
 		ttl = ttl ? : ip6_dst_hoplimit(ndst);
 		skb_scrub_packet(skb, xnet);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct ipv6hdr),
-- 
2.53.0



