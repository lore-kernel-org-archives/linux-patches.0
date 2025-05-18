Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3041F582E;
	Sun, 18 May 2025 03:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747538614; cv=none; b=VN5k3JkhCAhS6rn04IsLSTAzukqIGB098OdDetJrg3AVKt/ZKTzV9hQxKttMWnhOlHLjKOYDQfN5IAQsTpTlsqcsicHKJ4oUONv/DFl451f/5j/VbtEMMWrXIegsoQXm7/u4zVGB+hyO3YkGXzUQtB1nHOCq6RnoH5AptZyJdkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747538614; c=relaxed/simple;
	bh=tj7uSVwGEOpy7dfTuVDJ2qD9kI8t7PDcIeYZrYRntVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4PiqrUa9F4y4HehNvkGjt37OcMVSWUOkOIDwz67E/+Ek5wE9n3+1ikXNCsxlPjlA0KcHrlsso3Dj7xlawchC6Yu92Hts1lHLLQIL6Y9Ms3mh/rGPUoOGb8YcpH3fMiUyQI9JPDp4kknWPpXIBwS0JBfpuxdsF3rIbCjbKdONA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XIK4muPP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XIK4muPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AF8C4CEE7;
	Sun, 18 May 2025 03:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747538613;
	bh=tj7uSVwGEOpy7dfTuVDJ2qD9kI8t7PDcIeYZrYRntVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIK4muPPrSTcy5GjAdI576MMw04r3AteLyfMB3QL4dM+s2vzOrz0prR1WE1GdDLBN
	 sWoii3Oq5TXspdB49RZdxVQz959az/nlvA8lSbfweh0H5wqm53YNEutnJIplTQ67Gd
	 qtM25dbuXcT43MayJIApJZMTEulbFpA4JYsNBeHkGSOznpzs8UoyOQRjTlDNiUefZa
	 qg4xOWfzBoTWXOZ88cT9r0mGnWcsYsSgsI4cnvng8C1j5MEE4j5N/7mSr7a8+8msuh
	 +Ydhx/izD3m9oDr1etXXUas6M5cS16Alxllen/F6dbhuzg34gpuMAwPlvqEy887j3g
	 T6ZspY/3Y3scg==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jean-Francois Bortolotti <jeff@borto.fr>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Sven Peter <sven@svenpeter.dev>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sasha Finkelstein <fnkl.kernel@gmail.com>,
	Neal Gompa <neal@gompa.dev>
Subject: [PATCH 3/4] spmi: add a spmi driver for Apple SoC
Date: Sat, 17 May 2025 20:23:28 -0700
Message-ID: <20250518032330.2959766-4-sboyd@kernel.org>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
In-Reply-To: <20250518032330.2959766-1-sboyd@kernel.org>
References: <20250518032330.2959766-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Francois Bortolotti <jeff@borto.fr>

The connected PMU contains several useful nvmem cells such as RTC offset,
boot failure counters, reboot/shutdown selector, and a few others.
In addition M3+ machines have their USB-PD controller connected via SPMI.

