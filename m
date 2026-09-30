Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E691E0DD8;
	Wed, 30 Sep 2026 16:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787125; cv=none; b=NRWXGtaQJUKx2qo+BoE6L3sUb1DUIcyMQdot6udOASZApuuPH4cWbzNSeIHi7M6AzJu9NcMRkpUFtN92em0wEK6VBhvxZiT32FQez4/DkNGez9awohGcWT8Tpva6FRiFyjzfavWkX7oMcy+V203+u+pMxKEZ+wRBL20AsEiGsBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787125; c=relaxed/simple;
	bh=N8+UUJDuKPx+x0LEoSHAhzOnddBIJewPbYrXdgBf8MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbzou+lwdVuF50bbMRCR6+Yjxl/Z+A4ANlQc36sVs7oERNmacDQxT0Fe0fXIiR9SJJd9Yxw2bHtBybOmRXQRK5nmSDwKNq9PhUb7eKuRDMm42fG+j7tanXYYtr9IAVk0UgXzdT3agqGk5mPTvDaYsRkG6D5FTxFfAAs3AAkV0N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dH9Ch6YO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dH9Ch6YO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072C81F0089A;
	Wed, 30 Sep 2026 16:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787123;
	bh=Uel2gB7OA+bKhlJEDP8yvznlbud0YwyFeQJx6/djx9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dH9Ch6YO3wf+dgvvHB0Rt+MXoGCJSxlv5KzQwxLxaP86sphNGXkjCHjWpIogq1lpq
	 J34ixmQh+536j1DCpchyyZ/hbzCGkM2jtBvCQ9s7Z5iN2lUaj15qPkx+cdtEKLNyf5
	 r6VlpN0E15XvLXwVINdQKKVnhrRRD6M3Rnn+Yn2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 121/457] ovpn: replace bind when clearing stale local source
Date: Wed, 30 Sep 2026 17:23:46 +0200
Message-ID: <20260930152348.663629095@linuxfoundation.org>
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
index eeef4a7229f5b..055cdb1bee13b 100644
--- a/drivers/net/ovpn/udp.c
+++ b/drivers/net/ovpn/udp.c
@@ -185,7 +185,7 @@ static void ovpn_dst_cache_check_key(struct ovpn_peer *peer,
  * to detect whether the bind was replaced while the route lookup was running.
  *
  * Return: true if the lookup result still matches the current peer state and
- * may update the dst cache.
+ * may update the dst cache or replace the bind.
  */
 static bool ovpn_dst_cache_current(const struct ovpn_peer *peer,
 				   const struct ovpn_bind *bind,
@@ -218,6 +218,9 @@ static int ovpn_udp4_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 			    struct sk_buff *skb,
 			    const struct ovpn_route_key *key)
 {
+	struct sockaddr_storage remote;
+	struct in_addr local = {};
+	bool reset_local = false;
 	struct rtable *rt;
 	struct flowi4 fl = {
 		.saddr = bind->local.ipv4.s_addr,
@@ -236,24 +239,17 @@ static int ovpn_udp4_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 
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
@@ -267,10 +263,28 @@ static int ovpn_udp4_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
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
@@ -300,6 +314,9 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 			    struct sk_buff *skb,
 			    const struct ovpn_route_key *key)
 {
+	struct in6_addr local = in6addr_any;
+	struct sockaddr_storage remote;
+	bool reset_local = false;
 	struct dst_entry *dst;
 	int ret;
 
@@ -320,15 +337,11 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 
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
 
 	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl, NULL);
@@ -340,10 +353,28 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
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



