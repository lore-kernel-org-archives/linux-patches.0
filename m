Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC613D8900;
	Mon, 17 Aug 2026 13:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974709; cv=none; b=hRIH5azVLKGrKfRixM+icmzDKnE+WE0t8vJIvUr7QRrtkXxsGZJ2xedDOE6XDOSenU1ynsYTML4oAuiPzOfKqHJ16/sO4294NsR+lFzU2g6gdt958EffKh4OBY5ClFFAGFNqa5mxvHlecMbMkOhvLG0vuskGTMqWiPzWx0UwuNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974709; c=relaxed/simple;
	bh=bxGx4kp5vzbZyH1ZB3fmEDdZnScMblU3WmLaeH1zlmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6XFpea7ORQZEt5ZS+F9n7/dbUYcwbraQh7+GYijTm76mn3nYbkwY6hdY3JqUPFg1KMtgym8ne9PWHy4B0yrv3FPAHqnHGaVTy3bhxIsG0z+GjNFwashh1Js7PnSLlNSb0WGi6KaNTRR3AIpETwbweuDVuMofxOXOxaBiuY3iY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4lvw0aD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4lvw0aD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D81B1F000E9;
	Mon, 17 Aug 2026 13:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974704;
	bh=V5jhXwJEWqXQ7m3D9KrheBy2hb6YP6RnXnZd39g4+eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M4lvw0aD33mgLacYlep1Qo1ijPXh5pdd/CWjGswu8sNc9Y+2bhwL1aXh18P0K8u5u
	 dXhSk7Et4hXjOk5cpN86bjoMAIDzBfK85QwhtraXi68qOwFULBYnb09+9+CCZ3ZRkf
	 gPgHULtXkqdEQQ73rzy5WwUeOTKns+bFE/+njlkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/250] ovpn: zero-initialize sockaddr before learning a floated endpoint
Date: Mon, 17 Aug 2026 15:29:46 +0200
Message-ID: <20260817132537.487508472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Antonio Quartulli <antonio@openvpn.net>

[ Upstream commit 3f012bdbabe211ccbc0c50ea5a1dbc60f8af1532 ]

ovpn_peer_endpoints_update() builds the new remote endpoint in an
on-stack struct sockaddr_storage that is left uninitialized. For IPv4
only sin_family/sin_addr/sin_port are written, leaving the 8-byte
sin_zero padding as stack garbage (for IPv6, sin6_flowinfo is left
uninitialized likewise).

ovpn_peer_reset_sockaddr() -> ovpn_bind_from_sockaddr() then memcpy()s
sizeof(struct sockaddr_in)/sizeof(struct sockaddr_in6) bytes - padding
included - into bind->remote. That buffer is later hashed with jhash()
over the same length to place the peer in the by_transp_addr table, so
the garbage padding lands the floated peer in an essentially random
bucket. Lockless lookups in ovpn_peer_get_by_transp_addr() build their
key from a zero-initialized sockaddr_storage, compute a different bucket
and fail to find the peer.

This is also a plain use of uninitialized stack memory in jhash().

Build the floated endpoint with a designated initializer so the
padding (sin_zero for IPv4, sin6_flowinfo for IPv6) is zeroed as part
of the assignment. This keeps the padding out of the by_transp_addr
hash key without memset-ing the whole sockaddr_storage on every
received packet.

Fixes: f0281c1d3732 ("ovpn: add support for updating local or remote UDP endpoint")
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/peer.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index f502f9c576f8f..3824ee1c2e40a 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -218,9 +218,16 @@ void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
 			 */
 			local_ip = &ip_hdr(skb)->daddr;
 			sa = (struct sockaddr_in *)&ss;
-			sa->sin_family = AF_INET;
-			sa->sin_addr.s_addr = ip_hdr(skb)->saddr;
-			sa->sin_port = udp_hdr(skb)->source;
+			/* use a designated initializer so the sin_zero padding
+			 * is zeroed (it ends up in the by_transp_addr hash key)
+			 * without memset-ing the whole sockaddr_storage on the
+			 * RX fast path
+			 */
+			*sa = (struct sockaddr_in) {
+				.sin_family = AF_INET,
+				.sin_addr.s_addr = ip_hdr(skb)->saddr,
+				.sin_port = udp_hdr(skb)->source,
+			};
 			salen = sizeof(*sa);
 			reset_cache = true;
 			break;
@@ -246,11 +253,19 @@ void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
 			 */
 			local_ip = &ipv6_hdr(skb)->daddr;
 			sa6 = (struct sockaddr_in6 *)&ss;
-			sa6->sin6_family = AF_INET6;
-			sa6->sin6_addr = ipv6_hdr(skb)->saddr;
-			sa6->sin6_port = udp_hdr(skb)->source;
-			sa6->sin6_scope_id = ipv6_iface_scope_id(&ipv6_hdr(skb)->saddr,
-								 skb->skb_iif);
+			/* use a designated initializer so the sin6_flowinfo
+			 * padding is zeroed (it ends up in the by_transp_addr
+			 * hash key) without memset-ing the whole
+			 * sockaddr_storage on the RX fast path
+			 */
+			*sa6 = (struct sockaddr_in6) {
+				.sin6_family = AF_INET6,
+				.sin6_addr = ipv6_hdr(skb)->saddr,
+				.sin6_port = udp_hdr(skb)->source,
+				.sin6_scope_id =
+					ipv6_iface_scope_id(&ipv6_hdr(skb)->saddr,
+							    skb->skb_iif),
+			};
 			salen = sizeof(*sa6);
 			reset_cache = true;
 			break;
-- 
2.53.0



