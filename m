Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A713C3B995D;
	Sat, 12 Sep 2026 08:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201588; cv=none; b=YR5D5e/oloAP6WusuymXF/rw/gM82oeYAkx19Mo215StDzZwRaQRM36nK98eHCC0ZdJrsJGyueZhCngHxvsKcN2aOLgOpbhuIYMy3kbDqHk0Ywiq7S5dW2xfKnhtsNKiing8BX/bXE94P1lkH1MTZtyMkbWmb/IHZ8botllVMhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201588; c=relaxed/simple;
	bh=BXDufZwx/XM4UsSYr/eQWxxoBg+PQjzCD8uF7GTJQfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxYlooLuCwGwbUzfTIWGlxcdVAZIKjOhpqaezQ2GxSXSd6NTHedLwDWK8KOW/w3uDzbPAGTrhlUx+7uiwl+gfTgmeFp09QVOixRCZgRo3Mg0kaOaEtHdcdrroFq5l3i6QxOwiYh52FFlymqUcLeX4B4JiAyiY8QkjnSEoBgmQjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofMp0Yxm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofMp0Yxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17621F000FF;
	Sat, 12 Sep 2026 08:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201586;
	bh=lZYmLkJLA5lnydMUfteA73c2hxoKhsHF+CBZNtzjenI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofMp0Yxmxp+Oxwf1SGufl2uQfu6PEQ6Ist+lChwuhURFX6qmn5RI/O6gsb56JU1Bo
	 n9g1pgAxXptV2Km2FRRfawJZZ9DkM0ZyeUGFHeh/QiV6vjICMmbiXYGCjKlNi0J4d1
	 FYsIBsNeCIUSKTFIG8ifKWgmBYY8FwiBn1DIflbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zxyan Zhu <zxyan0222@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1026/1815] net: stmmac: Skip PHY attach if custom PCS is in use
Date: Sat, 12 Sep 2026 08:46:16 +0200
Message-ID: <20260912065713.105401530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zxyan Zhu <zxyan0222@gmail.com>

[ Upstream commit af4d934164457f0578bf90e92ae0fcc5348260cb ]

When a platform provides a custom PCS via the pcs_init callback,
the MAC's phylink_pcs is already configured. In this case, no
traditional PHY device is needed.

Without this, stmmac_init_phy() falls through to the no-phy-node
path and errors out with "no phy found" when the DT has no
phy-handle for such interfaces.

Skip the PHY attach when priv->hw->phylink_pcs is set and
phy_addr is invalid.

Fixes: f0ef433fc264 ("net: stmmac: introduce pcs_init/pcs_exit stmmac operations")
Signed-off-by: Zxyan Zhu <zxyan0222@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260729074237.2624940-2-zxyan0222@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a71f0df263785..b24e12130c078 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1330,6 +1330,10 @@ static int stmmac_init_phy(struct net_device *dev)
 		struct phy_device *phydev;
 
 		if (addr < 0) {
+			/* If a custom PCS is in use, no PHY is needed */
+			if (priv->hw->phylink_pcs)
+				return 0;
+
 			netdev_err(priv->dev, "no phy found\n");
 			return -ENODEV;
 		}
-- 
2.53.0



