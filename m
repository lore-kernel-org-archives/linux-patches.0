Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EF53F20E5;
	Tue, 28 Apr 2026 10:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372920; cv=none; b=SD3YJMFJkRg8dsbT/GtxWMAHAlmP6bj0HHGJnIWTd80dkeQyCIeSpxMx8pxhlpaDjMkfCf1xcpvtLRfkSY6oaJXApa67S5QVlldEikoU/zRwxaFqqSZv0hX2IUa/QGWvInCXuN3BrmZZqVPl87RyVbj90RZ6Ava8J0O46X7IxUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372920; c=relaxed/simple;
	bh=moRSq+QQ7JkPCG0pb4KT6HXASdeC7kq/Qu88/fsVK8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lKFaHACq1fmhbdxMEwZx7GcypxE5tgmMWQzNCVB+69CwdvkdQtM8RZNmb1VkyMcokigTQM+qpu9Ab2ha0l5GXkFivNGZDple8vorGG1Y2iHQwADaA5FNPia1U12tqK0yUeM1F8Eu/8Y2YpPVPLlzjnCBShtKa6Ga5xd//gx+j6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9JyWyTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9JyWyTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69157C2BCB9;
	Tue, 28 Apr 2026 10:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372920;
	bh=moRSq+QQ7JkPCG0pb4KT6HXASdeC7kq/Qu88/fsVK8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9JyWyTb81FiFRlaKs9kxhJeRM85YQWeGMDXrGPJHTj69OQtnP3AiFGSVhbNCL+7i
	 kkVSXSAEV10PDyIAFq+LVYgujbtuYLKHOegEhDVGZyKLQanZWaTRaUJCDW4d5mP46c
	 Rvjxa2yK+dG/2AcCcC2ClOQzfWt284h+rc3UZAtw8eVliqHTQN02lFkxa5f47WGzgW
	 HCMdt/oKP/7DjftJqsHy7Ni3ALlU3LKY3ur+U3sQKk48wL1vLyamjopkZFXPmAg9oR
	 0Lik7yaV+plMqCFISTwbYbxWSR+4NI4ca3WIiFt0cWARpdLhQXHnD82buoukDg9bDx
	 ubrUCOl+UfCbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tobias Heider <tobias.heider@canonical.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	srinivas.kandagatla@linaro.org,
	bgoswami@quicinc.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] ASoC: qcom: x1e80100: limit speaker volumes
Date: Tue, 28 Apr 2026 06:40:30 -0400
Message-ID: <20260428104133.2858589-19-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tobias Heider <tobias.heider@canonical.com>

[ Upstream commit 0a5ee0e520eff98ee2b4568194562870877b050f ]

Limit the digital gain and PA volumes to a combined -3 dB in the machine
driver to reduce the risk of speaker damage until we have active speaker
protection in place (or higher safe levels have been established).

