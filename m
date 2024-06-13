Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB67384;
	Thu, 13 Jun 2024 12:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282937; cv=none; b=SMQvxNUdLDQIKyovmKxraYvoTpTrevDtHPpfHrUWFDhSebm+yjYQGrQA5d8lGvx1G/GKPuA2hYfQ/R571ItoRge3Au9OR3JH0TaSV1z3n2OhdYtZunISdKPJ+98mxEKrVWGBkoZRO0tYLyTfGu32vp+HJj6ZdRLGVnIffRYd4UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282937; c=relaxed/simple;
	bh=haBuvypyuM9e/2MSkhmNDBn9gtePl/6guatOmmKZtyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9qgaf/o6nJG6bTaf9LXGbT6Ao8+gWDMtEBsr5+bG82dqYkt/cZ6do52G0fyP5w5VrWmmdAR+KQwaSfuqKL/yOGrY54eRlg/bfKNjvM6YuRLbUNaYiaIuZyr+gsL+AQX0+t9hbg4L/m+5NbKCUnsdy/3r0d1stGiJZ3fkyRoYt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhMArGiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhMArGiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03850C2BBFC;
	Thu, 13 Jun 2024 12:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282937;
	bh=haBuvypyuM9e/2MSkhmNDBn9gtePl/6guatOmmKZtyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GhMArGiFlknoUztt9YRqcbbZappvEqKF8gCAoiC6roxxjHdpuR/1oIkuhrUwJAyJz
	 UpyCq2SVvEt4+inew5k8WTwL5+lrYBtuK1dxkDK1iZVa9F50x5P+5c9FRbb2se/BlP
	 SVvHm9SobL65oaD8LKrFcuhFy8PeKGbdztbs+4kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 43/85] mmc: sdhci-acpi: Add quirk to enable pull-up on the card-detect GPIO on Asus T100TA
Date: Thu, 13 Jun 2024 13:35:41 +0200
Message-ID: <20240613113215.805622977@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 431946c0f640c93421439a6c928efb3152c035a4 upstream.

The card-detect GPIO for the microSD slot on Asus T100TA / T100TAM models
stopped working under Linux after commit 6fd03f024828 ("gpiolib: acpi:
support bias pull disable").

The GPIO in question is connected to a mechanical switch in the slot
which shorts the pin to GND when a card is inserted.

The GPIO pin correctly gets configured with a 20K pull-up by the BIOS,
but there is a bug in the DSDT where the GpioInt for the card-detect is
configured with a PullNone setting:

    GpioInt (Edge, ActiveBoth, SharedAndWake, PullNone, 0x2710,
        "\\_SB.GPO0", 0x00, ResourceConsumer, ,
        )
        {   // Pin list
        0x0026
        }

Linux now actually honors the PullNone setting and disables the 20K pull-up
configured by the BIOS.

Add a new DMI_QUIRK_SD_CD_ENABLE_PULL_UP quirk which when set calls
mmc_gpiod_set_cd_config() to re-enable the pull-up and set this for
the Asus T100TA models to fix this.

Fixes: 6fd03f024828 ("gpiolib: acpi: support bias pull disable")
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240410191639.526324-7-hdegoede@redhat.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-acpi.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -10,6 +10,7 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/pinctrl/pinconf-generic.h>
 #include <linux/platform_device.h>
 #include <linux/ioport.h>
 #include <linux/io.h>
@@ -81,6 +82,7 @@ enum {
 	DMI_QUIRK_RESET_SD_SIGNAL_VOLT_ON_SUSP			= BIT(0),
 	DMI_QUIRK_SD_NO_WRITE_PROTECT				= BIT(1),
 	DMI_QUIRK_SD_CD_ACTIVE_HIGH				= BIT(2),
+	DMI_QUIRK_SD_CD_ENABLE_PULL_UP				= BIT(3),
 };
 
 static inline void *sdhci_acpi_priv(struct sdhci_acpi_host *c)
@@ -735,6 +737,14 @@ static const struct dmi_system_id sdhci_
 		.driver_data = (void *)DMI_QUIRK_SD_NO_WRITE_PROTECT,
 	},
 	{
+		/* Asus T100TA, needs pull-up for cd but DSDT GpioInt has NoPull set */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "T100TA"),
+		},
+		.driver_data = (void *)DMI_QUIRK_SD_CD_ENABLE_PULL_UP,
+	},
+	{
 		/*
 		 * The Lenovo Miix 320-10ICR has a bug in the _PS0 method of
 		 * the SHC1 ACPI device, this bug causes it to reprogram the
@@ -908,6 +918,9 @@ static int sdhci_acpi_probe(struct platf
 				goto err_free;
 			dev_warn(dev, "failed to setup card detect gpio\n");
 			c->use_runtime_pm = false;
+		} else if (quirks & DMI_QUIRK_SD_CD_ENABLE_PULL_UP) {
+			mmc_gpiod_set_cd_config(host->mmc,
+						PIN_CONF_PACKED(PIN_CONFIG_BIAS_PULL_UP, 20000));
 		}
 
 		if (quirks & DMI_QUIRK_RESET_SD_SIGNAL_VOLT_ON_SUSP)


