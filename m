Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9931146A9D;
	Tue, 25 Jun 2024 09:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308959; cv=none; b=fNGLJL9Nqw3wOOpQ7OlMQeUkJPFzjALOkBAPxhCmWSPNeu7L7+141OjqFf2vVVY8v8xD/94QIZLB5uiUPxAybJrhWukVHdl7F2vIJHwCiyJD6faPWNWCL+TkHrA/V51cShC0RriAAprSOYCB9yh0o9vGN4UK1jFjxHiVWxPwmLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308959; c=relaxed/simple;
	bh=wecDaOtBoainBcv8e++OPPRlZnbHGkAKhxT9D8lE/bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTONqWjMXW6tYD8cttM+oaQvFGbQ69BhLFH0cPgIZ3+DqFAD3wJ2Rn/S8ThjfDTVCqzvSCPQti/1o0+NmZdM7uXdAPD1K3axaRKb/bud+jkHcF0Bo5yxsJtpxDCQentT67Q1SvMWeNY7X5aBs9t3S7vSglx08qE+D5bWgzPO9PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uj868ys2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uj868ys2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D524C32789;
	Tue, 25 Jun 2024 09:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308959;
	bh=wecDaOtBoainBcv8e++OPPRlZnbHGkAKhxT9D8lE/bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uj868ys21MzKtrGfmzeDZkj3Mli/b1GnBvaUrRyQEcJbwoO+wfl0toN3xOuhK1dFK
	 +vrf3NMhZUI0E6+vs8Y/NsUGQipgYD7fKdJFxh0rrh5cPJCDZAYN5lwsjxxkVP8Eid
	 hqdBzhs5z1+ONKnHuBNMysKNVLbR/oltgDfuqdu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/192] ACPI: x86: Add PNP_UART1_SKIP quirk for Lenovo Blade2 tablets
Date: Tue, 25 Jun 2024 11:31:28 +0200
Message-ID: <20240625085537.780791857@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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
index ac05e2557435e..e035cec614dc8 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -257,9 +257,10 @@ bool force_storage_d3(void)
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
@@ -339,6 +340,7 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 			DMI_MATCH(DMI_BIOS_VERSION, "BLADE_21"),
 		},
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_PNP_UART1_SKIP |
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
 	},
 	{
@@ -437,14 +439,18 @@ static int acpi_dmi_skip_serdev_enumeration(struct device *controller_parent, bo
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



