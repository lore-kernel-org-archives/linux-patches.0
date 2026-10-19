Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2177F59F505;
	Mon, 19 Oct 2026 13:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418369; cv=none; b=pq/EsL8MPmqeIyifLt5biSEX0U/3O++cu4M5/i87f8o755GhQalCAOqIe1olhPH5NtTmtP+5weYeFc/09w3xQmdUErH9qBJec+6XBwjCUxKcwCpXiSyVnoR0871ric1DW4EUzA6fctEEVgEd65V9LdIuEs9i56LSRjGhUm8Nz84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418369; c=relaxed/simple;
	bh=ExYcZ8dZAChh5V332irJFI9S2Xph4L0+n07BZFddPaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GpSDuaHN5S39rvWmKVqehg3WRiMgwqAgPr0KvzKKHxFUwhp2h+4bFBj4CyF8btLb58PKAJ5JjZq/C+JltCKjHwjy0OId0po+sQstcDh3EMg2PnJh83fh9cIvTnY/5vVSBrdJrmKDCbL9OjU5Ddq/+xrs9VntVmbNzDwO/omJJQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WdlbZCoL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WdlbZCoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C22E1F000CA;
	Mon, 19 Oct 2026 13:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418367;
	bh=lSXl3nuPvzEeeN2IWyab7W2XdCu637yuh10cyLL3DjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WdlbZCoLT6QaUnOiXtOimZFglCkB1XmhcFM2AD2mjTGFOq+8H7QkNv1Mr55yWu54N
	 n0nIitNuKUjz8WwE+UJ3cigvJjlffg9wzIbnCQ9RxHUtdQyqIsFGIX8M0NdlCnua70
	 hPJq7HBxTOYvGTTgp1/fmOKyIfPw/u1nvZRBI/e5W3rdqbXK6P3NiT02Eb2uC9i8N+
	 9jCIwK0WHFXt28AyAl+w9INXwsmwWRcUZJlN5IVCayEyI+aGBM7jVnMGzInZ6n0XS9
	 dYmjGqkd1ojBO1LMt7ByCEcC6QyUOkyzGRSQ71nL+XZzGPXbu8PnejO8N+41ozKCug
	 bhxORQGNjkwBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dave Carey <carvsdriver@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] HID: multitouch: Fix stale MT slots when contact count drops to zero
Date: Mon, 19 Oct 2026 09:48:08 -0400
Message-ID: <20261019135441.1420968-197-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Dave Carey <carvsdriver@gmail.com>

[ Upstream commit e8e60b6439eed340a611e9d7a5b9bcbd0ef62725 ]

The INGENIC 17EF:6161 touchscreen (Lenovo Yoga Book 9 14IAH10) reports
HID_DG_CONTACTCOUNT=0 in the frame immediately following the last finger
lift rather than omitting the frame entirely.  In mt_touch_report() the
existing code only updates num_expected when contact_count is non-zero,
so a zero contact count on the first packet of a new frame leaves
num_expected at its previous value (e.g. 2 for a two-finger gesture).
The sync check "num_received >= num_expected" then evaluates "0 >= 2"
and never fires, preventing INPUT_MT_DROP_UNUSED from releasing the
stale slots.  Those slots remain active in the kernel MT layer until the
next touch, at which point they are released in a batch alongside the
new contact — causing the userspace event consumer to miss the
intervening finger-up sequence and corrupt its gesture session state.

Fix by resetting num_expected to 0 when contact_count is zero and
num_received is still 0 (i.e., this is the first and only packet of the
frame, not a continuation packet in a multi-packet sequence).  With
num_expected=0 the sync check "0 >= 0" fires immediately, calling
input_mt_sync_frame() which drops the stale slots via
INPUT_MT_DROP_UNUSED.

The num_received==0 guard is critical: continuation packets in a
multi-packet frame arrive after at least one contact has already been
processed (num_received>0), so they are correctly excluded from this
path and the existing multi-packet logic is unaffected.

