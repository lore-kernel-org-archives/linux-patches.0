Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E591537C8;
	Thu, 12 Dec 2024 15:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016650; cv=none; b=EVrHgaXytdkb5fCopiEJU6I1WhDcp+YnccY/XS6O0GEnlkCkJT4WOkrzlReKdJn3QOJPYdI9y21NJDeatW/GAtvkAhwceYZJd11JfrrSotpAJH2Ox5LFG8iapgjkNEGeQ+v+S0QIvD4Ari1hQzx9PJv9F1GkWbXuCC1oSz5hgxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016650; c=relaxed/simple;
	bh=YHPTOyT7R9nCA19R6vdFgWhIJVUSmHqgZmrbWWk5jZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEwguudKGEziQYrpy0sSgSN281WfIrfddptegM1NgCYXQxxm5ZQzvT7xKwoxzrN/OHYbdMpa4GAfJCBUxfZhW+bqrbtdZXXeUprXMmWH01Jzdqv96MxGJwYHgbDVBoNDyzHttgx4gx5QF+SdluGJ5K2CxeiSaWlyVseo1Ph3vEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHvzL+XW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHvzL+XW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBD2C4CECE;
	Thu, 12 Dec 2024 15:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016650;
	bh=YHPTOyT7R9nCA19R6vdFgWhIJVUSmHqgZmrbWWk5jZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHvzL+XWiax4IASOfIDQf3nV9MMH+UbmhylNglcnhKdW2gLWYdaTIZaaxGr+s3e24
	 vzrSgzKxuisBo70VL8mVm5Fh0DjhjV1Y4QF1UdGd165VhtzmUi83d/N46DWh/CN+m7
	 hWc6r4JuNKC4SbRd1eoGjf3aU7kLN1lS55EbzVj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 228/466] ACPI: x86: Make UART skip quirks work on PCI UARTs without an UID
Date: Thu, 12 Dec 2024 15:56:37 +0100
Message-ID: <20241212144315.781827871@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7f261203d7c2e0c06e668b25dfaaee091a79ab25 ]

The Vexia EDU ATLA 10 tablet (9V version) which shipped with Android 4.2
as factory OS has the usual broken DSDT issues for x86 Android tablets.

On top of that this tablet is special because all its LPSS island
peripherals are enumerated as PCI devices rather then as ACPI devices as
they typically are.

For the x86-android-tablets kmod to be able to instantiate a serdev client
for the Bluetooth HCI on this tablet, an ACPI_QUIRK_UART1_SKIP quirk is
necessary.

Modify acpi_dmi_skip_serdev_enumeration() to work with PCI enumerated
UARTs without an UID, such as the UARTs on this tablet.

Also make acpi_dmi_skip_serdev_enumeration() exit early if there are no
quirks, since there is nothing to do then.

And add the necessary quirks for the Vexia EDU ATLA 10 tablet.

This should compile with CONFIG_PCI being unset without issues because
dev_is_pci() is defined as "(false)" then.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241109215936.83004-1-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 47 +++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 6af546b21574f..3eec889d4f5f8 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -12,6 +12,7 @@
 
 #include <linux/acpi.h>
 #include <linux/dmi.h>
+#include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
@@ -391,6 +392,19 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
 	},
+	{
+		/* Vexia Edu Atla 10 tablet 9V version */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
+			/* Above strings are too generic, also match on BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "08/25/2014"),
+		},
+		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_UART1_SKIP |
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
+					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
+	},
 	{
 		/* Whitelabel (sold as various brands) TM800A550L */
 		.matches = {
@@ -439,18 +453,35 @@ static int acpi_dmi_skip_serdev_enumeration(struct device *controller_parent, bo
 	struct acpi_device *adev = ACPI_COMPANION(controller_parent);
 	const struct dmi_system_id *dmi_id;
 	long quirks = 0;
-	u64 uid;
-	int ret;
+	u64 uid = 0;
 
-	ret = acpi_dev_uid_to_integer(adev, &uid);
-	if (ret)
+	dmi_id = dmi_first_match(acpi_quirk_skip_dmi_ids);
+	if (!dmi_id)
 		return 0;
 
-	dmi_id = dmi_first_match(acpi_quirk_skip_dmi_ids);
-	if (dmi_id)
-		quirks = (unsigned long)dmi_id->driver_data;
+	quirks = (unsigned long)dmi_id->driver_data;
+
+	/* uid is left at 0 on errors and 0 is not a valid UART UID */
+	acpi_dev_uid_to_integer(adev, &uid);
+
+	/* For PCI UARTs without an UID */
+	if (!uid && dev_is_pci(controller_parent)) {
+		struct pci_dev *pdev = to_pci_dev(controller_parent);
+
+		/*
+		 * Devfn values for PCI UARTs on Bay Trail SoCs, which are
+		 * the only devices where this fallback is necessary.
+		 */
+		if (pdev->devfn == PCI_DEVFN(0x1e, 3))
+			uid = 1;
+		else if (pdev->devfn == PCI_DEVFN(0x1e, 4))
+			uid = 2;
+	}
+
+	if (!uid)
+		return 0;
 
-	if (!dev_is_platform(controller_parent)) {
+	if (!dev_is_platform(controller_parent) && !dev_is_pci(controller_parent)) {
 		/* PNP enumerated UARTs */
 		if ((quirks & ACPI_QUIRK_PNP_UART1_SKIP) && uid == 1)
 			*skip = true;
-- 
2.43.0



