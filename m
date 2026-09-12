Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A6235C69C;
	Sat, 12 Sep 2026 19:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240679; cv=none; b=VXZRBGK0TZ8KKscKDIYDQOrtI0K21t38XGPP8i95a8bCCoieSAKowfdJTo4fYt4xtD0d9pTBzFK6vncrOFNgb0jeFq0mDZD8hc8ohteCOlpukVjnAHV6W7cpUBG8cb6mLZusopCPA07qEvulC5esXM+RpR3bcedQv4LEYTiDO6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240679; c=relaxed/simple;
	bh=iVDiYv+UPMvddO22UNNngz3eGdDnPnFT0aTDfLBrVTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lO2VqMUtxYfsnitbHDxf3Rp9bp9OpweOo2gkoT55HyqM27g0NsSLnjF5qtAXnD0A4BJYUX8tnYZC+ooUw+njTvrRbdSWL1jO++//XyA2yxo6eAsdqOXvAXMJ1Wt/SDuB9W9CKnZA46nCZMRoXj+1FYyfYqLNlGSHWiQyAuWDzXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTO4b2fU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTO4b2fU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5951F000FF;
	Sat, 12 Sep 2026 19:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240677;
	bh=jkbjH5N/kUV134gyrc3a7vcgj/kjMgoAcPX73GPpoZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTO4b2fU83YDTmq3DN012fNqbSaprkW/pVlK9uSNh9cZJwzQx4b+OpgyApV+ajANJ
	 7+ZjljQ/7tOiXCPLbGoon8IZgezB5ZGKIHYqISQDsYSy0JNyv89JlshDR+ysdnw4iG
	 xKV5EWdOSOrXoMyXM0tr0+1ho1EJUvs5mM88b9nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 918/935] net: stmmac: dwmac4: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 09:05:48 +0200
Message-ID: <20260912065547.875805639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c75868f3ceae1..983c7229afbfc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -678,7 +678,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	value |= GMAC_PACKET_FILTER_HPF;
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
+	if (netdev_uc_count(dev) + 1 > hw->unicast_filter_entries) {
 		/* Switch to promiscuous mode if more than 128 addrs
 		 * are required
 		 */
-- 
2.53.0



