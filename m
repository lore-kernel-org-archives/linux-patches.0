Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28ABA50E59B;
	Mon, 19 Oct 2026 13:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418204; cv=none; b=i6c6RU9NgHjf/Te0i22Bj92Rajj1ytf76QMQDb/iJl8DpY8CsQZe0AhSz9jFrhjJK/dKRHTbezZK+paNPlMEbPl4TR33pwBGEAjxgUFkxB9KuMnDhVrzbirF9AMTP4wCGwTG7Ec4bCbWyoMWn06eCc9FxjV/Z5c6JnsB+gXLUts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418204; c=relaxed/simple;
	bh=FUC4+ktDq9/olCbQLnWP9lsQxuowCI9V8p4DeN3m4C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wwzm7NvuTq82xl4ScrlWrl5Mkl001dVp0Sh7NB/Bivswl1KVsG8JOvtyO4GR6ALCnlCIjKYlcoXxzkq4cEbC1FO9lRMubwoqTXw5NoX2sF+ZjAnfCNbxpzDAqKD6pTLkC4Ev0KqdH6jTPv+HXR3c9ais/AI+6HJ/24N44GbcR4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LnkibqHS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnkibqHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B341F000C7;
	Mon, 19 Oct 2026 13:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418202;
	bh=lNWFS/3scIX+7MJSnEHstb3kLAcYL3/eoyYtqGJwCB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnkibqHS87my1ieBNzpo6zpnmLnT0fMpVNqdEL6yEwwnSFEBazKkXwxiyVPzIC9pV
	 f6DQnlQo1dnbIeRm8Qk8JtDSwIG0KXsbZYo1+bU6pVES/vzs8Q6gMlaLK1ula5cXZY
	 YIqlmtQsCn/GTx6FSmVCqCi2h+oQHT0sb2ogLpVVRcLn0Koqi9p8kMdD5ReczoTGVA
	 gz0mUctmw7gQPoqZxD9jEooYiJK9g+EHsnvzLy1aq5ky9HwtvKPQi48Ni/AoukgO8N
	 EXhftPku4kw7/pM9hV7H9wTRh1XGF0MiZKvz9ggOXd3NO+7me3ZXDa6P3+oxORKeqS
	 zy7DwNml0Odkg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hari Mishal <harimishal1@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	axboe@kernel.dk,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] nvme: bound ns descriptor header and body to identify buffer
Date: Mon, 19 Oct 2026 09:46:15 -0400
Message-ID: <20261019135441.1420968-84-sashal@kernel.org>
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

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit 3c568b35a0d309acb40746552bec2af24cd550ef ]

nvme_identify_ns_descs() allocates a buffer and gives it to the
controller, which populates it and then iterates the buffer with
variable byte increments that vary by type and body size.  But, there is
no bounds check inside the iteration itself except the loop bound
itself.  Fix this by checking and stopping iteration if the next header
or its declared body would go past the buffer itself.

Assisted-by: gkh_clanker_t1000
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[nvme]** **[bound]** bound namespace descriptor header and
body to the Identify buffer so iteration cannot walk off the end.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Assisted-by:** gkh_clanker_t1000 (LLM-assisted; not a substitute for
  review)
- **Reviewed-by:** Christoph Hellwig \<hch@lst.de\> (NVMe maintainer)
- **Signed-off-by:** Hari Mishal \<harimishal1@gmail.com\> (author)
- **Signed-off-by:** Greg Kroah-Hartman \<gregkh@linuxfoundation.org\>
  (submitted the series)
- **Signed-off-by:** Keith Busch \<kbusch@kernel.org\> (NVMe maintainer;
  applied)
- **No Fixes:** tag (expected for this review pipeline)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / Link / syzbot**
- Ignore pipeline markers: none in the supplied text beyond the usual
  SOBs

Notable: reviewed and applied by the two primary NVMe maintainers.
Submitted as **[PATCH 1/2]** with an unrelated sibling (FDP clamp).

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `nvme_identify_ns_descs()` allocates a 4096-byte Identify
  buffer, lets the controller fill it, then walks variable-length
  namespace ID descriptors. The only guard was `pos <
  NVME_IDENTIFY_DATA_SIZE`.
- **Symptom/failure mode:** out-of-bounds header/body access when a
  descriptor header sits near the end of the buffer, or `nidl` claims a
  body that extends past 4096 bytes. That is a heap OOB read (possible
  crash, KASAN report, or adjacent-heap leak via `memcpy` in
  `nvme_process_ns_desc()`).
- **Version info:** none in the message. The walker has existed since
  2017.
- **Root cause:** device-controlled stride (`sizeof(header) + nidl`)
  with no check that the next header or declared body still fits in the
  allocation.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a disguised cleanup.** It is an explicit bounds-check fix.
