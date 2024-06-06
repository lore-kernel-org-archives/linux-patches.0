Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F55219CD15;
	Thu,  6 Jun 2024 14:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683442; cv=none; b=i9sPr7BVsCXvtS/Z0ioaivnqWkVlmX9a+YjUod61EBNGnDRX1/I2iCDMKxoDbP7APtXkXr8XB+Y1AVZ7V/jbo26257roazSFueeTNeCiB4ZXQtyDJSgKf+tlLLDqLkJ9T1A61Y3YmSPHxHLy+PeLMs6bVdtxbQlTrZH1z3wiNoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683442; c=relaxed/simple;
	bh=4CBYpYxfIQhOkCbtMpxbMeXpEeJaoxSwYJjlCAOHSlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1KSepD6SG8iex52T1uBV4CYlXgbxDq4x+PZVlCZhGAKo4XdPahplSznmmO8mHKAVi20X565CjR4dQ8EeUwMFmGWbFfjy1nPj6itB3VLEPRTiKuOLKFZv/9N4WE1gREa8/rjWvy4f5rx6jnpp0bW3FLs34x9Pbxfgx8dX0e+pOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwyazOFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwyazOFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEB9C2BD10;
	Thu,  6 Jun 2024 14:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683442;
	bh=4CBYpYxfIQhOkCbtMpxbMeXpEeJaoxSwYJjlCAOHSlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwyazOFgFwtM/QdujIlGOhkQQwtjZAxUQw4w6e4pJMO72fVbGjJMup+E5+zPqF66/
	 pAdgUv55i6OIuekku+epLl2j7E1z50KVlYsgz0QsRSHuzC6Yr3piH+AaAcvHM/wo2M
	 jW6lE8l6vonSnVMLvLdHyF1p+wkgUe7GTX3zqF/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 327/473] watchdog: bd9576: Drop "always-running" property
Date: Thu,  6 Jun 2024 16:04:16 +0200
Message-ID: <20240606131710.744220211@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit e3b3afd34d84efcbe4543deb966b1990f43584b8 ]

The always-running (from linux,wdt-gpio.yaml) is abused by the BD9576
watchdog driver. It's defined meaning is "the watchdog is always running
and can not be stopped". The BD9576 watchdog driver has implemented it
as "start watchdog when loading the module and prevent it from being
stopped".

Furthermore, the implementation does not set the WDOG_HW_RUNNING when
enabling the watchdog due to the "always-running" at module loading.
This will end up resulting a watchdog timeout if the device is not
opened.

The culprit was pointed out by Guenter, discussion can be found from
https://lore.kernel.org/lkml/4fa3a64b-60fb-4e5e-8785-0f14da37eea2@roeck-us.net/

Drop the invalid "always-running" handling.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Fixes: b237bcac557a ("wdt: Support wdt on ROHM BD9576MUF and BD9573MUF")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/ZhPAt76yaJMersXf@fedora
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/bd9576_wdt.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/watchdog/bd9576_wdt.c b/drivers/watchdog/bd9576_wdt.c
index 4a20e07fbb699..f00ea1b4e40b6 100644
--- a/drivers/watchdog/bd9576_wdt.c
+++ b/drivers/watchdog/bd9576_wdt.c
@@ -29,7 +29,6 @@ struct bd9576_wdt_priv {
 	struct gpio_desc	*gpiod_en;
 	struct device		*dev;
 	struct regmap		*regmap;
-	bool			always_running;
 	struct watchdog_device	wdd;
 };
 
@@ -62,10 +61,7 @@ static int bd9576_wdt_stop(struct watchdog_device *wdd)
 {
 	struct bd9576_wdt_priv *priv = watchdog_get_drvdata(wdd);
 
-	if (!priv->always_running)
-		bd9576_wdt_disable(priv);
-	else
-		set_bit(WDOG_HW_RUNNING, &wdd->status);
+	bd9576_wdt_disable(priv);
 
 	return 0;
 }
@@ -264,9 +260,6 @@ static int bd9576_wdt_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	priv->always_running = device_property_read_bool(dev->parent,
-							 "always-running");
-
 	watchdog_set_drvdata(&priv->wdd, priv);
 
 	priv->wdd.info			= &bd957x_wdt_ident;
@@ -281,9 +274,6 @@ static int bd9576_wdt_probe(struct platform_device *pdev)
 
 	watchdog_stop_on_reboot(&priv->wdd);
 
-	if (priv->always_running)
-		bd9576_wdt_start(&priv->wdd);
-
 	return devm_watchdog_register_device(dev, &priv->wdd);
 }
 
-- 
2.43.0



