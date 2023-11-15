Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1642F18657
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0Hm5QIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F4FC433CA;
	Wed, 15 Nov 2023 20:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081098;
	bh=EvU1VQxTaSwmcNZeibo4DHlVN1LyxG3Qy2CFZtVTGLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0Hm5QIPXzdNlnoWk8E7JKXLqTk4jNoT+rH6V1PZejYJaJn5HODvQfOEIHes1kZnZ
	 iHLyvwvSTEph38gJ5xilAaECOdBCnj1jGINoK752fGnuq2UCIVfgWV+zYh8ogfoiSk
	 j3pt5k9X8LdB/UoD0uvogkSDTYz/n2QYd5vDZRr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eudean Sun <eudean@arista.com>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	=?UTF-8?q?S=C3=A9bastien=20Szymanski?= <sebastien.szymanski@armadeus.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/88] HID: cp2112: Use irqchip template
Date: Wed, 15 Nov 2023 15:35:50 -0500
Message-ID: <20231115191428.473308282@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 6bfa31756ae905e23050ee10a3b4d3d435122c97 ]

This makes the driver use the irqchip template to assign
properties to the gpio_irq_chip instead of using the
explicit calls to gpiochip_irqchip_add(). The irqchip is
instead added while adding the gpiochip.

Cc: Eudean Sun <eudean@arista.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: e3c2d2d144c0 ("hid: cp2112: Fix duplicate workqueue initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-cp2112.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 637a7ce281c61..875fd8b2eec23 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -1245,6 +1245,7 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	struct cp2112_device *dev;
 	u8 buf[3];
 	struct cp2112_smbus_config_report config;
+	struct gpio_irq_chip *girq;
 	int ret;
 
 	dev = devm_kzalloc(&hdev->dev, sizeof(*dev), GFP_KERNEL);
@@ -1348,6 +1349,15 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	dev->gc.can_sleep		= 1;
 	dev->gc.parent			= &hdev->dev;
 
+	girq = &dev->gc.irq;
+	girq->chip = &cp2112_gpio_irqchip;
+	/* The event comes from the outside so no parent handler */
+	girq->parent_handler = NULL;
+	girq->num_parents = 0;
+	girq->parents = NULL;
+	girq->default_type = IRQ_TYPE_NONE;
+	girq->handler = handle_simple_irq;
+
 	ret = gpiochip_add_data(&dev->gc, dev);
 	if (ret < 0) {
 		hid_err(hdev, "error registering gpio chip\n");
@@ -1363,17 +1373,8 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	chmod_sysfs_attrs(hdev);
 	hid_hw_power(hdev, PM_HINT_NORMAL);
 
-	ret = gpiochip_irqchip_add(&dev->gc, &cp2112_gpio_irqchip, 0,
-				   handle_simple_irq, IRQ_TYPE_NONE);
-	if (ret) {
-		dev_err(dev->gc.parent, "failed to add IRQ chip\n");
-		goto err_sysfs_remove;
-	}
-
 	return ret;
 
-err_sysfs_remove:
-	sysfs_remove_group(&hdev->dev.kobj, &cp2112_attr_group);
 err_gpiochip_remove:
 	gpiochip_remove(&dev->gc);
 err_free_i2c:
-- 
2.42.0