The verb “bound” here means “do not read past the buffer.”

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/nvme/host/core.c` — **+4 / −0**
- **Function:** `nvme_identify_ns_descs()`
- **Scope:** single-file surgical fix (two `if` + `break` pairs)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record: **Before:** loop at `pos`, form `cur = data + pos`, read
`cur->nidl` immediately, then call `nvme_process_ns_desc()` which
`memcpy`s the body. **After:** (1) if the 4-byte header would pass the
buffer, stop; (2) if `nidl == 0`, stop (unchanged); (3) if header+body
would pass the buffer, stop; then process. Still an Identify/scan path,
not an error-recovery rewrite. Stopping with `break` matches existing
`nidl == 0` / `len < 0` handling (no new error code for a truncated
trailing descriptor).

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Memory safety / out-of-bounds]** Device-controlled OOB read.

Mechanism, verified against `struct nvme_ns_id_desc` (`nidt`, `nidl`,
reserved — 4 bytes) and `nvme_process_ns_desc()`:
- If `pos` is 4093–4095, reading the header itself is OOB.
- If the header fits but `nidl` does not leave enough remaining bytes,
  known-type `memcpy` (EUI64/NGUID/UUID/CSI) reads past the
  `kzalloc(4096)` buffer after the length-equals-expected check.

The fix stops before those accesses. Header check is first, so
`cur->nidl` is only read when the header is in-bounds.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: **Obviously correct and minimal.** Check order is right. `nidl`
is `__u8` (max 255); `pos` is non-negative and `< 4096`; `pos + 4 +
nidl` cannot overflow a 32-bit `int`. On spec-compliant lists that fit
in 4096 bytes the new branches never fire. **Regression risk: very
low.** Truncating a malformed last descriptor is safer than reading past
the buffer. If CSI is truncated on a multi-CSS controller, the existing
`!csi_seen` path can still return `-EINVAL` — that is the conservative
failure.

No API, locking, or data-structure change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: Loop introduced by **`3b22ba2682b432`** (“nvme: get list of
namespace descriptors”, Johannes Thumshirn, 2017-06-15) — first
contained in **v4.13-rc1**. The two bounds checks are
**`3c568b35a0d309`** (this commit, 2026-07-14). The walker has been in-
tree for many years.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Buggy pattern comes from `3b22ba2682b432`,
which is an ancestor of this checkout.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Same-author sibling **`bc7f75eba5001`** — `nvmet: passthru: fix OOB
  reads when parsing ns id descriptor list` (same descriptor-list OOB
  class on the target passthru path). Independent file.
- Series sibling **`29261f8bb4166`** — `nvme: clamp FDP nruhsd...` is a
  different function (`nvme_query_fdp_info`). **This 1/2 does not depend
  on 2/2.**
- Later `core.c` changes (kmalloc_obj, unsigned nsid print,
  scan/SRCU/FDP) do not rewrite this loop. **Standalone.**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Hari Mishal is not an NVMe maintainer; three NVMe commits, all
device-controlled bounds issues. Weight comes from **Christoph Hellwig
Reviewed-by** and **Keith Busch** applying it to nvme-7.3.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **None.** Adds checks in an existing loop.
`nvme_process_ns_desc()`, `NVME_IDENTIFY_DATA_SIZE` (4096), and `struct
nvme_ns_id_desc` already exist here. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **b4 dig:** https://patch.msgid.link/2026070931-stopping-
  cost-239a@gregkh
- **v1 only** (`b4 dig -a`); applied version is that v1
- Thread (mbox): Christoph: “Looks good: Reviewed-by”; Keith: “Thanks,
  series applied to nvme-7.3.”
- **No NAK, no stability concerns, no request for Cc: stable**

WebFetch of lore.kernel.org returned **403**; discussion recovered via
`b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc included **linux-nvme**, **Keith Busch, Jens
Axboe, Christoph Hellwig, Sagi Grimberg** (all NVM EXPRESS DRIVER
maintainers). Appropriate audience.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: **No user/syzbot/bugzilla report.** Found by analysis (Greg’s
clanker + author). Still a real, reachable OOB given a malformed
Identify NS descriptor list.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: **[PATCH 1/2]** / **[PATCH 2/2]** share an author and file but
not code. 1/2 is self-contained. Target passthru fix is a related class,
not a prerequisite.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable WebFetch **403**. **UNVERIFIED** whether
stable@ already discussed this hash. Absence of Cc: stable is expected
here and is not a negative.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: **`nvme_identify_ns_descs()`** modified;
**`nvme_process_ns_desc()`** callee (memcpy of descriptor bodies).

**Step 5.2: TRACE CALLERS**

