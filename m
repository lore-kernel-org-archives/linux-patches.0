Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131D035AC12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302726; cv=none; b=CwkoDgHFps4vH/IYbNtVHUVElTjHWq8y+vUwDC1jpa92a7/w1gLbWx43NYb/8lu6CC99VsWHQ7p8ibnbzb6NZnIImC/tzUwWKZ6+HAmml53yOUx1Sn0RwHuMRyhHStSP5ltMBT22rbIdKezrcA+4EZzljN49aDh1Mle4GbVby+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302726; c=relaxed/simple;
	bh=mLOatFH7vwMzwa8GY6dXa0XDPEdJekvE4seQsG0XeFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PS6SbdVtUu4P0qkYi3BKwceNrxdiOb9SQYArVDWokICyLT+5fYACL3T1g9vuAiSL2SS7Yax21nn3aUEMBXNlPrFgd8R37W1FL3CHxspaXNCKWe6kHzDtKef5lAk/QVV2dKk0jplvU4mfTMUeikmec7mAZrqhQA3dUsnjHyJQ8Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nd6EZgsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nd6EZgsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EDAC19423;
	Sat, 28 Feb 2026 18:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302726;
	bh=mLOatFH7vwMzwa8GY6dXa0XDPEdJekvE4seQsG0XeFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nd6EZgsGn445hi21YNG/uuIdad6LQ3dbl8WH5erzVsky1pK7LBYDe+v/Tg2RO0MdP
	 jyWG0N9PTgMUlie1oOOZn2rV2ZisGjLGOHKdhIftjDDKNRKErc+XkTV4ZdMceQ/ewP
	 jfJhqrFb+OHTLESCQk0lznqBjCkOOoMJp9JB8Fwn1MgPfuqTPrciX49Q+3o9KIjptZ
	 h5LRjh8CRwBh64fXZA9piB8xKDLMK73kXEvvQJ9xbiYEznTlx+La1bK5NjbdB5nukR
	 C/zs/jrkl5Q0ck/1Gb7nlIt2FQBSDLa/R7JhMOPdbbJhcjYMUkKZLRlNaPFG7aobAq
	 MBsFnWbbxVcGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/147] power: supply: goldfish: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:16:35 -0500
Message-ID: <20260228181736.1605592-87-sashal@kernel.org>
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
index bf1754355c9fc..c7502fa8efa7b 100644
--- a/drivers/power/supply/goldfish_battery.c
+++ b/drivers/power/supply/goldfish_battery.c
@@ -226,12 +226,6 @@ static int goldfish_battery_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	ret = devm_request_irq(&pdev->dev, data->irq,
-			       goldfish_battery_interrupt,
-			       IRQF_SHARED, pdev->name, data);
-	if (ret)
-		return ret;
-
 	psy_cfg.drv_data = data;
 
 	data->ac = power_supply_register(&pdev->dev, &ac_desc, &psy_cfg);
@@ -247,6 +241,12 @@ static int goldfish_battery_probe(struct platform_device *pdev)
 
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

