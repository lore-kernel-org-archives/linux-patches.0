Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD33A1D6DB5;
	Tue, 11 Nov 2025 00:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822557; cv=none; b=a5k+95ZkGGWU00r6GIe2i3G3uc8SrT9aFBsO/L/V72i+U8MSBD1AiUXCBzwf7MlKIP0v1e7fwG8zZsRYucuz1Cncdt7gB+rRt4KOyryVq+RDmeCefHmF8alVGsi+gXmUO2H/cdLi02e/SvFenaslMfJ18cOJ81cjT56nPe6tBYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822557; c=relaxed/simple;
	bh=z8ZJi4GFliIOjc7X8H2vdiIrI6kmq1wmrlmkkgMfbyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Be9rdmBaLFnDrwPbqFIwbXaV2zjSGRn2yE2UCr5mBbU979WBbMHB0INO11G9l2ZIV70VQ2n9JdP9PgdB3bi8TubCqjuEToG38K+qjIGVsukXT3dOxAhPiVHfE4ilkWJd5pKWwK5VDEA12CaKfOzOoD9SIKTu+LbsmscHhv8cvlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0TTlQNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0TTlQNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60283C4CEF5;
	Tue, 11 Nov 2025 00:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822557;
	bh=z8ZJi4GFliIOjc7X8H2vdiIrI6kmq1wmrlmkkgMfbyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0TTlQNBvdmBVjf7RHNBal47i/vrvuoD/B6uXmjO2ZB52LUXJ7cVbg9wG22CxFiFH
	 BJeJcqPJ3awHzo591O785yizI+4nUP2xw7erO/ePNBE59qowqg9ucXWrvAnAMK8uZy
	 ovQvrl9RP4c5LndiEQ01nBfrap5V/1J87L8fWpao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/565] ACPI: fan: Use platform device for devres-related actions
Date: Tue, 11 Nov 2025 09:38:50 +0900
Message-ID: <20251111004528.620425010@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit d91a1d129b63614fa4c2e45e60918409ce36db7e ]

Device-managed resources are cleaned up when the driver unbinds from
the underlying device. In our case this is the platform device as this
driver is a platform driver. Registering device-managed resources on
the associated ACPI device will thus result in a resource leak when
this driver unbinds.

Ensure that any device-managed resources are only registered on the
platform device to ensure that they are cleaned up during removal.

Fixes: 35c50d853adc ("ACPI: fan: Add hwmon support")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Cc: 6.11+ <stable@vger.kernel.org> # 6.11+
Link: https://patch.msgid.link/20251007234149.2769-4-W_Armin@gmx.de
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/fan.h       |    4 ++--
 drivers/acpi/fan_core.c  |    2 +-
 drivers/acpi/fan_hwmon.c |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/acpi/fan.h
+++ b/drivers/acpi/fan.h
@@ -63,9 +63,9 @@ int acpi_fan_create_attributes(struct ac
 void acpi_fan_delete_attributes(struct acpi_device *device);
 
 #if IS_REACHABLE(CONFIG_HWMON)
-int devm_acpi_fan_create_hwmon(struct acpi_device *device);
+int devm_acpi_fan_create_hwmon(struct device *dev);
 #else
-static inline int devm_acpi_fan_create_hwmon(struct acpi_device *device) { return 0; };
+static inline int devm_acpi_fan_create_hwmon(struct device *dev) { return 0; };
 #endif
 
 #endif
--- a/drivers/acpi/fan_core.c
+++ b/drivers/acpi/fan_core.c
@@ -357,7 +357,7 @@ static int acpi_fan_probe(struct platfor
 	}
 
 	if (fan->has_fst) {
-		result = devm_acpi_fan_create_hwmon(device);
+		result = devm_acpi_fan_create_hwmon(&pdev->dev);
 		if (result)
 			return result;
 
--- a/drivers/acpi/fan_hwmon.c
+++ b/drivers/acpi/fan_hwmon.c
@@ -166,12 +166,12 @@ static const struct hwmon_chip_info acpi
 	.info = acpi_fan_hwmon_info,
 };
 
-int devm_acpi_fan_create_hwmon(struct acpi_device *device)
+int devm_acpi_fan_create_hwmon(struct device *dev)
 {
-	struct acpi_fan *fan = acpi_driver_data(device);
+	struct acpi_fan *fan = dev_get_drvdata(dev);
 	struct device *hdev;
 
-	hdev = devm_hwmon_device_register_with_info(&device->dev, "acpi_fan", fan,
-						    &acpi_fan_hwmon_chip_info, NULL);
+	hdev = devm_hwmon_device_register_with_info(dev, "acpi_fan", fan, &acpi_fan_hwmon_chip_info,
+						    NULL);
 	return PTR_ERR_OR_ZERO(hdev);
 }


