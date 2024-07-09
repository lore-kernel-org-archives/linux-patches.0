Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6F5157485;
	Tue,  9 Jul 2024 11:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524368; cv=none; b=cHLq4RkcwzGROHlFAImoy80qaRVHremTaa7wtw/npBZI3F7ZwVKADGpPX0pHicpqE0sNpjXVVrogvtl+HgMbAh7Iu7ZabvSt5e63hS2hRmjq1fkBOWFZOMzA86aGwchvgfQwa2wohra2ycOieXcmDy8NEjoQomZ9Lp+EuORaXwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524368; c=relaxed/simple;
	bh=7eHsA5CpHdkn9B6Pc7CeyXB0Gyfz7ewh4hXu27g3HKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jtRcjt4K/3VL5Uy6OGmhF6OXGVMHNYU+8RqkVWryNmLu+8pqUlDsTD2DQh4cIxnFSo4g0GWOgetnIiIX1OnH6Lvi27PPbrGtic3APQ4z6mYmekAv/fvAmd+eUMm5qpOajM/Pgl1W47cOuIgztujGV5xs43ENMdQ7n5/ieWLBq58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDIhfctY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDIhfctY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B717C3277B;
	Tue,  9 Jul 2024 11:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524367;
	bh=7eHsA5CpHdkn9B6Pc7CeyXB0Gyfz7ewh4hXu27g3HKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDIhfctYyRrtg7wE8tSvuwj1qomlj75ZKsvtvfhtXTIj6/C3rD0yorRjzpvai5Woi
	 cjRCsNDu0tNJO8+aRHmbFiEDIejug6Gc3FXjaObR9/M17/zl5XsC1SfcPOaMQatTR+
	 LANSdZQ4QRm8Isbalfgq+b/4NhE0hj4sCUeEPRnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kemal <kmal@cock.li>,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.9 131/197] platform/x86: toshiba_acpi: Fix quickstart quirk handling
Date: Tue,  9 Jul 2024 13:09:45 +0200
Message-ID: <20240709110714.021017877@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

commit e527a6127223b644e0a27b44f4b16e16eb6c7f0a upstream.

The global hci_hotkey_quickstart quirk flag is tested in
toshiba_acpi_enable_hotkeys() before the quirk flag is properly
initialized based on SMBIOS data. This causes the quirk to be
applied to all models, some of which behave erratically as a
result.

Fix this by initializing the global quirk flags during module
initialization before registering the ACPI driver. This also
allows us to mark toshiba_dmi_quirks[] as __initconst.

Fixes: 23f1d8b47d12 ("platform/x86: toshiba_acpi: Add quirk for buttons on Z830")
Reported-by: kemal <kmal@cock.li>
Closes: https://lore.kernel.org/platform-driver-x86/R4CYFS.TWB8QUU2SHWI1@cock.li/
Tested-by: kemal <kmal@cock.li>
Cc: stable@vger.kernel.org
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20240701194539.348937-1-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/toshiba_acpi.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -3276,7 +3276,7 @@ static const char *find_hci_method(acpi_
  */
 #define QUIRK_HCI_HOTKEY_QUICKSTART		BIT(1)
 
-static const struct dmi_system_id toshiba_dmi_quirks[] = {
+static const struct dmi_system_id toshiba_dmi_quirks[] __initconst = {
 	{
 	 /* Toshiba Portégé R700 */
 	 /* https://bugzilla.kernel.org/show_bug.cgi?id=21012 */
@@ -3311,8 +3311,6 @@ static int toshiba_acpi_add(struct acpi_
 	struct toshiba_acpi_dev *dev;
 	const char *hci_method;
 	u32 dummy;
-	const struct dmi_system_id *dmi_id;
-	long quirks = 0;
 	int ret = 0;
 
 	if (toshiba_acpi)
@@ -3465,16 +3463,6 @@ iio_error:
 	}
 #endif
 
-	dmi_id = dmi_first_match(toshiba_dmi_quirks);
-	if (dmi_id)
-		quirks = (long)dmi_id->driver_data;
-
-	if (turn_on_panel_on_resume == -1)
-		turn_on_panel_on_resume = !!(quirks & QUIRK_TURN_ON_PANEL_ON_RESUME);
-
-	if (hci_hotkey_quickstart == -1)
-		hci_hotkey_quickstart = !!(quirks & QUIRK_HCI_HOTKEY_QUICKSTART);
-
 	toshiba_wwan_available(dev);
 	if (dev->wwan_supported)
 		toshiba_acpi_setup_wwan_rfkill(dev);
@@ -3624,10 +3612,27 @@ static struct acpi_driver toshiba_acpi_d
 	.drv.pm	= &toshiba_acpi_pm,
 };
 
+static void __init toshiba_dmi_init(void)
+{
+	const struct dmi_system_id *dmi_id;
+	long quirks = 0;
+
+	dmi_id = dmi_first_match(toshiba_dmi_quirks);
+	if (dmi_id)
+		quirks = (long)dmi_id->driver_data;
+
+	if (turn_on_panel_on_resume == -1)
+		turn_on_panel_on_resume = !!(quirks & QUIRK_TURN_ON_PANEL_ON_RESUME);
+
+	if (hci_hotkey_quickstart == -1)
+		hci_hotkey_quickstart = !!(quirks & QUIRK_HCI_HOTKEY_QUICKSTART);
+}
+
 static int __init toshiba_acpi_init(void)
 {
 	int ret;
 
+	toshiba_dmi_init();
 	toshiba_proc_dir = proc_mkdir(PROC_TOSHIBA, acpi_root_dir);
 	if (!toshiba_proc_dir) {
 		pr_err("Unable to create proc dir " PROC_TOSHIBA "\n");


