Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A5542902A;
	Fri,  7 Aug 2026 15:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117459; cv=none; b=YKVv/QWUdblEZiijSmnaIxn+62XcfTIiTY5m9TqY2ipWX4ZvhhT3C2lNYOwOEb+ulxvl6MjEWCl5pepGvEbdDJeB2qvbE1ZiOriD8LQI6GAHi0mNsKayLGnHVCwbN3huPCKSHRBjKDLfrBkHfMXsct0Z6NyDBvKVlEkewno2RYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117459; c=relaxed/simple;
	bh=50Sghhq9EMIH/oww6TEZKxXxx8VhO4pMS9YZ9+gOicg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhPBgU3bZ5F/eMdLo90TiRPi4JIcjYvc74HOU54uc/7NrJYpSEN5bFEbwrrMfPvXmVi1k8k8EFDE5k/MM2SogOrt5NGQ+F5PGjMkFcpuY7eyVCFfymN7H4i+p4F3BeVkmSRe25cz0Y477chEjBzlWvSTwLq21PKTYAchGwjy4Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgEiM6QM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgEiM6QM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B901F000E9;
	Fri,  7 Aug 2026 15:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117457;
	bh=M7ae1pcQzADXCahpkAyQTNFiIuPVJ327DEY5lJfkSiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgEiM6QMw3xEZym2O4OFYr0XpKcRMUeTA/2fLwfitfZgeOdjBPv+SaXWILEtNSLVZ
	 6Y0GmYzrBDCPK1e60PdETCwKzBPkwLE7r9JzjVNBoW+7RD3Gn+uJ2AfocEEVYhUEoG
	 EqgSQdTISk3eE2npcGdTBdsqXm985L3gZAQF15wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Hardik Prakash <hardikprakash.official@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.1 326/438] i2c: designware: defer probe if child GpioInt controllers are not bound
Date: Fri,  7 Aug 2026 16:38:42 +0200
Message-ID: <20260807143434.924930262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hardik Prakash <hardikprakash.official@gmail.com>

commit 0a4bb2abc3e56d7be6e69b050c88ba52c87e22bf upstream.

I2C controllers may have child devices with GpioInt resources that
depend on GPIO controllers being fully initialized. If the I2C
controller probes and enumerates children before the referenced GPIO
controller has completed probe, GPIO interrupts may not be properly
configured, leading to device failures.

On Lenovo Yoga 7 14AGP11, the WACF2200 touchscreen (child of
AMDI0010:02) has a GpioInt resource pointing to GPIO 157 on the
pinctrl-amd controller (AMDI0030:00). When i2c-designware probes
AMDI0010:02 before pinctrl-amd finishes initializing, I2C transactions
fail with lost arbitration errors:

  0.285952  amd_gpio_probe: registering gpiochip  <- GPIO chip visible
  0.287121  amd_gpio_probe: requesting parent IRQ <- probe still running
  0.301454  AMDI0010:02 dw_i2c_plat_probe: start  <- races here
  2.348157  lost arbitration

Add a dependency check that walks ACPI child devices and defers probe
until any referenced GPIO controller is bound.

Fixes: 3812a9e84265 ("pinctrl-amd: enable IRQ for WACF2200 touchscreen on Lenovo Yoga 7 14AGP11")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221494
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Hardik Prakash <hardikprakash.official@gmail.com>
Assisted-by: Claude:claude-sonnet-5
Assisted-by: DeepSeek:deepseek-v4-pro
Cc: <stable@vger.kernel.org> # v7.1+
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260718054330.8975-2-hardikprakash.official@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-platdrv.c |   80 ++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -8,12 +8,14 @@
  * Copyright (C) 2007 MontaVista Software Inc.
  * Copyright (C) 2009 Provigent Ltd.
  */
+#include <linux/acpi.h>
 #include <linux/clk-provider.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/dmi.h>
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/gpio/driver.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -130,6 +132,80 @@ static int i2c_dw_probe_lock_support(str
 	return 0;
 }
 
+#if defined(CONFIG_ACPI) && defined(CONFIG_GPIOLIB)
+/*
+ * Check whether an ACPI GpioInt resource's referenced GPIO controller
+ * has finished probing. Resources with no named controller (resource
+ * source string) are skipped, since they can't be resolved to a
+ * struct device.
+ */
+static int check_gpioint_resource(struct acpi_resource *ares, void *data)
+{
+	struct acpi_resource_gpio *agpio;
+	struct acpi_device *gpio_adev;
+	struct device *gpio_dev;
+	acpi_handle handle;
+	acpi_status status;
+
+	if (!acpi_gpio_get_irq_resource(ares, &agpio))
+		return 1; /* not a GpioInt resource, skip */
+
+	if (!agpio->resource_source.string_length)
+		return 1; /* no named controller, skip */
+
+	status = acpi_get_handle(NULL, agpio->resource_source.string_ptr, &handle);
+	if (ACPI_FAILURE(status))
+		return 1;
+
+	gpio_adev = acpi_fetch_acpi_dev(handle);
+	if (!gpio_adev)
+		return 1;
+
+	struct gpio_device *gdev __free(gpio_device_put) =
+		gpio_device_find_by_fwnode(acpi_fwnode_handle(gpio_adev));
+	if (!gdev)
+		return -EPROBE_DEFER; /* controller not registered yet: abort walk */
+
+	gpio_dev = gpio_device_to_device(gdev)->parent;
+
+	guard(device)(gpio_dev);
+	if (!device_is_bound(gpio_dev))
+		return -EPROBE_DEFER; /* controller not bound yet: abort walk */
+
+	return 1; /* bound, skip adding to resource list, continue walk */
+}
+
+static int check_child_gpioint(struct acpi_device *adev, void *data)
+{
+	LIST_HEAD(res_list);
+	int ret;
+
+	ret = acpi_dev_get_resources(adev, &res_list, check_gpioint_resource, NULL);
+	if (ret < 0)
+		return ret;
+
+	acpi_dev_free_resource_list(&res_list);
+
+	return 0;
+}
+
+static int i2c_dw_check_gpio_dependencies(struct device *dev)
+{
+	struct acpi_device *adev;
+
+	adev = ACPI_COMPANION(dev);
+	if (!adev)
+		return 0;
+
+	return acpi_dev_for_each_child(adev, check_child_gpioint, NULL);
+}
+#else
+static int i2c_dw_check_gpio_dependencies(struct device *dev)
+{
+	return 0;
+}
+#endif /* CONFIG_ACPI && CONFIG_GPIOLIB */
+
 static int dw_i2c_plat_probe(struct platform_device *pdev)
 {
 	u32 flags = (uintptr_t)device_get_match_data(&pdev->dev);
@@ -138,6 +214,10 @@ static int dw_i2c_plat_probe(struct plat
 	struct dw_i2c_dev *dev;
 	int irq, ret;
 
+	ret = i2c_dw_check_gpio_dependencies(device);
+	if (ret)
+		return ret;
+
 	irq = platform_get_irq_optional(pdev, 0);
 	if (irq == -ENXIO)
 		flags |= ACCESS_POLLING;


