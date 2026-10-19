Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA8850CBA4;
	Mon, 19 Oct 2026 14:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418764; cv=none; b=DjpFo5WAgi7Nwm/0bhZHWIQgocdK+De2Y003DS8qTCzPpU8mLK5M9qzexFCLuT02GqJUNvw9bOzMgnouoPWojBHF/hzg8HBAn71Xb7J5HyZhErArnAaHEy4WWXi0hYBLZ5j5Gkxj6vv6zdJnx7yuHCyhjkjcd7RR96EZ4gkmpnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418764; c=relaxed/simple;
	bh=BVGJV32PwKi4P0vAzeDgfAs21HeyRwnOL+MLqqLN4oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NVJ+Hy9yEgml/9Tp6ral30KJDFpUdwEeRo+IHLbIDPjyAnR2LwYWsPdDSNF+PFnF+fLY47hxSDr3PT+0Rsxtwe93qMIm6/0USj8hJ7NUaXENzpL97+U6vAI1evxETePIjtd6jrLl0rSrqeVF6y0FBLvjK2UdR5mEZiOQOtfnYHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mVeiPshd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mVeiPshd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A222A1F000C4;
	Mon, 19 Oct 2026 14:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418761;
	bh=19SrjI/tRZUlcgCCmFpdJW/gTF/AXwCdC6X5z0tCrtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVeiPshdkuNVUD6cZXc3qPn/xGhPpjUdqDcTDimn+3fNqX/3okkw2xI5L1+EGek0A
	 2aql2JIUugs1afyUIp5KrkPXQFBG1XKILhSg+i7fD/dRhBzlPgUgkqtJUoJUosdORh
	 Xkj1SaCicag0Qx3zVFEjBZaF2VIllcKH514aa3hG5nhYSEczOSgNrPlaWJjrqWLWj2
	 w8LmoxXuC67axTuWfWsV5bsH05f4ieXgs4DgC3rIfYsbFp119nl2akOzxZUpq2Oi2b
	 bFrZxQTzQ1i1HQs5ogePASAOX78sexejQ4xohrqKCmB/Gr15B1/W6HtMRPYtnCSc26
	 QmjajIK9h7YtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	hsweeten@visionengravers.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] comedi: aio_iiro_16: Add sanity check to interrupt handler
Date: Mon, 19 Oct 2026 09:52:48 -0400
Message-ID: <20261019135441.1420968-477-sashal@kernel.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit 1ca44751915134f19e8627768159781e75b5da50 ]

The driver requests an interrupt handler for the device, after setting
device registers to disable interrupt generation.  The interrupt handler
should not be called prematurely unless the user-configured I/O port
base address and/or IRQ number are incorrect or the hardware is bad.

For safety, check the dev->attached flag in the interrupt handler to
ensure the device has been fully set up, avoiding a possible null
pointer dereference of dev->read_subdev.

Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Link: https://lore.kernel.org/lkml/20260610115912.780131-1-jjy600901@snu.ac.kr/
Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-2-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[comedi: aio_iiro_16:] [Add] sanity check to interrupt handler`
— add a guard in the IRQ handler of the ACCES I/O 104-IIRO-16 Comedi
driver.

**Step 1.2 — Tags**
Record:
- `Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>`
- `Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>`
- `Reported-by: Kyungwook Boo <bookyungwook@gmail.com>`
- `Link: https://lore.kernel.org/lkml/20260610115912.780131-1-
  jjy600901@snu.ac.kr/` (original bug report)
- `Link:
  https://patch.msgid.link/20260618102949.26607-2-abbotti@mev.co.uk`
  (patch 01/11 of the series; msgid `...-2` is the first code patch
  after the cover letter)
- `Signed-off-by: Ian Abbott <abbotti@mev.co.uk>` (COMEDI maintainer)
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected; not a negative signal)
- Three independent reporters — real-world/research report, not a drive-
  by cleanup

**Step 1.3 — Body**
Record:
- **Bug:** IRQ handler `aio_iiro_16_cos()` can run before the device is
  fully set up.
- **Symptom:** possible NULL dereference of `dev->read_subdev`.
- **Root cause (author):** `request_irq()` is issued after hardware IRQ
  generation is disabled, so a premature IRQ should only happen with a
  wrong user-configured I/O base and/or IRQ, or bad hardware. Attach
  still registers the handler before `read_subdev` is assigned and
  before `dev->attached` is set.
- **Version info:** none in the message. The IRQ path dates to 2015.

