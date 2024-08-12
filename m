Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEAC134AC;
	Mon, 12 Aug 2024 16:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479934; cv=none; b=cU1oD2LfREQ3HuzP+wNQJoxp4FCtTiXjhMtN2xl+x9qvNQCp6s7hJ4Gzovr0qGWELhfpDx2nBUdf/SAMjLxhrptnbbe7VR2UIa0B8Wo4nHFW0yPeYbOgi0jlxh7YwKaoKPMj5qt83Ab35UwVq4KaZSLa6mP/BwC7sh99Y+nnC8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479934; c=relaxed/simple;
	bh=e2zLxL+5ecTk8eW1nOQt6HuEFJ0D/t5nIyX+sbjH+fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfLrnqgRjrUwo64uUQyfHDJeohfpT4Stn2+VmAd2xymr1JWvYvk+W3sgSm24D1HDV3JZ9+hsKM5r/wcwmAcu1J6R5NZ5Qy/YeUs4JvXxlbL7tkBGvOzpKrIwuyjgv7VqyAfhVRHNppJ1T+4g4bTiIR6u2D5Vyn7PlGvBvSzEFBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOMPdC0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOMPdC0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173ABC32782;
	Mon, 12 Aug 2024 16:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479933;
	bh=e2zLxL+5ecTk8eW1nOQt6HuEFJ0D/t5nIyX+sbjH+fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SOMPdC0I3ROYqD6QYVNFwg0+L/9o5XEhZU1kp1M4fxVfAb+09D+Yi/ffrEN9Atmns
	 6tHT19m6/rfuIjY8S7tWuPcTL+2cTrz1Y1ajqBjEneenY30s3DVNGWBdhvX8fEhqfB
	 tL9/tyh5k7X0h0Ov1GAJJttm9vP7G4Bw+E1VWWK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	Ben Walsh <ben@jubnut.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 044/263] platform/chrome: cros_ec_lpc: Add a new quirk for ACPI id
Date: Mon, 12 Aug 2024 18:00:45 +0200
Message-ID: <20240812160148.232238786@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Walsh <ben@jubnut.com>

[ Upstream commit 040159e0912c31fe959d8671f9700bda105ab63a ]

Framework Laptops' ACPI exposes the EC with id "PNP0C09". But
"PNP0C09" is part of the ACPI standard; there are lots of computers
with EC chips with this id, and most of them don't support the cros_ec
protocol.

The driver could find the ACPI device by having "PNP0C09" in the
acpi_match_table, but this would match devices which don't support the
cros_ec protocol. Instead, add a new quirk "CROS_EC_LPC_QUIRK_ACPI_ID"
which allows the id to be specified. This quirk is applied after the
DMI check shows that the device is supported.

Tested-by: Dustin L. Howett <dustin@howett.net>
Signed-off-by: Ben Walsh <ben@jubnut.com>
Link: https://lore.kernel.org/r/20240605063351.14836-4-ben@jubnut.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_lpc.c | 50 ++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_lpc.c b/drivers/platform/chrome/cros_ec_lpc.c
index ddfbfec44f4cc..43e0914256a3c 100644
--- a/drivers/platform/chrome/cros_ec_lpc.c
+++ b/drivers/platform/chrome/cros_ec_lpc.c
@@ -39,6 +39,11 @@ static bool cros_ec_lpc_acpi_device_found;
  * be used as the base port for EC mapped memory.
  */
 #define CROS_EC_LPC_QUIRK_REMAP_MEMORY              BIT(0)
+/*
+ * Indicates that lpc_driver_data.quirk_acpi_id should be used to find
+ * the ACPI device.
+ */
+#define CROS_EC_LPC_QUIRK_ACPI_ID                   BIT(1)
 
 /**
  * struct lpc_driver_data - driver data attached to a DMI device ID to indicate
@@ -46,10 +51,12 @@ static bool cros_ec_lpc_acpi_device_found;
  * @quirks: a bitfield composed of quirks from CROS_EC_LPC_QUIRK_*
  * @quirk_mmio_memory_base: The first I/O port addressing EC mapped memory (used
  *                          when quirk ...REMAP_MEMORY is set.)
+ * @quirk_acpi_id: An ACPI HID to be used to find the ACPI device.
  */
 struct lpc_driver_data {
 	u32 quirks;
 	u16 quirk_mmio_memory_base;
+	const char *quirk_acpi_id;
 };
 
 /**
@@ -374,6 +381,26 @@ static void cros_ec_lpc_acpi_notify(acpi_handle device, u32 value, void *data)
 		pm_system_wakeup();
 }
 
+static acpi_status cros_ec_lpc_parse_device(acpi_handle handle, u32 level,
+					    void *context, void **retval)
+{
+	*(struct acpi_device **)context = acpi_fetch_acpi_dev(handle);
+	return AE_CTRL_TERMINATE;
+}
+
+static struct acpi_device *cros_ec_lpc_get_device(const char *id)
+{
+	struct acpi_device *adev = NULL;
+	acpi_status status = acpi_get_devices(id, cros_ec_lpc_parse_device,
+					      &adev, NULL);
+	if (ACPI_FAILURE(status)) {
+		pr_warn(DRV_NAME ": Looking for %s failed\n", id);
+		return NULL;
+	}
+
+	return adev;
+}
+
 static int cros_ec_lpc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -401,6 +428,16 @@ static int cros_ec_lpc_probe(struct platform_device *pdev)
 
 		if (quirks & CROS_EC_LPC_QUIRK_REMAP_MEMORY)
 			ec_lpc->mmio_memory_base = driver_data->quirk_mmio_memory_base;
+
+		if (quirks & CROS_EC_LPC_QUIRK_ACPI_ID) {
+			adev = cros_ec_lpc_get_device(driver_data->quirk_acpi_id);
+			if (!adev) {
+				dev_err(dev, "failed to get ACPI device '%s'",
+					driver_data->quirk_acpi_id);
+				return -ENODEV;
+			}
+			ACPI_COMPANION_SET(dev, adev);
+		}
 	}
 
 	/*
@@ -661,23 +698,12 @@ static struct platform_device cros_ec_lpc_device = {
 	.name = DRV_NAME
 };
 
-static acpi_status cros_ec_lpc_parse_device(acpi_handle handle, u32 level,
-					    void *context, void **retval)
-{
-	*(bool *)context = true;
-	return AE_CTRL_TERMINATE;
-}
-
 static int __init cros_ec_lpc_init(void)
 {
 	int ret;
-	acpi_status status;
 	const struct dmi_system_id *dmi_match;
 
-	status = acpi_get_devices(ACPI_DRV_NAME, cros_ec_lpc_parse_device,
-				  &cros_ec_lpc_acpi_device_found, NULL);
-	if (ACPI_FAILURE(status))
-		pr_warn(DRV_NAME ": Looking for %s failed\n", ACPI_DRV_NAME);
+	cros_ec_lpc_acpi_device_found = !!cros_ec_lpc_get_device(ACPI_DRV_NAME);
 
 	dmi_match = dmi_first_match(cros_ec_lpc_dmi_table);
 
-- 
2.43.0