Based on commit c481016bb4f8 ("ASoC: qcom: sc8280xp: limit speaker
volumes") which addressed the same issue on the sc8280x SoC with some
minor changes as explained below.

The Digital Volume behaves almost identical to sc8280x since both use
the same lpass-wsa-macro, but x1e80100 has two sets of controls prefixed
with WSA and WSA2.
For PA x1e80100 machines use wsa884x amplifiers which expose a linear
scale from -9 dB to 9 dB with a 1.5 dB step size giving us
0 dB = -9 dB + 6 * 1.5 dB.

On x1e80100 there are two different speaker topologies we need to handle:
  2-Speakers: SpkrLeft, Spkr Right
  4-Speakers: WooferLeft, WooferRight, TweeterLeft, TweeterRight

Signed-off-by: Tobias Heider <tobias.heider@canonical.com>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260422-x1e80100-audio-limit-v2-1-333258b97697@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis, I now have enough information to
provide my decision.

## Analysis Summary

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject line parsing**
- Subsystem: `ASoC: qcom: x1e80100`
- Action verb: "limit"
- Record: ASoC machine driver for Qualcomm X1E80100 SoC sets volume caps
  to prevent speaker damage.

**Step 1.2: Tags**
- `Signed-off-by: Tobias Heider <tobias.heider@canonical.com>` (author)
- `Tested-by: Srinivas Kandagatla
  <srinivas.kandagatla@oss.qualcomm.com>` (subsystem maintainer)
- `Reviewed-by: Srinivas Kandagatla
  <srinivas.kandagatla@oss.qualcomm.com>` (subsystem maintainer)
- `Link: https://patch.msgid.link/20260422-x1e80100-audio-
  limit-v2-1-333258b97697@canonical.com`
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (subsystem tree
  maintainer)
- Record: NO `Cc: stable` tag, NO `Fixes:` tag. Tested AND Reviewed by
  the subsystem maintainer.

**Step 1.3: Commit body analysis**
- Bug: Default audio volumes can drive speakers to dangerous
  (potentially damaging) levels.
- Author quote (cover letter): "trivial to crank up the volume to a
  point where the T14s will hit what I believe is a hardware protection
  that shuts down the speakers entirely until the next reboot. I am
  worried that this means there is also a risk cause permanent hardware
  damage."
- Based on a precedent commit `c481016bb4f8` ("ASoC: qcom: sc8280xp:
  limit speaker volumes") that DID have `Cc: <stable@vger.kernel.org> #
  6.5`.
- Record: Hardware safety patch; symptoms range from "speakers shut off
  until reboot" to potential permanent damage.

**Step 1.4: Hidden bug detection**
- "Limit" wording sounds non-fix-like but the commit IS a hardware
  safety fix (similar to a quirk).
- Record: Treats default volume as a hardware-damage risk; falls under
  "hardware quirks/workarounds".

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: 1 (`sound/soc/qcom/x1e80100.c`)
- Lines: +19, -0
- Function modified: `x1e80100_snd_init()`
- Record: Single-file, single-function, surgical change.

**Step 2.2: Code flow change**
- Before: `x1e80100_snd_init()` only handled DisplayPort cases; WSA
  cases fell through to default jack setup with no volume restrictions.
- After: Adds explicit WSA RX cases that call `snd_soc_limit_volume()`
  for digital and PA volumes, then breaks (skipping jack setup, which is
  correct since WSA is for speakers, not headphones).
- Record: Adds a new switch case branch that caps speaker volumes at
  safe levels.

**Step 2.3: Bug mechanism**
- Category: Hardware safety / quirk
- Mechanism: Caps "WSA WSA_RX0 Digital Volume" / "WSA2 ..." to 81 (-3
  dB) and PA volumes to 6 (= 0 dB on wsa884x's -9..+9 dB scale)
- Record: Hardware-protection limit; matches the pattern of the sc8280xp
  limit which was Cc'd to stable.

**Step 2.4: Fix quality**
- `snd_soc_limit_volume()` silently returns `-EINVAL` if a control name
  isn't found, so missing controls (e.g., 4-speaker names on a 2-speaker
  board) cause no harm.
- WSA case path properly `break`s before jack setup.
- v1 of the patch had wrong control names (missing "WSA "/"WSA2 "
  prefixes); maintainer Mark Brown caught it; v2 has correct prefixed
  names verified via `amixer`.
- Record: Minimal, contained, verified by author with `amixer cget`
  after the fix.

### PHASE 3: GIT HISTORY

**Step 3.1/3.2: Origin**
- No `Fixes:` tag. The "bug" is an absence of safe defaults rather than
  a regressive commit.
- The x1e80100 driver was added by `6b9dc2da66578` (ASoC: qcom: Add
  x1e80100 sound machine driver), first appearing in v6.8.
- Record: Driver and the unsafe default have existed since v6.8 (Dec
  2023).

**Step 3.3: Related changes**
- `159098859bf6d` ("ASoC: qcom: x1e80100: Support boards with two
  speakers") added 2-speaker support in v6.13.
- The 4-speaker prefixes (WooferLeft/TweeterLeft/etc.) come from per-
  board DT, not from the machine driver. WSA/WSA2 component prefixes
  have been in `arch/arm64/boot/dts/qcom/x1e80100.dtsi` (now
  `hamoa.dtsi`) since v6.10.
- Record: Patch is standalone; no functional dependency on other source-
  code commits.

**Step 3.4: Author/maintainer context**
- Author Tobias Heider (Canonical) – relevant as users are Linux distro
  users.
- Reviewer/Tester Srinivas Kandagatla is the qcom ASoC maintainer.
- Maintainer Mark Brown applied it.
- Record: Properly vetted by appropriate maintainers.

**Step 3.5: Dependencies**
- `snd_soc_limit_volume(card, ...)` API has the same signature since
  v4.4 — present in every relevant stable tree.
- Sister patch `sc8280xp.c` already shipped to stable confirms the
  API/pattern works in 6.5+.
- Record: No prerequisite kernel changes needed.

### PHASE 4: MAILING LIST

**Step 4.1: Original submission**
- `b4 dig -c 0a5ee0e520eff` →
  https://lore.kernel.org/all/20260422-x1e80100-audio-
  limit-v2-1-333258b97697@canonical.com/
- Record: Found via b4 dig.

**Step 4.1b: Revisions**
- `b4 dig -a` showed v1 (2026-04-21) and v2 (2026-04-22). v2 (the
  applied version) fixed the WSA prefix bug. Author confirmed via amixer
  that v2 correctly limits the controls.
- Record: Applied version is the corrected one.

**Step 4.2: Reviewers**
- Subsystem maintainer Srinivas Kandagatla tested on T14s and Dell
  Latitude 7455.
- Mark Brown applied to `for-7.1`.
- Johan Hovold (author of the original sc8280xp patch) was Cc'd.
- Record: Strong maintainer review.

**Step 4.3: Bug reports**
- No syzbot, no bugzilla. The driving evidence is the author's hands-on
  report of speaker shutdown on Lenovo T14s and the precedent of speaker
  damage concerns on sc8280xp.
- Record: User-reported style (cover letter); not a fuzzer bug.

**Step 4.4: Discussion**
- v1 review by Mark Brown found that "WSA_RX0 Digital Volume" wouldn't
  match because the controls are prefixed. The author confirmed via
  amixer that v1 was a no-op. v2 fixes this.
- Reviewer comment from Srinivas: "Thanks Tobias for doing this, this
  has been long pending." — indicates the issue was known.
- Record: Maintainer explicitly says the safety limit "has been long
  pending"; thread does NOT mention stable nomination.

**Step 4.5: Stable list**
- Did not find a stable-list discussion of this specific patch (it's
  very new, applied 2026-04-22).
- The precedent commit (`c481016bb4f8` for sc8280xp) explicitly carried
  `Cc: <stable@vger.kernel.org> # 6.5`.
- Record: No explicit stable nomination in this thread; precedent
  supports stable suitability.

### PHASE 5: SEMANTIC ANALYSIS

**Step 5.1-5.4: Function context**
- Modified function: `x1e80100_snd_init()` (machine driver init
  callback).
- Caller: `snd_soc_link_init()` ASoC core, invoked once per DAI link
  during sound card registration on x1e80100/glymur/Hamoa-class devices.
- Calls into: `snd_soc_limit_volume()` (caps platform_max), then
  `qcom_snd_dp_jack_setup()`/`qcom_snd_wcd_jack_setup()`.
- Record: Reachable on every probe of the x1e80100 sound card; not in
  hot path (one-time init), but every user of the SoC executes it.

**Step 5.5: Similar patterns**
- `sound/soc/qcom/sc8280xp.c` already has the identical pattern (limits
  81 / 17 due to wsa881x amplifier scale) and is in stable since v6.8 —
  proof that the pattern works in older trees.
- Record: Direct precedent.

### PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code presence in stable**
- `sound/soc/qcom/x1e80100.c` exists since v6.8.
- WSA/WSA2 sound-name-prefix in DT exists since v6.10.
- 2-speaker board support (SpkrLeft/Right path used here as well as
  4-speaker) added in v6.13.
- Record: Patch is meaningful for stable trees v6.13+ (where both 2-spk
  and 4-spk paths exist). On v6.8–v6.12 the limit on 4-speaker controls
  would be a no-op (silent), but the digital volume limits would still
  apply. No harm to apply.

**Step 6.2: Backport complications**
- Patch adds new lines to a switch statement and a local `card` pointer.
  Should apply cleanly to any stable tree with x1e80100.c.
- The `snd_soc_limit_volume(card, ...)` API signature is unchanged
  across all relevant stable trees.
- Record: Clean apply expected.

**Step 6.3: Already-applied checks**
- No prior fix for this issue in x1e80100.c. The sc8280xp limit is in
  stable but it doesn't cover x1e80100.
- Record: This is the only fix.

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- ASoC machine driver for Qualcomm X1E80100 (used on Snapdragon X Elite
  laptops: Lenovo T14s Gen 6, Dell XPS 13 9345/Latitude 7455, HP
  EliteBook Ultra G1q, ASUS Vivobook S15, etc.)
- Criticality: PERIPHERAL (driver-specific) — but the affected user
  population is sizable: this is the audio for an entire popular laptop
  class.
- Record: Driver-specific, but affects a popular consumer hardware
  platform.

**Step 7.2: Activity**
- Active subsystem; multiple recent commits to qcom ASoC and x1e80100
  family.
- Record: Active.

### PHASE 8: IMPACT/RISK

**Step 8.1: Affected users**
- Linux users running stable kernels on Snapdragon X Elite laptops who
  use built-in speakers.
- Record: Driver-specific but real user base growing rapidly.

**Step 8.2: Trigger**
- Trigger: any user moving the volume slider above the safe threshold.
  Easy to hit in normal use.
- Unprivileged: yes (any user with audio access).
- Record: Routinely triggerable in normal desktop usage.

**Step 8.3: Failure mode severity**
- Reproduced effect: speakers shutoff requiring reboot (acknowledged by
  author on T14s).
- Suspected effect: potential permanent hardware damage.
- Severity: HIGH — physical hardware damage risk for end users with no
  current mitigation.
- Record: Hardware safety, HIGH severity.

**Step 8.4: Risk-benefit**
- Benefit: prevents a user-triggerable speaker damage / lockout on a
  popular laptop class.
- Risk: very low. 19-line, single-file, contained change.
  `snd_soc_limit_volume()` is best-effort; missing controls produce no
  error. Tested by the maintainer on real hardware. Backport precedent
  (sc8280xp) has been in stable for ~2 years without issue.
- The only "downside" is users who currently operate above 0 dB lose
  that headroom — but that's exactly the point (it was unsafe).
- Record: High benefit, very low risk.

### PHASE 9: SYNTHESIS

**Evidence FOR backport:**
- Hardware safety; "trivial to trigger" speaker shutdown / potential
  permanent damage.
- Direct precedent (`c481016bb4f8`) was explicitly Cc'd to stable for
  the same class of issue on a sister SoC.
- Small (19 lines), surgical, single function.
- Tested AND Reviewed by the qcom ASoC maintainer; v1->v2 review caught
  the silent-failure bug.
- API used has been stable for many years; applies cleanly to v6.8+
  stable trees.
- Falls under the "hardware quirk/workaround" exception listed in stable
  rules.

**Evidence AGAINST backport:**
- No explicit `Cc: stable` tag (per the prompt, this is NOT a negative
  signal — it's why we're reviewing).
- Behavior change: caps user-facing maximum volume.
- Not a code-level bug per se (it's a missing safety default).

**Stable rules check:**
1. Obviously correct and tested? YES (Tested-by maintainer, amixer-
   verified).
2. Fixes a real issue affecting users? YES (speaker damage / lockup on
   popular laptops).
3. Important issue? YES (hardware damage risk).
4. Small and contained? YES (19 lines, one file, one function).
5. No new features/APIs? YES (uses existing API; not a new feature).
6. Applies to stable? YES (clean apply expected; precedent exists).

**Exception category:** Falls under "hardware quirks/workarounds for
broken/limited devices" - explicitly called out as automatically YES in
stable rules.

### Verification

- [Phase 1] Parsed tags: confirmed Tested-by + Reviewed-by Srinivas
  Kandagatla, no `Cc: stable`, no `Fixes:`.
- [Phase 2] Diff inventory: 19 lines added, 0 removed; only
  `x1e80100_snd_init()` modified; verified by reading the diff.
- [Phase 2] Verified `snd_soc_limit_volume()` silently returns `-EINVAL`
  for unknown controls (read `sound/soc/soc-ops.c:488-510`).
- [Phase 3] `git log -- sound/soc/qcom/x1e80100.c`: identified
  6b9dc2da66578 introducing the file in v6.8.
- [Phase 3] `git tag --contains 6b9dc2da66578 | grep -E
  "^v[0-9]\.[0-9]+$"`: first stable v6.8.
- [Phase 3] `git tag --contains c481016bb4f8a | grep -E
  "^v[0-9]\.[0-9]+$"`: precedent landed in v6.8 (and was Cc'd to 6.5+).
- [Phase 3] `git show c481016bb4f8a`: confirmed precedent has explicit
  `Cc: <stable@vger.kernel.org> # 6.5`.
- [Phase 4] `b4 dig -c 0a5ee0e520eff`: confirmed lore URL
  https://lore.kernel.org/all/20260422-x1e80100-audio-
  limit-v2-1-333258b97697@canonical.com/.
- [Phase 4] `b4 dig -c 0a5ee0e520eff -a`: identified v1 (2026-04-21) and
  v2 (2026-04-22) — applied version is v2.
- [Phase 4] Read mbox of v1 and v2 threads: confirmed Mark Brown caught
  the missing prefix in v1; author confirmed via amixer that v1 was a
  no-op; v2 has correct names and was Tested+Reviewed by maintainer.
- [Phase 5] Confirmed `snd_soc_limit_volume()` API exists since v4.4
  (`git tag --contains 26d9ca3462df8`).
- [Phase 5] Confirmed `sound/soc/qcom/sc8280xp.c` uses the same pattern
  with 81 / 17 limits (read file).
- [Phase 6] Confirmed WSA/WSA2 sound-name-prefix has been in DT since
  v6.10 (commit c6d6df1703d47, `git tag --contains`).
- [Phase 6] 2-speaker support added in v6.13 (`159098859bf6d`);
  4-speaker existed earlier.
- [Phase 8] Severity HIGH justified by author's reproduced symptom (T14s
  speakers shut off until reboot) and risk of permanent hardware damage
  stated in cover letter.
- UNVERIFIED: Could not verify whether stable maintainers will need a
  separate maintainer request (no stable@ thread for this commit yet).
  Did not let this drive the decision.
- UNVERIFIED: Did not directly test the patch on a stable tree — applies
  cleanly per visual inspection.

### Decision

This is a small, well-tested hardware-safety patch that closely mirrors
a precedent (`c481016bb4f8`) which was explicitly nominated for stable.
It prevents a real, user-triggerable hazard (speaker hardware damage /
lockup) on a popular laptop class. It uses an existing, stable API and
falls under the "hardware quirks/workarounds" exception. The behavior
change (capping volume) is the entire point of the safety fix. Risk of
regression is very low because `snd_soc_limit_volume()` silently no-ops
on unknown control names.

**YES**

 sound/soc/qcom/x1e80100.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/sound/soc/qcom/x1e80100.c b/sound/soc/qcom/x1e80100.c
index a3f4785c4bbe6..c81df41ace883 100644
--- a/sound/soc/qcom/x1e80100.c
+++ b/sound/soc/qcom/x1e80100.c
@@ -27,10 +27,29 @@ static int x1e80100_snd_init(struct snd_soc_pcm_runtime *rtd)
 {
 	struct x1e80100_snd_data *data = snd_soc_card_get_drvdata(rtd->card);
 	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
+	struct snd_soc_card *card = rtd->card;
 	struct snd_soc_jack *dp_jack = NULL;
 	int dp_pcm_id = 0;
 
 	switch (cpu_dai->id) {
+	case WSA_CODEC_DMA_RX_0:
+	case WSA_CODEC_DMA_RX_1:
+		/*
+		 * Set limit of -3 dB on Digital Volume and 0 dB on PA Volume
+		 * to reduce the risk of speaker damage until we have active
+		 * speaker protection in place.
+		 */
+		snd_soc_limit_volume(card, "WSA WSA_RX0 Digital Volume", 81);
+		snd_soc_limit_volume(card, "WSA WSA_RX1 Digital Volume", 81);
+		snd_soc_limit_volume(card, "WSA2 WSA_RX0 Digital Volume", 81);
+		snd_soc_limit_volume(card, "WSA2 WSA_RX1 Digital Volume", 81);
+		snd_soc_limit_volume(card, "SpkrLeft PA Volume", 6);
+		snd_soc_limit_volume(card, "SpkrRight PA Volume", 6);
+		snd_soc_limit_volume(card, "WooferLeft PA Volume", 6);
+		snd_soc_limit_volume(card, "TweeterLeft PA Volume", 6);
+		snd_soc_limit_volume(card, "WooferRight PA Volume", 6);
+		snd_soc_limit_volume(card, "TweeterRight PA Volume", 6);
+		break;
 	case DISPLAY_PORT_RX_0:
 		dp_pcm_id = 0;
 		dp_jack = &data->dp_jack[dp_pcm_id];
-- 
2.53.0

