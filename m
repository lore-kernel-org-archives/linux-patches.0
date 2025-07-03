Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2D52F270C;
	Thu,  3 Jul 2025 15:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556074; cv=none; b=PDydkXkTkqjSwpXijrxb5PAsOSlyoEFoArLMfNcVYKbBCCziWHeNdFNRaKmLvzxes9buxbrGiqT3gywKKTWxfp8Q9URCwQUXNH+4sCqO3XW61dJlSDc+7W0Dkrx0v2tNK+mcjGReTjRzTQkDenAUJiJmqkD4uLz6FbiI9wsGPMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556074; c=relaxed/simple;
	bh=4D1vBgMPwJXz+GeegKdtzuOvgQvBwVA4xRGlZaTtqxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0ZLs3fAotEoiewlkMi0zG5Iqrklu5URCI4VnR1lWtBG4FhQvi9YA5BOTmIAk4uED8wDYg+4nEb4txYLDnSrv9ldRKnlFB2oMxC6SiWIXlwswVeaWysqXr4UMNMvd6NvTlJM0D1T0bEpEPpFcmVRqTmT7ZhJJ4Bh0HUON/0IeWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xeda3q8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xeda3q8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F00C4CEED;
	Thu,  3 Jul 2025 15:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556074;
	bh=4D1vBgMPwJXz+GeegKdtzuOvgQvBwVA4xRGlZaTtqxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xeda3q8tvmIr4VmjInD1cpGsoxYs7Mg9l1glXieXCiUX4GxEScM15yJNZI2SoI3Ra
	 hXkyaC7RGkwd/K/Vzw2jVIqnYd3QgoVZblo8a9eqoUiYgOajVV5gjQ0GU/++5w9PZY
	 UFeluZmIlCJE05sA5F68bJsg4qmmzIHEl9RR3dnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chance Yang <chance.yang@kneron.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/132] usb: common: usb-conn-gpio: use a unique name for usb connector device
Date: Thu,  3 Jul 2025 16:41:55 +0200
Message-ID: <20250703143940.426640498@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

From: Chance Yang <chance.yang@kneron.us>

[ Upstream commit d4e5b10c55627e2f3fc9e5b337a28b4e2f02a55e ]

The current implementation of the usb-conn-gpio driver uses a fixed
"usb-charger" name for all USB connector devices. This causes conflicts
in the power supply subsystem when multiple USB connectors are present,
as duplicate names are not allowed.

Use IDA to manage unique IDs for naming usb connectors (e.g.,
usb-charger-0, usb-charger-1).

Signed-off-by: Chance Yang <chance.yang@kneron.us>
Link: https://lore.kernel.org/r/20250411-work-next-v3-1-7cd9aa80190c@kneron.us
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/common/usb-conn-gpio.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/common/usb-conn-gpio.c b/drivers/usb/common/usb-conn-gpio.c
index 3f5180d64931b..91461c744fcdd 100644
--- a/drivers/usb/common/usb-conn-gpio.c
+++ b/drivers/usb/common/usb-conn-gpio.c
@@ -20,6 +20,9 @@
 #include <linux/power_supply.h>
 #include <linux/regulator/consumer.h>
 #include <linux/usb/role.h>
+#include <linux/idr.h>
+
+static DEFINE_IDA(usb_conn_ida);
 
 #define USB_GPIO_DEB_MS		20	/* ms */
 #define USB_GPIO_DEB_US		((USB_GPIO_DEB_MS) * 1000)	/* us */
@@ -29,6 +32,7 @@
 
 struct usb_conn_info {
 	struct device *dev;
+	int conn_id; /* store the IDA-allocated ID */
 	struct usb_role_switch *role_sw;
 	enum usb_role last_role;
 	struct regulator *vbus;
@@ -160,7 +164,17 @@ static int usb_conn_psy_register(struct usb_conn_info *info)
 		.of_node = dev->of_node,
 	};
 
-	desc->name = "usb-charger";
+	info->conn_id = ida_alloc(&usb_conn_ida, GFP_KERNEL);
+	if (info->conn_id < 0)
+		return info->conn_id;
+
+	desc->name = devm_kasprintf(dev, GFP_KERNEL, "usb-charger-%d",
+				    info->conn_id);
+	if (!desc->name) {
+		ida_free(&usb_conn_ida, info->conn_id);
+		return -ENOMEM;
+	}
+
 	desc->properties = usb_charger_properties;
 	desc->num_properties = ARRAY_SIZE(usb_charger_properties);
 	desc->get_property = usb_charger_get_property;
@@ -168,8 +182,10 @@ static int usb_conn_psy_register(struct usb_conn_info *info)
 	cfg.drv_data = info;
 
 	info->charger = devm_power_supply_register(dev, desc, &cfg);
-	if (IS_ERR(info->charger))
-		dev_err(dev, "Unable to register charger\n");
+	if (IS_ERR(info->charger)) {
+		dev_err(dev, "Unable to register charger %d\n", info->conn_id);
+		ida_free(&usb_conn_ida, info->conn_id);
+	}
 
 	return PTR_ERR_OR_ZERO(info->charger);
 }
@@ -277,6 +293,9 @@ static int usb_conn_remove(struct platform_device *pdev)
 
 	cancel_delayed_work_sync(&info->dw_det);
 
+	if (info->charger)
+		ida_free(&usb_conn_ida, info->conn_id);
+
 	if (info->last_role == USB_ROLE_HOST && info->vbus)
 		regulator_disable(info->vbus);
 
-- 
2.39.5



