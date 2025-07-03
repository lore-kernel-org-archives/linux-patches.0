Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45F22EE98F;
	Thu,  3 Jul 2025 14:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554780; cv=none; b=mlhhcgwOqO+l663d/XIN1GuIGalQyUmGO1jf55JQI4xo8c3uJ84DroBu6uB2lRFhkv1WGzg7PHAVJLrnHTCYdXDsAyAfYSV2AFNDa5dLM2ILFEJkzjZIL05Tt+jdQWKO41rmc9FwcMtokm7OBl7NswwqbFsgF4QeASxSGf2U0ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554780; c=relaxed/simple;
	bh=PqWRC6VjcwAE9q9eOnjVXe0AKzgFevOFj2nxhDNs9ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkFl4GHxlPrPLcHR+UE5I19SPjfGNWTirPDF/hzBilDuDFjjYP/E2VX+8cOHLC+oC3MJs6ZCmjcjzA4txVuhL5mGvN3oAqgPYs43QwsdDy5b7/AtuXEHqnl0qt5Y6C342soHnCu9A/j8LqnwJw98ZJzSHub6tEXPiN1O7EGqxUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NBT8+Sp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NBT8+Sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC92C4CEED;
	Thu,  3 Jul 2025 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554780;
	bh=PqWRC6VjcwAE9q9eOnjVXe0AKzgFevOFj2nxhDNs9ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NBT8+SpO84hAOtibohtDabZ/5ELEo1RbG4i0Vod3tf9K0wINHK9cjwyZt/kXs61K
	 yk+/i+jUnWZ4+zYT4lSyQFd+/8FjW8U5ExnCx8VyhWdRghVYQiccc4T6fdRaIHiWm1
	 UlP5gIM6VIiivD1DwMOBpx8KE6VBUqj1l+9WL3AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chance Yang <chance.yang@kneron.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 059/263] usb: common: usb-conn-gpio: use a unique name for usb connector device
Date: Thu,  3 Jul 2025 16:39:39 +0200
Message-ID: <20250703144006.674213886@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1e36be2a28fd5..421c3af38e069 100644
--- a/drivers/usb/common/usb-conn-gpio.c
+++ b/drivers/usb/common/usb-conn-gpio.c
@@ -21,6 +21,9 @@
 #include <linux/regulator/consumer.h>
 #include <linux/string_choices.h>
 #include <linux/usb/role.h>
+#include <linux/idr.h>
+
+static DEFINE_IDA(usb_conn_ida);
 
 #define USB_GPIO_DEB_MS		20	/* ms */
 #define USB_GPIO_DEB_US		((USB_GPIO_DEB_MS) * 1000)	/* us */
@@ -30,6 +33,7 @@
 
 struct usb_conn_info {
 	struct device *dev;
+	int conn_id; /* store the IDA-allocated ID */
 	struct usb_role_switch *role_sw;
 	enum usb_role last_role;
 	struct regulator *vbus;
@@ -161,7 +165,17 @@ static int usb_conn_psy_register(struct usb_conn_info *info)
 		.fwnode = dev_fwnode(dev),
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
@@ -169,8 +183,10 @@ static int usb_conn_psy_register(struct usb_conn_info *info)
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
@@ -278,6 +294,9 @@ static void usb_conn_remove(struct platform_device *pdev)
 
 	cancel_delayed_work_sync(&info->dw_det);
 
+	if (info->charger)
+		ida_free(&usb_conn_ida, info->conn_id);
+
 	if (info->last_role == USB_ROLE_HOST && info->vbus)
 		regulator_disable(info->vbus);
 
-- 
2.39.5



