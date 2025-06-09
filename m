Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D54224895;
	Mon,  9 Jun 2025 22:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749509582; cv=none; b=iqAyxUErjRIqdeS9j58U+xm7p0+MQs7oJukZfmL0fOerflrTTUdOzbUDWX/dOyahkAXgBRGT+T16UXisWzcZw7OCs8ked7XANkxgjtNZYYE1M8RSP7qp555w6fuFHTbFXJIzwIT+vkz8naRDsnosqAc1k5z+DugpStl7bCSA240=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749509582; c=relaxed/simple;
	bh=HW9Yeg7MnH1ief6DhkUNV93WZye3u434SJbVmqYqwKc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sAUN3/SP999p63RjMRtMqH0mSUkG3Fa4fvwAjj6yWAIQIsrFRNZcRaw9RUW42B12JEAwETTILPNkDfBhVyDftDoBB1sVFziDgpBNoRfjDO5tryo1dwKiVbTC6xHaQ6ZwJDb7AZWO0ijdFe36sBAvJA4WuIIW1cfys4wkyRn0V4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aa1h/krb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aa1h/krb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B925AC4CEED;
	Mon,  9 Jun 2025 22:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749509582;
	bh=HW9Yeg7MnH1ief6DhkUNV93WZye3u434SJbVmqYqwKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aa1h/krbbJlgLRihWO9EYVOXZihN6iPLIO5C75dCiCZjDe7G0JJ9zfrMkgPc1cg+l
	 GPCOqxSLv6Nll+SkjSobgaulfV0JIdiw1rvaUibQRBcHUCFr2bqR+Hgymh2fTvs8es
	 6aoLfpA+y7wq/GZZxh5AV64NJujV3If4rHabhbvHT+lfdLyExLZpPXuBFqpOS4TOJU
	 e6nVaea0grKvB5x5BCoIenrAfnZrg1r6SKS9voqSn5z3BNY06v2ua7fenX8pVZZ35Q
	 zW4IQjZG/+/6HKy7o1rQeR2AEumK8opuoxFVJ1xsfDJxTiVEuRgtID4iBxrfU+uh2G
	 Ur5isdPCk55kA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com
Subject: [PATCH AUTOSEL 6.14 07/11] ASoC: rt1320: fix speaker noise when volume bar is 100%
Date: Mon,  9 Jun 2025 18:52:41 -0400
Message-Id: <20250609225246.1443679-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609225246.1443679-1-sashal@kernel.org>
References: <20250609225246.1443679-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 9adf2de86611ac108d07e769a699556d87f052e2 ]

This patch updates the settings to fix the speaker noise.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20250602085851.4081886-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Analysis of Code Changes

The commit modifies the `rt1320_vc_blind_write` array, which contains
critical audio initialization settings for the RT1320 version C audio
amplifier chip. The specific changes are:

1. **Register 0x1000db00**: Value changed from `0x04` to `0x07`
2. **New registers added**: 0x1000db15 through 0x1000db23 with specific
   coefficient values

## Why This Should Be Backported

### 1. **Critical Audio Quality Issue**
This directly addresses speaker noise at 100% volume, which is a
significant user experience problem. Looking at the similar commits in
the reference examples, this aligns with "Similar Commit #1" (marked
YES) which fixed "random louder sound" in RT1308-SDW. Both commits:
- Fix audio quality issues that directly affect users
- Modify vendor-specific register settings
- Address problems with volume control/audio output

### 2. **Small, Contained, Low-Risk Fix**
The changes are minimal and highly targeted:
- Only modifies initialization register values in a lookup table
- No architectural changes or new features
- Limited to the RT1320 VC chip variant specifically
- Changes are applied during device initialization only

### 3. **Hardware-Level Bug Fix**
The register addresses (0x1000db00-0x1000db23) are in the DSP/firmware
patch area, indicating this fixes a hardware-level audio processing
issue. These appear to be audio coefficient or speaker protection
parameters that prevent distortion at maximum volume.

### 4. **Follows Stable Tree Criteria**
This commit meets all stable tree requirements:
- ✅ **Important bugfix**: Fixes audible speaker noise affecting user
  experience
- ✅ **Minimal risk**: Only changes register initialization values
- ✅ **Confined scope**: Limited to RT1320 VC audio amplifier
- ✅ **No new features**: Pure bug fix for existing functionality
- ✅ **Clear impact**: Eliminates speaker noise at 100% volume

### 5. **Clear User Impact**
Users with RT1320 VC amplifiers (commonly found in modern
laptops/devices) would experience:
- **Before**: Audible noise/distortion when volume is at 100%
- **After**: Clean audio output at all volume levels including maximum

### 6. **Pattern Matching with Approved Backports**
This closely matches "Similar Commit #1" which was marked for
backporting (YES). Both commits:
- Fix audio output quality issues
- Use vendor registers to resolve problems
- Address volume-related audio artifacts
- Have minimal code impact with targeted register changes

The commit represents exactly the type of important, low-risk hardware
compatibility fix that stable trees are designed to include.

 sound/soc/codecs/rt1320-sdw.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt1320-sdw.c b/sound/soc/codecs/rt1320-sdw.c
index d83b236a04503..4953f554caf08 100644
--- a/sound/soc/codecs/rt1320-sdw.c
+++ b/sound/soc/codecs/rt1320-sdw.c
@@ -204,7 +204,7 @@ static const struct reg_sequence rt1320_vc_blind_write[] = {
 	{ 0x3fc2bfc0, 0x03 },
 	{ 0x0000d486, 0x43 },
 	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT1320_SDCA_ENT_PDE23, RT1320_SDCA_CTL_REQ_POWER_STATE, 0), 0x00 },
-	{ 0x1000db00, 0x04 },
+	{ 0x1000db00, 0x07 },
 	{ 0x1000db01, 0x00 },
 	{ 0x1000db02, 0x11 },
 	{ 0x1000db03, 0x00 },
@@ -225,6 +225,21 @@ static const struct reg_sequence rt1320_vc_blind_write[] = {
 	{ 0x1000db12, 0x00 },
 	{ 0x1000db13, 0x00 },
 	{ 0x1000db14, 0x45 },
+	{ 0x1000db15, 0x0d },
+	{ 0x1000db16, 0x01 },
+	{ 0x1000db17, 0x00 },
+	{ 0x1000db18, 0x00 },
+	{ 0x1000db19, 0xbf },
+	{ 0x1000db1a, 0x13 },
+	{ 0x1000db1b, 0x09 },
+	{ 0x1000db1c, 0x00 },
+	{ 0x1000db1d, 0x00 },
+	{ 0x1000db1e, 0x00 },
+	{ 0x1000db1f, 0x12 },
+	{ 0x1000db20, 0x09 },
+	{ 0x1000db21, 0x00 },
+	{ 0x1000db22, 0x00 },
+	{ 0x1000db23, 0x00 },
 	{ 0x0000d540, 0x01 },
 	{ 0x0000c081, 0xfc },
 	{ 0x0000f01e, 0x80 },
-- 
2.39.5

