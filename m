Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D955AEC66;
	Mon, 19 Oct 2026 14:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418513; cv=none; b=lJNHoDb3PdkgtlPIlhTIoD/92llhyheNazNZrXjwdxlPzmW+LfSiKLdtwuqCdsXRscTYKvvXHkkULG8PeCmkdSSUe+mUZHR9n6gD78VemahX5Dr0lWHZev+tPWz8J7kSSfnazyrFHJb7mpQWoKLXgmvE2b2B26KZLJYsjoEuqt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418513; c=relaxed/simple;
	bh=e4spfmLej0LJn/PLxt+k1zT8YDPCKUhYiCaG+TAVRQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YxRmtfL5zp94WHA9E1gvuxjwL0BJAzXbXTzKROdlPAB8qZSTgAwU6AZETi1A9i7HZviREtWK5T/6Dq9twVwgJlK5e+Li9V/LW5Q2frkPrrw2DfaWKVrf8MJ3MK1L2Qe7bDGhsgzBEjv9h7KOENoD8DtsPiu7wvQ0dRN5B4mHCr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qb6PW6PL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qb6PW6PL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8591F000C4;
	Mon, 19 Oct 2026 14:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418511;
	bh=l22djysCyKDJNS3uoV8CRlZhZzAYaynwJDAFk8wMj4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qb6PW6PLcS/zR+gvx2SjYoKSexCatEEaEw1jOvklDtgXCC69XzR7r8YjD6ujR85Md
	 z4UyGLiHRdHChcmaMDA+9t5Pd+i5RFf/9DAnwBgboijbWFBNAVACETEGJCc0n5KOe2
	 aOG3LVhjWd8fLd6gM8mgphGkyYKgaHtcw/kmn+WCERHck0vLTdiRJWgYglhmyRnX2C
	 dIG1kuGsphCrC6AWxatMer1SWbA5P+0fsRMGlSyHyKMdVfsiG7X1dTZx+AjFKUoMfL
	 mFpAdfAmVwRWNtgFbOlB0HOPevIlHkHpqNFAf60HKPd7/rbKzhZuBI7EJ7OAb8L+Ix
	 oK9g33UlTOEKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com,
	syzbot+5ebe7cd17e48b4293660@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/intel: Add sanity check for BAR0 size
Date: Mon, 19 Oct 2026 09:49:51 -0400
Message-ID: <20261019135441.1420968-300-sashal@kernel.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9895573b0185f922be4cf500a0f2e5b9560ab1c3 ]

The recent reports from syzkaller showed that we can bind any wild PCI
device to HD-audio controller, and if PCI BAR of the device is too
small, it may lead to a crash, as the driver believes as if the full
register range were accessible.

For avoiding such a problem, add a safeguard before the actual probe
to check the available BAR0 size.

Note that the threshold (0x200) is chosen to cover all needed
registers at probing.  But this doesn't mean that it would cover fully
for all features including the extended ones.

Reported-by: syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=10cd2d1efe8eeb604bee
Reported-by: syzbot+5ebe7cd17e48b4293660@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5ebe7cd17e48b4293660
Link: https://patch.msgid.link/20260813150354.763502-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[ALSA: hda/intel] [Add] sanity check for BAR0 size` — safeguard
in the Intel HD-audio PCI probe path.

**Step 1.2: Tags**
Record:
- `Reported-by: syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com`
- `Closes: https://syzkaller.appspot.com/bug?extid=10cd2d1efe8eeb604bee`
- `Reported-by: syzbot+5ebe7cd17e48b4293660@syzkaller.appspotmail.com`
- `Closes: https://syzkaller.appspot.com/bug?extid=5ebe7cd17e48b4293660`
- `Link: https://patch.msgid.link/20260813150354.763502-1-tiwai@suse.de`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer;
  applied his own patch)
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- No `Reviewed-by` / `Tested-by` / `Acked-by`

