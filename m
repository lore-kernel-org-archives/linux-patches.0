Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE1D2210F8;
	Thu, 12 Dec 2024 15:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018034; cv=none; b=QJaSvcSMIzfKvwGtC5Q8+T3CeWjDdk1reH39ZSqlcsdB8ziill6ufxrlOwuIjSA0H5uWYhdFZryYKsmMwJctvgh1SAPDO/cVxMCepGKPUlnYPBspi13PNRQbRHPr0oYpDWQIVlxA72YnJw//ytNJ2CUI9gP23eACaWuKz1ExHyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018034; c=relaxed/simple;
	bh=loCDByFzNsmLdI/ix+qBwM5jCTkElr7GpekZZUKQl8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j5c67x9yWPM1QIzTMLGX6XeSlOUaOBuIlG6Y8SNhNKsJc+yl3yoTDFeGCkis/i9H/gEH2P9Y57SjtJKB81hS/brE/Qy3PZF4y1cduk6zmY8vnKINoSW9OmUUySct0Tyuqm6a0wKLXZnyPvbk5NaKfyZlY93ry4z1IP1IL7cO7ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLUQAtG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLUQAtG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E251FC4CED4;
	Thu, 12 Dec 2024 15:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018033;
	bh=loCDByFzNsmLdI/ix+qBwM5jCTkElr7GpekZZUKQl8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLUQAtG4reYiadvW6wuZnZTHJrMjiGcG+qHnb7YImBIc0KVPbwqO3u0qJXNKjRrGY
	 C9fV9GGdWpzWbW3wHde/Qw/GVv3n5j5uR2dkOHEe7s27qQNIMQo5O9GSmDGqWRCL5z
	 /nawccAwfp4WmJb0cKFnkYTNYHZExPscJTz7865w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 178/356] mmc: sdhci-pci: Add DMI quirk for missing CD GPIO on Vexia Edu Atla 10 tablet
Date: Thu, 12 Dec 2024 15:58:17 +0100
Message-ID: <20241212144251.667614931@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 7f0fa47ceebcff0e3591bb7e32a71a2cd7846149 upstream.

The Vexia Edu Atla 10 tablet distributed to schools in the Spanish
Andalucía region has no ACPI fwnode associated with the SDHCI controller
for its microsd-slot and thus has no ACPI GPIO resource info.

This causes the following error to be logged and the slot to not work:
[   10.572113] sdhci-pci 0000:00:12.0: failed to setup card detect gpio

Add a DMI quirk table for providing gpiod_lookup_tables with manually
provided CD GPIO info and use this DMI table to provide the CD GPIO info
on this tablet. This fixes the microsd-slot not working.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Message-ID: <20241118210049.311079-1-hdegoede@redhat.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-core.c |   72 ++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci-pci.h      |    1 
 2 files changed, 73 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -21,6 +21,7 @@
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/gpio.h>
+#include <linux/gpio/machine.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_qos.h>
 #include <linux/debugfs.h>
@@ -1234,6 +1235,29 @@ static const struct sdhci_pci_fixes sdhc
 	.priv_size	= sizeof(struct intel_host),
 };
 
+/* DMI quirks for devices with missing or broken CD GPIO info */
+static const struct gpiod_lookup_table vexia_edu_atla10_cd_gpios = {
+	.dev_id = "0000:00:12.0",
+	.table = {
+		GPIO_LOOKUP("INT33FC:00", 38, "cd", GPIO_ACTIVE_HIGH),
+		{ }
+	},
+};
+
+static const struct dmi_system_id sdhci_intel_byt_cd_gpio_override[] = {
+	{
+		/* Vexia Edu Atla 10 tablet 9V version */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
+			/* Above strings are too generic, also match on BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "08/25/2014"),
+		},
+		.driver_data = (void *)&vexia_edu_atla10_cd_gpios,
+	},
+	{ }
+};
+
 static const struct sdhci_pci_fixes sdhci_intel_byt_sd = {
 #ifdef CONFIG_PM_SLEEP
 	.resume		= byt_resume,
@@ -1252,6 +1276,7 @@ static const struct sdhci_pci_fixes sdhc
 	.add_host	= byt_add_host,
 	.remove_slot	= byt_remove_slot,
 	.ops		= &sdhci_intel_byt_ops,
+	.cd_gpio_override = sdhci_intel_byt_cd_gpio_override,
 	.priv_size	= sizeof(struct intel_host),
 };
 
@@ -2036,6 +2061,42 @@ static const struct dev_pm_ops sdhci_pci
  *                                                                           *
 \*****************************************************************************/
 
+static struct gpiod_lookup_table *sdhci_pci_add_gpio_lookup_table(
+	struct sdhci_pci_chip *chip)
+{
+	struct gpiod_lookup_table *cd_gpio_lookup_table;
+	const struct dmi_system_id *dmi_id = NULL;
+	size_t count;
+
+	if (chip->fixes && chip->fixes->cd_gpio_override)
+		dmi_id = dmi_first_match(chip->fixes->cd_gpio_override);
+
+	if (!dmi_id)
+		return NULL;
+
+	cd_gpio_lookup_table = dmi_id->driver_data;
+	for (count = 0; cd_gpio_lookup_table->table[count].key; count++)
+		;
+
+	cd_gpio_lookup_table = kmemdup(dmi_id->driver_data,
+				       /* count + 1 terminating entry */
+				       struct_size(cd_gpio_lookup_table, table, count + 1),
+				       GFP_KERNEL);
+	if (!cd_gpio_lookup_table)
+		return ERR_PTR(-ENOMEM);
+
+	gpiod_add_lookup_table(cd_gpio_lookup_table);
+	return cd_gpio_lookup_table;
+}
+
+static void sdhci_pci_remove_gpio_lookup_table(struct gpiod_lookup_table *lookup_table)
+{
+	if (lookup_table) {
+		gpiod_remove_lookup_table(lookup_table);
+		kfree(lookup_table);
+	}
+}
+
 static struct sdhci_pci_slot *sdhci_pci_probe_slot(
 	struct pci_dev *pdev, struct sdhci_pci_chip *chip, int first_bar,
 	int slotno)
@@ -2111,8 +2172,19 @@ static struct sdhci_pci_slot *sdhci_pci_
 		device_init_wakeup(&pdev->dev, true);
 
 	if (slot->cd_idx >= 0) {
+		struct gpiod_lookup_table *cd_gpio_lookup_table;
+
+		cd_gpio_lookup_table = sdhci_pci_add_gpio_lookup_table(chip);
+		if (IS_ERR(cd_gpio_lookup_table)) {
+			ret = PTR_ERR(cd_gpio_lookup_table);
+			goto remove;
+		}
+
 		ret = mmc_gpiod_request_cd(host->mmc, "cd", slot->cd_idx,
 					   slot->cd_override_level, 0);
+
+		sdhci_pci_remove_gpio_lookup_table(cd_gpio_lookup_table);
+
 		if (ret && ret != -EPROBE_DEFER)
 			ret = mmc_gpiod_request_cd(host->mmc, NULL,
 						   slot->cd_idx,
--- a/drivers/mmc/host/sdhci-pci.h
+++ b/drivers/mmc/host/sdhci-pci.h
@@ -156,6 +156,7 @@ struct sdhci_pci_fixes {
 #endif
 
 	const struct sdhci_ops	*ops;
+	const struct dmi_system_id *cd_gpio_override;
 	size_t			priv_size;
 };
 


