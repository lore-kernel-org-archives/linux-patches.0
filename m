Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14F15458D2;
	Mon, 19 Oct 2026 14:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418801; cv=none; b=BQNd4m8BkS7RygiRyDFYb5R+MHAIvd9mKPFbzbKD8XxVYM3fcirTMK7h19LyOhfQY9U5hUezssZDf8GMo+dnlQ9DtOhRnBgvdbZzA9IvJ2GqFN2KUXyttLVR0usnibgm5HkunxdGA9pwBpudCER5uzfw1xnSaSzqKkLo3uWTk3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418801; c=relaxed/simple;
	bh=95qOH47L2e8gemey/UZsgmcWb0tqdDJwAaVk7WWxsC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BsAf/KQqv5GEvBOmhpVUh6pzA06eJCtC5bYsTID+mF4frFg3Fs9kgvqiHpA5ClyTZaIlKuhPUbLZJm0tQE9jrUjsqsVSDyt6EIEnte2lcMbzZSiJFrHxJQREvjXwXOlykNNZyrkXeHtr8RQ6PNHyAv85jIUD4+P7dZhUQSE8lvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dK8YCNLl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dK8YCNLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846B61F000C8;
	Mon, 19 Oct 2026 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418798;
	bh=qt8rAXV5w9aLTSVZK04czmnAvYtGQvH2a2vUMCv+/Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dK8YCNLlgN+U2dOydTM0q5VqujOSLIiPPqjCRCoO5BpYmxwdWIZwL2TEnnyDSO0oY
	 L2ihe3XKyVPN6Wn04ZsxlEqJWVGlT3lHQ3IIwOXQPZRMcD/Ikkt0wkiSfaEq3Z1T54
	 rN16OT5Ky/5wi5pHR4CEO6ns69CwTlM52Fh2H9zarseAN01tCz2jbzkTOXX3I5El3Z
	 Vl1wgI+mU+V8Qr1FegTOI+U4vPEznmgrzwG/y3jgYRzkUkATMVWPYkBkYf1Qyx+G0m
	 nt00PPr9RropVWvJbIFXsZhChkEhEhGYiXHN+qkgCXOPjN3/PkjN3iEBQjTKSPLJOi
	 0292q9rxQLnjg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ASoC: hdac_hdmi: Fix resource cleanup on probe failure
Date: Mon, 19 Oct 2026 09:53:15 -0400
Message-ID: <20261019135441.1420968-504-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 785903b7770f19ea05b8a76081dff691c56fa771 ]

hdac_hdmi_dev_probe() gets the HDA link before allocating and
initializing the HDMI codec private data. Several later error
paths return directly without dropping the link reference,
leaving the hlink refcount unbalanced.

Release the link reference on probe failures. Also turn display
power off if the failure happens after it has been enabled.

This issue was dicussed in:
https://lore.kernel.org/all/s5h1s0esk8o.wl-tiwai@suse.de/
I think the paths fixed here are probe failure paths: the device
has not been fully initialized or bound, and runtime PM suspend
cannot be relied on to balance the reference taken during probe.

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20260622151127.1198196-1-haoxiang_li2024@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a small probe-error-path leak fix in the Intel HDMI HDAC codec.
The buggy code is present in this 6.18.53 tree, the change is surgical,
and it should be backported.

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[ASoC / hdac_hdmi] [Fix] resource cleanup on probe failure`

**Step 1.2 — Tags**
Record:
- No `Fixes:` tag (expected for this review queue)
- No `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, or `Cc:
  stable`
- `Link: https://patch.msgid.link/20260622151127.1198196-1-
  haoxiang_li2024@163.com`
- Body also cites `https://lore.kernel.org/all/s5h1s0esk8o.wl-
  tiwai@suse.de/` (Takashi Iwai, 2019)
- `Signed-off-by: Haoxiang Li` (author)
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (ASoC maintainer)
- Ignore pipeline `Signed-off-by: Sasha Levin` and `[Upstream commit
  785903b7770f...]`