Signed-off-by: Dave Carey <carvsdriver@gmail.com>
Tested-by: Dave Carey <carvsdriver@gmail.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the buggy `num_expected` path is in this 6.12
tree, the Yoga Book 9 prerequisites are already here, and the patch
applies cleanly.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: **[HID: multitouch:] [Fix] [stale MT slots when a zero
ContactCount sentinel frame never syncs, so unused slots are not
dropped]**

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none
- **Tested-by:** Dave Carey \<carvsdriver@gmail.com\> (author tested on
  the affected laptop)
- **Reviewed-by:** none in the commit; HID maintainer Benjamin Tissoires
  reviewed on-list and applied it
- **Acked-by:** none
- **Link:** none in the commit
- **Cc: stable:** none (expected)
- **Signed-off-by:** Dave Carey (author); Benjamin Tissoires (HID
  maintainer)
- Ignore pipeline-added Sasha Levin SOB / `[Upstream commit ...]` if
  present

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** INGENIC 17EF:6161 (Lenovo Yoga Book 9 14IAH10) sends
  `HID_DG_CONTACTCOUNT=0` on the frame after the last finger lift.
  `mt_touch_report()` only updates `num_expected` when `contact_count`
  is non-zero, so a first packet with count 0 leaves `num_expected` at
  the previous value (e.g. 2).
- **Symptom / failure mode:** `num_received >= num_expected` becomes `0
  >= 2` and never fires. `INPUT_MT_DROP_UNUSED` does not run. Slots stay
  active until the next touch, then are released together with the new
  contact. Userspace misses the finger-up sequence and corrupts gesture
  state (stuck touch).
- **Version info:** none in the message. Logic has been in hid-
  multitouch since 2017; this hardware/class is recent.
- **Root cause:** zero ContactCount on the first packet of a new frame
  is treated as a multi-packet continuation instead of “no contacts.”

### Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not a hidden fix.** Subject and body describe a real input-
correctness bug and the exact `num_expected` mechanism.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/hid/hid-multitouch.c` — one hunk in
  `mt_touch_report()` (~8 insertions / ~11 deletions, net −3)
- **Scope:** single-file surgical logic change in the ContactCount
  handling block

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Current code in this tree (`drivers/hid/hid-multitouch.c`):

```1254:1269:drivers/hid/hid-multitouch.c
        if (contact_count >= 0) {
                /*
   - For Win8 PTPs the first packet (td->num_received == 0) may
   - have a contactcount of 0 if there only is a button event.
   - ...
                 */
                if ((app->quirks & MT_QUIRK_WIN8_PTP_BUTTONS) &&
                    app->num_received == 0 &&
                    app->prev_scantime != scantime)
                        app->num_expected = contact_count;
                /* A non 0 contact count always indicates a first packet
*/
                else if (contact_count)
                        app->num_expected = contact_count;
        }
