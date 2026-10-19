Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69C14F85A4;
	Mon, 19 Oct 2026 13:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418108; cv=none; b=iZZeVdA67HLGogVCpbiSG1p0BBblutCMGAi/3aC2eY+rpHO6Pb+ozxo5+AcZrE1y3thKy8FV+Ae7bGet8C+jxSo8MiRBhSPH9TP5Uq31xm21KH5CexhqNla2XLq1aka2nR9apZ9RrGpYNBMXdDct0v6v56uXQ70gTsDZBg87ytc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418108; c=relaxed/simple;
	bh=pmuIY4OZKfAYMXKgFAdLY0L3nV3R296R7yS7bxL/xbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nxcDemW5leAu3aSiWEFRoQxWmpFeQdmPa/damzbT2s9HhvgPforvCvAbPQUObEnqwnH/jBEUlxEWOMNXl2PUKKn3xFyeN+tjf6t1HToGmB766TcK06W3ECkzPQoJl2KcLs9blZ90yYTYLmtHZlsl4R6HKVGhpsGz9XO3vu2KIvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXbp7X4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXbp7X4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1561F000CE;
	Mon, 19 Oct 2026 13:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418106;
	bh=K1yI4OaXXQqqhSpz4taIeYtRsTD8IJ6NxXgAgl7pho8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXbp7X4wxaN4ubhmIBfePEnW8a9TF+FIkXAbsw+EJ3nxdy2OTI6NarjCFSy/bvH4g
	 uMg9p7/bOHcYV20mG4Ep4P3ASgyE5M0iow0smnor6hZNfE/ZlXdOTjH8occ36p/fEO
	 GGCV02QNByGiaS5iGymH35CfVfuWy2U2qmNIJDuFbVx15+8Nsjb8Jn+UhIqnm/2kbL
	 vnO8nIE/V2SOXXk1LP7Ok8hYUgiuxgqexL//dYVVDZi/DMwZg6fkZRZ/7nXWbz3DMq
	 RwTfU9vfxKhpPZbexGP9bvYBfL5UAPxPCqifktZSpj1Z2sVln8OVdHqZYKUMNlkYVM
	 +z59esXNrF2KQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xixin Liu <liuxixin@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	axboe@kernel.dk,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] nvme: zns: cap zone report nr_zones by DMA buffer size
Date: Mon, 19 Oct 2026 09:45:07 -0400
Message-ID: <20261019135441.1420968-16-sashal@kernel.org>
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

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit 09c9062d4f62199a634a45e2bb9e6e8e572cc78c ]

With Partial Report (PR=1), the Number of Zones (NZ) field in the report
header must equal the number of zone descriptors fully transferred in the
DMA buffer (ZNS Command Set Specification Rev 1.2, section 3.4.2).

nvme_ns_report_zones() does not cap the parse loop by max_in_buf derived
from buflen.  Cap nz with min3() over the device-reported count, nr_zones -
zone_idx, and max_in_buf.

Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
candidate is `09c9062d4f621` (“nvme: zns: cap zone report nr_zones by
DMA buffer size”). The ZNS report path has been here since v5.9; this is
a small host-side bounds cap against a device-controlled zone count.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[nvme: zns:] [cap] [limit zone-report parse count by DMA
buffer size]**
- Subsystem: NVMe host Zoned Namespace (ZNS) driver
- Verb “cap” is a bounds/safety fix, not a feature

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for manual review)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Christoph Hellwig `<hch@lst.de>` (NVMe/block
  maintainer)
- **Acked-by:** none
- **Link:** none
- **Cc: stable:** none (expected; not a negative)
- **Signed-off-by:** Xixin Liu `<liuxixin@kylinos.cn>` (author); Keith
  Busch `<kbusch@kernel.org>` (NVMe maintainer)
- Ignore any Sasha Levin SOB / “Upstream commit” markers — none present
  on the real commit

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `nvme_ns_report_zones()` trusts `report->nr_zones` from the
  device and caps only by the caller’s `nr_zones`, not by how many
  `nvme_zone_descriptor`s fit in the allocated DMA/vmalloc buffer
  (`buflen`).
- **Spec:** With Partial Report (PR=1), NZ must equal descriptors fully
  transferred (ZNS Command Set Spec Rev 1.2 §3.4.2).
- **Symptom/failure mode:** parse loop `report->entries[i]` can walk
  past `buflen` → kernel out-of-bounds read (crash / KASAN / info leak).
  `sector += zsze * nz` can also advance by an inflated `nz`.
- **Version info in message:** none
- **Root cause:** missing cap derived from `buflen`

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not disguised.** Explicit bounds-cap of a device-provided
count. Real memory-safety fix, not cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/nvme/host/zns.c` — **+6 / −2** (8 lines in the commit)
- Function: `nvme_ns_report_zones()` only
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** after `nvme_zns_alloc_report_buffer()` and
  `nvme_submit_sync_cmd()`, `nz = min(le64_to_cpu(report->nr_zones),
  nr_zones)` then `for (i = 0; i < nz && zone_idx < nr_zones; i++)`
  reads `report->entries[i]`.
- **After:** `max_in_buf = (buflen - sizeof(nvme_zone_report)) /
  sizeof(nvme_zone_descriptor)`; `nz = min3(device NZ, nr_zones -
  zone_idx, max_in_buf)`.
- Path: normal ZNS zone-report (probe/revalidate, `BLKREPORTZONE` ioctl,
  filesystems using `blkdev_report_zones()`).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Memory safety / OOB] [device-controlled length not capped by
allocation]**
- `nvme_zone_report` is 64 bytes + flexible `entries[]`; each descriptor
  is 64 bytes (verified in `include/linux/nvme.h`).
- Buffer is often **smaller** than `nr_zones` descriptors:
  `nvme_zns_alloc_report_buffer()` min()s against
  `queue_max_hw_sectors`, `queue_max_segments << PAGE_SHIFT`, and halves
  `bufsize` on vmalloc failure.
- Callers pass `BLK_ALL_ZONES` (`(unsigned int)-1` / `UINT_MAX`) — e.g.
  `disk->fops->report_zones(disk, 0, UINT_MAX, ...)` in `block/blk-
  zoned.c` during zone revalidate. Then `min(device_nz, UINT_MAX) ==
  device_nz`.
- If firmware reports total zones (or a huge NZ) instead of the partial-
  transfer count, the loop indexes past the allocation.
- Secondary: `nr_zones - zone_idx` keeps `nz` as remaining requested
  zones for `sector += zsze * nz`.
- Same buffer-derived cap already exists in the NVMe **target**:
  `get_nr_zones_from_buf()` in `drivers/nvme/target/zns.c`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Obviously correct:** `min3` of device count, remaining request, and
  descriptors that fit in `buflen`.
- **Minimal:** two small hunks, no API/struct change.
- **Regression risk: very low.** Only **lowers** `nz`. Compliant PR=1
  devices already set NZ ≤ `max_in_buf`, so behavior is unchanged on
  good hardware.
- `min3()` exists in `include/linux/minmax.h` in this tree.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Buggy pattern introduced in **`240e6ee272c07`** (“nvme: support for
  zoned namespaces”, Keith Busch, 2020-06-29).
- First contained in **`v5.9-rc1`**.
- Present for many years; not a recent-only bug.
- `nz = min(device NZ, nr_zones)` form after **`936fab503ff4a`** (“nvme:
  fix error handling in nvme_ns_report_zones”), which still did not cap
  by buffer size.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Introduced by `240e6ee272c07` (v5.9). That
commit **is** an ancestor of this tree (`git merge-base --is-ancestor
240e6ee272c07 HEAD` succeeded). Candidate **`09c9062d4f621` is also
already an ancestor of HEAD** (landed in **v7.3-rc1**). No later
overlapping fix of the same `nz` cap.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Related: `936fab503ff4a` (error handling), `8b4fb0f968ffe` (split
  report_zones), `fdb9aed869f34` (`disk_report_zone()` args).
- **Standalone:** this hunk does not need those refactors; it only
  changes how `nz` is computed.
- Sibling **`3456b52552896`** (v2 2/2) only adds zone index to an error
  log — **not a prerequisite**.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record:
- Author Xixin Liu: several NVMe patches (`09c9062d4f621`,
  `3456b52552896`, plus tcp/rdma/auth). Not the subsystem maintainer.
- Applied by **Keith Busch**; reviewed by **Christoph Hellwig**. High
  maintainer weight.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: **No functional prerequisites.** Uses existing `min3`, `buflen`,
`nvme_zone_report` / `nvme_zone_descriptor`. Can apply standalone on any
tree with this parse loop (since v5.9).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 09c9062d4f621` → https://patch.msgid.link/8ed1b6a33454.v2.1
  782280600.git.liuxixin@kylinos.cn
