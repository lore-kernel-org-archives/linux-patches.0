Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC8136C9D0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302254; cv=none; b=UPxeuuwrsNBixbk/3Ea0knQloK508AKcINevxIJc/rOHkb2jRPCKsk9WuyMt+Po98eV9i5Vrmd0ynVqadY6JpE1jGwl9yjkI+UTmN3nmNt1EMXy7/9MMateWjtXJVmvPeUl5Wmn0dWCGcicj4Mtss0YDqq49JHwuPYfdaUz41Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302254; c=relaxed/simple;
	bh=NiSIK+eJGWypbBBZ8bQ/K0t3tweFD/Djfdqenf+gMcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMk8zVYS0JPBycaN5XwzUV0GXihi1TcaN8L2njM00H0GGE6oEnw9h3ZGgZ/fjqUdC/9v4EsPOnE6psBB4R69lZPRR35qvy6zdmV8JZ8KVCxq7MOgA8TGKNEMaB+xCvuEJtNK/laz043STp7rdxkY6l3PqpUbQ0hXqR1uebUkBgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L6qGJiVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L6qGJiVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F2BC116D0;
	Sat, 28 Feb 2026 18:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302254;
	bh=NiSIK+eJGWypbBBZ8bQ/K0t3tweFD/Djfdqenf+gMcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6qGJiVSwA3GG+wwkB3oyoiPBadG6tafcp9jZB/yjOdKx+G8zdExCY2gt7v1sMM9/
	 jm9q5Henbnn8ZfWDqo9oCuqkEfldKn4zMeRWR7A3hXNjYztFWrhbMLjPWW6rRGGDqJ
	 Z9s5hZCaMAfDz7aii92vSuo8rqlxkeBx12D0TKPp2RXouKt9r8bubpTYg+8/ZM2oSZ
	 4obT5MfFfeb7WlotwkRQdLMD85DYDFuH1c6DaRsS623WLguOGykIAqla68YmIBn7KB
	 uM8fbhnQO/I8JuEOoddxc5QBBY+4Da5ooPTNTmxgTRJLIVN7pec8jponO31fz120z/
	 Wtb8tPjRGr0ug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 268/283] net: mscc: ocelot: add missing lock protection in ocelot_port_xmit_inj()
Date: Sat, 28 Feb 2026 13:06:50 -0500
Message-ID: <20260228180709.1583486-268-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 84b3dcf1d2f5a..b516b4e1ed974 100644
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

