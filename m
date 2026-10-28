Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215933;
	b=5YaJwgCbDRchEDxEpj1P5u3jtPbePWhxkRMxb7mQ5MG12jPyfPVZ3xMmWkBsqF1T0NqI
	 Cq7h/1BrXEyNyvm+emSjRchAKqWlWOEeq5zuYeLblSiBNinnojEOXEIW1kv6O+mK78ox0
	 /zdtX5TQfpTtq7uBa9usH4OHCOgGB+aVcmrvIwz7aSRdx26mR9cimj7b3dsLSrAJo9gbx
	 96IxmyScE1T8ocInzl9BlAFO2L2dvzOj9VnnxFhMIoKeMyZfE9dE9JGVZokJ8PRS5b8bK
	 4cs4wxlPcy8RzIk9yUUxbBboG4drnaUzDCcJOiUbDjxJ2snsoy+v/lbcBSmUZW2RUVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=owtfIbZjto+YiQqMivfccjdQJiWGvYSpx8q1NlPwMbc=;
	b=4kfYL1u0MIH1jy+cNgYZKo9n5ljFvqJgrDTGURVqEpjOyLPVF/jhIGR9dcG/p911QMNC
	 eF8NCEBBW3ROuEJIZ3M5ZM+jHhkhTKc2ch23phBe0mrWzcyuLBMLCDhekkKWiFMwsGFKO
	 XReZeQfEou7szPME9S+aC5tK7qqmkZ6rFlSNH7fhj/KI4GaBdT/geOeYjVt9oP4ghg/0M
	 LaNY3C/CKgPOUNcSUwz40TekiAeBHy8jzvXn50ijHK90zTZ/oFxBeEPTpTuxrvncsgZpP
	 cVoZqMBTys3YP184rSwIkilNsgkqq3ylkS0WH8hCoTMRPm8/NSRPqaobSLbbJERzXeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=js5ElzO9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FA2606A31E;
	Wed, 28 Oct 2026 19:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=js5ElzO9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24AD1F01825;
	Wed, 28 Oct 2026 19:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215933;
	bh=owtfIbZjto+YiQqMivfccjdQJiWGvYSpx8q1NlPwMbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=js5ElzO9QlRtWrZAs6/6SZtkiuKI+k3RySq6FoOaWRLdIm3YqRPjrTHpgtA41u/Ad
	 9Pvc4ZZa+ClSZnb+DDqq8qwn7tZnluYoNsgHMP/jMgI49y1Obe3aDwIOzX0IiPd8lu
	 FHULevmTPrkOtYZlKfZLz5aXJxuoOGnhGJYvZ1aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tangxin Xie <xietangxin@h-partners.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1366/1887] vlan: fix skb_under_panic and races when toggling HW VLAN offload
Date: Wed, 28 Oct 2026 17:57:42 +0100
Message-ID: <20261028170530.530889907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 447cbe95ebb95392b5d8f6a01c0556826919ce23 ]

Toggling hardware VLAN TX offload (NETIF_F_HW_VLAN_CTAG_TX or
NETIF_F_HW_VLAN_STAG_TX) on a lower device invokes vlan_transfer_features(),
which dynamically changed vlandev->hard_header_len.

This causes two issues:
1. Lockless TX paths (e.g. packet_snd in af_packet.c, ip6_finish_output2)
   read dev->hard_header_len without holding RTNL lock. Mutating
   hard_header_len dynamically under RTNL creates a data race where upper
   layers reserve insufficient headroom based on a stale hard_header_len,
   resulting in skb_under_panic when vlan_dev_hard_header() is called.
2. In addition, vlan_transfer_features() updated hard_header_len without
   updating header_ops, causing a mismatch between allocated headroom
   and header creation.

Always setting dev->hard_header_len = real_dev->hard_header_len and
dev->needed_headroom = real_dev->needed_headroom + VLAN_HLEN unconditionally
ensures:
- dev->hard_header_len remains 100% static and immutable at real_dev->hard_header_len,
  eliminating all dynamic runtime updates and data races on hard_header_len.
- Upper layers allocating skbs via LL_RESERVED_SPACE() will always reserve
  sufficient headroom for software VLAN tag insertion (real_dev->hard_header_len +
  real_dev->needed_headroom + VLAN_HLEN).
