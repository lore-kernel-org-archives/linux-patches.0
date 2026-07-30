Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AB343BDCB;
	Thu, 30 Jul 2026 14:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421490; cv=none; b=e61rxucE3QT58ZGgfCCGDSEhv8BMZIxXMX2ZuODWCNR6m2gjjQGbJ8I4cP8dVm4V3Ic/sol9IcUici3U+ugwtzs2SKaxP9I2b5UQtPe+PAqeTvmBHTr9rJ3ygxnuVZ1HrkNkduoJwN/Ia0RrIAMwn867scO/ztC23X8gSy7bQg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421490; c=relaxed/simple;
	bh=qjmfUXxa8+z3v9jZk+A2dZaZxP4UMSHZmQD6BAZZaAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+fnisPFn2PuTHRMLZsW+38E9LO9hycu3MXYvZK2UbXqD9TtkuTj7xdzhUZVzJT9y0nKH5lTCgYOQd/sUXBxWLYuKsvMLALw6UQuZwkHXjBlEuUb9d7EOk2Ft0JQoy9cQmN886FiY6iUcygdb4c2aACkRiG0+1UQuUIjICuRr7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nf9G6IVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nf9G6IVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB15A1F000E9;
	Thu, 30 Jul 2026 14:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421489;
	bh=XocfkkKpgQMIogUWLjbt4NjmWN54nx24hoGBIgAReg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nf9G6IVF/TpJK99FOKx7oj8DQE8uOVC6ZPXvJSzONSrb064N1eEE1q/B+qrwReUfU
	 MkR5TNPch/DIZQk7DuJtxVcYCGraNUUj+ufx6Q1J0Bf8+E2gkiplc1iVtHZWdbBhNJ
	 m2fNveiBU8Z0hz6OixnAFmSUYHf5v4sbxg6Ec+PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 119/744] can: j1939: fix lockless local-destination check
Date: Thu, 30 Jul 2026 16:06:32 +0200
Message-ID: <20260730141446.810585052@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
index df93d57907da7e..8a31cb23bc76d0 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -351,6 +351,18 @@ static void j1939_session_skb_drop_old(struct j1939_session *session)
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
@@ -359,8 +371,7 @@ void j1939_session_skb_queue(struct j1939_session *session,
 
 	j1939_ac_fixup(priv, skb);
 
-	if (j1939_address_is_unicast(skcb->addr.da) &&
-	    priv->ents[skcb->addr.da].nusers)
+	if (j1939_address_is_local(priv, skcb->addr.da))
 		skcb->flags |= J1939_ECU_LOCAL_DST;
 
 	skcb->flags |= J1939_ECU_LOCAL_SRC;
@@ -2038,8 +2049,7 @@ struct j1939_session *j1939_tp_send(struct j1939_priv *priv,
 		return ERR_PTR(ret);
 
 	/* fix DST flags, it may be used there soon */
-	if (j1939_address_is_unicast(skcb->addr.da) &&
-	    priv->ents[skcb->addr.da].nusers)
+	if (j1939_address_is_local(priv, skcb->addr.da))
 		skcb->flags |= J1939_ECU_LOCAL_DST;
 
 	/* src is always local, I'm sending ... */
-- 
2.53.0



