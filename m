Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC491442EF;
	Thu, 13 Jun 2024 12:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280430; cv=none; b=belKKoQ+nYEJl8/EkupXSggjUOYAHGrDky4XLUHb5F2H7EPFCb1ZCT8rwBqTxNxYVI3EiI0UdcHovaXNZXyrhAm4zPRXGpCV3LVbLrt5wrxldts59XEhZ3miN5BSay0hCB0rE82QYKkMjJgk0mneB9U9VfuXPzn/HKOM2WshMz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280430; c=relaxed/simple;
	bh=OHUeDdaHThiLVj9JsqfAnMXc27lJIYS4RGNKRH+WlLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdZwDPcYxYeOHPTLeQh3K+TlQs6QqZYSd3NFPa6Ko/M4B6G+bqRH2OmVGUVuYtIrPsxbgsu1PfNyFcSBPYaVkpkPttEjZkcZzF5905rkcJuTabx7T2895upjXxv6kIjpwKHchNbyJwA2Bj9tBE0MzSh6POG8fF/OJgr/BhoqVMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iW3sv12O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iW3sv12O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D66C2BBFC;
	Thu, 13 Jun 2024 12:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280429;
	bh=OHUeDdaHThiLVj9JsqfAnMXc27lJIYS4RGNKRH+WlLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iW3sv12Ob10mfWk3d3k+08RcYw8DrXkReIS18haReb6r8dntwHiwaLYi6EVsuRCVm
	 wzEMQorBnyVLBjCO85mjlP5SH79xreXWg8c0bZJukxx081H9A8+HmmFykq3cCGc2jV
	 oDonau68ylefD2J3xtDf1QOZJ2ND5hRuKr/y2wSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 051/137] mmc: sdhci-acpi: Fix Lenovo Yoga Tablet 2 Pro 1380 sdcard slot not working
Date: Thu, 13 Jun 2024 13:33:51 +0200
Message-ID: <20240613113225.273456666@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit f3521d7cbaefff19cc656325787ed797e5f6a955 upstream.

The Lenovo Yoga Tablet 2 Pro 1380 sdcard slot has an active high cd pin
and a broken wp pin which always reports the card being write-protected.

Add a DMI quirk to address both issues.

Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240410191639.526324-5-hdegoede@redhat.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-acpi.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -80,6 +80,7 @@ struct sdhci_acpi_host {
 enum {
 	DMI_QUIRK_RESET_SD_SIGNAL_VOLT_ON_SUSP			= BIT(0),
 	DMI_QUIRK_SD_NO_WRITE_PROTECT				= BIT(1),
+	DMI_QUIRK_SD_CD_ACTIVE_HIGH				= BIT(2),
 };
 
 static inline void *sdhci_acpi_priv(struct sdhci_acpi_host *c)
@@ -749,6 +750,26 @@ static const struct dmi_system_id sdhci_
 	},
 	{
 		/*
+		 * Lenovo Yoga Tablet 2 Pro 1380F/L (13" Android version) this
+		 * has broken WP reporting and an inverted CD signal.
+		 * Note this has more or less the same BIOS as the Lenovo Yoga
+		 * Tablet 2 830F/L or 1050F/L (8" and 10" Android), but unlike
+		 * the 830 / 1050 models which share the same mainboard this
+		 * model has a different mainboard and the inverted CD and
+		 * broken WP are unique to this board.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corp."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VALLEYVIEW C0 PLATFORM"),
+			DMI_MATCH(DMI_BOARD_NAME, "BYT-T FFD8"),
+			/* Full match so as to NOT match the 830/1050 BIOS */
+			DMI_MATCH(DMI_BIOS_VERSION, "BLADE_21.X64.0005.R00.1504101516"),
+		},
+		.driver_data = (void *)(DMI_QUIRK_SD_NO_WRITE_PROTECT |
+					DMI_QUIRK_SD_CD_ACTIVE_HIGH),
+	},
+	{
+		/*
 		 * The Toshiba WT8-B's microSD slot always reports the card being
 		 * write-protected.
 		 */
@@ -867,6 +888,9 @@ static int sdhci_acpi_probe(struct platf
 	if (sdhci_acpi_flag(c, SDHCI_ACPI_SD_CD)) {
 		bool v = sdhci_acpi_flag(c, SDHCI_ACPI_SD_CD_OVERRIDE_LEVEL);
 
+		if (quirks & DMI_QUIRK_SD_CD_ACTIVE_HIGH)
+			host->mmc->caps2 |= MMC_CAP2_CD_ACTIVE_HIGH;
+
 		err = mmc_gpiod_request_cd(host->mmc, NULL, 0, v, 0);
 		if (err) {
 			if (err == -EPROBE_DEFER)


