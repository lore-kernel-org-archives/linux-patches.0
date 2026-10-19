Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6482B5E0E2A;
	Mon, 19 Oct 2026 14:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418546; cv=none; b=K84wleMIFxNVSQWpxoJRcvRZhKh9Y6PLBbhCBJx/qKHRUE97PU8ywfW8hkOyUWbFrJfOLUYOhsaO3/GJbH/9k/sMBYoD9tp3r/N2zczwEEO3O2bhR/niwPL8o+TDNubscFnhXmg9diGCsWkpWjZ7v1eJRqUn5LjDG7Z1AlK/nWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418546; c=relaxed/simple;
	bh=rvJWQyr0WEfy6/AzCKYHXnWOaMUK+fe8bFgowxnOjPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KDBPJkPKXz9n3VsXHTXRzf1eGY7rBtgCHPdjQF9W5MYzQQxVVb0B7Je2h1IExlEVthPpuoSGfpnsAzm10VFfBqUQNovn5po/gW0hj/Bf1xoa4nU44Nlx6WJIfapOXGAFhh6VKURUIWeXGjSzJ2gwrLb4KpTJnbTIJ3qQeqlkgis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGX8RH+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGX8RH+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75511F000C4;
	Mon, 19 Oct 2026 14:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418542;
	bh=/+myPmVbI9znAEmr8DN9yfg2ABmzWBxhiHOVL+nrSUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGX8RH+FeTCN2UZjI/Z5ESIL7pESDs+/pui29FyQp77K6D57pF8EfZPLvMe7ewqt0
	 W5X5QFIiRoF2M5NiGQJdxvJQA6/FkauuMd9l/ttaY5QSS0I7Iii0i6XuI0kqvjE1DQ
	 JzQoL6HVDLaggBKHt80zh2NDSlyNeUZB+HBCluB/vQW1+3bjtxMe2gRinrNLbUeXuJ
	 5qeEozYqwalDztYZM6dbAay97INrcuZvNQGL9PJyL1FKXArThshpdoWzFi55r3XRd7
	 0NM00w1eTekQFlkvRMoiJxEOcku31H5gJlvYnfjKuxMYnQV9JTUyCTU5mLNWbpnLl1
	 bJf2mN1wyCC9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	jjohnson@kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: ath11k: validate regulatory capability phy_id
Date: Mon, 19 Oct 2026 09:50:13 -0400
Message-ID: <20261019135441.1420968-322-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit f8729a40ebcc94d164be8f154483a21669f3ab52 ]

ath11k_wmi_tlv_ext_hal_reg_caps() copies firmware regulatory
capability records into soc->hal_reg_cap[] using reg_cap.phy_id as
the destination index.  The loop count is bounded by num_phy, but the
phy_id embedded in each record is not checked against the fixed
MAX_RADIOS-sized destination array.

Reject firmware records whose phy_id does not fit soc->hal_reg_cap[]
before copying the parsed capability.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260704011040.26233-1-pengpeng@iscas.ac.cn
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The candidate
is a 6-line firmware `phy_id` bounds check in ath11k WMI parsing. The
buggy `memcpy` has been in this driver since v5.6; the check is
obviously correct and belongs here.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[wifi: ath11k] [validate] [reject firmware `phy_id` that is
out of range for `soc->hal_reg_cap[]`]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Rameshkumar Sundaram
  `<rameshkumar.sundaram@oss.qualcomm.com>`; Baochen Qiang
  `<baochen.qiang@oss.qualcomm.com>` (Qualcomm ath11k reviewers)
- **Acked-by:** none
- **Link:**
  `https://patch.msgid.link/20260704011040.26233-1-pengpeng@iscas.ac.cn`
- **Cc: stable:** none (expected; not a negative signal)
- **Signed-off-by:** Pengpeng Hou (author); Jeff Johnson (ath11k
  maintainer)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `ath11k_wmi_tlv_ext_hal_reg_caps()` copies firmware HAL
  regulatory-capability records into `soc->hal_reg_cap[]` using
  **`reg_cap.phy_id` as the destination index**. The loop is bounded by
  `num_phy`, but **`phy_id` inside each record is not checked** against
  `MAX_RADIOS`.
- **Symptom/failure mode:** out-of-bounds write into `struct
  ath11k_base` (memory corruption).
- **Version information:** none in the message.
- **Root cause:** firmware-controlled `u32 phy_id` used as an array
  index without a bounds check.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not disguised.** This is an explicit firmware-index validation
