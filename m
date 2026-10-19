Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1E9502568;
	Mon, 19 Oct 2026 13:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418182; cv=none; b=IEgjNVDg4oDEO+fmAsjGYbl90yOLg5SM1JVQEWPj5s9wOa1O/nZdtMjD6LQ6eIs6VEXJXnpcr2QFncNDYlCmRVA0q0FXDXSfi1pydjr4c1MXju/ZbM+LEoMTQjSTX1vss+cpz8QGQZR9jmT4GzRMhsw5z2riEgUQ1dIj3NYFtNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418182; c=relaxed/simple;
	bh=RlffUz8JihSlv5mwNytmHxI/B9wdZdzOvQe+86D73Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nzP4j353zUboskD8MYal6WZzehP/tu5J3vyw9QgFBuKaOQCghVPyvQjD8O2KlL2LUq5HtOzTElYBHBk0RHId3A1T9CztsMGCpiN7VR1rNSDTP0lUf5pI54IrFKLSn1q6oo6PXhmb2kmSQWZHtKvEQ0gaHX/7WDVoDFBZA0grQlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kSFNWfaN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kSFNWfaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE00E1F000C5;
	Mon, 19 Oct 2026 13:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418179;
	bh=vpj6IvGtQRXGfs75eSRHxCa9kkV+bZVG3Uo3pFiayeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kSFNWfaNahiLsQgI+ovO2xakRpOGSK7tN+pCCegsz8cn2X+99/H8GkBZ7+siCXBX5
	 Spi1/q/pd/ZDSO6wv3j87pUiJRaz8jON48NzyH5qCU2tfurB0x6xDTNL8jQFEC0l0e
	 wMRIazw/fGiQ6L5IIltUqW1Tn534a3NV/zMxhkb9IoDUQN5QawuaNU829C9WaFLVb2
	 EBRDC+8797DtJ7RRaJfhIUcjk8s4gsFvVn/fiSJ24qMsUnXcD0MSWQmSVSFxgNAdHq
	 QRUJ3kvqVlEzU/TyB81I/DiY3lDZFzgBMaLpoMRFYY5TnNKiel82uOhKAaKKw/qz7P
	 GtVGhp+703ePA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xixin Liu <liuxixin@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	kch@nvidia.com,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] nvmet: zns: reject full zone report when buffer is too small
Date: Mon, 19 Oct 2026 09:46:00 -0400
Message-ID: <20261019135441.1420968-69-sashal@kernel.org>
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

[ Upstream commit 86985da12699360a2b20748c5a492ddd92db8c47 ]

Zone Management Receive uses the Partial Report (PR) bit in dword 13.  On a
partial report (PR bit set), the host accepts an incomplete listing and
Number of Zones must not exceed the zone descriptors copied to the host
buffer.  On a full report (PR bit clear), Number of Zones is the total
number of matching zones and every descriptor must fit in the buffer (ZNS
Command Set Specification Rev 1.2, section 3.4.2).

nvmet_bdev_zone_zmgmt_recv_work() already caps Number of Zones for partial
reports, but on a full report it may still succeed when the buffer only
holds part of the matching descriptors.  Reject the command in that case.

Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The buggy Zone
Management Receive path is present here, and this is a small spec-
compliance fix that should be backported to this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
- Subsystem prefix: `nvmet: zns:`
- Action verb: **reject** (prevents an illegal success path)
- Claimed intent: fail a full (PR=0) zone report when the host buffer
  cannot hold every matching descriptor

Record: [nvmet/zns] [reject] [fail full zone report when the data buffer
is too small]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- Signed-off-by: Xixin Liu <liuxixin@kylinos.cn> (author)
- Reviewed-by: Christoph Hellwig <hch@lst.de> (NVMe/block maintainer)
- Signed-off-by: Keith Busch <kbusch@kernel.org> (NVMe maintainer;
  applied the patch)
- No Fixes: tag (expected for this review pipeline)
- No Reported-by / Tested-by / Link / Cc: stable
- Ignore any pipeline-added Sasha Levin SOB / Upstream markers

Record: Author SOB + Hellwig Reviewed-by + Busch SOB. No syzbot, no user
report, no Fixes tag.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Zone Management Receive uses the Partial Report (PR) bit:
- PR=1 (partial): host accepts an incomplete listing; Number of Zones
  must not exceed descriptors actually copied.
- PR=0 (full): Number of Zones is the total match count; every matching
  descriptor must fit (ZNS Command Set Spec Rev 1.2 §3.4.2). If the
  buffer is too small, the command must be aborted with Invalid Field in
  Command.

