Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA69C3AFB11;
	Wed, 30 Sep 2026 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787139; cv=none; b=nfIzU0ARU7lnnOhZIBn4R98WeCnHIQdMHJICAyz0PPBZvTTcOS5ZQF8z9+h38IyREFno8PTW9+apTSLAczCL5rQ6GZryvJUsQelxZMYuJfQKH5ZnJ3UknjzBJho5zLSbblS4Mvoa6vU+kANnmlvUNo4E1cjsv9DdPBaZ6C+dqWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787139; c=relaxed/simple;
	bh=YOxS7JZ4gJ89eQtDaIQoeBlB24pINe3ezrmxX469S/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejcrvvzGwh7l5nlscMDbExWqoaDMukIg/z/c6CaGl4zMBUcy2/cDbzNal0ywLlqyznhU4iPxvvCoCYVfEbSS09uTqvi/tyzOEt4bdC+xctsNxQEo54/CE2Jin3oeyVSThf5fAx4FLbV/fA13WnG6HM+/E677kufyYz1l0NNQJAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBjADleD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBjADleD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D18D1F000FF;
	Wed, 30 Sep 2026 16:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787137;
	bh=9OtUWXPBzX+v0xi8lE46680n9zy/8kYipNVZXRHsiG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBjADleD2zPIecW1d3dh4grtsa+Si5qeUmDxY2TU6r+IRoWYtrXivEhRti4Q4RfBi
	 RoUuMA2ZuqLAf6xtjP1cuO1P/vc9owKX0MSovQESkSeL3jlTuR0vCn+KSbF6KO92GY
	 dKKAZkydEkY3QZ6yxKAVrRJNqeW05vPDpTPwkZ/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 125/457] ovpn: reject invalid peer VPN addresses
Date: Wed, 30 Sep 2026 17:23:50 +0200
Message-ID: <20260930152348.748122231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
index e9e0f75e04433..5432bc2eb8e80 100644
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
@@ -387,12 +420,10 @@ int ovpn_nl_peer_new_doit(struct sk_buff *skb, struct genl_info *info)
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
@@ -558,13 +589,11 @@ int ovpn_nl_peer_set_doit(struct sk_buff *skb, struct genl_info *info)
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



