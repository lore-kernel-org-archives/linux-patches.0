Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990452D29D9;
	Tue, 15 Jul 2025 13:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587439; cv=none; b=uVNyQHVX+Z5QN9Gt0WSvzMwGiIl/ddcNtxTCRQ0LvOeIchbgZieTkYVKPRp2TgfilzbiikxVz7btWGJOs5eUjQMDur4WtxF4nIxUJQK3bF3S1X3m27WByFx81QcrXp31WxscrjYPWKDAKOfc3vtwKsVtW2sXCBsV/jMnJxIPMVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587439; c=relaxed/simple;
	bh=Lsunqhp5nqPHU9SnSTdKnliCVIMoLSHn4wRj4Fkc67E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VplpJHiBt3SHsNDctJFpD1TOkcduv8B/rGLGCCGt4BRPM7+sfSAHJGoGaZDG3MECzw8TNBkSNuOJz+o/dDF2ZI8fIyNTQQ0loXUDOGORpNzhpr4zrhk06sxgEQ5vrHkQAYuF48uo1qoBcHy/H4UvnjAGzl7Etz8JPqD7lTNB0Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3Kfi9X8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3Kfi9X8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29653C4CEE3;
	Tue, 15 Jul 2025 13:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587439;
	bh=Lsunqhp5nqPHU9SnSTdKnliCVIMoLSHn4wRj4Fkc67E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3Kfi9X87OabAoD6KgbK/8hl3C8u3idrNetYBWHb0V5BB3P3NGYsh+40hEIbd7Zf8
	 rbq1pjx+xJZKFpe7xh4prHl+Wx95VTRS/yeRYyb63ScuvVSVLKk4v5kvs43qF6trv1
	 GS2xHyCSVJwJdJNT0Xv8/B6KKqKkbyU4t5uwiH0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chance Yang <chance.yang@kneron.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/208] usb: common: usb-conn-gpio: use a unique name for usb connector device
Date: Tue, 15 Jul 2025 15:12:02 +0200
Message-ID: <20250715130811.367039232@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 02446092520c8..f5a1981c9eb40 100644
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
@@ -296,6 +312,9 @@ static int usb_conn_remove(struct platform_device *pdev)
 
 	cancel_delayed_work_sync(&info->dw_det);
 
+	if (info->charger)
+		ida_free(&usb_conn_ida, info->conn_id);
+
 	if (info->last_role == USB_ROLE_HOST && info->vbus)
 		regulator_disable(info->vbus);
 
-- 
2.39.5



