Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A97364A8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2MBbtwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6122BC433C7;
	Wed, 15 Nov 2023 19:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076338;
	bh=jbj6+PV+VHaw1hZdrDLKKjyoIFXrHkhTyqWoi0P9Q/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2MBbtwT/PyOmI5c0v+ANitT4ojrE38dwC7uKQn5jHOW7T+kTvhu0MRZ75q7PS44J
	 in2cj0ma8Y8H5W59h///JKJYMu4AsM8qzgtdYGo/z3ICkI7Ey8UyCZ+763zhO/PnT0
	 kwzMW+U8xgpS3n2oHYHfjhi6YqACzSKFQbuStkXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Nartowicz <deadbeef@nartowicz.co.uk>,
	Armin Wolf <W_Armin@gmx.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 193/550] Revert "hwmon: (sch56xx-common) Add DMI override table"
Date: Wed, 15 Nov 2023 14:12:57 -0500
Message-ID: <20231115191614.142346702@linuxfoundation.org>
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

[ Upstream commit 28da9dee3594423534f3ea1e1f61e6bb2d2fa651 ]

This reverts commit fd2d53c367ae9983c2100ac733a834e0c79d7537.

As reported by Ian Nartowicz, this and the preceding patch
result in a failure to load the driver on Celsius W280.
While the alternative would be to add the board to the DMI
override table, it is quite likely that other systems are
also affected. Revert the offending patches to avoid future
problems.

Fixes: fd2d53c367ae ("hwmon: (sch56xx-common) Add DMI override table")
Reported-by: Ian Nartowicz <deadbeef@nartowicz.co.uk>
Closes: https://lore.kernel.org/linux-hwmon/20231025192239.3c5389ae@debian.org/T/#t
Cc: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sch56xx-common.c | 44 ++++++++--------------------------
 1 file changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/hwmon/sch56xx-common.c b/drivers/hwmon/sch56xx-common.c
index de3a0886c2f72..3ece53adabd62 100644
--- a/drivers/hwmon/sch56xx-common.c
+++ b/drivers/hwmon/sch56xx-common.c
@@ -523,28 +523,6 @@ static int __init sch56xx_device_add(int address, const char *name)
 	return PTR_ERR_OR_ZERO(sch56xx_pdev);
 }
 
-static const struct dmi_system_id sch56xx_dmi_override_table[] __initconst = {
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "CELSIUS W380"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ESPRIMO P710"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ESPRIMO E9900"),
-		},
-	},
-	{ }
-};
-
 /* For autoloading only */
 static const struct dmi_system_id sch56xx_dmi_table[] __initconst = {
 	{
@@ -565,18 +543,16 @@ static int __init sch56xx_init(void)
 		if (!dmi_check_system(sch56xx_dmi_table))
 			return -ENODEV;
 
-		if (!dmi_check_system(sch56xx_dmi_override_table)) {
-			/*
-			 * Some machines like the Esprimo P720 and Esprimo C700 have
-			 * onboard devices named " Antiope"/" Theseus" instead of
-			 * "Antiope"/"Theseus", so we need to check for both.
-			 */
-			if (!dmi_find_device(DMI_DEV_TYPE_OTHER, "Antiope", NULL) &&
-			    !dmi_find_device(DMI_DEV_TYPE_OTHER, " Antiope", NULL) &&
-			    !dmi_find_device(DMI_DEV_TYPE_OTHER, "Theseus", NULL) &&
-			    !dmi_find_device(DMI_DEV_TYPE_OTHER, " Theseus", NULL))
-				return -ENODEV;
-		}
+		/*
+		 * Some machines like the Esprimo P720 and Esprimo C700 have
+		 * onboard devices named " Antiope"/" Theseus" instead of
+		 * "Antiope"/"Theseus", so we need to check for both.
+		 */
+		if (!dmi_find_device(DMI_DEV_TYPE_OTHER, "Antiope", NULL) &&
+		    !dmi_find_device(DMI_DEV_TYPE_OTHER, " Antiope", NULL) &&
+		    !dmi_find_device(DMI_DEV_TYPE_OTHER, "Theseus", NULL) &&
+		    !dmi_find_device(DMI_DEV_TYPE_OTHER, " Theseus", NULL))
+			return -ENODEV;
 	}
 
 	/*
-- 
2.42.0



