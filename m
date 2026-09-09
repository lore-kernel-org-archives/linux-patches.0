Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D5652ED5E;
	Wed,  9 Sep 2026 13:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962182; cv=none; b=f+RuC2BoDHkD5Z052VltW+JXzXdYT+iFP/aaHjCFTPawBzBy8FfEyjEal7NaPY9wr9Z21QgbCvJEdKCbB8miQz33a4Wwh889qoPgUsVcJhqG21z53qU540CDrpDUq8Wa9LfM5PB67i+MVNjy9CPKQKsERDC1ELy8ceXXNmDGw2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962182; c=relaxed/simple;
	bh=l+7Qqf+uFviMZxwR5jfqmAANUUO37/hXWymtyeJHsTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxdgJZMHULQVXrEMAXsCUon6FFkjWeYM6NVeIs+XnudOQ1xnnmYHiLnjkHe/r7fneXM1BRlbBWOAblOTwUkYKI0T+qH6cI/cCu/1n+fKhCZ6e2V5tUdKfdeopVFf9CGi1t7rPPtadteCwjjHSJh00/1Cb2sOeC5LQ1SDTLVfAEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2K0TLyt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2K0TLyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E751F00A3A;
	Wed,  9 Sep 2026 13:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962181;
	bh=b6MAuoQcktXPYHRjAE+PlQsQD7GPRCyT6O/neN0FE68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j2K0TLyt90aN7DkQV5hpfMOFD5igPLQYKynjXDF1f965XutJKwQzj8n+lcfdYIrtI
	 lWt98k/RObsIkNHpoJYbOg+sXd9l+86SeiszPRCWkE0aDskZWlC2k21V6j2Jupcpjx
	 YaV0s8+pZRa9uYuBiUXQHlW/KtwPjoOvSPwmOnwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.2 201/556] batman-adv: fix TX priority extraction for BATADV_FORW_MCAST
Date: Wed,  9 Sep 2026 15:38:01 +0200
Message-ID: <20260909134237.464722936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/mesh-interface.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/batman-adv/mesh-interface.c
+++ b/net/batman-adv/mesh-interface.c
@@ -260,6 +260,8 @@ static netdev_tx_t batadv_interface_tx(s
 	if (batadv_compare_eth(ethhdr->h_dest, ectp_addr))
 		goto dropped;
 
+	batadv_skb_set_priority(skb, 0);
+
 	gw_mode = READ_ONCE(bat_priv->gw.mode);
 	if (is_multicast_ether_addr(ethhdr->h_dest)) {
 		/* if gw mode is off, broadcast every packet */
@@ -293,6 +295,9 @@ static netdev_tx_t batadv_interface_tx(s
 
 send:
 		if (do_bcast && !is_broadcast_ether_addr(ethhdr->h_dest)) {
+			/* WARNING batadv_mcast_forw_mode might add more headers
+			 * in front of the skb. and might even reallocate the skb
+			 */
 			forw_mode = batadv_mcast_forw_mode(bat_priv, skb, vid,
 							   &mcast_is_routable);
 			switch (forw_mode) {
@@ -310,8 +315,6 @@ send:
 		}
 	}
 
-	batadv_skb_set_priority(skb, 0);
-
 	/* ethernet packet should be broadcasted */
 	if (do_bcast) {
 		primary_if = batadv_primary_if_get_selected(bat_priv);


