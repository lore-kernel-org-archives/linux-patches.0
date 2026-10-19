Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F00C5AE425;
	Mon, 19 Oct 2026 14:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418420; cv=none; b=C1fP4L2aEqmvQAVOoAlX++U5ohezsbD/wHg30WnY4+11OKSIBIgM2dPj5EqXQnz0KqVRssISINHr7dZvVvfqzxj6Oxz45ikAPTm36f6jKh8geWow93LDfxZWzppu1U50h1xXeD+L//4u98qIiz87DaBay0MUc8y+GGjgcnntT/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418420; c=relaxed/simple;
	bh=S7lFVMJ7BuzOzRErbq+8DCMi8gciIwlNEf4wOXl4KwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FdjqWTqRytOZqRbcZR9x+AqtONkC35EQEkiOLYlXeX1NEkDo7G62roDkX37hqiEokepMJTSneN+wON+jEDY4Nv+zkFsLWNAJz68TX44e9rW3tlCqmTTizFFdAOoMPeBbQcUMWuSWUUGrFsrosYNB+DbUEn3j3bXfZQ6JyRdWeYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ViTNwOlB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ViTNwOlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A3C1F000C7;
	Mon, 19 Oct 2026 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418417;
	bh=9qDIuP05gODfi9cm0VZadgzeBQpP5mTAh4M1Ws5ntiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViTNwOlBabYK9xvI7uMKgTgEf/POqPhwMwTucEDi8aMiLc7nbo1dh00dNlS4Z8HbI
	 aY+2SQGqa1IZ15vBe3Hn2uvwn5OXJJk72nlQmiSzD+CKungge6PgNKgfuhnxJZvZBP
	 PQhrGOW3cjL5G1nwy2nC4oJn3nLGeLiyMr8udMOt1SsrK6qDzPLAk6lOSx6pfSZWwL
	 19LoSxU5yTCPHKX0BxAryW1d2iWsdDsNv6izEhUT0zghmPT0FMGfovbR1bFduzDBqK
	 VoA8c+AtTs+9d7UE0U8YDoPMI/0act2C132IzeupMwDxddTDgbA5gJyR9tfQ31AQGj
	 4k/VEd0ogYprA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Wilhelm <alexander.wilhelm@westermo.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	jjohnson@kernel.org,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] wifi: ath12k: fix scan command endianness on big endian
Date: Mon, 19 Oct 2026 09:48:45 -0400
Message-ID: <20261019135441.1420968-234-sashal@kernel.org>
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

From: Alexander Wilhelm <alexander.wilhelm@westermo.com>

[ Upstream commit 6c90f68f97de591e0413f7d2de59449a0388bbab ]

ath12k_wmi_scan_req_arg stores scan parameters in CPU-native byte order,
while ath12k_wmi_send_scan_start_cmd() writes them into a WMI command
buffer whose contents must be in little-endian format. The existing code
copies the channel list and writes s_ssid and hint_bssid related values to
the command buffer without endian conversion. As a result, scan requests
contain invalid parameters on big-endian systems and fail.

Convert the channel list as well as the s_ssid and hint_bssid related
values to little-endian before writing them to the WMI command buffer. This
preserves the existing behaviour on little-endian systems while fixing scan
requests on big-endian architectures.

