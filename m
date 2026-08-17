Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB603033E7;
	Mon, 17 Aug 2026 14:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975471; cv=none; b=rzdybfBcavqGSKAMAhoyDB9ScPCm4xAx73AqYLY1lUNcfASIqxQ8sBUIktvziM5J7qHwEkW+vJ7S7xSp4NBkFb9zgyCG7bSfqGxgObxK4bX5UbPd1zH2tCehFjHUOlvZPkzn9ydpFHicCo6H+i5twlyiHR+aywBfOqNK4AHZ6Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975471; c=relaxed/simple;
	bh=RSSlO95HzFNdg72F4W9vWgxzMCe8kbfSQ/jGOf4MdmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiurGDQLjYMf+/Qsfl3nzQqzzuzWm/dWlRc3aP7F7AVUAceOY3/D68dteVpmCEINCiELpEw9u7s6QebMkqXPr2ZvM7dTDjfidYacUffVGqsmXUKPiRrUsS37YN6E0HiZnOmL/clTDxuY2mcC8pRTHbguLcuRqpoyucuFCGk/izE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHEQHhE3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHEQHhE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F411F000E9;
	Mon, 17 Aug 2026 14:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975470;
	bh=ZBFwbbRYY6LuLdyTlBSlweBYDk88AJfA0mHI6lWdzyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xHEQHhE3w7gQL1bJC1H8n5FY14Ne+iySPu68kxRSYLjNLl/c/xfjRkzwbM2Eqx+EW
	 DDVAWI0QRmsbOAMSU9s+4NfJquHVknX/NqhPPCAQWIMr/I1bUB0toiYC1k4qZLuicx
	 Cpf2bD6lbau64L1pF0wYKvcxWqoYPnLiUUZXSRzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/389] can: j1939: fix lockless local-destination check
Date: Mon, 17 Aug 2026 15:27:59 +0200
Message-ID: <20260817132540.552800224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
index 9f77a730be4847..21a4a4b10fc080 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -346,6 +346,18 @@ static void j1939_session_skb_drop_old(struct j1939_session *session)
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
@@ -354,8 +366,7 @@ void j1939_session_skb_queue(struct j1939_session *session,
 
 	j1939_ac_fixup(priv, skb);
 
-	if (j1939_address_is_unicast(skcb->addr.da) &&
-	    priv->ents[skcb->addr.da].nusers)
+	if (j1939_address_is_local(priv, skcb->addr.da))
 		skcb->flags |= J1939_ECU_LOCAL_DST;
 
 	skcb->flags |= J1939_ECU_LOCAL_SRC;
@@ -1998,8 +2009,7 @@ struct j1939_session *j1939_tp_send(struct j1939_priv *priv,
 		return ERR_PTR(ret);
 
 	/* fix DST flags, it may be used there soon */
-	if (j1939_address_is_unicast(skcb->addr.da) &&
-	    priv->ents[skcb->addr.da].nusers)
+	if (j1939_address_is_local(priv, skcb->addr.da))
 		skcb->flags |= J1939_ECU_LOCAL_DST;
 
 	/* src is always local, I'm sending ... */
-- 
2.53.0