```

Record:
- **Before:** `contact_count > 0` → set `num_expected`. `contact_count
  == 0` on a new first packet → set `num_expected = 0` **only** if
  `MT_QUIRK_WIN8_PTP_BUTTONS`. Otherwise leave the previous
  `num_expected`. Continuation packets with count 0 are left unchanged.
- **After:** `contact_count > 0` → set `num_expected`. Else if
  `num_received == 0` and scantime changed → `num_expected = 0` for
  **all** devices. Continuation packets still skipped (`num_received >
  0` or same scantime).
- **Path:** HID report processing for every hid-multitouch device that
  reports ContactCount; not an error/init-only path.

### Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **[Logic / correctness] + [hardware firmware workaround]**

When ContactCount is 0 on a new frame, `num_expected` is not reset, so
`mt_sync_frame()` / `input_mt_sync_frame()` never run and
`INPUT_MT_DROP_UNUSED` cannot release slots.

This tree already has `MT_QUIRK_CONTACT_CNT_ACCURATE` on Yoga Book 9
(`4dfad42f0610f`). With a stale `num_expected` of N, a 0-count frame can
still process N ghost slots (`ALWAYS_VALID` skips tip-state validity),
then sync those ghosts as live contacts. Resetting `num_expected` to 0
makes the accurate-count guard skip every slot (`0 >= 0`) and then drop
unused slots.

### Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Quality:** Minimal rewrite of one conditional. Continuation packets
  still guarded. Win8 PTP button-only frames (`contact_count == 0`,
  first packet, scantime changed) keep working, without requiring the
  quirk.
- **Regression risk:** Low–medium: the `WIN8_PTP_BUTTONS` gate is
  removed, so any hid-multitouch device that reports ContactCount and a
  new-frame scantime can now treat a 0-count first packet as “all up.”
  HID maintainer and hid-tools tests accepted that. Dropping the outer
  `contact_count >= 0` wrapper means `contact_count == -1` (no
  ContactCount field) can take the else-if; maintainer later called that
  semantically misleading but harmless because `num_expected` stays 0.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
Record:
- Multi-packet “zero contactcount” comment: `c2517f62dac608` (Benjamin
  Tissoires, 2013)
- Win8 PTP 0-touch handling: **`af8dc4d094909` (“HID: multitouch:
  Properly deal with Win8 PTP reports with 0 touches”, Hans de Goede,
  2017-11-22)**
- Application-level `num_expected`: `f146d1c4d7eafd` / `01eaac7e57134`
  (2018)
- `git merge-base --is-ancestor af8dc4d094909 HEAD` → **yes** (exit 0).
  Buggy pattern is old and present here.

### Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** Introduced behavior is the 2017 Win8 PTP
special case that never treated a generic 0-count sentinel as end-of-
frame.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record (this tree, `drivers/hid/hid-multitouch.c`):
- `bdaabb4cf6603` — Yoga Book 9i quirks / `MT_CLS_YOGABOOK9I`
- `a7359de3c246b` — Yoga Book 9 14IAH10 misclassification; adds
  `MT_QUIRK_NOT_SEEN_MEANS_UP` (`INPUT_MT_DROP_UNUSED`)
- `4dfad42f0610f` — Honor ContactCount ghost-contact suppression
  (`MT_QUIRK_CONTACT_CNT_ACCURATE`)
- This candidate is the remaining Yoga Book 9 hid-multitouch fix (author
  said so on-list)

Standalone: yes. v1 cover letter: independent of the ghost-contacts
patch; both sit on the misclassification commit. That misclassification
**is already in this tree.**

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Dave Carey is the Yoga Book 9 hid-multitouch contributor, not
the subsystem maintainer. Same-file commits here: `a7359de3c246b`,
`4dfad42f0610f`. Maintainer Benjamin Tissoires applied this one to
hid.git `for-7.3/upstream-fixes`.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Needs existing `mt_touch_report()` ContactCount / scantime /
  `num_expected` logic — present since 2017–2018.
- For Yoga Book 9 specifically, `MT_QUIRK_NOT_SEEN_MEANS_UP` (so
  `INPUT_MT_DROP_UNUSED` is set) is already here via `a7359de3c246b`.
- `git merge-base --is-ancestor e8e60b6439eed HEAD` → **no** (not in
  this tree).
- Applies standalone; `git apply --check` succeeded (hunk offset −70
  lines).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c e8e60b6439eed`:
  https://patch.msgid.link/20260730124336.637339-1-carvsdriver@gmail.com
- **v1** (2026-05-15):
  https://patch.msgid.link/20260515175253.873796-1-carvsdriver@gmail.com
  — added an `else if (num_received == 0)` branch
- **v2** (2026-05-22): sent as `[PATCH 2/5]` in reply to v1; maintainers
  did not treat it as a proper respin
- **v3** (2026-07-30): same code as v2; standalone subject. Applied
  2026-08-25
- lore.kernel.org WebFetch returned 403; thread recovered via `b4 dig
  -m` and `b4 mbox`

Key review:
- Benjamin on v1: hid-tools testsuite still happy; asked to flatten the
  if/else and add `prev_scantime != scantime`
