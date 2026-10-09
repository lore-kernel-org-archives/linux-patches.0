Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744BE4D5964;
	Fri,  9 Oct 2026 14:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555530; cv=none; b=YpQzW5RTDy7YITqFwKVSM/RiN7Topyd97EuNWNwopvi63cqC6QwX66ROVrBmxnXYAaLCUNivZFDGLlyYShqwAuzbIWJCqT9f4HtqbQyF1+KeefS4a/drPgbAhqRL/Z7HvbXLxx3q0TogseCT23tOpMFtJooYoI3AjDnbXwSpGsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555530; c=relaxed/simple;
	bh=b+e98YGA11Li0O9p8Lcpu/kp4+yeSgvzS2UTnOPBj+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eA6n8M7u55ps0gMiP7KG3c8rsIxLbA2xwvaq2jJ7V96qwMTlzdZXRf4I9KSRBV8laXAyHMdMELciv1Qm2Qe6Mva5Ees4igAYR46VCSKVb7qzqs8s4F2ix8yppkF4O0jyhsGP9JAJa9F7m/nf+URkc1OUzTKnlW42cwdQLSk2DRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blt1vF3G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blt1vF3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9405A1F000FF;
	Fri,  9 Oct 2026 14:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555528;
	bh=/LzV8V1ARtgVpvpZItYI4Pjs/3H8o9DwR/tvwFDdWsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=blt1vF3GWWijwa5wZClZj/47V7vw1FTCjeYFFvjztpCiQnELJ79NLDMwFkOo/ENqR
	 YsDx3V4vgOqHPoUzOokxHcv5SRmyrK/LN+x4oBNUFlGjK+MTxjAP8bdRlSl+xo4xHi
	 H9pFxrsvys5+QlIYRJkWgFSvDjgoM2Phlh7Qb26s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/403] rtc: ac100: Fix clock provider use-after-free on probe failure
Date: Fri,  9 Oct 2026 16:07:15 +0200
Message-ID: <20261009140953.827117648@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit fcf0b58e976e83adf246b014518e49c662b96f5e ]

ac100_rtc_register_clks() registers the RTC-32k clock with
clk_hw_register_fixed_rate() and the clock provider with
of_clk_add_hw_provider(). Neither is device managed, and both are
released only from ac100_rtc_remove(). The driver core does not call
remove() when probe() fails: really_probe() reaches probe_failed below
the device_remove() call and goes straight to releasing the device's
managed resources.

ac100_rtc_probe() ends with

	return devm_rtc_register_device(chip->rtc);

so if that fails after the clocks have been registered, the provider is
left on the global of_clk_providers list holding chip->clk_data, which
was allocated with devm_kzalloc() and is freed while probe() unwinds. A
later lookup on this device tree node then reads freed memory in
of_clk_hw_onecell_get(). Consumers that do exactly that exist in tree:
the wifi power sequence nodes on sun8i-a83t-bananapi-m3 and
sun8i-a83t-cubietruck-plus take <&ac100_rtc 1>, and the sun9i-a80 boards
route osc32k through <&ac100_rtc 0>. The window is narrow, as
devm_rtc_register_device() can only fail with -ENOMEM here, but the
provider is left dangling whenever it does.

The RTC-32k clock is leaked on the same path. Since clk_core_lookup()
searches a global list that is not scoped per device, __clk_register()
rejects the duplicate name with -EEXIST, so the leak also makes a later
probe of the same device fail.

The error path that returns -EINVAL when the ADDA 4M parent clock cannot
be found leaks the RTC-32k clock in the same way. No provider has been
registered at that point, so that one is a leak rather than a
use-after-free.

Register both with devm_clk_hw_register_fixed_rate() and
devm_of_clk_add_hw_provider() so that they are released whenever the
device goes away, on a failed probe as well as on unbind. Devres
releases in reverse order of acquisition, so the provider is removed
before chip->clk_data is freed, and the clkout children are now
unregistered before their parent rather than after it.
ac100_rtc_unregister_clks() and the remove callback then have nothing
left to do and are removed.

Fixes: d00a18a42c14 ("rtc: ac100: Add RTC driver for X-Powers AC100")
Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-rtc/20260905184936.155E11F00A3A@smtp.kernel.org/
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Link: https://patch.msgid.link/AS8P251MB0001A489CC45A591ABBB9BDCC8B42@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ac100.c | 36 +++++++-----------------------------
 1 file changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/rtc/rtc-ac100.c b/drivers/rtc/rtc-ac100.c
index 9917cd67f4c6d..ef6a9368c63f2 100644
--- a/drivers/rtc/rtc-ac100.c
+++ b/drivers/rtc/rtc-ac100.c
@@ -318,10 +318,10 @@ static int ac100_rtc_register_clks(struct ac100_rtc_dev *chip)
 
 	chip->clk_data->num = AC100_CLKOUT_NUM;
 
-	chip->rtc_32k_clk = clk_hw_register_fixed_rate(chip->dev,
-						       AC100_RTC_32K_NAME,
-						       NULL, 0,
-						       AC100_RTC_32K_RATE);
+	chip->rtc_32k_clk = devm_clk_hw_register_fixed_rate(chip->dev,
+							    AC100_RTC_32K_NAME,
+							    NULL, 0,
+							    AC100_RTC_32K_RATE);
 	if (IS_ERR(chip->rtc_32k_clk)) {
 		ret = PTR_ERR(chip->rtc_32k_clk);
 		dev_err(chip->dev, "Failed to register RTC-32k clock: %d\n",
@@ -355,28 +355,14 @@ static int ac100_rtc_register_clks(struct ac100_rtc_dev *chip)
 		if (ret) {
 			dev_err(chip->dev, "Failed to register clk '%s': %d\n",
 				init.name, ret);
-			goto err_unregister_rtc_32k;
+			return ret;
 		}
 
 		chip->clk_data->hws[i] = &clk->hw;
 	}
 
-	ret = of_clk_add_hw_provider(np, of_clk_hw_onecell_get, chip->clk_data);
-	if (ret)
-		goto err_unregister_rtc_32k;
-
-	return 0;
-
-err_unregister_rtc_32k:
-	clk_unregister_fixed_rate(chip->rtc_32k_clk->clk);
-
-	return ret;
-}
-
-static void ac100_rtc_unregister_clks(struct ac100_rtc_dev *chip)
-{
-	of_clk_del_provider(chip->dev->of_node);
-	clk_unregister_fixed_rate(chip->rtc_32k_clk->clk);
+	return devm_of_clk_add_hw_provider(chip->dev, of_clk_hw_onecell_get,
+					   chip->clk_data);
 }
 
 /*
@@ -614,13 +600,6 @@ static int ac100_rtc_probe(struct platform_device *pdev)
 	return devm_rtc_register_device(chip->rtc);
 }
 
-static void ac100_rtc_remove(struct platform_device *pdev)
-{
-	struct ac100_rtc_dev *chip = platform_get_drvdata(pdev);
-
-	ac100_rtc_unregister_clks(chip);
-}
-
 static const struct of_device_id ac100_rtc_match[] = {
 	{ .compatible = "x-powers,ac100-rtc" },
 	{ },
@@ -629,7 +608,6 @@ MODULE_DEVICE_TABLE(of, ac100_rtc_match);
 
 static struct platform_driver ac100_rtc_driver = {
 	.probe		= ac100_rtc_probe,
-	.remove		= ac100_rtc_remove,
 	.driver		= {
 		.name		= "ac100-rtc",
 		.of_match_table	= of_match_ptr(ac100_rtc_match),
-- 
2.53.0