Signed-off-by: Alexander Wilhelm <alexander.wilhelm@westermo.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260703-fix-channel-list-copy-v2-1-372c39306d79@westermo.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (mainline). The buggy ath12k scan path is
present here, and this is a small, real endianness fix for scan commands
on big-endian hosts.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: **[ath12k / wifi] [fix] [scan WMI command missing little-
  endian conversion on big-endian]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - No `Fixes:` tag (expected for this review)
  - No `Reported-by:` / `Tested-by:` / `Cc: stable`
  - `Reviewed-by: Rameshkumar Sundaram
    <rameshkumar.sundaram@oss.qualcomm.com>` (Qualcomm ath12k)
  - `Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>`
    (Qualcomm ath12k)
  - `Link: https://patch.msgid.link/20260703-fix-channel-list-
    copy-v2-1-372c39306d79@westermo.com`
  - `Signed-off-by: Alexander Wilhelm <alexander.wilhelm@westermo.com>`
    (author; Westermo)
  - `Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>`
    (ath12k maintainer; applied)
  - Ignore pipeline-added Sasha Levin SOB if present (not on this
    commit)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record:
  - **Bug:** `ath12k_wmi_scan_req_arg` is CPU-endian; the WMI start-scan
    buffer must be little-endian. Channel list is `memcpy`'d; `s_ssid` /
    `hint_bssid` integers are assigned without `cpu_to_le32`.
  - **Symptom:** scan start commands carry invalid channel/hint values
    on big-endian; scans fail.
  - **Root cause:** missing endian conversion on those TLV payloads
    (other scalar fields in the same function already use
    `cpu_to_le32`).
  - **Version info:** none in the message. Buggy code dates to the
    original ath12k driver.

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: **Not a hidden fix.** Subject and body state an endianness
  correctness bug. Not cleanup/refactor.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- Record:
  - `drivers/net/wireless/ath/ath12k/wmi.c`: 20 insertions / 8 deletions
  - `drivers/net/wireless/ath/ath12k/wmi.h`: 10 insertions
  - **Net:** +22 / −8, two files
  - **Function:** `ath12k_wmi_send_scan_start_cmd()`
  - **Scope:** single-function surgical fix plus two local wire-format
    structs

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record:
  - **Channel list:** `memcpy` of host `u32` channel frequencies → per-
    element `cpu_to_le32` into `__le32 *`.
  - **Hint short SSID:** raw `u32` assigns → `cpu_to_le32` into
    `ath12k_wmi_hint_short_ssid_params` (`__le32` fields).
  - **Hint BSSID:** `freq_flags` raw assign → `cpu_to_le32` into
    `ath12k_wmi_hint_bssid_params`.
  - **Normal path** (every scan start), not an error-only path. LE
    behavior unchanged (`cpu_to_le32` is identity on LE).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record: **[Type / endianness]** Host-endian `u32`s were placed in a LE
  WMI buffer. Firmware then sees swapped channel numbers (e.g. 2412 /
  `0x0000096c` becomes `0x6c090000`) and rejects or mis-handles the
  scan.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record: **Obviously correct.** Same function already converts
  `num_chan`, dwell times, SSID length, etc. with `cpu_to_le32`. New
  `*_params` structs match existing `ath12k_wmi_ssid_params` (`__le32
  ssid_len`). **Regression risk: very low** on LE; no
  API/locking/refcount change. Review found a pre-existing swapped
  `ether_addr_copy` on hint BSSID; that was **not** mixed into this
  patch (separate commit `7b0bd40e97a00`).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record: Buggy `memcpy(tmp_ptr, arg->chan_list, ...)` and hint field
  copies come from **`d889913205cf7` (“wifi: ath12k: driver for Qualcomm
  Wi-Fi 7 devices”)**, Kalle Valo, 2022-11-28. First appeared in
  **v6.3-rc1**. Long-lived, not recent churn.

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: **No `Fixes:` tag.** Introduction commit is `d889913205cf7`,
  ancestor of this HEAD (`git merge-base --is-ancestor` of the fix
  itself is true). This tree contains both the original driver and the
  fix.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Record:
  - Immediate predecessor on this function: `7b0bd40e97a00` “Correctly
    copy the hint BSSID in WMI scan request” (same day in the ath tree).
    Independent bug (copy direction).
  - Later `wmi.c` commits (`c42b27336eeff`, TLV/overread fixes) do
    **not** revert or rework this endian conversion.
  - Same author earlier: `9eb6f553026e1` “enforce CPU endian format for
    all QMI data” — same BE enablement effort.
  - **Standalone** for the endian bug; not patch N/M of a series (v2 of
    a single patch).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: Alexander Wilhelm (Westermo) has ath12k BE work; not the
  subsystem maintainer. Applied by **Jeff Johnson** (Qualcomm ath12k
  maintainer) after Qualcomm reviews.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: No new helpers. Uses existing `cpu_to_le32`. Hint `*_params`
  structs are added in this patch. `7b0bd40e97a00` is **not** a semantic
  prerequisite for channel-list conversion; it only changes
  `ether_addr_copy` argument order. **Can apply standalone** (possible
  one-hunk context mismatch on trees that still have the swapped copy).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record:
  - Lore/msgid: `https://patch.msgid.link/20260703-fix-channel-list-
    copy-v2-1-372c39306d79@westermo.com`
  - **v1:** 2026-03-17? (msgid dated 2026-06-29) “fix channel list copy
    on big endian”
  - **v2:** 2026-07-03 “fix scan command endianness on big endian” —
    rebase; also convert `s_ssid` / `hint_bssid`; reworded message
  - Applied version is **v2** (latest).
  - **No NAK.** Baochen asked whether to also fix swapped
    `ether_addr_copy`; Jeff: **separate patch**. Rameshkumar and Baochen
    `Reviewed-by`. Jeff: “Applied, thanks!”
  - **No reviewer `Cc: stable`.**

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record: Recipients: Jeff Johnson, Baochen Qiang, `linux-wireless`,
  `ath12k@lists.infradead.org`, `linux-kernel`. Right maintainers/lists.
  Two Qualcomm `Reviewed-by`s; maintainer applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: No syzbot/bugzilla. Author is a vendor using BE + ath12k
  (consistent with their prior QMI endian patch). Failure mode described
  as scan failure, not a crash dump.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: Single-patch series. Related: `7b0bd40e97a00` (hint BSSID copy
  direction), prompted by Baochen on this thread. Not required for the
  channel-list endian fix.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: No stable-list discussion found for this subject. WebSearch on
  `lore.kernel.org/stable` did not return this patch. **UNVERIFIED**
  beyond that search (lore.kernel.org HTTP 403 from this environment).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
