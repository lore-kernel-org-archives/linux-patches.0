Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F29562603;
	Mon, 19 Oct 2026 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418383; cv=none; b=apKpi5Q2aQ0kg2eFeupQ4BxgUNzr6zXKJnoOCmq3iDPpXaT+ExRVeMK3KZMB8dWn4QYhtEoQwjn/TNbjZBGlPcTGMuAWOKxg9lIGqcrmSjw2AG8laMqIIuLtDj9lAYDKQ4YQTbbfjqpfHIlddX2opyLre1pjnuCB03cMN8s0gZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418383; c=relaxed/simple;
	bh=ZgQ6IG3/9L98G0Gm0xaMLLQ6yNfAtV+hIlmhy7XoHaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gkcsqntlpE9gq9MP5bk076BKWAGIz02yFtWTZFYe2LF3tPZWGdp8w4Aa+BXvQm4D+xyg8fDL99hhp9+be533MQ23rq8TbODv+o8HqT0+Nnoeen6yN6z3/BER0l3fBwSte8Lk5B1wXI5MEv1Yho7YylUs/gsYX7a3sATIztgSULg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NjTjxpRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjTjxpRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B643B1F000C9;
	Mon, 19 Oct 2026 13:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418379;
	bh=rD2KxmotcfM8IGAGm9A/rw+ymS4q5qqa6HG40p80LfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjTjxpRZAKJYnNK3NxzDhK+2p9TBlF+7TxB4xqa8+7PQrTxXXnumLRQ8GIOz+Wjtm
	 8ZSsGt2mt6nKi9W+PrnWBDx1hWC8dEmybttW3yODDtLmW7oQNer8CmRhYnngO3bERR
	 EuMQHXB6cVFeoTw0P5ctGiakPjRXgeG0e82D35GshDa6SgiczSpTyG5t3qf0NYMXXM
	 hWcDCFMkGtFEWsKu01+G3KXePBOo8sMa51QpQ6CpkBVtXwVRCgrDtHNanvqvgOj9LA
	 CM5JR0HOiLKi9mq4HuGhla59iM6gwL3JuTmCWyQoxGAzk9YxDipA8a0uXrwtVPdQQB
	 Oct7WEXQXj80w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Berke Durak <berke.durak@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] HID: elecom: Add support for ELECOM M-XT4DRBK (018E)
Date: Mon, 19 Oct 2026 09:48:18 -0400
Message-ID: <20261019135441.1420968-207-sashal@kernel.org>
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

From: Berke Durak <berke.durak@gmail.com>

[ Upstream commit f3c2b266b8fd7cf816d36168d19f67e716f2c080 ]

The 2025 revision of the left-handed EX-G wireless trackball
(M-XT4DRBK-G) reports USB ID 056e:018e instead of 056e:00fd. Its report
descriptor declares an 8-bit button field (Report Count 8) but only five
usages (Usage Maximum 5), so the sixth (Fn) button ends up as a
duplicate of button 5 and is unusable.

The report descriptor has the same layout as the M-XT3DRBK 018C
(button usage maximum at offset 16, button report count at 22, button
report size at 24, padding report size at 30), so reuse that fixup.

Rename the existing M_XT4DRBK define to M_XT4DRBK_00FD to match the
convention used for the other EX-G revisions.

Tested on a Raspberry Pi 5 with the same fixup in an
out-of-tree module on 6.12 (6.12.96+rpt-rpi-2712);
all six buttons are reported after the fix, and they
work (tested with xev as well).

Report descriptor as sent by the device, pre-fix (056e:018e,
215 bytes):

 05 01 09 02 A1 01 09 01 A1 00 85 01 05 09 19 01
 29 05 15 00 25 01 95 08 75 01 81 02 95 01 75 00
 81 01 05 01 09 30 09 31 16 00 80 26 FF 7F 75 10
 95 02 81 06 C0 A1 00 05 01 09 38 15 81 25 7F 75
 08 95 01 81 06 C0 A1 00 05 0C 0A 38 02 95 01 75
 08 15 81 25 7F 81 06 C0 C0 06 01 FF 09 00 A1 01
 85 02 09 00 15 00 26 FF 00 75 08 95 07 81 02 C0
 05 0C 09 01 A1 01 85 05 15 00 26 3C 02 19 00 2A
 3C 02 75 10 95 01 81 00 C0 05 01 09 80 A1 01 85
 03 19 81 29 83 15 00 25 01 95 03 75 01 81 02 95
 01 75 05 81 01 C0 06 BC FF 09 88 A1 01 85 04 95
 01 75 08 15 00 26 FF 00 19 00 2A FF 00 81 00 C0
 06 02 FF 09 02 A1 01 85 06 09 02 15 00 26 FF 00
 75 08 95 07 B1 02 C0

