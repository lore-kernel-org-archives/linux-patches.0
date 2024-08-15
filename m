Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9220718D630;
	Thu, 15 Aug 2024 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730038; cv=none; b=o2hD7iboI2wA4vluGSzuPXmByhjB3bX23BRT2Mmc/QaNLKfN0w74fHyAzBQjC8T7HQd4VLgLnn9fdWaFSym1XI/p6fmPxq7wHktpIpLMgx8wW5sCkdLchx3RVGmP95K/t7kPFETJbwWczF1myg01QHBpfADsnx/ZmUnLE8rvKKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730038; c=relaxed/simple;
	bh=8zzxwEk5Q88IpKQdClk/DhE32X+gCV4XPBHyytRBWzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYNZPCsb8jAZmt5fA+ymV5Hob+1ur9e6nnFXQYjJaMj9VKMHoyoyChfyetQLckV9B+wUU2r0fw7bCY0R6YWZvepebiHS/vNbHQzy5jTGYHW1Iemhl4JCAotV2TGFrwbeOYtXr5WIYoxo0CV9zNZVqx8En44L0lKE1kEPFIqyoKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNgYKEbp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNgYKEbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41C3C32786;
	Thu, 15 Aug 2024 13:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730038;
	bh=8zzxwEk5Q88IpKQdClk/DhE32X+gCV4XPBHyytRBWzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNgYKEbpXabnaXF5XQb7jiQEeuxHn69QkgIHs7mQRQf0I9dWa+ZTgj7VKy5g5/s1Y
	 wpAd14T/X9X0FQmAqKjwOzFtVurHOZ3L35EQjRvfSSIS5SwCRcTjRSaqcYsIeRSRxz
	 AN8ZvDGl0WTp4i3WMN5Q+yU625za2vupvoZsewc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/484] spi: spidev: Replace OF specific code by device property API
Date: Thu, 15 Aug 2024 15:22:22 +0200
Message-ID: <20240815131952.377458267@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 88a285192084edab6657e819f7f130f9cfcb0579 ]

Instead of calling the OF specific APIs, use device property ones.

It also prevents misusing PRP0001 in ACPI when trying to instantiate
spidev directly. We only support special SPI test devices there.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220323140215.2568-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: fc28d1c1fe3b ("spi: spidev: add correct compatible for Rohm BH2228FV")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 45 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 8c69ab348a7f7..4a19c2142e474 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -20,8 +20,6 @@
 #include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/compat.h>
-#include <linux/of.h>
-#include <linux/of_device.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/spidev.h>
@@ -696,20 +694,31 @@ static const struct spi_device_id spidev_spi_ids[] = {
 };
 MODULE_DEVICE_TABLE(spi, spidev_spi_ids);
 
-#ifdef CONFIG_OF
+/*
+ * spidev should never be referenced in DT without a specific compatible string,
+ * it is a Linux implementation thing rather than a description of the hardware.
+ */
+static int spidev_of_check(struct device *dev)
+{
+	if (device_property_match_string(dev, "compatible", "spidev") < 0)
+		return 0;
+
+	dev_err(dev, "spidev listed directly in DT is not supported\n");
+	return -EINVAL;
+}
+
 static const struct of_device_id spidev_dt_ids[] = {
-	{ .compatible = "rohm,dh2228fv" },
-	{ .compatible = "lineartechnology,ltc2488" },
-	{ .compatible = "semtech,sx1301" },
-	{ .compatible = "lwn,bk4" },
-	{ .compatible = "dh,dhcom-board" },
-	{ .compatible = "menlo,m53cpld" },
-	{ .compatible = "cisco,spi-petra" },
-	{ .compatible = "micron,spi-authenta" },
+	{ .compatible = "rohm,dh2228fv", .data = &spidev_of_check },
+	{ .compatible = "lineartechnology,ltc2488", .data = &spidev_of_check },
+	{ .compatible = "semtech,sx1301", .data = &spidev_of_check },
+	{ .compatible = "lwn,bk4", .data = &spidev_of_check },
+	{ .compatible = "dh,dhcom-board", .data = &spidev_of_check },
+	{ .compatible = "menlo,m53cpld", .data = &spidev_of_check },
+	{ .compatible = "cisco,spi-petra", .data = &spidev_of_check },
+	{ .compatible = "micron,spi-authenta", .data = &spidev_of_check },
 	{},
 };
 MODULE_DEVICE_TABLE(of, spidev_dt_ids);
-#endif
 
 /* Dummy SPI devices not to be used in production systems */
 static int spidev_acpi_check(struct device *dev)
@@ -741,16 +750,6 @@ static int spidev_probe(struct spi_device *spi)
 	int			status;
 	unsigned long		minor;
 
-	/*
-	 * spidev should never be referenced in DT without a specific
-	 * compatible string, it is a Linux implementation thing
-	 * rather than a description of the hardware.
-	 */
-	if (spi->dev.of_node && of_device_is_compatible(spi->dev.of_node, "spidev")) {
-		dev_err(&spi->dev, "spidev listed directly in DT is not supported\n");
-		return -EINVAL;
-	}
-
 	match = device_get_match_data(&spi->dev);
 	if (match) {
 		status = match(&spi->dev);
@@ -827,7 +826,7 @@ static int spidev_remove(struct spi_device *spi)
 static struct spi_driver spidev_spi_driver = {
 	.driver = {
 		.name =		"spidev",
-		.of_match_table = of_match_ptr(spidev_dt_ids),
+		.of_match_table = spidev_dt_ids,
 		.acpi_match_table = spidev_acpi_ids,
 	},
 	.probe =	spidev_probe,
-- 
2.43.0



