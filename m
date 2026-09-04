Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33ED381E83;
	Fri,  4 Sep 2026 06:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502869; cv=none; b=C7ekpReOqtQIgIS/56voeaq+WVdozAhCM4VVxD/xTo5FFFeWMqWIVBpSSo3brZxMDy67V4pobPN2dL/f+php1wiRIIzwmTka6m/qAKoxbmM5cYy0ZrM2gDmLsEkEgPspM2VWWYta1OgC63NkIDwMw3PS2IaPMzpSNqzLdo1kqn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502869; c=relaxed/simple;
	bh=fN9qLoTNMzZ2iBXa5C8JqMa25TOqej8LgFqiQnKDAPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ff8vrzabgdEVYK4lyVLN6rEkGYJDh7rxu4BZfQLuKcK1sZwyoPNIZSXQTBjeVHsO8CWMVD8Kzn8pKEcjY+8NMLc8Sutdq24TA30nnAduk8NEK4WNF9CktmgSnufKPN2Y029+XqIKoQ61DDo8q8ianRYaUVVw8brBOuX234fZ0Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vzd9pVE4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vzd9pVE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282331F00A3D;
	Fri,  4 Sep 2026 06:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502867;
	bh=APxh4YJJ4Np9haDsQ9I9sqSeNJSRYBmOXWSG5iEjtto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vzd9pVE4dfFwkdjLSFltXnSSyzNIF950C2P2liMEiJD5snfDBkPod9Z3rSDCFbJr+
	 WGeFMYHk4vZfe4jvb7j1g8P/WxE+feGuMjD83mgGeF8tnLaJMy3rWPKcga95hgplTF
	 kMCpRaEi2Nlkbe7dCNOnIq5MoNlPUJRkXAHxVV8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 356/403] net: cap advertised IP tunnel headroom
Date: Fri,  4 Sep 2026 07:02:39 +0200
Message-ID: <20260904045742.909961971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 6b222adeb9340306e2ff97127c76117abb9b3df8 upstream.

IP tunnel devices derive their advertised needed_headroom from lower
output devices. A stack of user-created devices can make the derived
value larger than the 16-bit skb header offsets can represent. Once IP
output reserves it, skb head expansion can wrap those offsets.

The runtime transmit path already caps a growing needed_headroom at 512.
Apply the same cap when tunnel configuration publishes needed_headroom
derived from a lower output device.

Capping the advertised value is safe: IP tunnel transmit still expands
the skb when a packet needs more headroom. A nonsensical stacked
configuration can therefore incur an extra reallocation, but it cannot
publish an unbounded reservation to upper layers.

Fixes: 1a37e412a022 ("net: Use 16bits for *_headers fields of struct skbuff")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/ba04a1fd6bfae2377607fad5d8f80f7eb80fd4c4.1786542637.git.zhilinz@nebusec.ai
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip_tunnels.h |   11 +++++++++--
 net/ipv4/ip_tunnel.c     |    2 +-
 net/ipv6/ip6_gre.c       |    7 +++++--
 net/ipv6/ip6_tunnel.c    |    7 +++++--
 net/ipv6/sit.c           |    2 +-
 5 files changed, 21 insertions(+), 8 deletions(-)

--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -615,8 +615,7 @@ struct metadata_dst *iptunnel_metadata_r
 int skb_tunnel_check_pmtu(struct sk_buff *skb, struct dst_entry *encap_dst,
 			  int headroom, bool reply);
 
-static inline void ip_tunnel_adj_headroom(struct net_device *dev,
-					  unsigned int headroom)
+static inline unsigned int ip_tunnel_limit_headroom(unsigned int headroom)
 {
 	/* we must cap headroom to some upperlimit, else pskb_expand_head
 	 * will overflow header offsets in skb_headers_offset_update().
@@ -626,6 +625,14 @@ static inline void ip_tunnel_adj_headroo
 	if (headroom > max_allowed)
 		headroom = max_allowed;
 
+	return headroom;
+}
+
+static inline void ip_tunnel_adj_headroom(struct net_device *dev,
+					  unsigned int headroom)
+{
+	headroom = ip_tunnel_limit_headroom(headroom);
+
 	if (headroom > READ_ONCE(dev->needed_headroom))
 		WRITE_ONCE(dev->needed_headroom, headroom);
 }
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -316,7 +316,7 @@ static int ip_tunnel_bind_dev(struct net
 		mtu = min(tdev->mtu, IP_MAX_MTU);
 	}
 
-	dev->needed_headroom = t_hlen + hlen;
+	dev->needed_headroom = ip_tunnel_limit_headroom(t_hlen + hlen);
 	mtu -= t_hlen + (dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0);
 
 	if (mtu < IPV4_MIN_MTU)
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1165,8 +1165,11 @@ static void ip6gre_tnl_link_config_route
 			return;
 
 		if (rt->dst.dev) {
-			dev->needed_headroom = rt->dst.dev->hard_header_len +
-					       t_hlen;
+			unsigned int headroom;
+
+			headroom = rt->dst.dev->hard_header_len + t_hlen;
+			headroom = ip_tunnel_limit_headroom(headroom);
+			dev->needed_headroom = headroom;
 
 			if (set_mtu) {
 				int mtu = rt->dst.dev->mtu - t_hlen;
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1506,8 +1506,11 @@ static void ip6_tnl_link_config(struct i
 			tdev = __dev_get_by_index(t->net, p->link);
 
 		if (tdev) {
-			dev->needed_headroom = tdev->hard_header_len +
-				tdev->needed_headroom + t_hlen;
+			unsigned int headroom;
+
+			headroom = tdev->hard_header_len + tdev->needed_headroom;
+			headroom += t_hlen;
+			dev->needed_headroom = ip_tunnel_limit_headroom(headroom);
 			mtu = min_t(unsigned int, tdev->mtu, IP6_MAX_MTU);
 
 			mtu = mtu - t_hlen;
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1136,7 +1136,7 @@ static void ipip6_tunnel_bind_dev(struct
 		WRITE_ONCE(dev->mtu, mtu);
 		hlen = tdev->hard_header_len + tdev->needed_headroom;
 	}
-	dev->needed_headroom = t_hlen + hlen;
+	dev->needed_headroom = ip_tunnel_limit_headroom(t_hlen + hlen);
 }
 
 static void ipip6_tunnel_update(struct ip_tunnel *t,


