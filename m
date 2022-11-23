Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CB31C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CACBC43153;
	Wed, 23 Nov 2022 09:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195588;
	bh=mCmpBwT8Ioz8zoxuf/jc5cRTM5dhY4OjpjcHwzkIS2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOj5u2ztCP6+VSRuyHY89uXNvS4WQi+MkvDH24IzPZwBUVDg/xqb32Ab8jz9Al2a1
	 z/fSz1BC7tiR1DOtEaKia+8ySSzC00DBskhDF46hL4uUbYf89xsv/r9xP4+6d/V3nf
	 NK3dKi3A5D9xT5nHISEllR5x1185/xqgLr3QELGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Chuhong Yuan <hslester96@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 097/149] USB: bcma: Make GPIO explicitly optional
Date: Wed, 23 Nov 2022 09:51:20 +0100
Message-Id: <20221123084601.486556062@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Walleij <linus.walleij@linaro.org>

commit cd136706b4f925aa5d316642543babac90d45910 upstream.

What the code does is to not check the return value from
devm_gpiod_get() and then avoid using an erroneous GPIO descriptor
with IS_ERR_OR_NULL().

This will miss real errors from the GPIO core that should not be
ignored, such as probe deferral.

Instead request the GPIO as explicitly optional, which means that
if it doesn't exist, the descriptor returned will be NULL.

Then we can add error handling and also avoid just doing this on
the device tree path, and simplify the site where the optional
GPIO descriptor is used.

There were some problems with cleaning up this GPIO descriptor
use in the past, but this is the proper way to deal with it.

Cc: Rafał Miłecki <rafal@milecki.pl>
Cc: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20221107090753.1404679-1-linus.walleij@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/bcma-hcd.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/bcma-hcd.c
+++ b/drivers/usb/host/bcma-hcd.c
@@ -285,7 +285,7 @@ static void bcma_hci_platform_power_gpio
 {
 	struct bcma_hcd_device *usb_dev = bcma_get_drvdata(dev);
 
-	if (IS_ERR_OR_NULL(usb_dev->gpio_desc))
+	if (!usb_dev->gpio_desc)
 		return;
 
 	gpiod_set_value(usb_dev->gpio_desc, val);
@@ -406,9 +406,11 @@ static int bcma_hcd_probe(struct bcma_de
 		return -ENOMEM;
 	usb_dev->core = core;
 
-	if (core->dev.of_node)
-		usb_dev->gpio_desc = devm_gpiod_get(&core->dev, "vcc",
-						    GPIOD_OUT_HIGH);
+	usb_dev->gpio_desc = devm_gpiod_get_optional(&core->dev, "vcc",
+						     GPIOD_OUT_HIGH);
+	if (IS_ERR(usb_dev->gpio_desc))
+		return dev_err_probe(&core->dev, PTR_ERR(usb_dev->gpio_desc),
+				     "error obtaining VCC GPIO");
 
 	switch (core->id.id) {
 	case BCMA_CORE_USB20_HOST:


