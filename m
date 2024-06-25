Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16B4149DEF;
	Tue, 25 Jun 2024 09:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309464; cv=none; b=j96juFIqOu8ue32nUMjEHQtOn/sv8Q+DsPe0f+TNHmOc49f6zNLDmq7DaX/SJ/XP1ST/hJ/DVp0q6p3Qs7x0q4RCUOBbXZUlV1Wcih3klPTiRSN3PwnAWQjN6sI2zOegF/7mcWu0FA64DmNJBOKAGxGcRvz1xuSwfAc8aCw01v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309464; c=relaxed/simple;
	bh=rCFJ08d9jaOruQZfFABYHiqdDl+w7JTR/BOmtD8xkss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lncfwm35WPWwWIEt8V04s7nPRupwDBSb0pLTl3pTU+7kZCsokij0qA10PLareuCX8Z2k8p3oydBj6DzZmVVaMjrbmqsr1lX+DhW3g4BmO4KrJo106HJlrpzN5HJ5UNvBiVwnpllPDRNH4EdJRJPdXXteHQWT8Ni/1HgbwEu283o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOSGpjOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOSGpjOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D027C32781;
	Tue, 25 Jun 2024 09:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309464;
	bh=rCFJ08d9jaOruQZfFABYHiqdDl+w7JTR/BOmtD8xkss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aOSGpjOjA8bnkAv/oazQ8ca+1djMtN1dHoK2OVErMTMbycIy7yQ56awQDQN9ICXtr
	 4Gqmc4C7OzQ2m5AJJI6Ck7HAUxqT0unj0Y4lIfu0neQ5VpBYQUGxBGRUtAtHyt+rVJ
	 0t1Rs6sEy+DaR+Qcj4Q4pfRh/O0ZLztz3dB6kRhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arvid Norlander <lkml@vorpal.se>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/131] platform/x86: toshiba_acpi: Add quirk for buttons on Z830
Date: Tue, 25 Jun 2024 11:32:59 +0200
Message-ID: <20240625085526.867947574@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arvid Norlander <lkml@vorpal.se>

[ Upstream commit 23f1d8b47d125dcd8c1ec62a91164e6bc5d691d0 ]

The Z830 has some buttons that will only work properly as "quickstart"
buttons. To enable them in that mode, a value between 1 and 7 must be
used for HCI_HOTKEY_EVENT. Windows uses 0x5 on this laptop so use that for
maximum predictability and compatibility.

As there is not yet a known way of auto detection, this patch uses a DMI
quirk table. A module parameter is exposed to allow setting this on other
models for testing.

Signed-off-by: Arvid Norlander <lkml@vorpal.se>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240131111641.4418-3-W_Armin@gmx.de
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/toshiba_acpi.c | 36 ++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 160abd3b3af8b..f10994b94a33a 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -57,6 +57,11 @@ module_param(turn_on_panel_on_resume, int, 0644);
 MODULE_PARM_DESC(turn_on_panel_on_resume,
 	"Call HCI_PANEL_POWER_ON on resume (-1 = auto, 0 = no, 1 = yes");
 
+static int hci_hotkey_quickstart = -1;
+module_param(hci_hotkey_quickstart, int, 0644);
+MODULE_PARM_DESC(hci_hotkey_quickstart,
+		 "Call HCI_HOTKEY_EVENT with value 0x5 for quickstart button support (-1 = auto, 0 = no, 1 = yes");
+
 #define TOSHIBA_WMI_EVENT_GUID "59142400-C6A3-40FA-BADB-8A2652834100"
 
 /* Scan code for Fn key on TOS1900 models */
@@ -136,6 +141,7 @@ MODULE_PARM_DESC(turn_on_panel_on_resume,
 #define HCI_ACCEL_MASK			0x7fff
 #define HCI_ACCEL_DIRECTION_MASK	0x8000
 #define HCI_HOTKEY_DISABLE		0x0b
+#define HCI_HOTKEY_ENABLE_QUICKSTART	0x05
 #define HCI_HOTKEY_ENABLE		0x09
 #define HCI_HOTKEY_SPECIAL_FUNCTIONS	0x10
 #define HCI_LCD_BRIGHTNESS_BITS		3
@@ -2730,10 +2736,15 @@ static int toshiba_acpi_enable_hotkeys(struct toshiba_acpi_dev *dev)
 		return -ENODEV;
 
 	/*
+	 * Enable quickstart buttons if supported.
+	 *
 	 * Enable the "Special Functions" mode only if they are
 	 * supported and if they are activated.
 	 */
-	if (dev->kbd_function_keys_supported && dev->special_functions)
+	if (hci_hotkey_quickstart)
+		result = hci_write(dev, HCI_HOTKEY_EVENT,
+				   HCI_HOTKEY_ENABLE_QUICKSTART);
+	else if (dev->kbd_function_keys_supported && dev->special_functions)
 		result = hci_write(dev, HCI_HOTKEY_EVENT,
 				   HCI_HOTKEY_SPECIAL_FUNCTIONS);
 	else
@@ -3259,7 +3270,14 @@ static const char *find_hci_method(acpi_handle handle)
  * works. toshiba_acpi_resume() uses HCI_PANEL_POWER_ON to avoid changing
  * the configured brightness level.
  */
-static const struct dmi_system_id turn_on_panel_on_resume_dmi_ids[] = {
+#define QUIRK_TURN_ON_PANEL_ON_RESUME		BIT(0)
+/*
+ * Some Toshibas use "quickstart" keys. On these, HCI_HOTKEY_EVENT must use
+ * the value HCI_HOTKEY_ENABLE_QUICKSTART.
+ */
+#define QUIRK_HCI_HOTKEY_QUICKSTART		BIT(1)
+
+static const struct dmi_system_id toshiba_dmi_quirks[] = {
 	{
 	 /* Toshiba Portégé R700 */
 	 /* https://bugzilla.kernel.org/show_bug.cgi?id=21012 */
@@ -3267,6 +3285,7 @@ static const struct dmi_system_id turn_on_panel_on_resume_dmi_ids[] = {
 		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
 		DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE R700"),
 		},
+	 .driver_data = (void *)QUIRK_TURN_ON_PANEL_ON_RESUME,
 	},
 	{
 	 /* Toshiba Satellite/Portégé R830 */
@@ -3276,6 +3295,7 @@ static const struct dmi_system_id turn_on_panel_on_resume_dmi_ids[] = {
 		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
 		DMI_MATCH(DMI_PRODUCT_NAME, "R830"),
 		},
+	 .driver_data = (void *)QUIRK_TURN_ON_PANEL_ON_RESUME,
 	},
 	{
 	 /* Toshiba Satellite/Portégé Z830 */
@@ -3283,6 +3303,7 @@ static const struct dmi_system_id turn_on_panel_on_resume_dmi_ids[] = {
 		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
 		DMI_MATCH(DMI_PRODUCT_NAME, "Z830"),
 		},
+	 .driver_data = (void *)(QUIRK_TURN_ON_PANEL_ON_RESUME | QUIRK_HCI_HOTKEY_QUICKSTART),
 	},
 };
 
@@ -3291,6 +3312,8 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 	struct toshiba_acpi_dev *dev;
 	const char *hci_method;
 	u32 dummy;
+	const struct dmi_system_id *dmi_id;
+	long quirks = 0;
 	int ret = 0;
 
 	if (toshiba_acpi)
@@ -3443,8 +3466,15 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 	}
 #endif
 
+	dmi_id = dmi_first_match(toshiba_dmi_quirks);
+	if (dmi_id)
+		quirks = (long)dmi_id->driver_data;
+
 	if (turn_on_panel_on_resume == -1)
-		turn_on_panel_on_resume = dmi_check_system(turn_on_panel_on_resume_dmi_ids);
+		turn_on_panel_on_resume = !!(quirks & QUIRK_TURN_ON_PANEL_ON_RESUME);
+
+	if (hci_hotkey_quickstart == -1)
+		hci_hotkey_quickstart = !!(quirks & QUIRK_HCI_HOTKEY_QUICKSTART);
 
 	toshiba_wwan_available(dev);
 	if (dev->wwan_supported)
-- 
2.43.0



