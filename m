Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69289227B94;
	Sun,  7 Jun 2026 10:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827063; cv=none; b=rV1Ki/MEP6D4pf+k++l+URb+XLQvKSoiX7ePKG9g61u7ate82UjbFmvaadJVNWRFuMSLVfyZbXoawxRAknlarRiqYyc0QCs6hoUF31CPq+hdf5ggmzeWdzPTbD9xOsQfjvBIXxPznaPclXadyvjDb1QyhVVUnqocQQ06GAkuwqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827063; c=relaxed/simple;
	bh=bYdFnlf4Tld1buFLNorgjpNTVKq0kpsPRCr395wQ2Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4Kg8QiAYvD2RYAb/YeCfe82n9KXCa6Zbb3Ue79o5DP1xjoL0G/jxromuAU7FjAYMWEukcVQdKV2gSKU8cvr6CNuCmnaq2zxHIJo5aJR9JxO/Vp7jkLDYrJ6PFVKHdqvM34Nke+7zHweZyYaB9y9/OQJPeCPK0Uu1tXtzUvygH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xm8Ll7CM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xm8Ll7CM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720111F00893;
	Sun,  7 Jun 2026 10:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827062;
	bh=05cLO3whbTPZ8mfsqZbpemhig+9Dx/31EDxOXzuaIgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xm8Ll7CMXEgASxw6T1A3Pn1uMfAOpvCIL1abBTGFljFoorREH2X2qIidKlR+IGxwG
	 vct2XKOBzyoQkgGqfdW7X+mrqPywweAWRWR6ZW877UwLTIZ5wgJe1YrctKZL0o5lXn
	 uPav+r57YxnR5ouTdNj+lXnGR/snwlANwLGsY3GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stefano Brivio <sbrivio@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 059/332] vxlan: do not reuse cached ip_hdr() value after skb_tunnel_check_pmtu()
Date: Sun,  7 Jun 2026 11:57:08 +0200
Message-ID: <20260607095730.297954946@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index a94ac82a613649..0cc3b34add5eb4 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2534,7 +2534,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto out_unlock;
 		}
 
-		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos = ip_tunnel_ecn_encap(tos, ip_hdr(skb), skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct iphdr),
 				      vni, md, flags, udp_sum);
@@ -2608,7 +2608,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			goto out_unlock;
 		}
 
-		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
+		tos = ip_tunnel_ecn_encap(tos, ip_hdr(skb), skb);
 		ttl = ttl ? : ip6_dst_hoplimit(ndst);
 		skb_scrub_packet(skb, xnet);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct ipv6hdr),
-- 
2.53.0



