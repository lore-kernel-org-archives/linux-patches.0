Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B2F596E98;
	Mon, 19 Oct 2026 13:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418354; cv=none; b=Lnc0eBEIJgYQnNpcr5vovPOe1Qwy39lBEKcevmPqng2flxqjmqNCg533BDNIuHHgyoYkKc/F1HEFwf1ob2+o5W/fzzOB41tb17RXw6p4BNE6gC1GKvmnBb2z9ljAtDMW01n1DF3CvGKxSWIp4uNC3bHLx2Ga6Qi1IoewhPoOJnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418354; c=relaxed/simple;
	bh=o605FMvXndwHEREVMBPg3HwAA0lcourAG5txsOaZZJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSdNaDcVadTSPIghQJFQEL0gl+nHIS1XawMzsi+zUHVRP7Lu7XQsKfHhq2OyPBFRACl8dez8Kf0NVoeAkhiYXz9MAHfOmrEHhEhbEj3BL/CPAPfVtfIOvxvKdYbLoZfJSoBU0+5nNWbwLcp24OiBdefhf6BndUZdOwzWUbRD8h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCRsKisO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCRsKisO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C922E1F000C7;
	Mon, 19 Oct 2026 13:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418351;
	bh=sUW48Z87ALzhTOhiTFMjpUbWtbdV6iudAstjZ6av5P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCRsKisOhVYu+D8OyBmJsqGLmuvFjraHn7mUmxpoYgWpQ+z4cLXmJjMMHLZmzghnw
	 BPeOPuCTLyualK1AZ28zxY+3tad1URzJ4IXOmd+Gfbz7gew3Iu+BndMm1edWDIFeEX
	 fdgeT0+J06hFHIAPE8mVIAFbDQtktfKUUGXBZQhqAash7Ygyvma93BusImca7FtQGF
	 yvjiUUZqCG9QJzWnOnuC0/6co3kxpvEcxLBu8LIjMzhPy4AANgSHQf9IZ+uWpC4vqF
	 EMnFAFl9Lo3B3kLSdhbyTlp0Ar6vKrQeQ3IoQFpsC55Ymq50VFhlILsWuAfCyxQqcG
	 hatyTEGyjgpGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	basavaraj.natikar@amd.com,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] HID: amd_sfh: Serialize access to the shared emp2 pointer
Date: Mon, 19 Oct 2026 09:47:57 -0400
Message-ID: <20261019135441.1420968-186-sashal@kernel.org>
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

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit c57016bcf6d0b57cda5579e5d6856bd9bbe52a77 ]

The SFH accessors reach the device through a file-global emp2 pointer
that is published at probe and cleared on remove. amd_get_sfh_info() is
exported and called from other modules on unrelated threads, so a reader
can observe a non-NULL emp2 and then race a concurrent unbind that clears
it and frees the device.

Serialize the emp2 publish/clear and all readers under a mutex, so a
reader either sees a live device for the whole access or sees NULL.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111**. The buggy global `emp2` pointer and
exported `amd_get_sfh_info()` are in this checkout; the 6-line mutex fix
applies here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[HID: amd_sfh]** **[Serialize]** Serialize access to the
shared `emp2` pointer used by exported SFH accessors.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Basavaraj Natikar (author; AMD SFH maintainer)
- Signed-off-by: Jiri Kosina (HID maintainer; applied the patch)
- No Fixes, Reported-by, Tested-by, Reviewed-by, Acked-by, Link, or Cc:
  stable on the committed message (absence of Fixes/Cc:stable is
  expected for this review)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** File-global `emp2` is published at probe
  (`sfh_interface_init`) and cleared on remove (`sfh_deinit_emp2`).
  `amd_get_sfh_info()` is `EXPORT_SYMBOL_GPL` and is called from other
  modules on other threads.
- **Symptom/failure mode:** A reader can see a non-NULL `emp2`, then a
  concurrent unbind NULLs it and frees the device → use-after-free /
  MMIO against freed `amd_mp2_dev`.
- **Version info:** None in the message. Introduced with HPD export in
  v6.8 (`b5b0774d53bb81`). Present in this 6.12 tree.
- **Root cause (author):** Missing serialization between publish/clear
  and all readers.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. It is an explicit race/UAF fix. Cover letter for
