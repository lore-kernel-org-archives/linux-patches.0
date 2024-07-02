Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095901BD505;
	Tue,  2 Jul 2024 17:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940053; cv=none; b=aC8O2FvNid0ij3HoCkVFEqbQ2NhzC7qsmypXz4Fif0L+jIXxgyFdRJD75Vyfmu9sk7BQUe9pFasfDNAJ5ioZKxgl+UqrTShfZv/jqdIHhVdi7WUfANGY9EFUHx9w4JqypT4ENcT7UlRUzh+ZlX6t7mpMtXXDO+pia6XDOKjlW9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940053; c=relaxed/simple;
	bh=3y2U9Y1TQf7uriuU7U1qgH71EqkM1NSUYO/dTeshy+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNbrnrWLVJAGYeDZzN6Zx+w3vOdlYM9yYUD90nTDN2BtjGRq7ydw6E9l6tURumVv61gu1GOBrR5w2RYd8gWAc4d1a+EKgiM2ftzavMMj6kC1VfLultRbXwpDZ1y+r319QNuDL9C0cDid6gtwcXCDPS9bsWPiVzU76GuCfi7Z5I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=le/rSPIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="le/rSPIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9E8C116B1;
	Tue,  2 Jul 2024 17:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940052;
	bh=3y2U9Y1TQf7uriuU7U1qgH71EqkM1NSUYO/dTeshy+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=le/rSPIbVcFzNQsBbx9zckkGs6rQgQzq2bNWZrhlW/3KH9TzrWWUVZL7u4c8EIyU1
	 lKHbnLT+7J+GE2EjHph0kbLdDPq8hy7h03mPqAWRwI+E7BKRZdN/pJL3d7+QsZbY8e
	 ZVoKUkFElPoaAUeRsCYl3fnvaRAMJYVfvBNm+9hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 038/222] vxlan: Pull inner IP header in vxlan_xmit_one().
Date: Tue,  2 Jul 2024 19:01:16 +0200
Message-ID: <20240702170245.432126352@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 31392048f55f98cb01ca709d32d06d926ab9760a ]

Ensure the inner IP header is part of the skb's linear data before
setting old_iph. Otherwise, on a non-linear skb, old_iph could point
outside of the packet data.

Unlike classical VXLAN, which always encapsulates Ethernet packets,
VXLAN-GPE can transport IP packets directly. In that case, we need to
look at skb->protocol to figure out if an Ethernet header is present.

Fixes: d342894c5d2f ("vxlan: virtual extensible lan")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/2aa75f6fa62ac9dbe4f16ad5ba75dd04a51d4b99.1718804000.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index b2d054f59f30f..49779ba3c4b7b 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2336,7 +2336,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	struct ip_tunnel_key *pkey;
 	struct ip_tunnel_key key;
 	struct vxlan_dev *vxlan = netdev_priv(dev);
-	const struct iphdr *old_iph = ip_hdr(skb);
+	const struct iphdr *old_iph;
 	struct vxlan_metadata _md;
 	struct vxlan_metadata *md = &_md;
 	unsigned int pkt_len = skb->len;
@@ -2350,8 +2350,15 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	bool use_cache;
 	bool udp_sum = false;
 	bool xnet = !net_eq(vxlan->net, dev_net(vxlan->dev));
+	bool no_eth_encap;
 	__be32 vni = 0;
 
+	no_eth_encap = flags & VXLAN_F_GPE && skb->protocol != htons(ETH_P_TEB);
+	if (!skb_vlan_inet_prepare(skb, no_eth_encap))
+		goto drop;
+
+	old_iph = ip_hdr(skb);
+
 	info = skb_tunnel_info(skb);
 	use_cache = ip_tunnel_dst_cache_usable(skb, info);
 
-- 
2.43.0