**Step 1.3 — Body**
Record:
- **Bug:** `hdac_hdmi_dev_probe()` takes an HDAC link ref
  (`snd_hdac_ext_bus_link_get`) then returns on later errors without
  `snd_hdac_ext_bus_link_put`. After `snd_hdac_display_power(...,
  true)`, parse failure also leaves display power held.
- **Symptom:** Unbalanced `hlink->ref_count` (link stays powered) and
  possibly a stuck i915/display audio power well.
- **Root cause (author):** Probe-failure paths never bind the driver, so
  runtime PM suspend cannot drop the probe-time ref.
- **Version info:** None in the message. History puts the leak in this
  driver since link management was added (~v4.7).

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. Explicit leak fix on error paths.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `sound/soc/codecs/hdac_hdmi.c` (+8 / −2)
- Function: `hdac_hdmi_dev_probe()`
- Scope: single-file surgical error-path fix

**Step 2.2 — Flow change**
Record (verified against v6.18.53 and the patch):
1. After `snd_hdac_ext_bus_link_get()`:
   - **ENOMEM** (`devm_kzalloc` fails): was `return -ENOMEM` → now
     `link_put` then return
   - **`!hdac_id`:** was `return -ENODEV` → now `link_put` then return
   - **`hdac_hdmi_parse_and_map_nid()` fails:** was log + `return ret`
     after `snd_hdac_display_power(..., true)` → now `link_put` +
     `snd_hdac_display_power(..., false)` then return
2. Success / `devm_snd_soc_register_component` path already did
   `link_put`. Unchanged.

**Step 2.3 — Bug mechanism**
Record: **Error-path resource leak** (link refcount + display power
ref). `snd_hdac_ext_bus_link_get()` increments `hlink->ref_count` and
powers the link at 0→1. Matching `put` powers it down at 1→0. Probe
failure skipped that put. `snd_hdac_display_power(..., true)` sets
`display_power_status` and may call DRM `get_power`; without `false`,
that well can stay on.

**Step 2.4 — Fix quality**
Record: Obviously correct: every new `put`/`display_power(false)` is on
a path that already took the matching get/enable and does not reach the
existing success-path `put`. No API/lock/structure changes. Remaining
gap (not introduced here): if `devm_snd_soc_register_component()` fails,
`link_put` already runs but display power is still left on. That does
not make this patch wrong.

## Phase 3: Git history

**Step 3.1 — Blame**
Record:
- Link get in this probe: `b2047e996cd88` (“ASoC: hdac_hdmi: add link
  management”), contained in **v4.7-rc1**. Error returns after get were
  already unbalanced.
- Display power enable: `4f799e734094f0` (Takashi Iwai), contained in
  **v5.0-rc1**.
- Buggy pattern has been in this file for many years, including this
  6.18.y tree.

**Step 3.2 — Fixes: tag**
Record: None. Introducer is `b2047e996cd88` (link get without error-path
put). That commit is an ancestor of this tree.

**Step 3.3 — File history**
Record: Recent `hdac_hdmi.c` work is lock `guard()` conversion, enum
validation, logging. No prerequisite refactor for this fix. `git diff
v6.18.53 0754884332e60^ -- sound/soc/codecs/hdac_hdmi.c` is empty: probe
text at v6.18.53 matches the pre-patch parent.

**Step 3.4 — Author**
Record: Haoxiang Li has several ASoC probe-leak fixes here, including
`e8ea01a045708` (“ASoC: hdac_hda: Fix hlink refcount leak on component
registration failure”), which **did** carry `Fixes:` + `Cc: stable` and
is already in this tree. Same bug class, sibling driver.

**Step 3.5 — Dependencies**
Record: None. Uses existing `snd_hdac_ext_bus_link_put` /
`snd_hdac_display_power`. Standalone.

## Phase 4: Mailing list / external

