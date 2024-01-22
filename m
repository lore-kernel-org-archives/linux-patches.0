Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F016BB55;
	Tue, 23 Jan 2024 02:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975369; cv=none; b=JNqMbuVP+vLuM+NW8+K4t/UNYFS89N1z7txEBqdN7ZM5U/DoR6FKpOjCJMVzLA0O9rKd17olgTnD511xpCojAXBJ9fTOk1M3eWbSjJiw6XH269BVt0bga0rCsx2JGVQrIx8/K7b1fIqIYYoTvXa8O3bnj0nu2z18K6emWeDBTo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975369; c=relaxed/simple;
	bh=GmBJ25rYbLqTQ0R9pxnaOzhYh2rToaj1S/yid9jQ1pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfYhwj+uJOIvoVBapWerad5reTZvkrzTbQo+tSivK077L9wFVI8+VG43sl6PlM64X5DqMueqlA30rOB1/V0WQMfLClH4PuZT5gqbaBG9Y2OHQ7WebYeQglvpfEa4uYQ/ZHPOp7L/4f5JozMPgBQeNLwM2SmaexMO1W/Ntz6FOC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzPIpQBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzPIpQBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E24C43390;
	Tue, 23 Jan 2024 02:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975369;
	bh=GmBJ25rYbLqTQ0R9pxnaOzhYh2rToaj1S/yid9jQ1pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzPIpQBTewTxKfyfUKbrZlm6TKEX5poRBi3gjgl8rSLXZL7Z8HmFzwNH7Yx8foM+r
	 +q5Afeojd6jegBh6MlwafoAbrYtVCwe7B2kdrOKUdpiq0sXO2Rr0r7JxCrHgOxXbsE
	 nqgtcE+e0v0eyNOiAuTcvZxoe08kgfWm22CblEZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Emil Velikov <emil.velikov@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 306/583] ASoC: amd: vangogh: Drop conflicting ACPI-based probing
Date: Mon, 22 Jan 2024 15:55:57 -0800
Message-ID: <20240122235821.390099116@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit ddd1ee12a8fb6e4d6f86eddeba64c135eee56623 ]

The Vangogh machine driver variant based on the MAX98388 amplifier, as
found on Valve's Steam Deck OLED, relies on probing via an ACPI match
table.  This worked fine until commit 197b1f7f0df1 ("ASoC: amd: Add new
dmi entries to config entry") enabled SOF support for the target machine
(i.e. Galileo product), causing the sound card to enter the deferred
probe state indefinitely:

$ cat /sys/kernel/debug/devices_deferred
AMDI8821:00	acp5x_mach: Register card (acp5x-max98388) failed

The issue is related to commit e89f45edb747 ("ASoC: amd: vangogh: Add
check for acp config flags in vangogh platform"), which tries to
mitigate potential conflicts between SOF and generic ACP Vangogh
drivers, due to sharing the PCI device IDs.

However, the solution is effective only if the machine driver is
directly probed by pci-acp5x through platform_device_register_full().

Hence, remove the conflicting ACPI based probing and rely exclusively on
DMI quirks for sound card setup.

Fixes: dba22efd0d17 ("ASoC: amd: vangogh: Add support for NAU8821/MAX98388 variant")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Emil Velikov <emil.velikov@collabora.com>
Link: https://msgid.link/r/20231209203229.878730-2-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/vangogh/acp5x-mach.c | 35 +++++++++++-------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/sound/soc/amd/vangogh/acp5x-mach.c b/sound/soc/amd/vangogh/acp5x-mach.c
index eda464545866..2ccc95d57783 100644
--- a/sound/soc/amd/vangogh/acp5x-mach.c
+++ b/sound/soc/amd/vangogh/acp5x-mach.c
@@ -439,7 +439,15 @@ static const struct dmi_system_id acp5x_vg_quirk_table[] = {
 		.matches = {
 			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Valve"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Jupiter"),
-		}
+		},
+		.driver_data = (void *)&acp5x_8821_35l41_card,
+	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Valve"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Galileo"),
+		},
+		.driver_data = (void *)&acp5x_8821_98388_card,
 	},
 	{}
 };
@@ -452,25 +460,15 @@ static int acp5x_probe(struct platform_device *pdev)
 	struct snd_soc_card *card;
 	int ret;
 
-	card = (struct snd_soc_card *)device_get_match_data(dev);
-	if (!card) {
-		/*
-		 * This is normally the result of directly probing the driver
-		 * in pci-acp5x through platform_device_register_full(), which
-		 * is necessary for the CS35L41 variant, as it doesn't support
-		 * ACPI probing and relies on DMI quirks.
-		 */
-		dmi_id = dmi_first_match(acp5x_vg_quirk_table);
-		if (!dmi_id)
-			return -ENODEV;
-
-		card = &acp5x_8821_35l41_card;
-	}
+	dmi_id = dmi_first_match(acp5x_vg_quirk_table);
+	if (!dmi_id || !dmi_id->driver_data)
+		return -ENODEV;
 
 	machine = devm_kzalloc(dev, sizeof(*machine), GFP_KERNEL);
 	if (!machine)
 		return -ENOMEM;
 
+	card = dmi_id->driver_data;
 	card->dev = dev;
 	platform_set_drvdata(pdev, card);
 	snd_soc_card_set_drvdata(card, machine);
@@ -482,17 +480,10 @@ static int acp5x_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct acpi_device_id acp5x_acpi_match[] = {
-	{ "AMDI8821", (kernel_ulong_t)&acp5x_8821_98388_card },
-	{},
-};
-MODULE_DEVICE_TABLE(acpi, acp5x_acpi_match);
-
 static struct platform_driver acp5x_mach_driver = {
 	.driver = {
 		.name = DRV_NAME,
 		.pm = &snd_soc_pm_ops,
-		.acpi_match_table = acp5x_acpi_match,
 	},
 	.probe = acp5x_probe,
 };
-- 
2.43.0