Notable: two independent syzbot reports with C reproducers.

**Step 1.3: Body**
Record:
- **Bug:** binding a non-HD-audio / undersized-BAR PCI device to `snd-
  hda-intel` lets the driver treat BAR0 as a full HD-audio register
  window.
- **Symptom:** kernel paging oops while reading controller registers.
- **Root cause:** no check of `pci_resource_len(pci, 0)` before
  `pcim_iomap_regions` + MMIO reads.
- **Fix:** reject probe if BAR0 < `0x200`.
- **Caveat:** `0x200` covers probe-time registers (GCAP at `0x00`, LLCH
  at `0x14`), not the full extended register set.
- No version range given.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. It is an explicit crash-prevention check, even
though the verb is “Add”.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- Upstream file: `sound/hda/controllers/intel.c` (+9 / −0)
- Function: `azx_probe()`
- Scope: single-file surgical check before `snd_card_new()`

**Step 2.2: Code flow**
Record:
Before: after the `dmic_detect` / DSP-driver selection block, probe
continues into `snd_card_new()` → `azx_create()` → later
`azx_first_init()`, which iomaps BAR0 and reads registers with no size
check.
After: if BAR0 length < 512 bytes, log `"Too small PCI BAR0"` and return
`-EINVAL` before allocating a card.

**Step 2.3: Bug mechanism**
Record: **Memory safety / out-of-bounds MMIO**. `pcim_iomap_regions()`
maps whatever BAR0 exists. `azx_readw(GCAP)` and
`snd_hdac_bus_parse_capabilities()` then `readw` past the mapping →
`#PF` / oops. Category (g)+(h): logic/correctness guard plus a
hardware/binding sanity check.

**Step 2.4: Fix quality**
Record: Obviously correct. `pci_resource_len()` is the standard helper.
`0x200` is well below a real HD-audio BAR (typically 16KB / `0x4000` per
spec); legitimate devices will not be rejected. Regression risk is very
low: only devices with BAR0 < 512 bytes fail probe, which could not work
anyway. Incomplete vs. every later register (author notes that); still
sufficient for the reported oops.

## Phase 3: Git history

**Step 3.1: Blame**
Record: Insertion point is immediately before `snd_card_new()` in
`azx_probe()`, blamed to Takashi Iwai 2014 (`60c5772b50fe`) / original
driver era (`e58de7baf7de`, `^1da177e4c3f41`). The missing BAR check is
not a recent regression; the driver has always assumed a full controller
BAR.

**Step 3.2: Fixes: tag**
Record: None. The “bug” is long-standing missing validation, not a
single introducing commit.

**Step 3.3: File history**
Record: Recent `hda_intel.c` commits in this tree are device IDs,
denylist, and PM quirks. No prior BAR0 size check, no conflicting
refactor of `azx_probe()`. Standalone, not patch X/Y.

**Step 3.4: Author**
Record: Takashi Iwai is the ALSA/HDA maintainer. He authored and
committed the patch the same day (2026-08-13). Strong maintainer signal.

**Step 3.5: Dependencies**
Record: None. Uses `pci_resource_len()` (`include/linux/pci.h` in this
tree). Surrounding `azx_probe()` context (dmic_detect warning, then
`snd_card_new`) matches this checkout. Standalone.

Upstream SHA `9895573b0185` exists as an object but is **not** an
ancestor of HEAD (`git merge-base --is-ancestor` exit 1).

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record: `b4 dig -c 9895573b0185` →
https://patch.msgid.link/20260813150354.763502-1-tiwai@suse.de
`b4 dig -a`: **v1 only**, no later revisions.
`b4 dig -m`: thread is the single patch email; **no replies, no NAK, no
Cc: stable suggestion**. Maintainer self-applied (~1 hour later).

Lore WebFetch returned 403; discussion was recovered from the b4 mbox
instead.

