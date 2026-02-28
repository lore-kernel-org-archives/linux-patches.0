Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6AB33A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301933; cv=none; b=JFOaDyZUuOkB7brs0c4GUFPw9oSW91cBb2sjEN98iOlti8qWyHdCKP9+S+rO81S0QHV5APSBA792vwwKSKN9jx02eKanA1i6OqMSl0GEDXQgq30HPJitt0Hw7SZOKA61/yF8876evfnRbzxswiA3H/sjk5B5pLgQED7dsvTyNDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301933; c=relaxed/simple;
	bh=iX/9kBBxUQLYpAodsUWsmuvU4gH17coBA5QGd5keets=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZGY8hh6M9tf11o44zOaPFXVvDUYpYEqKE9bhsm/cKPB5R0sjXnBDfy4udQpOFAgmkA311CuGUlyAgmMKn3m6Qxm22s2RqViau3hdwFBzumU/jv+zxONWExp7NoFQVS5izt4SBhII4DhwsgEe8LeOjPutwd9VsVY/AgR7EmhCkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+eImXD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+eImXD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079FEC19423;
	Sat, 28 Feb 2026 18:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301933;
	bh=iX/9kBBxUQLYpAodsUWsmuvU4gH17coBA5QGd5keets=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+eImXD62sfCwEHdbTdTNtl0XB1eDuNQ2HfMfCENE172FUa33NWB5v2Qm00FWCM8f
	 o9RNwZKGb9HCnzEHrIell3WwRxREtttZiy4JhxkKywgWdpP0YyLSbJ2dBUHjGJLFRO
	 19QDk6UavmzMF7uX1vHTlEtP17AufGX9OfWtBlp2UcwB0wiB911ej2bXE0tNZzpF+g
	 Ou4utUIc/si0+bj3dsOusdRxwLudliBf2cLMeBqAoFNh2BrJKveyfkylECI+RfLkts
	 MDD8PZZJ7q9Q5/oMDAeIsVmGyeiFuDNOxR/6MPd3YC1d+k89+91/aH1E8WFsjkgqCF
	 DJoa1ZtLmg/nw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 369/385] net: mscc: ocelot: add missing lock protection in ocelot_port_xmit_inj()
Date: Sat, 28 Feb 2026 12:59:51 -0500
Message-ID: <20260228180011.1568201-369-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 026f6513c5880c2c89e38ad66bbec2868f978605 ]

ocelot_port_xmit_inj() calls ocelot_can_inject() and
ocelot_port_inject_frame() without holding the injection group lock.
Both functions contain lockdep_assert_held() for the injection lock,
and the correct caller felix_port_deferred_xmit() properly acquires
the lock using ocelot_lock_inj_grp() before calling these functions.

Add ocelot_lock_inj_grp()/ocelot_unlock_inj_grp() around the register
injection path to fix the missing lock protection. The FDMA path is not
affected as it uses its own locking mechanism.

Fixes: c5e12ac3beb0 ("net: mscc: ocelot: serialize access to the injection/extraction groups")
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20260208225602.1339325-4-n7l8m4@u.northwestern.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index df863657c87de..7df78004dba91 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -597,14 +597,22 @@ static netdev_tx_t ocelot_port_xmit_inj(struct sk_buff *skb,
 	int port = priv->port.index;
 	u32 rew_op = 0;
 
-	if (!ocelot_can_inject(ocelot, 0))
+	ocelot_lock_inj_grp(ocelot, 0);
+
+	if (!ocelot_can_inject(ocelot, 0)) {
+		ocelot_unlock_inj_grp(ocelot, 0);
 		return NETDEV_TX_BUSY;
+	}
 
-	if (!ocelot_xmit_timestamp(ocelot, port, skb, &rew_op))
+	if (!ocelot_xmit_timestamp(ocelot, port, skb, &rew_op)) {
+		ocelot_unlock_inj_grp(ocelot, 0);
 		return NETDEV_TX_OK;
+	}
 
 	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
 
+	ocelot_unlock_inj_grp(ocelot, 0);
+
 	consume_skb(skb);
 
 	return NETDEV_TX_OK;
-- 
2.51.0