- Benjamin on v3: `contact_count == -1` path is misleading but harmless;
  negative ContactCount would be clamped to 0 (improvement)
- Applied to hid.git `for-7.3/upstream-fixes` as `e8e60b6439ee`
- No NAK. AI review noted an unrelated pre-existing sticky-finger timer
  UAF in `mt_remove()`, not introduced here
- No reviewer `Cc: stable`

### Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc `linux-input@vger.kernel.org`, Jiri Kosina
(`jikos@kernel.org`), Benjamin Tissoires (`bentiss@kernel.org`). HID
maintainer reviewed and merged.

### Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Author described HID capture behavior and
tested on Yoga Book 9 14IAH10 (83KJ). Same author as the two Yoga Book 9
commits already in this tree.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Intended as the last of three Yoga Book 9 hid-multitouch fixes.
The other two are already in this 6.12 tree. v2’s “2/5” was a mistaken
subject, not a hard series dependency. No later same-file follow-up on
origin/master besides an unrelated ASUS ROG Z13 quirk.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No stable@ discussion found. Commit has no Cc: stable. Not a
negative signal.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS
Record: **`mt_touch_report()`** only. Nearby: `mt_sync_frame()`,
`mt_process_slot()`, `mt_touch_input_configured()`.

### Step 5.2: TRACE CALLERS
Record: Only caller is `mt_report()` when `rdata->is_mt_collection`.
That is the HID `.report` callback for incoming device reports.
Interrupt/HID-completion context, not a syscall. Triggered by touching
the panel. `CONFIG_HID_MULTITOUCH` (`drivers/hid/Kconfig`).

### Step 5.3: TRACE CALLEES
Record: Reads `app->raw_cc` / `app->scantime`; walks slots via
`mt_process_slot()`; then `if (num_received >= num_expected)
mt_sync_frame()` → `input_mt_sync_frame()` + `input_sync()`. Yoga Book 9
sets `INPUT_MT_DROP_UNUSED` from `MT_QUIRK_NOT_SEEN_MEANS_UP` in
`mt_touch_input_configured()`.

### Step 5.4: FOLLOW THE CALL CHAIN
Record: USB/I2C HID report → `mt_report()` → `mt_touch_report()`.
Userspace-visible via evdev. Unprivileged user touching the screen can
trigger it.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same 0-count first-packet case already existed for
`MT_QUIRK_WIN8_PTP_BUTTONS` (`af8dc4d094909`). This generalizes that
handling. No duplicate fix already in this tree (`git log --grep` for
“stale MT” / “contact count drops” on the file: empty).

semcode MCP: not available; used grep/read.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- `git describe HEAD` → **`p-6.12-3-gc504cf0baa3d8`**
- `make kernelversion` → **6.12.111**
- Branch: **pending-6.12**
- Buggy block is at `drivers/hid/hid-multitouch.c:1254-1268`
- Yoga Book 9 class with `NOT_SEEN_MEANS_UP | ALWAYS_VALID |
  CONTACT_CNT_ACCURATE` is at lines 411–421
- Introduced in generic form in **v4.15-era (2017)**; this device class
  is already backported here

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **`git apply --check` succeeded** (hunk at line 1251, offset
−70). Surrounding `mt_touch_report()` matches mainline. **Clean apply /
trivial offset.**

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Misclassification + ContactCount-accurate quirks are here. They
do **not** reset `num_expected` on a 0-count sentinel. No equivalent of
`e8e60b6439eed` is in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **HID multitouch input driver** (`drivers/hid/hid-
multitouch.c`). **IMPORTANT** (laptop touchscreens/touchpads), not core
mm/fs. Affects all hid-multitouch devices for the ContactCount=0 path;
the reported user is Yoga Book 9, already enabled here.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Active (device IDs, quirks, Yoga Book 9, OOB fixes). This is a
late correctness fix on long-standing frame-sync logic, not a refactor
of new code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / hardware-specific** for the reported failure
(Yoga Book 9 14IAH10, USB 17EF:6161). The code path is generic hid-
multitouch. Users of this 6.12 tree already have the rest of that
device’s support, so they can hit the leftover stuck-touch bug.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Lift all fingers; firmware sends ContactCount=0 instead of
omitting the frame. Common on this device (author: “immediately
following the last finger lift”). Unprivileged physical touch. Timing:
every lift, not a rare race.

