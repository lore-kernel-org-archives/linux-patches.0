Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D29C2C17A0;
	Wed, 25 Feb 2026 06:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002604; cv=none; b=bQOovhZJ9RQB9W0xLZwRo9ZZvu8sefRZQW70QKmgj3rr9epOH1QN8ZQTWvli/v/BrlXt4ursPjmsXQD3h9Cva5JrmAZHeoKBNfV1z2s8iWs6VIyIW7JgXfUe47pHZnZadD2o5bq+J70M1bS0dNje7Hs5p+B5v36Pnf77CuUs5mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002604; c=relaxed/simple;
	bh=if9xJ43Aeaks6Fw1IUIIudW43fziNa36uPHUPlr/XvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvQUrBUJ8MdYGL8rHWuDDxRyIw2XEk9VXX0Sg485xd9ygpuWhxGK1yaz+LoN76wqlMM1TVVIkEIG6yGtEzmG1P+1oEd5kZXlFxft8JiG/Nyit7IMgEYJdPkjJ5pex8i2U1mNoygeXe+JEoVuCOKrTL+ujE8JPcqx17ehmO7htjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEXXobfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEXXobfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EF1C116D0;
	Wed, 25 Feb 2026 06:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002604;
	bh=if9xJ43Aeaks6Fw1IUIIudW43fziNa36uPHUPlr/XvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEXXobfV/9iR7Hn53UWI3seuVKhk75cWKRRGCRw25pCahvROZOrq6yYkB+nv87OjW
	 pYt89XDA8FXaIAmODWfbyZR4e8o+2cNKKOUy1jouM5uFLprneSXkcMEfox9ZWY2BI8
	 z+zAG5vE17Rcx9qPzfGlPhFfC9yErFaaJcq8B4os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Phil Reid <preid@electromag.com.au>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 353/641] power: supply: sbs-battery: Fix use-after-free in power_supply_changed()
Date: Tue, 24 Feb 2026 17:21:19 -0800
Message-ID: <20260225012357.192774973@linuxfoundation.org>
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
index 943c82ee978f4..43c48196c1674 100644
--- a/drivers/power/supply/sbs-battery.c
+++ b/drivers/power/supply/sbs-battery.c
@@ -1174,24 +1174,6 @@ static int sbs_probe(struct i2c_client *client)
 
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
@@ -1217,6 +1199,24 @@ static int sbs_probe(struct i2c_client *client)
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



