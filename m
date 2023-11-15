Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07583A8E7
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwSpRzTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E089C433C7;
	Wed, 15 Nov 2023 19:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076297;
	bh=Ou0GOJmrkwCty6z8gov9b75RgywQd+84u8xXv74Df6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwSpRzTeykM4bJZxEFh2RWM2gPUXOWRVOuTfiAhk8tSKP+WmIkZVzXT3owo9fpR9h
	 3BbFdWfVFg7sR7jA4802E9atZD0xkROk/jWKw2ELjWnapVYrW4+IgR1g8ENjTvN4G9
	 fhDUi5qaqSuOt0icPnyp2dzDH5j3PgIKkImGZkEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Nartowicz <deadbeef@nartowicz.co.uk>,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 194/550] Revert "hwmon: (sch56xx-common) Add automatic module loading on supported devices"
Date: Wed, 15 Nov 2023 14:12:58 -0500
Message-ID: <20231115191614.218089092@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit d621a46d05107f4e510383d6a38f2160c62d28f7 ]

This reverts commit 393935baa45e5ccb9603cf7f9f020ed1bc0915f7.

As reported by Ian Nartowicz, this and the next patch
result in a failure to load the driver on Celsius W280.
While the alternative would be to add the board to the DMI
override table, it is quite likely that other systems are
also affected. Revert the offending patches to avoid future
problems.

Fixes: 393935baa45e ("hwmon: (sch56xx-common) Add automatic module loading on supported devices")
Reported-by: Ian Nartowicz <deadbeef@nartowicz.co.uk>
Closes: https://lore.kernel.org/linux-hwmon/20231025192239.3c5389ae@debian.org/T/#t
Cc: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sch56xx-common.c | 40 ++--------------------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff --git a/drivers/hwmon/sch56xx-common.c b/drivers/hwmon/sch56xx-common.c
index 3ece53adabd62..ac1f725807155 100644
--- a/drivers/hwmon/sch56xx-common.c
+++ b/drivers/hwmon/sch56xx-common.c
@@ -7,10 +7,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/mod_devicetable.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/dmi.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/acpi.h>
@@ -21,10 +19,7 @@
 #include <linux/slab.h>
 #include "sch56xx-common.h"
 
-static bool ignore_dmi;
-module_param(ignore_dmi, bool, 0);
-MODULE_PARM_DESC(ignore_dmi, "Omit DMI check for supported devices (default=0)");
-
+/* Insmod parameters */
 static bool nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
@@ -523,42 +518,11 @@ static int __init sch56xx_device_add(int address, const char *name)
 	return PTR_ERR_OR_ZERO(sch56xx_pdev);
 }
 
-/* For autoloading only */
-static const struct dmi_system_id sch56xx_dmi_table[] __initconst = {
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-		},
-	},
-	{ }
-};
-MODULE_DEVICE_TABLE(dmi, sch56xx_dmi_table);
-
 static int __init sch56xx_init(void)
 {
-	const char *name = NULL;
 	int address;
+	const char *name = NULL;
 
-	if (!ignore_dmi) {
-		if (!dmi_check_system(sch56xx_dmi_table))
-			return -ENODEV;
-
-		/*
-		 * Some machines like the Esprimo P720 and Esprimo C700 have
-		 * onboard devices named " Antiope"/" Theseus" instead of
-		 * "Antiope"/"Theseus", so we need to check for both.
-		 */
-		if (!dmi_find_device(DMI_DEV_TYPE_OTHER, "Antiope", NULL) &&
-		    !dmi_find_device(DMI_DEV_TYPE_OTHER, " Antiope", NULL) &&
-		    !dmi_find_device(DMI_DEV_TYPE_OTHER, "Theseus", NULL) &&
-		    !dmi_find_device(DMI_DEV_TYPE_OTHER, " Theseus", NULL))
-			return -ENODEV;
-	}
-
-	/*
-	 * Some devices like the Esprimo C700 have both onboard devices,
-	 * so we still have to check manually
-	 */
 	address = sch56xx_find(0x4e, &name);
 	if (address < 0)
 		address = sch56xx_find(0x2e, &name);
-- 
2.42.0



