Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC125AD60D;
	Mon, 19 Oct 2026 14:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418413; cv=none; b=C5/T5di7NzFnLtImdYbP+XbqDbj9UuTkyWabT9dDIwBSkRJSUGDI38PJQBNbp7aHjQ51anDhKkDYa3E1cnIZT3dJkCqGhGbjBH+t2V7yHVMHizN/WV6RfQbsYvIPDgA5IgcEuNIhptxYSfQiYPMJVFzNCjzW7yWlhubrObVW0J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418413; c=relaxed/simple;
	bh=BAxXmKzipUKgwnwjt46mX8OWaHPtpfcRGxvBMikOUgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UcSKqsuv0eqJLdDCf+WzS/xpf28UNh5DKmD+1+jCivHoig+8VPpQcZBFfruY8RXa/wprjVqF8Oenhrq/nxbkD8Y++qH61lmkfzwSMa9/ow0FMqyje62rh5w5zlStGbsEx6XC6x1aFlzDjdT09J01TcHyd2ySLsDc/qWAcKo4gGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XodgFDMJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XodgFDMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACB41F000C4;
	Mon, 19 Oct 2026 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418411;
	bh=62WN2Y9i3wsFgQq2p6V9Mjpp4uZxM4JD2fNUMBgQi6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XodgFDMJP27pnY/QoaxbohoV75QlAljUVCPIRsCNLxQkG5wjvqjcvYKZZhztWBIZT
	 VnjTRdgNOijREW2v+7zXzeDiK33y3v7w3Lz+AVTdsdXvzyJF7sl+hrVo2pyjncdDZc
	 p8ibT8Vv/CjXGdeYbNIHmR07uWfAW6a+8JI+toM3nKj+abyK3A6666tzoZni8PJ7gY
	 /caSmLquwejwphDLIAbA5L6hfLuzBku4BHO/resrJNGlPTtw4M01xgtMsd8TAXab8A
	 KYw16XV5FDr+w/AIYny9Tpr/gW7E/Nu3t3csJ4u76nPJsedko9rB3UzsKRvVCWHZJN
	 ecTzHpiyfzgGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	s.shravan@intel.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] platform/x86: int1092: Fix info leak in parse_package()
Date: Mon, 19 Oct 2026 09:48:41 -0400
Message-ID: <20261019135441.1420968-230-sashal@kernel.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit f5eb833730c071b68a68de5d1df442aae4ae7e6e ]

Sashiko reports a possible information leak that can occur as follows:

1. In parse_package(), memory allocated for data->device_mode_info is not
   zerozed initially as it is allocated with devm_kmalloc_array().

2. In the for loop after the allocation, a malformed ACPI package
   provided by firmware can cause some fields in data->device_mode_info
   to remain uninitialized.

3. Later in update_sar_data(), the uninitialized fields gets copied to
   the fields of context->sar_data, which can be exposed to userspace
   through sysfs attribute read (intc_data_show()).

Fix the leak by switching to use devm_kcalloc() for allocation.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260710052806.100107-1-nihaal%40cse.iitm.ac.in
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260723-platx86-v4-2-93b4a178b595@cse.iitm.ac.in
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to judge the leak path, the `devm_kcalloc` fix, and
whether this 7.3-rc4 tree should take it. Writing up the nine-phase
analysis next.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[platform/x86: int1092]` `[Fix]` `[info leak in parse_package()
— uninitialized kmalloc data can reach sysfs]`

**Step 1.2: Tags**
Record:
- `Reported-by: Sashiko <sashiko-bot@kernel.org>` — automated kernel
  review bot, not syzbot
- `Closes: https://sashiko.dev/#/patchset/20260710052806.100107-1-
  nihaal%40cse.iitm.ac.in`
- `Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>` (author)
- `Link: https://patch.msgid.link/20260723-platx86-v4-2-
  93b4a178b595@cse.iitm.ac.in`
- `Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>`
  (platform/x86 maintainer)
- `Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>`
  (applied by maintainer)
- No `Fixes:` tag in the committed message (expected for this review
  pipeline)
- No `Cc: stable` in the committed message; original mail **was** CCed
  to `stable@vger.kernel.org` (verified via `b4 dig -w` and the v4 cover
  letter on the stable list)
- No `Tested-by:` (cover letter: compile-tested only)

**Step 1.3: Body**
Record:
- **Bug:** `device_mode_info` is allocated with `devm_kmalloc_array()`
  (non-zeroed). The parse loop `continue`s on malformed ACPI package
  elements, leaving those array slots uninitialized.
- **Symptom:** Uninitialized fields can be copied in `update_sar_data()`
  into `context->sar_data` and read from userspace via `intc_data` sysfs
  (`intc_data_show()`).
- **Root cause:** Allocation is not zeroed, despite `parse_package()`
  documenting that skipped entries “will have the default value of
  zero.”
- **Fix:** `devm_kmalloc_array()` → `devm_kcalloc()`.
- **Version info in message:** none. Driver has existed since v5.15.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. Explicit information-leak fix. The surrounding
comment already promised zeroed skipped slots; the allocator did not
provide that.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/platform/x86/intel/int1092/intel_sar.c` (+4/−4)
- Function: `parse_package()`
- Scope: single-file, one-call-site surgical change