- Record: `ath12k_wmi_send_scan_start_cmd()` only. New structs:
  `ath12k_wmi_hint_short_ssid_params`, `ath12k_wmi_hint_bssid_params`.

**Step 5.2: TRACE CALLERS**
- Record:
  - `ath12k_wmi_send_scan_start_cmd` ← `ath12k_start_scan`
    (`mac.c:5407`)
  - `ath12k_start_scan` ← hw scan (`mac.c:5727`, fills `chan_list[i] =
    chan_list[i]->center_freq`)
  - `ath12k_start_scan` ← remain-on-channel (`mac.c:14062`,
    `chan_list[0] = chan->center_freq`)
  - **Userspace-reachable** via nl80211 scan / ROC. Not IRQ.

**Step 5.3: TRACE CALLEES**
- Record: Builds a WMI skb (`ath12k_wmi_alloc_skb`), fills TLVs,
  `ath12k_wmi_cmd_send(..., WMI_START_SCAN_CMDID)`. Firmware then runs
  the scan.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: cfg80211/mac80211 scan or ROC → `ath12k_mac` → WMI start-scan.
  **Yes, userspace-triggerable.** Channel list is always filled on those
  paths. `num_hint_s_ssid` / `num_hint_bssid` are **never assigned** in
  this tree (stay 0 from `kzalloc`); hint conversions are still correct
  but not the live bug. **The live bug is the channel list on every
  scan/ROC.**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: Other fields in the same command already use `cpu_to_le32`.
  `ath12k_wmi_ssid_params` already has `__le32 ssid_len`. Sibling ath11k
  `ath11k_wmi_send_scan_start_cmd` still copies `chan_list` as host
  `u32` without `cpu_to_le32` (ath11k WMI structs are less consistently
  `__le32`). Other ath12k endian fixes exist (`2adcddd8a316e` vdev
  create, `8f1a078842d4a` WMI service bits, `1cfa6d4e5bd9b` HAL TLV).

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: **Yes.** Tree is **v7.3-rc4** (`7.3.0-rc4`, HEAD
  `f0100363d8c37`). ath12k and `ath12k_wmi_send_scan_start_cmd` exist.
  Bug introduced **v6.3**; not after this branch. The fix commit
  `6c90f68f97de5` is already an ancestor of HEAD; current `wmi.c`
  already has the `cpu_to_le32` channel loop. Evaluating technical merit
  for this codebase, not “already queued.”

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: **Clean apply here** (already present). New structs are
  additive. On older stables without `7b0bd40e97a00`, one
  `ether_addr_copy` context hunk may need a trivial refresh; channel-
  list hunk is independent.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: This exact fix is in the tree. No alternate/earlier endian fix
  for this memcpy. No revert.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: **wifi / ath12k (Qualcomm Wi-Fi 7)** — **IMPORTANT** (not
  mm/core; real devices and scan/ROC depend on it).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- Record: **Active** (frequent `wmi.c` fixes). This particular memcpy
  has been wrong since the driver landed in v6.3.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: **Driver-specific + endian-specific:** `CONFIG_ATH12K` on big-
  endian CPUs. LE ath12k (typical x86/ARM) unchanged. Author affiliation
  indicates real BE industrial use.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Record: **Any scan or remain-on-channel.** Common for Wi-Fi (network
  manager, `iw scan`, P2P/ROC). Unprivileged users can trigger scans
  depending on policy; not a UAF/crash primitive. Not a race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- Record: **Scan/ROC commands invalid on BE → scan fails / association
  cannot find APs.** Not oops/deadlock/corruption. **Severity: HIGH**
  for BE ath12k (driver largely unusable for STA), **LOW** for LE
  majority.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Record:
  - **Benefit:** Restores scanning on BE ath12k; no-op on LE.
  - **Risk:** Very low (~22 lines, `cpu_to_le32` only, internal
    structs).
  - **Ratio:** Favorable. Classic endianness driver fix.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real, user-visible bug: WMI scan channel list (and hint integers) not
  converted to LE.