**Step 1.4 — Hidden fix?**
Record: Not hidden. It is an explicit NULL-deref guard, even though the
verb is “Add” rather than “fix”.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `drivers/comedi/drivers/aio_iiro_16.c` (+3 / −0)
- Function: `aio_iiro_16_cos()`
- Scope: single-file, 3-line surgical change

**Step 2.2 — Control flow**
Record:
- **Before:** handler always takes `s = dev->read_subdev`, reads STATUS,
  and on `IRQE` calls `comedi_buf_write_samples(s, &val, 1)` then
  `comedi_handle_events(dev, s)`.
- **After:** if `!dev->attached`, return `IRQ_NONE` before using `s`.
- Path: interrupt / attach window, not the steady-state command path.

**Step 2.3 — Bug mechanism**
Record: **NULL pointer dereference (memory safety).**
- `aio_iiro_16_attach()` does `aio_iiro_enable_irq(dev, false)`, then
  `request_irq()`, then `comedi_alloc_subdevices()`, then
  `dev->read_subdev = s`.
- `dev->attached` is set later in `comedi_device_postconfig()`.
- If the handler runs in that window, `read_subdev` is still NULL.
  `comedi_buf_write_samples(s, ...)` calls
  `comedi_get_is_subdevice_running(s)`, which does
  `spin_lock_irqsave(&s->spin_lock, flags)` — a confirmed NULL deref,
  not a theoretical one.

**Step 2.4 — Fix quality**
Record: Obviously correct and matches the existing Comedi IRQ idiom (`if
(!dev->attached) return IRQ_NONE;`) used in many sibling drivers.
Regression risk is very low: a premature IRQ is ignored until attach
finishes. The load of `s` still happens before the check, but `s` is not
dereferenced until after it; that is the same pattern as `das6402` /
`comedi_parport`. No API or locking-order change.

## Phase 3: Git history

**Step 3.1 — Blame**
Record:
- IRQ handler introduced in `ad7a370c8be472` (“staging: comedi:
  aio_iiro_16: add command support for change of state detection”),
  2015-01-09, contained in v4.0-rc1.
- Driver left staging in `8ffdff6a8cfbd` (2021).
- The missing `attached` check is the bug; it has been present for the
  life of this IRQ handler.

**Step 3.2 — Fixes: tag**
Record: none. Introducer is `ad7a370c8be472` (v4.0), present in this
tree.

**Step 3.3 — File history**
Record (recent, path-limited):
- `1ca4475191513` this commit
- `81c2e0c8b7933` I/O-base sanity checks (different msgid series, not a
  prerequisite)
- `66acb1586737a` bit-shift bounds fix
This patch does not depend on those.

**Step 3.4 — Author**
Record: Ian Abbott is listed in MAINTAINERS as COMEDI maintainer
(`COMEDI DRIVERS`, status Odd Fixes). Around the same time he landed an
11-patch series of the same IRQ `attached` guards, plus earlier
`17221216ae8ce` (`comedi_parport: deal with premature interrupt`) which
*was* tagged `Cc: stable` and `Reported-by: syzbot` for a GPF in
`comedi_get_is_subdevice_running()`.

**Step 3.5 — Dependencies**
Record: Cover letter is `comedi: Add/fix sanity check in ISA drivers to
avoid null-ptr-deref` (11 patches, one driver each). This patch is self-
contained; it does not need the other 10. Applies standalone.

## Phase 4: Mailing list / external

**Step 4.1 — Original submission**
Record:
- `b4 dig -c 1ca4475191513` →
  https://patch.msgid.link/20260618102949.26607-2-abbotti@mev.co.uk
- `b4 dig -a`: v1 only; committed version is that v1.
- Cover letter: several ISA Comedi drivers register the IRQ handler
  before the subdevice exists; premature IRQ → NULL deref. aio_iiro_16
  is named in the report.
- Mbox of the series: 12 messages (cover + 11 patches). No NAK, no
  reviewer objections in that thread.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: Ian Abbott, Greg Kroah-Hartman, H Hartley Sweeten (other COMEDI
maintainer), linux-kernel, and the three reporters. Right people were on
the patch.

**Step 4.3 — Bug report**
Record: Subject `comedi: KASAN null-ptr-deref in ISA driver IRQ handlers
on early IRQ`. Explicitly lists `aio_iiro_16.c` / `aio_iiro_16_cos()`.
Failure: KASAN NULL deref / kernel panic. Suggested fix: move
`request_irq()` later **or** guard the handler. This commit takes the
guard (the established Comedi pattern).

**Step 4.4 — Series**
Record: 11 independent per-driver patches. This one does not need the
rest.