- Full thread saved via `b4 dig -m /tmp/nvme-zns-thread.mbox`
- **v1** (2026-06-24): combined bounds cap + log message change
- **v2** (2026-06-25): split per review; **1/2 is this fix**, 2/2 is
  logging
- Christoph on v1: log change “unrelated, please split”; **“The rest
  looks good as well.”**
- Christoph on v2 1/2: **“Looks good: Reviewed-by: Christoph Hellwig”**
- Keith Busch: **“Thanks, applied to nvme-7.3.”**
- **No NAK, no stable objection, no risk flags.** No explicit Cc: stable
  in the thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc linux-nvme, Keith Busch, Jens Axboe,
Christoph Hellwig, Sagi Grimberg, linux-kernel. Appropriate NVMe/block
maintainers.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: **No syzbot, bugzilla, or user crash report.** Spec-driven host-
side hardening. Still a real OOB if NZ exceeds the buffer
(buggy/malicious NVMe, including fabrics/USB).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: v2 is 2/2. **1/2 is self-contained.** 2/2 is optional logging,
not required for the bounds fix.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Web search of lore.kernel.org/stable for this subject found **no
relevant discussion** (unrelated historical hits only). Not previously
rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: **`nvme_ns_report_zones()`** (uses
`nvme_zns_alloc_report_buffer()`, `nvme_zone_parse_entry()`,
`nvme_submit_sync_cmd()`).

**Step 5.2: TRACE CALLERS**
Record:
- `nvme_report_zones()` in `drivers/nvme/host/core.c` — `gendisk`
  `.report_zones` (`nvme_bdev_ops`)
- `nvme_ns_head_report_zones()` in `drivers/nvme/host/multipath.c` —
  multipath head ops
Both under `CONFIG_BLK_DEV_ZONED` (`zns.o` is `nvme-
core-$(CONFIG_BLK_DEV_ZONED)`).
Upper layer: `blkdev_do_report_zones()` → ioctl,
`blkdev_report_zones()`, and **revalidate with `UINT_MAX`** (`block/blk-
zoned.c` ~2354). Filesystems: zonefs, f2fs, btrfs, xfs zoned.

**Step 5.3: TRACE CALLEES**
Record: alloc buffer (vmalloc, queue limits), Zone Management Receive
with `NVME_REPORT_ZONE_PARTIAL`, parse entries, `disk_report_zone()`,
`kvfree`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace `BLKREPORTZONE` / zoned FS mount / disk revalidate →
`disk->fops->report_zones` → `nvme_ns_report_zones`. **Reachable from
userspace and from device probe.** Unprivileged trigger depends on
device node permissions; probe path is admin/boot. Malicious NVMe-over-
Fabrics still in scope for some deployments.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: NVMe target already caps with `get_nr_zones_from_buf()`. SCSI
`sd_zbc.c` uses report-length/`nr_zones` differently. Host ZNS was the
missing cap.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: **Linux 7.3.0-rc4** (`git describe HEAD` =
  `v7.3-rc4-27-gf0100363d8c37`).
