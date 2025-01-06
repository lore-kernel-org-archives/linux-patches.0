Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C295A1DE3B8;
	Mon,  6 Jan 2025 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178355; cv=none; b=b2CdM96oW+nYrEXJJJLlodSJ8exo7q0OAuMoHndkemIQjY154CNZ7VnfGokdb9ygkq/jBrL7t7NUBFVKZClEVwrYRVxTDf4Lhr328p53bASjq8MkwoOjwIe9TcbXcVGP4N1f23AZxBnmQFx8xCRx5W9QfYkzVoy4QtrTEzwdPj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178355; c=relaxed/simple;
	bh=0UnfP0Ntk2BhQDj70eOzbCbCVz6QQE1cYJceOAuxTs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnfjCu8aIPSqctChTGgn4FkJNo8TjmtZSTlaeqXyqI+jg3UoRMTuL7j6UQZ9M56PMlo8hTziir6bjfCSoAZrjRg0+ce93UP+n9bS8OBXJyanaRDBzwzuDfWUaUFuElIfrDJNzvdNqi2z33/xRAx9HFhlabiT2XDxvRcbp16Eaug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGbozUKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGbozUKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EE2C4CED2;
	Mon,  6 Jan 2025 15:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178355;
	bh=0UnfP0Ntk2BhQDj70eOzbCbCVz6QQE1cYJceOAuxTs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGbozUKUN7/We//9RgMfG672d53mchckbzKWtTqZpLQkMxgvFza0dz6omyjI5L+3n
	 KJ9tOXqto4VtJsk9ynuSOWP2PyLbstLxFXNnHTWDwp1+PET1tt/5mYFhgC7JwhxEQr
	 FjS/94kWpXd8gs3rVkv81MFmYbnwM7ZX12DVg3ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/138] watchdog: it87_wdt: add PWRGD enable quirk for Qotom QCML04
Date: Mon,  6 Jan 2025 16:16:23 +0100
Message-ID: <20250106151135.470408481@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit 43439076383a7611300334d1357c0f8883f40816 ]

For the watchdog timer to work properly on the QCML04 board we need to
set PWRGD enable in the Environment Controller Configuration Registers
Special Configuration Register 1 when it is not already set, this may
be the case when the watchdog is not enabled from within the BIOS.

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20241025063441.3494837-1-james.hilliard1@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/it87_wdt.c | 39 +++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index 6340ca058f89..da9e24e4a8b6 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -20,6 +20,8 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/bits.h>
+#include <linux/dmi.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
@@ -40,6 +42,7 @@
 #define VAL		0x2f
 
 /* Logical device Numbers LDN */
+#define EC		0x04
 #define GPIO		0x07
 
 /* Configuration Registers and Functions */
@@ -71,6 +74,12 @@
 #define IT8784_ID	0x8784
 #define IT8786_ID	0x8786
 
+/* Environment Controller Configuration Registers LDN=0x04 */
+#define SCR1		0xfa
+
+/* Environment Controller Bits SCR1 */
+#define WDT_PWRGD	0x20
+
 /* GPIO Configuration Registers LDN=0x07 */
 #define WDTCTRL		0x71
 #define WDTCFG		0x72
@@ -241,6 +250,21 @@ static int wdt_set_timeout(struct watchdog_device *wdd, unsigned int t)
 	return ret;
 }
 
+enum {
+	IT87_WDT_OUTPUT_THROUGH_PWRGD	= BIT(0),
+};
+
+static const struct dmi_system_id it87_quirks[] = {
+	{
+		/* Qotom Q30900P (IT8786) */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "QCML04"),
+		},
+		.driver_data = (void *)IT87_WDT_OUTPUT_THROUGH_PWRGD,
+	},
+	{}
+};
+
 static const struct watchdog_info ident = {
 	.options = WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
 	.firmware_version = 1,
@@ -262,8 +286,10 @@ static struct watchdog_device wdt_dev = {
 
 static int __init it87_wdt_init(void)
 {
+	const struct dmi_system_id *dmi_id;
 	u8  chip_rev;
 	u8 ctrl;
+	int quirks = 0;
 	int rc;
 
 	rc = superio_enter();
@@ -274,6 +300,10 @@ static int __init it87_wdt_init(void)
 	chip_rev  = superio_inb(CHIPREV) & 0x0f;
 	superio_exit();
 
+	dmi_id = dmi_first_match(it87_quirks);
+	if (dmi_id)
+		quirks = (long)dmi_id->driver_data;
+
 	switch (chip_type) {
 	case IT8702_ID:
 		max_units = 255;
@@ -334,6 +364,15 @@ static int __init it87_wdt_init(void)
 		superio_outb(0x00, WDTCTRL);
 	}
 
+	if (quirks & IT87_WDT_OUTPUT_THROUGH_PWRGD) {
+		superio_select(EC);
+		ctrl = superio_inb(SCR1);
+		if (!(ctrl & WDT_PWRGD)) {
+			ctrl |= WDT_PWRGD;
+			superio_outb(ctrl, SCR1);
+		}
+	}
+
 	superio_exit();
 
 	if (timeout < 1 || timeout > max_units * 60) {
-- 
2.39.5