- Hits every hw scan and ROC on BE; firmware gets garbage channel
  numbers.
- Small, matches existing conversions in the same function.
- Present since v6.3; this tree has the driver.
- Reviewed and applied by Qualcomm ath12k maintainers; v2 addressed
  review (hints + rebase).
- `cpu_to_le32` is identity on LE → negligible regression risk.
- Endianness/type bugs are a documented stable category.

**AGAINST:**
- Not crash/UAF/security/deadlock.
- BE + ath12k is a smaller population than x86/ARM LE.
- No `Fixes:` / `Cc: stable` / syzbot (absence expected; not a
  negative).
- Hint paths appear unused in this tree (still correct to convert).

**UNRESOLVED:**
- Full lore.kernel.org HTML was 403; thread recovered via `b4 dig -m`.
- No stable-list thread found.
- No in-tree test proving a specific BE board besides the author’s
  description.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — same conversion pattern as
   the rest of the command; Qualcomm review + maintainer apply. Author
   exercised BE.
2. Fixes a real bug that affects users? **PASS** — scans fail on BE.
3. Important issue? **PASS** — Wi-Fi scan/ROC broken on affected systems
   (endianness correctness), not a style tweak.
4. Small and contained? **PASS** — two files, +22/−8, one function.
5. No new features or APIs? **PASS** — internal `__le32` wire structs
   only.
6. Can apply to the local tree? **PASS** — ath12k WMI scan path exists
   here; hunks match.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Record: Not a device-ID/quirk/DT/build/docs exception. Standard
  correctness fix.

**Step 9.4: MAKE YOUR DECISION**
This tree has the ath12k scan WMI path introduced in v6.3. Missing
`cpu_to_le32` on the channel list makes scanning fail on big-endian; the
patch is small, matches existing WMI encoding, and is a no-op on little-
endian. It meets stable rules for this checkout.

---

## What the commit solves and why it matters

`ath12k_wmi_send_scan_start_cmd()` already converted scalar WMI fields
with `cpu_to_le32`, but copied `chan_list` with `memcpy` and assigned
hint integers in CPU order. On big-endian, firmware sees swapped
frequencies, so scan/ROC fail. Stable users of ath12k on BE cannot scan
or remain-on-channel without this. LE users see no behavior change.

## Risk vs benefit

Benefit is restoring a core Wi-Fi operation on BE. Risk is very low:
surgical conversions, no locking/API change, identity transform on LE.

## Concerns

No functional dependency on other patches for the channel-list fix. Hint
BSSID `ether_addr_copy` direction is a separate commit already in this
tree. Backport to older stables may need a one-line context tweak if
that copy-direction fix is absent.

---

## Verification
- [Phase 1] Parsed tags: two Qualcomm `Reviewed-by`; maintainer SOB;
  msgid.link; no Fixes/stable/syzbot
- [Phase 2] Diff: `wmi.c` + `wmi.h`, +22/−8; `memcpy` → `cpu_to_le32`
  loop; hint fields converted; two `__le32` structs added
- [Phase 3] `git describe HEAD`: `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion`: `7.3.0-rc4`
- [Phase 3] `git merge-base --is-ancestor 6c90f68f97de5 HEAD`: yes (exit
  0)
- [Phase 3] `git blame` on parent: buggy memcpy/assigns from
  `d889913205cf7` (v6.3-rc1)
- [Phase 3] Related: `7b0bd40e97a00` hint BSSID copy; `9eb6f553026e1`
  QMI endian; no revert after this fix
- [Phase 4] `b4 dig -c 6c90f68f97de5`: v2 msgid `20260703-fix-channel-
  list-copy-v2-1-372c39306d79@westermo.com`
- [Phase 4] `b4 dig -a`: v1 channel-list-only → v2 also converts hints
- [Phase 4] `b4 dig -w`: Jeff Johnson, Baochen Qiang, linux-wireless,
  ath12k list