**Step 2.2: Code flow**
Record:
- **Before:** `devm_kmalloc_array()` returns uninitialized heap. Loop
  writes only successfully parsed modes; failed/malformed entries leave
  `device_mode_info[itr]` untouched.
- **After:** `devm_kcalloc()` zeros the whole array first, so skipped
  slots stay `{0}` as the function comment describes.
- **Path:** probe/init (`sar_get_data()` → `parse_package()`), then
  later sysfs read / ACPI notify (`update_sar_data()`).

**Step 2.3: Bug mechanism**
Record: **Uninitialized data / kernel info leak.**
Mechanism verified in this tree:
1. `parse_package()` allocates `device_mode_info`.
2. Loop uses `continue` on type/count/`get_int_value()` failures (lines
   105–114).
3. `update_sar_data()` compares `context->sar_data.device_mode` to
   `device_mode_info[itr].device_mode` and copies `bandtable_index`,
   `antennatable_index`, `sartable_index`.
4. `intc_data_show()` emits those four ints to userspace.

If a skipped slot’s uninitialized `device_mode` happens to match the
current mode, heap leftovers are copied into `sar_data` and printed.

**Step 2.4: Fix quality**
Record: Obviously correct. `devm_kcalloc()` is the zeroing counterpart
of `devm_kmalloc_array()`. No API change, no lock change, no extra error
path. Regression risk is negligible (slightly more work at probe to zero
a small array, max 50 modes).

## Phase 3: Git history

**Step 3.1: Blame**
Record:
- Buggy skip-and-leave-uninitialized loop: `dcfbd31ef4bcf`
  (“platform/x86: BIOS SAR driver for Intel M.2 Modem”), 2021-08-20,
  first in **v5.15-rc1**.
- Original allocator was `kmalloc_array()` (also non-zeroing). Same leak
  class from day one.
- Matching-by-`device_mode` copy: `7df227847ab56` (2021-10-11).

**Step 3.2: Fixes: tag**
Record: No `Fixes:` on this commit. The matching parent
(`30c906cff490c`) has `Fixes: dcfbd31ef4bc`. That introducer **is** an
ancestor of this tree (`git merge-base --is-ancestor dcfbd31ef4bcf HEAD`
succeeded).

**Step 3.3: File history**
Record: Recent related commits on this file:
- `30c906cff490c` — convert to `devm_*` allocations (patch 1/2, parent
  of this commit)
- `f5eb833730c07` — this info-leak fix (patch 2/2)
This is **patch 2/2** of a two-patch series. It is standalone *on top of
patch 1*.

**Step 3.4: Author**
Record: Abdun Nihaal submitted both int1092 fixes in this series. Ilpo
Järvinen (platform/x86 maintainer) reviewed and applied both. Not the
original driver author (Shravan Sudhakar / Intel).

**Step 3.5: Prerequisites**
Record: **Depends on `30c906cff490c`**, which changed
`kmalloc_objs`/`kmalloc_array` into `devm_kmalloc_array()`. This hunk
only applies as written if that conversion is present. In **this** tree,
that parent **is** present (`git merge-base --is-ancestor 30c906cff490c
HEAD` succeeded). No other missing helpers: `devm_kcalloc()` is core
device-managed alloc.

