Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE57222D46;
	Thu, 12 Dec 2024 15:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018458; cv=none; b=KUSGYxEeuZgZRjgemzjbyBmmBJbov+WKiYWwr+250ocbJQAFRzN+FViM+sHhAC+EBmXCKJfX55b7E/EoHgeTTyzr92/7Z+PTIKNN7QdN75T8Uxq4p81TXDlqE00TLfZYERqzrFxAPj2qYEcjbw8+TzHsYZZLxhzQbJyumrT90hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018458; c=relaxed/simple;
	bh=Bab70+QBiGTfVWffOvuygFNzECMyAT+duaLzPEwA7ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azredDSAoSYHQmoBnLbfzV0gz9e/Ta0M/xzqNAQFDn2RtCr597uEOmsw2UK3YKgi3tDCTOveHHbkRNKwUKc1YaHXt3DTw0b6VQkCQEkr0w5yaftG9lH2YpX0AWaWf1gj1QYxNZ4ZGUIpcnFjsZ+28q7113UhkadLpWd5Ej946l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heapy+Yr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heapy+Yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB9DC4CECE;
	Thu, 12 Dec 2024 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018458;
	bh=Bab70+QBiGTfVWffOvuygFNzECMyAT+duaLzPEwA7ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=heapy+YrBaarHK4z8MZwByhE9yP4qi+k6QBS1izmxJKJ4VLhWpZfQDwwolCDecVuX
	 X+QEA5+TU1cluEkZmauwtXfpvb/nkDHJsFx0gi8EePo+IuDDbJ5QYNlxy0I4ENrbr/
	 GobFlI2HiP+LSSga0VWbWjfhSmg4Z9S1OsagQE5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 299/356] ACPI: x86: Add skip i2c clients quirk for Acer Iconia One 8 A1-840
Date: Thu, 12 Dec 2024 16:00:18 +0100
Message-ID: <20241212144256.378928194@linuxfoundation.org>
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

[ Upstream commit 82f250ed1a1dcde0ad2a1513f85af7f9514635e8 ]

The Acer Iconia One 8 A1-840 (not to be confused with the A1-840FHD which
is a different model) ships with Android 4.4 as factory OS and has the
usual broken DSDT issues for x86 Android tablets.

Add quirks to skip ACPI I2C client enumeration and disable ACPI battery/AC
and ACPI GPIO event handlers.

Also add the "INT33F5" HID for the TI PMIC used on this tablet to the list
of HIDs for which not to skip i2c_client instantiation, since we do want
an ACPI instantiated i2c_client for the PMIC.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241116095825.11660-1-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 33d200cfc2fe1..5fa37e4fecc55 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -300,6 +300,18 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
 					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
 	},
+	{
+		/* Acer Iconia One 8 A1-840 (non FHD version) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "BayTrail"),
+			/* Above strings are too generic also match BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "04/01/2014"),
+		},
+		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
+					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
+	},
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
@@ -418,6 +430,7 @@ static const struct acpi_device_id i2c_acpi_known_good_ids[] = {
 	{ "10EC5640", 0 }, /* RealTek ALC5640 audio codec */
 	{ "10EC5651", 0 }, /* RealTek ALC5651 audio codec */
 	{ "INT33F4", 0 },  /* X-Powers AXP288 PMIC */
+	{ "INT33F5", 0 },  /* TI Dollar Cove PMIC */
 	{ "INT33FD", 0 },  /* Intel Crystal Cove PMIC */
 	{ "INT34D3", 0 },  /* Intel Whiskey Cove PMIC */
 	{ "NPCE69A", 0 },  /* Asus Transformer keyboard dock */
-- 
2.43.0



