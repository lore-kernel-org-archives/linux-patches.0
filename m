Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8734FDE61;
	Tue, 13 Oct 2026 12:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893472; cv=none; b=SCpln8q5DmH1kJbqSz2zSdkL4kSIs+xONiw+thMxnDSosUJLflT4OiPXC/E5gYB0xJMHKQCj/ShJb+DjttWCBIY42W8mfFxamPsxe66/STRGs+8okj+ffydmVTpZyBbjSQdyZtv0ottQ8Y5OzPbViaisnIhH/7aG8JNQJofRbuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893472; c=relaxed/simple;
	bh=JEP5IarB7v3JhBX0qX2GELDNtRVbfB0ZOyboUhgLiUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmWQr2SfPyAQzC4c7KRck6I3I1VNm8sSZx4CrRARkLnkh+1ZotaibHv8MBJVojYMxrKghOWqQVhl+C9M7bUzegTTJk5zS7Nlme6dWivUldotDXkgoXJL8P+iekWZgSthL9WrHrroGZb248NVVmvJO+gDLTWsOgPvCXTkUuRhHfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxZsELUG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxZsELUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F154E1F000FF;
	Tue, 13 Oct 2026 12:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893471;
	bh=tDHyudhY1DghI/euHFquzwrgakxIKZCR2m5hyANdL5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxZsELUGPZzTrREtGaa7jWHXqrlkK2AkyIbPdilUPnkMatYHPIFHY7wEdfmwerptI
	 L3oWkwUySE8WN72GFUoYVah9+8cI4fZrRnkZg38Feh5pMpMdo2SP+rvI01hMiaR5jr
	 MtFkNfUiAUBtcvau3umsjXDue5FuUmdIQJd/L09c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 236/621] ACPI: button: Convert the driver to a platform one
Date: Tue, 13 Oct 2026 13:33:51 +0200
Message-ID: <20261013112926.458495014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 52d86401963666423cb9a56d117136c846093db0 ]

While binding drivers directly to struct acpi_device objects allows
basic functionality to be provided, at least in the majority of cases,
there are some problems with it, related to general consistency, sysfs
layout, power management operation ordering, and code cleanliness.

Overall, it is better to bind drivers to platform devices than to their
ACPI companions, so convert the ACPI button driver to a platform one.

While this is not expected to alter functionality, it changes sysfs
layout and so it will be visible to user space.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2461734.NG923GbCHz@rafael.j.wysocki
Stable-dep-of: fe80251152fe ("ACPI: button: Fix ACPI GPE handler leak during removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 61 +++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 09a6e4ffe9f20..b899b8745fedd 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/dmi.h>
+#include <linux/platform_device.h>
 #include <acpi/button.h>
 
 #define ACPI_BUTTON_CLASS		"button"
@@ -145,8 +146,8 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
 	{}
 };
 
-static int acpi_button_add(struct acpi_device *device);
-static void acpi_button_remove(struct acpi_device *device);
+static int acpi_button_probe(struct platform_device *pdev);
+static void acpi_button_remove(struct platform_device *pdev);
 
 #ifdef CONFIG_PM_SLEEP
 static int acpi_button_suspend(struct device *dev);
@@ -157,19 +158,19 @@ static int acpi_button_resume(struct device *dev);
 #endif
 static SIMPLE_DEV_PM_OPS(acpi_button_pm, acpi_button_suspend, acpi_button_resume);
 
