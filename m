Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF3F359A61
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302404; cv=none; b=s0xpkW6wuHCfBFWxBGYTxr+Td5QR+iVTSETmQMgtUZ32dwabU1WOIQxluyfkwwfRGXv0qcmAjsRl/g6gdEzvvNl78iEp5oGIYwIkf+BVKfgOpMb7j9QTrrA9vBEvBuuMD7YbLwf/Ui4llylAWpG3DkI6Na0KX/ANYly43iFWWpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302404; c=relaxed/simple;
	bh=nZtQ2aA95fdYg1HdvmxyA3DRvf2aqXEEdmNki7HrlWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcZ9KfXgoXkP//NBAdavPU68em9nEopfd25mt1LIKuaAHUIc0FiaMldukuxkD2c7uIwnQ5/gK3xykkO1SlB6VebY1w4IDz6lwUWSlVqsx2We3ZXsKzn3wZXxnv1ca3fFTA0g/bZ5apm7xJGaAR/ooqDOnCBacn6P939zw3EtdGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=haFZM4oE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="haFZM4oE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397B0C19423;
	Sat, 28 Feb 2026 18:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302404;
	bh=nZtQ2aA95fdYg1HdvmxyA3DRvf2aqXEEdmNki7HrlWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=haFZM4oEzjLgnAZw1DCCKP5KehmLl7Fg4JzU3Vg6g5t9aZyLPGpkS1YNGQ+KI6qyz
	 XF1T21O2lMp1dnfvR+VXfxr+vqRYGtXacirA6NEsZrzCAj4lPFUUHmOlfmd3xsEsyb
	 eBWrk6pUwuUD3Cwu4kiphk0EkliO3fgXcnrbjnwFsB9wHd2TYvLl8wa6UcibTRb8Br
	 o9bWQfn+1Qn0McO0qY2efjjRHOjPNLFhpe6cV/x02zYldk7bwrhufyq/eP72btAeQu
	 SNZTlUWOtjH7GRxNz13RmFdbpO5K6Jp9hT6+B+YNtCozZgT5YAuF7TQ5zfCvjRcq3F
	 rwFVDtgIN3hXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/232] power: supply: bq256xx: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:09:49 -0500
Message-ID: <20260228181127.1592657-136-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 686eb8d86e221..e75283006d29c 100644
--- a/drivers/power/supply/bq256xx_charger.c
+++ b/drivers/power/supply/bq256xx_charger.c
@@ -1678,6 +1678,12 @@ static int bq256xx_probe(struct i2c_client *client,
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
@@ -1690,12 +1696,6 @@ static int bq256xx_probe(struct i2c_client *client,
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

