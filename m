Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F011359A72
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302407; cv=none; b=drhGhfpOKo7LCh7JmS0MJ5OrvaV8YPROoVOy1FXdKShUuUgztYFTujPNRj52t84w1ebtx0+mKCiiafoAQCP5fjR9veK8mx0LHBnsYkATD0cXsuJ95kD1I+9QU6iInJXN472OClodDVb/FXOpt7yJFYFoCr6wZPdO5g3eGZ6Zm5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302407; c=relaxed/simple;
	bh=ZI8EmwhkU14hhjxXFFt7gI5cGF9/AuGaxZmmSrSOXo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVbZ7pm8Qf+Jvj2Ox/8gOV0gMpmjcFYuEzZQlib5pRHPDkLAC+ysd6CSWGuhbGim/TuegU+MjSLrUIj7f26kPM1w7m/GYHBUBHzqZcdnd0/qguh2S9ARXrcqjlXcGtgGjbfNMahSk0WsfxW44CvrKQiivVDb0IyUNnRds9NEIU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HxtsRaLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HxtsRaLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E383C116D0;
	Sat, 28 Feb 2026 18:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302407;
	bh=ZI8EmwhkU14hhjxXFFt7gI5cGF9/AuGaxZmmSrSOXo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxtsRaLLp7/xK8YWxVHzbMscnEDU7p5IZRYifEcZ9tB9gNcbDKqXbS5wjN3HyBLM9
	 9RQGrC+VgXr7lhY7P3SdolZzF0LD1QUBulGpdKvM2orMYFvWylAIM0bJtLYh28pNFL
	 2V8fXiEvNZwJ3rfUa2oP4HzevMLF0DCdHyj3nDbJfg+QWHNOubQ+3EHySQVaP53iF1
	 k2n0vN/QM6FKICXObAu4UVo2Brzcxxc167SgduHMV0k717sFwL0Sf7aW+WcCz9rqO1
	 /KJQBw33C+zXqKEF5LAhHkMr3RM0eZrFklQtc2h0Ab9OYY63EHJCEwgxLXU3tBnxy+
	 9Ugig+/9HjOPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/232] power: supply: goldfish: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:09:52 -0500
Message-ID: <20260228181127.1592657-139-sashal@kernel.org>
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

[ Upstream commit b2ce982e2e0c888dc55c888ad0e20ea04daf2e6b ]

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

Fixes: 84d7b7687489 ("power: Add battery driver for goldfish emulator")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Link: https://patch.msgid.link/500a606bb6fb6f2bb8d797e19a00cea9dd7b03c1.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/goldfish_battery.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/supply/goldfish_battery.c b/drivers/power/supply/goldfish_battery.c
index a58d713d75ce8..4d204f0e18532 100644
--- a/drivers/power/supply/goldfish_battery.c
+++ b/drivers/power/supply/goldfish_battery.c
@@ -224,12 +224,6 @@ static int goldfish_battery_probe(struct platform_device *pdev)
 	if (data->irq < 0)
 		return -ENODEV;
 
-	ret = devm_request_irq(&pdev->dev, data->irq,
-			       goldfish_battery_interrupt,
-			       IRQF_SHARED, pdev->name, data);
-	if (ret)
-		return ret;
-
 	psy_cfg.drv_data = data;
 
 	data->ac = power_supply_register(&pdev->dev, &ac_desc, &psy_cfg);
@@ -245,6 +239,12 @@ static int goldfish_battery_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
+	ret = devm_request_irq(&pdev->dev, data->irq,
+			       goldfish_battery_interrupt,
+			       IRQF_SHARED, pdev->name, data);
+	if (ret)
+		return ret;
+
 	GOLDFISH_BATTERY_WRITE(data, BATTERY_INT_ENABLE, BATTERY_INT_MASK);
 	return 0;
 }
-- 
2.51.0

