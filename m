Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6712461257C;
	Mon, 19 Oct 2026 14:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418640; cv=none; b=pIpGQ+9+VrT78OYH99+pvC/yL+Yz4O4iT19akubGUpMfVYcLt9uV3LGRbiuQWifF7im8YF4KWFjL7g7k5ZzNSS4ahwh020ylVfDuDMX2tYQ7tlqwORUHxD14uy1M3B3Y9s38xXKwdcovRfSh3qq027+yFfi4LWYmmTQCibym9Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418640; c=relaxed/simple;
	bh=r5s3InEchgvzp3m5zFOMXBo11KI1W/XUdhk/T3HSa7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uL/p5uzqdMYxPLfh421oN7UmHjlHkdtAop3wmTx3ACLj7+9Z/7Y2wy66J+tT/PjyYhPqiLzeDsXthGnWrWHWFfrsbn1AMEi/HJ6U1FtsjKFNofX4RrWvKEBuhGPWUAk+6c1RONLVoEtw2tVUijCzOXT2Xb2Un8dbat5LZYOpwCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/NQEzy0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/NQEzy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266391F000C6;
	Mon, 19 Oct 2026 14:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418638;
	bh=RpwoW7TM1a80u01aCDnUbBDnSWEjFDM2O80sxikozNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/NQEzy0VZ9FzibMz+BiyK1tSjkk8DCXXiPKi3hhKYJA4YrIT4ZeE72fk7OuOysu9
	 +lbsRhpftpHyzoB7+i4sfAA8WCKVEHpmlr4QFFhZaOyY22Xq/8rFrwF0+5JcFoI1Xz
	 bxxuLY8YpFXCMipVD3Zd6QhAZ/CF9GBKj77JBc+5HwEYRojw52uvMrHIKZcDumsD3F
	 3yN8UeNauPYvBIyvtj0SkfRYUjjc77o5/20hZMkJNhu5st9iV+lQV/ol5+ZhBQ8LAL
	 0v9GCar2R9x+51VwPudHar4f3qecBBbJOUWQNCbrdijQZLWgu/uSal2cjyEPk2jSFn
	 K2oZTi8dJq4/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: hda: Check snd_hda_power_pm construct error before executing verb
Date: Mon, 19 Oct 2026 09:51:22 -0400
Message-ID: <20261019135441.1420968-391-sashal@kernel.org>
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

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit df27e4dc80c4a30ad206432cb848aab00de22ca7 ]

When userspace writes 1 to /sys/bus/pci/devices/XX/remove to remove
HDA PCI device, the HDA hardware control path is shut down and devres
unmaps the BAR virtual address bus->remap_addr automatically during
driver removal.

If a delayed HDA verb command arrives after the MMIO region is
unmapped, the driver will access invalid virtual addresses and trigger
a page fault splat.

So add an error check right after constructing snd_hda_power_pm.

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260717024948.506335-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **7.3-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The HDA
`CLASS(snd_hda_power_pm)` path exists here, and this is a real page-
fault on PCI unbind. Analysis below is for this checkout only.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ALSA: hda:] [Check] [bail out of verb execution if
`snd_hda_power_pm` construction failed and the controller is already
stopped]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Bob Song <songxiebing@kylinos.cn>` (author)
- `Link: https://patch.msgid.link/20260717024948.506335-1-
  songxiebing@kylinos.cn` (v2 submission)
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA/HDA maintainer)
- No `Fixes:`, no `Reported-by:`, no `Tested-by:`, no `Cc: stable`
  (absence expected)
- Pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  ignored

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** After `echo 1 > /sys/bus/pci/devices/XX/remove`, the HDA
  control path is torn down and `devres` unmaps `bus->remap_addr`.
- **Symptom:** A later HDA verb still runs, touches the unmapped BAR,
  **page fault / splat**.
- **Root cause (author):** `CLASS(snd_hda_power_pm, pm)(codec)` can
  fail; the old code ignored `pm.err` and still called
  `snd_hdac_bus_exec_verb_unlocked()`.
- **Version info:** none in the message.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Explicit crash-avoidance check. The v1 lore text is
even clearer: constructor fails, code still issues verbs, then MMIO
after iounmap.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `sound/hda/common/codec.c` — **+6 / -0**
- Function: `call_exec_verb()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `CLASS(snd_hda_power_pm, pm)(codec)` then immediately
  `guard(mutex)` and `snd_hdac_bus_exec_verb_unlocked()` — `pm.err`
  unused.