`nvmet_bdev_zone_zmgmt_recv_work()` already caps Number of Zones for
PR=1, but for PR=0 it can still complete successfully when only some
matching descriptors were copied.

Record:
- Bug: full report succeeds with incomplete descriptors while Number of
  Zones is the full match count
- Symptom: initiator sees SUCCESS plus a header that claims more zones
  than were transferred
- Version info: none in the message; code dates to 2021
- Root cause: PR=0 path never checks `nr_zones > out_nr_zones`

Step 1.4: DETECT HIDDEN BUG FIXES
Not hidden. This is an explicit protocol-correctness fix: illegal
SUCCESS → INVALID_FIELD | DNR.

Record: [Not a disguised cleanup; it is a command-handling bug fix]

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
- File: `drivers/nvme/target/zns.c`
- Scope: ~10 insertions / 3 deletions in one function
- Function: `nvmet_bdev_zone_zmgmt_recv_work()`
- Classification: single-file surgical fix

Record: [zns.c, ~+10/-3] [nvmet_bdev_zone_zmgmt_recv_work] [surgical]

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Before (this tree, lines 301–309):

```301:309:drivers/nvme/target/zns.c
        /*
  - When partial bit is set nr_zones must indicate the number of zone
  - descriptors actually transferred.
         */
        if (req->cmd->zmr.pr)
                rz_data.nr_zones = min(rz_data.nr_zones,
rz_data.out_nr_zones);

        nr_zones = cpu_to_le64(rz_data.nr_zones);
        status = nvmet_copy_to_sgl(req, 0, &nr_zones, sizeof(nr_zones));
```

After:
- PR=1: same cap as today
- PR=0 and `nr_zones > out_nr_zones`: set `error_loc` to `numd`, return
  `NVME_SC_INVALID_FIELD | NVME_STATUS_DNR`, skip writing the header
- Otherwise: unchanged success path

The callback still copies only descriptors that fit (`if (rz->nr_zones <
rz->out_nr_zones)`), then increments `nr_zones` for every match. So
after `blkdev_report_zones()`, `nr_zones` is the match count and
`out_nr_zones` is buffer capacity. That comparison is exactly the
missing check.

Record: [PR=0 undersized buffer: SUCCESS + inflated nr_zones →
INVALID_FIELD | DNR]

Step 2.3: IDENTIFY THE BUG MECHANISM
Category: **logic / protocol correctness** (not UAF, leak, or race).

Mechanism: PR=0 must fail when the buffer cannot hold every matching
descriptor. The target currently reports SUCCESS and writes Number of
Zones = full match count while copying only `out_nr_zones` descriptors.
A host that iterates `report->nr_zones` entries then reads past its
buffer.

The status and `error_loc` match the existing too-small-header check in
`nvmet_bdev_validate_zone_mgmt_recv()` (lines 164–166).

Record: [Logic/spec] [PR=0 truncated full report incorrectly succeeds]

Step 2.4: ASSESS THE FIX QUALITY
Obviously correct against the spec and against the existing PR=1 cap.
Minimal. No API/data-structure change.

Regression risk is low:
- Linux kernel host always sets `c.zmr.pr = NVME_REPORT_ZONE_PARTIAL` in
  `nvme_ns_report_zones()` — that path is unchanged
- PR=0 with an adequate buffer is unchanged
- Only PR=0 with a too-small buffer flips SUCCESS → error, which is the
  specified behavior
- Failed commands already `goto out` in this function; `error_loc` /
  `NVME_STATUS_DNR` are used throughout this file

Record: [High quality, surgical] [Low regression risk; only the illegal
success path changes]

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
`git blame -L 267,313 drivers/nvme/target/zns.c`: every line of this
function is from

`aaf2e048af2704` — `nvmet: add ZBD over ZNS backend support` (Chaitanya
Kulkarni, 2021-06-09)

`git merge-base --is-ancestor aaf2e048af2704 v6.12` succeeded. The bug
has been in this series from the start of 6.12 (and since ~v5.14).

Record: [Introduced by aaf2e048af2704, 2021] [Present in this 6.12 tree]

Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag. The introducing commit is the original ZNS target
feature, not a later regression.

Record: [No Fixes tag] [Buggy code is the original 2021 implementation,
ancestor of HEAD]

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Recent `drivers/nvme/target/zns.c` history in this tree: identify NULL
deref, DNR rename, conv_zones_bitmap, etc. None already implement this
PR=0 rejection. Current source still has the old comment and the `if
(req->cmd->zmr.pr)` cap only.

