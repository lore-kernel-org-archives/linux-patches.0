Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495B633A712
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302180; cv=none; b=uJU+Rj+0jqwNeaqyU7D3KEUP9/PR5TVrajbsyzVPgO4SPoNbaIngOFOM8qjCv8SnHzpPfdWGzeNTjOXOjF5UJILtzLtvjCDRVPspKgj22UoY4oLPtaxJ63qmQpPYY+5W1Jcd5Adu3xGqQZ0UiVhzVNAnWd39/PFekqkDy6G+S28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302180; c=relaxed/simple;
	bh=9r1rMaAyj6pWsF3OWePOF6nN+aYDPfT+2ccdNRJztsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExZPfggAM2LUkQ0zJvApwcopB0xwGfq6Ql1oFpoKOnMntGhKoYNvHVwMXSOAXEVnpOobYq8ORNImiTzb/a0W/AYccUDiiV8MlYRCdDfoGLZmEzBACKkJTBkkkE7AiDqJlyt5s9SriQ1L/PQ7LjVmbRB2qK/mZ54nEEggyAOmTO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=caU3Rfrt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caU3Rfrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC049C116D0;
	Sat, 28 Feb 2026 18:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302180;
	bh=9r1rMaAyj6pWsF3OWePOF6nN+aYDPfT+2ccdNRJztsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caU3RfrtjdJsA2qIK1biSmMGkxN8SVZOgPqY7CJi+Kb/RnY+iEoxZbiREVbRPLNHx
	 iTz6TXK5NdRC4m+mdV9fkFrr2p5kmfweGyvS9we7AMIJTZCUbOl8Ymq+br8kp/YCI6
	 IYgu/wt021h2+yN14YUR3B+svBWcYp+HRRSi0dcmT4LJh+ryg/1Ky1ApmTkky9r7Ke
	 WaSXpljWwKaJzlMOnCpX0/17PZI0QO8XL64rWAL6lQjJNtzdgIhGvpI9f6AAi88koA
	 jHJ6a1sLDHU09GFnFh7dZ8SPbSRCat+uTgOjzhiYvFWSmZo1p3C8c7OZX7sravVjpW
	 dN+l6uFv6EXqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/283] power: supply: wm97xx: Fix NULL pointer dereference in power_supply_changed()
Date: Sat, 28 Feb 2026 13:05:22 -0500
Message-ID: <20260228180709.1583486-180-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index f4b190adb3359..d3e5c2f7762a6 100644
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

