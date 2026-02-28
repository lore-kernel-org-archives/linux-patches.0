Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA5E35AC20
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302727; cv=none; b=hl8Kgkxf8kulDj7jMl4un9yJs/NOH66cucLb/nIlp9X6pbXCehO/CW8lfADS4qGyuSGaeOnn2tlGYnYsVkCNCAZnq6Jf/a+RKJZ7EkkNw3AgbKEppQO5H+UWjHUls3blipcUh9T909o0nbhsxGcFWFEPiOPKcsrMvDduRO/NRm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302727; c=relaxed/simple;
	bh=Uur4cYf/UOz+C7kRL423bFKClhHv+Mn30nMup3rMlxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWuxTODIeKcCRVlSycnGHWBIVfa5a7IEEkb3aifXuF953aVY+3p1bIs2QFnoPJmcMGGHiau42W3JGMocmVnm7nXxgmxVnFp6QAXTBU7IJ5SyMJczpnHiHkH41UCEWXQL+zvOMcdl+6dvEFlShBCrG1LPT1JIArzmZD1Z5JzioDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OdlisZbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OdlisZbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F135AC19423;
	Sat, 28 Feb 2026 18:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302727;
	bh=Uur4cYf/UOz+C7kRL423bFKClhHv+Mn30nMup3rMlxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdlisZbF4cpq2g/VJXIhuHvvQOlPAwo+K+wM4/ZHS1aNyYX6lrdGe2GVrY6p4xMHT
	 VG0E37R82aaIEhUf6h1lI7H152ABCOfaDOnSj6pc1xRXCVFovB5j5TLT1+HfgW3H0y
	 exNYKBM9eLZ9wvNRfty0+riQWmduaMTiOB0hlS9z7xZYwNlJ/+e4/+2Bv1kddCDTSU
	 uhELKFMVJ2G19vramo5YrVbuXXHFzQP+OD5Ao0Ra+G/PelMP4PYuuB/MONKeoUXbQv
	 7RGeOucuaLIMERHau6p0DAyFkjcYLEbi3vvkagV2ElfNBljp5ZLfZRxEuDVBJ4C/sr
	 SjZm1oExHqm3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Phil Reid <preid@electromag.com.au>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/147] power: supply: sbs-battery: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:16:37 -0500
Message-ID: <20260228181736.1605592-89-sashal@kernel.org>
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
index b6a538ebb378f..ee8816ce0b800 100644
--- a/drivers/power/supply/sbs-battery.c
+++ b/drivers/power/supply/sbs-battery.c
@@ -1131,24 +1131,6 @@ static int sbs_probe(struct i2c_client *client)
 
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
@@ -1176,6 +1158,24 @@ static int sbs_probe(struct i2c_client *client)
 		goto exit_psupply;
 	}
 
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