Standalone 1/1 (cover letter on lore confirms a single patch).

Record: [No prior equivalent fix in this file] [Standalone; no series
prerequisites]

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Xixin Liu has other NVMe work in this tree (tcp/rdma), but this ZNS recv
check is not already here. Review weight comes from Hellwig + Busch, not
from the author being the subsystem maintainer.

Record: [Contributor, not nvmet maintainer] [Reviewed/applied by NVMe
maintainers]

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Diff uses `req->error_loc`, `offsetof(struct nvme_zone_mgmt_recv_cmd,
numd)`, `NVME_SC_INVALID_FIELD | NVME_STATUS_DNR`. All exist in this
tree (`NVME_STATUS_DNR` via `dd0b0a4a2c5d7`, already in 6.12). Context
in `zns.c` matches the pre-image exactly.

Record: [No missing helpers] [Applies standalone to this tree]

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
lore.kernel.org WebFetch returned 403. Thread recovered from the gnuweeb
mirror:

https://lore-kernel.gnuweeb.org/linux-
nvme/cover.1783579899.git.liuxixin@kylinos.cn/T/

- v1: 2026-07-09, nested `else { if (...) }`
- Hellwig: line too long; use `else if`
- v2: 2026-07-13, matches the candidate diff
- Hellwig: “Looks good” + Reviewed-by
- Busch: “Thanks, applied to nvme-7.3.”
- No NAK, no stable discussion, no security/crash report
- Author: “Tested on nvmet-tcp loopback with io-passthru.”

`b4 dig -c` was not used: the candidate SHA is not in this checkout.
Thread contents were verified from the archive instead.

Record: [v1→v2 style-only] [Hellwig RB, Busch applied] [No NAK / no Cc:
stable in review]

Step 4.2: CHECK WHO REVIEWED THE PATCH
Original To/Cc: linux-nvme, hch, sagi (Sagi Grimberg), kch (Chaitanya
Kulkarni). Right maintainers were on the thread.

Record: [Hellwig reviewed; Busch applied; Kulkarni/Grimberg CCed]

Step 4.3: SEARCH FOR THE BUG REPORT
No Reported-by, bugzilla, or syzbot. Same author also posted a host-side
defensive patch (`nvme: zns: cap zone report nr_zones by DMA buffer
size`) because hosts that trust Number of Zones can walk past the DMA
buffer. That is independent; this tree’s host `zns.c` has no
`max_in_buf` yet, and Linux host uses PR=1 anyway.

Record: [No end-user crash report] [Author also wrote a host-side bound
against inflated nr_zones]

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Cover is 0/1 + 1/1. Self-contained. Host cap patch is a separate
hardening change, not a prerequisite for the target rejection.

Record: [Standalone target fix] [Host companion not required here]

Step 4.5: CHECK STABLE MAILING LIST HISTORY
lore.kernel.org/stable search also 403. No evidence in the nvme thread
that stable was requested or rejected.

Record: [No stable-list discussion found] [UNVERIFIED: could not query
lore.kernel.org/stable directly]

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: [`nvmet_bdev_zone_zmgmt_recv_work`]

Step 5.2: TRACE CALLERS
- `nvmet_bdev_execute_zone_mgmt_recv()` queues that work
- Set as `req->execute` from `nvmet_bdev_zns_parse_io_cmd()` on
  `nvme_cmd_zone_mgmt_recv`
- `nvmet_parse_io_cmd()` → `nvmet_bdev_zns_parse_io_cmd()` when
  `req->ns->csi == NVME_CSI_ZNS` and `CONFIG_BLK_DEV_ZONED`

Record: [I/O path for ZNS namespaces on nvmet] [Triggered by Zone
Management Receive from an initiator]

Step 5.3: TRACE CALLEES
`nvmet_bdev_validate_zone_mgmt_recv`, `blkdev_report_zones` /
`nvmet_bdev_report_zone_cb`, `nvmet_copy_to_sgl`, `nvmet_req_complete`.
No new locks or allocations.

Record: [Existing report/copy/complete helpers only]

Step 5.4: FOLLOW THE CALL CHAIN
Reachable from NVMe-oF (TCP/RDMA/FC/loop) against a ZNS target
namespace. Userspace tools (`nvme zns report-zones`, libnvme, SPDK) can
send PR=0. Linux in-kernel host always uses PR=1, so it does not hit the
bug, but other initiators can.

