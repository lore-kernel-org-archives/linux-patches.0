Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622612C17A0;
	Wed, 25 Feb 2026 06:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002606; cv=none; b=D33NPX1GTRkZyRKOXAlVTB55HQdL3iLKtolUXWmnDfmpkN8TgW6PgUSHrJ6zwjMbGriIJtld+U6QF9FUj+apjafbZvCItNZVeKMmzVYIrgCMYIlgJkYWz1MlJZx2RP3YFgo8pSgi3ReU+i6W2YOaz4ecbkPljOBD93nZLCcEJDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002606; c=relaxed/simple;
	bh=gvMlASx1q5uXSY0JEnEP4I9fF3daFn0TO+ERHcU6asw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdFTn0dWgHWrc0rUTo+MkAcFJiLP5kkiHzK/3bqozOMbrBh598Nqvy/9PJKukPpa7iVz3T+xWeCEY6xCfNRIPAEo7G44maejIE7lsFm1PXpQzyy2+pqR1tw4wJUFovL8DzOS5Pf8dOwmN08uYdHBukjhnaXjqxM4dvYERdmaivg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZGxsJXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZGxsJXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9B1C2BC86;
	Wed, 25 Feb 2026 06:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002606;
	bh=gvMlASx1q5uXSY0JEnEP4I9fF3daFn0TO+ERHcU6asw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZGxsJXe7GG5Rk46scUCZBMjh2wOYTO2mleN3Qohm3xLOD/RU+G3QlmO7KFX1ftxt
	 3CeezkGMm0PmvXFoyovxnq9kpprg8W1Moy8QKi3vTwJT7PFi6Ci/fv4kG//+nigiKP
	 9x+VQsS2w4a7h9eVZsXQfiLp4K+r4zsLSe3RoUqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 356/641] power: supply: wm97xx: Fix NULL pointer dereference in power_supply_changed()
Date: Tue, 24 Feb 2026 17:21:22 -0800
Message-ID: <20260225012357.257444972@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index b3b0c37a9dd2d..f00722c88c6fe 100644
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