## Phase 4: Mailing list / external research

**Step 4.1: Original discussion**
Record:
- `b4 dig -c f5eb833730c07` → https://patch.msgid.link/20260723-platx86-
  v4-2-93b4a178b595@cse.iitm.ac.in
- Series: v1 (combined) → v2 → v3 (split 2/2) → **v4** (applied). v4
  only updated the commit message per Ilpo to document the leak path.
- Cover letter: “[PATCH v4 0/2] platform/x86: int1092: Fix two bugs in
  SAR driver”
- Explicitly CCed `stable@vger.kernel.org`; also appeared on the stable
  list (spinics `lists/stable/msg986235.html` / `msg971516.html`).
- No NAK found in available archives.
- Cover letter: “Both patches are compile tested only.”

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Abdun Nihaal; Shravan Sudhakar; Hans de Goede; Ilpo Järvinen;
`platform-driver-x86@vger.kernel.org`; `linux-kernel@vger.kernel.org`;
**`stable@vger.kernel.org`**; Sashiko. Maintainer Ilpo reviewed and
applied.

**Step 4.3: Bug report**
Record: Sashiko static/agent review, not a user crash report. Closes URL
did not return the specific finding body (only the Sashiko project
page). Leak path is independently verifiable from the source.
**UNVERIFIED:** exact Sashiko finding text.

**Step 4.4: Series**
Record: 2/2. Patch 1 (`30c906cff490c`) is the `devm_` conversion (has
`Cc: stable` and `Fixes:`). Patch 2 is this kcalloc leak fix. Both are
in this tree, in order.

**Step 4.5: Stable list**
Record: Series was mailed to stable@ (cover + both patches). No evidence
of a NAK or “not for stable” reason. Patch 1 later received
CVE-2026-89437 (memory leak). That CVE is **patch 1**, not this info-
leak commit; not used as the reason for this decision.

## Phase 5: Code semantic analysis

**Step 5.1: Functions**
Record: `parse_package()` modified. Related: `update_sar_data()`,
`intc_data_show()`, `sar_get_data()`, `sar_probe()`,
`sar_get_device_mode()`, `intc_reg_store()`.

**Step 5.2: Callers**
Record:
- `parse_package()` ← `sar_get_data()` ← `sar_probe()` (boot/probe,
  `MAX_REGULATORY` = 3 times)
- `update_sar_data()` ← `sar_get_device_mode()` (probe + ACPI notify
  `0x80`) and `intc_reg_store()` (sysfs write)
- `intc_data_show()` ← sysfs read of `intc_data`

**Step 5.3: Callees**
Record: `get_int_value()`, `devm_kcalloc()`. No locks, no I/O besides
ACPI objects already passed in.

**Step 5.4: Reachability**
Record: Yes, from userspace on systems with ACPI ID `INTC1092`:
- `DEVICE_ATTR_RO(intc_data)` is mode **0444** (`__DEVICE_ATTR_RO` →
  0444 in `include/linux/device.h`).
- Documented in `Documentation/ABI/testing/sysfs-driver-intc_sar` as
  `/sys/bus/platform/devices/INTC1092:00/intc_data`.
Unprivileged processes can read it. Triggering the *uninitialized* slots
still needs malformed ACPI firmware; once those slots exist, a matching
`device_mode` exposes leftover heap words.

**Step 5.5: Similar patterns**
Record: Same file’s loop comment already required zeros. No sibling copy
of this bug in the int1092 directory. The immediately preceding series
patch did not zero the array (`devm_kmalloc_array`), so this follow-up
is required to actually close the leak.

## Phase 6: Local tree (this checkout only)

**Step 6.1: Does the buggy code exist here?**
Record:
- Tree: **`v7.3-rc4-27-gf0100363d8c37`**, `make kernelversion` =
  **7.3.0-rc4**, `VERSION=7 PATCHLEVEL=3 SUBLEVEL=0 EXTRAVERSION=-rc4`.