- **After:** if `pm.err < 0 && !bus->core.chip_init`, warn and return
  `pm.err`; skip MMIO.
- Path: verb send after power-up, specifically when the controller is
  already stopped.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** memory-safety / invalid MMIO after teardown (page
  fault).
- **Mechanism:** `snd_hdac_bus_send_cmd_corb()` does
  `snd_hdac_chip_readw(bus, CORBWP)` via `bus->remap_addr` with **no
  `chip_init` guard**. `azx_send_cmd()` only checks `chip->disabled`.
  After `snd_hdac_bus_stop_chip()` sets `chip_init = false`, a delayed
  verb still MMIO’s the BAR. Power-up failure (`pm_runtime_get_sync`
  error while the device is going away) is the signal that hardware is
  no longer usable.
- **Note:** `CLASS` destructor still runs on the early return, so the
  `get`/`put` pair stays balanced (`pm_runtime_get_sync` still bumps the
  usage count on error).

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Quality:** Small, matches the header note (“If the error handling is
  needed, refer `pm.err`”). HDMI already checks `pm.err`
  (`sound/hda/codecs/hdmi/hdmi.c`).
- **Conservative:** both `pm.err < 0` **and** `!chip_init` — v1’s
  `pm_runtime_status_suspended()` false-positive on platform devices
  without RPM was why v1 was dropped.
- **Residual hole:** if power-up fails but `chip_init` is still true,
  verbs still run; if `chip_init` is false but power-up succeeded, verbs
  still run. Incomplete, not wrong.
- **Regression risk:** low for this v2 form. `codec_warn` on a teardown
  race is acceptable.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `CLASS(snd_hda_power_pm, pm)(codec)` introduced in **`8dad6b3dac279`**
  (“ALSA: hda/common: Use cleanup macros for PM controls”, 2025-08-29) —
  in this tree.
- Before that, `codec_exec_verb()` called `snd_hda_power_up_pm()` and
  **also ignored the return value** (`664c715573c2c`, 2015). Ignoring
  power-up failure is old; `pm.err` only became easy to check after
  CLASS.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Closest introducer of this exact shape is
`8dad6b3dac279` (CLASS refactor, “no functional changes”). Present in
this 7.3 tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Immediate parents of `call_exec_verb`: `8dad6b3dac279` (extract +
  CLASS), `62dd3851d2450` (`guard(mutex)`).
- Follow-ups on this file after the fix (`ba4239b6d8e1b`,
  `7284788743121`) are unrelated.
- Standalone 6-line patch, not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Bob Song is a regular HDA contributor (quirks, NULL checks), not
the maintainer. Maintainer is Takashi Iwai, who applied the patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs `CLASS(snd_hda_power_pm)` / `struct __hda_power_obj.err` from
  **`5d8c9c987fbdd`** + **`8dad6b3dac279`**.
- Needs `sound/hda/common/codec.c` (moved in **`05be28fe8521f`**,
  2025-07).
- **All of that is in this 7.3-rc4 tree.** Applies standalone here.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Lore (via `b4 dig`): https://patch.msgid.link/20260717024948.506335-1-
  songxiebing@kylinos.cn
- **v1** (2026-07-13): `pm.err < 0 && pm_runtime_status_suspended(...)`.
  Takashi applied, then **author asked to drop it**: platforms without
  RPM keep `runtime_status == suspended`, so verbs would be blocked.
  Takashi dropped it.
- **v2** (2026-07-17): `pm.err < 0 && !bus->core.chip_init`. Takashi:
  “Applied to for-next branch.” **This is the committed version.**
- **v3** (same day): only `!bus->core.chip_init` (no `pm.err`). **Not
  applied.**
- No NAKs on v2. No `Cc: stable` in review.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: To/Cc: Takashi Iwai, Jaroslav Kysela, linux-sound, linux-kernel.
Subsystem maintainer applied v2 after the v1 false-positive.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot. Trigger described as sysfs PCI `remove`. No
stack dump in the thread. **UNVERIFIED** how many users hit it beyond
the author (Kylinos).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone. HDMI already has similar `pm.err` checks;
ca0132/realtek CLASS sites were not changed.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned a bot wall (403).
**UNVERIFIED** whether stable@ already discussed this. No local `git log
--grep` hits besides this commit.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `call_exec_verb()`; helper for `codec_exec_verb()`.

