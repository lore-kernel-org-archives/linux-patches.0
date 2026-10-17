Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF4A350A0F;
	Sat, 17 Oct 2026 17:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259623; cv=none; b=Y+Yady0aL96pr84iuND4XCNmb1CtKPOvxxlV+R/gSWBIsQy86r/uWcUfe1UBSgOxdvDVhRVcinzEnG1jtZgYWFuvj/UknSuiY8dySAl/yBxBag+x1l7UADPmfh6HJ11EJxH2lKgYBDyxU/6f8rOqNCag9c0kHXZUKgnwg55sEVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259623; c=relaxed/simple;
	bh=N3UCcVipFW4VSaUI1D0UirRWoSYE7ovy4L4l5zyfxIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWl3xRkyTDx5F4nrFnYpREUap77YRdlRkThPgVcpQqIaQXdhqmJ0S0p4WkpgvgYdEoRewQngLSGRg76naGJ+PruIsKkOfjn1biuz+vX19WugL7A1ZNfHkHsYyoqqMr6j98GM98iUhAF6kOxx4lxmnZhctZVPHmTAP7x7IrOOCVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EU1Ds8zO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EU1Ds8zO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1981F000C4;
	Sat, 17 Oct 2026 17:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259622;
	bh=AwW7VQ1DFVSdE5raLdfNnKCEZhgVjsA+gDmUBG39X2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EU1Ds8zOJufPaFDtaq2m5GCndF11MFr/taKjP1WKqjuAma3bI58m6rJ5ICsRbiiuK
	 6HlZrh4EkL9HNTOZjRxEDTbaPUn3tJP7vbHQbSH7Rc3OHWyYKQGl4/cHKX7cYBXBKB
	 Nba7kMPNMIIbKBGYCPV9d4YThdNufFPrnM+fZuTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1273/1674] power: supply: lp8788: Use devm_power_supply_register() helper
Date: Sat, 17 Oct 2026 17:59:05 +0200
Message-ID: <20261017160503.819320053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Andrew Davis <afd@ti.com>

[ Upstream commit 2abb571143c39f581df9951d263948726db42d86 ]

Use the device lifecycle managed register function. This helps prevent
mistakes like unregistering out of order in cleanup functions and
forgetting to unregister on error paths.

Signed-off-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20240123163653.384385-7-afd@ti.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 831c29a12d56 ("power: supply: lp8788-charger: fix use-after-free on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/lp8788-charger.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/power/supply/lp8788-charger.c b/drivers/power/supply/lp8788-charger.c
index 2c81be82a41a4..72b170b4ac46a 100644
--- a/drivers/power/supply/lp8788-charger.c
+++ b/drivers/power/supply/lp8788-charger.c
@@ -406,12 +406,6 @@ static const struct power_supply_desc lp8788_psy_battery_desc = {
 	.get_property	= lp8788_battery_get_property,
 };
 
-static void lp8788_psy_unregister(struct lp8788_charger *pchg)
-{
-	power_supply_unregister(pchg->battery);
-	power_supply_unregister(pchg->charger);
-}
-
 static void lp8788_charger_event(struct work_struct *work)
 {
 	struct lp8788_charger *pchg =
@@ -666,18 +660,16 @@ static int lp8788_psy_register(struct platform_device *pdev,
 	charger_cfg.supplied_to = battery_supplied_to;
 	charger_cfg.num_supplicants = ARRAY_SIZE(battery_supplied_to);
 
-	pchg->charger = power_supply_register(&pdev->dev,
-					      &lp8788_psy_charger_desc,
-					      &charger_cfg);
+	pchg->charger = devm_power_supply_register(&pdev->dev,
+						   &lp8788_psy_charger_desc,
+						   &charger_cfg);
 	if (IS_ERR(pchg->charger))
 		return -EPERM;
 
-	pchg->battery = power_supply_register(&pdev->dev,
-					      &lp8788_psy_battery_desc, NULL);
-	if (IS_ERR(pchg->battery)) {
-		power_supply_unregister(pchg->charger);
+	pchg->battery = devm_power_supply_register(&pdev->dev,
+						   &lp8788_psy_battery_desc, NULL);
+	if (IS_ERR(pchg->battery))
 		return -EPERM;
-	}
 
 	return 0;
 }
@@ -720,7 +712,6 @@ static void lp8788_charger_remove(struct platform_device *pdev)
 
 	flush_work(&pchg->charger_work);
 	lp8788_irq_unregister(pdev, pchg);
-	lp8788_psy_unregister(pchg);
 }
 
 static struct platform_driver lp8788_charger_driver = {
-- 
2.53.0



