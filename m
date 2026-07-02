Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3FE3D9558;
	Thu,  2 Jul 2026 16:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009426; cv=none; b=qfcwwcDSRZxR5DkSaiTowSO1Mrm6WIHcDSaTPCvhEwOmhsGS41u5Lij6GcrTfu1ss5Zr5wGIibslaHMgxOxge+mcERt44Z/bGEW+33ZQCrmXdHXDmCXEHey9q/eeue7XnFuGHaKj3pMOsZOFYXuL5ACI3CSqsxif/dDUunXOkcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009426; c=relaxed/simple;
	bh=Wa/g4trUSD04HFWXpjmx23Je0EykOMmlk/ffpgxoFA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMAFOySP6ll/2UJqFSxe21SfOOTYZeY+ndAsjl/buvzQmLlmsYDOT9JBvYeK+7oQTbGVQ15CE/RSMiNr/+oiLKZ62Oa/UzgdBHdoJ8UVjdKxEjGwut6misYpONhu1rebCFY4PEq76a/j9h5SDHIMFDW8kQHKhfEGU6zHliH3kuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGQfF7Qv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGQfF7Qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491C11F00A3E;
	Thu,  2 Jul 2026 16:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009418;
	bh=p1QruZScJk3FrczJ+N1d4+TvI38ST2NPTAX6UjGSOC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGQfF7Qv50ke9AmC36jRSxt9BvreTiKTVFm+VL+Fq+xOY8j7Bhr7A/eLai2jkYEhk
	 k3IyUSFMTK+/N9cY/74ptKDvBx6P3JNTf5WSzA4n4hxpKfEG9rJdd7mED96/PO7g2m
	 O+WDtOg+2o+7TZyXCRr/h3OpJs+0StIyjBpFhXBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/96] batman-adv: bla: annotate lasttime access with READ/WRITE_ONCE
Date: Thu,  2 Jul 2026 18:19:34 +0200
Message-ID: <20260702155109.871810009@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 98b0fb191c878a64cbaebfe231d96d57576acf8c upstream.

The lasttime field for claim, backbone_gw, and loopdetect tracks the
jiffies value of the most recent activity and is used to detect timeouts.
These accesses are not consistently protected by a lock, so
READ_ONCE/WRITE_ONCE must be used to prevent data races caused by compiler
optimizations.

