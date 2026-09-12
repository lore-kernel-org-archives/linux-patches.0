Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB24747B437;
	Sat, 12 Sep 2026 12:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217116; cv=none; b=A+Hu9lxkNMO6zVnBE+/bDFEjnVJaJV61aNiKz+RpLsvp161nBa7ltAdZemL8qtql197Dolp1gNQetAKcBSxumx9Efx/QnbPQZgg2kEiZ9WFKXpykvA+PppK2o89IbszHURxWyGRS9lPkVAnh8P41FlwYMYNWMix47RMA9YDHmes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217116; c=relaxed/simple;
	bh=sEFfvkNJqwRxduot8w8OjnVLmPdbiy7Nr7E9gHEqSo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dqo5E7gFDGtBu+9gIgThHcbFr+m3j1d8lO1Zpm9AzQrJM7QRzdnXA7aaKLxZN375DMQ7BUfgTLwwlWRLNihLP1cRCq5TgANpbfsnwrzV6pToxOmCURM7NKLlVJBaF+TNRArIy1bpzEDXyrP5zO9xXbwAf11DJNUmspr/vRWH1gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkRpTU5a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkRpTU5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931711F000FF;
	Sat, 12 Sep 2026 12:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217115;
	bh=nwgVImpkBqaniOr1iRuKjzhSTJCOgmqhF1WJIsFuXKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JkRpTU5aC7XHSqlZOcv2OMzK6359DQsOg9gagiIInZxzxwz2ZWcrxgfGCcFKBqmnv
	 Y4sLMyFTV3UxTMyTrbogBnFmEXhKNEpTNvdnsNEB5EvtDNpuFfDV4eRq7tcFjDFCu2
	 JvsKeznlZaDoPDDttv7vevgaNb6gB8/Xmoli/Fx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zxyan Zhu <zxyan0222@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0873/1376] net: stmmac: Skip PHY attach if custom PCS is in use
Date: Sat, 12 Sep 2026 08:54:59 +0200
Message-ID: <20260912065627.014891237@linuxfoundation.org>
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
index 44fd0fadc137d..3074e322a2cc2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1183,6 +1183,10 @@ static int stmmac_init_phy(struct net_device *dev)
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



