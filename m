Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4AB35AC20
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302731; cv=none; b=YkSCCZLyEuV/zMGYazXvs2BWO3TUcE75tQ/jTuC40Po/+kAsvDzlOno842pSlhZKPTfIk94DVq0nySwLzBVh6KjCe4dNYOfWscoPbDGCy77Z6saTNfJKrTAZHEaJx9xqK5W07LGdlttItEH18vspLdb6S91iIyLDF3qVViTex8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302731; c=relaxed/simple;
	bh=6hYmZAbDsLTe5G4GU6gYlGiDS7kGiljeEbE6L8fxfT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtLMMCsQmZeElnD+NJphzvB4bMeAacAAKTX3mYJZd0yPgS46KSEchRKHNkaBBjfUVlZ+PF4a0a++NllKpR2BWJzyhl9Pl4pNf9d0I+ZPcLgG7POiz7zxD+0eeTMR2qT2dRDTYpHQRiTVBoLuE8H2keuaqgXuy7lzbdJM6cIPJKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=opq8AK4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="opq8AK4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804A2C19423;
	Sat, 28 Feb 2026 18:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302731;
	bh=6hYmZAbDsLTe5G4GU6gYlGiDS7kGiljeEbE6L8fxfT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opq8AK4ttrCtEohGKGRF6MI+26/7KGRkHUOXfi7iZKsiPhAaInOU0LnwBnaBM4hdK
	 SX8l+C/c21bN3vTV0pCG0DN6K40wWdhSD7yEPokgONWp34dIL0RJOZBXUcvJwRJv9i
	 bJaKAni+6SAQuXbM77KcxNBCZFJUvisX8nc5qGfPKRZaXp+IhQFaiZA1esWsvJWSNp
	 2Hec64WKrnghtiffyEygEb3IYO9IWzeMDu9I+KFo5OaY1cfHgVUou30HDVxKxQo1cZ
	 ABfVwR33T1FgpJdWfF22aV+fvrxrf2aeS06UIlF1EIqmE7Yz1fgACd9g/iKift7AcS
	 +zJ7JUVHKgKNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/147] power: supply: wm97xx: Fix NULL pointer dereference in power_supply_changed()
Date: Sat, 28 Feb 2026 13:16:41 -0500
Message-ID: <20260228181736.1605592-93-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Waqar Hameed <waqar.hameed@axis.com>

[ Upstream commit 39fe0eac6d755ef215026518985fcf8de9360e9e ]

In `probe()`, `request_irq()` is called before allocating/registering a
`power_supply` handle. If an interrupt is fired between the call to
`request_irq()` and `power_supply_register()`, the `power_supply` handle
will be used uninitialized in `power_supply_changed()` in
`wm97xx_bat_update()` (triggered from the interrupt handler). This will
lead to a `NULL` pointer dereference since

Fix this racy `NULL` pointer dereference by making sure the IRQ is
requested _after_ the registration of the `power_supply` handle. Since
the IRQ is the last thing requests in the `probe()` now, remove the
error path for freeing it. Instead add one for unregistering the
`power_supply` handle when IRQ request fails.

Fixes: 7c87942aef52 ("wm97xx_battery: Use irq to detect charger state")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Link: https://patch.msgid.link/97b55f0479a932eea7213844bf66f28a974e27a2.1766270196.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/wm97xx_battery.c | 34 +++++++++++++++------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/power/supply/wm97xx_battery.c b/drivers/power/supply/wm97xx_battery.c
index a0e1eaa25d93e..e2a41f9c903c5 100644
--- a/drivers/power/supply/wm97xx_battery.c
+++ b/drivers/power/supply/wm97xx_battery.c
@@ -178,12 +178,6 @@ static int wm97xx_bat_probe(struct platform_device *dev)
 				     "failed to get charge GPIO\n");
 	if (charge_gpiod) {
 		gpiod_set_consumer_name(charge_gpiod, "BATT CHRG");
-		ret = request_irq(gpiod_to_irq(charge_gpiod),
-				wm97xx_chrg_irq, 0,
-				"AC Detect", dev);
-		if (ret)
-			return dev_err_probe(&dev->dev, ret,
-					     "failed to request GPIO irq\n");
 		props++;	/* POWER_SUPPLY_PROP_STATUS */
 	}
 
@@ -199,10 +193,8 @@ static int wm97xx_bat_probe(struct platform_device *dev)
 		props++;	/* POWER_SUPPLY_PROP_VOLTAGE_MIN */
 
 	prop = kcalloc(props, sizeof(*prop), GFP_KERNEL);
-	if (!prop) {
-		ret = -ENOMEM;
-		goto err3;
-	}
+	if (!prop)
+		return -ENOMEM;
 
 	prop[i++] = POWER_SUPPLY_PROP_PRESENT;
 	if (charge_gpiod)
@@ -236,15 +228,27 @@ static int wm97xx_bat_probe(struct platform_device *dev)
 		schedule_work(&bat_work);
 	} else {
 		ret = PTR_ERR(bat_psy);
-		goto err4;
+		goto free;
+	}
+
+	if (charge_gpiod) {
+		ret = request_irq(gpiod_to_irq(charge_gpiod), wm97xx_chrg_irq,
+				  0, "AC Detect", dev);
+		if (ret) {
+			dev_err_probe(&dev->dev, ret,
+				      "failed to request GPIO irq\n");
+			goto unregister;
+		}
 	}
 
 	return 0;
-err4:
+
+unregister:
+	power_supply_unregister(bat_psy);
+
+free:
 	kfree(prop);
-err3:
-	if (charge_gpiod)
-		free_irq(gpiod_to_irq(charge_gpiod), dev);
+
 	return ret;
 }
 
-- 
2.51.0

