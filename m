Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8F41C6881;
	Tue, 27 Aug 2024 15:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771473; cv=none; b=mfCg9doJFO0PvSmEG0PvSOGgDrlTLWJ83GvlZWdsnlMv9d30pWl1EWgkcfLExeHOy0Xl5c9aOcxeqoEMIeULYBPWlhkqG6cYAPM3Jt7dyMR2wvZD4QZe2yG6Bn8hMvXhY/hG0P92w5esYpg60FzexX650NFTsiEs1w+COVVQFbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771473; c=relaxed/simple;
	bh=04L+D9jArrrlnYWljTwMt9fWdMjedjP73Z1jGJiypcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrzdPY9jlpV+14/49wrUHbGRbohCLyS2ocdu0MVDwp8e3SC7Yc0Zqa+YEpGx9zyK4MO/9cs5WOefGGL+od+8L3uq5xDmwtj8SZP2b71Kvhu3LddLPuW5GsK7HK/D+P1fJHvi+hTz4AvPZlza6TqwHkzcyoO1aK1CRBPLSUyL27c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/sxVoxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/sxVoxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7DEC4DDF2;
	Tue, 27 Aug 2024 15:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771473;
	bh=04L+D9jArrrlnYWljTwMt9fWdMjedjP73Z1jGJiypcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/sxVoxpBUdIDY/udlNFxSOlYylQOx+e6yzY3EyjJE8sJ/rWgSxJkJoijdPtSttNm
	 h5WWSExbYUPcCqOPU525AyBQN3lSoC8HaM2F5aorZu9PaWvoaq0KHCYqtDEix17nnS
	 yoKZKXIqG7wtybM2prHD2/dnOhv7gGxUqyuaSGjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 167/273] ip6_tunnel: Fix broken GRO
Date: Tue, 27 Aug 2024 16:38:11 +0200
Message-ID: <20240827143839.764135272@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9dee0c1279554..87dfb565a9f81 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1507,7 +1507,8 @@ static void ip6_tnl_link_config(struct ip6_tnl *t)
 			tdev = __dev_get_by_index(t->net, p->link);
 
 		if (tdev) {
-			dev->hard_header_len = tdev->hard_header_len + t_hlen;
+			dev->needed_headroom = tdev->hard_header_len +
+				tdev->needed_headroom + t_hlen;
 			mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
 
 			mtu = mtu - t_hlen;
@@ -1731,7 +1732,9 @@ ip6_tnl_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 int ip6_tnl_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct ip6_tnl *tnl = netdev_priv(dev);
+	int t_hlen;
 
+	t_hlen = tnl->hlen + sizeof(struct ipv6hdr);
 	if (tnl->parms.proto == IPPROTO_IPV6) {
 		if (new_mtu < IPV6_MIN_MTU)
 			return -EINVAL;
@@ -1740,10 +1743,10 @@ int ip6_tnl_change_mtu(struct net_device *dev, int new_mtu)
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
 	WRITE_ONCE(dev->mtu, new_mtu);
@@ -1887,12 +1890,11 @@ ip6_tnl_dev_init_gen(struct net_device *dev)
 	t_hlen = t->hlen + sizeof(struct ipv6hdr);
 
 	dev->type = ARPHRD_TUNNEL6;
-	dev->hard_header_len = LL_MAX_HEADER + t_hlen;
 	dev->mtu = ETH_DATA_LEN - t_hlen;
 	if (!(t->parms.flags & IP6_TNL_F_IGN_ENCAP_LIMIT))
 		dev->mtu -= 8;
 	dev->min_mtu = ETH_MIN_MTU;
-	dev->max_mtu = IP6_MAX_MTU - dev->hard_header_len;
+	dev->max_mtu = IP6_MAX_MTU - dev->hard_header_len - t_hlen;
 
 	netdev_hold(dev, &t->dev_tracker, GFP_KERNEL);
 	netdev_lockdep_set_classes(dev);
-- 
2.43.0



