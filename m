Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D445138D017
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302177; cv=none; b=EpetLr7Q5U7n8oa7y65kiNMGH8DXDXEOPcEA3UC+hbrNv88DVqGiPWiMgiOUO4XEfSpq38xPqZvk3llh+scEeG1rvYF0xvTBO11be0O7NNzY5qO5i6EnUIYTTKf0mpJtALOzxNeUb1Q6hDh2zIoxGADQniSsGjxsPX2lsEdSl3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302177; c=relaxed/simple;
	bh=XS7yCkPaoW2IEsg4gRh6jYV2eyPp/1gD2vs+glAbB/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsPD1OIerL4mud7UpobLQPScazIEhe3V9PC7gy5Ufte3lZHMV0J6k3A2ulXqvWJ0m/kUu0gc6x9eZUd2DHTqOdXzm6PT8PgBiAJDddgJttp52xTeqXz6ABZkYP53lrgMw1fR2/A2j09Mpa0wdPrtN6jK2nvQm68RJhNLoXJONNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pGD/RcjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pGD/RcjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F847C19424;
	Sat, 28 Feb 2026 18:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302177;
	bh=XS7yCkPaoW2IEsg4gRh6jYV2eyPp/1gD2vs+glAbB/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGD/RcjCmoaPVHBR7M+EN8NY1YfkHZxEzTowp6EdXkOhBgV5CZ5vSfBZLctWuDd49
	 D1eSWCx86jXueswfidHl+BvarcrTn9IUyy/sYBs6sCcRLHndIdrMsOSvJmdG0GKBf1
	 Dp3OA2RWY/GBwWe0yRBsk8q90KcooLZGRmeyBREMakpSGNEdnNzUXVjYdBznqluyPx
	 10mhBhoaZYbmOVPJFUPkqetN+JMZU4rJxFCRkdPJcWb7KwQ3gLpPpJtG4dpnw/qDp0
	 ivqYjWBbCYyvetRov6LhnLB9x3heWxIA3jksSzisQLC59gkThuIKU6nRJBl2Mo0Adc
	 f/Qs2HKMdupJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Phil Reid <preid@electromag.com.au>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/283] power: supply: sbs-battery: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:05:19 -0500
Message-ID: <20260228180709.1583486-177-sashal@kernel.org>
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
index cdfc8466d129b..f30a542d4716c 100644
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