**Step 4.2: Recipients**
Record (`b4 dig -w`): `Takashi Iwai`, `linux-sound@vger.kernel.org`
only. Appropriate list; author is the maintainer.

**Step 4.3: Bug reports**
Record (syzkaller, both marked **prio:high**, C repro, fix commit
`9895573b0185`):

1. `extid=10cd2d1efe8eeb604bee` — `BUG: unable to handle kernel paging
   request in snd_hdac_bus_parse_capabilities`
  RIP: `readw` of LLCH (`+0x14`) in `snd_hdac_bus_parse_capabilities`;
  caller `azx_first_init` → `azx_probe_work`.
  Security notes: DenialOfService yes, Exploitable yes, Unprivileged no,
  PeripheralTrigger yes, VMHostTrigger yes.

2. `extid=5ebe7cd17e48b4293660` — `BUG: unable to handle kernel paging
   request in azx_probe_work`
  RIP: `azx_readw(GCAP)` in `azx_first_init`. Same workqueue path. DoS
  yes, unprivileged no.

**Step 4.4: Series**
Record: Standalone v1. No sibling patches required.

**Step 4.5: Stable list**
Record: lore.kernel.org/stable WebFetch 403. UNVERIFIED: no independent
confirmation of a prior stable request/rejection. Absence of `Cc:
stable` is expected for this review pipeline.

## Phase 5: Semantic / call-chain

**Step 5.1: Functions**
Record: `azx_probe()` only (new early return). Crash site functions
unchanged: `azx_first_init()`, `snd_hdac_bus_parse_capabilities()`.

**Step 5.2: Callers**
Record: `azx_probe` is `azx_driver.probe`
(`module_pci_driver(azx_driver)`). Invoked on PCI bind of matching IDs,
including the generic Intel class match:

```2595:2599:sound/pci/hda/hda_intel.c
        /* Generic Intel */
        { PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_ANY_ID),
          .class = PCI_CLASS_MULTIMEDIA_HD_AUDIO << 8,
          .class_mask = 0xffffff,
          .driver_data = AZX_DRIVER_ICH | AZX_DCAPS_NO_ALIGN_BUFSIZE },
```

Similar class catch-alls exist for NVIDIA/ATI/AMD. Binding also works
via sysfs `new_id` / `driver_override` (privileged).

**Step 5.3: Callees of the crash path (this tree)**
Record: `azx_first_init()` does `pcim_iomap_regions(pci, 1 << 0, ...)`,
then `snd_hdac_bus_parse_capabilities(bus)` for SKL, then
`azx_readw(chip, GCAP)` at offset `0x00`.
`snd_hdac_bus_parse_capabilities()` starts with
`snd_hdac_chip_readw(bus, LLCH)` at `0x14`. `pcim_iomap_regions()` does
**not** require a minimum size.

**Step 5.4: Reachability**
Record: PCI probe / `azx_probe_work` workqueue. Reachable from:
- automatic bind of class `0x0403` devices (including fuzzed/malformed
  PCI devices)
- privileged `new_id` / `driver_override`
Not a normal unprivileged syscall. Still a real kernel oops, including
in VMs (syzbot’s environment).

**Step 5.5: Similar patterns**
Record: Other ALSA PCI drivers already reject tiny BARs (e.g.
`sound/pci/oxygen/oxygen_lib.c` compares `pci_resource_len(pci, 0) <
OXYGEN_IO_SIZE`). HDA Intel was missing that class of check. This commit
does not touch `hda_tegra.c`.

## Phase 6: This tree (6.12.y)

**Step 6.1: Buggy code present?**
Record: **Yes.** Local tree is **6.12.111** (`p-6.12-3-gc504cf0baa3d8`).
File is `sound/pci/hda/hda_intel.c` (pre-rename). `azx_probe()` at 2116
has the same dmic_detect block and goes straight to `snd_card_new()`
with **no** BAR0 check. `azx_first_init()` at 1854 performs the same
iomap + GCAP/capability MMIO. `"Too small PCI BAR0"` is absent.

