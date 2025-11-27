Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EF728D830;
	Thu, 27 Nov 2025 14:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255427; cv=none; b=OrhAhSUd1ogEChPp07ES6umVE7MdPO4vM0Ie8l+UbU/hIpIJh8rUkIszN5bHvtdmWo5AKQwX2c4rlsmbdBosLJ2MtlC7U2s2pe033OTlBcWM0YXEEdCxNl3/htKYVIi6vRlyQTV90/hiwn2bdJ7fX1WXTAPcEU7ogbNGy9609vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255427; c=relaxed/simple;
	bh=BsRPrQ0ip6dOzvp6fFzuN/wLEIPZ1CqNZRdYjabxQso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TzXZHmb//LfYrs2aAXffj+s7+FWgjagz82FVN2IJjf6Bpzoy+NB6gji5KDzse3vJdrAyEiUCDBZwseznEVFNkOzHt/zbW1Nq/xYZDh0jmQ9xgQapRao+NllLKGSPJh32REXHp4zarq8HEwBrH2ipnzT90zx6YVRDUbzdyB+DwDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5VUtHto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5VUtHto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A46C4CEF8;
	Thu, 27 Nov 2025 14:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255427;
	bh=BsRPrQ0ip6dOzvp6fFzuN/wLEIPZ1CqNZRdYjabxQso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5VUtHtoQ56SDiBC6XSPPxDF8cQn97uw557JLslX/cG3agE5a+HQnju0MeJNJ7W7y
	 AhVZopvIqzo1Jx9XvM6mm3YA93i7kxQu/ejRfdXXqyyJatAP+uPlbUe2MMq64YRgKa
	 a8epx1QIJ2VT+l9+KfiQ+mTqXRu80YGgHzWVGtlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/112] platform/x86: msi-wmi-platform: Only load on MSI devices
Date: Thu, 27 Nov 2025 15:46:01 +0100
Message-ID: <20251127144035.000701524@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit c93433fd4e2bbbe7caa67b53d808b4a084852ff3 ]

It turns out that the GUID used by the msi-wmi-platform driver
(ABBC0F60-8EA1-11D1-00A0-C90629100000) is not unique, but was instead
copied from the WIndows Driver Samples. This means that this driver
could load on devices from other manufacturers that also copied this
GUID, potentially causing hardware errors.

Prevent this by only loading on devices whitelisted via DMI. The DMI
matches where taken from the msi-ec driver.

Reported-by: Antheas Kapenekakis <lkml@antheas.dev>
Fixes: 9c0beb6b29e7 ("platform/x86: wmi: Add MSI WMI Platform driver")
Tested-by: Antheas Kapenekakis <lkml@antheas.dev>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20251110111253.16204-2-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig            |  1 +
 drivers/platform/x86/msi-wmi-platform.c | 41 ++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 3875abba5a790..902b50510d8d6 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -726,6 +726,7 @@ config MSI_WMI
 config MSI_WMI_PLATFORM
 	tristate "MSI WMI Platform features"
 	depends on ACPI_WMI
+	depends on DMI
 	depends on HWMON
 	help
 	  Say Y here if you want to have support for WMI-based platform features
diff --git a/drivers/platform/x86/msi-wmi-platform.c b/drivers/platform/x86/msi-wmi-platform.c
index dc5e9878cb682..bd2687828a2e6 100644
--- a/drivers/platform/x86/msi-wmi-platform.c
+++ b/drivers/platform/x86/msi-wmi-platform.c
@@ -14,6 +14,7 @@
 #include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/device/driver.h>
+#include <linux/dmi.h>
 #include <linux/errno.h>
 #include <linux/hwmon.h>
 #include <linux/kernel.h>
@@ -448,7 +449,45 @@ static struct wmi_driver msi_wmi_platform_driver = {
 	.probe = msi_wmi_platform_probe,
 	.no_singleton = true,
 };
-module_wmi_driver(msi_wmi_platform_driver);
+
+/*
+ * MSI reused the WMI GUID from the WMI-ACPI sample code provided by Microsoft,
+ * so other manufacturers might use it as well for their WMI-ACPI implementations.
+ */
+static const struct dmi_system_id msi_wmi_platform_whitelist[] __initconst = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MICRO-STAR INT"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+		},
+	},
+	{ }
+};
+
+static int __init msi_wmi_platform_module_init(void)
+{
+	if (!dmi_check_system(msi_wmi_platform_whitelist)) {
+		if (!force)
+			return -ENODEV;
+
+		pr_warn("Ignoring DMI whitelist\n");
+	}
+
+	return wmi_driver_register(&msi_wmi_platform_driver);
+}
+
+static void __exit msi_wmi_platform_module_exit(void)
+{
+	wmi_driver_unregister(&msi_wmi_platform_driver);
+}
+
+module_init(msi_wmi_platform_module_init);
+module_exit(msi_wmi_platform_module_exit);
+
 
 MODULE_AUTHOR("Armin Wolf <W_Armin@gmx.de>");
 MODULE_DESCRIPTION("MSI WMI platform features");
-- 
2.51.0



