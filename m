Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FD92185A8;
	Thu, 12 Dec 2024 15:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018194; cv=none; b=MNVlWSGlVTMlmBeuQCffCwCyXLF5DhHzwafyXvuMpXQrLZiRWYkPfyTfI0LBpCGq8tLL8YPLPHh2EGYEoDjDOrUd6LbwmJZ1PVYDyQnZ67/qBqtds+C4CmXU5tTWVSVE52hp17pUxmWau3sRpWsf5HMZ5KcXqSabb0UH8Z6VxAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018194; c=relaxed/simple;
	bh=VeBRzS9U5gG18xq0fd22iubXWyH46cFprk9ZtIulTXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O04JwH63MgqghE97yG4m4/itFDa0dZMTxOY58CCi/0lh3WlRSXKD+Ugzy42QWsI9O0gwt4B3Y9r3WxKf66ANSUOh00jj1RKjlChSzhOVKBaeUgbJu4xqEHsYPSbH+i1lnC6g1Rp6MIOTkIUgmRQKyHeOmPRqrkXF/OHIL/GFxn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FFW+QzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FFW+QzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFB5C4CECE;
	Thu, 12 Dec 2024 15:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018194;
	bh=VeBRzS9U5gG18xq0fd22iubXWyH46cFprk9ZtIulTXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FFW+QzRXqGwXusk6yBX8Kccm2xEHLZuXRlJSRuwnbWmb1jmTcnsEL//ClzQncp0o
	 Q6jAdyYIntkobbrr9bU20JVAV3iiGo3idl/+yeoKLYSv+ev1fT658mms21Z1FgKyl4
	 +pP9ceY25QOMotgMTV2g1q4qgSXO6sglbrogh79Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 193/356] ACPI: x86: Make UART skip quirks work on PCI UARTs without an UID
Date: Thu, 12 Dec 2024 15:58:32 +0100
Message-ID: <20241212144252.254166899@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e035cec614dc8..33d200cfc2fe1 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -12,6 +12,7 @@
 
 #include <linux/acpi.h>
 #include <linux/dmi.h>
+#include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
@@ -384,6 +385,19 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
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
@@ -432,18 +446,35 @@ static int acpi_dmi_skip_serdev_enumeration(struct device *controller_parent, bo
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