- File and function exist; current `zns.c` **already contains this cap**
  (commit is in HEAD).
- Bug introduced **v5.9** (`240e6ee272c07`); not after this branch
  point.
- This checkout is **mainline 7.3-rc**, not an older LTS cut, but the
  **same `nvme_ns_report_zones` loop** is what older stables still have
  without the cap.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** on this tree (already applied). Context around
`nz = min(...)` is stable since the 2020 error-handling fix. No
conflicting later rewrite of that assignment. Expected **clean or
trivial** cherry-pick onto trees that still have
`nvme_ns_report_zones()`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This is the fix. No alternate `max_in_buf` cap. Sibling logging
commit is independent.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **`drivers/nvme/host/` ZNS** — **IMPORTANT** (storage; not core
mm/VFS, but NVMe zoned devices used by zonefs/f2fs/btrfs/xfs). Config-
gated by `CONFIG_BLK_DEV_ZONED`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: NVMe host is actively maintained; `zns.c` itself is **mature**
(ZNS since 2020). Long-lived bug, not churn from a new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver/config-specific:** NVMe ZNS namespaces
(`CONFIG_BLK_DEV_ZONED`). Not all NVMe users; all ZNS users on
report/revalidate/ioctl/FS mount.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Common path: zone report / revalidate (`UINT_MAX` zones).
- Harmless on spec-compliant PR=1 devices (NZ already ≤ buffer).
- Harmful if firmware reports NZ larger than transferred descriptors
  (ignore PR, report total count, or malicious controller).
- Not a timing race. Device-controlled integer.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Out-of-bounds kernel read** of `report->entries[i]` past
`buflen` → oops/KASAN, possible infoleak. **Severity: HIGH** (memory
safety from device-provided length). Inflated `nz` can also skip zones
in `sector +=` if the loop continues; the OOB is the primary issue.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** HIGH for ZNS — prevents OOB on buggy/malicious
  controllers; correct remaining-count; matches target-side logic.
- **Risk:** VERY LOW — 6 insertions, only tightens a min(); no
  lock/API/hot-path change.
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OOB: parse count from device NZ not limited by DMA/vmalloc buffer
- Buffer is routinely smaller than requested `nr_zones` (queue limits,
  vmalloc backoff)
- Revalidate uses `UINT_MAX`, so `min(NZ, nr_zones)` does not cap
- Small (+6/−2), obviously correct `min3`
- Reviewed by Christoph Hellwig; applied by Keith Busch
- Same cap already in NVMe target
- Bug in tree since v5.9; no extra deps
- No new API/feature

AGAINST:
- No public crash/syzbot report (spec-compliant devices already set NZ)
- ZNS is a subset of NVMe users
- No Fixes:/Cc: stable (ignored per rules)

UNRESOLVED:
- Could not fetch lore.kernel.org HTML (403); thread recovered via `b4
  dig -m`
- No stable-list discussion found

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — maintainer Reviewed-by;
   applied to nvme-7.3
2. Fixes a real bug that affects users? **PASS** — OOB if NZ exceeds
   buffer; reachable zone-report path
3. Important issue? **PASS** — HIGH memory-safety (OOB read), not
   cosmetic
4. Small and contained? **PASS** — 8 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — code present; patch already
   applies here

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Not** a device-ID/quirk/DT/build/docs exception. Ordinary
**memory-safety bug fix**.

**Step 9.4: MAKE YOUR DECISION**
This should be backported: it is a small, maintainer-acked cap that
stops the ZNS host from walking off the report buffer when the device’s
NZ is larger than what `buflen` can hold. On this 7.3-rc4 tree the ZNS
report path exists and the same bug has been in `nvme_ns_report_zones()`
since v5.9.

What it solves for stable users: kernel OOB on NVMe ZNS zone reports
(ioctl, FS mount, disk revalidate), especially with `BLK_ALL_ZONES` and
firmware that does not honor Partial Report.

Risk vs benefit: benefit is memory safety on a real I/O path; risk is a
tighter min that is a no-op on compliant devices.

