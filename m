Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC16B357D11;
	Wed, 30 Sep 2026 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787121; cv=none; b=qCga8kIOZSkLTYfrEd8ahfOokucqvUeTXmDGSd0YK4UUr+H3OjuS1oy+qkobxHuI7fycW1aW3q7GHziDcWvKV4Wglz1n3WkJb2E3MfPS9JKiZJQVPzaM/VALifMsjR0OPLwKYdR9kg/357MDRekvCNwgdUa4gQ1dF8sYA4+CPFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787121; c=relaxed/simple;
	bh=iz8zJ2GAvO7j6GJIv+3vKBkatkrF+El7UggzH1U8zFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhBe4vArtJs4Ziyqjpv938ack5REAP8Qawwj1BfzM8BsBIH52d2dmsKN7Porvnm56hAii8/7f8Nf5xbutuoVPSz8R/iLhf/msLE2rmq6ayisYanMJR+wcTTmSfF9QA4fpEGdCXy7vnRyupJCdhrfI2MvzoR+YEYGlUpzNpygA3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiNKfa1J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiNKfa1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213E41F000FF;
	Wed, 30 Sep 2026 16:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787120;
	bh=jIFB/49P4RefYBklNddjTlQCCBBDOJoWNtDaQWP9h4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SiNKfa1JvRXBVzKEHqaEA31TDokW2YV+EyfWQoztyduVc7nV1P8pwzAgCy+DSye/N
	 YA7dUcwoWxQLNnROQOy1EF+xgAa5wXApj2aqRP8t09FUXxG6M9HsV9y1S6CbNI5HPj
	 dVM4Y6jmyWT9U2lJ+Cq1I53GN2PBzDZpYrSdUtsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 120/457] ovpn: replace bind when learning local endpoint
Date: Wed, 30 Sep 2026 17:23:45 +0200
Message-ID: <20260930152348.643426901@linuxfoundation.org>
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

[ Upstream commit aea934a221ec6a867221e5b765f65f1857befd53 ]

struct ovpn_bind is published through peer->bind with RCU, but local
endpoint learning updates bind->local in place under peer->lock. UDP TX
reads the field without that lock. In particular, a concurrent IPv6
update can therefore result in a torn address read.

Use ovpn_peer_reset_sockaddr to publish a replacement bind when learning
a new local endpoint, just as a remote endpoint change does. Preserve
the current remote address and reset the dst cache only after the new
bind has been published successfully.

Track remote endpoint changes separately so that float notification and
transport-address rehashing remain limited to actual peer floats.

Fixes: f0281c1d3732 ("ovpn: add support for updating local or remote UDP endpoint")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/peer.c | 43 ++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index b400783c2efab..430c6cd48db87 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -200,13 +200,12 @@ static void __ovpn_peer_hash_transp_addr(struct ovpn_peer *peer,
  */
 void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
 {
+	const void *local_ip = NULL;
 	struct sockaddr_storage ss;
 	struct sockaddr_in6 *sa6;
-	bool reset_cache = false;
 	struct sockaddr_in *sa;
 	struct ovpn_bind *bind;
-	const void *local_ip;
-	size_t salen = 0;
+	bool floated = false;
 
 	spin_lock_bh(&peer->lock);
 	bind = rcu_dereference_protected(peer->bind,
@@ -233,8 +232,7 @@ void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
 				.sin_addr.s_addr = ip_hdr(skb)->saddr,
 				.sin_port = udp_hdr(skb)->source,
 			};
-			salen = sizeof(*sa);
-			reset_cache = true;
+			floated = true;
 			break;
 		}
 
@@ -246,10 +244,12 @@ void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
 					    netdev_name(peer->ovpn->dev),
 					    peer->id, &bind->local.ipv4.s_addr,
 					    &ip_hdr(skb)->daddr);
-			bind->local.ipv4.s_addr = ip_hdr(skb)->daddr;
-			reset_cache = true;
+			local_ip = &ip_hdr(skb)->daddr;
+			memcpy(&ss, &bind->remote, sizeof(struct sockaddr_in));
+			break;
 		}
-		break;
+		/* nothing changed */
+		goto unlock;
 	case htons(ETH_P_IPV6):
 		/* float check */
 		if (unlikely(!ovpn_bind_skb_src_match(bind, skb))) {
@@ -271,8 +271,7 @@ void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
 					ipv6_iface_scope_id(&ipv6_hdr(skb)->saddr,
 							    skb->skb_iif),
 			};
-			salen = sizeof(*sa6);
-			reset_cache = true;
+			floated = true;
 			break;
 		}
 
@@ -285,26 +284,30 @@ void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
 					    netdev_name(peer->ovpn->dev),
 					    peer->id, &bind->local.ipv6,
 					    &ipv6_hdr(skb)->daddr);
-			bind->local.ipv6 = ipv6_hdr(skb)->daddr;
-			reset_cache = true;
+			local_ip = &ipv6_hdr(skb)->daddr;
+			memcpy(&ss, &bind->remote, sizeof(struct sockaddr_in6));
+			break;
 		}
-		break;
+		/* nothing changed */
+		goto unlock;
 	default:
 		goto unlock;
 	}
 
-	if (unlikely(reset_cache))
-		dst_cache_reset(&peer->dst_cache);
-
-	/* if the peer did not float, we can bail out now */
-	if (likely(!salen))
-		goto unlock;
-
 	if (unlikely(ovpn_peer_reset_sockaddr(peer,
 					      (struct sockaddr_storage *)&ss,
 					      local_ip) < 0))
 		goto unlock;
 
+	/* reset the cache only after a successful bind update to avoid useless
+	 * cache misses on concurrent TX
+	 */
+	dst_cache_reset(&peer->dst_cache);
+
+	/* if only the local address changed, bail out now */
+	if (!floated)
+		goto unlock;
+
 	net_dbg_ratelimited("%s: peer %d floated to %pIScp",
 			    netdev_name(peer->ovpn->dev), peer->id, &ss);
 
-- 
2.53.0



