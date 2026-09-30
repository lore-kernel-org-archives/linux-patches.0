Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE4E51DDEA;
	Wed, 30 Sep 2026 18:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793003; cv=none; b=LYs6B6/CNywNVMSBAyysGaSsqyUO3JoKyFgku9BBu3ce9YT8F9HA6C9EmLT5RmQULRmIHGwfvV8I/drOdwBfAoZBF96W+wd7OqYFcbd6LiO55VS646KCm9H3DoklfK7oyRo/o61XxHsH7AE92wtoOccQ7BGtErayFO5GE5Rkcbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793003; c=relaxed/simple;
	bh=DZY7L+xULzPwF1EgdP5RZREwCIoR1mSwclSe0eGRD0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpBdCpj0A5TeloUwd0HpBVRpbZRPq1z682iH+j8Zrq0DgUkUBXrN4/f7W83vZKB6IvEK5bC9TOaeCYTiL2LmDtS9mKISIgQkh4VJznES1unz9oePZRvNkUuFUlQvGWSaKPY7VGgvQNJfxlsIE6XJ5KYRteduYLp0AHMwM5bEn7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUPquLtg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUPquLtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8C31F000FF;
	Wed, 30 Sep 2026 18:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793002;
	bh=ldtnk37Sf1b91BB7WgTvJPyPiJgZrDH/E+mCkmXH+IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUPquLtg0F+T1MZnGoKHO0WV2aMbPtGlDY/ZAfd+4/pDO9z4OCNvC7ecTNlQVkHGP
	 3j3HEYx9fr00xQAwmaNH2oHzc6TtLCr+wz8wAKI5rUUe1qJyOvHtqipTcifuG7sq1A
	 iD01ixa8v3I8+mDV5B0ikzqq6+VKRajM8R8oqMrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/395] ovpn: validate peer state before caching UDP dst
Date: Wed, 30 Sep 2026 17:26:03 +0200
Message-ID: <20260930152342.825528122@linuxfoundation.org>
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

[ Upstream commit fa603710bdb9aea33c0d9cc2c05ed24d84f58753 ]

UDP route lookup runs without peer->lock while the bind is protected by
RCU. The route key is snapshotted separately. Either can change while
the lookup is in progress.

The TX path currently checks only the route key before publishing the
looked-up dst. If the bind changes but the route key does not, a dst
resolved from the old endpoint can be installed in the cache after the
bind replacement.

Compare both the bind pointer and the route key under peer->lock before
updating the cache. The RCU read-side critical section keeps the old
bind alive throughout the lookup, so pointer identity is sufficient to
detect a replacement.

Fixes: f0281c1d3732 ("ovpn: add support for updating local or remote UDP endpoint")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/udp.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ovpn/udp.c b/drivers/net/ovpn/udp.c
index 8be5f64e0a1fa..6ca482144dc4f 100644
--- a/drivers/net/ovpn/udp.c
+++ b/drivers/net/ovpn/udp.c
@@ -174,6 +174,35 @@ static void ovpn_dst_cache_check_key(struct ovpn_peer *peer,
 	spin_unlock_bh(&peer->lock);
 }
 
+/**
+ * ovpn_dst_cache_current - check whether a route lookup matches peer state
+ * @peer: the peer owning the bind and dst cache
+ * @bind: the RCU bind used for the route lookup
+ * @key: the route key used for the route lookup
+ *
+ * Check that @bind is still the current peer bind and that @key still matches
+ * the peer route key. The caller must hold @peer->lock. The TX path keeps
+ * @bind inside an RCU read-side critical section, so pointer identity is enough
+ * to detect whether the bind was replaced while the route lookup was running.
+ *
+ * Return: true if the lookup result still matches the current peer state and
+ * may update the dst cache.
+ */
+static bool ovpn_dst_cache_current(const struct ovpn_peer *peer,
+				   const struct ovpn_bind *bind,
+				   const struct ovpn_route_key *key)
+{
+	const struct ovpn_bind *curr_bind;
+
+	lockdep_assert_held(&peer->lock);
+
+	curr_bind = rcu_dereference_protected(peer->bind,
+					      lockdep_is_held(&peer->lock));
+
+	return curr_bind == bind &&
+	       ovpn_route_key_equal(key, &peer->route_key);
+}
+
 /**
  * ovpn_udp4_output - send IPv4 packet over udp socket
  * @peer: the destination peer
@@ -241,7 +270,7 @@ static int ovpn_udp4_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 
 	/* avoid storing a stale cache */
 	spin_lock_bh(&peer->lock);
-	if (likely(ovpn_route_key_equal(key, &peer->route_key)))
+	if (likely(ovpn_dst_cache_current(peer, bind, key)))
 		dst_cache_set_ip4(cache, &rt->dst, fl.saddr);
 	spin_unlock_bh(&peer->lock);
 
@@ -314,7 +343,7 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 
 	/* avoid storing a stale cache */
 	spin_lock_bh(&peer->lock);
-	if (likely(ovpn_route_key_equal(key, &peer->route_key)))
+	if (likely(ovpn_dst_cache_current(peer, bind, key)))
 		dst_cache_set_ip6(cache, dst, &fl.saddr);
 	spin_unlock_bh(&peer->lock);
 
-- 
2.53.0