Cc: stable@kernel.org
Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bridge_loop_avoidance.c | 28 +++++++++++++-------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 00185ed4940f23..5593ac0aae378a 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -517,7 +517,7 @@ batadv_bla_get_backbone_gw(struct batadv_priv *bat_priv, u8 *orig,
 		return NULL;
 
 	entry->vid = vid;
-	entry->lasttime = jiffies;
+	WRITE_ONCE(entry->lasttime, jiffies);
 	entry->crc = BATADV_BLA_CRC_INIT;
 	entry->bat_priv = bat_priv;
 	spin_lock_init(&entry->crc_lock);
@@ -585,7 +585,7 @@ batadv_bla_update_own_backbone_gw(struct batadv_priv *bat_priv,
 	if (unlikely(!backbone_gw))
 		return;
 
-	backbone_gw->lasttime = jiffies;
+	WRITE_ONCE(backbone_gw->lasttime, jiffies);
 	batadv_backbone_gw_put(backbone_gw);
 }
 
@@ -719,7 +719,7 @@ static void batadv_bla_add_claim(struct batadv_priv *bat_priv,
 		ether_addr_copy(claim->addr, mac);
 		spin_lock_init(&claim->backbone_lock);
 		claim->vid = vid;
-		claim->lasttime = jiffies;
+		WRITE_ONCE(claim->lasttime, jiffies);
 		kref_get(&backbone_gw->refcount);
 		claim->backbone_gw = backbone_gw;
 		kref_init(&claim->refcount);
@@ -741,7 +741,7 @@ static void batadv_bla_add_claim(struct batadv_priv *bat_priv,
 			return;
 		}
 	} else {
-		claim->lasttime = jiffies;
+		WRITE_ONCE(claim->lasttime, jiffies);
 		if (claim->backbone_gw == backbone_gw)
 			/* no need to register a new backbone */
 			goto claim_free_ref;
@@ -774,7 +774,7 @@ static void batadv_bla_add_claim(struct batadv_priv *bat_priv,
 	spin_lock_bh(&backbone_gw->crc_lock);
 	backbone_gw->crc ^= crc16(0, claim->addr, ETH_ALEN);
 	spin_unlock_bh(&backbone_gw->crc_lock);
-	backbone_gw->lasttime = jiffies;
+	WRITE_ONCE(backbone_gw->lasttime, jiffies);
 
 claim_free_ref:
 	batadv_claim_put(claim);
@@ -863,7 +863,7 @@ static bool batadv_handle_announce(struct batadv_priv *bat_priv, u8 *an_addr,
 		return true;
 
 	/* handle as ANNOUNCE frame */
-	backbone_gw->lasttime = jiffies;
+	WRITE_ONCE(backbone_gw->lasttime, jiffies);
 	crc = ntohs(*((__force __be16 *)(&an_addr[4])));
 
 	batadv_dbg(BATADV_DBG_BLA, bat_priv,
@@ -1258,7 +1258,7 @@ static void batadv_bla_purge_backbone_gw(struct batadv_priv *bat_priv, int now)
 						  head, hash_entry) {
 				if (now)
 					goto purge_now;
-				if (!batadv_has_timed_out(backbone_gw->lasttime,
+				if (!batadv_has_timed_out(READ_ONCE(backbone_gw->lasttime),
 							  BATADV_BLA_BACKBONE_TIMEOUT))
 					continue;
 
@@ -1339,7 +1339,7 @@ static void batadv_bla_purge_claims(struct batadv_priv *bat_priv,
 						primary_if->net_dev->dev_addr))
 				goto skip;
 
-			if (!batadv_has_timed_out(claim->lasttime,
+			if (!batadv_has_timed_out(READ_ONCE(claim->lasttime),
 						  BATADV_BLA_CLAIM_TIMEOUT))
 				goto skip;
 
@@ -1499,7 +1499,7 @@ static void batadv_bla_periodic_work(struct work_struct *work)
 		eth_random_addr(bat_priv->bla.loopdetect_addr);
 		bat_priv->bla.loopdetect_addr[0] = 0xba;
 		bat_priv->bla.loopdetect_addr[1] = 0xbe;
-		bat_priv->bla.loopdetect_lasttime = jiffies;
+		WRITE_ONCE(bat_priv->bla.loopdetect_lasttime, jiffies);
 		atomic_set(&bat_priv->bla.loopdetect_next,
 			   BATADV_BLA_LOOPDETECT_PERIODS);
 
@@ -1520,7 +1520,7 @@ static void batadv_bla_periodic_work(struct work_struct *work)
 						primary_if->net_dev->dev_addr))
 				continue;
 
-			backbone_gw->lasttime = jiffies;
+			WRITE_ONCE(backbone_gw->lasttime, jiffies);
 
 			batadv_bla_send_announce(bat_priv, backbone_gw);
 			if (send_loopdetect)
@@ -1907,7 +1907,7 @@ batadv_bla_loopdetect_check(struct batadv_priv *bat_priv, struct sk_buff *skb,
 	/* If the packet came too late, don't forward it on the mesh
 	 * but don't consider that as loop. It might be a coincidence.
 	 */
-	if (batadv_has_timed_out(bat_priv->bla.loopdetect_lasttime,
+	if (batadv_has_timed_out(READ_ONCE(bat_priv->bla.loopdetect_lasttime),
 				 BATADV_BLA_LOOPDETECT_TIMEOUT))
 		return true;
 
@@ -2023,7 +2023,7 @@ bool batadv_bla_rx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 
 	if (own_claim) {
 		/* ... allow it in any case */
-		claim->lasttime = jiffies;
+		WRITE_ONCE(claim->lasttime, jiffies);
 		goto allow;
 	}
 
@@ -2127,7 +2127,7 @@ bool batadv_bla_tx(struct batadv_priv *bat_priv, struct sk_buff *skb,
 		/* if yes, the client has roamed and we have
 		 * to unclaim it.
 		 */
-		if (batadv_has_timed_out(claim->lasttime, 100)) {
+		if (batadv_has_timed_out(READ_ONCE(claim->lasttime), 100)) {
 			/* only unclaim if the last claim entry is
 			 * older than 100 ms to make sure we really
 			 * have a roaming client here.
@@ -2513,7 +2513,7 @@ batadv_bla_backbone_dump_entry(struct sk_buff *msg, u32 portid,
 	backbone_crc = backbone_gw->crc;
 	spin_unlock_bh(&backbone_gw->crc_lock);
 
-	msecs = jiffies_to_msecs(jiffies - backbone_gw->lasttime);
+	msecs = jiffies_to_msecs(jiffies - READ_ONCE(backbone_gw->lasttime));
 
 	if (is_own)
 		if (nla_put_flag(msg, BATADV_ATTR_BLA_OWN)) {
-- 
2.53.0



