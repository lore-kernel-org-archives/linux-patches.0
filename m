Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AE1383983;
	Thu, 30 Jul 2026 16:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427333; cv=none; b=WP2eKdxDvSj+kYZENv5RXW36MFVL2wfF8zc2TYB1Hti/rYPvElJwCN5/vNIKdWC3P2F6KO1AfqM84fiIZiclsFsPtfQXhqsPiz62Q7f+CvCSAKnB6ZBAx4cKHIGlAzFwT2N/4/yzXIT7o6/VzYcbh/8yHfahYDnwQtZug61OUZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427333; c=relaxed/simple;
	bh=brh6GWiOEPWt4JSRIoKO4H4ArLgBANp5Qf+wdYUkiPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2KaraFPmihGulNnykK6VB16jufpITvO0+PGovJ15mvzjZOYq+UjTjzQo8iIQ//oTk6GVprhMPLirC9JaqB+sr6XnMLb64CIRJ7wU1V1rwFZ+FWHI8vhTh/XJcv0mPGdYGq1ymamfevwp4z8oIKoVuryfFtvGaEo643q7rQ9xDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4bmcXWK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4bmcXWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B83F1F000E9;
	Thu, 30 Jul 2026 16:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427332;
	bh=H4cVW6pYnFtNVJKcq+FQj7uSX9URkB+b7KEWMgDZMLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4bmcXWKw9t+2cOnA5N3QYdM0e9b5/8P2p+kCIH7bzMjRY0gn5wXLSBnqjxPh4lr9
	 qlqud0eQ16kUdA+i37tXFZXb5lDrjiQ5N7m8Bt9K33MSPF9ycU38Sgb0sP4UZk23OB
	 PExgeqiGKMPBWTv6uHqbdxs6j9CIf8M+CqxXQbGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/484] can: j1939: fix lockless local-destination check
Date: Thu, 30 Jul 2026 16:09:46 +0200
Message-ID: <20260730141425.382223286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