Assisted-by: LLM
Signed-off-by: Berke Durak <berke.durak@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.57** (`v6.18.57-155-gcdf239ca885b2`). The
question is whether this HID/elecom USB-ID + report-descriptor fixup
should be backported here. The driver, the existing
`mouse_button_fixup()` helper, and the sibling 018C fixup are all
already present in 6.18.57.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[HID / elecom] [Add support] [USB ID 056e:018e for the 2025
M-XT4DRBK-G trackball, plus the existing button report-descriptor
fixup]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- No `Fixes:` tag (expected for this review)
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:`
- No `Link:`
- No `Cc: stable@vger.kernel.org` (expected; not a negative)
- `Assisted-by: LLM`
- `Signed-off-by: Berke Durak <berke.durak@gmail.com>` (author)
- `Signed-off-by: Jiri Kosina <jkosina@suse.com>` (HID maintainer)
- Ignore pipeline `Signed-off-by: Sasha Levin` and `[Upstream commit
  ...]`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: 2025 left-handed EX-G wireless trackball (M-XT4DRBK-G) uses USB
  ID `056e:018e` instead of the old `056e:00fd`.
- Descriptor claims an 8-bit button field (`Report Count 8`) but only
  five usages (`Usage Maximum 5`), so the sixth (Fn) button is a
  duplicate of button 5 and is unusable.
- Root cause: same broken descriptor layout as M-XT3DRBK 018C (offsets
  16/22/24/30).
- Symptom: extra button does not work; mouse otherwise enumerates.
- Author tested on Raspberry Pi 5, 6.12 (`6.12.96+rpt-rpi-2712`), via an
  out-of-tree module; all six buttons work (`xev`).
- Full 215-byte pre-fix descriptor is included.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is a device-ID addition plus an
existing HID report-descriptor quirk. The rename `M_XT4DRBK` →
`M_XT4DRBK_00FD` is local naming only.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `drivers/hid/hid-ids.h`: +1 ID (`0x018e`), rename existing `0x00fd`
  define
- `drivers/hid/hid-elecom.c`: +1 case in `elecom_report_fixup()`, +1
  `elecom_devices[]` entry, rename 00FD references
- `drivers/hid/hid-quirks.c`: +1 `hid_have_special_driver[]` entry,
  rename 00FD
- Scope: 8 insertions, 4 deletions across 3 files. Surgical, existing
  driver only.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: `056e:018e` is not in hid-elecom, so hid-generic binds and the
  stock descriptor is used (Usage Maximum 5 / Count 8). Old `056e:00fd`
  still uses the 6-button fixup via `USB_DEVICE_ID_ELECOM_M_XT4DRBK`.
- After: `018e` is claimed by hid-elecom and runs
  `mouse_button_fixup(..., 22, 30, 24, 16, 6)` (same as 018C). Old 00FD
  device still hits the same 6-button fixup through the renamed define.
  `hid_have_special_driver` keeps hid-generic from binding 018E.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: `[Hardware workaround / device ID + HID descriptor quirk]`
- Broken HID report descriptor: Usage Maximum 5 vs Report Count 8.
- Fix reuses the proven 018C path: set count and usage max to 6, padding
  to 2.

Verified against the included descriptor (first 32 bytes):
```
offset 16: 29 05  Usage Maximum (5)
offset 22: 95 08  Report Count (8)
offset 24: 75 01  Report Size (1)
offset 30: 75 00  padding Report Size (0)
```
Those match `mouse_button_fixup(hdev, rdesc, *rsize, 22, 30, 24, 16,
6)`. The helper then writes count=6, usage max=6, padding=2. The 018C
commit in this tree used the identical dump.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: new ID, existing helper, offsets match the dump.
- Minimal: no new APIs, no new helper, no behavior change for 00FD.
- Rename is kernel-internal (`hid-ids.h`); grep shows no leftover
  `USB_DEVICE_ID_ELECOM_M_XT4DRBK` users.
- Regression risk is low: `mouse_button_fixup()` bails out unless the
  expected HID items are at those offsets, so a mismatched 018E
  descriptor would be left unchanged.
- `hid-quirks.c` update is required so hid-generic does not steal the
  device (`HID_QUIRK_HAVE_SPECIAL_DRIVER`).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Original M-XT4DRBK 00FD support: `fbb77e88f08ce` (2018, Tomasz
  Kramkowski), already in 6.18.57.
- Parameterized `mouse_button_fixup()`: `68d09380a6278` (2020), already
  in 6.18.57.
- 018C sibling layout this patch reuses: `da1880c7b6b83` (Arnoud
  Willemsen), already in 6.18.57 (`git merge-base --is-ancestor`
  returned 0).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not a regression in previously working 018E
support; 018E was never in this tree. The bug is the device’s
descriptor, same class as 00FD/018C.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `hid-elecom.c` history is the same pattern of “new USB ID
+ existing fixup”:
- `cdcbb8e8d10f6` M-XT3URBK 018F (in 6.18.57)
- `da1880c7b6b83` M-XT3DRBK 018C (in 6.18.57)
- `a36e053b16804` HUGE Plus M-HT1MRBK (in 6.18.57)
Standalone; not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Berke Durak has only this hid-elecom commit here. Jiri Kosina
(HID maintainer) signed off and applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `mouse_button_fixup()` and the 018C case. Both exist at
v6.18.57. No new functions. Can apply standalone. `patch --dry-run` of
this diff onto the v6.18.57 copies of the three files succeeded.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c a6dbbf8a1601a`:
  https://patch.msgid.link/20260907184719.25042-1-berke.durak@gmail.com
