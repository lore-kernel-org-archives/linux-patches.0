Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C62A33A6F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302174; cv=none; b=TdO4yBlq3ch1pplBAI1ih/OTpGsUNNoTNeFDdOvR7kbXPIgkfSMqTmGiZZuX6SG5GCzbtoALlCAk5XoSxAKSXMG5cSm4ZTBxzqqtCXmgWFlaqNLhi1pgl9+GEliy3PLYxIIc82P/YJ54OYxnI95BIA7oUMJKdsykTcsXQVOmR24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302174; c=relaxed/simple;
	bh=Fx383WXRDsEaQLyejXTWxBuHv1ZL978lLNW4c797m0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7whZSPy+fK2sMBXH6Ef7BPfatrHjk8n4/aCkfMMTwMtwbDGzFFo5aOzHdYLIDgYSSyUVQvl8C77ClPeet6zLGelN703M6nFLQZKk9NuPX8p4ovaSIansRZ2ANrdQAxQLN6k27XdTSqsTHbagNQ+Br5XZoJMctTJKfGoTDHdNnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSX1ZMVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSX1ZMVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712A2C19423;
	Sat, 28 Feb 2026 18:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302173;
	bh=Fx383WXRDsEaQLyejXTWxBuHv1ZL978lLNW4c797m0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSX1ZMVSbWkKTDIrF0rvQjmB13rt66SNg/u+ySg5hKL2B/vYVDSLPfzLlUbVgsZ4d
	 56e0d7egmsRDwPTcnFBlKp04qPlaNT1IhDT71RzqcxntUnUFIVhIJcbgZwEd3MrZyR
	 Pjh1yFP32+4LIkXpIO9I49UB7ScjUEMGH7Iop4MCWFeZPSxXB/Pw9rpSgN+sn0FBbZ
	 BrawoQD7aOIdeKgZnx/yxRETdhFIR/U3Pov5T0Oxfsqt7DCQa4FWrHe2XnJI9CGiXn
	 xuVypPxbUMHLc2kcLrSZSuZe0EYo9yY0knWNXTikSr4dpK/UEhrRlPcIDru2rbIYgY
	 34NmufDMSaAXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/283] power: supply: bq256xx: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:05:14 -0500
Message-ID: <20260228180709.1583486-172-sashal@kernel.org>
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

[ Upstream commit 8005843369723d9c8975b7c4202d1b85d6125302 ]

Using the `devm_` variant for requesting IRQ _before_ the `devm_`
variant for allocating/registering the `power_supply` handle, means that
the `power_supply` handle will be deallocated/unregistered _before_ the
interrupt handler (since `devm_` naturally deallocates in reverse
allocation order). This means that during removal, there is a race
condition where an interrupt can fire just _after_ the `power_supply`
handle has been freed, *but* just _before_ the corresponding
unregistration of the IRQ handler has run.

This will lead to the IRQ handler calling `power_supply_changed()` with
a freed `power_supply` handle. Which usually crashes the system or
otherwise silently corrupts the memory...

Note that there is a similar situation which can also happen during
`probe()`; the possibility of an interrupt firing _before_ registering
the `power_supply` handle. This would then lead to the nasty situation
of using the `power_supply` handle *uninitialized* in
`power_supply_changed()`.

Fix this racy use-after-free by making sure the IRQ is requested _after_
the registration of the `power_supply` handle.

Fixes: 32e4978bb920 ("power: supply: bq256xx: Introduce the BQ256XX charger driver")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Link: https://patch.msgid.link/39da6da8cc060fa0382ca859f65071e791cb6119.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq256xx_charger.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/supply/bq256xx_charger.c b/drivers/power/supply/bq256xx_charger.c
index c8368dae69c71..2b0216d32d5f7 100644
--- a/drivers/power/supply/bq256xx_charger.c
+++ b/drivers/power/supply/bq256xx_charger.c
@@ -1746,6 +1746,12 @@ static int bq256xx_probe(struct i2c_client *client)
 		usb_register_notifier(bq->usb3_phy, &bq->usb_nb);
 	}
 
+	ret = bq256xx_power_supply_init(bq, &psy_cfg, dev);
+	if (ret) {
+		dev_err(dev, "Failed to register power supply\n");
+		return ret;
+	}
+
 	if (client->irq) {
 		ret = devm_request_threaded_irq(dev, client->irq, NULL,
 						bq256xx_irq_handler_thread,
@@ -1758,12 +1764,6 @@ static int bq256xx_probe(struct i2c_client *client)
 		}
 	}
 
-	ret = bq256xx_power_supply_init(bq, &psy_cfg, dev);
-	if (ret) {
-		dev_err(dev, "Failed to register power supply\n");
-		return ret;
-	}
-
 	ret = bq256xx_hw_init(bq);
 	if (ret) {
 		dev_err(dev, "Cannot initialize the chip.\n");
-- 
2.51.0

