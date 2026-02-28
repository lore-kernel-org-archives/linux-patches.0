Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A503439B970
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302594; cv=none; b=diXGg8tDyQ2vFbiSloVS7JBCSgcRVdiccnhDoah9i4UT2Bz/ngivIu7Bbt/UMzZdMC7bLy5uEi15C65ouGSMcZgp4Bmy7W1QJwFwGTtPulRXlvg0Dp/B7X5ckpcmv5nQenxAR6bVJIEU9oA9dq65KOlwDIz4L5ryjlJRAtWLzPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302594; c=relaxed/simple;
	bh=6hYmZAbDsLTe5G4GU6gYlGiDS7kGiljeEbE6L8fxfT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFgryMOQKFfHhozbDX7cWT9zWQ5SCOfYe0kCiLm2YwptmPq1RBWUvIlJ2q9aGD+9XCHlMyOV+O1JVTlIUcYeUNCa+SGqv3+0kTLK0IDsWkOXn19CjVCM+1g9zNUJ8i3NM2jHWEWsL19lu/inkkM3+X0J8J3pgSPipjUpkPbBOQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jzTdbONd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzTdbONd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150E2C19423;
	Sat, 28 Feb 2026 18:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302594;
	bh=6hYmZAbDsLTe5G4GU6gYlGiDS7kGiljeEbE6L8fxfT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzTdbONdFX297Q4Cd1zx718TaxR2E1A56NAbyQFxugoSwHhlPV/VXU8BcKOM7Og0P
	 zJu2L+4gI3y6TkZ64Le7XTiaim5PM5Kk0da740Yw0k9xCxp7FBCwUT7/+M42b7jzZ8
	 Jyw2TsX1eA0C9YUCW4rXsbLrPn22Qc/o2vYMPb6OzumRZ3H1Z3bDouAFwMkP5IYJu0
	 s3Zg6mBjbj9kRkwF5sfdIt95Ui43jtqqwiX3Vvpj/RNmYOoNEouRx8HnwFeBaUn5Qt
	 y1vbiPrmkM5UGgo29vK9zaKlYJR94V76DTWebhenEAUIqK0A4URN8uJ9FMtOpK2XuJ
	 J7bmTv3loOzXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/164] power: supply: wm97xx: Fix NULL pointer dereference in power_supply_changed()
Date: Sat, 28 Feb 2026 13:14:05 -0500
Message-ID: <20260228181505.1600663-106-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

