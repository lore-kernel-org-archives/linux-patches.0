Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840573D9DA8;
	Tue, 13 Oct 2026 12:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894802; cv=none; b=XNrMD0od2yR9dATGcKsb/W8kCkSneG1FDi6U5AW5zOZzX8pFbuN5Ma9WSFvAWuIM1m5GKgLFGo7oh30PY7xv+FNMQveC87656uCW0qwj9J0y4pF+aO3ZnC5P2AhR6zxYJ9QgfEAISvvNbgjymSKF4VlLg+nW5S4X9y3cjTsGXK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894802; c=relaxed/simple;
	bh=72qT8HNscHEitB2kDWxA1bfwBgCt+r7aOR3+yWplhao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eb9j+3rWm+aMZ+uLOBNY2Hy0S3oUXtaRbvB0jS7tO91eLtQX6/m2A9ZZ0S5eAGIF24l/zoff91K7ZRZgSx14IxDwAdmq49MZDOcKeHROepZeVPv8WlqRzL1fa43Jer3YXWhGu3DAqqGbbrqtdAWys7BKaSH3A+Kqwmp16l2GlOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIhhC3g/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIhhC3g/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB34F1F000FF;
	Tue, 13 Oct 2026 12:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894801;
	bh=deEsMc46r08M9psfI9Gbethg1t3o0C8lOGdgklMkF8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIhhC3g/O70GXsgPB0n/jth7YKcCEzvsVesWCj5F/7R4oO3ZOW7/EUoZV3MNQAO7U
	 yfFUZlnnYW5LtdzyHW5CpddnEdp8pt+6uy/VVmwlguwt8GxscYqkEn73FZR4CY+QkT
	 wF922YMCpOQ4afhoG0Z76IO4dZ4juzxskevHtuxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/497] rtc: ac100: Fix clock provider use-after-free on probe failure
Date: Tue, 13 Oct 2026 13:33:48 +0200
Message-ID: <20261013112909.335874051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