UNVERIFIED: firmware HID descriptor was not dumped here to prove
`HID_DG_SCANTIME` exists. v3 includes the scantime-change guard and
carries `Tested-by` on this hardware, so scantime almost certainly
changes; the Yoga Book 9 report-descriptor fixup does not strip usage
0x56 (`HID_DG_SCANTIME`).

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: **Stuck/stale multitouch slots; missed finger-up; userspace
gesture state corruption.** Not a kernel oops. **HIGH** for that
hardware (touch becomes wrong after lift). Fits stable-rules “hardware
quirk” / “oh, that's not good.”

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** Completes already-backported Yoga Book 9 support; stops
  stuck fingers and ghost slots on 0-count frames. Also helps any
  similar sentinel-frame firmware.
- **Risk:** Low. ~19-line logic change, continuation path preserved,
  hid-tools passed, maintainer reviewed the `-1` ContactCount case.
- **Ratio:** Benefit outweighs risk on this tree.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real user-visible bug on shipping hardware (Lenovo Yoga Book 9
  14IAH10)
- This 6.12 tree already has the two prior Yoga Book 9 hid-multitouch
  fixes; without this, 0-count frames still leave slots active and can
  even feed `CONTACT_CNT_ACCURATE` with a stale expected count
- Small, obviously targeted change; applies cleanly
- Tested by the author; HID maintainer reviewed (v1 testsuite + v3
  semantic check) and merged
- Matches stable rules’ hardware-quirk / input-correctness category
- Continuation / multi-packet path explicitly preserved

**AGAINST backporting:**
- Not a crash, UAF, or security issue
- Widens 0-count handling beyond `MT_QUIRK_WIN8_PTP_BUTTONS`
- No Fixes:/Cc: stable (not a negative by itself)
- Niche dual-screen laptop as the reporter

**UNRESOLVED:**
- No independent HID dump confirming scantime on this firmware
  (mitigated by Tested-by on v3)
- No distribution-kernel bugzilla

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — maintainer + hid-tools +
   author Tested-by
2. Fixes a real bug that affects users? **PASS** — missed finger-up /
   stuck slots on a supported laptop
3. Important issue? **PASS** — hardware input correctness / firmware
   quirk, not theoretical
