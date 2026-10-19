Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF1252F82F;
	Mon, 19 Oct 2026 13:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418389; cv=none; b=tEryHEQskWwc6Gp52kbcF6xqHYG4jG7/FV0lGCXF4YH6JZ4ATERVV8rLG2zboQqxYyccxBMFIbkIc28XnMu28pH+g6cdRxbqzOxT6uydO+aHOkU9htWkl0J6ZWgslkfaAO92Ti8f4bZqSOx6x5abFCk9iuKw4nxou/OKfQzOYa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418389; c=relaxed/simple;
	bh=CXzADxk9wqX09v7ycqrdX6eAVir6soUV+PCXFq9YVhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N/EbjqCU3X7BMqf1MEScMyPc4UFYFykxup8Y0lO8jJAzYa7/KyVVqym5GBOy842bEEwMCfpU8wBB3dJNY6owBcqZLbffdvZeCylbZnYrOkzbzm+HpfrvyXfSc43Fe09zL7w035eiX0pLiSQLb64+mf9o3j69z0DhFzg0bkP9T0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKQoQXyf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKQoQXyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EEE1F000C9;
	Mon, 19 Oct 2026 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418384;
	bh=8mQ3Y+7UHIH059+NAi9vk+LgHMB4/3HWDkvw9jCS914=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKQoQXyfw4atyFLeKELm/jUlqecQo+rgyrlTYIUx+2HIV2m5H+ceoUzXEMb0lgZNO
	 u4peYGDHCVg0FGbCHnjtJ57Xv0UIkZGFXGVPrBoiB6n4YacCMeepEfUm8zlgUIDPv/
	 rjsG1Zhy92+6V3LWVIhd0YDLqEkSf2K4dciowLCWaSGl/TOK7o5nlE9doQsgqxPK+d
	 1vVHkZ27eF8y6y0aXhE1PHPjTMvUewtzJHE7grF4lUBhX4wtDhrUG+dmqm0hNaqrfU
	 c4k9pIixM/G2lZrM8LcxQHN6PQAipYI0OUluciASVM7skjFLohpgxbGaQLFPcQEcNo
	 yi2EH9E6eCoXg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michal Pecio <michal.pecio@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: usx2y: Stop clearing urb->hcpriv before submission
Date: Mon, 19 Oct 2026 09:48:22 -0400
Message-ID: <20261019135441.1420968-211-sashal@kernel.org>
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

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit fabae5548149ef5c8a056875d9ebdc38366db539 ]

This is managed by USB core and drivers aren't expected to touch it.

It should only be not NULL on a submitted URB, in which case clearing
defeats the "submitted while active" sanity check in usb_submit_urb()
and may crash the HCD handling the URB and panic the kernel.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Link: https://patch.msgid.link/20260810075728.483c827e.michal.pecio@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the local tree, the live `hcpriv` path, and the mailing-list
record. The rest of this is the nine-phase write-up and the backport
verdict for 6.12 only.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ALSA/usx2y] [Stop]** Stop clearing `urb->hcpriv` before
`usb_submit_urb()`. “Stop” here means “stop doing something unsafe,”
i.e. a correctness fix, not a feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Verified from `git show fabae5548149ef5c8a056875d9ebdc38366db539`:

- `Signed-off-by: Michal Pecio <michal.pecio@gmail.com>` (author)
- `Link: https://patch.msgid.link/20260810075728.483c827e.michal.pecio@g
  mail.com`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer)

Absent (expected for this pipeline, not a negative signal): `Fixes:`,
`Cc: stable`, `Reported-by`, `Tested-by`, `Reviewed-by`, `Acked-by`.

No syzbot, no CVE, no multi-user report.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** Client driver writes `urb->hcpriv = NULL` immediately before
  `usb_submit_urb()`. `hcpriv` is USB-core/HCD private.
- **Symptom/failure mode:** If the URB is still active (`hcpriv !=
  NULL`), that store hides it from `usb_submit_urb()`’s “submitted while
  active” check. The HCD then treats a live URB as a new submit and
  **can crash / panic**.
- **Version info in the message:** none. Git places the commit at
  `v7.2-rc5-196-gfabae5548149e` (2026-08-10). The assignment itself
  dates to `1da177e4c3f41` (Linux-2.6.12-rc2).
