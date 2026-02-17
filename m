Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAE52773E4;
	Tue, 17 Feb 2026 20:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361329; cv=none; b=d2Sd8G3XjIdoyStzu2QgYj7eQYncAJnlj8qso3ren66Upis1TsctbDNqK8Vuy5jjHaHKGjWM7J4Gy1FbdJL6CpqxM4x8s99ut2UiZrDhgO/TaK4EYPCHwZUAsLj9hAWoBMifbaqsc3cfeC4BHdylyEARXbhQY6WGUFin5904hVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361329; c=relaxed/simple;
	bh=ERKWIJ7pgm+xbiims/KqrIdtbNrooNUujCPrykr3hYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y32aAoMA+QvxHJ3ejjW37Zob1piXgs/cEOA9+4cWtV5U/GuSBzIimK2/rIAbOtaeYHe9OgRP2OD4FLXDsHwdzO7qYR3MG6HaH2X6PTYbKD5x1ApwhUdde60eWwMA81Huubz+EsLbDmbSQxPXBsnYiIDwy+HUscUk1VcoBgjdXTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKK4Aixw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKK4Aixw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11D5C4CEF7;
	Tue, 17 Feb 2026 20:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361329;
	bh=ERKWIJ7pgm+xbiims/KqrIdtbNrooNUujCPrykr3hYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKK4AixwX2k6mezjA0P9ZN703VCJlVgkUGb4v+ZOjVLtMYbgaK1UrTY31zuUMhAMt
	 j2bajGDswKa82kWFbj0ii8UlvkNp8WdKnuYFxT2L+ag9O8zR2zbwjubKolGtCo6B5I
	 qmrLcwEEW1aVofySp/Bt59grUELbxg/s/OhWPhH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tagir Garaev <tgaraev653@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 36/64] ASoC: Intel: sof_es8336: Add DMI quirk for Huawei BOD-WXX9
Date: Tue, 17 Feb 2026 21:31:32 +0100
Message-ID: <20260217200008.863604709@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tagir Garaev <tgaraev653@gmail.com>

[ Upstream commit 6b641122d31f9d33e7d60047ee0586d1659f3f54 ]

Add DMI entry for Huawei Matebook D (BOD-WXX9) with HEADPHONE_GPIO
and DMIC quirks.

This device has ES8336 codec with:
- GPIO 16 (headphone-enable) for headphone amplifier control
- GPIO 17 (speakers-enable) for speaker amplifier control
- GPIO 269 for jack detection IRQ
- 2-channel DMIC

Hardware investigation shows that both GPIO 16 and 17 are required
for proper audio routing, as headphones and speakers share the same
physical output (HPOL/HPOR) and are separated only via amplifier
enable signals.

RFC: Seeking advice on GPIO control issue:

GPIO values change in driver (gpiod_get_value() shows logical value
changes) but not physically (debugfs gpio shows no change). The same
gpiod_set_value_cansleep() calls work correctly in probe context with
msleep(), but fail when called from DAPM event callbacks.

Context information from diagnostics:
- in_atomic=0, in_interrupt=0, irqs_disabled=0
- Process context: pipewire
- GPIO 17 (speakers): changes in driver, no physical change
- GPIO 16 (headphone): changes in driver, no physical change

In Windows, audio switching works without visible GPIO changes,
suggesting possible ACPI/firmware involvement.

Any suggestions on how to properly control these GPIOs from DAPM
events would be appreciated.

Signed-off-by: Tagir Garaev <tgaraev653@gmail.com>
Link: https://patch.msgid.link/20260201121728.16597-1-tgaraev653@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_es8336.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 41dab5dcf79a3..1c71c23f347e7 100644
--- a/sound/soc/intel/boards/sof_es8336.c
+++ b/sound/soc/intel/boards/sof_es8336.c
@@ -332,6 +332,15 @@ static int sof_es8336_quirk_cb(const struct dmi_system_id *id)
  * if the topology file is modified as well.
  */
 static const struct dmi_system_id sof_es8336_quirk_table[] = {
+	{
+		.callback = sof_es8336_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HUAWEI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "BOD-WXX9"),
+		},
+		.driver_data = (void *)(SOF_ES8336_HEADPHONE_GPIO |
+					SOF_ES8336_ENABLE_DMIC)
+	},
 	{
 		.callback = sof_es8336_quirk_cb,
 		.matches = {
-- 
2.51.0



