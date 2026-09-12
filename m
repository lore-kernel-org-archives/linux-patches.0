Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6774437F8BC;
	Sat, 12 Sep 2026 09:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205665; cv=none; b=JAnkvW/V3y6JMyUa/tO18M6en7lHB8TIX3NNmYbAJiX0sOku/oJbDRx+ubl/vaVRjD8yPh3FwJNbBmtM/S8ApzitJrVkqTR8v6nXakrH1zRu2BVGJhG7m7zUbPggo0n0cQkP5ZXoOiOUXMZAu8c33969v9CAlVcb4Ff6FeEJhNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205665; c=relaxed/simple;
	bh=7rJ0dDxwRbqBl/e8KqR3FP31cp7Qhr98x1JqkoPl9WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHq4j8dKWZgd23VCTsiU2IQ7WPEBYhQxr+aos8F5cxcTruhOsd1LJKFkBldpOWFB/orQ4u1E44HSwbddcac7K+mD09coV+zY4KPd5JRo2ys+6fLz77S6BTHPZEX7/caLBWiKvSsRW5Now1Urnk5i7nV1SZ43RfFvlxBYJSjEjak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lv1vxscq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lv1vxscq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD46A1F000FF;
	Sat, 12 Sep 2026 09:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205663;
	bh=2gw1U4ZYAZkWWQkRDsVhYu7LT7IMTE/+jSeVAHF+4zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lv1vxscqxJaRu6sKBQoY0yAt0GF9jw5/T9xU0x9Z4sQ+eHOm7r+MWu0jnwwW4yrnM
	 mQvc8UTJqetZV9/jWXfO9zBPrEqBkew5IMA4sl9qXufQwhlKgVePNobTkoMa64bR4O
	 xg+kHt9lZwrybZN4C9KP3+6I8jQdWA4pCO4Qv8tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0007/1518] batman-adv: fix TX priority extraction for BATADV_FORW_MCAST
Date: Sat, 12 Sep 2026 08:36:16 +0200
Message-ID: <20260912065623.571946423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 7aedb59b80993c912ab45ce24386a2775150962b upstream.

batadv_mcast_forw_mode_by_count() pushs the skb->data for BATADV_FORW_MCAST
forwarding via batadv_mcast_forw_mcsend(). But the
batadv_skb_set_priority() expects the ethernet header directly before
(skb->data + offset). With the moved skb->data, just some random data would
be accessed to get the priority data.

Move the batadv_skb_set_priority() before the decision about the handling
multicast packets and potential header modifications.

Cc: stable@vger.kernel.org
Fixes: 90039133221e ("batman-adv: mcast: implement multicast packet generation")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/mesh-interface.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/mesh-interface.c b/net/batman-adv/mesh-interface.c
index 0d598bf39bfc2..3d49fd7ef3e62 100644
--- a/net/batman-adv/mesh-interface.c
+++ b/net/batman-adv/mesh-interface.c
@@ -258,6 +258,8 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 	if (batadv_compare_eth(ethhdr->h_dest, ectp_addr))
 		goto dropped;
 
+	batadv_skb_set_priority(skb, 0);
+
 	gw_mode = atomic_read(&bat_priv->gw.mode);
 	if (is_multicast_ether_addr(ethhdr->h_dest)) {
 		/* if gw mode is off, broadcast every packet */
@@ -291,6 +293,9 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 
 send:
 		if (do_bcast && !is_broadcast_ether_addr(ethhdr->h_dest)) {
+			/* WARNING batadv_mcast_forw_mode might add more headers
+			 * in front of the skb. and might even reallocate the skb
+			 */
 			forw_mode = batadv_mcast_forw_mode(bat_priv, skb, vid,
 							   &mcast_is_routable);
 			switch (forw_mode) {
@@ -308,8 +313,6 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 		}
 	}
 
-	batadv_skb_set_priority(skb, 0);
-
 	/* ethernet packet should be broadcasted */
 	if (do_bcast) {
 		primary_if = batadv_primary_if_get_selected(bat_priv);
-- 
2.53.0



