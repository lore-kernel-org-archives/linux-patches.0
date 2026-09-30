Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D777536E467;
	Wed, 30 Sep 2026 16:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787119; cv=none; b=DDaxQ6bKjZkO7cjswnQrNgszBKNzJFs9BEGugiHu52PVvwSd3icOLIR5woCr/I8hgnjEoAAxrORv1iZ8iCNTPMYTncUGPec1FraDpeNdFMMzVAVnf9FYcBUmsweKYzjhqmyRCMLbS5jVKsgEiCYHR5M8bJzs8Y9UKWyOyRAxsSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787119; c=relaxed/simple;
	bh=hZksQiy23Nb0lJsUe75pz+vk2078mwhd4It8mKj/pNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilgLk0U0mKeMLAXGRFwZdMXI72G7ncB20JHLe1xrkbedAlAnlFc8WEpEJbqOWGFjz1Jl42rOGF2fQqcPV6/nLYxDL6iU8zF1Spau0y+gw+ZfXdqzRIalNppx+qP8q5bEK5BLiLuDFPMPTGbA96BhRsxzPfZfcf6UBTlgD9+6rYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMiwHU3E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMiwHU3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBB31F000FF;
	Wed, 30 Sep 2026 16:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787117;
	bh=enx53yI4hzKnRo0bvI8aGBumc5eCAuCvRxJjwWAxtjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMiwHU3E8C7CYCPTCZhvPe9fsmMVXlTe9sd03xx/qSs2x6EXyErg3W3I8bA0px6Pz
	 wz7Hl2grPxUwg/e41/ENnt3XfvntZdN6ewrSgJDzkUXnAfqfU0ZQl4IDB/7vPZOLhH
	 SE4KVoGe7qqnQuX6KB7XIQp3aS2u1YWcf8KOt7wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 119/457] ovpn: validate peer state before caching UDP dst
Date: Wed, 30 Sep 2026 17:23:44 +0200
Message-ID: <20260930152348.620324655@linuxfoundation.org>
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
index c6d591cb7ff45..eeef4a7229f5b 100644
--- a/drivers/net/ovpn/udp.c
+++ b/drivers/net/ovpn/udp.c
@@ -173,6 +173,35 @@ static void ovpn_dst_cache_check_key(struct ovpn_peer *peer,
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
@@ -240,7 +269,7 @@ static int ovpn_udp4_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 
 	/* avoid storing a stale cache */
 	spin_lock_bh(&peer->lock);
-	if (likely(ovpn_route_key_equal(key, &peer->route_key)))
+	if (likely(ovpn_dst_cache_current(peer, bind, key)))
 		dst_cache_set_ip4(cache, &rt->dst, fl.saddr);
 	spin_unlock_bh(&peer->lock);
 
@@ -313,7 +342,7 @@ static int ovpn_udp6_output(struct ovpn_peer *peer, struct ovpn_bind *bind,
 
 	/* avoid storing a stale cache */
 	spin_lock_bh(&peer->lock);
-	if (likely(ovpn_route_key_equal(key, &peer->route_key)))
+	if (likely(ovpn_dst_cache_current(peer, bind, key)))
 		dst_cache_set_ip6(cache, dst, &fl.saddr);
 	spin_unlock_bh(&peer->lock);
 
-- 
2.53.0



