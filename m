Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A5139B96D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302592; cv=none; b=SeesyzAUP9lHqGkI+OQza9+JXe87RnLpQI78jUD+qRqnir5GRR5nqomcZlxf2Fys8VGLq0mvpcy8Dknk0TuZry0wuZVbHmrRKABVXorsNHe0IDap3Koldd9KipETU+8cywG2YxzxFaNVK811LXrTzqHe8xkdbfgcsQCgnOl3SVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302592; c=relaxed/simple;
	bh=DFnR59OL4jpG1jJoiOFAIv3HZ3/CwNFOb7qfeE93ju8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2mJOF1puue2PUm16wUlo45tuwL1pBo+d8iFi/9W0Eu9eU8qabJ34J8mHIPpbPtvVfvwh+sRLMiPR4QSlX4T3963vG3hfdQ9Rpj2DOIlMosiwlfMS4Ljfac5bNCda17JorwkYwtj7JtfshehF+ihPU1eNE6ZcEQiqE+ox8p/txc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IoQfmi/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IoQfmi/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92374C2BC87;
	Sat, 28 Feb 2026 18:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302592;
	bh=DFnR59OL4jpG1jJoiOFAIv3HZ3/CwNFOb7qfeE93ju8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IoQfmi/MJWAm5BzpOlvv6PT2NgunrZScDhzIqqvCWkvnxBuv2CTRx2tXwsAB9RdU8
	 x8SPE0jYZ0J4qSY+y5zS3NQjb8e5xZDjl0qhKQqEOy1nNfmVPoExqiXI+M4XDgy17t
	 uMK2bIHz73mRMFsvbRr6gYTgxRckewR4Jgtzqhl4VYiakwSwvcyZ0ydsF8GsG3t2aG
	 Yc+PwlZDONpiGenzfk4tAUb/8r5fZizOVjstHUIQ7kG9InWQe/C4skQX/z4oWE5HVt
	 qUEzoEkr1yRMl1p/9mcACj8BZMFEHHD2pYRITi66BZMijoSRN0YKWMepm7KyfbF8Un
	 HXS8cn2sI5fJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Phil Reid <preid@electromag.com.au>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/164] power: supply: sbs-battery: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:14:02 -0500
Message-ID: <20260228181505.1600663-103-sashal@kernel.org>
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

[ Upstream commit 8d59cf3887fbabacef53bfba473e33e8a8d9d07b ]

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
the registration of the `power_supply` handle. Keep the old behavior of
just printing a warning in case of any failures during the IRQ request
and finishing the probe successfully.

Fixes: d2cec82c2880 ("power: sbs-battery: Request threaded irq and fix dev callback cookie")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Reviewed-by: Phil Reid <preid@electromag.com.au>
Link: https://patch.msgid.link/0ef896e002495e615157b482d18a437af19ddcd0.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/sbs-battery.c | 36 +++++++++++++++---------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/power/supply/sbs-battery.c b/drivers/power/supply/sbs-battery.c
index c4a95b01463ae..a633130a768df 100644
--- a/drivers/power/supply/sbs-battery.c
+++ b/drivers/power/supply/sbs-battery.c
@@ -1173,24 +1173,6 @@ static int sbs_probe(struct i2c_client *client)
 
 	i2c_set_clientdata(client, chip);
 
-	if (!chip->gpio_detect)
-		goto skip_gpio;
-
-	irq = gpiod_to_irq(chip->gpio_detect);
-	if (irq <= 0) {
-		dev_warn(&client->dev, "Failed to get gpio as irq: %d\n", irq);
-		goto skip_gpio;
-	}
-
-	rc = devm_request_threaded_irq(&client->dev, irq, NULL, sbs_irq,
-		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-		dev_name(&client->dev), chip);
-	if (rc) {
-		dev_warn(&client->dev, "Failed to request irq: %d\n", rc);
-		goto skip_gpio;
-	}
-
-skip_gpio:
 	/*
 	 * Before we register, we might need to make sure we can actually talk
 	 * to the battery.
@@ -1216,6 +1198,24 @@ static int sbs_probe(struct i2c_client *client)
 		return dev_err_probe(&client->dev, PTR_ERR(chip->power_supply),
 				     "Failed to register power supply\n");
 
+	if (!chip->gpio_detect)
+		goto out;
+
+	irq = gpiod_to_irq(chip->gpio_detect);
+	if (irq <= 0) {
+		dev_warn(&client->dev, "Failed to get gpio as irq: %d\n", irq);
+		goto out;
+	}
+
+	rc = devm_request_threaded_irq(&client->dev, irq, NULL, sbs_irq,
+		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+		dev_name(&client->dev), chip);
+	if (rc) {
+		dev_warn(&client->dev, "Failed to request irq: %d\n", rc);
+		goto out;
+	}
+
+out:
 	dev_info(&client->dev,
 		"%s: battery gas gauge device registered\n", client->name);
 
-- 
2.51.0