Record: [Userspace/NVMe-oF reachable] [Linux kernel host does not use
PR=0]

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Only this one PR=0/PR=1 split in nvmet. Host always sets
`NVME_REPORT_ZONE_PARTIAL`. No sibling driver with the same missing
full-report check.

Record: [Single instance in nvmet ZNS]

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Yes. `make kernelversion` = 6.12.111; `git describe HEAD` =
`p-6.12-3-gc504cf0baa3d8`. Current `nvmet_bdev_zone_zmgmt_recv_work()`
still only caps PR=1. Introducer `aaf2e048af2704` is an ancestor of
v6.12 and of HEAD.

Record: [Bug exists at drivers/nvme/target/zns.c:305-306] [Since
aaf2e048af2704 / ~5.14]

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Pre-image matches this file exactly (`OLD FOUND` in a dry-run of the
hunk). `NVME_STATUS_DNR` and `numd` exist. No refactor in the way.

Record: [Expected clean apply]

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
`git log --grep` on this file found no “reject full zone report”. Host
`max_in_buf` is also absent. No equivalent fix.

Record: [Not already present]

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
`drivers/nvme/target/zns.c` — NVMe target ZNS backend, built as
`nvmet-$(CONFIG_BLK_DEV_ZONED)`.

Record: [nvmet ZNS] [IMPORTANT for NVMe-oF zoned exports; not core
mm/VFS]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
nvmet is actively fixed in this 6.12 tree (TCP OOB, auth, RDMA leaks,
ZNS identify NULL deref). ZNS recv itself has been stable since 2021.

Record: [nvmet active; this function long-unchanged]

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Config-specific: `CONFIG_NVME_TARGET=y` and `CONFIG_BLK_DEV_ZONED=y`,
exporting a zoned bdev as a ZNS namespace. Initiators that send Zone
Management Receive with PR=0 and a buffer smaller than the matching
descriptor list.

Record: [Config-specific: nvmet + zoned bdev + PR=0 full report]

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Deterministic: PR=0 + `numd` too small for every matching zone. Not a
race. Linux kernel host does not trigger it (PR=1). Userspace and non-
Linux NVMe-oF initiators can. Needs access to the subsystem, not a
random unprivileged syscall on a machine that is not an NVMe target.

Record: [Deterministic protocol path] [Common for tools that request a
full report with a small buffer] [Not a local unprivileged syscall
unless nvmet is configured]

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Target kernel: no oops, leak, or deadlock — wrong SUCCESS instead of
Invalid Field.

Initiator: SUCCESS + Number of Zones = full match count + only a prefix
of descriptors transferred. A parser that trusts that count walks past
its buffer (userspace OOB / wrong zone map). Incomplete zone inventory
can then drive wrong zone management.

Record: [Incorrect SUCCESS / truncated full report] [Severity: MEDIUM —
protocol/data-integrity for zoned NVMe-oF, not a target oops]

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Benefit: spec-correct failure instead of a silently truncated zone map;
avoids initiator over-read and incomplete inventory. Small but real for
nvmet ZNS users.

Risk: ~10 lines, error path only, same status pattern already used in
this file. Linux in-kernel host path unchanged.

Record: [Benefit: medium for affected nvmet ZNS users] [Risk: very low]
[Favor backport]

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR:
- Real, deterministic spec violation in command completion (ZNS 1.2
  §3.4.2)
- SUCCESS with Number of Zones > descriptors transferred can make
  initiators over-read or act on an incomplete zone map
- ~10-line surgical change, obviously correct
- Hellwig Reviewed-by, Busch applied; author tested nvmet-tcp loopback
- Buggy code has been in this 6.12 tree since the original ZNS target
  code (2021)
- Applies cleanly; all symbols exist (`NVME_STATUS_DNR`, `numd`,
  `error_loc`)
- No new API/feature
- Fits stable-kernel-rules “oh, that's not good” for storage protocol
  results

AGAINST:
- Not a target oops/UAF/deadlock
- No syzbot or production Reported-by
- Niche: nvmet + zoned + PR=0
- Linux in-kernel host always uses PR=1
- No Cc: stable (not a negative under these review rules)

UNRESOLVED:
- Could not `b4 dig` a local SHA (commit not in this checkout)
- lore.kernel.org and git.kernel.org fetches were blocked; thread
  verified via gnuweeb mirror
- Exact mainline SHA not confirmed locally

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — spec-aligned; Hellwig RB;
   author tested loopback
2. Fixes a real bug that affects users? **PASS** — wrong SUCCESS on a
   real NVMe-oF command