Record:
- Only caller: `nvme_scan_ns()` in `drivers/nvme/host/core.c`
- `nvme_scan_ns()` ← `nvme_scan_ns_async()` /
  `nvme_scan_ns_sequential()`
- Those ← `nvme_scan_work()` on `ctrl->scan_work`

Context: **process-context workqueue**, NVMe namespace scan on probe,
reset, and NS-changed AEN. Common path for NVMe hosts, not IRQ/hot-
cache.

**Step 5.3: TRACE CALLEES**

Record: `kzalloc` / `nvme_submit_sync_cmd` / `nvme_process_ns_desc` /
`kfree`. The OOB is in the parse loop and in `nvme_process_ns_desc()`
memcpy, not in the admin command itself.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Reachable on any NVMe 1.3+ controller (or multi-CSS) that does
not have `NVME_QUIRK_NO_NS_DESC_LIST`. Userspace does not call this
syscall-direct; a **malicious or buggy controller** (local PCIe or NVMe-
oF target) controls the buffer. That is a standard untrusted-device
memory-safety bug.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same class already bounded in `drivers/nvme/target/passthru.c`
(`pos + sizeof(*cur)` and CSI body). Host-side
`nvme_identify_ns_descs()` was the gap this commit closes.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: **`git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`**,
  **`make kernelversion` = 7.3.0-rc4**
- Function and loop exist at `drivers/nvme/host/core.c`
  (`nvme_identify_ns_descs`)
- Bug introduced **v4.13** (`3b22ba2682b432`), long before this branch
- The two checks are present on HEAD (this commit is an ancestor). That
  is historical fact, **not** used as “already selected for stable”

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** to this `nvme_identify_ns_descs()` shape.
Context is the same 4.13-era loop; no extra helpers required. **Expected
backport difficulty: clean apply** on trees that still have this
function.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No earlier host-side equivalent. Passthru OOB fix is a different
file. No conflicting alternate host fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: **NVMe host core** (`drivers/nvme/host/core.c`). **IMPORTANT** —
common block/storage path, not mm/VFS core, but widely deployed
(servers, laptops, NVMe-oF).

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: Actively maintained (Keith Busch, Christoph Hellwig, et al.).
This is a small correctness fix in old parse code, not a follow-on to a
brand-new feature in 7.3.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: **Driver-specific, but broad:** NVMe hosts scanning namespaces
(almost all NVMe users on 1.3+). Triggered by device Identify data, not
a rare Kconfig.

**Step 8.2: TRIGGER CONDITIONS**

Record: Namespace scan (probe/reset/NS-changed). **Not** every I/O.
Needs a **malformed descriptor list** (buggy firmware or untrusted
target). Unprivileged local users typically cannot inject Identify
payloads without device control; NVMe-oF to an untrusted target can.
Timing-independent; deterministic given bad data.

**Step 8.3: FAILURE MODE SEVERITY**

Record: **Heap out-of-bounds read** → KASAN/oops, possible info leak, or
silent heap corruption adjacent to the Identify buffer. **Severity:
HIGH.** Not a guaranteed panic on production kernels, but it is a real
memory-safety bug in a storage driver.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit: high** — stops device-controlled OOB on a common NVMe scan
  path; 4 lines; maintainers acked.
- **Risk: very low** — two range checks; no lock/API/behavior change for
  valid lists.
- **Ratio: strongly favors backport.**

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real OOB read from controller-controlled Identify NS descriptor list
- Path is namespace scan on ordinary NVMe hosts
- 4-line, obviously correct bounds checks; header checked before `nidl`
- Same bug class already recognized on the passthru parser
- Reviewed-by Christoph Hellwig; applied by Keith Busch
- Code has existed since v4.13; no missing prerequisites in this tree
- No new feature/API

**AGAINST:**
- No Fixes:/Cc: stable/syzbot/user report (not a negative per the rules)
- LLM-assisted origin (offset by maintainer review)
- Trigger needs a bogus/malicious controller, not typical I/O
- Series labeled 1/2 (sibling is independent)

**UNRESOLVED:**
- lore.kernel.org HTTP 403; thread recovered via b4 mbox
- Whether stable@ already discussed this commit: **UNVERIFIED**

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — two range checks; Reviewed-
   by maintainer; applied to nvme-7.3
2. Fixes a real bug that affects users? **PASS** — OOB parse of device
   Identify data
3. Important (crash/security/corruption/deadlock)? **PASS** — HIGH
   memory-safety (OOB read; crash/leak potential)
4. Small and contained? **PASS** — +4 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — same function/context; no
   extra deps

**Step 9.3: EXCEPTION CATEGORIES**

Record: **None** (not an ID/quirk/DT/build/doc exception). It qualifies
as a normal small memory-safety fix.

**Step 9.4: DECISION**

