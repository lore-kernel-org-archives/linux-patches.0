Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA402DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301838; cv=none; b=omjKGAY8J459woAxJKWKsOF05mfJm1xPtMGTXgK0arVvp0AhVSytCfCmaYRZ1qbbVul8rlAqOGdUP4CoIDA0fjXo4/iuyeFVkiO0fdmu/NeAi5uOf2HtvgDRN+CyMfgzikIoZLtq7PKtPLdb9PM2RNw1St+N/ccB3oOZGhdh2bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301838; c=relaxed/simple;
	bh=Nz6hnyNWyM0xSCzLezlRlfJn0L0HOkx1RgaGA/dHPF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oI0l60/HwknnaEz6WpxO8zreH9RL2I2pbn5U7lNrSp/x3usLTXnoWKfOTAC8qVU7mz6yr5vLnr5c1jm4a8k8myUkfoe0ef3MrI+ybuFd8C/nuMj27kv/D4Clzp3aDX2pWgQL2NlP54x8PUruz091MCljachwcCTRWDVgtoSuBBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K/wvyLi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K/wvyLi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454D8C116D0;
	Sat, 28 Feb 2026 18:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301837;
	bh=Nz6hnyNWyM0xSCzLezlRlfJn0L0HOkx1RgaGA/dHPF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/wvyLi30W0xsUzDXzLO8lp9p+7JBGEGsdg0j0f/SyvDy0EZzEAFXkoPw5gzmuugq
	 FO7KCev4zH9EBsqqP2VmblNkGKDCxn5voNhv1++O3Mh/c93ZuOec73S5xiuqCH890/
	 gSqP6Vfg2zY1y66Qva1cqwhMZJoW5o3bGzS6229V3nvKh+k4aC2A6EVQZhqSxDDQnk
	 b3zt8xua8y56Y9SNqtTFUHYS5mNekLiWWhzcQNq4/n4wPFJd2MYcJC6JuvcgsjmKZR
	 K57/2OXMct9NAAyUrMeYqbL2sp9lYnXNYOlEjsDnA+78GmmQU5jqmUWTDxFq9LdzOM
	 bdORL0EYjS0Sw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Nikita Travkin <nikita@trvn.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 256/385] power: supply: pm8916_bms_vm: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 12:57:58 -0500
Message-ID: <20260228180011.1568201-256-sashal@kernel.org>
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

[ Upstream commit 62914959b35e9a1e29cc0f64cb8cfc5075a5366f ]

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

Fixes: 098bce1838e0 ("power: supply: Add pm8916 VM-BMS support")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Reviewed-by: Nikita Travkin <nikita@trvn.ru>
Link: https://patch.msgid.link/2749c09ff81fcac87ae48147e216135450d8c067.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/pm8916_bms_vm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/power/supply/pm8916_bms_vm.c b/drivers/power/supply/pm8916_bms_vm.c
index 5d0dd842509c4..9b069af077be5 100644
--- a/drivers/power/supply/pm8916_bms_vm.c
+++ b/drivers/power/supply/pm8916_bms_vm.c
@@ -167,15 +167,6 @@ static int pm8916_bms_vm_battery_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return -EINVAL;
 
-	irq = platform_get_irq_byname(pdev, "fifo");
-	if (irq < 0)
-		return irq;
-
-	ret = devm_request_threaded_irq(dev, irq, NULL, pm8916_bms_vm_fifo_update_done_irq,
-					IRQF_ONESHOT, "pm8916_vm_bms", bat);
-	if (ret)
-		return ret;
-
 	ret = regmap_bulk_read(bat->regmap, bat->reg + PM8916_PERPH_TYPE, &tmp, 2);
 	if (ret)
 		goto comm_error;
@@ -220,6 +211,15 @@ static int pm8916_bms_vm_battery_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Unable to get battery info\n");
 
+	irq = platform_get_irq_byname(pdev, "fifo");
+	if (irq < 0)
+		return irq;
+
+	ret = devm_request_threaded_irq(dev, irq, NULL, pm8916_bms_vm_fifo_update_done_irq,
+					IRQF_ONESHOT, "pm8916_vm_bms", bat);
+	if (ret)
+		return ret;
+
 	platform_set_drvdata(pdev, bat);
 
 	return 0;
-- 
2.51.0