/ OOB-write fix. Verb “validate” is a bounds check, not cleanup.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/net/wireless/ath/ath11k/wmi.c` — **+6 / -0**
- **Function:** `ath11k_wmi_tlv_ext_hal_reg_caps()`
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record (verified in this tree at `wmi.c:4862-4880`):
- **Before:** `ath11k_pull_reg_cap_svc_rdy_ext()` fills `reg_cap` from
  firmware TLV `ext_reg_cap[i].phy_id`, then
  `memcpy(&soc->hal_reg_cap[reg_cap.phy_id], &reg_cap, sizeof(reg_cap))`
  with no check that `phy_id < MAX_RADIOS`.
- **After:** if `reg_cap.phy_id >= ARRAY_SIZE(soc->hal_reg_cap)`, log a
  warning and return `-EINVAL`; otherwise copy as before.
- **Path:** firmware `WMI_SERVICE_READY_EXT` event during ath11k bring-
  up (probe/init), not a hot datapath.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** **(d) memory safety — buffer overflow / out-of-bounds
  write**
- **Mechanism:** `phy_id` is a firmware `u32`
  (`wmi_hal_reg_capabilities_ext.phy_id`). Destination is
  `hal_reg_cap[MAX_RADIOS]` with **`MAX_RADIOS == 3`** (`core.h:242`,
  `core.h:971`). Loop bound `num_phy` is also firmware-supplied and is
  **not** the same as `phy_id`. A record with `phy_id >= 3` writes
  `sizeof(struct ath11k_hal_reg_capabilities_ext)` (10 × `u32` = 40
  bytes) past the array into following `ath11k_base` fields
  (`free_vdev_map`, `tbl_mtx_lock`, peer rhashtables).
- The parse helper only checks TLV count vs `num_phy`
  (`n_ext_hal_reg_caps >= param.num_phy` → `-ENOBUFS`); it does **not**
  validate `phy_id`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Obviously correct:** `ARRAY_SIZE(soc->hal_reg_cap)` is the real
  destination size; reject-and-return is the right failure mode.
- **Minimal:** 6 lines, one check, no API/struct changes.
- **Regression risk:** **very low**. Well-formed firmware with `phy_id`
  0–2 is unchanged. Invalid `phy_id` now fails WMI parse instead of
  corrupting memory. That is the intended probe failure, not a behavior
  change for working hardware.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Loop + `memcpy`: **`d5c65159f28953`** — “ath11k: driver for Qualcomm
  IEEE 802.11ax devices” (Kalle Valo, 2019-11-25).
- Bounds check: **`f8729a40ebcc9`** (this commit).
- Introducer is in **v5.6**, not v5.5 (`git merge-base --is-ancestor`).
  Bug has been in every tree with ath11k since then.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Not applicable. Introducer identified by
blame: `d5c65159f28953` (original driver).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Recent `wmi.c` work is other firmware TLV hardening (overread, stride,
  leak) — related thematically, **not prerequisites**.
- Earlier `84eee3c845d37` (“refine the phy_id check in
  ath11k_reg_chan_list_event”) is a **different** event path.
- **Standalone**, not patch N/M. Maintainer applied it as `[1/1]`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou has this one ath11k commit here. Weight comes from
**Qualcomm reviewers** and **maintainer Jeff Johnson** (MAINTAINERS:
ATH11K).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: **None.** Uses existing `ARRAY_SIZE`, `ath11k_warn`, `-EINVAL`,
`soc->hal_reg_cap`. Can apply standalone on any tree with this 2019
function.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **Lore URL (b4 dig):**
  `https://patch.msgid.link/20260704011040.26233-1-pengpeng@iscas.ac.cn`
- **Revisions:** **v1 only** (`b4 dig -a`); committed v1.
- **Thread (saved via `b4 dig -m`):**
  - Baochen Qiang: `Reviewed-by`
  - Rameshkumar Sundaram: `Reviewed-by`
  - Jeff Johnson: “Applied, thanks!” `[1/1]`
- **No NAKs, no stable nomination, no requested revisions.**

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc were Jeff Johnson, `linux-wireless`,
`ath11k@lists.infradead.org`, `linux-kernel`. Right lists and
maintainer.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: **No user/syzbot/bugzilla report.** Found by code review of
firmware TLV parsing. Severity is from the mechanism (OOB write), not
from a crash log.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone `[PATCH]`, not a series. ath12k still has an
analogous unguarded `soc->hal_reg_cap[reg_cap.phy_id] = reg_cap` in
`ath12k/wmi.c` — sibling issue, **not a dependency**.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** for lore.kernel.org/stable (HTTP 403). Local
history has no stable-specific discussion of this subject.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `ath11k_wmi_tlv_ext_hal_reg_caps()`; helpers
`ath11k_pull_reg_cap_svc_rdy_ext()`,
`ath11k_wmi_tlv_ext_hal_reg_caps_parse()`.

