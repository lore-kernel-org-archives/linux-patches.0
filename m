Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEE23AEF2E;
	Wed, 30 Sep 2026 18:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793009; cv=none; b=ck1QbIDFFT6jqw1bHBEtSnt6pTIDBL0ILv1iCS9oMvVeNObpZXB6c3Wmz7KRVX1W1HO0mbZ3ncQIKr18WYry7dRQX+c5NaBEd9RPHcaAURxUYs1cftsorJWeqCADt0R9/pNbWBaew39KPL+2ho6YKK/nSVZA/eIOrKz0SkhF3TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793009; c=relaxed/simple;
	bh=xtoqGBFKniLFnaAydSmsE6tq9WIWFXSYFRs7xQvwDsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBKa2/zXb2a3ZgNedrQc4bJcLIDJVqYil8yjmvIgQ3iB9czajaBuv9e/mKyIcKl8Nikfjme5Ernn/3YsvM+k4EW6tOv8qLL3q2ocoeQNALPUmOBGt4IhRcBPXrKblZktbqK4pbPGKqfR9A3lXhhaJ3+HjZI3n9TID1rbMoAi788=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldL+sOug; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldL+sOug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449BC1F000FF;
	Wed, 30 Sep 2026 18:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793007;
	bh=bVtdepO+CsWv9P4bIGMRPusiV+GUZ+yZghyueoF/Weg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldL+sOugnhAI9le5BOKjsqHsTu2YCVU6GBq8bPMxjxvazV4kzjBsheceo5dRpk/rQ
	 lHuvqaACukrX3+yFQLSO1X2ehJSIeLYqo0PiPvXvcJLqxG1tbQclU+c9dwLmZ6+MJp
	 m8dpB6t2AzuggULYctTY6Tpjcbe01Ay9P0kIPzL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/395] ovpn: replace bind when clearing stale local source
Date: Wed, 30 Sep 2026 17:26:05 +0200
Message-ID: <20260930152342.870067526@linuxfoundation.org>
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

[ Upstream commit 7d8104988f423572df1f3347ce578037b1043f34 ]

The UDP output fallback clears bind->local in place when the remembered
source address is no longer usable. The bind is RCU-published and read
locklessly by concurrent TX, so an IPv6 reader can observe a torn
address.

Retry the route lookup with source address autoselection without
modifying the bind. After a successful lookup, revalidate the bind and
route key under peer->lock, reset the dst cache, and best-effort publish
a replacement bind with a wildcard local address.

Do not cache the resolved dst when clearing the local source. Replacing
the source invalidates all per-CPU cache entries, while
dst_cache_set_ip4 and dst_cache_set_ip6 update only the current CPU
slot. The current packet can still use the resolved route; if bind
allocation fails, a later cache miss retries the repair.

Fixes: 08857b5ec5d9 ("ovpn: implement basic TX path (UDP)")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/udp.c | 81 +++++++++++++++++++++++++++++-------------
 1 file changed, 56 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ovpn/udp.c b/drivers/net/ovpn/udp.c
