Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE14511E96;
	Wed, 30 Sep 2026 16:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787110; cv=none; b=Q+v89CQuzJ49Es9vwdhVoTAhJBCH2K/OXXM6sDWhPheFHL9BfoxsgB6bmGh31g69x9l1q/9iOQo384+LouyjtfZapIamZS2Hiz2zeDu5TKpOQ/myYMb7ZoLsiNhl30A4YZroLKMhovv6LCtBReevp3RFMJbBCXa7itx5rbLxZQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787110; c=relaxed/simple;
	bh=3KiHixsz5QDzv6fDyQNq+mnVMilsw2p+3Q6f6EA2kUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGIvGxNFucRx31Wuwy0GceUhvQu1HfzkJjcpgwBU9xOA1kvZ+teXVf9Zo5YDYqYn/H6CpCJ4gztNIJDow05bCGmBNEN1sMsWULDVl/4afHQSKQJE0+vYwbTq33H6AqY3p5vn7x9IpXsODDx+Q1WUviiRF5HCJ3wmls92vAvOWy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SiEoxgQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SiEoxgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE6E1F000FF;
	Wed, 30 Sep 2026 16:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787109;
	bh=cHdP6hMIl1dEL+GF4YghcEdLuMsjwNIC7OxEc01cxic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1SiEoxgQZzcROjIFXyZTvO092P8tuhhXixDIeXW9Uy3aMqVLyefG577BorQ/+vOOw
	 Y2pzAJO2zKJYYzV1FItIKWH98iul18+ijbwjimcw7oZ2ebjdPGw9tLXz8Dd/P3gt4w
	 P2AvCOL0Jm9svMMGZHODjaNfPONMHSUPgEaAesqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 116/457] ovpn: preserve IPv6 scope id for netlink peer endpoints
Date: Wed, 30 Sep 2026 17:23:41 +0200
Message-ID: <20260930152348.555806002@linuxfoundation.org>
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

[ Upstream commit 7a6d08ee0f0e30023d18779bb314db8fd9a3b6d4 ]

ovpn accepts OVPN_A_PEER_REMOTE_IPV6_SCOPE_ID and reports
bind->remote.in6.sin6_scope_id in peer dumps, but the netlink endpoint
parser never copied the attribute into the sockaddr_in6 used to create or
update the peer bind.

As a result, an IPv6 link-local remote endpoint configured through
netlink loses its interface scope, unlike on the peer float path where
ipv6_iface_scope_id populates the field. The UDPv6 output path then
builds a flow with flowi6_oif set to zero and route lookup can fail or
select the wrong interface.

Copy the scope id when parsing non-v4-mapped IPv6 remote endpoints. The
existing precheck already rejects the scope-id attribute for IPv4 and
v4-mapped IPv6 remotes.

Fixes: 1d36a36f6d53 ("ovpn: implement peer add/get/dump/delete via netlink")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/netlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ovpn/netlink.c b/drivers/net/ovpn/netlink.c
index 4dad852941982..2ba762082acc1 100644
--- a/drivers/net/ovpn/netlink.c
+++ b/drivers/net/ovpn/netlink.c
@@ -100,6 +100,8 @@ static bool ovpn_nl_attr_sockaddr_remote(struct nlattr **attrs,
 	struct sockaddr_in6 *sin6;
 	struct sockaddr_in *sin;
 	struct in6_addr *in6;
+	struct nlattr *scope;
+	u32 scope_id = 0;
 	__be16 port = 0;
 	__be32 *in;
 
@@ -114,6 +116,9 @@ static bool ovpn_nl_attr_sockaddr_remote(struct nlattr **attrs,
 	} else if (attrs[OVPN_A_PEER_REMOTE_IPV6]) {
 		ss->ss_family = AF_INET6;
 		in6 = nla_data(attrs[OVPN_A_PEER_REMOTE_IPV6]);
+		scope = attrs[OVPN_A_PEER_REMOTE_IPV6_SCOPE_ID];
+		if (scope)
+			scope_id = nla_get_u32(scope);
 	} else {
 		return false;
 	}
@@ -126,6 +131,7 @@ static bool ovpn_nl_attr_sockaddr_remote(struct nlattr **attrs,
 		if (!ipv6_addr_v4mapped(in6)) {
 			sin6 = (struct sockaddr_in6 *)ss;
 			sin6->sin6_port = port;
+			sin6->sin6_scope_id = scope_id;
 			memcpy(&sin6->sin6_addr, in6, sizeof(*in6));
 			break;
 		}
-- 
2.53.0