**Step 6.2: Backport difficulty**
Record: **Clean apply after path remap**
(`sound/hda/controllers/intel.c` → `sound/pci/hda/hda_intel.c`). Hunk
context is identical. No data-structure or helper prerequisites.

**Step 6.3: Related fixes already here?**
Record: No. `git log --grep` on those paths found no BAR0 sanity check.
`9895573b0185` is not an ancestor of HEAD.

## Phase 7: Subsystem context

**Step 7.1**
Record: ALSA HD-audio PCI controller (`sound/pci/hda`). **IMPORTANT** —
default audio driver on essentially all x86 laptops/desktops
(`CONFIG_SND_HDA_INTEL`).

**Step 7.2**
Record: Mature, actively maintained. Probe path itself is old and
stable; recent churn is IDs/quirks, not `azx_probe()` structure.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Users of `snd-hda-intel` (very common), plus anyone who can bind
a PCI function with a tiny BAR0 (VM/PCI fuzzing, `new_id`,
malformed/class-matching devices).

**Step 8.2: Trigger**
Record: PCI bind of a device whose BAR0 is smaller than the offsets the
driver reads. Common in syzkaller/QEMU; uncommon on real ICH/PCH
hardware (those BARs are ~16KB). Typically needs a matching class/ID or
CAP_SYS_ADMIN for `new_id`. Unprivileged userspace cannot trigger it
directly (syzbot: Unprivileged: no). Peripheral/VM-host injection is in
the syzbot assessment.

**Step 8.3: Failure mode**
Record: Kernel oops (`BUG: unable to handle kernel paging request`) in
`azx_probe_work`. **Severity: CRITICAL** (host/guest crash). DoS; one
report also marked exploitable. Not filesystem corruption.

**Step 8.4: Risk-benefit**
Record:
- **Benefit:** High — prevents a documented, reproducible oops in a
  widely enabled driver.
- **Risk:** Very low — 9 lines, fail-closed on impossible hardware, no
  locking/API change.
- **Ratio:** Strongly favors backport.

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Two syzbot reports, C repros, prio:high, paging oops
- Real crash in `azx_first_init` / `snd_hdac_bus_parse_capabilities` —
  both exist here
- 9-line, obviously correct check
- ALSA maintainer authored and applied it
- Same probe context in 6.12; only the filename differs
- Spec-sized HD-audio BARs are far larger than `0x200`

AGAINST:
- Trigger is not the everyday laptop codec path (needs a tiny BAR / wild
  bind)
- `0x200` is a floor, not full MMIO coverage
- No mailing-list review besides the maintainer
- Lore/stable-list HTTP 403 (discussion recovered via b4)

UNRESOLVED:
- Could not WebFetch lore.kernel.org or git.kernel.org (403/bot wall);
  b4 mbox and syzbot pages were sufficient
- No independent stable-list discussion found

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — maintainer patch; syzbot
   lists it as the fix commit and patched on upstream CI.
2. Real bug affecting users? **PASS** — reproducible kernel oops.
3. Important (crash/security/corruption/deadlock)? **PASS** — oops / DoS
   (CRITICAL).
4. Small and contained? **PASS** — +9 lines, one function.
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — path remap only; context matches.

**Step 9.3: Exception category**
Record: Not an ID/quirk/DT/docs exception. It is a normal crash-
prevention bugfix.

**Step 9.4: Decision**
This tree has the vulnerable probe path. The patch is a small, correct
guard that stops a syzbot-proven oops. It should be backported to this
6.12 tree.

---

### What the commit solves, and why it matters here

