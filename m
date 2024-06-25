Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C50CFBEF;
	Tue, 25 Jun 2024 09:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308153; cv=none; b=XBaEK/OLBMP/Z+atLxUM7hC5ziQlP2dsudwIdN7cloK0firh+CgAnv42+nkA3GBvia11c4QGVeEavEjOKEoduED48jRWifMUhfN/uM2TtBKZyck9yncTlzu4Oq6iD16qch6sFHppODj4k49ddo1sdScvceZeWpe3qMcjGibWRgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308153; c=relaxed/simple;
	bh=15YgzIkVDO58ATWSwp7xgQP2ydWo5PwjHmkCG+wgZ+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLm5y2gdDGzBTPjCpszs+r+arMvAOj1MZdNPBIdY2FBdeQ6pUYz79J4yjEhYvFa8ajd+lIwpd19iIzlFxZzMzKm8DOM7wKeuRQMHvdQ/R3R0s6jZEO3m+hV1ZC5j+WqHd9nrBkR+NWGT6TnWA7clEh4U9V4my9akbueGgH0fQ7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzCOq1Pq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzCOq1Pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964D6C32789;
	Tue, 25 Jun 2024 09:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308153;
	bh=15YgzIkVDO58ATWSwp7xgQP2ydWo5PwjHmkCG+wgZ+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzCOq1Pq+3f9mMSvrJVkHl+vsnO54LJQI/8HL+/vDWu7a5dgMby9XHjniPMwCwC0V
	 zVRKvITI1VvL1pAX+rQhkRu2firdBHG8csXwecAYr/seCDCWdd8JcNUUKP1FN9E3kW
	 MrhMY6jcizBDGj0RaoosuoQuHriwHEFWvWEnDhcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 024/250] ACPI: x86: Add PNP_UART1_SKIP quirk for Lenovo Blade2 tablets
Date: Tue, 25 Jun 2024 11:29:42 +0200
Message-ID: <20240625085548.982916440@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d8f20383a2fc3a3844b08a4999cf0e81164a0e56 ]

The x86 Android tablets on which quirks to skip looking for a matching
UartSerialBus resource and instead unconditionally create a serial bus
device (serdev) are necessary there are 2 sorts of serialports:

ACPI enumerated highspeed designware UARTs, these are the ones which
typcially need to be skipped since they need a serdev for the attached
BT HCI.

A PNP enumerated UART which is part of the PCU. So far the existing
quirks have ignored this. But on the Lenovo Yoga Tablet 2 Pro 1380
models this is used for a custom fastcharging protocol. There is
a Micro USB switch which can switch the USB data lines to this uart
and then a 600 baud protocol is used to configure the charger for
a voltage higher then 5V.

Add a new ACPI_QUIRK_PNP_UART1_SKIP quirk type and set this for
the existing entry for the Lenovo Yoga Tablet 2 830 / 1050 models.
Note this will lead to unnecessarily also creating a serdev for
the PCU UART on the 830 / 1050 which don't need this, but the UART
is not used otherwise there so that is not a problem.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 7507a7706898c..448e0d14fd7bd 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -256,9 +256,10 @@ bool force_storage_d3(void)
 #define ACPI_QUIRK_SKIP_I2C_CLIENTS				BIT(0)
 #define ACPI_QUIRK_UART1_SKIP					BIT(1)
 #define ACPI_QUIRK_UART1_TTY_UART2_SKIP				BIT(2)
-#define ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY			BIT(3)
-#define ACPI_QUIRK_USE_ACPI_AC_AND_BATTERY			BIT(4)
-#define ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS			BIT(5)
+#define ACPI_QUIRK_PNP_UART1_SKIP				BIT(3)
+#define ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY			BIT(4)
+#define ACPI_QUIRK_USE_ACPI_AC_AND_BATTERY			BIT(5)
+#define ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS			BIT(6)
 
 static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 	/*
@@ -338,6 +339,7 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 			DMI_MATCH(DMI_BIOS_VERSION, "BLADE_21"),
 		},
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_PNP_UART1_SKIP |
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
 	},
 	{
@@ -436,14 +438,18 @@ static int acpi_dmi_skip_serdev_enumeration(struct device *controller_parent, bo
 	if (ret)
 		return 0;
 
-	/* to not match on PNP enumerated debug UARTs */
-	if (!dev_is_platform(controller_parent))
-		return 0;
-
 	dmi_id = dmi_first_match(acpi_quirk_skip_dmi_ids);
 	if (dmi_id)
 		quirks = (unsigned long)dmi_id->driver_data;
 
+	if (!dev_is_platform(controller_parent)) {
+		/* PNP enumerated UARTs */
+		if ((quirks & ACPI_QUIRK_PNP_UART1_SKIP) && uid == 1)
+			*skip = true;
+
+		return 0;
+	}
+
 	if ((quirks & ACPI_QUIRK_UART1_SKIP) && uid == 1)
 		*skip = true;
 
-- 
2.43.0



