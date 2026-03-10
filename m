Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D471A43C07F;
	Tue, 10 Mar 2026 09:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133312; cv=none; b=NyuyZBOG/jzmUU05a1J83hKaC5Fisdtx5j682QFof+U6aWtAeaD3HSVRT/Ia1/5vOCXvDVf1pJ2epKUQyXvru+yHFYrErfTGYBxI6m8UGBK8u0aHzmbdLauNU2UeJe+NDs+N8kBO5Bg2MBXi6cbbpN47o9ZZRPTWMUgK33TaAoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133312; c=relaxed/simple;
	bh=QSp+cJDd/+CmLLNITxn5D3V0lWZorncu4EOGJu0orBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icyClByiFIJRkiT9kpi9ZbpVb/1mI1ZSiE3i+oND/UZW/5c8CMowz/x4VOoJgxzow8IVtw7JOZg8BEvGT93zgI52U0YG0AHsLwPyjLxFSUbxzoa8KEEmhGyy6lt8t+O+pnKPp/rWtVGz/jncSrltpJTv013AFdAyzivjgVYS2lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q8GbFKiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q8GbFKiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B24C2BC87;
	Tue, 10 Mar 2026 09:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133312;
	bh=QSp+cJDd/+CmLLNITxn5D3V0lWZorncu4EOGJu0orBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8GbFKiYn9/t6jWZk2MPzJGzLldG4K9H1MensnbxdmadFJgwt1HgafdC8UNmPhkjK
	 P8kODJizA5q+/hcYpyoxo0j1NHmp8oZ0+86riQ0v6jumqWS7KEqEH9OH1udzmR07Ce
	 WiZNbMxSxbx20JkC+qD8kZ0+/PQU4xcZ7RD6k0n3DbqENwv82XIJjggc6GaCrLrKco
	 3skSfQ/xVKMCeCA4Qbj5w+6fT3miw6lqA/9gJrr1taD3SQQ4mDNEiGwFLpj3K3Bc5i
	 ZjEqGYqeOqJ/NulZE9lnU9ndil4fOjYMY1EmMtQPEszZu4STO8uOeawvjpgkgfvKy/
	 zaXTEa982yI5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	david.rhodes@cirrus.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ASoC: cs35l56: Only patch ASP registers if the DAI is part of a DAIlink
Date: Tue, 10 Mar 2026 05:01:04 -0400
Message-ID: <20260310090145.2709021-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 9351cf3fd92dc1349bb75f2f7f7324607dcf596f ]

Move the ASP register patches to a separate struct and apply this from the
ASP DAI probe() function so that the registers are only patched if the DAI
is part of a DAI link.

Some systems use the ASP as a special-purpose interconnect and on these
systems the ASP registers are configured by a third party (the firmware,
the BIOS, or another device using the amp's secondary host control
interface).

If the machine driver does not hook up the ASP DAI then the ASP registers
must be omitted from the patch to prevent overwriting the third party
configuration.

If the machine driver includes the ASP DAI in a DAI link, this implies that
the machine driver and higher components (such as alsa-ucm) are taking
ownership of the ASP. In this case the ASP registers are patched to known
defaults and the machine driver should configure the ASP.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260226110137.1664562-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I notice the HDA path still calls `cs35l56_set_patch()` but NOT
`cs35l56_set_asp_patch()`. This makes sense - the HDA path uses HDA for
audio, not ASP. The ASP on HDA systems would be used as a special-
purpose interconnect and should NOT have its registers overwritten.

## Analysis

### What the commit does

This commit splits the ASP (Audio Serial Port) register initialization
out of the general `cs35l56_set_patch()` function into a separate
`cs35l56_set_asp_patch()` function. The ASP patch is now only applied
from the DAI `.probe()` callback, meaning it only runs when the ASP DAI
is actually included in a machine driver's DAI link.

### The bug being fixed

On systems where the CS35L56 amplifier's ASP is used as a special-
purpose interconnect (configured by firmware, BIOS, or a secondary host
control interface), the kernel driver was unconditionally overwriting
the ASP registers with hard-coded defaults during initialization. This
would break the ASP configuration set by those third parties, causing
**audio malfunction on those systems**.

This is a real-world functional bug - audio would break or behave
incorrectly on affected systems. The commit message explicitly describes
the problem: "the ASP registers must be omitted from the patch to
prevent overwriting the third party configuration."

### Stable kernel criteria assessment

1. **Fixes a real bug**: Yes - ASP register overwrite causes audio
   malfunction on systems where ASP is configured by firmware/BIOS.
2. **Obviously correct**: Yes - the logic is clean and clear: only patch
   ASP registers when the ASP DAI is actively used by the machine
   driver.
3. **Small and contained**: The change is moderate in size (~40 lines
   across 3 files) but very contained - it only splits an existing array
   and adds a new calling path.
4. **No new features**: The commit does not add new functionality. It
   makes existing functionality conditional to prevent a bug.
5. **Risk**: Low - the change is well-scoped and only affects one codec
   driver. The worst case if something goes wrong is audio issues on
   cs35l56 devices.

### Concerns

1. **Code exists in stable trees**: The driver was introduced in v6.4,
   so it exists in stable trees 6.6.y and later.
2. **Dependencies**: This commit appears to be self-contained - it only
   restructures existing code and adds a standard DAI `.probe` callback.
3. **New exported symbol**: `cs35l56_set_asp_patch` is a new export, but
   it's only called from the same driver (cs35l56.c), and exporting from
   shared modules is the established pattern for this driver.
