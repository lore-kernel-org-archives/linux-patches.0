Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BD71C57A9;
	Tue, 27 Aug 2024 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771580; cv=none; b=hgfeqQI64VX2WlpGccOQ4UxZCVVwOJycd3uBX1wO0iJT+iEEpbwt6tDNBQJiYJY0dK/llQF/aSVMz9FTrHRm2O5e/9Q8Lx4+FecMKRDtfd+u2IZgBQxk30uABXl2vYl0IDXMkbsZDmRWwS8NwePPVGW3BRGhqjzcbGFxyjTzgP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771580; c=relaxed/simple;
	bh=Clnx2dh9HWv8prf7MEQxTzQlMub05nvXVxfVaQYw+VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVr2l8vs5RFbM4RVYSAFmrLHkl7wOC3Sjo4FLRoxIJLcVgxpb2BIDSSJPb8EthBnFHascc1/S1UnSkRKnpV6f7LZuMYBQp5LTS9XyD56oJMZM0MsDreXXbG64f9njgoD1b99Vk8MC2OvKEqfGz1c+bX8whn03w8pXsD/cSz+BQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xf4qYtwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xf4qYtwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C749C61043;
	Tue, 27 Aug 2024 15:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771580;
	bh=Clnx2dh9HWv8prf7MEQxTzQlMub05nvXVxfVaQYw+VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xf4qYtwdPvZhLwL6kbzpx2dsCicNmk0kHZ+w+S6wS/CsEcwM5mQwzJdDiFrji47nG
	 B1TmDC57cCxCm+lslTEwQHuImto3Vt6T4HqNK9Av8M7bwiVKtPSg/D54QmypRbR9I8
	 4an7bOfN/PavRfxdJX8Xqodyd9LatZPzyMzUaFSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.10 230/273] platform/x86: dell-uart-backlight: Use acpi_video_get_backlight_type()
Date: Tue, 27 Aug 2024 16:39:14 +0200
Message-ID: <20240827143842.158761557@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit b5f0943001339c4d324a1af10470ce0bdd79f966 upstream.

The dell-uart-backlight driver supports backlight control on Dell All In
One (AIO) models using a backlight controller board connected to an UART.

In DSDT this uart port will be defined as:

   Name (_HID, "DELL0501")
   Name (_CID, EisaId ("PNP0501")

Now the first AIO has turned up which has not only the DSDT bits for this,
but also an actual controller attached to the UART, yet it is not using
this controller for backlight control.

Use the acpi_video_get_backlight_type() function from the ACPI video-detect
code to check if the dell-uart-backlight driver should actually be used.
This allows reusing the existing ACPI video-detect infra to override
the backlight control method on the commandline or with DMI quirks.

Fixes: 484bae9e4d6a ("platform/x86: Add new Dell UART backlight driver")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20240814190159.15650-3-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/Kconfig               |    1 +
 drivers/platform/x86/dell/dell-uart-backlight.c |    8 ++++++++
 2 files changed, 9 insertions(+)

--- a/drivers/platform/x86/dell/Kconfig
+++ b/drivers/platform/x86/dell/Kconfig
@@ -148,6 +148,7 @@ config DELL_SMO8800
 config DELL_UART_BACKLIGHT
 	tristate "Dell AIO UART Backlight driver"
 	depends on ACPI
+	depends on ACPI_VIDEO
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on SERIAL_DEV_BUS
 	help
--- a/drivers/platform/x86/dell/dell-uart-backlight.c
+++ b/drivers/platform/x86/dell/dell-uart-backlight.c
@@ -20,6 +20,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <acpi/video.h>
 #include "../serdev_helpers.h"
 
 /* The backlight controller must respond within 1 second */
@@ -332,10 +333,17 @@ struct serdev_device_driver dell_uart_bl
 
 static int dell_uart_bl_pdev_probe(struct platform_device *pdev)
 {
+	enum acpi_backlight_type bl_type;
 	struct serdev_device *serdev;
 	struct device *ctrl_dev;
 	int ret;
 
+	bl_type = acpi_video_get_backlight_type();
+	if (bl_type != acpi_backlight_dell_uart) {
+		dev_dbg(&pdev->dev, "Not loading (ACPI backlight type = %d)\n", bl_type);
+		return -ENODEV;
+	}
+
 	ctrl_dev = get_serdev_controller("DELL0501", NULL, 0, "serial0");
 	if (IS_ERR(ctrl_dev))
 		return PTR_ERR(ctrl_dev);


