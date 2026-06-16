Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80249328610;
	Tue, 16 Jun 2026 17:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629334; cv=none; b=MbdoaydL2/ulJeRUE9HPFrj7lZFiH+t+7U/BQIGwGI785U9SoBSqRzssoPsbIXAT9sRemQMMXDNLxYHK6MlMwpVCMvQ/1ueDxBazvVeHvy0+hZ6spsWPRfH8W53OCUiphC5PQUbHQjS9VvyLqqaq9+/cNuR4oxMpx5aXED+rS28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629334; c=relaxed/simple;
	bh=bshNP+VlAOM1attr9KPDBmANxxpcJTx7a9lZw5PPqnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqFuo8OrwOBEJEkMYcAa8c99MsiVsN+CmPkMsS1Gn6+1Y3lQa2O9FoxUGnIgE9H38uxB6tZ2tlqRyX/ihTW03eMVeE8kKWFPMCsl4NVvQrR2+SNIx5xZrZMe6ULcI4NmrAT6dTrzbVUHWFncdmga6VCL8uSJCI43VV9FngcOFo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hr7NfACy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hr7NfACy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B741F000E9;
	Tue, 16 Jun 2026 17:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629333;
	bh=8WtEMgLxHBFk3YLRf3G13VqKfDAEmVmYQELU6qAxe1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hr7NfACylMVd6drNOWx0co++C7eCMNiTBWEfU+AncQQvvNq1uuMokBfA8l3bbP4Gs
	 v7wxND0NRUHT+chjzVZFGjQNiyZWSwd0HnlMrN+/yJ10wuRfQ/4buvn3NchFj2zRKa
	 2Hvme9+vOUsFBEXISM+KWlPWbG4H10HOQCv0gt+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 266/452] net: phy: clean the sfp upstream if phy probing fails
Date: Tue, 16 Jun 2026 20:28:13 +0530
Message-ID: <20260616145131.578878305@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

[ Upstream commit 48774e87bbaa0056819d4b52301e4692e50e3252 ]

Sashiko reported that we don't call sfp_bus_del_upstream() in the probe
failure path, so let's add it, otherwise the sfp-bus is left with a
dangling 'upstream' field, that may be used later on during SFP events.

This issue existed before the generic phylib sfp support, back when
drivers were calling phy_sfp_probe themselves.

Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Fixes: 298e54fa810e ("net: phy: add core phylib sfp support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260604092819.723505-2-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1d073947dd4c26..c8aa322f59918c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1432,6 +1432,9 @@ int phy_sfp_probe(struct phy_device *phydev,
 
 		ret = sfp_bus_add_upstream(bus, phydev, ops);
 		sfp_bus_put(bus);
+
+		if (ret)
+			phydev->sfp_bus = NULL;
 	}
 	return ret;
 }
@@ -3414,6 +3417,9 @@ static int phy_probe(struct device *dev)
 	return 0;
 
 out:
+	sfp_bus_del_upstream(phydev->sfp_bus);
+	phydev->sfp_bus = NULL;
+
 	if (!phydev->is_on_sfp_module)
 		phy_led_triggers_unregister(phydev);
 
-- 
2.53.0