- **Root cause (author):** drivers must not touch `hcpriv`; a non-NULL
  value means “already submitted.”

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. The message names the panic path. The
diff is a one-line deletion of an illegal store.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `sound/usb/usx2y/usbusx2yaudio.c` — 1 deletion, 0 additions
- Function: `usx2y_urb_submit()`
- Scope: single-file, surgical

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record: Before, `usx2y_urb_submit()` set `start_frame`, **zeroed
`hcpriv`**, set `urb->dev`, then `usb_submit_urb(GFP_ATOMIC)`. After,
the `hcpriv` store is gone. This is the **normal ISO resubmit path**
(completion → `usx2y_usbframe_complete()` → `usx2y_urb_submit()`), not
an error-only path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Memory safety / HCD invariant]** `urb->hcpriv` is documented
in `include/linux/usb.h` as HCD-private. `usb_submit_urb()` in this
tree:

```378:381:drivers/usb/core/urb.c
        if (urb->hcpriv) {
                WARN_ONCE(1, "URB %pK submitted while active\n", urb);
                return -EBUSY;
        }
```

`__usb_hcd_giveback_urb()` already sets `urb->hcpriv = NULL` **before**
the complete callback, so on a legal resubmit the driver’s store is a
no-op. If the URB is still queued, the store defeats
`-EBUSY`/`WARN_ONCE`. xHCI then does `urb->hcpriv = urb_priv` in
`xhci_urb_enqueue()` over a live URB (new `urb_priv`, old still on the
ring) → DMA/ring corruption and panic.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct: delete an illegal write. Minimal. Regression
risk is very low: giveback already NULL’s `hcpriv` before complete;
first-time submits from `usx2y_urbs_start()` go through
`usb_submit_urb()` directly with a freshly allocated URB. On a true
double-submit, users get `-EBUSY` and this driver’s existing `dev_err` +
`usx2y_clients_stop()` instead of an HCD panic.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record: `git blame` on line 170: `urb->hcpriv = NULL` introduced in
**`1da177e4c3f41` (Linux-2.6.12-rc2, 2005)**. Present for the entire
life of this driver. Surrounding function was only renamed/style-fixed
(Takashi Iwai, 2021).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The broken line is original driver code, not a
later regression. The USB-core check was added in **`2f02bc8af3abb`
(Alan Stern, 2012)** “USB: report submission of active URBs”
(`WARN_ONCE` + `-EBUSY`). That commit exists in this tree. This driver
has been defeating that check since the check existed.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent local history on this file includes `86f82bf2b5f99`
(validate `nrpacks`), print API, `__counted_by`, etc. None of those
remove `hcpriv`. `git merge-base --is-ancestor fabae5548149e HEAD` →
**not an ancestor** (exit 1). Standalone one-line patch, not `N/M`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Michal Pecio has no prior ALSA usx2y commits in this checkout.
On `origin/master` the only nearby `hcpriv` work is `25e531b422dc2`
(`usb: xhci: Make usb_host_endpoint.hcpriv survive endpoint_disable()`)
— different field (`ep->hcpriv`), not a prerequisite. Author is a
USB/xHCI contributor; ALSA maintainer applied this the same day.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: None. The function, field, and `usb_submit_urb()` check all
exist here. `git show fabae5548149e | git apply --check` succeeded.
Standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c fabae5548149e` → https://patch.msgid.link/20260810075728.48
  3c827e.michal.pecio@gmail.com
- `b4 dig -a`: **v1 only**, 2026-08-10
- Thread (LKML/openwall): standalone `[PATCH]`, no v2. Takashi Iwai:
  “Applied to for-next branch. Thanks.” No NAK, no stable discussion, no
  reviewer risk flags.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc Jaroslav Kysela, Takashi Iwai, linux-sound,
linux-kernel. **Not** linux-usb. Applied by the ALSA maintainer the same
day; no separate Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No `Reported-by`, no bugzilla/syzbot. Inspection-driven.
Severity from the author is kernel panic; no public crash log was found.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Not a series. `git log origin/master
fabae5548149e..origin/master -- sound/usb/usx2y/usbusx2yaudio.c` is
empty (no follow-up/revert).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org returned 403 via WebFetch. Web search of
`site:lore.kernel.org/stable usx2y hcpriv` found **no** stable-list
thread. UNVERIFIED beyond that search: no evidence it was rejected for
stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

semcode MCP is not available; callers/callees from grep + reads.

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `usx2y_urb_submit()` only.

**Step 5.2: TRACE CALLERS**

Record:
- `usx2y_usbframe_complete()` in the same file: playback URB after
  `usx2y_urb_play_prepare()`, capture `completed_urb` after retire.
  Called from `i_usx2y_urb_complete()` (URB complete / giveback).
- `usx2yhwdeppcm.c` includes `usbusx2yaudio.c` and calls
  `usx2y_urb_submit()` for capture (and second capture) in the
  hwdep/rawusb path.

Hot path: **every ISO frame** while PCM is running. Userspace trigger:
open/play/record on a Tascam US-122/224/428 (`CONFIG_SND_USB_USX2Y`).

**Step 5.3: TRACE CALLEES**

Record: `usb_submit_urb(urb, GFP_ATOMIC)`, `dev_err` on failure. No
alloc, no new locks.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: `usb_hcd_giveback_urb` → `__usb_hcd_giveback_urb` (`hcpriv =
NULL`) → `i_usx2y_urb_complete` → `usx2y_usbframe_complete` →
`usx2y_urb_submit` → `usb_submit_urb`. Reachable from normal PCM. On a
clean complete, `hcpriv` is already NULL. Double-submit is the dangerous
case (startup state machine `STATE_STARTING1/2` can pick
`urb[0]`/`urb[1]` by index; two URBs per substream, `NRURBS == 2`).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: `urb->hcpriv = NULL` in `sound/` exists **only** in this file.
Other `hcpriv` writes are in HCDs (`xhci`, `ehci`, `ohci`, …), which is
correct. This driver is the outlier among ALSA USB.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** Local tree: `pending-6.12`, `git describe`
`p-6.12-3-gc504cf0baa3d8`, **`make kernelversion` = 6.12.111**. Line 170
of `sound/usb/usx2y/usbusx2yaudio.c` is `urb->hcpriv = NULL;`.
Introduced in 2.6.12-rc2; present for this entire 6.12 line.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** (`git apply --check` exit 0). Hunk context
matches. No refactor of this submit helper in 6.12 vs the mainline
parent.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No prior usx2y `hcpriv` fix (`git log --grep=hcpriv --
sound/usb/usx2y/` empty). Nearby usx2y hardening in this tree (`nrpacks`
validation, URB `actual_length` checks, etc.) does not replace this
change.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **ALSA USB** (`sound/usb/usx2y/`), driver-specific.
**PERIPHERAL/IMPORTANT-for-those-devices**: Tascam US-122/224/428
(`CONFIG_SND_USB_USX2Y`, x86/PPC/Alpha). Not core mm/net, but USB audio
submit on a live HCD is a **system-wide panic** if it fires.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature (2002–2005 origin), still receiving real fixes in 6.12
(parameter validation, bounds). Low churn, not staging.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific / config-specific**: users with Tascam
US-122/224/428 and `CONFIG_SND_USB_USX2Y`. Unprivileged PCM I/O can
exercise the path.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Legal resubmit after giveback: `hcpriv` already NULL → **no
behavior change**. Panic requires submitting a still-active URB (startup
state machine, lost `completed_urb`, or overlapping complete/submit).
Not shown with a public reproducer; ISO ping-pong with two URBs makes it
**plausible**. Unprivileged users running audio can hit the submit path.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **HCD crash / kernel panic** if an active URB is submitted after
`hcpriv` is cleared. **Severity: CRITICAL** when it fires; **likelihood:
unproven / low** (no Reported-by). After the fix: `-EBUSY` + WARN +
stream stop — **HIGH** improvement vs panic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** Restores USB core’s active-URB guard on a path that
  otherwise can panic the machine; correct path unchanged.
- **Risk:** 1-line deletion, no API, no locking, no data-structure
  change.
- **Ratio:** Strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Objectively illegal write to HCD-private `urb->hcpriv` (docs + USB
  core).
- Defeats `usb_submit_urb()`’s `WARN_ONCE`/`-EBUSY` (in this tree since
  2012).
- Failure mode is HCD crash/panic (xhci re-owns a live URB).
- Buggy line present here since 2.6.12; commit is **not** in HEAD.
- 1 deletion; `git apply --check` clean; no prerequisites.
- USB-knowledgeable author; ALSA maintainer applied v1 same day; no NAK;
  no later revert.

AGAINST:
- No `Reported-by` / syzbot / crash log.
- Tascam-only driver.
- On the spec-compliant complete path the store is already a no-op
  (giveback NULL’s `hcpriv` first), so this is **latent** unless double-
  submit happens.

UNRESOLVED:
- Could not fetch lore.kernel.org (403); discussion recovered via b4 +
  LKML/openwall.
- No stable-list hit found; not proven it was ever NAK’d for stable.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — one illegal store removed;
   maintainer applied; correct path unchanged.
2. Fixes a real bug that affects users? **PASS** — drivers must not
   clear `hcpriv`; this driver does; users of this hardware exist.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   bypass can panic the HCD; severity is crash, even if unreported.
4. Small and contained? **PASS** — 1 line, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — clean apply; code present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
bugfix.

**Step 9.4: MAKE YOUR DECISION**

This belongs in **this** 6.12 tree. The hardware set is narrow, but the
patch is the lowest-risk way to stop a driver from disabling USB core’s
double-submit guard. A panic on ISO resubmit is exactly the class of bug
stable is meant to take; waiting for a public oops is unnecessary when
the mechanism is visible in this checkout.

------------------------------------------------
What the commit solves for 6.12 users
------------------------------------------------
`usx2y_urb_submit()` currently zeros `urb->hcpriv` before
`usb_submit_urb()`. USB core uses that pointer as “this URB is in the
HCD.” Clearing it lets a still-active URB through as if it were idle.
That can crash the host controller. After the deletion, a double-submit
returns `-EBUSY` and this driver already stops the streams.

Meets stable rules: obviously correct, real invariant bug, crash
severity, 1 line, no new API, applies here.

Risk vs benefit: benefit is avoiding a panic; risk is effectively zero
on the giveback path this driver uses every frame.

Concerns: niche device, no reproducer. Neither blocks a one-line restore
of an existing USB-core check.

Verification:
- [Phase 1] Tags: author SOB, Link msgid, Takashi Iwai SOB; no
  Fixes/Reported-by/stable Cc
- [Phase 1] Subject/body: stop illegal `hcpriv` clear; panic if URB
  still active
- [Phase 2] Diff: delete `urb->hcpriv = NULL` in `usx2y_urb_submit()`;
  confirmed at line 170 in this tree
- [Phase 2] `usb_submit_urb()` checks `urb->hcpriv` and returns `-EBUSY`
  (`drivers/usb/core/urb.c:378-381`)
- [Phase 2] `__usb_hcd_giveback_urb()` sets `urb->hcpriv = NULL` before
  `urb->complete()` (`hcd.c:1627`)
- [Phase 2] xHCI `xhci_urb_enqueue()` assigns `urb->hcpriv = urb_priv`
  (`xhci.c:1552`)
- [Phase 2] `include/linux/usb.h`: `hcpriv` is HCD-private;
  Documentation `-EBUSY` = URB already active
- [Phase 3] blame: `1da177e4c3f41` Linux-2.6.12-rc2 introduced the store
- [Phase 3] sanity check added `2f02bc8af3abb` (2012), present here
- [Phase 3] `git merge-base --is-ancestor fabae5548149e HEAD` → not in
  this tree
- [Phase 3] no follow-up/revert on `origin/master` for this file after
  the commit
- [Phase 4] `b4 dig -c fabae5548149e`: lore msgid; v1 only; To/Cc ALSA
  maintainers
- [Phase 4] Takashi Iwai applied to for-next; no NAK
- [Phase 4] lore.kernel.org WebFetch 403; LKML/openwall used instead
- [Phase 5] callers: `usx2y_usbframe_complete`, hwdep path via `#include
  "usbusx2yaudio.c"`
- [Phase 5] only `sound/` instance of `urb->hcpriv = NULL`
- [Phase 6] `git describe HEAD` = p-6.12-3-gc504cf0baa3d8; `make
  kernelversion` = 6.12.111
- [Phase 6] `git apply --check` of `fabae5548149e` succeeded
- [Phase 7] `CONFIG_SND_USB_USX2Y` Tascam US-122/224/428
- [Phase 8] Failure mode: HCD panic on active-URB submit; severity
  CRITICAL if triggered
- UNVERIFIED: no public reproducer; stable@ archive not readable (403)

**YES**

 sound/usb/usx2y/usbusx2yaudio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index c7c7ec9c228b4..1ea181e9bb283 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -167,7 +167,6 @@ static int usx2y_urb_submit(struct snd_usx2y_substream *subs, struct urb *urb, i
 	if (!urb)
 		return -ENODEV;
 	urb->start_frame = frame + NRURBS * nr_of_packs();  // let hcd do rollover sanity checks
-	urb->hcpriv = NULL;
 	urb->dev = subs->usx2y->dev; /* we need to set this at each time */
 	err = usb_submit_urb(urb, GFP_ATOMIC);
 	if (err < 0) {
-- 
2.53.0

