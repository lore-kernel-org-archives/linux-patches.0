Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6EE23BD03;
	Sat, 12 Sep 2026 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226376; cv=none; b=cG4JlWaxpJzJosQ/3RnEeiUMkC7d1/zy2ksK+kiW7PsY8F7A38g8xJ02BjMKxpPxVKHywLLvVH14BV8pMz37HVDM5iVebujvpnIdhOfWQHPBGXqywM/mcIkZusBvJ8Cg1F2xETtYtdhjPzqEJcc5jlaSapUJ9rZsj4F+4cbnNKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226376; c=relaxed/simple;
	bh=NdAxy7f9LxUxFvC7g+Qi1zMUFK42fxCVy3VeRQABBXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGZ23apMlZRrQzIrZ/KWK5Il7CDnkWe+CsFUPvaUrSQ/uRaLXz1ri7Pk6Qk7c6tPWHvDjM0AqvA50lK81VwfdhivcvxJHeWbj/LzBliq23THO4oSYq3POSamFaWrjNiekulHqFXwS+t1hVstBxGJQxubCDBVL/64zNiRwyejcS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCJdrIt3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCJdrIt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4491F000FF;
	Sat, 12 Sep 2026 15:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226374;
	bh=NdCB1D6Q0/rL9LacCcSRaqlZKe3zQGtzmaSD7srFgw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCJdrIt3zotlLXCRGGTGRh9h8EzWR7fxdnpAT9TQRTGNyGVz9XvZVaLiE9TyqQU7Z
	 VeXYbx5UJVChg9otaVA2rUoK+uS23z0XbsM8UhZJD75dEz3Yco+uVWZAwUleDi5ACZ
	 nlnXE3zhu/pQyiB1gTmmlRun4Pc7qppWxax7CzCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1389/1424] net: stmmac: dwmac4: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 09:03:41 +0200
Message-ID: <20260912065638.364680596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 82187f42c014d22520b9c3c4e2cfb519223fb29b ]

The same filter slots are used to store the main MAC address as well as
the address for the unicast filter. Let's account for that when deciding
whether or not to use promisc when programming the UC list in hardware.

Fixes: 477286b53f55 ("stmmac: add GMAC4 core support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260826140500.616466-4-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index bdb4f527289d2..065e24054e3b2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -684,7 +684,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	value |= GMAC_PACKET_FILTER_HPF;
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
+	if (netdev_uc_count(dev) + 1 > hw->unicast_filter_entries) {
 		/* Switch to promiscuous mode if more than 128 addrs
 		 * are required
 		 */
-- 
2.53.0



