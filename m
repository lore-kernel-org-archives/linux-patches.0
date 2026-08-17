Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390A33E4C94;
	Mon, 17 Aug 2026 13:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973933; cv=none; b=VSoCmXR13KU5bh7pNo8DK93Aux5GEN8rwFvQNpsDcjGyd+7dM3KyNWiD6n68wSzcn9ERmfkFZUtpT3PIyrpGVzshwPJhZRmYCVpNyOEXkbYtlzv+1QzS4mvoIru6EN6m0BdkqAg4rcph+GcnnaA7Vtwy4uQOtqBC7oh/6eeqgOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973933; c=relaxed/simple;
	bh=SQt5KZaB4Xg0OQRD3/5f/s81qe4JeDzup9kgJVLiE/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3s4sKG02H4S3lQRvhOEqZq2XulSt/eA9Dr5vApkBu603mnJF3qmWcbRqqCPT9lxpgCMKexUXS8UKTgti4L7MMeWGP6kLJkmoQrtCFtHZkKfFVEqYg7YCLPExrL9Lw1R5Iq7GlEMcPv/nn/DQs086gcsl79ggu366qLlq8m15mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FaKZD3/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FaKZD3/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DA31F000E9;
	Mon, 17 Aug 2026 13:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973932;
	bh=52WY7nQsYH6SMNWQTZNjb9+GLno2G8sT42Rvpp4Mrkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FaKZD3/WjfiRAar0YrVF3kKpt+1SYE7g8hftqnbzyvdTKFqJrZtPqo4hqr9EJhjxr
	 2blNxunv8nKCevdeskaHiwH2EkzhmZg2AhQ0x8HqurEHwGxOjMF+NkxwCHRFgQ1jzE
	 f1bDwOlhkEjamJIHHPbxkynCZDz38WERDRhl+mxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 030/271] ovpn: zero-initialize sockaddr before learning a floated endpoint
Date: Mon, 17 Aug 2026 15:29:15 +0200
Message-ID: <20260817132537.991663793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index a330892e82bf7..33fb0a75e6006 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -222,9 +222,16 @@ void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
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
@@ -250,11 +257,19 @@ void ovpn_peer_endpoints_update(struct ovpn_peer *peer, struct sk_buff *skb)
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