**Step 4.5 — stable@**
Record: lore.kernel.org/stable search returned HTTP 403 from this
environment. **UNVERIFIED** whether this hash was discussed on stable@.
Sibling `comedi_parport` fix of the same class *was* explicitly `Cc:
stable`.

## Phase 5: Semantic analysis

**Step 5.1 — Functions**
Record: `aio_iiro_16_cos()` only.

**Step 5.2 — Callers**
Record: registered via `request_irq(it->options[1], aio_iiro_16_cos, 0,
...)` in `aio_iiro_16_attach()`. Hard-IRQ context. IRQ is optional (user
config option [1]).

**Step 5.3 — Callees**
Record: `inb()`, `aio_iiro_16_read_inputs()`,
`comedi_buf_write_samples()`, `comedi_handle_events()`. The crash is in
`comedi_get_is_subdevice_running()` → `spin_lock_irqsave(&s->spin_lock,
...)`.

**Step 5.4 — Reachability**
Record: Attach of a legacy Comedi device goes through
`comedi_device_attach()` / `COMEDI_DEVCONFIG` and requires
`CAP_SYS_ADMIN` when not already attached (`comedi_fops.c`). Not an
unprivileged syscall smash, but a privileged configure/load path that
can panic the kernel. Same class syzbot actually hit on
`comedi_parport`.

**Step 5.5 — Similar patterns**
Record: dozens of Comedi IRQ handlers already check `dev->attached`
first. This driver was a missing instance. Same series patched das6402,
dt2811, ni_at_a2150, ni_atmio16d, pcl711, pcl816, pcl818, pcmmio,
pcmuio, quatech_daqp_cs.

## Phase 6: Local tree