3. Important issue? **PASS** (MEDIUM) — not a kernel oops, but incorrect
   zoned inventory / initiator over-read; “oh, that's not good” for a
   storage protocol
4. Small and contained? **PASS** — one function, ~10 lines
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — pre-image matches 6.12.111
   `zns.c`

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Not a device-ID, quirk, DT, build, or docs exception. It is a normal
small bugfix.

Step 9.4: MAKE YOUR DECISION
This 6.12 tree still has the original PR=0 hole. The fix is tiny,
maintainer-reviewed, and changes only the illegal success path. That is
appropriate for this stable tree.

Verification:
- [Phase 1] Tags: Xixin Liu SOB, Christoph Hellwig Reviewed-by, Keith
  Busch SOB; no Fixes/Reported-by/Cc: stable
- [Phase 1] Body: PR=0 full report must fail when buffer cannot hold
  every matching descriptor (ZNS 1.2 §3.4.2)
- [Phase 2] Diff: one hunk in `nvmet_bdev_zone_zmgmt_recv_work()`; PR=1
  still capped; PR=0 adds `nr_zones > out_nr_zones` →
  `NVME_SC_INVALID_FIELD | NVME_STATUS_DNR`
- [Phase 2] Callback already copies only `out_nr_zones` descriptors
  while counting all matches — verified at
  drivers/nvme/target/zns.c:227-246
- [Phase 3] `git blame`: function from aaf2e048af2704 (2021-06-09)
- [Phase 3] `git merge-base --is-ancestor aaf2e048af2704 HEAD` and `...
  v6.12`: both true
- [Phase 3] No equivalent fix in `git log -- drivers/nvme/target/zns.c`
- [Phase 4] Thread: https://lore-kernel.gnuweeb.org/linux-
  nvme/cover.1783579899.git.liuxixin@kylinos.cn/T/ — v1→v2 style only;
  Hellwig RB; Busch applied to nvme-7.3
- [Phase 4] UNVERIFIED: b4 dig (SHA not in tree); lore.kernel.org HTTP
  403
- [Phase 5] Callers: `nvmet_parse_io_cmd` →
  `nvmet_bdev_zns_parse_io_cmd` → `nvmet_bdev_execute_zone_mgmt_recv`
  (core.c:954-961, zns.c:315-318, 614-615)
- [Phase 5] Linux host uses `c.zmr.pr = NVME_REPORT_ZONE_PARTIAL`
  (host/zns.c:197)
- [Phase 6] `make kernelversion` = 6.12.111; buggy `if
  (req->cmd->zmr.pr)` still present; dry-run pre-image found;
  `NVME_STATUS_DNR` and `numd` exist
- [Phase 7] Built only with `nvmet-$(CONFIG_BLK_DEV_ZONED)`
- [Phase 8] Failure mode: incorrect SUCCESS / truncated full report, not
  a target crash
- UNVERIFIED: whether a later mainline follow-up changed this hunk after
  nvme-7.3 apply

The problem is a spec-incorrect SUCCESS on a full zone report when the
host buffer is too small. That is a real command-handling bug in this
6.12 tree, the patch is small and already matches local code, and the
risk is limited to failing a command that was already returning
inconsistent data.

**YES**

 drivers/nvme/target/zns.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 95af4b67108c7..abf3435ca2900 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -299,11 +299,18 @@ static void nvmet_bdev_zone_zmgmt_recv_work(struct work_struct *w)
 	}
 
 	/*
-	 * When partial bit is set nr_zones must indicate the number of zone
-	 * descriptors actually transferred.
+	 * Partial report (PR bit set): the host accepts an incomplete listing,
+	 * so cap Number of Zones to the descriptors that fit in the buffer.
+	 * Full report (PR bit clear): Number of Zones is the match count; fail
+	 * if the buffer cannot hold every matching zone descriptor.
 	 */
-	if (req->cmd->zmr.pr)
+	if (req->cmd->zmr.pr) {
 		rz_data.nr_zones = min(rz_data.nr_zones, rz_data.out_nr_zones);
+	} else if (rz_data.nr_zones > rz_data.out_nr_zones) {
+		req->error_loc = offsetof(struct nvme_zone_mgmt_recv_cmd, numd);
+		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
+		goto out;
+	}
 
 	nr_zones = cpu_to_le64(rz_data.nr_zones);
 	status = nvmet_copy_to_sgl(req, 0, &nr_zones, sizeof(nr_zones));
-- 
2.53.0

