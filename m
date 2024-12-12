Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9910913792B;
	Thu, 12 Dec 2024 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017171; cv=none; b=SCVnDwiZo3+/g517HuI74P1vtWHqDWELy53kd8Wg0KAOaOusUfLop62TFzMKVi5/9fATP0yqjceRmpPYxtMrsrIz00MQkMt1tnkTMn/XVMrNYq4re9R4XTrTplFEm+KPgGjkhfBBRKXB59CagZyxAA6DvYCdGfwlEfiYPaDVoII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017171; c=relaxed/simple;
	bh=+3q3uKds7XY+daZAunoFIHe+ICHtZzgSkmC0jrKFctA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwCWCRiYs8UABgqb6znDdVitjkqMzD8yCwP8t4NqYb5TpwVvtn+pB/SLu1/KONdoY4fzsOobQpKnOeqzB6QEybBYM7gs+a6nzhBm0ZVYtUp7gqSVFNXPAeSqL6eezdygLmQo6ZNn/lUr++zRTCSj/JGqMxjb6fc2aLMssf4vMok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YSvYp3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YSvYp3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4129C4CECE;
	Thu, 12 Dec 2024 15:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017171;
	bh=+3q3uKds7XY+daZAunoFIHe+ICHtZzgSkmC0jrKFctA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YSvYp3KknqGq8M0EqAqMPAdkCfj+0oztNaLcPc80ni3MiHUtbn91iAol4QOBmZbt
	 jhmORbBGlE8q8cag+YqJtJfp8nMGRHcmrc/99koMKcNpbaykCky3z4JVDXZXVvx49U
	 wYjCEAvngSCVnjhTc5EXcJ+O/qXDeI8JyUcvuJYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 403/466] ACPI: x86: Add skip i2c clients quirk for Acer Iconia One 8 A1-840
Date: Thu, 12 Dec 2024 15:59:32 +0100
Message-ID: <20241212144322.675531095@linuxfoundation.org>
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
index 423565c31d5ef..1bb425b78032a 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -308,6 +308,18 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
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
@@ -425,6 +437,7 @@ static const struct acpi_device_id i2c_acpi_known_good_ids[] = {
 	{ "10EC5640", 0 }, /* RealTek ALC5640 audio codec */
 	{ "10EC5651", 0 }, /* RealTek ALC5651 audio codec */
 	{ "INT33F4", 0 },  /* X-Powers AXP288 PMIC */
+	{ "INT33F5", 0 },  /* TI Dollar Cove PMIC */
 	{ "INT33FD", 0 },  /* Intel Crystal Cove PMIC */
 	{ "INT34D3", 0 },  /* Intel Whiskey Cove PMIC */
 	{ "NPCE69A", 0 },  /* Asus Transformer keyboard dock */
-- 
2.43.0



