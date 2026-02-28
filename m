Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225672DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301837; cv=none; b=EyVwELbBdra674e9mStrpl4uyYxAWD27BtjtHpLJgnrDiZoq1eLXsNNaUagjtriDqOQD3G8kHTdWdULytycGGbmlrmp08PiYu0IuUTWR9bswzys0d3hk0J/byjOVlH0dnJWcia5TeF6q/g2LnVt3IIQWx5vvSYZKYZYZ+MgJt/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301837; c=relaxed/simple;
	bh=B21+Zrc+f2lknq19SuGgd6/OSzEPu18B8f6KP38mazc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTIwD9Lo04ukS5IG6BRJh4/Iv6ubAGBdRJ4fxM3x7oAZooD6qedGokNDFAn6Bclwlax6VLzTOtItwJI4X7JZsPf6/PdhyGbQ/BZSa0h2Loqr2BKimjsrvn/kbTjrraqVGNFAYxjI5OxtfjG31fYevXb/BA9wkeYpFP2KWyg62ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKS958NP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKS958NP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868F2C116D0;
	Sat, 28 Feb 2026 18:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301837;
	bh=B21+Zrc+f2lknq19SuGgd6/OSzEPu18B8f6KP38mazc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKS958NPs9gn67/DZJb7DOJqeGDoW76H2tN7ysMSMArEaHeNdkxY2pamyaxc1tKzf
	 Kqes7w0bU6lgtPvmQ2cYqo0pxOJ6XOpk7/0BGlt6doHMB6s+1OLjS8mOat/SYoinHz
	 TT7O9EGE8Mrl7/qHu5OKBo8TLU2Z7pgmScdckU2qObSw0PmAw7YrRwUbYb6WQ2iPCz
	 z+3mwteJtv12n84V7dGCohIMgPspkAdPNXkWyAP7VeM73FGUFVuTtHdUOAaz9LnmTZ
	 eOjvnQ9hjsvKWWAtuaFnMCVBDI/H3U4nyLILbhJUDiOWMcZ9NDitwJTYJphwcZZpc9
	 W+L/7SqWu/nqA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 255/385] power: supply: goldfish: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 12:57:57 -0500
Message-ID: <20260228180011.1568201-255-sashal@kernel.org>
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
index 479195e35d734..5aa24e4dc4455 100644
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
 
 	data->ac = devm_power_supply_register(&pdev->dev,
@@ -244,6 +238,12 @@ static int goldfish_battery_probe(struct platform_device *pdev)
 	if (IS_ERR(data->battery))
 		return PTR_ERR(data->battery);
 
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

