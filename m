Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88293EF0A2;
	Tue, 31 Mar 2026 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974248; cv=none; b=DXyv25mhA78ZP5pIPtcS+2kPLXPMhywp5xgkbBGUgmDeue4UtTjunWwqFa6nI7oPt3ZvIREmHZdi5m0iYo3NeQO5+1ycWfUsOefQUfDu8DSBCX84ml3jpNAoCBVlI4ZjYPWgYUlWjQBgsS0I7TeCmz7woBB1JOKPiW54vRSCEAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974248; c=relaxed/simple;
	bh=Hzm8tQI0cq2XgXEL/I2wH+yuWyPm+ABcLJMvQFC7iUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4MgolD2hxKHNwPiCXWDrNPEoINXJH367yCMnzN96nmhLTtLZPqNKoAfrJQw4W3H7UVmPIjo+Fa1cBG8vCIcDHalPlkIVCYYQjTvKIT4LjEzCSl7Us/kP04BAQ6GtgBtnQ/Mw1hVwHX70K+Pw8Trj4HD5VEUGZe8YivpijjlJXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqw3t3lf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqw3t3lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F3BC19423;
	Tue, 31 Mar 2026 16:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974247;
	bh=Hzm8tQI0cq2XgXEL/I2wH+yuWyPm+ABcLJMvQFC7iUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqw3t3lfT9GWQ6ffmTQXqQhzylWKwPpjwrii1l26Wj/Uj46arxRAJhJd0Jnd3CpWN
	 E2lwafebUJGwtLYZoG5ccfWFUx3lUF1U90yH06t2K6WqDCMH0Ne1NzR+VihzF0L6kD
	 j7Q3eKm8BNn4v/zz0S45Rf084rejwczACJFZINKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/175] hwmon: (axi-fan-control) Use device firmware agnostic API
Date: Tue, 31 Mar 2026 18:19:48 +0200
Message-ID: <20260331161729.946360395@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 1b5239f70fcd2d7fe86f0f5473006c2896db07a8 ]

Don't directly use OF and use device property APIs. In addition, this
makes the probe() code neater and also allow us to move the
of_device_id table to it's natural place.

While at it, make sure to explicitly include mod_devicetable.h for the
of_device_id table.

Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240214-axi-fan-control-no-of-v1-1-43ca656fe2e3@analog.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 813bbc4d33d2 ("hwmon: axi-fan: don't use driver_override as IRQ name")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/axi-fan-control.c | 39 +++++++++++++++++----------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/hwmon/axi-fan-control.c b/drivers/hwmon/axi-fan-control.c
index 19b9bf3d75ef9..8dfe3b6c5a177 100644
--- a/drivers/hwmon/axi-fan-control.c
+++ b/drivers/hwmon/axi-fan-control.c
@@ -13,8 +13,9 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/of.h>
+#include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
+#include <linux/property.h>
 
 /* register map */
 #define ADI_REG_RSTN		0x0080
@@ -368,12 +369,12 @@ static irqreturn_t axi_fan_control_irq_handler(int irq, void *data)
 }
 
 static int axi_fan_control_init(struct axi_fan_control_data *ctl,
-				const struct device_node *np)
+				const struct device *dev)
 {
 	int ret;
 
 	/* get fan pulses per revolution */
-	ret = of_property_read_u32(np, "pulses-per-revolution", &ctl->ppr);
+	ret = device_property_read_u32(dev, "pulses-per-revolution", &ctl->ppr);
 	if (ret)
 		return ret;
 
@@ -443,25 +444,16 @@ static struct attribute *axi_fan_control_attrs[] = {
 };
 ATTRIBUTE_GROUPS(axi_fan_control);
 
-static const u32 version_1_0_0 = ADI_AXI_PCORE_VER(1, 0, 'a');
-
-static const struct of_device_id axi_fan_control_of_match[] = {
-	{ .compatible = "adi,axi-fan-control-1.00.a",
-		.data = (void *)&version_1_0_0},
-	{},
-};
-MODULE_DEVICE_TABLE(of, axi_fan_control_of_match);
-
 static int axi_fan_control_probe(struct platform_device *pdev)
 {
 	struct axi_fan_control_data *ctl;
 	struct clk *clk;
-	const struct of_device_id *id;
+	const unsigned int *id;
 	const char *name = "axi_fan_control";
 	u32 version;
 	int ret;
 
-	id = of_match_node(axi_fan_control_of_match, pdev->dev.of_node);
+	id = device_get_match_data(&pdev->dev);
 	if (!id)
 		return -EINVAL;
 
@@ -485,18 +477,18 @@ static int axi_fan_control_probe(struct platform_device *pdev)
 
 	version = axi_ioread(ADI_AXI_REG_VERSION, ctl);
 	if (ADI_AXI_PCORE_VER_MAJOR(version) !=
-	    ADI_AXI_PCORE_VER_MAJOR((*(u32 *)id->data))) {
+	    ADI_AXI_PCORE_VER_MAJOR((*id))) {
 		dev_err(&pdev->dev, "Major version mismatch. Expected %d.%.2d.%c, Reported %d.%.2d.%c\n",
-			ADI_AXI_PCORE_VER_MAJOR((*(u32 *)id->data)),
-			ADI_AXI_PCORE_VER_MINOR((*(u32 *)id->data)),
-			ADI_AXI_PCORE_VER_PATCH((*(u32 *)id->data)),
+			ADI_AXI_PCORE_VER_MAJOR(*id),
+			ADI_AXI_PCORE_VER_MINOR(*id),
+			ADI_AXI_PCORE_VER_PATCH(*id),
 			ADI_AXI_PCORE_VER_MAJOR(version),
 			ADI_AXI_PCORE_VER_MINOR(version),
 			ADI_AXI_PCORE_VER_PATCH(version));
 		return -ENODEV;
 	}
 
-	ret = axi_fan_control_init(ctl, pdev->dev.of_node);
+	ret = axi_fan_control_init(ctl, &pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize device\n");
 		return ret;
@@ -527,6 +519,15 @@ static int axi_fan_control_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static const u32 version_1_0_0 = ADI_AXI_PCORE_VER(1, 0, 'a');
+
+static const struct of_device_id axi_fan_control_of_match[] = {
+	{ .compatible = "adi,axi-fan-control-1.00.a",
+		.data = (void *)&version_1_0_0},
+	{},
+};
+MODULE_DEVICE_TABLE(of, axi_fan_control_of_match);
+
 static struct platform_driver axi_fan_control_driver = {
 	.driver = {
 		.name = "axi_fan_control_driver",
-- 
2.51.0