**Step 4.1 — Original thread**
Record:
- `b4 dig -c 785903b7770f`: https://patch.msgid.link/20260622151127.1198
  196-1-haoxiang_li2024@163.com
- Single revision (v1 only, `-a`)
- Thread: patch + Mark Brown apply to `for-7.3`. No NAK, no requested
  respin.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: Liam Girdwood, Mark Brown, Jaroslav Kysela, Takashi Iwai,
Cirrus, Kuninori Morimoto, `linux-sound`, `linux-kernel`. Right
ASoC/ALSA maintainers.

**Step 4.3 — Cited 2019 discussion**
Record: MARC copy of `s5h1s0esk8o.wl-tiwai@suse.de` (2019-05-31).
Ranjani Sridharan noted hdac_hdmi had a similar unbalanced link ref.
Takashi said hdac_hdmi is different because it balances via runtime PM
(put in suspend, get in resume), and he was unsure about removal vs
suspend. He called the code “a bit too fragile.” This 2026 patch
correctly treats **probe failure** as unbound, so runtime suspend cannot
be assumed. That matches `hdmi_codec_probe()`, which documents relying
on `pm_runtime_put` only after a successful component probe.

**Step 4.4 — Series**
Record: Standalone `[PATCH]`, not `n/m`. Sibling hdac_hda leak fix sent
the same day.

**Step 4.5 — stable@**
Record: **UNVERIFIED** (lore.kernel.org returns 403 here). No stable
nomination in the saved mbox.

## Phase 5: Code semantics

**Step 5.1 — Functions**
Record: `hdac_hdmi_dev_probe()` only.

**Step 5.2 — Callers**
Record: `hdmi_driver.probe`, registered by `hdmi_init()` →
`snd_hda_ext_driver_register()`. Runs on HDAC enumeration of Intel HDMI
IDs 0x80862809–0x8086280d (Skylake / Broxton / Kaby Lake / Cannon Lake /
Gemini Lake). Boot/device-probe path, not a syscall hot path.

**Step 5.3 — Callees**
Record: `snd_hdac_ext_bus_get_hlink_by_name`,
`snd_hdac_ext_bus_link_get/put`, `snd_hdac_display_power`,
`hdac_hdmi_parse_and_map_nid` (can return `-EINVAL`/`-EIO`/`-ENOMEM` on
bad topology or alloc failure), `devm_snd_soc_register_component`.

**Step 5.4 — Reachability**
Record: Yes, if `CONFIG_SND_SOC_HDAC_HDMI` is built and the module
binds. Parse failure is a real probe error (`HDMI: failed to get afg sub
nodes`, `Bad pin/cvt setup`). Unprivileged users do not trigger it
directly; boot/bind does.

**Step 5.5 — Similar patterns**
Record: Same leak class in `hdac_hda_dev_probe` (already fixed with Cc:
stable). `hdmi_codec_probe()` still has its own error-path link_get
without put if widget map / notifier registration fails; that is **not**
this commit.

## Phase 6: This tree (6.18.53)

**Step 6.1 — Buggy code present?**
Record: **Yes.** `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`;
`Makefile` is 6.18.53. At `v6.18.53`, `hdac_hdmi_dev_probe()` gets the
link then returns on ENOMEM / `!hdac_id` / parse failure with no put
(and no display power off on parse failure). Bug introduced ~v4.7, not
after 6.18 branched.

**Step 6.2 — Backport difficulty**
Record: **Clean apply.** `patch --dry-run` of this diff onto
`v6.18.53:sound/soc/codecs/hdac_hdmi.c` succeeded. No intervening probe
rewrite.

**Step 6.3 — Related fixes already here?**
Record: No other hdac_hdmi probe-leak fix. Sibling `hdac_hda` leak fix
is already in this tree; it does not cover this file.

## Phase 7: Subsystem context