the v3 series also calls patches 1–2 “preparation” for SW_TABLET_MODE,
but the mutex independently closes an existing unbind-vs-reader UAF. It
is not a pure refactor with no standalone value.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c` (+6 / −0)
- Functions: file-scope `emp2_lock`; `sfh_deinit_emp2`;
  `sfh_interface_init`; `amd_get_sfh_info`
- Scope: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: `emp2 = mp2` / `emp2 = NULL` with no lock.
  `amd_get_sfh_info()` checks `emp2` then dereferences `emp2->mmio` /
  `emp2->vsbase` unlocked.
- After: `DEFINE_MUTEX(emp2_lock)`; `guard(mutex)(&emp2_lock)` around
  publish, clear, and the whole reader. A reader either keeps a live
  device for the full access or sees NULL.
- Paths: probe/init, remove/error-deinit, and the exported reader
  (normal path from AMD PMF work).

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **Race / UAF (check-then-use on a global device pointer).**
Writers and the exported reader were unsynchronized. Mutex makes
publish/clear and MMIO mutually exclusive. Helpers `amd_sfh_hpd_info` /
`amd_sfh_als_info` stay unlocked internally but are static and only
called from `amd_get_sfh_info()` while that lock is held.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct for this TOCTOU.
- Minimal; no API or structure change.
- Regression risk low: mutex is not nested; readers run in PMF delayed
  work (sleepable); remove already sleeps (`flush_work`). Holding the
  lock across `readl`/`memcpy_fromio` can delay unbind slightly; that is
  the intended tradeoff vs UAF.
- `linux/cleanup.h` + `guard(mutex)` exist in 6.12; `mutex.h` is already
  pulled in via `amd_sfh_common.h`.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: `emp2`, `sfh_deinit_emp2`, `amd_get_sfh_info`, and
`EXPORT_SYMBOL_GPL` come from **b5b0774d53bb81** (“HID: amd_sfh: Add a
new interface for exporting HPD data”, 2023-12-20). ALS reader added in
**584f35a3647d42**. Both are in v6.8 and in this tree. The race is old
relative to 6.12, not new mainline-only code.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes tag. Buggy pattern is the unlocked global from
b5b0774d53bb81, which **is** an ancestor of HEAD.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent 6.12 history on this file is register-access helpers
(`7902ec988a9a6`, `6296562f30b1c`), not locking. Origin/master later
added MT_SRA / tablet-mode around this commit; those features are
**not** in this tree. No existing emp2 lock here.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Basavaraj Natikar is listed in MAINTAINERS for AMD SENSOR FUSION
HUB. Same author added the export and later SFH1.1 work. Series v3 was
applied by Jiri Kosina.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Committed as **[PATCH v3 2/5]** in “Add SW_TABLET_MODE support”.
- 1/5 “Track MP2 version explicitly” (`1a73a4e7673f57`) is **not** in
  HEAD and is **not** required for this mutex (different files/fields).
- 3–5 add operating-mode accessor, aux device, and a new input driver —
  features, not needed for this fix.
- This patch is self-contained. `git apply --check` of c57016bcf6d0b on
  this tree **succeeds** (hunk 3 offset −35: no
  `amd_sfh_mode_info`/`MT_SRA` in 6.12).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- Lore/msgid: https://patch.msgid.link/20260803175230.3839752-3-
  Basavaraj.Natikar@amd.com
- Series: v1 (operating-mode only) → v2 0/5 → **v3 2/5** (applied).
- Cover letter (v3 0/5): patches 1–2 are preparation; v2 notes from
  Sashiko review: serialize emp2 so concurrent unbind cannot free the
  device while a reader dereferences it.
- Jiri Kosina queued the series in hid.git#for-7.3/amd-sfh. No NAK. No
  Cc: stable in review.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To/Cc: jikos@kernel.org, bentiss@kernel.org,
dmitry.torokhov@gmail.com, linux-input@. HID maintainers were on the
series. Dmitry Acked-by is on 5/5 (input driver), not this patch.
Applied by Jiri Kosina.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Race found in review of the tablet-mode
series, not a user crash report. The existing PMF caller was already
racy.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: 2/5 is the UAF serialization. 3/5 also adds `sfh_set_emp2()` and
uses `emp2_lock`; that is extra feature plumbing, not required to lock
the 6.12 HPD/ALS paths.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned HTTP 403. UNVERIFIED
whether stable@ discussed this. No evidence in the input thread of a
stable nomination or a rejection.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `sfh_deinit_emp2`, `sfh_interface_init`, `amd_get_sfh_info`; new
`emp2_lock`.

Step 5.2: TRACE CALLERS
Record:
- `sfh_interface_init`: `amd_sfh_set_ops()` ← `amd_sfh1_1_init()`
  (SFH1.1 probe work).
- `sfh_deinit_emp2`: `amd_mp2_pci_remove` (unbind) and error paths in
  `amd_sfh1_1_init` after publish.
- `amd_get_sfh_info`: `amd_pmf_get_sensor_info()` in
  `drivers/platform/x86/amd/pmf/spc.c` (MT_ALS, MT_HPD) ←
  `amd_pmf_populate_ta_inputs` ← `amd_pmf_invoke_cmd_enact` ← delayed
  work `amd_pmf_invoke_cmd` every `pb_actions_ms` (default **1000 ms**).

Step 5.3: TRACE CALLEES
Record: Readers do `readl` / `memcpy_fromio` on `emp2->mmio` /
`emp2->vsbase`. Remove then `amd_sfh_hid_client_deinit`, `stop_all`, PCI
intx/intr clear. `mp2` is `devm_kzalloc`; mapping is `pcim_iomap` —
freed after PCI remove.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable without the new tablet driver: AMD PMF policy work
(typical on AMD laptops with PMF) vs SFH1.1 unbind (`amd_sfh_remove` →
`mp2_ops->remove`). Not a syscall hot path; unbind is admin/module/PCI.
Still a real concurrent path: 1 Hz reader vs remove.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Only this file holds `emp2`. No sibling unlocked copy in 6.12.
Later mainline adds more readers (MT_OP_MODE at 200 ms); those are not
in this tree.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. `drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c`:
unlocked `static struct amd_mp2_dev *emp2`, `sfh_deinit_emp2` sets NULL,
`amd_get_sfh_info` is exported. Introduced v6.8; this tree is 6.12.111.
`git merge-base --is-ancestor c57016bcf6d0b HEAD` → **not present**.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply** (`git apply --check` succeeded; one hunk
offset). 6.12 lacks `amd_sfh_mode_info`/`MT_SRA`; that is context only.
`guard(mutex)` and `DEFINE_MUTEX` are available.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `edeae8be4d263` syncs SFH work functions — different bug. No
emp2 mutex. d1c444b47100d / 01601fdd40ecf not in HEAD (and not
required).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: HID / AMD SFH (`drivers/hid/amd-sfh-hid/`), plus AMD PMF
consumer. **IMPORTANT** for AMD Ryzen laptops with SFH1.1 (HPD/ALS) and
PMF; not core mm/VFS. Config: `CONFIG_AMD_SFH_HID`.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature driver (since ~5.11), still receiving fixes. Export of
`emp2` is from 6.8; the unlocked design lasted until the 7.3 tablet-mode
series.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific: AMD SFH1.1 (PCI ID MP2 1.1) **and** AMD PMF
loaded. Typical modern AMD notebooks, not all machines.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Concurrent `amd_get_sfh_info` (PMF delayed work, default 1 s)
with `sfh_deinit_emp2` (unbind, rmmod, or probe error after publish).
Unprivileged users cannot normally unbind. Window is small but standard
check-then-use. New 200 ms tablet poll is **not** in this tree, so
trigger rate here is lower than mainline after 7.3.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Use-after-free of `amd_mp2_dev` / MMIO after `devm` teardown →
oops/panic, possibly memory corruption. **HIGH**. Not a guaranteed panic
on every boot.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: closes a real UAF on a supported unbind path for SFH1.1+PMF
  systems.
- Risk: 6 lines, existing mutex helpers, no ABI change; apply is clean.
- Ratio: favorable. Preparation-for-feature context does not make the
  existing race fictional.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real UAF race on a global pointer vs exported cross-module reader
  (verified call path: PMF work → `amd_get_sfh_info` vs
  `amd_mp2_pci_remove`).
- Buggy code in this 6.12 tree since v6.8.
- 6-line, obviously correct mutex; maintainer-authored; HID maintainer
  applied.
- Applies cleanly here.
- `guard(mutex)` already used elsewhere in 6.12.

AGAINST:
- Sent as 2/5 “preparation” for SW_TABLET_MODE, not as a standalone
  stable fix.
- No user/syzbot report; narrow unbind window; no Cc: stable (not a
  negative per rules).
- Later series patches must **not** come along (new feature).

UNRESOLVED:
- Stable list discussion (lore/stable 403).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — mutex around the only
   publisher/clearer and the only exported reader; merged to hid.git
   after review.
2. Fixes a real bug that affects users? **PASS** — UAF if SFH1.1 unbinds
   while PMF polls.
3. Important issue? **PASS** — UAF / crash / possible memory corruption
   (HIGH).
4. Small and contained? **PASS** — +6 lines, one file.
5. No new features or APIs? **PASS** — locking only. (3–5 of the series
   would FAIL this; they are out of scope.)
6. Can apply to the local tree? **PASS** — `git apply --check`
   succeeded.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID / quirk / DT / build / doc exception).
Qualifies as a normal race/UAF bugfix.

Step 9.4: MAKE YOUR DECISION
This tree has the unlocked `emp2` export and the PMF reader. The patch
does not need MP2 version tracking or tablet-mode. It should be
backported here.

------------------------------------------------
What problem it solves for stable users
------------------------------------------------
On 6.12, AMD PMF’s delayed work calls `amd_get_sfh_info()` about once a
second. That function tests the file-global `emp2` and then uses
`emp2->mmio` / `emp2->vsbase`. Remove (`amd_sfh_remove` →
`amd_mp2_pci_remove`) sets `emp2 = NULL` and then tears down a
`devm_kzalloc`’d `amd_mp2_dev`. Without a lock, a reader can keep using
a pointer to already-freed device/MMIO. The mutex makes that impossible.

Why it meets stable rules
Small, correct, no new API, applies here, fixes a real UAF. Being patch
2/5 of a feature series is not a dependency: 1/5 and 3–5 are unrelated
or features.

Risk vs benefit
Low risk, meaningful benefit on AMD SFH1.1 + PMF systems. Do not pull
the rest of the tablet-mode series.

Concerns
Backport only this commit. Context offset on `amd_get_sfh_info` (no
MT_SRA) is already handled by a clean apply.

Verification:
- [Phase 1] Parsed tags: only two SOBs (Natikar, Kosina); no
  Fixes/Reported-by/Cc:stable
- [Phase 1] Cover letter (mbox): “Patches 1 and 2 are preparation”; v2
  changelog describes the unbind UAF
- [Phase 2] Diff: +6 lines, mutex + three `guard(mutex)` sites in one
  file
- [Phase 3] git describe HEAD / Makefile: **p-6.12-3-gc504cf0baa3d8**,
  version **6.12.111**
- [Phase 3] git blame: emp2/export from b5b0774d53bb81; `git merge-base
  --is-ancestor b5b0774d53bb81 HEAD` → yes; in v6.8
- [Phase 3] git merge-base --is-ancestor c57016bcf6d0b HEAD → **no**
  (candidate not in this tree)
- [Phase 3] Parent 1a73a4e7673f57 “Track MP2 version” not in HEAD; not
  required by this diff
- [Phase 4] b4 dig -c c57016bcf6d0b: https://patch.msgid.link/2026080317
  5230.3839752-3-Basavaraj.Natikar@amd.com
- [Phase 4] b4 dig -a: v1 → v2 0/5 → v3 2/5 applied
- [Phase 4] b4 dig -w: linux-input, jikos, bentiss, dmitry.torokhov
- [Phase 4] mbox: Jiri queued for-7.3/amd-sfh; no NAK; no stable
  nomination
- [Phase 4] lore.kernel.org WebFetch: 403; stable@ search UNVERIFIED
- [Phase 5] Callers: amd_pmf_get_sensor_info → delayed work default 1000
  ms; deinit from amd_mp2_pci_remove and probe error paths
- [Phase 6] Current file still has unlocked emp2; apply --check of
  c57016bcf6d0b succeeded (hunk 3 offset −35)
- [Phase 6] include/linux/cleanup.h and DEFINE_GUARD(mutex) in
  include/linux/mutex.h present; mutex.h included via amd_sfh_common.h
- [Phase 8] Failure mode: UAF of amd_mp2_dev/MMIO on unbind vs PMF
  reader; severity HIGH
- UNVERIFIED: whether anyone asked for this on stable@ (HTTP 403)

**YES**

 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c
index 837d59e7a6610..dd2720bae65c3 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c
@@ -8,12 +8,14 @@
  * Author: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
  */
 #include <linux/amd-pmf-io.h>
+#include <linux/cleanup.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/iopoll.h>
 
 #include "amd_sfh_interface.h"
 
 static struct amd_mp2_dev *emp2;
+static DEFINE_MUTEX(emp2_lock);
 
 static int amd_sfh_wait_response(struct amd_mp2_dev *mp2, u8 sid, u32 cmd_id)
 {
@@ -78,12 +80,14 @@ static struct amd_mp2_ops amd_sfh_ops = {
 
 void sfh_deinit_emp2(void)
 {
+	guard(mutex)(&emp2_lock);
 	emp2 = NULL;
 }
 
 void sfh_interface_init(struct amd_mp2_dev *mp2)
 {
 	mp2->mp2_ops = &amd_sfh_ops;
+	guard(mutex)(&emp2_lock);
 	emp2 = mp2;
 }
 
@@ -160,6 +164,8 @@ static int amd_sfh_als_info(u32 *ambient_light)
 
 int amd_get_sfh_info(struct amd_sfh_info *sfh_info, enum sfh_message_type op)
 {
+	guard(mutex)(&emp2_lock);
+
 	if (sfh_info) {
 		switch (op) {
 		case MT_HPD:
-- 
2.53.0

