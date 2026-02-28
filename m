Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4A134252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301840; cv=none; b=MxFdBUOOEMWpHQVQMmCjVkvfW2VxMgTOGce9n6wt/cpr8wwKDhxbLXiyNtxqKcX4KQxvBm6LfgKH+PnsPfPFYs15+Ik/QwxagSkxLU2vYjT0iy21Ynal/DnNnK29LbmeLsCF14EJ10sSjHaRFrv2AK4Y7nXg3uQp+qhP9jpShpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301840; c=relaxed/simple;
	bh=DzTUD1EeiKnZBDXZClObqgGyOewPAhuXrPofvG+0XPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQUR5aZovEz2z75Vqgd2GMTwTzS5NsXu7T7YaQiYBycl2fgMiMORlrcoq1DyJ9AFE05k/op2WGE2GoCIhytNVcF/TYPXwBOFBfmp/MwnRYHoPnOl0UxTljUBRiEsupgelr/MYR7PuFlAjg79Hetj7cVL38ecNH84I7K/iNjB2RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKmyFaqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKmyFaqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7587C19425;
	Sat, 28 Feb 2026 18:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301840;
	bh=DzTUD1EeiKnZBDXZClObqgGyOewPAhuXrPofvG+0XPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKmyFaqAMokk/kZAoZkfGlMSnels67ASDErLziEjFIJ7IKNCMwy/2nBl5/8esGuIZ
	 mYUWj2Sh1lqSy0ocZhvKc4pHDhVJx7L9tBbkp84QlUf+uhPJBaS1H3IioPk7qqlqr2
	 cd8sXeJH5HK+awGgq+fgQmJm0/v9GhhNP3CgE71S632MBsx0Z6TmJkao0PhfLRLTf1
	 IKc2FLwQFsZYtUEl2cw5HKSfEjHhrQFVLFGZ6cV1PxevrDJvdYwXWioI0bwxjfTTCM
	 SDE2PoXcA8i+FbO6UyC1rFqigIzk5HrS6ww9H//HwwR0gZ3upX0cYPUaHhmuluBofk
	 xUVDbTjnPcHJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Phil Reid <preid@electromag.com.au>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 259/385] power: supply: sbs-battery: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 12:58:01 -0500
Message-ID: <20260228180011.1568201-259-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index a6c204c08232a..f80edceafc3cf 100644
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