4. Small and contained? **PASS** — one function, ~19 lines
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check` clean;
   prerequisites present

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/DT/build/docs exception. Closest: **hardware
firmware workaround** in an existing driver, which stable explicitly
allows.

### Step 9.4: MAKE YOUR DECISION
This 6.12 tree already enables the Yoga Book 9 touchscreen and the
ContactCount-accurate / DROP_UNUSED quirks. The remaining bug is that a
firmware 0-count sentinel never completes the frame, so slots are not
released. The fix is small, reviewed, tested, and applies here. Backport
it.

---

### What the commit solves for stable users
On kernels that already have Yoga Book 9 hid-multitouch support (this
tree does), lifting fingers can leave MT slots active because
ContactCount=0 does not reset `num_expected`. Userspace then misses the
up events. The patch forces a frame sync on a new 0-count packet so
`INPUT_MT_DROP_UNUSED` runs.

### Stable rules / risk vs benefit
Meets the written rules: real bug, small, no new API, applies cleanly.
Risk is a slightly broader 0-count interpretation; that was reviewed and
is the same condition Win8 PTP already used for button-only frames.

### Concerns
No crash/CVE; generic path rather than a Yoga-Book-only quirk table
entry. Still appropriate because the buggy code and the device class are
both in this checkout.

---

Verification:
- [Phase 1] Parsed tags: Tested-by Dave Carey; SOB Dave Carey + Benjamin
  Tissoires; no Fixes/Reported-by/Cc: stable/Link
- [Phase 2] Diff: one hunk in `mt_touch_report()`; 0-count new frames
  set `num_expected=0`; Win8 PTP quirk gate removed
- [Phase 2] Local code at `drivers/hid/hid-multitouch.c:1254-1268`
  matches pre-patch logic
- [Phase 2] Yoga Book 9 class at 411–421 has `NOT_SEEN_MEANS_UP |
  ALWAYS_VALID | CONTACT_CNT_ACCURATE`
- [Phase 3] `git describe HEAD` = p-6.12-3-gc504cf0baa3d8; `make
  kernelversion` = 6.12.111
- [Phase 3] blame: Win8 0-touch logic from `af8dc4d094909` (2017);
  ancestor of HEAD
- [Phase 3] `git merge-base --is-ancestor e8e60b6439eed HEAD` = not
  present
- [Phase 3] Related commits in this tree: `a7359de3c246b`,
  `4dfad42f0610f`, `bdaabb4cf6603`
- [Phase 3] Author’s other hid-multitouch commits: those two Yoga Book 9
  fixes
- [Phase 4] `b4 dig -c e8e60b6439eed`: v3 at
  patch.msgid.link/20260730124336.637339-1-carvsdriver@gmail.com
- [Phase 4] `b4 dig -a`: v1 2026-05-15, v3 2026-07-30 (v2 mistagged 2/5)
- [Phase 4] `b4 dig -w`: linux-input, jikos, bentiss
- [Phase 4] mbox: Benjamin hid-tools OK on v1; requested scantime guard;
  v3 applied for-7.3/upstream-fixes; -1 contact_count called harmless
- [Phase 4] lore WebFetch 403; used b4 mbox instead
- [Phase 5] `mt_touch_report` only called from `mt_report()` on MT
  collections
- [Phase 5] `INPUT_MT_DROP_UNUSED` set from `MT_QUIRK_NOT_SEEN_MEANS_UP`
  in `mt_touch_input_configured()`
- [Phase 6] `git apply --check` of `e8e60b6439eed` succeeded at offset
  −70
- [Phase 6] no local equivalent fix (`git log --grep` on the file empty
  for this bug)
- [Phase 7] CONFIG_HID_MULTITOUCH in `drivers/hid/Kconfig`
- [Phase 8] Failure mode: stale MT slots / missed finger-up / gesture
  corruption, severity HIGH for that hardware
- UNVERIFIED: no firmware HID dump confirming scantime on 17EF:6161
  (Tested-by on v3 is the evidence)
- UNVERIFIED: no stable@ thread (search not useful; lore fetch blocked)

**YES**

 drivers/hid/hid-multitouch.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 2461d84eb0e98..8dd69c6e7edf8 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1332,21 +1332,18 @@ static void mt_touch_report(struct hid_device *hid,
 	 * Includes multi-packet support where subsequent
 	 * packets are sent with zero contactcount.
 	 */
-	if (contact_count >= 0) {
+	if (contact_count > 0)
+		app->num_expected = contact_count;
+	else if (app->num_received == 0 && app->prev_scantime != scantime) {
 		/*
+		 * New multi-report frame:
+		 *
 		 * For Win8 PTPs the first packet (td->num_received == 0) may
 		 * have a contactcount of 0 if there only is a button event.
-		 * We double check that this is not a continuation packet
-		 * of a possible multi-packet frame be checking that the
-		 * timestamp has changed.
+		 *
+		 * Some other devices use a sentinel frame with 0 to release all contacts
 		 */
-		if ((app->quirks & MT_QUIRK_WIN8_PTP_BUTTONS) &&
-		    app->num_received == 0 &&
-		    app->prev_scantime != scantime)
-			app->num_expected = contact_count;
-		/* A non 0 contact count always indicates a first packet */
-		else if (contact_count)
-			app->num_expected = contact_count;
+		app->num_expected = 0;
 	}
 	app->prev_scantime = scantime;
 
-- 
2.53.0