**Step 5.2: TRACE CALLERS**
Record:
- `codec_exec_verb` is `codec->core.exec_verb`
  (`snd_hda_codec_device_new`).
- `snd_hdac_exec_verb()` uses that; fallback is
  `snd_hdac_bus_exec_verb()`.
- Reachable from mixer/jack/HDMI/proc/hwdep/regmap — **normal HDA I/O**,
  not an obscure helper.

**Step 5.3: TRACE CALLEES**
Record: `snd_hda_power_up_pm` → `pm_runtime_get_sync`;
`snd_hdac_bus_exec_verb_unlocked` → `bus->ops->command` (`azx_send_cmd`
→ `snd_hdac_bus_send_cmd_corb`) which **MMIO’s `remap_addr`**.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record:
- Everyday verbs: yes, from ALSA ioctls (often unprivileged for the
  audio device).
- **The crash path** is teardown: PCI `remove` / `snd_card_free` /
  `azx_free` → `azx_stop_chip()` (`chip_init = false`) then `pcim` BAR
  unmap. Needs a verb still in flight (jack work, unsol work, a racing
  ctl).
- `echo 1 > .../remove` is admin; **VFIO GPU passthrough** also unbinds
  the HDA function. Userspace-reachable as a privileged/hotplug path,
  not a syzbot syscall smash.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: HDMI already checks `pm.err`. USB mixer code widely checks
`pm.err < 0` after CLASS. This `call_exec_verb` site was the hole for
generic HDA verbs.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `sound/hda/common/codec.c` `call_exec_verb()` uses
CLASS; `chip_init` and `pm.err` exist. Parent of `df27e4dc80c4a` had no
check. Bug is this tree’s HDA code (CLASS era, ~6.18+; this is 7.3).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** on this tree: same function, same CLASS, same
`bus->core.chip_init`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier alternate fix. HDMI’s `pm.err` checks do not cover
`call_exec_verb`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **ALSA HD-audio codec core** (`sound/hda/common/`).
**IMPORTANT** — Intel/AMD/NVIDIA HDA is on most PCs, not core mm/sched.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (CLASS/guard cleanups, HDMI, Realtek). Maintainer-acked.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific** — HDA users who unbind/remove the PCI
function (sysfs remove, VFIO, hotplug, driver rebind). Not all boots.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Timing-dependent: delayed verb vs. chip stop / BAR unmap.
Privileged/hotplug, not a typical unprivileged mixer write while the
device is live.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Page fault / oops** (author; lore v1 said “page fault BUG”).
**Severity: HIGH** (oops on unbind; panic if `panic_on_oops`). Not
filesystem corruption.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** HIGH for unbind/VFIO/hotplug — avoids oops.
- **Risk:** LOW — 6 lines, v1 regression already filtered, maintainer
  applied v2.
- **Ratio:** favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real oops: MMIO after HDA BAR unmap / chip stop.
- `snd_hdac_bus_send_cmd_corb()` has no `chip_init`/`remap_addr`
  validity check — verified.
- 6-line, no new API, CLASS destructor still balances PM.
- Maintainer applied v2 after a real v1 false-positive on no-RPM
  platform devices.
- All prerequisites exist in **this** 7.3-rc4 tree.
- HDA + PCI unbind (including GPU audio / VFIO) is a real production
  path.

**AGAINST:**
- No stack trace, syzbot, or extra `Reported-by`.
- Trigger is teardown, not playback.
- Check is incomplete (`pm.err` XOR `chip_init`).
- v3 was not taken; v2 is what mainline has.

**UNRESOLVED:**
- Exact delayed-verb source (jack vs unsol vs racing ctl) not dumped.
- stable@ discussion unverified (lore blocked).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — v2 after v1 drop; maintainer
   applied.
2. Fixes a real bug that affects users? **PASS** — oops on PCI remove.
3. Important issue? **PASS** — kernel page fault / oops (HIGH, not idle
   WARN).
