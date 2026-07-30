Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1884943F0AF;
	Thu, 30 Jul 2026 15:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425536; cv=none; b=SzlAIPW1EbM9zGkfVf3TPlXUso6Fc0VCvTXqeiZRXVMJE3lZdwbA4AADg2uQe+9lX7h7X68YlMTy5ZUyQ/yPK4aRsH453GdwToDt8hyEU9TWHML9Vso/RwtNDQF0QBs5ARR86tEhEX1lWr7kgKBnHagWjvCKdX9QX6a7um4BTVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425536; c=relaxed/simple;
	bh=QkI6t/1+T/DRDxarQDWQmd/vfWGmO2H1qHtcrz95BV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfOZA/OQLEZTLmJG9lfLor8WhK87C60VzoYtW90zw9ClqEm1ixONT7anYNrmJwEkJViE99CxBFmSNxhQfUf88BKz835g8uxNxOiQv1DOHlyG8KQSad4gdKj0AOSfEANy2YuvFkAE9Re399L6C1884cz30Qfzr3HK8aC8MeyLkYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOzL0mpC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOzL0mpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247191F000E9;
	Thu, 30 Jul 2026 15:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425534;
	bh=/EHcoMgw458uBSFILh65Anr3ATsiR6wm2KmMS+eALxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SOzL0mpCC6MhCHoAuTZ5eMMU3TEO4xyNu5i3a1MGjYiNVZb4CNdL0ztFtADXbceB0
	 o46ONM5kAIGuh/Sd/FOBpYCCkYegxqzQR8IipQBGm85mZRN5h+Pg7B39DYOa0DCzdJ
	 xJjSQ1Qmlpi6681wX+suDMFH0ki7o8TIgsr+K3Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/602] can: j1939: fix lockless local-destination check
Date: Thu, 30 Jul 2026 16:08:16 +0200
Message-ID: <20260730141438.179138833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit e4e8af62adab2fdcca230006f829407a953070cd ]

j1939_priv.ents[].nusers is documented as protected by priv->lock, and
its updates already happen under that lock. j1939_can_recv() also reads
it under read_lock_bh(). However, j1939_session_skb_queue() and
j1939_tp_send() still read priv->ents[da].nusers without taking the
lock.

Those transport-side checks decide whether to set J1939_ECU_LOCAL_DST, so
they can race with j1939_local_ecu_get() and j1939_local_ecu_put() while
userspace is binding or releasing sockets concurrently with TP traffic.
This can misclassify TP/ETP sessions as local or remote and take the wrong
transport path.

Fix both transport paths by routing the destination-locality check through
a helper that reads ents[].nusers under read_lock_bh(&priv->lock).

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20260419140614.GA4041240@chcpu16
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/transport.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 6c37562a50f72e..d8dada03b3cd12 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -350,6 +350,18 @@ static void j1939_session_skb_drop_old(struct j1939_session *session)
 	}
 }
 
+static bool j1939_address_is_local(struct j1939_priv *priv, u8 addr)
+{
+	bool local = false;
+
+	read_lock_bh(&priv->lock);
+	if (j1939_address_is_unicast(addr) && priv->ents[addr].nusers)
+		local = true;
+	read_unlock_bh(&priv->lock);
+
+	return local;
+}
+
 void j1939_session_skb_queue(struct j1939_session *session,
 			     struct sk_buff *skb)
 {
@@ -358,8 +370,7 @@ void j1939_session_skb_queue(struct j1939_session *session,
 
 	j1939_ac_fixup(priv, skb);
 
-	if (j1939_address_is_unicast(skcb->addr.da) &&
-	    priv->ents[skcb->addr.da].nusers)
+	if (j1939_address_is_local(priv, skcb->addr.da))
 		skcb->flags |= J1939_ECU_LOCAL_DST;
 
 	skcb->flags |= J1939_ECU_LOCAL_SRC;
@@ -2021,8 +2032,7 @@ struct j1939_session *j1939_tp_send(struct j1939_priv *priv,
 		return ERR_PTR(ret);
 
 	/* fix DST flags, it may be used there soon */
-	if (j1939_address_is_unicast(skcb->addr.da) &&
-	    priv->ents[skcb->addr.da].nusers)
+	if (j1939_address_is_local(priv, skcb->addr.da))
 		skcb->flags |= J1939_ECU_LOCAL_DST;
 
 	/* src is always local, I'm sending ... */
-- 
2.53.0