- vlandev inherits real_dev->needed_tailroom so underlying trailer/padding/ICV
  requirements are honored.
- AF_PACKET SOCK_RAW network header offsets remain correctly aligned at
  real_dev->hard_header_len.
- vlan_header_ops is used unconditionally.

Note to stable teams: Make sure to backport these commits:

e16e960d55a4 ("ipvlan: inherit needed_headroom and needed_tailroom from phy_dev")
cef51860becd ("macvlan: inherit needed_headroom and needed_tailroom from lowerdev")

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Tangxin Xie <xietangxin@h-partners.com>
Closes: https://lore.kernel.org/netdev/99d678ae-c7b2-4b44-b534-b8320679deb3@h-partners.com/
Cc: <stable@vger.kernel.org> # 3.19: e16e960d55a4: ipvlan: inherit needed_headroom and needed_tailroom from phy_dev
Cc: <stable@vger.kernel.org> # 3.19: cef51860becd: macvlan: inherit needed_headroom and needed_tailroom from lowerdev
Cc: <stable@vger.kernel.org> # 3.19
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260811085246.2267779-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan.c     |  7 +++----
 net/8021q/vlan_dev.c | 32 ++++----------------------------
 2 files changed, 7 insertions(+), 32 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 7c77482f31594..8b38466fb0415 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -324,10 +324,9 @@ static void vlan_transfer_features(struct net_device *dev,
 
 	netif_inherit_tso_max(vlandev, dev);
 
-	if (vlan_hw_offload_capable(dev->features, vlan->vlan_proto))
-		vlandev->hard_header_len = dev->hard_header_len;
-	else
-		vlandev->hard_header_len = dev->hard_header_len + VLAN_HLEN;
+	vlandev->needed_headroom = dev->needed_headroom + VLAN_HLEN;
+	vlandev->needed_tailroom = dev->needed_tailroom;
+	vlandev->hard_header_len = dev->hard_header_len;
 
 #if IS_ENABLED(CONFIG_FCOE)
 	vlandev->fcoe_ddp_xid = dev->fcoe_ddp_xid;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index a703d7f09f502..f43dfd8f19d96 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -505,26 +505,6 @@ static const struct header_ops vlan_header_ops = {
 	.parse_protocol = vlan_parse_protocol,
 };
 
-static int vlan_passthru_hard_header(struct sk_buff *skb, struct net_device *dev,
-				     unsigned short type,
-				     const void *daddr, const void *saddr,
-				     unsigned int len)
-{
-	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
-	struct net_device *real_dev = vlan->real_dev;
-
-	if (saddr == NULL)
-		saddr = dev->dev_addr;
-
-	return dev_hard_header(skb, real_dev, type, daddr, saddr, len);
-}
-
-static const struct header_ops vlan_passthru_header_ops = {
-	.create	 = vlan_passthru_hard_header,
-	.parse	 = eth_header_parse,
-	.parse_protocol = vlan_parse_protocol,
-};
-
 static struct device_type vlan_type = {
 	.name	= "vlan",
 };
@@ -577,14 +557,10 @@ static int vlan_dev_init(struct net_device *dev)
 	dev->fcoe_ddp_xid = real_dev->fcoe_ddp_xid;
 #endif
 
-	dev->needed_headroom = real_dev->needed_headroom;
-	if (vlan_hw_offload_capable(real_dev->features, vlan->vlan_proto)) {
-		dev->header_ops      = &vlan_passthru_header_ops;
-		dev->hard_header_len = real_dev->hard_header_len;
-	} else {
-		dev->header_ops      = &vlan_header_ops;
-		dev->hard_header_len = real_dev->hard_header_len + VLAN_HLEN;
-	}
+	dev->needed_headroom = real_dev->needed_headroom + VLAN_HLEN;
+	dev->needed_tailroom = real_dev->needed_tailroom;
+	dev->header_ops      = &vlan_header_ops;
+	dev->hard_header_len = real_dev->hard_header_len;
 
 	dev->netdev_ops = &vlan_netdev_ops;
 
-- 
2.53.0