- Driver **is** present. `parse_package()` / `update_sar_data()` /
  `intc_data_show()` all exist.
- Introducer `dcfbd31ef4bcf` is an ancestor (v5.15-era).
- Current file already uses `devm_kcalloc()` because `f5eb833730c07` is
  an ancestor of HEAD. That is **not** treated as “already selected”; it
  only confirms the code and the fix belong to this lineage.
- Parent `30c906cff490c` is also an ancestor, so the hunk’s
  `devm_kmalloc_array` context exists in this history.

**Step 6.2: Backport difficulty**
Record: **Clean apply** onto the parent already in this tree (4-line
allocator swap in one function). No conflicting refactor of this
function after the parent besides this commit itself.

**Step 6.3: Related fixes already here**
Record: Patch 1 (devm conversion) is here. That conversion **does not**
zero the array, so it does not substitute for this fix. No other info-
leak fix on this path.

## Phase 7: Subsystem context

**Step 7.1**
Record: `drivers/platform/x86/intel/int1092/` — Intel BIOS Dynamic SAR
for M.2 modem. Criticality: **PERIPHERAL / platform-specific**, but the
sysfs node is world-readable, so the leak is a real userspace-visible
security issue on those machines.

**Step 7.2**
Record: Low-churn mature driver (added 2021, occasional fixes).
Maintainer: Shravan Sudhakar; applied by Ilpo Järvinen (pdx86). Config:
`CONFIG_INTEL_SAR_INT1092`, depends on ACPI.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Users of Intel platforms with ACPI device `INTC1092` and this
driver loaded (WWAN SAR). Not universal; **driver/platform-specific**.

**Step 8.2: Trigger**
Record: Probe parses BIOS ACPI DSM packages. Malformed/partial packages
skip slots. Later, ACPI notify or `intc_reg` store calls
`update_sar_data()`; any user can read `intc_data`. Firmware-dependent,
but the skip path is intentional (not a theoretical dead branch).
Unprivileged read of the attribute: **yes**.

**Step 8.3: Failure mode**
Record: Kernel heap contents (a few integers) can be copied into a
world-readable sysfs attribute. Severity: **HIGH** (info leak /
security), not a panic. Matches the classic uninitialized-kmalloc-to-
userspace pattern.

**Step 8.4: Risk–benefit**
Record:
- **Benefit:** High for affected hardware — closes a kernel-memory
  disclosure through a documented 0444 sysfs ABI; implements the
  behavior the function comment already promised.
- **Risk:** Very low — one allocator flag, no locking, no ABI change, no
  new features.
- **Ratio:** Strongly favors taking the fix.

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Real uninitialized-heap info leak to userspace via sysfs
- World-readable `intc_data` (0444)
- Function comment already required zeros;
  `kmalloc`/`devm_kmalloc_array` never provided them
- Bug present since the driver was added (v5.15); code exists in this
  7.3 tree
- 4-line, obviously correct `devm_kcalloc()` switch
- Reviewed and applied by the platform/x86 maintainer
- Author CCed stable@; v4 series posted to the stable list
- Prerequisite patch 1 is already in this tree

AGAINST:
- Niche Intel WWAN SAR driver, not a core path
- Needs malformed ACPI to leave holes (though that path is explicit)
- Compile-tested only, no `Tested-by`
- Committed message omitted `Fixes:` / `Cc: stable` (not a negative per
  pipeline rules)

UNRESOLVED:
- Full Sashiko finding text (page did not return the patchset body)
- Full verbatim Ilpo review mail (known: he asked to document the leak
  path; then Reviewed-by + applied)
- lore.kernel.org WebFetch returned 403; discussion reconstructed via
  `b4 dig`, openwall, LKML archive, and spinics

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** (obvious kcalloc swap;
   maintainer review; compile-tested)
2. Real bug affecting users? **PASS** (heap data can reach sysfs)
3. Important (crash/security/corruption/deadlock)? **PASS** —
   security/info leak
4. Small and contained? **PASS** — 8 lines in one function
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — file, function, and
   `devm_kmalloc_array` parent all exist here