This is a surgical host-side bounds check for a long-standing, device-
controlled OOB in NVMe namespace scanning. It meets stable rules for
this checkout (7.3-rc4; buggy walker present since v4.13). Benefit is
high; regression risk is very low.

---

### What the commit solves (for this tree)

`nvme_identify_ns_descs()` walks a 4096-byte Identify Namespace ID
Descriptor List with a device-chosen stride. Without checking that the
next 4-byte header and `nidl` body fit, a truncated or oversized last
descriptor causes an out-of-bounds header read and/or `memcpy` in
`nvme_process_ns_desc()`. That hits every NVMe scan of a 1.3+ (or multi-
CSS) controller that returns a bad list. The patch stops the loop before
those accesses. Compliant devices are unchanged.

### Risk vs benefit

Four lines of range checks, no locking or ABI change. Worst case on a
truncated list is skipping remaining descriptors (already the `nidl ==
0` policy). Benefit is preventing a heap OOB in a widely used storage
driver.

### Concerns

None that block backport: 1/2 is independent of the FDP 2/2 patch; no
extra commits required; apply is clean against this
`nvme_identify_ns_descs()`.

---

### Verification

- **[Phase 1]** Parsed tags: Reviewed-by Christoph Hellwig; SOB Hari
  Mishal, Greg Kroah-Hartman, Keith Busch; Assisted-by
  gkh_clanker_t1000; no Fixes/Reported-by/Cc:stable/syzbot
- **[Phase 2]** Diff: +4 lines in `nvme_identify_ns_descs()`; two `pos +
  sizeof(*cur)` / `+ cur->nidl` checks vs `NVME_IDENTIFY_DATA_SIZE`
  (4096). Confirmed `struct nvme_ns_id_desc` is 4 bytes; `nidl` is
  `__u8`
- **[Phase 2]** `nvme_process_ns_desc()` memcpy of EUI64/NGUID/UUID/CSI
  only after `nidl` matches expected length — body check is what keeps
  those copies in-buffer
- **[Phase 2]** Integer overflow: max `pos+hdr+nidl` ≈ 4354, no 32-bit
  overflow
- **[Phase 3]** `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- **[Phase 3]** Commit `3c568b35a0d309`; `git merge-base --is-ancestor`
  → ancestor of HEAD
- **[Phase 3]** Blame: loop `3b22ba2682b432` (2017, v4.13-rc1); checks
  from this commit
- **[Phase 3]** Pre-image `git show 3c568b35a0d30^:...` matches the
  supplied diff (no header/body checks)
- **[Phase 3]** Sibling `29261f8bb4166` is `nvme_query_fdp_info()` only
  — not a prereq. Related `bc7f75eba5001` is target passthru
- **[Phase 4]** `b4 dig -c 3c568b35a0d309`: lore/msgid
  2026070931-stopping-cost-239a@gregkh; v1 only; CC linux-nvme + all
  NVMe maintainers
- **[Phase 4]** mbox: Hellwig Reviewed-by; Busch “series applied to
  nvme-7.3”; no NAK
- **[Phase 4]** WebFetch lore.kernel.org / patch.msgid.link / lore
  stable search: **403** — discussion taken from b4 mbox instead
- **[Phase 5]** Only caller `nvme_scan_ns()` → `nvme_scan_work()`
  (probe/reset/NS-changed scan)
- **[Phase 5]** Similar bounds already in
  `drivers/nvme/target/passthru.c`
- **[Phase 6]** Buggy walker exists in this tree’s history since v4.13;
  current file has the checks; apply would be clean
- **[Phase 6]** MAINTAINERS: NVM EXPRESS DRIVER — Busch, Axboe, Hellwig,
  Grimberg
- **[Phase 8]** Failure mode: heap OOB read on malformed Identify NS
  descriptor list; severity HIGH
- **UNVERIFIED:** whether stable@ already discussed this commit (lore
  stable HTTP 403)

**YES**

 drivers/nvme/host/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d5fb6612fa229..5ed62e070f715 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1564,8 +1564,12 @@ static int nvme_identify_ns_descs(struct nvme_ctrl *ctrl,
 	for (pos = 0; pos < NVME_IDENTIFY_DATA_SIZE; pos += len) {
 		struct nvme_ns_id_desc *cur = data + pos;
 
+		if (pos + sizeof(*cur) > NVME_IDENTIFY_DATA_SIZE)
+			break;
 		if (cur->nidl == 0)
 			break;
+		if (pos + sizeof(*cur) + cur->nidl > NVME_IDENTIFY_DATA_SIZE)
+			break;
 
 		len = nvme_process_ns_desc(ctrl, &info->ids, cur, &csi_seen);
 		if (len < 0)
-- 
2.53.0