`snd-hda-intel` maps BAR0 and then reads HD-audio registers (GCAP at
`0x00`, LLCH at `0x14`, later stream descriptors). If BAR0 is too small
— syzkaller binds a wild PCI function, or a class-`0x0403` device has a
truncated BAR — those `readw`s walk off the iomap and oops the kernel in
`azx_probe_work`. On 6.12 that is still `azx_probe()` in
`sound/pci/hda/hda_intel.c` with no size check. The patch rejects BAR0 <
512 bytes before `snd_card_new()`, which is enough to stop the reported
crash and will not reject real controllers.

### Stable-rules / risk vs benefit

Meets the rules: real oops, tiny diff, no API, applies with a filename
change. Benefit is preventing a kernel crash in a default x86 audio
driver; risk is an early `-EINVAL` only for hardware that could not
function.

### Concerns

Need to drop the patch onto `sound/pci/hda/hda_intel.c` instead of
`sound/hda/controllers/intel.c`. No other prerequisites. The `0x200`
floor is incomplete for later registers; that is documented and does not
block the oops fix.

### Verification
- [Phase 1] Parsed tags: two syzbot Reported-by/Closes, maintainer SOB,
  no Fixes/Cc:stable
- [Phase 2] Diff: +9 lines in `azx_probe()`, `pci_resource_len(pci, 0) <
  0x200` → `-EINVAL`
- [Phase 3] `git describe HEAD` / `make kernelversion`: **6.12.111**
  (`p-6.12-3-gc504cf0baa3d8`)
- [Phase 3] `git merge-base --is-ancestor 9895573b0185 HEAD` → not
  ancestor (exit 1); object exists
- [Phase 3] Blame around insertion: `snd_card_new` path dates to
  2008–2014; no existing BAR check
- [Phase 3] `git log --oneline -20 -- sound/pci/hda/hda_intel.c`:
  IDs/quirks only; no related fix
- [Phase 4] `b4 dig -c 9895573b0185`: lore URL
  `20260813150354.763502-1-tiwai@suse.de`
- [Phase 4] `b4 dig -a`: v1 only; `b4 dig -w`: linux-sound + maintainer
- [Phase 4] b4 mbox: single email, no NAK/review replies
- [Phase 4] syzbot: paging oops in `snd_hdac_bus_parse_capabilities` and
  `azx_probe_work`; C repro; prio:high; fix `9895573b0185`
- [Phase 4] WebFetch lore/stable/git.kernel.org: 403 — UNVERIFIED via
  HTTP; b4/syzbot used instead
- [Phase 5] Callers: PCI `.probe = azx_probe`; Intel/NVIDIA/ATI/AMD HD-
  audio class catch-alls
- [Phase 5] This tree `azx_first_init`: `pcim_iomap_regions` then
  `azx_readw(GCAP)` / `snd_hdac_bus_parse_capabilities` (LLCH `0x14`)
- [Phase 5] `pcim_iomap_regions()` maps BAR as-is; no minimum size
- [Phase 6] Local `azx_probe()` at `sound/pci/hda/hda_intel.c:2116`
  lacks the check; grep found no `"Too small PCI BAR0"`
- [Phase 6] Surrounding lines 2149–2160 match the upstream hunk — clean
  path-remap apply
- [Phase 8] Failure: kernel oops on probe workqueue; severity CRITICAL;
  unprivileged trigger not shown

**YES**

 sound/hda/controllers/intel.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index f07fc5dc5cede..3ed33cba7d83f 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -2155,6 +2155,15 @@ static int azx_probe(struct pci_dev *pci,
 		dev_warn(&pci->dev, "dmic_detect option is deprecated, pass snd-intel-dspcfg.dsp_driver=1 option instead\n");
 	}
 
+	/* A sanity check against wild device binding;
+	 * here the range 0x200 is enough for the registers used at probe,
+	 * but it doesn't mean covering all HD-audio registers
+	 */
+	if (pci_resource_len(pci, 0) < 0x200) {
+		dev_err(&pci->dev, "Too small PCI BAR0\n");
+		return -EINVAL;
+	}
+
 	err = snd_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
 			   0, &card);
 	if (err < 0) {
-- 
2.53.0

