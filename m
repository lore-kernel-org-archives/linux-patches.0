Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A046218D630;
	Thu, 15 Aug 2024 13:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730031; cv=none; b=Xwb85GHP028NahzbNA35YPnI5LWmWiTM4x9sKdDBNMSyObbHMzzpTQtk1kWUGI/1UxkRe9qjhMGs7O4v9ETD3DYwwvGktc6e1TvjtJe9ABpDvNA/lD48EHUgODlMLLnaUMa/VHECmkBIVR2iKTAJpKL/2noVd9xHUfhqwCBr4cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730031; c=relaxed/simple;
	bh=8CbvWtYi7o24xC+kqvNy8uaL0YWTYbii7htjbJRwy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+siwNgCd8Ak8MRBeSBtcBPLIXS/FqlITiJWo64x+9CJPOSSWq5hdKV3GAca5NTLhORI5qRLtE/q1+tVs1GQzPrm7g+9Qc5q8okz+tsH3NA0VVJxm9NB51adUlnlXbYovJD+sTz/a2xAcjz68nsCpmN55yrcxeQb43Ivq5h9rug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xe35RNFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xe35RNFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAE4C32786;
	Thu, 15 Aug 2024 13:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730031;
	bh=8CbvWtYi7o24xC+kqvNy8uaL0YWTYbii7htjbJRwy08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xe35RNFQE9gFdXMmzpKQOB8ozUUVVEH4izIx7+phpJg47PtPNQ3rHQa3rglruXxZz
	 ExXNSkVa65sdz0K81D3Dpl2KA+FW0BcBXjBImb4lLK0Q3E14bizKt7yZaYnbHwFn/c
	 yJioc6LGNIz4XFbAIjtgF/B/15M7lNi30yJqm7ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 283/484] spi: spidev: Replace ACPI specific code by device_get_match_data()
Date: Thu, 15 Aug 2024 15:22:21 +0200
Message-ID: <20240815131952.339731275@linuxfoundation.org>
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

[ Upstream commit 2a7f669dd8f6561d227e724ca2614c25732f4799 ]

Instead of calling the ACPI specific APIs, use device_get_match_data().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220323140215.2568-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: fc28d1c1fe3b ("spi: spidev: add correct compatible for Rohm BH2228FV")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 47 ++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 75eb1c95c4a04..8c69ab348a7f7 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -8,19 +8,20 @@
  */
 
 #include <linux/init.h>
-#include <linux/module.h>
 #include <linux/ioctl.h>
 #include <linux/fs.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/list.h>
 #include <linux/errno.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/compat.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/acpi.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/spidev.h>
@@ -710,10 +711,12 @@ static const struct of_device_id spidev_dt_ids[] = {
 MODULE_DEVICE_TABLE(of, spidev_dt_ids);
 #endif
 
-#ifdef CONFIG_ACPI
-
 /* Dummy SPI devices not to be used in production systems */
-#define SPIDEV_ACPI_DUMMY	1
+static int spidev_acpi_check(struct device *dev)
+{
+	dev_warn(dev, "do not use this driver in production systems!\n");
+	return 0;
+}
 
 static const struct acpi_device_id spidev_acpi_ids[] = {
 	/*
@@ -722,35 +725,18 @@ static const struct acpi_device_id spidev_acpi_ids[] = {
 	 * description of the connected peripheral and they should also use
 	 * a proper driver instead of poking directly to the SPI bus.
 	 */
-	{ "SPT0001", SPIDEV_ACPI_DUMMY },
-	{ "SPT0002", SPIDEV_ACPI_DUMMY },
-	{ "SPT0003", SPIDEV_ACPI_DUMMY },
+	{ "SPT0001", (kernel_ulong_t)&spidev_acpi_check },
+	{ "SPT0002", (kernel_ulong_t)&spidev_acpi_check },
+	{ "SPT0003", (kernel_ulong_t)&spidev_acpi_check },
 	{},
 };
 MODULE_DEVICE_TABLE(acpi, spidev_acpi_ids);
 
-static void spidev_probe_acpi(struct spi_device *spi)
-{
-	const struct acpi_device_id *id;
-
-	if (!has_acpi_companion(&spi->dev))
-		return;
-
-	id = acpi_match_device(spidev_acpi_ids, &spi->dev);
-	if (WARN_ON(!id))
-		return;
-
-	if (id->driver_data == SPIDEV_ACPI_DUMMY)
-		dev_warn(&spi->dev, "do not use this driver in production systems!\n");
-}
-#else
-static inline void spidev_probe_acpi(struct spi_device *spi) {}
-#endif
-
 /*-------------------------------------------------------------------------*/
 
 static int spidev_probe(struct spi_device *spi)
 {
+	int (*match)(struct device *dev);
 	struct spidev_data	*spidev;
 	int			status;
 	unsigned long		minor;
@@ -765,7 +751,12 @@ static int spidev_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	spidev_probe_acpi(spi);
+	match = device_get_match_data(&spi->dev);
+	if (match) {
+		status = match(&spi->dev);
+		if (status)
+			return status;
+	}
 
 	/* Allocate driver data */
 	spidev = kzalloc(sizeof(*spidev), GFP_KERNEL);
@@ -837,7 +828,7 @@ static struct spi_driver spidev_spi_driver = {
 	.driver = {
 		.name =		"spidev",
 		.of_match_table = of_match_ptr(spidev_dt_ids),
-		.acpi_match_table = ACPI_PTR(spidev_acpi_ids),
+		.acpi_match_table = spidev_acpi_ids,
 	},
 	.probe =	spidev_probe,
 	.remove =	spidev_remove,
-- 
2.43.0



