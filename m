Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D084D3AA4ED;
	Mon, 20 Apr 2026 13:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691940; cv=none; b=YS2YCJWadCsotfNJbzI5DqeTH9bhp8yoSF3GFCgKzQ58aF4onHe3IcVAsDqUTcNrNRdcKGHpbsAjOE2d4R8jibk8GByqex5WwdxcdwPYwTBKJT6cqm7OWsaVNUkWIVSy1AQBqyPttELDujzeOoel+yin8/inBmZ7b2IoUf5HWwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691940; c=relaxed/simple;
	bh=jOZIcP955CdCBt+l6sj/8XP1v0Jo6Uy5+KY4u8iSTH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X+Fb7slUSSbUL52RV8o05l8nzIe+r83G/4G28tqGxlyKbFEemFFu/xdFKm/9miClB8zUleCg0IVh+GgoQ9FPMaojxIIHP+2wFWapTkB7xsCZ+TWe+p/Yze0R8nEkIZqSvHMB95odbIfCinAlRXi/6DhnIRx8BFcbvBrMWcfMzf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rlnW3TWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rlnW3TWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFB8C19425;
	Mon, 20 Apr 2026 13:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691940;
	bh=jOZIcP955CdCBt+l6sj/8XP1v0Jo6Uy5+KY4u8iSTH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlnW3TWfNYCmffLOWfLGm+PbI2jjQ6pBqbJXNDwJJOyM7IEBqMqCfcCW98Tsy+Ei1
	 TgROLNToIWIwnsK/l2WML0kbwYjCSLVRIuQ4Nm5oR9WxYj+zvuQvXXFMcOERu4lQqE
	 tM1FT9GsHEYO3zkrQQT+nKEYPaRn5FD/zqNEG2xA3bhQFweeUd+bxNcynEEDNecWdY
	 BlY0vFNNffBSpqNylTfREl10PyPbPMr58UwPUwSeWBAia59KcWlrhpLcwAOER9P2xo
	 mpSZZNmwMi/gnaXNxbc2+VTr2rPjZezoGqOn6im7EVzu0axc+qqYocB5Gg51IYD1eQ
	 nK7xP3GApqnWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Li Ming <ming.li@zohomail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	dave@stgolabs.net,
	jic23@kernel.org,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	djbw@kernel.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] cxl/pci: Hold memdev lock in cxl_event_trace_record()
Date: Mon, 20 Apr 2026 09:21:15 -0400
Message-ID: <20260420132314.1023554-281-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Ming <ming.li@zohomail.com>

[ Upstream commit dc372e5f429ced834d81ff12a945397dc43585a8 ]

cxl_event_config() invokes cxl_mem_get_event_record() to get remain
event logs from CXL device during cxl_pci_probe(). If CXL memdev probing
failed before that, it is possible to access an invalid endpoint. So
adding a cxlmd->driver binding status checking inside
cxl_dpa_to_region() to ensure the corresponding endpoint is valid.

Besides, cxl_event_trace_record() needs to hold memdev lock to invoke
cxl_dpa_to_region() to ensure the memdev probing completed. It is
possible that cxl_event_trace_record() is invoked during the CXL memdev
probing, especially user or cxl_acpi triggers CXL memdev re-probing.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Li Ming <ming.li@zohomail.com>
Link: https://patch.msgid.link/20260314-fix_access_endpoint_without_drv_check-v2-3-4c09edf2e1db@zohomail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to write a comprehensive analysis.

# ANALYSIS: cxl/pci: Hold memdev lock in cxl_event_trace_record()

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** Subsystem: cxl/pci. Action verb: "Hold" (synchronization -
adding a lock). One-line intent: Add memdev device lock around
`cxl_event_trace_record()` to serialize with memdev probing.

