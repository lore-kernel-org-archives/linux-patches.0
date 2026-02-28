Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AFF359A72
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302472; cv=none; b=cudIyPvKD0voWbMpTRLq2OwU+NZunPIC3k0DgLbTxvOgRqPFG7SdPh5FuRy3g6YHLcNcW41wO72YB67jdfTTA63VwdecyVPVdox4PeRiWUEcXncmD+guJtLmmWyWVZOaYMqvJmjIRmBTvG4jzeRIR+ADQHVrXc1zWKgAQQw2UFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302472; c=relaxed/simple;
	bh=SLMYVpbRCSdqSYzm7eQ6PexsE+8pONAU1NG6J7PjZ4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRTTsCRpJbjTEHZqKlmpZ5qCXuYLmAAUElue3bBNE5KAX1lqcJPplcA6ix4oUCZzFqvQsnWromZcIlr2scqVD2eDJu3Uku7Oyhy5UOyuBGRnm0jvs/lDsjJ0sYyglP8MtkJTh9cJZmuT3DZPHGVRyEbVBQoZwGmDI3j3sTYxtT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NX6Q3NKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NX6Q3NKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2638C2BC87;
	Sat, 28 Feb 2026 18:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302472;
	bh=SLMYVpbRCSdqSYzm7eQ6PexsE+8pONAU1NG6J7PjZ4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NX6Q3NKVKGgre3JpIUKd+EvXKhvZTnwak0SpSgQRVFTnIpsvpSex5EK7bNWO0w0Of
	 TduY5Hozc4QYAyWeOSioQeC4Lev45hDCm/RcoPJFvqYyzUTlNY1TFCcI+lWzxA+46J
	 4bsTGH2vlU9z5Y5PZWjsrx49ZVF8AJVagiz8O+ZMzBOs5YlXdEBrk+MVC9E7DMF4a/
	 ouTeYnIj9YM/E5HC8YRjpJTsSJHZU2lkRtHWBkJkty/7reWGjdQi5wZCvAErZky59u
	 ZtXDWWkPo/OdQH2XyQVtaq6jDot39Tg4K765qTVrPCscgjLXnMeiM0eHHkO7qWRPP5
	 OIoxfEd7ULNtA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 217/232] net: mscc: ocelot: add missing lock protection in ocelot_port_xmit_inj()
Date: Sat, 28 Feb 2026 13:11:10 -0500
Message-ID: <20260228181127.1592657-217-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 14de948f72464..e4f4ea97c55b7 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -606,14 +606,22 @@ static netdev_tx_t ocelot_port_xmit_inj(struct sk_buff *skb,
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