4. **Backport complexity**: The patch should apply relatively cleanly to
   recent stable trees (6.6.y, 6.12.y) though minor conflicts may occur
   if the register list has changed across versions.

### Verdict

This fixes a real audio regression/bug on systems where the ASP is
managed by firmware/BIOS rather than by the Linux machine driver. The
fix is well-contained, obviously correct, low risk, and self-contained.
The driver exists in stable trees from v6.4 onward. It meets stable
kernel criteria as a bug fix for real-world hardware.

### Verification

- `git log --diff-filter=A` confirmed cs35l56-shared.c was introduced in
  commit e496112529006 ("ASoC: cs35l56: Add driver for Cirrus Logic
  CS35L56")
- `git tag --contains` confirmed the driver was first included in v6.4
- `grep` confirmed `cs35l56_set_patch` is called from both the ASoC path
  (cs35l56.c:1726) and HDA path (cs35l56_hda.c:1186)
- `grep` confirmed `cs35l56_set_asp_patch` is only called from the new
  DAI probe in cs35l56.c:353
- Read of cs35l56_hda.c confirmed the HDA path does NOT call
  `cs35l56_set_asp_patch`, consistent with HDA systems not using ASP via
  the Linux driver
- Read of the current cs35l56-shared.c confirmed the patch was properly
  split - ASP registers in `cs35l56_asp_patch[]`, non-ASP registers in
  `cs35l56_patch[]`
- The commit is very recent (Feb 2026) and not yet in a release tag
  (unverified whether it's had extensive testing in mainline, but it has
  been reviewed by Mark Brown, the ASoC maintainer)

**YES**

 include/sound/cs35l56.h           |  1 +
 sound/soc/codecs/cs35l56-shared.c | 16 +++++++++++++++-
 sound/soc/codecs/cs35l56.c        |  8 ++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/sound/cs35l56.h b/include/sound/cs35l56.h
index 5928af539c468..d0ae1ae2ae2a0 100644
--- a/include/sound/cs35l56.h
+++ b/include/sound/cs35l56.h
@@ -374,6 +374,7 @@ extern const char * const cs35l56_cal_set_status_text[3];
 extern const char * const cs35l56_tx_input_texts[CS35L56_NUM_INPUT_SRC];
 extern const unsigned int cs35l56_tx_input_values[CS35L56_NUM_INPUT_SRC];
 
+int cs35l56_set_asp_patch(struct cs35l56_base *cs35l56_base);
 int cs35l56_set_patch(struct cs35l56_base *cs35l56_base);
 int cs35l56_mbox_send(struct cs35l56_base *cs35l56_base, unsigned int command);
 int cs35l56_firmware_shutdown(struct cs35l56_base *cs35l56_base);
diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index 60100c8f8c952..0ec6a96e80858 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -23,7 +23,7 @@
 
 #include "cs35l56.h"
 
-static const struct reg_sequence cs35l56_patch[] = {
+static const struct reg_sequence cs35l56_asp_patch[] = {
 	/*
 	 * Firmware can change these to non-defaults to satisfy SDCA.
 	 * Ensure that they are at known defaults.
@@ -40,6 +40,20 @@ static const struct reg_sequence cs35l56_patch[] = {
 	{ CS35L56_ASP1TX2_INPUT,		0x00000000 },
 	{ CS35L56_ASP1TX3_INPUT,		0x00000000 },
 	{ CS35L56_ASP1TX4_INPUT,		0x00000000 },
+};
+
+int cs35l56_set_asp_patch(struct cs35l56_base *cs35l56_base)
+{
+	return regmap_register_patch(cs35l56_base->regmap, cs35l56_asp_patch,
+				     ARRAY_SIZE(cs35l56_asp_patch));
+}
+EXPORT_SYMBOL_NS_GPL(cs35l56_set_asp_patch, "SND_SOC_CS35L56_SHARED");
+
+static const struct reg_sequence cs35l56_patch[] = {
+	/*
+	 * Firmware can change these to non-defaults to satisfy SDCA.
+	 * Ensure that they are at known defaults.
+	 */
 	{ CS35L56_SWIRE_DP3_CH1_INPUT,		0x00000018 },
 	{ CS35L56_SWIRE_DP3_CH2_INPUT,		0x00000019 },
 	{ CS35L56_SWIRE_DP3_CH3_INPUT,		0x00000029 },
diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 55b4d0d55712a..1c1924c6f4070 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -346,6 +346,13 @@ static int cs35l56_dsp_event(struct snd_soc_dapm_widget *w,
 	return wm_adsp_event(w, kcontrol, event);
 }
 
+static int cs35l56_asp_dai_probe(struct snd_soc_dai *codec_dai)
+{
+	struct cs35l56_private *cs35l56 = snd_soc_component_get_drvdata(codec_dai->component);
+
+	return cs35l56_set_asp_patch(&cs35l56->base);
+}
+
 static int cs35l56_asp_dai_set_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 {
 	struct cs35l56_private *cs35l56 = snd_soc_component_get_drvdata(codec_dai->component);
@@ -550,6 +557,7 @@ static int cs35l56_asp_dai_set_sysclk(struct snd_soc_dai *dai,
 }
 
 static const struct snd_soc_dai_ops cs35l56_ops = {
+	.probe = cs35l56_asp_dai_probe,
 	.set_fmt = cs35l56_asp_dai_set_fmt,
 	.set_tdm_slot = cs35l56_asp_dai_set_tdm_slot,
 	.hw_params = cs35l56_asp_dai_hw_params,
-- 
2.51.0

