Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB0B313530;
	Tue, 16 Dec 2025 11:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884548; cv=none; b=htk6p7qYxXEPUqG2S5MqjRFt9sXi3lfsbkMo54iB7NN5UqZ99DxgFKHJsxEOuyLyGI2NybfHhMC9jog+0QQ32ws5aYY7gBpDzNLQrDlT+RFkib8nyhUbgqcn8V+eFMN2WARNH2QlYaPIDlRfOEnaF5BCMdMpLkXqinWMqRbT3Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884548; c=relaxed/simple;
	bh=m6bmjwXsVFhic/IImVzTD/qw7jsrLe3LgRMdwEMTfDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvUi63U3ojJ2B/aysqU11T99pUNSw5LEXOKPqbqXw9Kywf8RwiTPRiC+xa7rmf7VWUNh2PSUcioeyhhMsYcfblX5Ng9ZhF+fi6O7DUEej7R4rCAchcHkY5edj2aTAcabfDUqrOcUFweBB6V00rxZ3r3HIUGsWj9NhTCKNdQTtQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQpvZQv6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQpvZQv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90B4C4CEF1;
	Tue, 16 Dec 2025 11:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884548;
	bh=m6bmjwXsVFhic/IImVzTD/qw7jsrLe3LgRMdwEMTfDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQpvZQv6ufplasbRvmHqC0mhmvms3Ki2XjpjzK5bcHHavPIe5nxs87ixG7cJS3mhP
	 Xu/6JmEqfEOccSyyNrht3Baxn6GP88FPwIaKM4LW0ZX1iXIMq3Vlu7y2w16YSyQiv5
	 FTQkDb5Q1GM69brjZ0qXpiRRVoRwabu1UxI/Q5+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Herve Codina <herve.codina@bootlin.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 227/354] backlight: led-bl: Add devlink to supplier LEDs
Date: Tue, 16 Dec 2025 12:13:14 +0100
Message-ID: <20251216111329.141893823@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit 9341d6698f4cfdfc374fb6944158d111ebe16a9d ]

LED Backlight is a consumer of one or multiple LED class devices, but
devlink is currently unable to create correct supplier-producer links when
the supplier is a class device. It creates instead a link where the
supplier is the parent of the expected device.

One consequence is that removal order is not correctly enforced.

Issues happen for example with the following sections in a device tree
overlay:

    // An LED driver chip
    pca9632@62 {
        compatible = "nxp,pca9632";
        reg = <0x62>;

	// ...

        addon_led_pwm: led-pwm@3 {
            reg = <3>;
            label = "addon:led:pwm";
        };
    };

    backlight-addon {
        compatible = "led-backlight";
        leds = <&addon_led_pwm>;
        brightness-levels = <255>;
        default-brightness-level = <255>;
    };

In this example, the devlink should be created between the backlight-addon
(consumer) and the pca9632@62 (supplier). Instead it is created between the
backlight-addon (consumer) and the parent of the pca9632@62, which is
typically the I2C bus adapter.

On removal of the above overlay, the LED driver can be removed before the
backlight device, resulting in:

    Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
    ...
    Call trace:
     led_put+0xe0/0x140
     devm_led_release+0x6c/0x98

Another way to reproduce the bug without any device tree overlays is
unbinding the LED class device (pca9632@62) before unbinding the consumer
(backlight-addon):

  echo 11-0062 >/sys/bus/i2c/drivers/leds-pca963x/unbind
  echo ...backlight-dock >/sys/bus/platform/drivers/led-backlight/unbind

Fix by adding a devlink between the consuming led-backlight device and the
supplying LED device, as other drivers and subsystems do as well.

Fixes: ae232e45acf9 ("backlight: add led-backlight driver")
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Tested-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://patch.msgid.link/20250519-led-backlight-add-devlink-to-supplier-class-device-v6-1-845224aeb2ce@bootlin.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/led_bl.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/video/backlight/led_bl.c b/drivers/video/backlight/led_bl.c
index 7826006018457..f0c7e25537d1f 100644
--- a/drivers/video/backlight/led_bl.c
+++ b/drivers/video/backlight/led_bl.c
@@ -209,6 +209,19 @@ static int led_bl_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->bl_dev);
 	}
 
+	for (i = 0; i < priv->nb_leds; i++) {
+		struct device_link *link;
+
+		link = device_link_add(&pdev->dev, priv->leds[i]->dev->parent,
+				       DL_FLAG_AUTOREMOVE_CONSUMER);
+		if (!link) {
+			dev_err(&pdev->dev, "Failed to add devlink (consumer %s, supplier %s)\n",
+				dev_name(&pdev->dev), dev_name(priv->leds[i]->dev->parent));
+			backlight_device_unregister(priv->bl_dev);
+			return -EINVAL;
+		}
+	}
+
 	for (i = 0; i < priv->nb_leds; i++) {
 		mutex_lock(&priv->leds[i]->led_access);
 		led_sysfs_disable(priv->leds[i]);
-- 
2.51.0



