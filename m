Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149C41DFD1;
	Sun,  1 Sep 2024 16:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209619; cv=none; b=VxvYdGhRCYJpAQxqgTmGDs0Zzy7jOfxealUqKhR4XJElk74XaCl3i9F48BmvRe5ipz3j1Epd1Aw5VudNPlNiZo2Ck6UWUe7YgTdGP39qlEOLrumf7EYHv0S3lyknksTJsh5L1fwzzrzXx+8tK0aoaXhXu6h98a/rp+j3spayLgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209619; c=relaxed/simple;
	bh=4VPW5iI4vjkdMx6FUt2DOQeK1bqxibRgRM3Yq09Nuc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5HtLU/Hv43q0Kre6iiQi/xWnNDlTDx1z/i/PorMMc9mT6vL3R08Gmta7wSePMRyGtoXLisw3TuCXK1NCAmAp6QdOTxjsdwQacTPpl/eLodcEuIaIzggJ+TLI3SC7SgZfZ8rJlA3sP/TPnVivFltQ9VAn6kLi0+9RiJwHcH7S6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBqQyARb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBqQyARb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E557C4CEC3;
	Sun,  1 Sep 2024 16:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209618;
	bh=4VPW5iI4vjkdMx6FUt2DOQeK1bqxibRgRM3Yq09Nuc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBqQyARbikTrtqWlUVlUoAGkM5kI7v1hDLW5ZOaMIW5UMIn5qWgUJfOJ7edFEqgPv
	 r/kI/ASc7QphxuQit35G7ezdZaIMiIeyUmTnZNEtNsNmpBaHNZ/GjvKgQnKUWyDgD8
	 hLUg0lo+/dm1z4v6bi2bhATxGGbppEmi8F79rWh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/151] ip6_tunnel: Fix broken GRO
Date: Sun,  1 Sep 2024 18:17:31 +0200
Message-ID: <20240901160817.539856444@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 4b3e33fcc38f7750604b065c55a43e94c5bc3145 ]

GRO code checks for matching layer 2 headers to see, if packet belongs
to the same flow and because ip6 tunnel set dev->hard_header_len
this check fails in cases, where it shouldn't. To fix this don't
set hard_header_len, but use needed_headroom like ipv4/ip_tunnel.c
does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Link: https://patch.msgid.link/20240815151419.109864-1-tbogendoerfer@suse.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_tunnel.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index d1f8192384147..bd27204725ed8 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1531,7 +1531,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 			tdev = __dev_get_by_index(t->net, p->link);
 
 		if (tdev) {
-			dev->hard_header_len = tdev->hard_header_len + t_hlen;
+			dev->needed_headroom = tdev->hard_header_len +
+				tdev->needed_headroom + t_hlen;
 			mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
 
 			mtu = mtu - t_hlen;
@@ -1758,7 +1759,9 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 int ip6_tnl_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct ip6_tnl *tnl = netdev_priv(dev);
+	int t_hlen;
 
+	t_hlen = tnl->hlen + sizeof(struct ipv6hdr);
 	if (tnl->parms.proto == IPPROTO_IPV6) {
 		if (new_mtu < IPV6_MIN_MTU)
 			return -EINVAL;
@@ -1767,10 +1770,10 @@ int ip6_tnl_change_mtu(struct net_device *dev, int new_mtu)
 			return -EINVAL;
 	}
 	if (tnl->parms.proto == IPPROTO_IPV6 || tnl->parms.proto == 0) {
-		if (new_mtu > IP6_MAX_MTU - dev->hard_header_len)
+		if (new_mtu > IP6_MAX_MTU - dev->hard_header_len - t_hlen)
 			return -EINVAL;
 	} else {
-		if (new_mtu > IP_MAX_MTU - dev->hard_header_len)
+		if (new_mtu > IP_MAX_MTU - dev->hard_header_len - t_hlen)
 			return -EINVAL;
 	}
 	dev->mtu = new_mtu;
@@ -1916,12 +1919,11 @@ ip6_tnl_dev_init_gen(struct net_device *dev)
 	t_hlen = t->hlen + sizeof(struct ipv6hdr);
 
 	dev->type = ARPHRD_TUNNEL6;
-	dev->hard_header_len = LL_MAX_HEADER + t_hlen;
 	dev->mtu = ETH_DATA_LEN - t_hlen;
 	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
 		dev->mtu -= 8;
 	dev->min_mtu = ETH_MIN_MTU;
-	dev->max_mtu = IP6_MAX_MTU - dev->hard_header_len;
+	dev->max_mtu = IP6_MAX_MTU - dev->hard_header_len - t_hlen;
 
 	dev_hold(dev);
 	return 0;
-- 
2.43.0