- [Phase 4] mbox: Baochen/Rameshkumar R-b; Jeff applied; swapped
  `ether_addr_copy` deferred to separate patch (no NAK of endian fix)
- [Phase 4] lore.kernel.org fetch: 403; used b4 mbox + mirrors
- [Phase 4] stable list search: no discussion found
- [Phase 5] Callers: `ath12k_start_scan` ← hw scan (`mac.c:5727`) and
  ROC (`mac.c:14062`); both write `chan_list` as `center_freq`
- [Phase 5] `num_hint_*` never assigned in ath12k (remain 0)
- [Phase 6] Current tree already contains the converted loop at
  `wmi.c:2739-2740`
- [Phase 8] Failure: invalid WMI scan params on BE → scan failure; not
  oops
- UNVERIFIED: specific BE board log beyond commit text; full lore HTML

**YES**

 drivers/net/wireless/ath/ath12k/wmi.c | 20 ++++++++++++--------
 drivers/net/wireless/ath/ath12k/wmi.h | 10 ++++++++++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 39d5110eca901..91f293ab70137 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -2666,9 +2666,10 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
 	struct wmi_tlv *tlv;
 	void *ptr;
 	int i, ret, len;
-	u32 *tmp_ptr, extraie_len_with_pad = 0;
-	struct ath12k_wmi_hint_short_ssid_arg *s_ssid = NULL;
-	struct ath12k_wmi_hint_bssid_arg *hint_bssid = NULL;
+	__le32 *tmp_ptr;
+	u32 extraie_len_with_pad = 0;
+	struct ath12k_wmi_hint_short_ssid_params *s_ssid = NULL;
+	struct ath12k_wmi_hint_bssid_params *hint_bssid = NULL;
 
 	len = sizeof(*cmd);
 
@@ -2751,9 +2752,10 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
 	tlv = ptr;
 	tlv->header = ath12k_wmi_tlv_hdr(WMI_TAG_ARRAY_UINT32, len);
 	ptr += TLV_HDR_SIZE;
-	tmp_ptr = (u32 *)ptr;
+	tmp_ptr = (__le32 *)ptr;
 
-	memcpy(tmp_ptr, arg->chan_list, arg->num_chan * 4);
+	for (i = 0; i < arg->num_chan; i++)
+		tmp_ptr[i] = cpu_to_le32(arg->chan_list[i]);
 
 	ptr += len;
 
@@ -2809,8 +2811,10 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
 		ptr += TLV_HDR_SIZE;
 		s_ssid = ptr;
 		for (i = 0; i < arg->num_hint_s_ssid; ++i) {
-			s_ssid->freq_flags = arg->hint_s_ssid[i].freq_flags;
-			s_ssid->short_ssid = arg->hint_s_ssid[i].short_ssid;
+			s_ssid->freq_flags =
+				cpu_to_le32(arg->hint_s_ssid[i].freq_flags);
+			s_ssid->short_ssid =
+				cpu_to_le32(arg->hint_s_ssid[i].short_ssid);
 			s_ssid++;
 		}
 		ptr += len;
@@ -2824,7 +2828,7 @@ int ath12k_wmi_send_scan_start_cmd(struct ath12k *ar,
 		hint_bssid = ptr;
 		for (i = 0; i < arg->num_hint_bssid; ++i) {
 			hint_bssid->freq_flags =
-				arg->hint_bssid[i].freq_flags;
+				cpu_to_le32(arg->hint_bssid[i].freq_flags);
 			ether_addr_copy(&hint_bssid->bssid.addr[0],
 					&arg->hint_bssid[i].bssid.addr[0]);
 			hint_bssid++;
diff --git a/drivers/net/wireless/ath/ath12k/wmi.h b/drivers/net/wireless/ath/ath12k/wmi.h
index 6d9c645e3d5d0..6468d9738639e 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.h
+++ b/drivers/net/wireless/ath/ath12k/wmi.h
@@ -3504,6 +3504,16 @@ struct ath12k_wmi_hint_bssid_arg {
 	struct ath12k_wmi_mac_addr_params bssid;
 };
 
+struct ath12k_wmi_hint_short_ssid_params {
+	__le32 freq_flags;
+	__le32 short_ssid;
+};
+
+struct ath12k_wmi_hint_bssid_params {
+	__le32 freq_flags;
+	struct ath12k_wmi_mac_addr_params bssid;
+};
+
 struct ath12k_wmi_scan_req_arg {
 	u32 scan_id;
 	u32 scan_req_id;
-- 
2.53.0