**Step 6.1 — Does the buggy code exist here?**
Record:
- Local tree: `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = `7.3.0-rc4`.
- File and IRQ handler exist. Pre-fix parent of `1ca4475191513` has the
  unguarded handler. Bug introduced v4.0 (2015), long before this tree.
- `git merge-base --is-ancestor 1ca4475191513 HEAD` is true (the fix is
  already in this checkout). That is not treated as “already selected
  for stable”; it only confirms the code exists here.

**Step 6.2 — Backport difficulty**
Record: clean apply. Hunk is three lines in a handler whose surrounding
code has been stable since 2015. Does not depend on
`comedi_check_request_region` or other recent helpers.

**Step 6.3 — Related fixes already here?**
Record: `17221216ae8ce` (comedi_parport premature IRQ) is in this tree
and is the same bug class. No earlier aio_iiro_16-specific guard.

## Phase 7: Subsystem context

**Step 7.1**
Record: `drivers/comedi/` — data-acquisition. **PERIPHERAL** for this
specific PC/104 ISA board (`CONFIG_COMEDI_AIO_IIRO_16`), but the failure
is a kernel oops, not a device quirk.

**Step 7.2**
Record: Comedi is mature (“Odd Fixes”). This is an old missing check,
not churn in new code. Driver comment still says `Status: experimental`;
that does not make a panic in the IRQ handler ineligible.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: users of ACCES I/O 104-IIRO-16 with `CONFIG_COMEDI_AIO_IIRO_16`,
typically industrial/DAQ. Driver-specific, not universal.

**Step 8.2 — Trigger**
Record: attach with an IRQ configured, then a premature IRQ before
`attached` is set. Author: wrong I/O base/IRQ or bad hardware (disable
write may not hit the real board, STATUS `inb` can look like `IRQE`).
Requires `CAP_SYS_ADMIN` to attach. Unprivileged users cannot hit it on
a default system.

**Step 8.3 — Failure mode**
Record: KASAN null-ptr-deref / kernel panic in hard-IRQ context.
**Severity: CRITICAL** (oops/panic). Not data corruption.

**Step 8.4 — Benefit vs risk**
Record:
- Benefit: prevents a documented panic on a real attach/IRQ window.
  Medium for this hardware’s users, high given crash severity.
- Risk: very low (3 lines, established pattern, early return only).
- Ratio: favorable.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

FOR:
- Real KASAN NULL deref / panic, named in the SNU report for this exact
  driver
- Three reporters
- 3-line, obviously correct guard matching existing Comedi IRQ style
- Maintainer-authored; Greg KH applied it
- Same class as `comedi_parport` GPF that was `Cc: stable` + syzbot
- Bug in code since v4.0; present in this tree
- Standalone; no series dependency
- Driver exists here; patch applies cleanly

AGAINST:
- Niche ISA/PC104 board; experimental driver
- Privileged trigger; premature IRQ only if config/hardware is wrong
  (author’s own caveat)
- No `Fixes:` / `Cc: stable` on this commit
- No review replies in the v1 mbox (quality still supported by
  maintainer + Greg KH)

UNRESOLVED:
- stable@ discussion (HTTP 403)
- Whether reporters had a hardware repro vs static/KASAN analysis
  (report is KASAN-framed)

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — standard `dev->attached`
   guard; applied to char-misc/mainline.
2. Fixes a real bug that affects users? **PASS** — KASAN null-ptr-deref
   in IRQ; reported; attach path is how this board is used.
3. Important (crash/security/corruption/deadlock)? **PASS** — kernel
   panic in IRQ. Not a security hole for unprivileged users, but it is a
   serious crash.
4. Small and contained? **PASS** — +3 lines, one function.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS** — driver and hunk exist; no missing
   helpers.

**Step 9.3 — Exceptions**
Record: none (not an ID/quirk/DT/build/doc exception). It is a straight
bug fix.

**Step 9.4 — Decision**
This tree is **7.3.0-rc4**. The IIRO-16 IRQ handler and the attach-
before-`attached` window are here. The patch is a minimal, maintainer-
written guard against a reported IRQ-time NULL deref/panic. Niche
hardware and a privileged trigger do not outweigh a 3-line crash fix of
a pattern already used across Comedi and already `Cc: stable` for the
sibling parport case.

### What it solves for users of this tree
If the 104-IIRO-16 driver is loaded and attached with an IRQ, a
premature interrupt (wrong I/O/IRQ or bad hardware) used to call
`comedi_buf_write_samples(NULL, ...)` and panic. After the guard, that
IRQ is ignored until attach completes.

Risk is negligible; benefit is avoiding an oops.

Verification:
- [Phase 1] Parsed tags: three Reported-by (SNU), two Link URLs, Ian
  Abbott + Greg KH SOB; no Fixes/Cc:stable
- [Phase 1] Fetched bug report: KASAN null-ptr-deref, aio_iiro_16 named
- [Phase 2] Diff: +3 lines in `aio_iiro_16_cos()`; `if (!dev->attached)
  return IRQ_NONE;`
- [Phase 2] Confirmed crash: `comedi_get_is_subdevice_running()` locks
  `&s->spin_lock`
- [Phase 2] Confirmed attach order: disable IRQ → `request_irq` → alloc
  subdevices → `read_subdev`; `attached` set in
  `comedi_device_postconfig()`
- [Phase 3] blame: handler from `ad7a370c8be472` (v4.0-rc1, 2015)
- [Phase 3] `git merge-base --is-ancestor 1ca4475191513 HEAD` succeeded
- [Phase 3] Author is COMEDI maintainer; 11-patch series, this patch
  standalone
- [Phase 3] Sibling `17221216ae8ce` (comedi_parport) had syzbot GPF +
  `Cc: stable`
- [Phase 4] `b4 dig -c 1ca4475191513`: lore msgid
  `20260618102949.26607-2`; v1 only
- [Phase 4] Cover letter: ISA IRQ-before-subdevice NULL deref series
- [Phase 4] `b4 dig -w`: Greg KH + Hartley Sweeten + reporters on Cc
- [Phase 4] UNVERIFIED: stable@ archive (403)
- [Phase 5] Only caller is `request_irq` in attach; `CAP_SYS_ADMIN`
  required to attach
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; kernel
  7.3.0-rc4; buggy handler in parent of the commit; clean 3-line apply
- [Phase 8] Failure: KASAN NULL deref → panic, severity CRITICAL;
  trigger privileged + misconfig/bad HW
- UNVERIFIED: hardware vs static reproduction by the SNU reporters

**YES**

 drivers/comedi/drivers/aio_iiro_16.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/comedi/drivers/aio_iiro_16.c b/drivers/comedi/drivers/aio_iiro_16.c
index 739cc4db52ac7..fe75b7e1ddcac 100644
--- a/drivers/comedi/drivers/aio_iiro_16.c
+++ b/drivers/comedi/drivers/aio_iiro_16.c
@@ -59,6 +59,9 @@ static irqreturn_t aio_iiro_16_cos(int irq, void *d)
 	unsigned int status;
 	unsigned int val;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	status = inb(dev->iobase + AIO_IIRO_16_STATUS);
 	if (!(status & AIO_IIRO_16_STATUS_IRQE))
 		return IRQ_NONE;
-- 
2.53.0