- `b4 dig -a`: single revision (v1 only), 2026-09-07
- lore.kernel.org fetches returned 403; discussion confirmed via patchew
  and openwall mirrors
- Jiri Kosina: “Applied, thanks.” No NAK, no requested respin, no
  stable-risk comments

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc Jiri Kosina, Benjamin Tissoires, linux-
input, linux-kernel. HID maintainer applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot link. The author is the reporter and tester,
with a full descriptor dump and xev confirmation. Same failure mode as
018C, which is already in this tree.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone v1. Closely related 018C/018F/HUGE Plus ID+fixup
patches are already in 6.18.57.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: UNVERIFIED. `lore.kernel.org/stable/?q=M-XT4DRBK` returned 403.
No evidence of a prior rejection. Does not change the technical verdict.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `elecom_report_fixup()` (switch cases / id table);
`mouse_button_fixup()` called but not modified; ID tables in `hid-
elecom.c` and `hid_have_special_driver[]`.

**Step 5.2: TRACE CALLERS**
Record:
- `elecom_report_fixup` ← `elecom_driver.report_fixup` ← `hid-core.c`
  `hid_open_report()` (`device->driver->report_fixup(...)` at line 1305)
- `hid_have_special_driver` match ← `hid_gets_squirk()` sets
  `HID_QUIRK_HAVE_SPECIAL_DRIVER` ← `hid_generic_match()` returns false
  so hid-generic does not bind