-static struct acpi_driver acpi_button_driver = {
-	.name = "button",
-	.class = ACPI_BUTTON_CLASS,
-	.ids = button_device_ids,
-	.ops = {
-		.add = acpi_button_add,
-		.remove = acpi_button_remove,
+static struct platform_driver acpi_button_driver = {
+	.probe = acpi_button_probe,
+	.remove = acpi_button_remove,
+	.driver = {
+		.name = "acpi-button",
+		.acpi_match_table = button_device_ids,
+		.pm = &acpi_button_pm,
 	},
-	.drv.pm = &acpi_button_pm,
 };
 
 struct acpi_button {
 	struct acpi_device *adev;
+	struct platform_device *pdev;
 	unsigned int type;
 	struct input_dev *input;
 	char phys[32];			/* for input device */
@@ -397,7 +398,7 @@ static int acpi_lid_update_state(struct acpi_button *button,
 		return state;
 
 	if (state && signal_wakeup)
-		acpi_pm_wakeup_event(&device->dev);
+		acpi_pm_wakeup_event(&button->pdev->dev);
 
 	return acpi_lid_notify_state(button, state);
 }
@@ -454,7 +455,7 @@ static void acpi_button_notify(acpi_handle handle, u32 event, void *data)
 		return;
 	}
 
-	acpi_pm_wakeup_event(&device->dev);
+	acpi_pm_wakeup_event(&button->pdev->dev);
 
 	if (button->suspended || event == ACPI_BUTTON_NOTIFY_WAKE)
 		return;
@@ -486,8 +487,7 @@ static u32 acpi_button_event(void *data)
 #ifdef CONFIG_PM_SLEEP
 static int acpi_button_suspend(struct device *dev)
 {
-	struct acpi_device *device = to_acpi_device(dev);
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_button *button = dev_get_drvdata(dev);
 
 	button->suspended = true;
 	return 0;
@@ -495,9 +495,9 @@ static int acpi_button_suspend(struct device *dev)
 
 static int acpi_button_resume(struct device *dev)
 {
+	struct acpi_button *button = dev_get_drvdata(dev);
+	struct acpi_device *device = ACPI_COMPANION(dev);
 	struct input_dev *input;
-	struct acpi_device *device = to_acpi_device(dev);
-	struct acpi_button *button = acpi_driver_data(device);
 
 	button->suspended = false;
 	if (button->type == ACPI_BUTTON_TYPE_LID) {
@@ -529,8 +529,9 @@ static int acpi_lid_input_open(struct input_dev *input)
 	return 0;
 }
 
-static int acpi_button_add(struct acpi_device *device)
+static int acpi_button_probe(struct platform_device *pdev)
 {
+	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
 	acpi_notify_handler handler;
 	struct acpi_button *button;
 	struct input_dev *input;
@@ -547,8 +548,9 @@ static int acpi_button_add(struct acpi_device *device)
 	if (!button)
 		return -ENOMEM;
 
-	device->driver_data = button;
+	platform_set_drvdata(pdev, button);
 
+	button->pdev = pdev;
 	button->adev = device;
 	button->input = input = input_allocate_device();
 	if (!input) {
@@ -599,7 +601,7 @@ static int acpi_button_add(struct acpi_device *device)
 	input->phys = button->phys;
 	input->id.bustype = BUS_HOST;
 	input->id.product = button->type;
-	input->dev.parent = &device->dev;
+	input->dev.parent = &pdev->dev;
 
 	switch (button->type) {
 	case ACPI_BUTTON_TYPE_POWER:
@@ -653,7 +655,7 @@ static int acpi_button_add(struct acpi_device *device)
 		lid_device = device;
 	}
 
-	device_init_wakeup(&device->dev, true);
+	device_init_wakeup(&pdev->dev, true);
 	pr_info("%s [%s]\n", name, acpi_device_bid(device));
 	return 0;
 
@@ -666,9 +668,10 @@ static int acpi_button_add(struct acpi_device *device)
 	return error;
 }
 
-static void acpi_button_remove(struct acpi_device *device)
+static void acpi_button_remove(struct platform_device *pdev)
 {
-	struct acpi_button *button = acpi_driver_data(device);
+	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
+	struct acpi_button *button = platform_get_drvdata(pdev);
 
 	switch (device->device_type) {
 	case ACPI_BUS_TYPE_POWER_BUTTON:
@@ -727,7 +730,7 @@ module_param_call(lid_init_state,
 		  NULL, 0644);
 MODULE_PARM_DESC(lid_init_state, "Behavior for reporting LID initial state");
 
-static int acpi_button_register_driver(struct acpi_driver *driver)
+static int __init acpi_button_init(void)
 {
 	const struct dmi_system_id *dmi_id;
 
@@ -743,20 +746,20 @@ static int acpi_button_register_driver(struct acpi_driver *driver)
 	 * Modules such as nouveau.ko and i915.ko have a link time dependency
 	 * on acpi_lid_open(), and would therefore not be loadable on ACPI
 	 * capable kernels booted in non-ACPI mode if the return value of
-	 * acpi_bus_register_driver() is returned from here with ACPI disabled
+	 * platform_driver_register() is returned from here with ACPI disabled
 	 * when this driver is built as a module.
 	 */
 	if (acpi_disabled)
 		return 0;
 
-	return acpi_bus_register_driver(driver);
+	return platform_driver_register(&acpi_button_driver);
 }
 
-static void acpi_button_unregister_driver(struct acpi_driver *driver)
+static void __exit acpi_button_exit(void)
 {
 	if (!acpi_disabled)
-		acpi_bus_unregister_driver(driver);
+		platform_driver_unregister(&acpi_button_driver);
 }
 
-module_driver(acpi_button_driver, acpi_button_register_driver,
-	       acpi_button_unregister_driver);
+module_init(acpi_button_init);
+module_exit(acpi_button_exit);
-- 
2.53.0