index 6ca482144dc4f..0b620c6cc64dd 100644
--- a/drivers/net/ovpn/udp.c
+++ b/drivers/net/ovpn/udp.c
@@ -186,7 +186,7 @@ static void ovpn_dst_cache_check_key(struct ovpn_peer *peer,
  * to detect whether the bind was replaced while the route lookup was running.
  *
  * Return: true if the lookup result still matches the current peer state and
- * may update the dst cache.
+ * may update the dst cache or replace the bind.
  */
 static bool ovpn_dst_cache_current(const struct ovpn_peer *peer,
 				   const struct ovpn_bind *bind,
@@ -219,6 +219,9 @@ static int ovpn_udp4_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 			    struct sk_buff *skb,
 			    const struct ovpn_route_key *key)
 {
+	struct sockaddr_storage remote;
+	struct in_addr local = {};
+	bool reset_local = false;
 	struct rtable *rt;
 	struct flowi4 fl = {
 		.saddr = bind->local.ipv4.s_addr,
@@ -237,24 +240,17 @@ static int ovpn_udp4_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 
 	if (fl.saddr && unlikely(!inet_confirm_addr(sock_net(sk), NULL, 0,
 						    fl.saddr, RT_SCOPE_HOST))) {
-		/* we may end up here when the cached address is not usable
-		 * anymore. In this case we reset address/cache and perform a
-		 * new look up
+		/* The learned local address is not usable anymore.
+		 * Retry with source address autoselection.
 		 */
 		fl.saddr = 0;
-		spin_lock_bh(&peer->lock);
-		bind->local.ipv4.s_addr = 0;
-		spin_unlock_bh(&peer->lock);
-		dst_cache_reset(cache);
+		reset_local = true;
 	}
 
 	rt = ip_route_output_flow(sock_net(sk), &fl, sk);
 	if (IS_ERR(rt) && PTR_ERR(rt) == -EINVAL) {
 		fl.saddr = 0;
-		spin_lock_bh(&peer->lock);
-		bind->local.ipv4.s_addr = 0;
-		spin_unlock_bh(&peer->lock);
-		dst_cache_reset(cache);
+		reset_local = true;
 
 		rt = ip_route_output_flow(sock_net(sk), &fl, sk);
 	}
@@ -268,10 +264,28 @@ static int ovpn_udp4_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 		goto err;
 	}
 
-	/* avoid storing a stale cache */
+	/* avoid storing a stale cache or local address */
 	spin_lock_bh(&peer->lock);
-	if (likely(ovpn_dst_cache_current(peer, bind, key)))
-		dst_cache_set_ip4(cache, &rt->dst, fl.saddr);
+	if (likely(ovpn_dst_cache_current(peer, bind, key))) {
+		if (!reset_local) {
+			dst_cache_set_ip4(cache, &rt->dst, fl.saddr);
+			spin_unlock_bh(&peer->lock);
+			goto transmit;
+		}
+
+		/* invalidate per-CPU dst entries that may still carry
+		 * the stale source
+		 */
+		dst_cache_reset(cache);
+
+		/* preserve the current remote */
+		memcpy(&remote, &bind->remote, sizeof(struct sockaddr_in));
+		/* The current packet already has a valid wildcard-source route.
+		 * If replacing the bind fails, leave the stale local in place;
+		 * a later cache miss will retry the repair.
+		 */
+		ovpn_peer_reset_sockaddr(peer, &remote, &local);
+	}
 	spin_unlock_bh(&peer->lock);
 
 transmit:
@@ -301,6 +315,9 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 			    struct sk_buff *skb,
 			    const struct ovpn_route_key *key)
 {
+	struct in6_addr local = in6addr_any;
+	struct sockaddr_storage remote;
+	bool reset_local = false;
 	struct dst_entry *dst;
 	int ret;
 
@@ -321,15 +338,11 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 
 	if (!ipv6_addr_any(&fl.saddr) &&
 	    unlikely(!ipv6_chk_addr(sock_net(sk), &fl.saddr, NULL, 0))) {
-		/* we may end up here when the cached address is not usable
-		 * anymore. In this case we reset address/cache and perform a
-		 * new look up
+		/* The learned local address is not usable anymore.
+		 * Retry with source address autoselection.
 		 */
 		fl.saddr = in6addr_any;
-		spin_lock_bh(&peer->lock);
-		bind->local.ipv6 = in6addr_any;
-		spin_unlock_bh(&peer->lock);
-		dst_cache_reset(cache);
+		reset_local = true;
 	}
 
 	dst = ipv6_stub->ipv6_dst_lookup_flow(sock_net(sk), sk, &fl, NULL);
@@ -341,10 +354,28 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 		goto err;
 	}
 
-	/* avoid storing a stale cache */
+	/* avoid storing a stale cache or local address */
 	spin_lock_bh(&peer->lock);
-	if (likely(ovpn_dst_cache_current(peer, bind, key)))
-		dst_cache_set_ip6(cache, dst, &fl.saddr);
+	if (likely(ovpn_dst_cache_current(peer, bind, key))) {
+		if (!reset_local) {
+			dst_cache_set_ip6(cache, dst, &fl.saddr);
+			spin_unlock_bh(&peer->lock);
+			goto transmit;
+		}
+
+		/* invalidate per-CPU dst entries that may still carry
+		 * the stale source
+		 */
+		dst_cache_reset(cache);
+
+		/* preserve the current remote */
+		memcpy(&remote, &bind->remote, sizeof(struct sockaddr_in6));
+		/* The current packet already has a valid wildcard-source route.
+		 * If replacing the bind fails, leave the stale local in place;
+		 * a later cache miss will retry the repair.
+		 */
+		ovpn_peer_reset_sockaddr(peer, &remote, &local);
+	}
 	spin_unlock_bh(&peer->lock);
 
 transmit:
-- 
2.53.0



