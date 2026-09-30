Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C013AFB11;
	Wed, 30 Sep 2026 16:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787133; cv=none; b=oajlJLv4t9ArfXDjS0RozCfmeC0qaMWtgNJYfnbwpFOpovm9DiOkLD/gK0wnUSDM/bL/EVZq7ByvZkfMwu5yKtBKloWcpbIh42i+VfPvuUvDSiq75XEaFObuFW355qe+mI/Broj+XHlBTI25+mqLFUMrHKQSC1pE+xNAsxjI/s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787133; c=relaxed/simple;
	bh=yYRcFKV9Tf/2C/fSa8iV7My96Tu7bjrARPtzEpiKAnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsOi8vBeav+iypjYZTESd0Na1xvazJ3IjntFMuQ9MP3kxmRJT5NM/E4KvhHkePuZeVlah3K0zYF+GsmyHN0APlhXYtf2mY+Qm71BLyCi7uFtrp24r9fCI9RVhEvbyHSUU+nCTrMwc9T2j1d4EsDTPOintlTzU8dzJTOXX/tznHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zObw062R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zObw062R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633861F000FF;
	Wed, 30 Sep 2026 16:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787131;
	bh=w9SG0PTw+qYi83KAFXTFt+iJoBGFpBo0sVKrsZ2hPfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zObw062ROeEA1ZeWs+0bUfi2Is7DP4mgs/Rr826rzqja+ik3N14UiJyRsF0jT4sVH
	 SaC6IgAddQPXOWy80MDwFl8s2FT8yWIVAoKM6W1B1sTCDW+g9PwL2NUMYb6pABIpMj
	 7CvufMdbY70OOjcuSDxIM2YnxS8nNw1Kk5adQglc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 124/457] ovpn: reject multipeer peers without VPN addresses
Date: Wed, 30 Sep 2026 17:23:49 +0200
Message-ID: <20260930152348.727034939@linuxfoundation.org>
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

[ Upstream commit 025af3a0a892514f9f27f186338ba3d44365547a ]

In MP mode, ovpn uses the peer VPN addresses to select the peer for
outgoing tunnel packets. Peer creation currently requires a VPN IPv4 or
IPv6 attribute, but it only checks for the presence of the attribute and
not for a usable address value.

This allows userspace to create an MP peer with only unspecified VPN
addresses, or to update an existing peer so that both VPN address
families become unspecified. Such a peer cannot be selected through the
VPN address hash tables.

Reject MP peer creation or update when the resulting peer would not have
at least one VPN address configured.

This changes such configurations from being accepted to being rejected,
but they have never been usable because the peer cannot be selected
through the VPN address hash tables.

Fixes: 1d36a36f6d53 ("ovpn: implement peer add/get/dump/delete via netlink")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/netlink.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ovpn/netlink.c b/drivers/net/ovpn/netlink.c
index e23f7d1f49e01..e9e0f75e04433 100644
--- a/drivers/net/ovpn/netlink.c
+++ b/drivers/net/ovpn/netlink.c
@@ -352,8 +352,10 @@ static int ovpn_nl_peer_modify(struct ovpn_peer *peer, struct genl_info *info,
 
 int ovpn_nl_peer_new_doit(struct sk_buff *skb, struct genl_info *info)
 {
-	struct nlattr *attrs[OVPN_A_PEER_MAX + 1];
+	struct in_addr vpn_addr4 = { .s_addr = htonl(INADDR_ANY) };
+	struct in6_addr vpn_addr6 = IN6ADDR_ANY_INIT;
 	struct ovpn_priv *ovpn = info->user_ptr[0];
+	struct nlattr *attrs[OVPN_A_PEER_MAX + 1];
 	struct ovpn_socket *ovpn_sock;
 	struct socket *sock = NULL;
 	struct ovpn_peer *peer;
@@ -377,11 +379,20 @@ int ovpn_nl_peer_new_doit(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	/* in MP mode VPN IPs are required for selecting the right peer */
-	if (ovpn->mode == OVPN_MODE_MP && !attrs[OVPN_A_PEER_VPN_IPV4] &&
-	    !attrs[OVPN_A_PEER_VPN_IPV6]) {
-		NL_SET_ERR_MSG_FMT_MOD(info->extack,
-				       "VPN IP must be provided in MP mode");
-		return -EINVAL;
+	if (ovpn->mode == OVPN_MODE_MP) {
+		if (attrs[OVPN_A_PEER_VPN_IPV4])
+			vpn_addr4.s_addr =
+				nla_get_in_addr(attrs[OVPN_A_PEER_VPN_IPV4]);
+		if (attrs[OVPN_A_PEER_VPN_IPV6])
+			vpn_addr6 =
+				nla_get_in6_addr(attrs[OVPN_A_PEER_VPN_IPV6]);
+
+		if (vpn_addr4.s_addr == htonl(INADDR_ANY) &&
+		    ipv6_addr_any(&vpn_addr6)) {
+			NL_SET_ERR_MSG_FMT_MOD(info->extack,
+					       "at least one VPN IP must be configured in MP mode");
+			return -EINVAL;
+		}
 	}
 
 	peer_id = nla_get_u32(attrs[OVPN_A_PEER_ID]);
@@ -531,6 +542,9 @@ int ovpn_nl_peer_set_doit(struct sk_buff *skb, struct genl_info *info)
 
 	spin_lock_bh(&ovpn->lock);
 
+	vpn_addr4 = peer->vpn_addrs.ipv4;
+	vpn_addr6 = peer->vpn_addrs.ipv6;
+
 	/* reject peer with conflicting VPN address */
 	if (attrs[OVPN_A_PEER_VPN_IPV4]) {
 		vpn_addr4.s_addr = nla_get_in_addr(attrs[OVPN_A_PEER_VPN_IPV4]);
@@ -543,6 +557,16 @@ int ovpn_nl_peer_set_doit(struct sk_buff *skb, struct genl_info *info)
 			goto addr_conflict;
 	}
 
+	/* in MP mode VPN IPs are required for selecting the right peer */
+	if (ovpn->mode == OVPN_MODE_MP &&
+	    vpn_addr4.s_addr == htonl(INADDR_ANY) &&
+	    ipv6_addr_any(&vpn_addr6)) {
+		NL_SET_ERR_MSG_FMT_MOD(info->extack,
+				       "at least one VPN IP must be configured in MP mode");
+		ret = -EINVAL;
+		goto unlock;
+	}
+
 	ret = ovpn_nl_peer_modify(peer, info, attrs);
 	if (ret < 0)
 		goto unlock;
-- 
2.53.0