4. Small and contained? **PASS** — +6 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** —
   CLASS/`pm.err`/`chip_init`/`call_exec_verb` all present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID/quirk/DT/build/doc). It is a normal crash
fix.

**Step 9.4: MAKE YOUR DECISION**
For **this 7.3-rc4 tree**, the bug is present, the patch is self-
contained, and it prevents a verified MMIO-after-teardown oops. It meets
stable rules here.

**What it solves for this tree:** A delayed HDA verb after controller
stop / BAR unmap used to ignore `snd_hda_power_pm` failure and hit
unmapped MMIO. Skipping the verb when power-up failed **and**
`chip_init` is false stops that oops without the v1 “platform device
never left RPM_SUSPENDED” regression.

**Risk vs benefit:** Low risk, clear oops-avoidance benefit on
unbind/hotplug.

---

Verification:
- [Phase 1] Tags: author Bob Song; Link to v2 msgid; SOB Takashi Iwai;
  no Fixes/Reported-by/Cc:stable
- [Phase 1] Body: PCI sysfs `remove` → BAR unmap → delayed verb → page
  fault
- [Phase 2] Diff: +6 in `call_exec_verb()`; `pm.err < 0 &&
  !bus->core.chip_init` then return
- [Phase 2] `snd_hdac_bus_send_cmd_corb()` uses `snd_hdac_chip_readw` on
  `remap_addr` with no `chip_init` check (`sound/hda/core/controller.c`)
- [Phase 2] `azx_send_cmd()` only checks `chip->disabled`
- [Phase 2] Header documents `pm.err` (`include/sound/hda_codec.h`)
- [Phase 2] CLASS destructor still `snd_hda_power_down_pm` on early
  return (RAII)
- [Phase 3] Blame: CLASS in `8dad6b3dac279` (2025-08-29); this tree has
  it (`git merge-base --is-ancestor` 0)
- [Phase 3] Pre-CLASS `codec_exec_verb` also ignored
  `snd_hda_power_up_pm()` return (`git show 8dad6b3dac279`)
- [Phase 3] CLASS macros: `5d8c9c987fbdd`; file move: `05be28fe8521f`;
  both in this tree
- [Phase 3] No follow-up fix of this check after `df27e4dc80c4a`
- [Phase 4] `b4 dig -c df27e4dc80c4a`: v1/v2/v3; committed = v2
- [Phase 4] mbox: v1 applied then dropped (no-RPM platform false
  positive); v2 applied; v3 not applied
- [Phase 4] Recipients: tiwai, perex, linux-sound
- [Phase 4] lore WebFetch 403; stable@ search unverified (bot wall)
- [Phase 5] `codec_exec_verb` set as `codec->core.exec_verb`; used via
  `snd_hdac_exec_verb`
- [Phase 5] HDMI already checks `pm.err` (`hdmi.c`)
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] Pre-image of `call_exec_verb` confirmed via `git show
  df27e4dc80c4a^:sound/hda/common/codec.c`
- [Phase 6] `azx_free()` stops chip when `bus->chip_init` (`intel.c`);
  `azx_remove()` → `snd_card_free`
- [Phase 8] Failure mode: page fault on unmapped BAR; trigger: PCI
  remove / unbind
- UNVERIFIED: exact delayed-verb producer; number of users; stable@
  thread

The fix is small, matches this tree’s CLASS-based HDA code, and prevents
a real oops on device teardown.

**YES**

 sound/hda/common/codec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/hda/common/codec.c b/sound/hda/common/codec.c
index 8cab932177194..7869f673894fe 100644
--- a/sound/hda/common/codec.c
+++ b/sound/hda/common/codec.c
@@ -39,6 +39,12 @@ static int call_exec_verb(struct hda_bus *bus, struct hda_codec *codec,
 	int err;
 
 	CLASS(snd_hda_power_pm, pm)(codec);
+	if (pm.err < 0 && !bus->core.chip_init) {
+		codec_warn(codec,
+			   "Failed to send cmd 0x%x ret=[%d], hda control stopped\n",
+			   cmd, pm.err);
+		return pm.err;
+	}
 	guard(mutex)(&bus->core.cmd_mutex);
 	if (flags & HDA_RW_NO_RESPONSE_FALLBACK)
 		bus->no_response_fallback = 1;
-- 
2.53.0