Signed-off-by: Jean-Francois Bortolotti <jeff@borto.fr>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Co-developed-by: Sasha Finkelstein <fnkl.kernel@gmail.com>
Signed-off-by: Sasha Finkelstein <fnkl.kernel@gmail.com>
Link: https://lore.kernel.org/r/20250409-spmi-v4-2-eb81ecfd1f64@gmail.com
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 MAINTAINERS                          |   1 +
 drivers/spmi/Kconfig                 |   8 ++
 drivers/spmi/Makefile                |   1 +
 drivers/spmi/spmi-apple-controller.c | 168 +++++++++++++++++++++++++++
 4 files changed, 178 insertions(+)
 create mode 100644 drivers/spmi/spmi-apple-controller.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 5f348736ea0b..2bf1c547bd0a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2302,6 +2302,7 @@ F:	drivers/pinctrl/pinctrl-apple-gpio.c
 F:	drivers/pwm/pwm-apple.c
 F:	drivers/soc/apple/*
 F:	drivers/spi/spi-apple.c
+F:	drivers/spmi/spmi-apple-controller.c
 F:	drivers/video/backlight/apple_dwi_bl.c
 F:	drivers/watchdog/apple_wdt.c
 F:	include/dt-bindings/interrupt-controller/apple-aic.h
diff --git a/drivers/spmi/Kconfig b/drivers/spmi/Kconfig
index 4ee496491c74..a80cf4047b86 100644
--- a/drivers/spmi/Kconfig
+++ b/drivers/spmi/Kconfig
@@ -11,6 +11,14 @@ menuconfig SPMI
 
 if SPMI
 
+config SPMI_APPLE
+	tristate "Apple SoC SPMI Controller platform driver"
+	depends on ARCH_APPLE || COMPILE_TEST
+	help
+	  If you say yes to this option, support will be included for the
+	  SPMI controller present on many Apple SoCs, including the
+	  t8103 (M1) and t600x (M1 Pro/Max).
+
 config SPMI_HISI3670
 	tristate "Hisilicon 3670 SPMI Controller"
 	select IRQ_DOMAIN_HIERARCHY
diff --git a/drivers/spmi/Makefile b/drivers/spmi/Makefile
index 7f152167bb05..38ac635645ba 100644
--- a/drivers/spmi/Makefile
+++ b/drivers/spmi/Makefile
@@ -4,6 +4,7 @@
 #
 obj-$(CONFIG_SPMI)	+= spmi.o spmi-devres.o
 
+obj-$(CONFIG_SPMI_APPLE)	+= spmi-apple-controller.o
 obj-$(CONFIG_SPMI_HISI3670)	+= hisi-spmi-controller.o
 obj-$(CONFIG_SPMI_MSM_PMIC_ARB)	+= spmi-pmic-arb.o
 obj-$(CONFIG_SPMI_MTK_PMIF)	+= spmi-mtk-pmif.o
diff --git a/drivers/spmi/spmi-apple-controller.c b/drivers/spmi/spmi-apple-controller.c
new file mode 100644
index 000000000000..697b3e8bb023
--- /dev/null
+++ b/drivers/spmi/spmi-apple-controller.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Apple SoC SPMI device driver
+ *
+ * Copyright The Asahi Linux Contributors
+ *
+ * Inspired by:
+ *		OpenBSD support Copyright (c) 2021 Mark Kettenis <kettenis@openbsd.org>
+ *		Correllium support Copyright (C) 2021 Corellium LLC
+ *		hisi-spmi-controller.c
+ *		spmi-pmic-arb.c Copyright (c) 2021, The Linux Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/platform_device.h>
+#include <linux/spmi.h>
+
+/* SPMI Controller Registers */
+#define SPMI_STATUS_REG 0
+#define SPMI_CMD_REG 0x4
+#define SPMI_RSP_REG 0x8
+
+#define SPMI_RX_FIFO_EMPTY BIT(24)
+
+#define REG_POLL_INTERVAL_US 10000
+#define REG_POLL_TIMEOUT_US (REG_POLL_INTERVAL_US * 5)
+
+struct apple_spmi {
+	void __iomem *regs;
+};
+
+#define poll_reg(spmi, reg, val, cond) \
+	readl_poll_timeout((spmi)->regs + (reg), (val), (cond), \
+			   REG_POLL_INTERVAL_US, REG_POLL_TIMEOUT_US)
+
+static inline u32 apple_spmi_pack_cmd(u8 opc, u8 sid, u16 saddr, size_t len)
+{
+	return opc | sid << 8 | saddr << 16 | (len - 1) | (1 << 15);
+}
+
+/* Wait for Rx FIFO to have something */
+static int apple_spmi_wait_rx_not_empty(struct spmi_controller *ctrl)
+{
+	struct apple_spmi *spmi = spmi_controller_get_drvdata(ctrl);
+	int ret;
+	u32 status;
+
+	ret = poll_reg(spmi, SPMI_STATUS_REG, status, !(status & SPMI_RX_FIFO_EMPTY));
+	if (ret) {
+		dev_err(&ctrl->dev,
+			"failed to wait for RX FIFO not empty\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int spmi_read_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
+			 u16 saddr, u8 *buf, size_t len)
+{
+	struct apple_spmi *spmi = spmi_controller_get_drvdata(ctrl);
+	u32 spmi_cmd = apple_spmi_pack_cmd(opc, sid, saddr, len);
+	u32 rsp;
+	size_t len_read = 0;
+	u8 i;
+	int ret;
+
+	writel(spmi_cmd, spmi->regs + SPMI_CMD_REG);
+
+	ret = apple_spmi_wait_rx_not_empty(ctrl);
+	if (ret)
+		return ret;
+
+	/* Discard SPMI reply status */
+	readl(spmi->regs + SPMI_RSP_REG);
+
+	/* Read SPMI data reply */
+	while (len_read < len) {
+		rsp = readl(spmi->regs + SPMI_RSP_REG);
+		i = 0;
+		while ((len_read < len) && (i < 4)) {
+			buf[len_read++] = ((0xff << (8 * i)) & rsp) >> (8 * i);
+			i += 1;
+		}
+	}
+
+	return 0;
+}
+
+static int spmi_write_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid,
+			  u16 saddr, const u8 *buf, size_t len)
+{
+	struct apple_spmi *spmi = spmi_controller_get_drvdata(ctrl);
+	u32 spmi_cmd = apple_spmi_pack_cmd(opc, sid, saddr, len);
+	size_t i = 0, j;
+	int ret;
+
+	writel(spmi_cmd, spmi->regs + SPMI_CMD_REG);
+
+	while (i < len) {
+		j = 0;
+		spmi_cmd = 0;
+		while ((j < 4) & (i < len))
+			spmi_cmd |= buf[i++] << (j++ * 8);
+
+		writel(spmi_cmd, spmi->regs + SPMI_CMD_REG);
+	}
+
+	ret = apple_spmi_wait_rx_not_empty(ctrl);
+	if (ret)
+		return ret;
+
+	/* Discard */
+	readl(spmi->regs + SPMI_RSP_REG);
+
+	return 0;
+}
+
+static int apple_spmi_probe(struct platform_device *pdev)
+{
+	struct apple_spmi *spmi;
+	struct spmi_controller *ctrl;
+	int ret;
+
+	ctrl = devm_spmi_controller_alloc(&pdev->dev, sizeof(*spmi));
+	if (IS_ERR(ctrl))
+		return -ENOMEM;
+
+	spmi = spmi_controller_get_drvdata(ctrl);
+
+	spmi->regs = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(spmi->regs))
+		return PTR_ERR(spmi->regs);
+
+	ctrl->dev.of_node = pdev->dev.of_node;
+
+	ctrl->read_cmd = spmi_read_cmd;
+	ctrl->write_cmd = spmi_write_cmd;
+
+	ret = devm_spmi_controller_add(&pdev->dev, ctrl);
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret,
+				     "spmi_controller_add failed\n");
+
+	return 0;
+}
+
+static const struct of_device_id apple_spmi_match_table[] = {
+	{ .compatible = "apple,spmi", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, apple_spmi_match_table);
+
+static struct platform_driver apple_spmi_driver = {
+	.probe		= apple_spmi_probe,
+	.driver		= {
+		.name	= "apple-spmi",
+		.of_match_table = apple_spmi_match_table,
+	},
+};
+module_platform_driver(apple_spmi_driver);
+
+MODULE_AUTHOR("Jean-Francois Bortolotti <jeff@borto.fr>");
+MODULE_DESCRIPTION("Apple SoC SPMI driver");
+MODULE_LICENSE("GPL");
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

