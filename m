Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41CA28FAA8;
	Mon, 30 Jun 2025 20:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317120; cv=none; b=XV4b0l4OMl+hP6+9nXkT+tQAx/w6lXOKNxsKUGExrXDiXgfvfmnnfHV5nWOF/7UfNtifYqMtBl0YliCA4rtCjCh7OJQ34p2NHdDFiomoiCpmiPsFXELh765a2RQ4ElVfFiGPiak3FUyiqM2vqAtiG6U5xoDN7yh2idgJZVE8n18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317120; c=relaxed/simple;
	bh=0mrlP4RQWhearshPohuTkY9jkmPF8Or6XOBrolcfz24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fxw1ou8v5Xmix2iWhD6LCEvZbNSbGQ5NyFN6GPoGW/BuC5yvS28fCc9WUtmYnFnn8en9rWZ3s3zaxg/97QJriwfBX4b45HSE9BJoJU2zLy/NWIKmeTIU3Ex9rmHGZxNdFl3W02BpL2i+GPH8+k48fERZ1lAkkEvQVU7nesnxxvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjmIhmDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjmIhmDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D957C4CEEB;
	Mon, 30 Jun 2025 20:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317119;
	bh=0mrlP4RQWhearshPohuTkY9jkmPF8Or6XOBrolcfz24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjmIhmDbr6W5VmpT92JMr4pWCgSUjeW4lIW7tbkmToOeQOdSyK0N39gqVSS/Rpm3L
	 UqMkov1VDejVpRSalzdArqYy/Dye6jEN5QoetbcUmyD0oYORWDE/kTZPKfAMXx2T2z
	 lZleBrmDqEqeFCRoKWLztV02ETisPVIq9ZYA0hv+jm0EoCjPmynl7pdpvdlwvLMrKC
	 H+xTpNHRammWfDqQPABL35OqxZeIv+lpIJ107sc7PxyJUOC52pSYyjTRSEPe5GWmjP
	 8SaVJA+9uPVvql3OOJZTyGWPz8XIqDXc8bXKyMFRMbrDhewZhZvPwVc9sBZT3AHVwV
	 aGEH+aqTHpeCA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com
Subject: [PATCH AUTOSEL 6.15 05/23] ASoC: rt721-sdca: fix boost gain calculation error
Date: Mon, 30 Jun 2025 16:44:10 -0400
Message-Id: <20250630204429.1357695-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204429.1357695-1-sashal@kernel.org>
References: <20250630204429.1357695-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.4
Content-Transfer-Encoding: 8bit

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit ff21a6ec0f27c126db0a86d96751bd6e5d1d9874 ]

Fix the boost gain calculation error in rt721_sdca_set_gain_get.
This patch is specific for "FU33 Boost Volume".

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://patch.msgid.link/1b18fcde41c64d6fa85451d523c0434a@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Analysis

The commit fixes a calculation error in the `rt721_sdca_set_gain_get()`
function, specifically for FU33 Boost Volume controls. Looking at the
code changes:

1. **The bug**: When `mc->shift == 1` (FU33 boost gain), the original
   code incorrectly falls through to the ADC/DAC gain calculation path
   (lines 444-449 in the original):
  ```c
  if (mc->shift == 8) /* boost gain */
  ctl_l = read_l / tendB;
  else {
  // This path was incorrectly used for FU33 boost (shift == 1)
  if (adc_vol_flag)
  ctl_l = mc->max - (((0x1e00 - read_l) & 0xffff) / interval_offset);
  else
  ctl_l = mc->max - (((0 - read_l) & 0xffff) / interval_offset);
  }
  ```

2. **The fix**: Adds a specific case for `mc->shift == 1` with proper
   FU33 boost gain calculation:
  ```c
  else if (mc->shift == 1) {
  /* FU33 boost gain */
  if (read_l == 0x8000 || read_l == 0xfe00)
  ctl_l = 0;
  else
  ctl_l = read_l / tendA + 1;  // Uses tendA (0x200) instead of tendB
  }
  ```

## Backport Justification

1. **User-facing bug**: This causes incorrect volume levels to be
   reported to userspace for FU33 boost controls, affecting audio
   applications and user experience.

2. **Small and contained**: The fix only adds ~15 lines of code in a
   single function, with no changes to data structures or APIs.

3. **Low regression risk**: The change only affects the specific case
   where `mc->shift == 1`, leaving all other code paths unchanged.

4. **Similar to accepted backports**: This follows the pattern of
   similar commits #1 and #2 in the reference set:
   - "ASoC: rt5682: Fix the boost volume at the beginning of playback"
     (backported)
   - "ASoC: rt5645: fix the shift bit of IN1 boost" (backported)

   Both were small, targeted fixes for boost gain calculation errors and
were accepted for stable.

5. **Clear fix for clear bug**: The commit message and code clearly show
   this is fixing an incorrect calculation, not adding features or
   making architectural changes.

The commit meets all criteria for stable backporting: it fixes a real
bug, is minimal in scope, has low risk of regression, and follows
established patterns for similar codec driver fixes.

 sound/soc/codecs/rt721-sdca.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt721-sdca.c b/sound/soc/codecs/rt721-sdca.c
index 1c9f32e405cf9..ba080957e9336 100644
--- a/sound/soc/codecs/rt721-sdca.c
+++ b/sound/soc/codecs/rt721-sdca.c
@@ -430,6 +430,7 @@ static int rt721_sdca_set_gain_get(struct snd_kcontrol *kcontrol,
 	unsigned int read_l, read_r, ctl_l = 0, ctl_r = 0;
 	unsigned int adc_vol_flag = 0;
 	const unsigned int interval_offset = 0xc0;
+	const unsigned int tendA = 0x200;
 	const unsigned int tendB = 0xa00;
 
 	if (strstr(ucontrol->id.name, "FU1E Capture Volume") ||
@@ -439,9 +440,16 @@ static int rt721_sdca_set_gain_get(struct snd_kcontrol *kcontrol,
 	regmap_read(rt721->mbq_regmap, mc->reg, &read_l);
 	regmap_read(rt721->mbq_regmap, mc->rreg, &read_r);
 
-	if (mc->shift == 8) /* boost gain */
+	if (mc->shift == 8) {
+		/* boost gain */
 		ctl_l = read_l / tendB;
-	else {
+	} else if (mc->shift == 1) {
+		/* FU33 boost gain */
+		if (read_l == 0x8000 || read_l == 0xfe00)
+			ctl_l = 0;
+		else
+			ctl_l = read_l / tendA + 1;
+	} else {
 		if (adc_vol_flag)
 			ctl_l = mc->max - (((0x1e00 - read_l) & 0xffff) / interval_offset);
 		else
@@ -449,9 +457,16 @@ static int rt721_sdca_set_gain_get(struct snd_kcontrol *kcontrol,
 	}
 
 	if (read_l != read_r) {
-		if (mc->shift == 8) /* boost gain */
+		if (mc->shift == 8) {
+			/* boost gain */
 			ctl_r = read_r / tendB;
-		else { /* ADC/DAC gain */
+		} else if (mc->shift == 1) {
+			/* FU33 boost gain */
+			if (read_r == 0x8000 || read_r == 0xfe00)
+				ctl_r = 0;
+			else
+				ctl_r = read_r / tendA + 1;
+		} else { /* ADC/DAC gain */
 			if (adc_vol_flag)
 				ctl_r = mc->max - (((0x1e00 - read_r) & 0xffff) / interval_offset);
 			else
-- 
2.39.5