**Step 7.1**
Record: ASoC codec driver (`sound/soc/codecs/hdac_hdmi.c`).
**IMPORTANT** for Intel HDMI audio on SKL–GLK, not core mm/net.
`SND_SOC_HDAC_HDMI` is a hidden `tristate` implied by
`SND_SOC_ALL_CODECS`; this tree has no board `select SND_SOC_HDAC_HDMI`
(SOF uses `SND_SOC_HDAC_HDA`). Distros that enable all codecs still ship
the module, and it still matches those HDMI codec IDs.

**Step 7.2**
Record: File is mature (2015–); recent commits are small fixes, not a
rewrite.

## Phase 8: Impact and risk

**Step 8.1 — Who**
Record: Users of this HDMI HDAC codec (Intel SKL/BXT/KBL/CNL/GLK ASoC
HDMI), and only when **probe fails**. Not universal.

**Step 8.2 — Trigger**
Record: Failed `hdac_hdmi_dev_probe` after `link_get`: ENOMEM, ID lookup
miss, or `hdac_hdmi_parse_and_map_nid` failure. Once per failed bind,
not a hot path. Not a userspace-triggered security issue.

**Step 8.3 — Failure mode**
Record: HDAC link ref never drops → link stays powered; display power
bit/get_power may stay held → GPU/audio power well may not idle.
**Severity: MEDIUM–HIGH** (power-management leak / stuck resource, not
oops/corruption). HDMI audio already failed on that path; leftover refs
can still affect the controller and display PM.

**Step 8.4 — Risk vs benefit**
Record:
- Benefit: balances refs on real probe-error paths; prevents stuck
  link/display power.
- Risk: very low (error path only, matching put/power-off, no locking
  change).
- Ratio: favorable for stable.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

For:
- Real unbalanced `hlink` refcount and display-power hold on probe
  failure (verified in v6.18.53 source and `link_get`/`display_power`
  implementations).
- Probe failure cannot rely on runtime suspend (verified: PM
  enable/`pm_runtime_put` is in `hdmi_codec_probe`, after successful
  bind).
- Tiny (+8/−2), obviously correct, applies cleanly here.
- ASoC maintainer applied it; 2019 maintainer thread already flagged the
  fragility.
- Same-week sibling hdac_hda leak fix was treated as stable material.

Against:
- Probe-error path only; no crash/corruption/CVE.
- No `Reported-by` of a field failure.
- Display power still leaked if component registration fails (pre-
  existing, incomplete).
- Driver is less central in 6.18 than in Skylake-SST days (SOF uses
  hdac_hda).

Unresolved:
- Could not search lore.kernel.org/stable (HTTP 403).
- No direct evidence of how often parse-and-map fails on shipping
  SKL–GLK machines.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — mechanical matching
   put/power-off; maintainer applied. No extra Tested-by.
2. Real bug affecting users? **PASS** — leftover link/display power
   after failed HDMI codec probe.
3. Important (crash/security/corruption/deadlock)? **PASS** (lower end)
   — not an oops, but a stuck PM ref that can keep an HDA link and
   display audio power well on; same class as other probe-path leak
   backports.
4. Small and contained? **PASS** — one function, 10 lines.
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS** — buggy code in 6.18.53, clean apply.

**Step 9.3 — Exception category**
Record: None (not a device ID/quirk/DT/build/doc-only change). Ordinary
error-path leak fix.

**Step 9.4 — Decision**
The leak is real in this checkout, the fix is minimal and correct, and
regression risk is confined to paths that already failed probe. That is
appropriate for 6.18.y.

### What it solves for stable users
On Intel HDMI HDAC probe failure, this tree currently leaves
`snd_hdac_ext_bus_link_get()` unmatched and can leave
`snd_hdac_display_power(..., true)` unmatched. That keeps the HDAC link
(and possibly the i915 audio power well) up for the life of the boot.
The patch drops those refs on the failing paths.

### Risk vs benefit
Benefit is restoring power/ref balance when HDMI codec init fails. Risk
is very low: no success-path or locking change.

---

Verification:
- [Phase 1] Parsed tags: no Fixes/Cc-stable/Reported-by; Link to msgid
  20260622151127; Mark Brown SOB; body cites Takashi 2019 thread
