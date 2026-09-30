Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00CD3AD539;
	Wed, 30 Sep 2026 18:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793023; cv=none; b=ByT1oQ1Hl4PAeksA3XCihFBBUHORvy/G4/4E8Vm5IU1yFD3SSArNpgQnZFghQi81kKFsfIVt9W3A2y27yLcqbzJaSTLUmxSuwHWrlh+GKyJEpo359tPIR8qYOVnJvL24nmrJTMeJXVODfGyK24SFLvXCPoM/cBZNpUTKgNQqtFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793023; c=relaxed/simple;
	bh=tQnxLCaz5x2W/qJ9OVZy0VXSLs4jR4y+VDPQx2ZToa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wn3qnlX+4UW1tcKcSJ23k4rQaTG3HO658gbJsIHmDbgB437L8ZO378PlN87i1djHosAHQQxaT3D8/7BirYfqE/9xHNlr0Pwnfzqum2OxFPydRBNpeiO3VZoA3C5wyymxXyBfa1wu5AzJhz8wva2foo0vs3hTVhdFZtF6D7Cx+0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEJs7zWd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEJs7zWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411591F000FF;
	Wed, 30 Sep 2026 18:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793021;
	bh=qXUlxSO6cKxd+vvqWDoKHEBzLzGYWGYk9FHU7aIwhWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEJs7zWdGbnnKPsswtZ8f0C3tMcKfv26+SR21B7a9hezrz2K+vDfF94/d2xqc+BKt
	 nXKKTvD04YD5Hq4N/cCQjKOuxNMMgZRgacl8IRC2cx1S+4/F8gg6w64nwj4beGwp4V
	 cz7aigs+HpSgm9Qef5RYwBZquVQSImgJMX/s/2/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/395] ovpn: reject invalid peer VPN addresses
Date: Wed, 30 Sep 2026 17:26:09 +0200
Message-ID: <20260930152342.958385641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit 5940f3407b78062442cb01f541ef6eed709fc380 ]

In MP mode, ovpn uses peer VPN addresses as lookup keys for selecting
the peer that should receive outgoing tunnel packets. The netlink
configuration path currently accepts address values that cannot sensibly
identify a VPN peer, such as multicast, broadcast or loopback addresses.

Reject invalid peer VPN addresses when creating or updating an MP peer.
Keep accepting the unspecified address as the internal unset value,
provided that at least one VPN address family remains configured.

Fixes: 1d36a36f6d53 ("ovpn: implement peer add/get/dump/delete via netlink")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/netlink.c | 55 +++++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ovpn/netlink.c b/drivers/net/ovpn/netlink.c
index 45fa69d9c951f..15664cde85e0b 100644
--- a/drivers/net/ovpn/netlink.c
+++ b/drivers/net/ovpn/netlink.c
@@ -185,6 +185,39 @@ static sa_family_t ovpn_nl_family_get(struct nlattr *addr4,
 	return AF_UNSPEC;
 }
 
+static int ovpn_nl_peer_check_vpn_addrs(const struct in_addr *addr4,
+					const struct in6_addr *addr6,
+					struct genl_info *info)
+{
+	int addr6_type;
+
+	if (addr4->s_addr == htonl(INADDR_ANY) && ipv6_addr_any(addr6)) {
+		NL_SET_ERR_MSG_MOD(info->extack,
+				   "at least one VPN IP must be configured in MP mode");
+		return -EINVAL;
+	}
+
+	if (ipv4_is_multicast(addr4->s_addr) || ipv4_is_lbcast(addr4->s_addr) ||
+	    ipv4_is_loopback(addr4->s_addr)) {
+		NL_SET_ERR_MSG_MOD(info->extack,
+				   "VPN IPv4 address must be valid unicast or any");
+		return -EADDRNOTAVAIL;
+	}
+
+	if (!ipv6_addr_any(addr6)) {
+		addr6_type = ipv6_addr_type(addr6);
+
+		if (!(addr6_type & IPV6_ADDR_UNICAST) ||
+		    (addr6_type & (IPV6_ADDR_LOOPBACK | IPV6_ADDR_COMPATv4))) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "VPN IPv6 address must be valid unicast or any");
+			return -EADDRNOTAVAIL;
+		}
+	}
+
+	return 0;
+}
+
 static int ovpn_nl_peer_precheck(struct ovpn_priv *ovpn,
 				 struct genl_info *info,
 				 struct nlattr **attrs)
@@ -381,12 +414,10 @@ int ovpn_nl_peer_new_doit(struct sk_buff *skb, struct genl_info *info)
 			vpn_addr6 =
 				nla_get_in6_addr(attrs[OVPN_A_PEER_VPN_IPV6]);
 
-		if (vpn_addr4.s_addr == htonl(INADDR_ANY) &&
-		    ipv6_addr_any(&vpn_addr6)) {
-			NL_SET_ERR_MSG_FMT_MOD(info->extack,
-					       "at least one VPN IP must be configured in MP mode");
-			return -EINVAL;
-		}
+		ret = ovpn_nl_peer_check_vpn_addrs(&vpn_addr4, &vpn_addr6,
+						   info);
+		if (ret < 0)
+			return ret;
 	}
 
 	peer_id = nla_get_u32(attrs[OVPN_A_PEER_ID]);
@@ -551,13 +582,11 @@ int ovpn_nl_peer_set_doit(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* in MP mode VPN IPs are required for selecting the right peer */
-	if (ovpn->mode == OVPN_MODE_MP &&
-	    vpn_addr4.s_addr == htonl(INADDR_ANY) &&
-	    ipv6_addr_any(&vpn_addr6)) {
-		NL_SET_ERR_MSG_FMT_MOD(info->extack,
-				       "at least one VPN IP must be configured in MP mode");
-		ret = -EINVAL;
-		goto unlock;
+	if (ovpn->mode == OVPN_MODE_MP) {
+		ret = ovpn_nl_peer_check_vpn_addrs(&vpn_addr4, &vpn_addr6,
+						   info);
+		if (ret < 0)
+			goto unlock;
 	}
 
 	ret = ovpn_nl_peer_modify(peer, info, attrs);
-- 
2.53.0