**Step 5.2: TRACE CALLERS**
Record (verified with grep/read):
- `ath11k_wmi_tlv_ext_hal_reg_caps()` ←
  `ath11k_wmi_tlv_svc_rdy_ext_parse()` (`WMI_TAG_ARRAY_STRUCT` after hw-
  mode and mac-phy TLVs)
- ← `ath11k_service_ready_ext_event()`
- ← WMI event switch `WMI_SERVICE_READY_EXT_EVENTID`

**Step 5.3: TRACE CALLEES**
Record: `ath11k_wmi_tlv_iter()`, `ath11k_pull_reg_cap_svc_rdy_ext()`
(copies firmware `phy_id`), `memcpy()`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable on **ath11k device init** when firmware sends service-
ready-ext. Not a syscall hot path. Trigger needs **CONFIG_ATH11K** +
Qualcomm 802.11ax hardware + firmware that puts `phy_id >= 3` (or
otherwise ≥ `ARRAY_SIZE`). Unprivileged users cannot poke this WMI path
directly; **buggy or malicious firmware** can. That is still a real
kernel OOB write.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same driver already bounds other firmware indices (e.g. `phy_idx
>= reg_caps->num_phy` in the pull helper). This copy site was the hole.
ath12k has the same hole unfixed.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `ath11k_wmi_tlv_ext_hal_reg_caps()` and
`hal_reg_cap[MAX_RADIOS]` are present. The unguarded `memcpy` was here
from v5.6 until `f8729a40ebcc9`. **Bug introduced in v5.6, long before
7.3.** `git merge-base --is-ancestor f8729a40ebcc9 HEAD` is true (fix is
in 7.3-rc1+); that is mainline merge, not “already selected for stable.”

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Surrounding function body is still the 2019
structure plus this 6-line check. No refactor of this function in
between.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No alternate fix for this memcpy. Other nearby TLV fixes address
different bugs.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **ath11k (Qualcomm 802.11ax)** under
`drivers/net/wireless/ath/ath11k/`. **IMPORTANT** — not core mm/fs, but
a widely used Wi-Fi driver (laptops, AP SoCs, Chromebooks, phones).
CONFIG: `ATH11K` / `ATH11K_PCI` / `ATH11K_AHB`.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Actively maintained (Jeff Johnson). Recent WMI work is firmware-
message validation, consistent with this patch.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: **Driver-specific / config-specific:** `CONFIG_ATH11K` users.
Impact only if firmware sends a `phy_id` that does not fit
`hal_reg_cap[]`.

**Step 8.2: TRIGGER CONDITIONS**
Record: Device init / firmware service-ready-ext. **Not** every packet.
Needs bad `phy_id` in the WMI record (firmware bug or hostile firmware).
Unprivileged userspace cannot fire it without controlling firmware.

**Step 8.3: FAILURE MODE SEVERITY**
Record: **Out-of-bounds write** of 40 bytes into `struct ath11k_base`
after `hal_reg_cap[]` — can corrupt `free_vdev_map`, mutexes, peer
tables → crash, deadlock, or further memory corruption. **Severity:
HIGH** (OOB write / memory corruption). Not a panic on every boot with
good firmware.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** High for ath11k — stops a real OOB write on a long-
  standing path (v5.6+).
- **Risk:** Very low — 6 lines, error-path reject, no lock/API change,
  good firmware unaffected.
- **Ratio:** strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real OOB write: firmware `u32 phy_id` used as index into a 3-element
  array.
- Small, obviously correct check (`ARRAY_SIZE` + `-EINVAL`).
- Present in this tree’s ath11k code; bug dates to original driver
  (v5.6).
- Reviewed by Qualcomm ath11k developers; applied by the maintainer.
- Standalone; no new APIs; no series dependencies.
- Matches stable pattern: buffer overflow / firmware TLV validation.

**AGAINST:**
- No `Reported-by` / syzbot / production crash.
- Trigger is firmware-supplied data at probe, not a generic syscall.
- No explicit `Cc: stable` (not a negative per pipeline rules).

**UNRESOLVED:**
- Could not query lore.kernel.org/stable (403).
- No public report that shipping firmware actually sent `phy_id >= 3`.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — local review + two Qualcomm
   Reviewed-by + maintainer apply.
2. Fixes a real bug that affects users? **PASS** — OOB write on firmware
   parse; ath11k users are real users.