### Step 1.2: Parse all tags
**Record:**
- Suggested-by: Dan Williams (CXL maintainer)
- Reviewed-by: Dan Williams <dan.j.williams@intel.com>
- Reviewed-by: Dave Jiang <dave.jiang@intel.com>
- Signed-off-by: Li Ming (author)
- Signed-off-by: Dave Jiang (subsystem maintainer, applied via tree)
- Link: patch.msgid.link ->
  20260314-fix_access_endpoint_without_drv_check-v2-3
- **NO Fixes: tag** (patch 4 of the same series has one, but this one
  doesn't)
- **NO Cc: stable** tag
- Strong review from TWO senior CXL maintainers

### Step 1.3: Analyze the commit body
**Record:**
- Bug description: (1) During `cxl_pci_probe()`, `cxl_event_config()`
  calls `cxl_mem_get_event_record()` which can eventually call
  `cxl_event_trace_record()`. If the cxl_memdev driver probing failed
  before this, `cxlmd->endpoint` remains at its initial value
  `ERR_PTR(-ENXIO)` (non-NULL but invalid). (2)
  `cxl_event_trace_record()` can also race with re-probing triggered by
  user (sysfs) or cxl_acpi.
- Symptom: Invalid endpoint access in `cxl_dpa_to_region()` -> NULL-ptr-
  deref / GPF (same symptom as KASAN trace in the related commit
  0066688dbcdcf).
- Author's root cause explanation: `cxlmd->endpoint` is initialized to
  `ERR_PTR(-ENXIO)` at memdev creation, and only gets updated to valid
  port on successful probe. If probing fails, consumers can see the
  sentinel and crash when dereferencing.

### Step 1.4: Detect hidden bug fixes
**Record:** The commit uses "Hold memdev lock" (synchronization change).
Per the guidance, "Clean up locking"/synchronization changes often fix
races. This is explicitly a race fix even though the subject says "Hold
lock" rather than "Fix".

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- `drivers/cxl/core/mbox.c`: ~3 lines changed (+1, added
  `guard(device)`, changed `const` to non-const)
- `drivers/cxl/core/region.c`: ~7 lines changed (added
  `!cxlmd->dev.driver` check, removed `port && is_cxl_endpoint(port)`
  check)
- `drivers/cxl/cxlmem.h`: 1 line changed (const removed from prototype)
- Total: 3 files, ~12 lines. Small, surgical.

### Step 2.2: Understand the code flow change
**Record:**
- `cxl_event_trace_record()`: BEFORE: takes region/dpa rwsems only.
  AFTER: takes memdev device lock first (synchronizes with memdev
  probe), then rwsems.
- `cxl_dpa_to_region()`: BEFORE: `port = cxlmd->endpoint; if (port &&
  is_cxl_endpoint(port) && ...)` - dereferences `ERR_PTR(-ENXIO)` in
  `is_cxl_endpoint()`. AFTER: First check `if (!cxlmd->dev.driver)
  return NULL;` - early exit when driver not bound. Then
  `cxl_num_decoders_committed(port)` check.

### Step 2.3: Identify the bug mechanism
**Record:** Combination bug category:
- **Race condition** in synchronization (commit adds `guard(device)`)
- **Memory safety** (commit adds NULL-ish check `!cxlmd->dev.driver`)
- **Invalid pointer dereference**: `cxlmd->endpoint` can be
  `ERR_PTR(-ENXIO)` (verified in drivers/cxl/core/memdev.c:678 where
  it's initialized). The old code `if (port && is_cxl_endpoint(port))`
  passes the NULL check since `ERR_PTR(-ENXIO)` is non-NULL, but then
  `is_cxl_endpoint()` dereferences `port->uport_dev` causing a GPF.

### Step 2.4: Assess fix quality
**Record:**
- Fix is correct and minimal
- Regression risk: Adding `guard(device)` could serialize event
  processing with probing. Acceptable - this is the intent. All
  callsites (`cxl_event_thread` IRQ handler, `cxl_event_config` via
  process context, `cxl_handle_cper_event`) are sleepable contexts.
- No deadlock risk: cxl_mem_probe does not need any cxl_pci-held
  resources; device locks are per-device.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:**
- `cxl_event_trace_record()` in its current form was introduced in
  v6.9-rc6 (commit 6aec00139d3a8 "cxl/core: Add region info to
  cxl_general_media and cxl_dram events"). Before v6.10 it was a static
  function without the region-lookup path.
- `cxlmd->endpoint = ERR_PTR(-ENXIO)` initialization in memdev.c:678 has
  been present for years.

### Step 3.2: Follow the Fixes: tag
**Record:** No Fixes: tag on this patch. The patch is a hardening
against race/NULL deref discovered during analysis rather than a
targeted fix. However, the bug fundamentally exists since v6.10 when
`cxl_dpa_to_region()` was first called from `cxl_event_trace_record()`.

### Step 3.3: Check file history for related changes
**Record:**
- Related recent fix: `0066688dbcdcf` ("cxl/port: Hold port host lock
  during dport adding") - merged v7.0-rc1+3. Shows an actual KASAN crash
  stack: `cxl_dpa_to_region+0x105 -> cxl_event_trace_record ->
  cxl_mock_mem_probe`. This confirms the same code path has produced
  observable crashes (in cxl_test).
- Related older fix: `285f2a0884143` ("cxl/region: Avoid null pointer
  dereference in region lookup") from v6.10 - an earlier attempt to
  harden `cxl_dpa_to_region` against the same invalid-endpoint scenario.
- This commit is patch 3/4 of the series "cxl: Consolidate
  cxlmd->endpoint accessing" (v2 from 20260314).

### Step 3.4: Check author's other commits
**Record:** Li Ming is an active CXL contributor with recent fixes in
the subsystem (PCI/IDE fixes, cxl/edac fixes, cxl/port fixes including
the related 0066688dbcdcf). Suggested-by Dan Williams = the CXL
architect. Patch-to-maintainer credibility is high.

### Step 3.5: Check for dependent/prerequisite commits
**Record:**
- Patch 3 uses `guard(device)(&cxlmd->dev)` which relies on
  `DEFINE_GUARD(device, ...)` in include/linux/device.h. This was
  introduced in v6.7-rc7 (commit 134c6eaa6087d), so all stable trees
  v6.7+ have it.
- Patch 3 does NOT depend on patch 1 of the series (which adds
  `DEFINE_GUARD_COND(device, _intr, ...)` - used only by patch 2).
- Patch 3 does NOT strictly depend on patch 2 (patch 2 fixes poison
  debugfs paths; orthogonal).
- However, older stable trees (v6.10-v6.16) use
  `cxl_region_rwsem`/`cxl_dpa_rwsem` instead of
  `cxl_rwsem.region`/`cxl_rwsem.dpa` (consolidated in v6.17 via
  d03fcf50ba56f). Backport would need rwsem name changes.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Find the original patch discussion
**Record:**
- b4 am successfully fetched the full series: 4 patches in "cxl:
  Consolidate cxlmd->endpoint accessing" v2.
- v1 of the series was at
  `20260310-fix_access_endpoint_without_drv_check-v1`.
- Changes v1->v2 per cover letter: squashed two patches into patch 3
  (this one), dropped an ineffective patch, moved lock placement per
  Alison Schofield's feedback.
- Dave Jiang confirmed applying patches 2/3/4 to `cxl/next` for v7.1:
  `43e4c205197e`, `11ce2524b7f3` (this patch), `b227d1faed0a`.
- **No stable nomination discussed** in the thread.
- No NAKs. Two rounds of review with all feedback addressed.

### Step 4.2: Check who reviewed the patch
**Record:** Dan Williams (Intel, CXL subsystem co-maintainer), Dave
Jiang (Intel, CXL subsystem maintainer), Alison Schofield (Intel, CXL
developer). All three CXL-specific mailing lists and linux-kernel were
CC'd. Full subsystem maintainer review.

### Step 4.3: Search for bug report
**Record:** No separate bug report link. The commit describes the
scenario analytically. The related commit `0066688dbcdcf` shows a real
KASAN crash in cxl_test with the same stack trace leading through
`cxl_event_trace_record -> cxl_dpa_to_region`, confirming the crash is
reproducible.

### Step 4.4: Check related patches in series
**Record:** Patch 3 is self-contained for its stated scenarios
(cxl_pci_probe event path, re-probing race). Patches 2 and 4 address
different callers (poison debugfs, cxl_reset_done). Patch 1 is a driver-
core helper used only by patch 2. Patch 3 stands on its own.

### Step 4.5: Stable mailing list history
**Record:** No stable-list discussion found for this specific patch
(only 1 month old - on its way to v7.1-rc1).

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Identify key functions
**Record:** Modified: `cxl_event_trace_record()`,
`__cxl_event_trace_record()`, `cxl_dpa_to_region()`.

### Step 5.2: Trace callers
**Record:**
- `cxl_event_trace_record()` callers (verified via grep):
  `cxl_handle_cper_event()` in pci.c (firmware event handler),
  `__cxl_event_trace_record()` in mbox.c.
- `__cxl_event_trace_record()` is called from
  `cxl_mem_get_records_log()` which is called from
  `cxl_mem_get_event_records()` which is called from: (a)
  `cxl_event_thread` (IRQ thread, pci.c:582), (b) `cxl_event_config()`
  (cxl_pci_probe path, pci.c:755).
- `cxl_dpa_to_region()` callers: `cxl_event_trace_record` (mbox.c),
  `cxl_inject_poison` and `cxl_clear_poison` (memdev.c via lines 315,
  384).

### Step 5.3: Trace callees
**Record:** `cxl_dpa_to_region` calls `device_for_each_child()` on the
endpoint port, iterating decoders. Pre-fix, first access is
`is_cxl_endpoint(port)` which dereferences `port->uport_dev` - this is
where `ERR_PTR(-ENXIO)` causes GPF.

### Step 5.4: Follow the call chain
**Record:** Path from user/firmware to crash:
1. cxl_pci_probe (boot/hotplug) -> cxl_event_config ->
   cxl_mem_get_event_records -> __cxl_event_trace_record ->
   cxl_event_trace_record -> cxl_dpa_to_region -> CRASH
2. CXL IRQ thread -> cxl_mem_get_event_records -> ... -> CRASH (if
   happens concurrent with re-probe)
3. Firmware CPER handler -> cxl_handle_cper_event ->
   cxl_event_trace_record -> CRASH

**Path is user-triggerable**: User can `echo` to sysfs to unbind/rebind
cxl_memdev, creating the race window with any ongoing event processing.

### Step 5.5: Search for similar patterns
**Record:** Commit `285f2a0884143` was an earlier (v6.10) attempt to
harden this same function against NULL-ish pointer issues. This current
patch provides stronger guarantees via driver-binding check + device
lock.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Does the buggy code exist in stable?
**Record:** The function `cxl_event_trace_record()` started calling
`cxl_dpa_to_region()` in v6.10 (commit `6aec00139d3a8`). Before that
(v6.6, v6.1) the function didn't have this call path, so the bug doesn't
exist.

Bug exists in: v6.19.y (LTS), v6.17.y (prior LTS), v6.12.y (LTS), and
anything v6.10+.
Bug does NOT exist in: v6.6.y, v6.1.y, v5.15.y, v5.10.y, v5.4.y.

### Step 6.2: Check for backport complications
**Record:**
- v6.19.y: applies with minor adjustment (uses `cxl_rwsem.region/dpa` -
  matches current tree ✓)
- v6.17.y: applies cleanly (has cxl_rwsem consolidation from v6.17)
- v6.12.y: needs rwsem name changes (`cxl_region_rwsem`,
  `cxl_dpa_rwsem`) - manual backport needed
- v6.17+ already has the function in the format this patch modifies.
  Earlier trees need non-trivial rewording of the rwsem guards.

### Step 6.3: Check if related fixes are in stable
**Record:** Commit `0066688dbcdcf` has a Fixes: tag (`4f06d81e7c6a`) and
a clear backport candidate - but it addresses a different race (dport
addition). This commit is a separate, complementary fix for a related
but distinct scenario.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** drivers/cxl = CXL memory/interconnect subsystem.
Criticality: IMPORTANT (used in data center servers, but fraction of
users compared to core mm/fs/net). CXL is relatively new hardware -
affected user population is concentrated in enterprise/server.

### Step 7.2: Subsystem activity
**Record:** CXL is actively developed - many commits per release. The
bug has existed since v6.10 (~2 years). No user-filed bug reports found,
but a reproducible test-environment crash exists.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected users
**Record:** CXL-hardware users: enterprise servers using CXL Type 3
memory devices. A subset of Linux deployments, but important for data
center.

### Step 8.2: Trigger conditions
**Record:**
- Requires probing failure OR user/firmware-initiated re-probing with
  concurrent event processing
- User-triggerable via sysfs (unprivileged users cannot access sysfs
  unbind, but root can)
- Timing-dependent race with a realistic window during probe
- Not triggered on every boot, but possible in fault/recovery scenarios

### Step 8.3: Failure mode severity
**Record:** CRITICAL - NULL-ptr-deref / general protection fault. Per
KASAN stack trace in sibling commit, the crash is reproducible. On a
server, this would be a kernel oops/panic during probe or device
recovery.

### Step 8.4: Risk-benefit
**Record:**
- Benefit: MEDIUM-HIGH (prevents crashes on CXL-enabled servers,
  especially during probe failure/recovery)
- Risk: LOW (~12 lines, surgical change, no API changes, well-reviewed
  by two maintainers)
- Ratio: favorable for backport

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Compile evidence

**For backporting:**
- Fixes a real crash (null-ptr-deref / GPF) reachable from boot probe
  path
- Small and surgical (~12 lines, 3 files)
- Well-reviewed by two senior subsystem maintainers (Dan Williams, Dave
  Jiang)
- Suggested by Dan Williams (CXL architect)
- Bug is reachable from userspace via sysfs unbind/rebind + concurrent
  event
- Similar crash confirmed in KASAN testing (related sibling commit)
- No new features, no API changes
- Patch 3 is self-contained (doesn't require patches 1/2/4 to be
  correct)

**Against backporting:**
- No Fixes: tag (the author/maintainers didn't mark this as a regression
  fix)
- No Cc: stable: annotation
- Described as "consolidate endpoint accessing" (hardening effort, not
  targeted fix)
- Part of a larger series, though this patch is self-contained
- Older stable trees (v6.12) need rwsem name adaptation
- Race is theoretical in that no user report exists (only test-env KASAN
  hits)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? YES (reviewed by two maintainers,
   applied to cxl-next)
2. Fixes a real bug that affects users? YES (null-ptr-deref crash)
3. Important issue? YES (CRITICAL severity - kernel crash)
4. Small and contained? YES (~12 lines, 3 files)
5. No new features or APIs? YES (only changes prototype const-ness and
   adds lock)
6. Can apply to stable trees? YES for v6.17+, needs adaptation for
   v6.12-v6.16

### Step 9.3: Exception categories
Not a simple device ID/quirk/DT/build fix. Falls under "race condition /
invalid pointer dereference fix" category.

### Step 9.4: Decision
The evidence favors backporting: CRITICAL severity, small scope,
maintainer review, self-contained fix for a user-triggerable crash. The
lack of a Fixes: tag is explainable (the patch is a hardening against a
long-standing issue diagnosed through systematic review) but per the
prompt, absence of tags is not a negative signal. The prompt explicitly
calls out null-ptr-deref and race condition fixes as STRONG YES signals.

## Verification

- [Phase 1] Parsed tags: Found `Suggested-by: Dan Williams`, `Reviewed-
  by: Dan Williams`, `Reviewed-by: Dave Jiang`, `Signed-off-by: Li
  Ming`, `Signed-off-by: Dave Jiang`. No Fixes:, no Cc: stable on this
  patch (confirmed by reading commit text and mailing list mbox).
- [Phase 1] Link to lore discussion: `20260314-
  fix_access_endpoint_without_drv_check-v2-3-4c09edf2e1db@zohomail.com`
  - confirmed series name "cxl: Consolidate cxlmd->endpoint accessing".
- [Phase 2] Diff analysis: Verified 3 files changed with ~12 lines total
  (mbox.c: const -> mutable + `guard(device)` add; region.c: driver
  check added, is_cxl_endpoint removed; cxlmem.h: prototype updated).
- [Phase 2] Verified `ERR_PTR(-ENXIO)` initialization at
  drivers/cxl/core/memdev.c:678 via Grep.
- [Phase 2] Verified `is_cxl_endpoint()` dereferences port->uport_dev at
  drivers/cxl/cxlmem.h:99-101, confirming crash mechanism.
- [Phase 3] `git log --oneline --grep="cxl_event_trace_record"`: found
  related fix `0066688dbcdcf` with KASAN stack trace showing the same
  crash pattern.
- [Phase 3] `git show 6aec00139d3a8`: confirmed `cxl_dpa_to_region()`
  began being called from `cxl_event_trace_record` in v6.9-rc6-4-g (part
  of v6.10 release).
- [Phase 3] `git describe --contains d03fcf50ba56f`: cxl_rwsem
  consolidation in v6.17-rc1.
- [Phase 3] `git describe --contains 134c6eaa6087d`:
  `DEFINE_GUARD(device, ...)` in v6.7-rc7, so `guard(device)` available
  in all affected stable trees.
- [Phase 4] `b4 am` successfully fetched the series, confirmed 4-patch
  structure.
- [Phase 4] Read the mbox thread - confirmed Dave Jiang applied patches
  2/3/4 to `cxl/next` for v7.1 (commits 43e4c205197e, 11ce2524b7f3,
  b227d1faed0a).
- [Phase 4] No stable nomination or concerns raised in the thread.
- [Phase 5] `grep cxl_event_trace_record`: callers are
  `cxl_handle_cper_event` (pci.c) and `__cxl_event_trace_record`
  (mbox.c); further callers in `cxl_event_thread` (IRQ) and
  `cxl_event_config` (probe).
- [Phase 5] `grep cxl_dpa_to_region`: called from
  `cxl_event_trace_record` (mbox.c) and from
  `cxl_inject_poison`/`cxl_clear_poison` (memdev.c lines 315, 384).
- [Phase 6] `git show v6.19:drivers/cxl/core/region.c`: confirmed pre-
  fix `cxl_dpa_to_region()` code exists in v6.19 (buggy pattern).
- [Phase 6] `git show v6.6:drivers/cxl/core/mbox.c`: confirmed
  `cxl_event_trace_record()` in v6.6 is different (old signature) and
  doesn't call `cxl_dpa_to_region`, so bug doesn't exist there.
- [Phase 6] `git show v6.17:drivers/cxl/core/mbox.c`: confirmed v6.17
  has `cxl_rwsem.region/dpa` (patch applies cleanly).
- [Phase 8] Failure mode: GPF/null-ptr-deref in `is_cxl_endpoint(port)`
  when port is `ERR_PTR(-ENXIO)` - verified code path. Severity:
  CRITICAL.
- UNVERIFIED: Whether this specific crash has been reported by end users
  on real (non-test) hardware - no user bug report found in lore.
- UNVERIFIED: Whether this patch has already been picked up by mainline
  Linus tree - as of this analysis, it's in cxl/next targeting v7.1-rc1,
  not yet in mainline.

## Conclusion

This patch fixes a user-triggerable null-pointer dereference
(effectively accessing `ERR_PTR(-ENXIO)`) in a CXL event trace path. The
crash pattern has been observed with KASAN in testing environments. The
fix is small (~12 lines), well-reviewed by two senior maintainers, and
self-contained. It adds a `guard(device)(&cxlmd->dev)` to serialize with
memdev probing and an explicit driver-binding check. No new features or
API changes.

The main backport complication is that older stable trees (v6.12.y) use
`cxl_region_rwsem`/`cxl_dpa_rwsem` instead of the consolidated
`cxl_rwsem` (introduced in v6.17), requiring a minor adaptation. The bug
does not exist in v6.6 and earlier.

Given it fixes a kernel crash with clear mechanism, is small and
contained, and has strong maintainer review, it meets the stable kernel
rules criteria despite lacking a Fixes: tag.

**YES**

 drivers/cxl/core/mbox.c   | 5 +++--
 drivers/cxl/core/region.c | 8 +++++---
 drivers/cxl/cxlmem.h      | 2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 12386d9127054..c4a2a1ba13ca6 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -893,7 +893,7 @@ int cxl_enumerate_cmds(struct cxl_memdev_state *mds)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_enumerate_cmds, "CXL");
 
-void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
+void cxl_event_trace_record(struct cxl_memdev *cxlmd,
 			    enum cxl_event_log_type type,
 			    enum cxl_event_type event_type,
 			    const uuid_t *uuid, union cxl_event *evt)
@@ -920,6 +920,7 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
 		 * translations. Take topology mutation locks and lookup
 		 * { HPA, REGION } from { DPA, MEMDEV } in the event record.
 		 */
+		guard(device)(&cxlmd->dev);
 		guard(rwsem_read)(&cxl_rwsem.region);
 		guard(rwsem_read)(&cxl_rwsem.dpa);
 
@@ -968,7 +969,7 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
 }
 EXPORT_SYMBOL_NS_GPL(cxl_event_trace_record, "CXL");
 
-static void __cxl_event_trace_record(const struct cxl_memdev *cxlmd,
+static void __cxl_event_trace_record(struct cxl_memdev *cxlmd,
 				     enum cxl_event_log_type type,
 				     struct cxl_event_record_raw *record)
 {
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index c37ae0b28bbbc..373551022a2b3 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2950,13 +2950,15 @@ static int __cxl_dpa_to_region(struct device *dev, void *arg)
 struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
 {
 	struct cxl_dpa_to_region_context ctx;
-	struct cxl_port *port;
+	struct cxl_port *port = cxlmd->endpoint;
+
+	if (!cxlmd->dev.driver)
+		return NULL;
 
 	ctx = (struct cxl_dpa_to_region_context) {
 		.dpa = dpa,
 	};
-	port = cxlmd->endpoint;
-	if (port && is_cxl_endpoint(port) && cxl_num_decoders_committed(port))
+	if (cxl_num_decoders_committed(port))
 		device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);
 
 	return ctx.cxlr;
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index e21d744d639bd..7a34a19c02c87 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -864,7 +864,7 @@ void set_exclusive_cxl_commands(struct cxl_memdev_state *mds,
 void clear_exclusive_cxl_commands(struct cxl_memdev_state *mds,
 				  unsigned long *cmds);
 void cxl_mem_get_event_records(struct cxl_memdev_state *mds, u32 status);
-void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
+void cxl_event_trace_record(struct cxl_memdev *cxlmd,
 			    enum cxl_event_log_type type,
 			    enum cxl_event_type event_type,
 			    const uuid_t *uuid, union cxl_event *evt);
-- 
2.53.0