**Step 5.3: TRACE CALLEES**
Record: `mouse_button_fixup()` only mutates three descriptor bytes after
pattern checks; `hid_info()` log. No allocation, locking, or I/O.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Plug USB receiver → usbhid → hid parse → `report_fixup` → input
events. Userspace-reachable on plug. Unprivileged users then use the
extra button via evdev. Not a security bug; it is a functional hardware
bug.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same pattern already used for 018C, 018F, DT2, HUGE, etc. in
this file. This is the left-handed 2025 wireless counterpart of 018C.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. v6.18.57 has hid-elecom, `mouse_button_fixup()`, and 018C’s
layout, but **not** ID `0x018e`. Without this patch, 018E is a generic
HID mouse with a broken sixth button. The 00FD model is already quirked.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply onto v6.18.57 (`patch --dry-run` rc 0). Parent vs
v6.18.57 differs only by an unrelated ITE keyboard ID later in `hid-
ids.h`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No 018E fix in v6.18.57. 018C/018F/HUGE Plus ID+fixup patches
**are** already in 6.18.57, which is the same stable-accepted class of
change.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `[drivers/hid/hid-elecom.c] [PERIPHERAL / driver-specific]`,
gated by `CONFIG_HID_ELECOM`. Important for owners of this trackball;
not core MM/VFS.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature driver (2010–); recent work is additional ELECOM IDs and
descriptor fixups, several of which already landed in 6.18.y.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / config-specific: users of ELECOM M-XT4DRBK-G
2025 (`056e:018e`) with `CONFIG_HID_ELECOM`. 00FD users are unchanged.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every plug-in of that dongle. Not a race. Unprivileged users see
a missing/duplicated Fn button.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: `[Broken extra mouse button on specific hardware] [MEDIUM
functional / hardware-quirk]`. Not a crash, UAF, or corruption issue.
This is the documented stable exception for USB IDs and hardware quirks.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: 2025 left-handed EX-G trackball gets a working sixth button
  on 6.18.y, matching what 018C already got.
- Risk: very low (8/4 line change, existing helper, pattern-gated,
  maintainer-applied, tested).
- Ratio: high benefit for affected hardware, negligible regression risk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- USB ID + existing HID quirk on an existing driver (stable exceptions 1
  and 2)
- Real user-visible bug: sixth button unusable; author tested the fix
- Descriptor offsets verified against the dump and against 018C already
  in this tree
- Small, obviously correct, no new APIs
- HID maintainer applied v1 with no objections
- Same class of patch (018C/018F/HUGE Plus) already in 6.18.57
- Applies cleanly to this tree

AGAINST:
- Not a crash/security/corruption fix
- Affects one consumer trackball model
- Author is not a regular HID contributor; patch notes `Assisted-by:
  LLM` (mitigated by maintainer apply + dump + test)

UNRESOLVED:
- Could not fetch lore.kernel.org (403) or search stable@ archives
  directly; discussion recovered from b4/patchew/openwall

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — offsets match; author
   tested; maintainer applied
2. Fixes a real bug that affects users? **PASS** — Fn button unusable
   without the quirk
3. Important issue? **PASS** under the hardware-quirk / new-ID exception
   (severity MEDIUM, not CRITICAL)
4. Small and contained? **PASS** — 8 insertions / 4 deletions, 3 files
5. No new features or APIs? **PASS** — ID + existing fixup only
6. Can apply to the local tree? **PASS** — clean apply to v6.18.57;
   prerequisites present

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Device ID addition to existing driver** and **hardware
quirk/workaround**. Both qualify for stable.

**Step 9.4: MAKE YOUR DECISION**
YES. This is the same HID-elecom USB-ID + report-descriptor quirk 6.18.y
has already taken for 018C. It does not add a driver or API; it makes a
current ELECOM trackball’s sixth button work.

What the commit solves: the 2025 M-XT4DRBK-G (`056e:018e`) ships a
descriptor that only declares five button usages, so Linux reports the
Fn button as a duplicate of button 5. The fix binds that ID to hid-
elecom and reuses the 018C `mouse_button_fixup()`.

Risk vs benefit: benefit is a working extra button on real hardware;
risk is a few table entries and a pattern-checked 3-byte descriptor
edit. 00FD behavior is unchanged.

No extra prerequisites; 018C’s helper and case are already in this tree.

Verification:
- [Phase 1] Parsed tags: author + Jiri Kosina SOB; no Fixes/Cc
  stable/Reported-by; LLM-assisted
- [Phase 1] Body: 056e:018e, Usage Maximum 5 vs Count 8, sixth button
  unusable; tested on Pi 5 / 6.12
