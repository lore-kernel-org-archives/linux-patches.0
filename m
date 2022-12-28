Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE9E1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2E4C433D2;
	Wed, 28 Dec 2022 16:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246010;
	bh=hMWM+V4ICwMI3VjpThbL+msBKbfsn/cx8Gjl0zT1VIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmSwfK5A7ZpcHED+NGwuknej9FDSQ+LG39s60svhflyOhEvI0e7hlQ62tstRPpxEQ
	 oi6oRgljjPcYvpDNwM6KvxpscTv1VYKvaguQ8/WUNaL0JZyZWj4jTuyeu5biFZeEAR
	 D/Pku7ak7c/FPg6ehZQM31O7DUPYwcyMJgZ7cmxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0961/1146] ACPI: x86: Add skip i2c clients quirk for Lenovo Yoga Tab 3 Pro (YT3-X90F)
Date: Wed, 28 Dec 2022 15:41:40 +0100
Message-Id: <20221228144356.423024917@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit fe820db35275561d8bf86ad19044d40ffc95bc04 ]

The Lenovo Yoga Tab 3 Pro (YT3-X90F) is a x86 (Cherry Trail) tablet which
ships with Android x86 as factory OS. The Android x86 kernel fork ignores
I2C devices described in the DSDT, except for the PMIC and Audio codecs.

As usual the Lenovo Yoga Tab 3 Pro's DSDT contains a bunch of extra I2C
devices which are not actually there, causing various resource conflicts.
Add an ACPI_QUIRK_SKIP_I2C_CLIENTS quirk for the Lenovo Yoga Tab 3 Pro to
the acpi_quirk_skip_dmi_ids table to woraround this.

ACPI_QUIRK_SKIP_I2C_CLIENTS handling uses i2c_acpi_known_good_ids[],
so that PMICs and Audio codecs will still be enumerated properly.
The Lenovo Yoga Tab 3 Pro uses a Whiskey Cove PMIC, add the INT34D3 HID
for this PMIC to the i2c_acpi_known_good_ids[] list.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index d7d3f1669d4c..635de40b5822 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -308,7 +308,7 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
 	},
 	{
-		/* Lenovo Yoga Tablet 1050F/L */
+		/* Lenovo Yoga Tablet 2 1050F/L */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corp."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "VALLEYVIEW C0 PLATFORM"),
@@ -319,6 +319,16 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
 	},
+	{
+		/* Lenovo Yoga Tab 3 Pro X90F */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Blade3-10A-001"),
+		},
+		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
+	},
 	{
 		/* Nextbook Ares 8 */
 		.matches = {
@@ -348,6 +358,7 @@ static const struct acpi_device_id i2c_acpi_known_good_ids[] = {
 	{ "10EC5640", 0 }, /* RealTek ALC5640 audio codec */
 	{ "INT33F4", 0 },  /* X-Powers AXP288 PMIC */
 	{ "INT33FD", 0 },  /* Intel Crystal Cove PMIC */
+	{ "INT34D3", 0 },  /* Intel Whiskey Cove PMIC */
 	{ "NPCE69A", 0 },  /* Asus Transformer keyboard dock */
 	{}
 };
-- 
2.35.1



