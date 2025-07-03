Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FAB2EF9B8;
	Thu,  3 Jul 2025 15:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555596; cv=none; b=SdPTEnMlo9bldOVWWv9i/+r87g0yfYfzinGJr9jH+P4mQJrlYTr9/AV4zfi1uxiJfoGAj0DJSKbDof09h404F20nHwzq8sdtqiKFu7r2Rnj7/xXodPWzQ5aMNKJrorG/Zo6yn/62ZqRguhmyInzA7rNtp09hikji8KC9gFFjn6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555596; c=relaxed/simple;
	bh=E23ymLqNLKC3wYRDL0FEnNnPGrOyKWQOYWp/4+WS740=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEhf10/KdfURjjw9HWZ1+ipuj8Z5lz/pXnMrJwZ78VbJWT/F5bioY91PU8QEastHarul4Lpk0vm5T3QzTH4aI2MFEk6biwmIcBWCKbmREn9te6Ey7U0Bj7aVmMmQf4FQ/qw27/cNtAXkhEi7LwDNVK7EjCATLR30sD73BjTxBXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbydlVEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbydlVEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53237C4CEEE;
	Thu,  3 Jul 2025 15:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555594;
	bh=E23ymLqNLKC3wYRDL0FEnNnPGrOyKWQOYWp/4+WS740=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbydlVEXjbdND0VDPkKdr+BBDLIHejoMWL2uFKgc9KD9xxMsqI/CZBfKLO74G04cB
	 4oASejTT29pesTZq2F7AhU/kPNJf1u8d0RhClERNlaG/PEOx1BbgwcNP6kpWykW5Wd
	 7imBN9LIyWYt/h1AGphG0aiY4Cyl6yEu2ip1i+zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chance Yang <chance.yang@kneron.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/139] usb: common: usb-conn-gpio: use a unique name for usb connector device
Date: Thu,  3 Jul 2025 16:41:38 +0200
Message-ID: <20250703143942.555707928@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 501e8bc9738eb..1096a884c8d70 100644
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
@@ -277,6 +293,9 @@ static void usb_conn_remove(struct platform_device *pdev)
 
 	cancel_delayed_work_sync(&info->dw_det);
 
+	if (info->charger)
+		ida_free(&usb_conn_ida, info->conn_id);
+
 	if (info->last_role == USB_ROLE_HOST && info->vbus)
 		regulator_disable(info->vbus);
 
-- 
2.39.5