- [Phase 2] Diff: +8/-4 in hid-elecom.c, hid-ids.h, hid-quirks.c; rename
  00FD define; add 018E to 018C fixup
- [Phase 2] Descriptor offsets 16/22/24/30 verified against the dump
- [Phase 3] `git describe HEAD` / Makefile: local tree is 6.18.57
- [Phase 3] `git merge-base --is-ancestor a6dbbf8a1601a v6.18.57` → not
  in v6.18.57 (exit 1)
- [Phase 3] 00FD support `fbb77e88f08ce` and 018C `da1880c7b6b83` are
  ancestors of v6.18.57
- [Phase 3] v6.18.57 still uses `USB_DEVICE_ID_ELECOM_M_XT4DRBK` only;
  no 018E
- [Phase 3] Author has no other hid-elecom commits here
- [Phase 4] `b4 dig -c`: msgid
  20260907184719.25042-1-berke.durak@gmail.com; v1 only
- [Phase 4] `b4 dig -w`: Kosina + Tissoires + linux-input; Kosina
  applied
- [Phase 4] lore.kernel.org 403; patchew/openwall used instead
- [Phase 4] UNVERIFIED: stable@ archive search (403)
- [Phase 5] Callers: hid-core `report_fixup` on probe; hid-generic skips
  via `HID_QUIRK_HAVE_SPECIAL_DRIVER`
- [Phase 6] `patch --dry-run` onto v6.18.57 files: success
- [Phase 6] Related 018C/018F/HUGE Plus ID patches already in 6.18.57
- [Phase 8] Failure mode: extra button unusable, not a kernel crash
- UNVERIFIED: original lore HTML (403); does not affect the decision

**YES**

 drivers/hid/hid-elecom.c | 6 ++++--
 drivers/hid/hid-ids.h    | 3 ++-
 drivers/hid/hid-quirks.c | 3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-elecom.c b/drivers/hid/hid-elecom.c
index 37d88ce57f671..d21ead40bb076 100644
--- a/drivers/hid/hid-elecom.c
+++ b/drivers/hid/hid-elecom.c
@@ -79,7 +79,7 @@ static const __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	case USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB:
 	case USB_DEVICE_ID_ELECOM_M_XT3URBK_018F:
 	case USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC:
-	case USB_DEVICE_ID_ELECOM_M_XT4DRBK:
+	case USB_DEVICE_ID_ELECOM_M_XT4DRBK_00FD:
 		/*
 		 * Report descriptor format:
 		 * 12: button bit count
@@ -104,6 +104,7 @@ static const __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		mouse_button_fixup(hdev, rdesc, *rsize, 12, 30, 14, 20, 8);
 		break;
 	case USB_DEVICE_ID_ELECOM_M_XT3DRBK_018C:
+	case USB_DEVICE_ID_ELECOM_M_XT4DRBK_018E:
 		/*
 		 * Report descriptor format:
 		 * 22: button bit count
@@ -148,7 +149,8 @@ static const struct hid_device_id elecom_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_018C) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK_00FD) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK_018E) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1URBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT2DRBK) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index a10b4ae0e3d8e..ca5c62f29aebe 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -466,7 +466,8 @@
 #define USB_DEVICE_ID_ELECOM_M_XT3URBK_018F	0x018f
 #define USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC	0x00fc
 #define USB_DEVICE_ID_ELECOM_M_XT3DRBK_018C	0x018c
-#define USB_DEVICE_ID_ELECOM_M_XT4DRBK	0x00fd
+#define USB_DEVICE_ID_ELECOM_M_XT4DRBK_00FD	0x00fd
+#define USB_DEVICE_ID_ELECOM_M_XT4DRBK_018E	0x018e
 #define USB_DEVICE_ID_ELECOM_M_DT1URBK	0x00fe
 #define USB_DEVICE_ID_ELECOM_M_DT1DRBK	0x00ff
 #define USB_DEVICE_ID_ELECOM_M_DT2DRBK	0x018d
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 8d2ac32c5ac12..debd00ed9062a 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -431,7 +431,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_00FC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3DRBK_018C) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK_00FD) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT4DRBK_018E) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1URBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT1DRBK) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_DT2DRBK) },
-- 
2.53.0

