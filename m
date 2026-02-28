Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4409E270545
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302176; cv=none; b=hZVFjpoS/Geeo5+SLDygC4B1OYIBy9qBLjawjoUE0LdX9GtVsnDWi7RTCu6Ld/omrQlvvK3R+Y7k3XWJlsUUWSSpJxOqZuXND0uVCNITjvrZp5WVachGVQdiL3s5zLzWx4mnNlS1PReSJ0oQbxhhZA5bT/eQesehFIzAKZIHehQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302176; c=relaxed/simple;
	bh=ZI8EmwhkU14hhjxXFFt7gI5cGF9/AuGaxZmmSrSOXo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIsYwK4hAeWJXmltmmnLGSRZ71Z++ZsPOHTnYf/iGQvesG8wY0lYfphbnYgDONPhFcZcPFSGOfqfDnYhbAGvVPIrvN2/yRe/VLbLEHH8+TQg6fA3wN28RM0mcMFkd+BADAqNJZeu1lbnInonPkA2HqOqacq42HdKwr3+4Q8TXu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=szmQKXjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="szmQKXjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8121C116D0;
	Sat, 28 Feb 2026 18:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302176;
	bh=ZI8EmwhkU14hhjxXFFt7gI5cGF9/AuGaxZmmSrSOXo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szmQKXjzRhHD4ZLyxZbL6oaK64OhLQ3MjRo0/k/mkg4tc3Uu9W04Gfplk7mxv8vSN
	 64DS/AOFrzIvnmxxORLQ0DgOw9MFZo/6zLvv9txQT84Riw4Ta0F9HBTNOtranUN2fp
	 HV0xL/xm4GzztvngawH27racJQGUkqk3Nc0YdxAu68iNqvDw5fic/SUx2u61jMY6R7
	 MLjQyMFhep/6sOWg62qe0oZSa4G1njIZtG3Itf9Yp193lYqCDpiGKhL87qjUwpJFP5
	 Zn5z0xSIBBi3pv/cyqGteqbjkazZ5WQBTQUHLPyDMaZ4cZ4LRPHJg4MmpNc72LRgrP
	 N+pGiiBdIkyDA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/283] power: supply: goldfish: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:05:17 -0500
Message-ID: <20260228180709.1583486-175-sashal@kernel.org>
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