Concerns: none material. Sibling logging patch is not required. No
missing prerequisites on this tree.

Verification:
- [Phase 1] Parsed subject/tags: Reviewed-by Christoph Hellwig; SOB
  Keith Busch; no Fixes/Reported-by/Cc:stable
- [Phase 1] Body: PR=1 / NZ vs DMA buffer; missing `max_in_buf` cap
- [Phase 2] Diff: `drivers/nvme/host/zns.c` +6/−2 in
  `nvme_ns_report_zones()`; `min3(device NZ, nr_zones - zone_idx,
  max_in_buf)`
- [Phase 2] Struct sizes: `nvme_zone_report` 64B, descriptor 64B
  (`include/linux/nvme.h`)
- [Phase 2] Alloc can shrink buffer: `nvme_zns_alloc_report_buffer()`
  hw_sectors/segments/vmalloc halving
- [Phase 3] `git blame`: loop from `240e6ee272c07` (v5.9-rc1)
- [Phase 3] `git describe --contains 240e6ee272c07` → v5.9-rc1;
  `09c9062d4f621` → v7.3-rc1
- [Phase 3] `git merge-base --is-ancestor` both SHAs vs HEAD: success
- [Phase 3] No Fixes: tag; sibling `3456b52552896` is logging-only
- [Phase 4] `b4 dig -c`: msgid
  `8ed1b6a33454.v2.1782280600.git.liuxixin@kylinos.cn`
- [Phase 4] `b4 dig -a`: v1 then v2 (split log change)
- [Phase 4] `b4 dig -w`: linux-nvme, kbusch, axboe, hch, sagi
- [Phase 4] mbox: Christoph “Looks good” + R-b; Keith “applied to
  nvme-7.3”; no NAK
- [Phase 4] lore HTTP 403; used b4 mbox instead
- [Phase 4] stable list search: no relevant thread
- [Phase 5] Callers: `core.c` `nvme_report_zones`, `multipath.c`
  `nvme_ns_head_report_zones`; `blk-zoned.c` `UINT_MAX` revalidate
- [Phase 5] `BLK_ALL_ZONES` = `(unsigned int)-1` in
  `include/linux/blkdev.h`
- [Phase 5] Target already has `get_nr_zones_from_buf()`
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-g…; `make kernelversion`:
  7.3.0-rc4
- [Phase 6] Current `zns.c` already has `max_in_buf` / `min3`
- [Phase 8] Failure: OOB read of `report->entries[]`; severity HIGH
- UNVERIFIED: live crash on specific firmware (no public repro); does
  not override code-level OOB

The patch is small, correct, and fixes a real device-controlled bounds
bug in NVMe ZNS zone reporting.

**YES**

 drivers/nvme/host/zns.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index cce4c5b55aa9c..f067185920451 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -178,7 +178,7 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	struct nvme_zone_report *report;
 	struct nvme_command c = { };
 	int ret, zone_idx = 0;
-	unsigned int nz, i;
+	unsigned int max_in_buf, nz, i;
 	size_t buflen;
 
 	if (ns->head->ids.csi != NVME_CSI_ZNS)
@@ -188,6 +188,9 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	if (!report)
 		return -ENOMEM;
 
+	max_in_buf = (buflen - sizeof(struct nvme_zone_report)) /
+		sizeof(struct nvme_zone_descriptor);
+
 	c.zmr.opcode = nvme_cmd_zone_mgmt_recv;
 	c.zmr.nsid = cpu_to_le32(ns->head->ns_id);
 	c.zmr.numd = cpu_to_le32(nvme_bytes_to_numd(buflen));
@@ -207,7 +210,8 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 			goto out_free;
 		}
 
-		nz = min((unsigned int)le64_to_cpu(report->nr_zones), nr_zones);
+		nz = min3((unsigned int)le64_to_cpu(report->nr_zones),
+			  nr_zones - zone_idx, max_in_buf);
 		if (!nz)
 			break;
 
-- 
2.53.0

