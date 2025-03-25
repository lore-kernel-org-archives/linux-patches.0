Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939DB2571DC;
	Tue, 25 Mar 2025 12:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905717; cv=none; b=Hq7URhiwXZ7XKKjyYdJ+rclh621W6ir3B6yucaGEdsMdLyQ56UFBDRcb3qI7CT6s1/tY+4hC9k9WNxsw2avZX5LJaWhs6o1+hmD1+pTP8ogQb1WL6KqwuxtaL/1PRPn8zCasBOFjxvHz12g9Qae3fvMDYeJzMJ0wfX2GqvA90nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905717; c=relaxed/simple;
	bh=hM0PufEWJhDjz/qhYeutLO8kQ80OI5sveov65awtZlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uu6IuMrvGnahfIDGn5hUraJ0sbJY2kJ25f9I5wjD+/H/1GTy5o5hdbrgKnqzfKfQb37s8DGuf17KmU9QHGENx25ggqSH4sR3H7zm6VeS6eWRyCNCdLim4MzjbNLiXqsb4lMb90MG4MKL/dcInz54oO20bazj6fIvMImiGmc5Ojk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpCKH41d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpCKH41d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43332C4CEE4;
	Tue, 25 Mar 2025 12:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905717;
	bh=hM0PufEWJhDjz/qhYeutLO8kQ80OI5sveov65awtZlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpCKH41dKXY6LRiw+3iaagD2kblNZlpqeD6SmSZBwYct8Q/jh5tcTzEsxhJ/AjGQi
	 Y/IREw75S8LTMSv1+PaqNIUr5T/j+N2+Hzv6A20W2pH+1lqQvD0tKZJFcHY8IrXJn8
	 JwUpJ82R4h+Eyz7my5ZsGxTmEJhBsHchlFK9nkB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Stark <gnstark@salutedevices.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 125/198] leds: mlxreg: Use devm_mutex_init() for mutex initialization
Date: Tue, 25 Mar 2025 08:21:27 -0400
Message-ID: <20250325122159.931812599@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: George Stark <gnstark@salutedevices.com>

commit efc347b9efee1c2b081f5281d33be4559fa50a16 upstream.

In this driver LEDs are registered using devm_led_classdev_register()
so they are automatically unregistered after module's remove() is done.
led_classdev_unregister() calls module's led_set_brightness() to turn off
the LEDs and that callback uses mutex which was destroyed already
in module's remove() so use devm API instead.

Signed-off-by: George Stark <gnstark@salutedevices.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20240411161032.609544-8-gnstark@salutedevices.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-mlxreg.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/drivers/leds/leds-mlxreg.c
+++ b/drivers/leds/leds-mlxreg.c
@@ -258,6 +258,7 @@ static int mlxreg_led_probe(struct platf
 {
 	struct mlxreg_core_platform_data *led_pdata;
 	struct mlxreg_led_priv_data *priv;
+	int err;
 
 	led_pdata = dev_get_platdata(&pdev->dev);
 	if (!led_pdata) {
@@ -269,28 +270,21 @@ static int mlxreg_led_probe(struct platf
 	if (!priv)
 		return -ENOMEM;
 
-	mutex_init(&priv->access_lock);
+	err = devm_mutex_init(&pdev->dev, &priv->access_lock);
+	if (err)
+		return err;
+
 	priv->pdev = pdev;
 	priv->pdata = led_pdata;
 
 	return mlxreg_led_config(priv);
 }
 
-static int mlxreg_led_remove(struct platform_device *pdev)
-{
-	struct mlxreg_led_priv_data *priv = dev_get_drvdata(&pdev->dev);
-
-	mutex_destroy(&priv->access_lock);
-
-	return 0;
-}
-
 static struct platform_driver mlxreg_led_driver = {
 	.driver = {
 	    .name = "leds-mlxreg",
 	},
 	.probe = mlxreg_led_probe,
-	.remove = mlxreg_led_remove,
 };
 
 module_platform_driver(mlxreg_led_driver);