**Step 9.3: Exception category**
Record: Not a device-ID/quirk/DT/build/docs exception. It is a normal
**security/uninitialized-data** bugfix.

**Step 9.4: Decision**
This tree is 7.3-rc4. The INT1092 SAR driver and the non-zeroed
allocation-plus-`continue` parse loop are part of this lineage.
Switching to `devm_kcalloc()` is the minimal, correct way to stop
leftover slab contents from being matched in `update_sar_data()` and
printed by `intc_data_show()`. Prerequisite `30c906cff490c` is already
here, so the patch is self-contained for this tree. That is a stable-
quality security fix.

### What the commit solves, and why it matters here
`parse_package()` can skip malformed ACPI package entries and leave
`device_mode_info[]` uninitialized. Those words can later be copied into
`context->sar_data` and read through
`/sys/bus/platform/devices/INTC1092:00/intc_data` (mode 0444). On 7.3
this driver is present; without zeroing, that is a kernel info leak.
`devm_kcalloc()` closes it with no behavioral change for well-formed
firmware.

### Stable rules / risk
The change is four lines, maintainer-reviewed, and does not add APIs.
Benefit is closing a userspace-visible leak; regression risk is
essentially zero.

### Concerns
Needs patch 1’s `devm_kmalloc_array` conversion — **already in this
tree**. No other blockers.

Verification:
- [Phase 1] Parsed tags: Reported-by Sashiko; Reviewed-by/SOB Ilpo
  Järvinen; no Fixes in the commit; original mail CCed stable@
- [Phase 2] Diff: `devm_kmalloc_array` → `devm_kcalloc` in
  `parse_package()` only
- [Phase 2] Confirmed skip/`continue` loop and `update_sar_data()` copy
  in `intel_sar.c`
- [Phase 3] Introducer `dcfbd31ef4bcf` (v5.15-rc1) is ancestor of HEAD
- [Phase 3] Parent `30c906cff490c` is ancestor of HEAD (`merge-base
  --is-ancestor` exit 0)
- [Phase 3] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = 7.3.0-rc4
- [Phase 4] `b4 dig -c f5eb833730c07`: v4 2/2 at
  patch.msgid.link/20260723-platx86-v4-2-93b4a178b595@cse.iitm.ac.in
- [Phase 4] `b4 dig -a`: v1…v4; applied version is v4 (commit-message-
  only change)
- [Phase 4] `b4 dig -w`: pdx86 maintainers + stable@vger.kernel.org
- [Phase 4] Cover letter: two bugfixes, compile-tested only; Ilpo
  requested leak-path wording
- [Phase 4] lore.kernel.org WebFetch: 403; used openwall/LKML/spinics
  instead
- [Phase 5] Call chain: `sar_probe` → `sar_get_data` → `parse_package`;
  sysfs `intc_data_show` is 0444
- [Phase 6] Buggy parse/sysfs path exists in this tree; kcalloc is the
  correct fix for it
- [Phase 8] Failure mode: kernel heap integers to userspace sysfs,
  severity HIGH (info leak)
- UNVERIFIED: verbatim Sashiko finding body; full Ilpo review email text

**YES**

 drivers/platform/x86/intel/int1092/intel_sar.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel/int1092/intel_sar.c b/drivers/platform/x86/intel/int1092/intel_sar.c
index 7263114f0b3d0..f506155f35d4d 100644
--- a/drivers/platform/x86/intel/int1092/intel_sar.c
+++ b/drivers/platform/x86/intel/int1092/intel_sar.c
@@ -91,10 +91,10 @@ static acpi_status parse_package(struct wwan_sar_context *context, union acpi_ob
 	    item->package.count <= data->total_dev_mode)
 		return AE_ERROR;
 
-	data->device_mode_info = devm_kmalloc_array(&context->sar_device->dev,
-						    data->total_dev_mode,
-						    sizeof(*data->device_mode_info),
-						    GFP_KERNEL);
+	data->device_mode_info = devm_kcalloc(&context->sar_device->dev,
+					      data->total_dev_mode,
+					      sizeof(*data->device_mode_info),
+					      GFP_KERNEL);
 	if (!data->device_mode_info)
 		return AE_ERROR;
 
-- 
2.53.0

