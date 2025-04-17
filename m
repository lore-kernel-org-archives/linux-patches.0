Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B05325744D;
	Thu, 17 Apr 2025 17:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912699; cv=none; b=dfUu2xkZ7UVRf0g1QsjcXCGlK2k2rYL4Pw84lzKSSqdKFun7wYKLw7i2dUNeqWqv0tQl7e4TMlQbfC3rkb2USzUtQ2Bo7aTSdItPXxDFbsml+V6TsOPobzo7P6EfeIE6P1e+wKI0BiZO+4BQe/5SMCMNqvAL55yTfowhuP7r4oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912699; c=relaxed/simple;
	bh=TYKlTwPa0tu/yy+VoiZlUfyL2xraxpGso4WgEtKe5z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msQ7H86dHVRoW7RPqjoGIY1fr8FJueXRi/Fy8TGfotLEdtUzNZi5QwCnM2OWZpBi53u2YlknUyCzQxkAQrsqUuRy0zlbidqNIuHXhytikthoq/qteApZ7s8BeQXdIRblJ+MHHoKfU38l8G/3C7QsryZZCu44GJZf4aQ4R118Rmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XY4xViJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XY4xViJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08FCC4CEE4;
	Thu, 17 Apr 2025 17:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912699;
	bh=TYKlTwPa0tu/yy+VoiZlUfyL2xraxpGso4WgEtKe5z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XY4xViJ/Eo6dq8dkGgzNg8XKQR6sNZHAE0iMmoghhx5rlyD1l/XOi+hSquIQzDDov
	 s89tCGmniq5s/LSsQjAeHpSGDdKNcoQRfebxVAoDSjQtPUTEfvhcH8wJRPvWjyNtuo
	 O4qjg66aPEdXGc1D/LlOqzKDbcUL5i6NXcp8TVXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	linux@frame.work,
	"Dustin L. Howett" <dustin@howett.net>,
	Daniel Schaefer <dhs@frame.work>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 068/449] platform/chrome: cros_ec_lpc: Match on Framework ACPI device
Date: Thu, 17 Apr 2025 19:45:56 +0200
Message-ID: <20250417175120.719717995@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Schaefer <dhs@frame.work>

[ Upstream commit d83c45aeec9b223fe6db4175e9d1c4f5699cc37a ]

Load the cros_ec_lpc driver based on a Framework FRMWC004 ACPI device,
which mirrors GOOG0004, but also applies npcx quirks for Framework
systems.

Matching on ACPI will let us avoid having to change the SMBIOS match
rules again and again.

Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: linux@frame.work
Cc: Dustin L. Howett <dustin@howett.net>
Signed-off-by: Daniel Schaefer <dhs@frame.work>
Link: https://lore.kernel.org/r/20250128181329.8070-1-dhs@frame.work
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_lpc.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_lpc.c b/drivers/platform/chrome/cros_ec_lpc.c
index 5a2f1d98b3501..be319949b9415 100644
--- a/drivers/platform/chrome/cros_ec_lpc.c
+++ b/drivers/platform/chrome/cros_ec_lpc.c
@@ -30,6 +30,7 @@
 
 #define DRV_NAME "cros_ec_lpcs"
 #define ACPI_DRV_NAME "GOOG0004"
+#define FRMW_ACPI_DRV_NAME "FRMWC004"
 
 /* True if ACPI device is present */
 static bool cros_ec_lpc_acpi_device_found;
@@ -514,7 +515,7 @@ static int cros_ec_lpc_probe(struct platform_device *pdev)
 	acpi_status status;
 	struct cros_ec_device *ec_dev;
 	struct cros_ec_lpc *ec_lpc;
-	struct lpc_driver_data *driver_data;
+	const struct lpc_driver_data *driver_data;
 	u8 buf[2] = {};
 	int irq, ret;
 	u32 quirks;
@@ -526,6 +527,9 @@ static int cros_ec_lpc_probe(struct platform_device *pdev)
 	ec_lpc->mmio_memory_base = EC_LPC_ADDR_MEMMAP;
 
 	driver_data = platform_get_drvdata(pdev);
+	if (!driver_data)
+		driver_data = acpi_device_get_match_data(dev);
+
 	if (driver_data) {
 		quirks = driver_data->quirks;
 
@@ -696,12 +700,6 @@ static void cros_ec_lpc_remove(struct platform_device *pdev)
 	cros_ec_unregister(ec_dev);
 }
 
-static const struct acpi_device_id cros_ec_lpc_acpi_device_ids[] = {
-	{ ACPI_DRV_NAME, 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(acpi, cros_ec_lpc_acpi_device_ids);
-
 static const struct lpc_driver_data framework_laptop_npcx_lpc_driver_data __initconst = {
 	.quirks = CROS_EC_LPC_QUIRK_REMAP_MEMORY,
 	.quirk_mmio_memory_base = 0xE00,
@@ -713,6 +711,13 @@ static const struct lpc_driver_data framework_laptop_mec_lpc_driver_data __initc
 	.quirk_aml_mutex_name = "ECMT",
 };
 
+static const struct acpi_device_id cros_ec_lpc_acpi_device_ids[] = {
+	{ ACPI_DRV_NAME, 0 },
+	{ FRMW_ACPI_DRV_NAME, (kernel_ulong_t)&framework_laptop_npcx_lpc_driver_data },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, cros_ec_lpc_acpi_device_ids);
+
 static const struct dmi_system_id cros_ec_lpc_dmi_table[] __initconst = {
 	{
 		/*
@@ -866,7 +871,8 @@ static int __init cros_ec_lpc_init(void)
 	int ret;
 	const struct dmi_system_id *dmi_match;
 
-	cros_ec_lpc_acpi_device_found = !!cros_ec_lpc_get_device(ACPI_DRV_NAME);
+	cros_ec_lpc_acpi_device_found = !!cros_ec_lpc_get_device(ACPI_DRV_NAME) ||
+		!!cros_ec_lpc_get_device(FRMW_ACPI_DRV_NAME);
 
 	dmi_match = dmi_first_match(cros_ec_lpc_dmi_table);
 
-- 
2.39.5