- [Phase 2] Diff: +8/−2 in `hdac_hdmi_dev_probe()`; puts on ENOMEM,
  !hdac_id, parse failure; display_power(false) on parse failure
- [Phase 2] Confirmed `snd_hdac_ext_bus_link_get/put` in
  `sound/hda/core/ext/controller.c` power the link on 0↔1 refcount
- [Phase 2] Confirmed `snd_hdac_display_power()` in
  `sound/hda/core/component.c` holds DRM get_power while bits are set
- [Phase 3] `git describe HEAD`: v6.18.53-5049-g0f0bdc2b0dffb; `make
  kernelversion` / Makefile: 6.18.53
- [Phase 3] Blame: link get from `b2047e996cd88` (v4.7); display power
  from `4f799e734094f0` (v5.0)
- [Phase 3] `git show v6.18.53:sound/soc/codecs/hdac_hdmi.c`: buggy
  returns present; parent of candidate identical to v6.18.53 for this
  file
- [Phase 3] Sibling `e8ea01a045708` (hdac_hda leak) is an ancestor of
  HEAD and had Cc: stable
- [Phase 4] `b4 dig -c 785903b7770f`: v1 only; applied by Mark Brown to
  for-7.3; no NAK in mbox
- [Phase 4] MARC: Takashi 2019 mail `s5h1s0esk8o.wl-tiwai@suse.de` on
  runtime-PM vs hdac_hdmi link refs
- [Phase 5] `hdac_hdmi_dev_probe` is `hdmi_driver.probe`; IDs
  0x80862809–0x8086280d
- [Phase 5] `hdac_hdmi_parse_and_map_nid` can return -EINVAL/-EIO and
  alloc errors
- [Phase 6] `patch --dry-run` onto v6.18.53 file: success
- [Phase 6] Upstream `785903b7770f` is not an ancestor of v6.18.53 (fix
  not already in the stable base)
- [Phase 8] Failure mode: stuck HDAC link / display power after failed
  probe, not oops
- UNVERIFIED: lore.kernel.org WebFetch/curl 403; no stable@ archive
  search
- UNVERIFIED: field frequency of `hdac_hdmi_parse_and_map_nid` failures
  on 6.18 hardware

**YES**

 sound/soc/codecs/hdac_hdmi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/hdac_hdmi.c b/sound/soc/codecs/hdac_hdmi.c
index 2385e18127a33..1ca5e7aa42aca 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -1861,8 +1861,10 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	snd_hdac_ext_bus_link_get(hdev->bus, hlink);
 
 	hdmi_priv = devm_kzalloc(&hdev->dev, sizeof(*hdmi_priv), GFP_KERNEL);
-	if (hdmi_priv == NULL)
+	if (hdmi_priv == NULL) {
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 		return -ENOMEM;
+	}
 
 	snd_hdac_register_chmap_ops(hdev, &hdmi_priv->chmap);
 	hdmi_priv->chmap.ops.get_chmap = hdac_hdmi_get_chmap;
@@ -1871,8 +1873,10 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	hdmi_priv->chmap.ops.get_spk_alloc = hdac_hdmi_get_spk_alloc;
 	hdmi_priv->hdev = hdev;
 
-	if (!hdac_id)
+	if (!hdac_id) {
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 		return -ENODEV;
+	}
 
 	if (hdac_id->driver_data)
 		hdmi_priv->drv_data =
@@ -1897,6 +1901,8 @@ static int hdac_hdmi_dev_probe(struct hdac_device *hdev)
 	if (ret < 0) {
 		dev_err(&hdev->dev,
 			"Failed in parse and map nid with err: %d\n", ret);
+		snd_hdac_ext_bus_link_put(hdev->bus, hlink);
+		snd_hdac_display_power(hdev->bus, hdev->addr, false);
 		return ret;
 	}
 	snd_hdac_refresh_widgets(hdev);
-- 
2.53.0

