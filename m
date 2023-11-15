Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A2145C12
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2py5Gvip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDD8C433CB;
	Wed, 15 Nov 2023 22:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085793;
	bh=kTZ45n3+gUD/1IKkuU440iIjEYaXAbejM6Z9tbL3XB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2py5GvipXrClU9Pcs+0HnycbPqBS5CIgCum8U4mRZy6O0ivwV7V9blUxuJG3e1f9Y
	 C7msNsxyYaOcwv3TcwwwMGCC43OwhvwowRNEJSCWVqSBjTUKy0i0GfToOoWoGqPYkR
	 x2FfHj4XOynzBqynqUNv/vzbwvxeNs2ZADkjqc8w=
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
Subject: [PATCH 5.4 057/119] HID: cp2112: Use irqchip template
Date: Wed, 15 Nov 2023 17:00:47 -0500
Message-ID: <20231115220134.397067598@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 340408f8c8ab2..f2ff244c6b106 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -1240,6 +1240,7 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	struct cp2112_device *dev;
 	u8 buf[3];
 	struct cp2112_smbus_config_report config;
+	struct gpio_irq_chip *girq;
 	int ret;
 
 	dev = devm_kzalloc(&hdev->dev, sizeof(*dev), GFP_KERNEL);
@@ -1343,6 +1344,15 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
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
@@ -1358,17 +1368,8 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
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



