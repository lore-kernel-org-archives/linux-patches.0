Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DE647CC9C;
	Sat, 12 Sep 2026 13:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219343; cv=none; b=qTdv62S/6kSfwazoL8FKZ5UJF1edQAx+Y5CefqWMG4rXosFHbxuGwlANmF+suDhxVZbKfFgWJce3Lj/TbrnZKN3mD6XkUr0R4RAbh99Xdvy6n+BwESQ22mvFAxE4m7RCbqMH5W9WbQKyB3qN6txhGYt4wkex4UvYCYCfW8qcss8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219343; c=relaxed/simple;
	bh=rZiCunqAtIXIsyFAN5HTADsWNCIcxC56oFREV+vvn1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZw+Dp2+k2aZMzakot/lQWD4FPxaA+P822KfHaYqiRGCk6+mEizKHvXp6MpmxqcKPEjkwhxP3DpP43WOYEFrwJo/4ntY3/CmyuU+SX2ghAX8Mi7XNUBmb/XzyOnYa+7eu2KeTxjtvhvx+Z0q+kIZ8DVuoeGVfs+bVTYYLNa59yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGxjQj77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGxjQj77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8191F000FF;
	Sat, 12 Sep 2026 13:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219342;
	bh=+oQ1FgI1lVBwxNjiDRRBNAnhL6aoNi8oVm+GWzzrL3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGxjQj77uWDLlHuy+riVYJGofQTR78QB4nK5qlayRmG1/9q/EykIYk0blhZuwdNA9
	 MN1Z39+lOpfocevvE+WWp2SmeofXdqqO3ZQHhXTgMgP6qHumE4xwOO/SKVrNXpWPkc
	 +mgR2xRp8WqgTq/GzMhmXOldu25uGmp1uAAmX5oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1330/1376] net: stmmac: dwxgmac: Account for the primary MAC address for UC filtering
Date: Sat, 12 Sep 2026 09:02:36 +0200
Message-ID: <20260912065637.175298976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 2739d6f9a2b8729b0d85cbe0dc93e1d68670b6f2 ]

The same filter slots are used to store the main MAC address as well as
the address for the unicast filter. Let's account for that when deciding
whether or not to use promisc when programming the UC list in hardware.

Fixes: 0efedbf11f07 ("net: stmmac: xgmac: Fix XGMAC selftests")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260826140500.616466-5-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 445259f2ee935..d1a6cc7bd9bbf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -540,7 +540,7 @@ static void dwxgmac2_set_filter(struct mac_device_info *hw,
 	dwxgmac2_set_mchash(ioaddr, mc_filter, mcbitslog2);
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
+	if (netdev_uc_count(dev) + 1 > hw->unicast_filter_entries) {
 		value |= XGMAC_FILTER_PR;
 	} else {
 		struct netdev_hw_addr *ha;
-- 
2.53.0



