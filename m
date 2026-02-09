Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0183019CB;
	Mon,  9 Feb 2026 12:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640055; cv=none; b=lpGWjHoqaZWJVKqfY1iux85fDCaod28c2Z6ctatzDDB/3VwoZNVrcGKFRXZKZeEl9pbZfC9NXUiAiqPjrCId1a+BbyfjrqHFHySOEgFJoWEVEGVTMPqTEsKvEziWn9/SI+tgWERbgIvQcRt095UCWJjWOOKJJEIETOU3hI0PbEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640055; c=relaxed/simple;
	bh=lRtg476s14l1t1W7R1QDOyJJ0+/3DLw1jJMaeSb5CvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubB2YFwN8BaKgpfjjII7NCA2sJuRAuPXE+q0Yshc+HTRDgR2A5OP+1L7VqdV1SwSzhOhf7cuS/aJLROu1gfMRAmQQ7N7+OQ+vIz2JmiinFuS8MjXO+0XIm3SvHwIIOrtekZQD9IsIy9e+bFy2VbWrbZP2OR1axPcllE2/3Bfr84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ivdOfdpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ivdOfdpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5503C19423;
	Mon,  9 Feb 2026 12:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770640055;
	bh=lRtg476s14l1t1W7R1QDOyJJ0+/3DLw1jJMaeSb5CvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivdOfdpq9Z4xIBAkXE/9/X7MZzQkVWhEJM4Hs33agTTIWG9JgjNrnkcZRhLBCXOGy
	 HPvVkdZ60U4H89QfErYYY4q21YtOwPjQcHnRF8b+zz8vIubGK6HbPhr8f1lUqJXzqP
	 RrBh9WDKfDLE2oXNCExgJ6dGzoSLxQ/pqwiA9MZzD+QjV2Q6efCDcsTEPUsvLgidiQ
	 QvgMUWGnzR4vyhUs6mL7UaKURKoIlBC9/CX/dz1S3Z5dFFUgt9C0euN61EQKvOJYa2
	 WhydIfIoGL5XDWHF1OjuQLO7ddtqWK5IxIV0WxSG0+nyNOZUqHMpKyikGY2TYh3t5F
	 4WpJHK3k40Caw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tagir Garaev <tgaraev653@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kuninori.morimoto.gx@renesas.com,
	balamurugan.c@intel.com,
	liam.r.girdwood@intel.com,
	marco.crivellari@suse.com
Subject: [PATCH AUTOSEL 6.18-6.1] ASoC: Intel: sof_es8336: Add DMI quirk for Huawei BOD-WXX9
Date: Mon,  9 Feb 2026 07:26:50 -0500
Message-ID: <20260209122714.1037915-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209122714.1037915-1-sashal@kernel.org>
References: <20260209122714.1037915-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.9
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

## Analysis of ASoC: Intel: sof_es8336: Add DMI quirk for Huawei BOD-
WXX9

### 1. Commit Message Analysis

The commit adds a DMI quirk entry for the Huawei Matebook D (BOD-WXX9)
laptop to the `sof_es8336` audio driver. The quirk enables
`SOF_ES8336_HEADPHONE_GPIO` and `SOF_ES8336_ENABLE_DMIC` flags for this
specific hardware.

Notably, the commit message contains an RFC section describing an
**unresolved GPIO control issue** - the GPIOs change logically but not
physically when called from DAPM event callbacks. This means the quirk
entry is being added, but the author acknowledges that audio switching
(headphone/speaker) may not fully work yet.

### 2. Code Change Analysis

The change is a pure **DMI quirk table addition**:
- Adds a single new entry to the `sof_es8336_quirk_table[]` array
- Matches `DMI_SYS_VENDOR = "HUAWEI"` and `DMI_PRODUCT_NAME = "BOD-
  WXX9"`
- Sets `SOF_ES8336_HEADPHONE_GPIO | SOF_ES8336_ENABLE_DMIC` as driver
  data
- No code logic changes, no new functions, no structural modifications

The pattern is identical to the existing HUAWEI entry (BOHB-WAX9-PCB-B2)
just below it, which uses `SOF_ES8336_HEADPHONE_GPIO |
SOC_ES8336_HEADSET_MIC1`.

### 3. Classification

This falls squarely into the **hardware quirk/workaround** exception
category for stable backports. DMI quirk entries for audio codecs are
one of the most common types of stable-appropriate additions. They:
- Enable audio functionality on specific hardware
- Are trivially small (data-only addition to an existing table)
- Cannot affect any other hardware (DMI matching is device-specific)
- Follow an established pattern already in the driver

### 4. Scope and Risk Assessment

- **Lines changed**: ~9 lines of new code (one table entry)
- **Files touched**: 1 file (`sound/soc/intel/boards/sof_es8336.c`)
- **Risk**: Extremely low - the DMI match ensures this code path only
  activates on the specific Huawei BOD-WXX9 laptop. No other systems are
  affected.
- **Regression potential**: Near zero for any system other than the
  target device.

### 5. User Impact

- **Who benefits**: Users of Huawei Matebook D (BOD-WXX9) laptops
  running Linux
- **Without this quirk**: The DMIC (internal microphone) and headphone
  GPIO configuration won't be properly set, potentially resulting in no
  audio or broken audio routing
- **Severity**: Audio not working is a significant usability issue for
  laptop users

### 6. Concerns

- The RFC section in the commit message is notable - the author reports
  that GPIO control from DAPM callbacks doesn't work as expected
  (physical GPIO state doesn't change). This suggests the quirk may
  provide partial functionality (DMIC works, but headphone/speaker
  switching may not work fully).
- However, even partial functionality (enabling DMIC) is better than no
  quirk entry at all.
- The commit was accepted by the subsystem maintainer (Mark Brown)
  despite the RFC, suggesting the base quirk entry is valid.

### 7. Dependency Check

No dependencies on other commits. The quirk flags
(`SOF_ES8336_HEADPHONE_GPIO`, `SOF_ES8336_ENABLE_DMIC`) and the quirk
table infrastructure already exist in stable trees where this driver is
present.

### 8. Stability Indicators

- Accepted via the standard ASoC maintainer path (Mark Brown)
- Follows the exact same pattern as existing entries in the same table
- Data-only change with zero logic modifications

### Decision

This is a textbook hardware quirk addition - a small, safe, data-only
change to an existing DMI quirk table that enables audio functionality
on a specific laptop model. It matches the "QUIRKS and WORKAROUNDS"
exception category perfectly. The risk is essentially zero (only affects
one specific hardware model), and the benefit is real (audio support for
Huawei Matebook D users on stable kernels).

**YES**

 sound/soc/intel/boards/sof_es8336.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/intel/boards/sof_es8336.c b/sound/soc/intel/boards/sof_es8336.c
index 09acd80d23e0f..cf50de5c2edd8 100644
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

