Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBAC1C9DEB;
	Wed, 20 Nov 2024 13:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107621; cv=none; b=UNKvwYzvq27bHqFeboWgU0SBNUIA7l4vjo+qCHg3T669xWHKYsjslEcYOoSzJNQQFy/AX2OHVzwe8aaB6nHYar00BMe2rTrGOprOOk5Fhbi0XAWKpwW39hbeFhX3trM9k2kYZc8F0FjIKK74tFxj/1a1TpRjECYdGWLPyGEmYdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107621; c=relaxed/simple;
	bh=pOsTQToWyFYGAgaQOntpdeMQpnTxAAQTMqHpuKqfNwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGqhLb2Wymj2CvsIMsENZYz7tYHKrhOPPwG8HOycqXCMnO3zUWQo7iO0e8xUom+SX9176CTRj27FbaQEJZS4f4XM/g4/UxeqHpk14g+GN16SRg60qIKS0MHPSPqs6lUixFLKvC4jp1vR4h2MvQddoVFhKDgeT3WHecUVzM07pZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMLIrqVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMLIrqVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E75C4CECD;
	Wed, 20 Nov 2024 13:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107620;
	bh=pOsTQToWyFYGAgaQOntpdeMQpnTxAAQTMqHpuKqfNwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMLIrqVm4I9vyPlwihXfasH9t38ouzY2hPAj8TN6hrtjjx51gkyjSAgz5UG/NytVx
	 p/fl3Qhxq7UIlCz6KkPZ1a5t3VcDr9R0d4awWMPrzRlNrRxuk5FQrdtigGQGIr2hs7
	 UZP7YNlsFCfyUDaW+LejnndOBpaPkN59hayzyQzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Stark <gnstark@salutedevices.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Bin Lan <bin.lan.cn@windriver.com>
Subject: [PATCH 6.6 74/82] leds: mlxreg: Use devm_mutex_init() for mutex initialization
Date: Wed, 20 Nov 2024 13:57:24 +0100
Message-ID: <20241120125631.282792930@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ Resolve minor conflicts to fix CVE-2024-42129 ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-mlxreg.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/drivers/leds/leds-mlxreg.c
+++ b/drivers/leds/leds-mlxreg.c
@@ -257,6 +257,7 @@ static int mlxreg_led_probe(struct platf
 {
 	struct mlxreg_core_platform_data *led_pdata;
 	struct mlxreg_led_priv_data *priv;
+	int err;
 
 	led_pdata = dev_get_platdata(&pdev->dev);
 	if (!led_pdata) {
@@ -268,28 +269,21 @@ static int mlxreg_led_probe(struct platf
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


