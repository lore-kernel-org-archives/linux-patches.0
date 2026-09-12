Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A4A3BE175;
	Sat, 12 Sep 2026 09:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203621; cv=none; b=DfmMH3/KpUZ/TH/pzRJsvZkhyh7wVyKsylpaN/GQhlaL6gW/bjd4/iFwuvm6i2+nK1nKDMp+N3gxVWe5a6Ukq/TF/Nqu8xT+35p3bvu8MXlfHWHMtaYW+n91vWkJWMlcqoKrCpQFGOmwR6ziOosraKouyPWvCnwDdns1cIgfoSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203621; c=relaxed/simple;
	bh=1Tpie4my5JSXQhkQhVO9DdDq1o3piaQdsn20LaV+kiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bq4HrttGXwWByjaKSCxwc1puQvnNtJdZ7Odx/B/koD8OK3cEHFrT+/u96VSoCIPQf2aTb1LAtktC+jrV5/se3WSubKal2nZKckHwXD0a+e8AF4cyZ5oDOqUVPgQvZSnJ4o6kanymgvWmaEyZbOXVL2ylVTHhOzxMxZA1FHeC9oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeXwTp5h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeXwTp5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E7B1F000FF;
	Sat, 12 Sep 2026 09:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203619;
	bh=+fHm26SbHLL/QkOhGV2eF56snKZhAqfpxpZte2o3x10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XeXwTp5hWL8g9Er3cYeqHxxwMRpq0bMxDAFLy0qjhSdHbxfxVChwDG4XKsn00lhUh
	 7vEKnrBeCobAAvWWiy1s2Y01Jffv7dJs/zTabfJjcZ5lxbgY04BVwk5ESsGaFEcVcd
	 HvSwXuBzJrpjFl6HeF7Ip+ibLESFe+SzDFLyRwQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Kalle Niemi <kaleposti@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1418/1815] power: supply: bd71828: Do not hide errors
Date: Sat, 12 Sep 2026 08:52:48 +0200
Message-ID: <20260912065722.309329598@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit a3c841e420e124783a805919ab072551543e477b ]

The bd71828 reports success / continues operation even when some regmap
operations fail. This can lead incorrect data to be reported.

Return appropriate errors when operations fail.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 5bff79dad20a ("power: supply: Add bd718(15/28/78) charger driver")
Tested-by: Kalle Niemi <kaleposti@gmail.com>
Link: https://patch.msgid.link/22db56cf35252d2d8f67828a0554e8daac7ae251.1786356145.git.mazziesaccount@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bd71828-power.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/bd71828-power.c b/drivers/power/supply/bd71828-power.c
index 792596d96e624..3be7a75a7d6ca 100644
--- a/drivers/power/supply/bd71828-power.c
+++ b/drivers/power/supply/bd71828-power.c
@@ -455,8 +455,10 @@ static int bd71828_charger_get_property(struct power_supply *psy,
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
 		ret = get_chg_online(pwr, &online);
-		if (!ret)
-			val->intval = online;
+		if (ret)
+			return ret;
+
+		val->intval = online;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 		ret = bd7182x_read16_himask(pwr, pwr->regs->vdcin,
@@ -1217,7 +1219,9 @@ static int bd71828_power_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, ret, "sense resistor missing\n");
 
 	dev_set_drvdata(&pdev->dev, pwr);
-	bd71828_init_hardware(pwr);
+	ret = bd71828_init_hardware(pwr);
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "hardware init failed\n");
 
 	bat_cfg.drv_data	= pwr;
 	bat_cfg.fwnode		= dev_fwnode(&pdev->dev);
-- 
2.53.0