3. Important issue? **PASS** — OOB write / memory corruption (**HIGH**),
   not style.
4. Small and contained? **PASS** — +6 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — same function/context; no
   missing prerequisites.

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not a device ID / quirk / DT / build / doc exception).
Qualifies as a normal bugfix.

**Step 9.4: DECISION**

This is a surgical firmware-index bounds check that stops a memcpy past
`hal_reg_cap[MAX_RADIOS]`. The destination array and unguarded copy
exist in this 7.3 tree’s ath11k code; the bug is older than this branch.
Risk is negligible; the failure mode is memory corruption. That meets
stable criteria for **this** tree.

---

### What the commit solves for this tree
`ath11k_wmi_tlv_ext_hal_reg_caps()` trusted firmware `phy_id` as an
index into a 3-slot array. A bad `phy_id` overwrites the rest of `struct
ath11k_base`. The patch rejects those records before the copy.

### Stable rules
Small, obviously correct, no new APIs, applies cleanly, fixes a real OOB
write.

### Risk vs benefit
Benefit is preventing kernel memory corruption on ath11k bring-up with
bad firmware. Risk is an early `-EINVAL` only when `phy_id` is already
invalid.

### Concerns
No in-the-wild crash report; trigger is firmware, not unprivileged
syscalls. That does not make an OOB write unsuitable for stable. No
backport rework needed here.

---

Verification:
- **[Phase 1]** Parsed tags: two Qualcomm Reviewed-by, maintainer
  SOB/Link; no Fixes/Reported-by/Cc:stable
- **[Phase 2]** Diff: +6 in `ath11k_wmi_tlv_ext_hal_reg_caps()`;
  `ARRAY_SIZE` check before `memcpy(&soc->hal_reg_cap[reg_cap.phy_id],
  ...)`
- **[Phase 2]** `MAX_RADIOS` is 3; `hal_reg_cap[MAX_RADIOS]` in
  `core.h:971`; `phy_id` is firmware `u32`
- **[Phase 3]** `git blame`: memcpy from `d5c65159f28953` (2019); check
  from `f8729a40ebcc9`
- **[Phase 3]** Introducer in v5.6, not v5.5; fix in v7.3-rc1, not v7.2
- **[Phase 3]** `git merge-base --is-ancestor f8729a40ebcc9 HEAD` → yes
  (mainline already has the fix; ignored as “already selected”)
- **[Phase 3]** No series/prereqs; author has only this ath11k commit
  here
- **[Phase 4]** `b4 dig -c f8729a40ebcc9`: v1 at
  patch.msgid.link/20260704011040.26233-1-pengpeng@iscas.ac.cn
- **[Phase 4]** `b4 dig -a`: v1 only; `b4 dig -w`: maintainer + linux-
  wireless + ath11k list
- **[Phase 4]** mbox: Reviewed-by Baochen Qiang + Rameshkumar Sundaram;
  Jeff Johnson applied `[1/1]`; no NAK
- **[Phase 4]** lore HTTP fetch 403; used `b4 dig -m` instead
- **[Phase 5]** Call chain: WMI `SERVICE_READY_EXT` →
  `ath11k_service_ready_ext_event` → TLV parse → this function
- **[Phase 5]** ath12k has the same unguarded pattern (sibling, not a
  prereq)
- **[Phase 6]** `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` = 7.3.0-rc4; buggy function present
- **[Phase 6]** Surrounding code still matches 2019 introducer → clean
  apply
- **[Phase 7]** MAINTAINERS: Jeff Johnson, Supported
- **[Phase 8]** Failure mode: 40-byte OOB write into `ath11k_base` after
  `hal_reg_cap[]` → HIGH
- **UNVERIFIED:** stable@ lore search (HTTP 403); whether any shipping
  firmware actually sent `phy_id >= 3`

**YES**

 drivers/net/wireless/ath/ath11k/wmi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 3305ec66ddbf2..c6b9e84b169c9 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4816,6 +4816,12 @@ static int ath11k_wmi_tlv_ext_hal_reg_caps(struct ath11k_base *soc,
 			return ret;
 		}
 
+		if (reg_cap.phy_id >= ARRAY_SIZE(soc->hal_reg_cap)) {
+			ath11k_warn(soc, "invalid reg cap phy_id %u\n",
+				    reg_cap.phy_id);
+			return -EINVAL;
+		}
+
 		memcpy(&soc->hal_reg_cap[reg_cap.phy_id],
 		       &reg_cap, sizeof(reg_cap));
 	}
-- 
2.53.0

