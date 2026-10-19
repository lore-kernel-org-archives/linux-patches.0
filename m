Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461994C8472;
	Mon, 19 Oct 2026 13:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418143; cv=none; b=O1YWpfH2JE6cBU/UMDFLX+BQ1hz9mkJEOuh25pAxhWxsMH/i5wTNNOMPuLMDSwwGTMxal8j2FA+k03s8s/lzU2FSdIlR2rDOMHi/ZQTL+qtBmC8iqQsBb+uHMh0VyugRGqk2xjcgLWZVz21W7tp0d41ucNR1JjzM6EXMctPpLm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418143; c=relaxed/simple;
	bh=ZkXaKlUyhiS+fvLIj9i2IUobo1CeYA99D47HxTX72Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dwtrkOfE7CzvG8w9yn+AjPF7rzMZ7KOlL62GOXnIOD5OYrksWQJoQ2ZJoNbXVjiTlO3v2BdH+WdshUaNnTNfF2o4FAhKvTB94iFDOQdki3fPjwSN8mavAWLgx4LJ4z9e1Jj+e9RmjYYkCkSJsRr1LdQPV3t18VM5EInaBiBuVgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YqNpPYpj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YqNpPYpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BDE1F000C7;
	Mon, 19 Oct 2026 13:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418141;
	bh=ypyiSk7m1tN2St+TQ9gw6JLtzzjoLOMXeA2Bwty7kUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqNpPYpj0Z7D95H69wGyZDNyXwZfQqb/XD9tABfjvSXDLL7TgpHRKY3thQn14XU2K
	 a4vN8JK48uTYrkUGPU42H8ywffSTBa0500NBJ9WwyWJzEd354JsYnn5QOBT6c0JaM4
	 iYH1vD0hAwHQF9Vd0qr/oHjyrGKwX+iZ6d7p+ofvXUaWNLhcIV3h1Q6WfykARwsBcZ
	 H1kfksigDOhmD+M6mrAjY23U6rEZInTBs1QkJybFKa+5kog0gv/9ww5vrAX6UQx27l
	 ftw30IGG0lyGQbhO80/Hm5JeciNVD8CccVXvu1TUPajvbUkCXylYdkjmUjk5LdEJdP
	 kgGa3TIW0MNvw==
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
Subject: [PATCH AUTOSEL 6.18] nvme: clamp FDP nruhsd to allocated RUH status descriptor count
Date: Mon, 19 Oct 2026 09:45:32 -0400
Message-ID: <20261019135441.1420968-41-sashal@kernel.org>
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

[ Upstream commit 29261f8bb41662f2a660c479e5cf592942b53f78 ]

nvme_query_fdp_info() allocates the RUH status buffer for at most S8_MAX
- 1 descriptors, and then copies ruhs->ruhsd[] into head->plids[] using
the controller reported ruhs->nruhsd directly as the loop bound.
However, that count wasn't taken into account for the actual buffer's
size, so there was a chance for a controller reporting a larger nruhsd
to cause the copy to overflow the buffer.  Clamp nr_plids to the same
bound used for the allocation.

Assisted-by: gkh_clanker_t1000
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line out-of-bounds-read clamp in NVMe FDP setup. The local
tree is **v7.3-rc4** (`7.3.0-rc4`, HEAD `f0100363d8c37`).
`nvme_query_fdp_info()` exists here; the overflow is real; the change is
surgical.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[nvme]** **[clamp]** clamp FDP `nruhsd` to the allocated RUH
status descriptor count. “Clamp” is a bounds-fix verb.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Reviewed-by:** Christoph Hellwig `<hch@lst.de>`
- **Assisted-by:** gkh_clanker_t1000
- **Signed-off-by:** Hari Mishal (author), Greg Kroah-Hartman
  (submitter), Keith Busch (NVMe maintainer)
- **No Fixes:** tag (expected)
- **No Reported-by / Tested-by / Link / Cc: stable**
- Ignore pipeline SOBs; Greg’s SOB is from the actual submission, not a
  stable-prep marker

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `nvme_query_fdp_info()` allocates a RUH-status buffer for at
  most `S8_MAX - 1` descriptors, then copies `ruhs->ruhsd[]` using
  controller-reported `ruhs->nruhsd` as the loop bound.
- **Symptom:** a controller that reports `nruhsd` larger than the
  allocated descriptor count overflows that buffer on the copy into
  `head->plids[]`.
- **Root cause:** allocation size and copy bound were not the same.
- **Fix:** clamp `nr_plids` to the same bound used for allocation.
- **Version info in message:** none.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. This is an explicit buffer-overflow / OOB-read fix.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/nvme/host/core.c` — 1 insertion, 1 deletion
- **Function:** `nvme_query_fdp_info()`
- **Scope:** single-file, one-line surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before: `head->nr_plids = le16_to_cpu(ruhs->nruhsd);` then
`kcalloc(head->nr_plids, …)` and `for (i = 0; i < head->nr_plids; i++)
head->plids[i] = le16_to_cpu(ruhs->ruhsd[i].pid);`. After: `nr_plids` is
`min(reported, S8_MAX - 1)`, so the copy cannot walk past the allocated
`ruhs` buffer. Path is namespace-head init when the controller
advertises FDP.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **(g) logic/correctness + (d) memory safety — out-of-bounds
read.** `nruhsd` is a `__le16` from the device (0..65535). Allocation
used `struct_size(ruhs, ruhsd, S8_MAX - 1)` (126 descriptors, 4048
bytes). Verified layout in `include/linux/nvme.h`: 16-byte header +
32-byte `nvme_fdp_ruh_status_desc`. If `nruhsd == 65535`, the loop reads
~2MB past the buffer. `plids` is sized from `nr_plids`, so the overflow
is an OOB **read** of `ruhs`, not a write into `plids`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct: clamp matches the allocation bound. Minimal.
Regression risk is low: extra reported placement IDs are dropped instead
of overflowing. Later mainline commit `53cdaeab2e30e` raised that cap to
`U8_MAX` / `NVME_MAX_PLIDS`; that is a follow-up improvement, not a sign
this clamp is wrong.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Allocation `struct_size(..., S8_MAX - 1)` introduced in
  `30b5f20bb2dda` (“nvme: register fdp parameters with the block layer”,
  Keith Busch, 2025-05-06).
- Unclamped `nr_plids` assignment plus the `ruhsd[]` copy loop:
  `38e8397dde633` (“nvme: use fdp streams if write stream is provided”).
- Both first appear in **v6.16-rc1** (`git describe --contains --match
  'v*'`).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Introducing commits identified by blame, not by
tag.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- `29261f8bb4166` — this clamp (candidate)
- `53cdaeab2e30e` — raise cap to `U8_MAX` and introduce `NVME_MAX_PLIDS`
  (depends on the clamp being present)
- `56e1c6bbe4bb0` — race on the plids array (independent locking fix)
- Series partner `3c568b35a0d30` — NS descriptor bounds (different
  function, not a prerequisite)

Standalone. Labeled `[PATCH 2/2]` but 1/2 is an independent bounds check
in `nvme_identify_ns_descs()`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Hari Mishal also authored sibling overflow fixes (`nvme: bound
ns descriptor header…`, `nvmet: passthru: fix OOB reads…`). Submitted
via Greg; merged by NVMe maintainer Keith Busch. Christoph Hellwig
reviewed.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None for the clamp itself. It only needs `nvme_query_fdp_info()`
with `S8_MAX - 1` allocation and the copy loop — present since v6.16. No
new helpers or APIs.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 29261f8bb4166` → https://patch.msgid.link/2026070932-fried-
  frying-9c36@gregkh
- **v1 only** (`b4 dig -a`): `[PATCH 1/2] nvme: bound ns descriptor…` +
  `[PATCH 2/2]` this clamp
- Full thread saved via `b4 dig -m`; lore HTTP fetch returned 403, so
  discussion is from the mbox, not lore HTML
- Christoph: “Looks good: Reviewed-by: Christoph Hellwig”
- Keith Busch: “Thanks, series applied to nvme-7.3.”
- No NAK, no stable discussion in-thread, no reviewer risk flags

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): linux-nvme, linux-kernel, Keith Busch, Jens Axboe,
Christoph Hellwig, Sagi Grimberg. Appropriate maintainers were on Cc.
Christoph reviewed; Keith applied.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla/`Reported-by`. Bug is from code review /
static analysis (Greg/clanker-assisted). Still a concrete OOB from
device-provided `nruhsd`.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 2/2 is independent of 1/2. Follow-up `53cdaeab2e30e` changes the
numeric cap but does not replace the need to clamp. Race fix
`56e1c6bbe4bb0` is separate.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned 403. **UNVERIFIED**
whether stable@ already discussed this. No evidence in the nvme thread
of a stable NAK.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `nvme_query_fdp_info()` only.

**Step 5.2: TRACE CALLERS**
Record: Only caller is `nvme_alloc_ns_head()` in
`drivers/nvme/host/core.c`:

```4043:4047:drivers/nvme/host/core.c
        if (ctrl->ctratt & NVME_CTRL_ATTR_FDPS) {
                ret = nvme_query_fdp_info(ns, info);
                if (ret < 0)
                        goto out_cleanup_srcu;
        }
```

Triggered during namespace-head creation when Identify Controller
`ctratt` has `NVME_CTRL_ATTR_FDPS`. That is probe/scan, not a hot I/O
path, but it runs for every FDP-capable namespace.

**Step 5.3: TRACE CALLEES**
Record: `nvme_get_features()`, `nvme_query_fdp_granularity()`,
`kzalloc`/`kcalloc`, `nvme_submit_sync_cmd()` (device fills `ruhs`),
then the copy loop.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Device probe / namespace scan → `nvme_init_ns_head` →
`nvme_alloc_ns_head` → `nvme_query_fdp_info`. Reachable from attaching
an NVMe device, including NVMe over Fabrics. A malicious or buggy target
can set FDPS and return a huge `nruhsd`. Not a direct unprivileged
syscall, but device/Fabrics-controlled and kernel-reachable.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same author series also bounded NS identify descriptors. Follow-
up kept the clamp and only raised the cap. No second unclamped `nruhsd`
copy found.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes, in this lineage.** This checkout is **v7.3-rc4** (`make
kernelversion` → `7.3.0-rc4`). FDP query exists. Bug introduced
**v6.16-rc1**, before 7.3. Candidate `29261f8bb4166` is already an
ancestor of HEAD (`git merge-base --is-ancestor` succeeded; first
contained in **v7.3-rc1**). Current HEAD already clamps:

```2371:2371:drivers/nvme/host/core.c
        head->nr_plids = min(le16_to_cpu(ruhs->nruhsd), NVME_MAX_PLIDS);
```

That is this fix plus `53cdaeab2e30e` (`NVME_MAX_PLIDS` = `U8_MAX`). The
unclamped assignment is gone at HEAD because the fix landed in 7.3-rc1;
the overflow pattern is still the code this tree maintains.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Against **current HEAD**, the original hunk would not apply
(`S8_MAX - 1` vs `NVME_MAX_PLIDS`). Against the pre-fix function (parent
of `29261f8bb4166` in this history), it is a one-line change on
`head->nr_plids = le16_to_cpu(ruhs->nruhsd)` with matching `S8_MAX - 1`
allocation. **Expected backport difficulty: clean apply** on trees that
still have that allocation; this 7.3 checkout already has the later
form.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This clamp and the `NVME_MAX_PLIDS` follow-up are both in HEAD.
That is this tree already containing the upstream fix, not a different
substitute.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **NVMe host core** (`drivers/nvme/host/`). **IMPORTANT** —
common storage stack, not staging. Overflow is in host core during
namespace setup.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (recent FDP, multipath, scan, SRCU fixes). FDP streams
themselves date to v6.16; this is not brand-new experimental code in
7.3.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / config-specific:** NVMe controllers with FDP
(`NVME_CTRL_ATTR_FDPS` + `FDPCFG_FDPE`). Includes local NVMe and Fabrics
targets that advertise FDP.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Namespace scan/probe on an FDP-enabled controller that returns
`nruhsd >` allocated descriptor count. Not every boot. A buggy SSD can
hit it; an untrusted NVMe/TCP target can hit it on purpose. Unprivileged
local users cannot trigger it without a device.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Kernel out-of-bounds read** of `ruhs->ruhsd[]` → KASAN/oops or
infoleak of adjacent heap. **Severity: HIGH.**

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: **Benefit: high** (stops device-triggered OOB). **Risk: very
low** (one `min()`, same bound as allocation). **Ratio: strongly
favorable.**

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real OOB read from device-controlled `nruhsd` vs a 126-descriptor
  buffer
- One-line, obviously correct clamp
- Reviewed by Christoph Hellwig; applied by Keith Busch
- No new API/feature
- Self-contained; series 1/2 is not required
- FDP path exists in this tree; bug dates to v6.16

**AGAINST:**
- No public user/syzbot report (code-analysis find)
- Only FDP-capable devices
- HEAD already has this clamp (and a later cap raise), so this exact
  hunk is not what HEAD’s source line looks like
- Lore stable@ search could not be fetched (403)

**UNRESOLVED:**
- Whether stable@ already queued it (lore/stable HTTP 403)
- No runtime reproducer in the message (mechanism is still verified in
  code)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — clamp equals allocation
   bound; reviewed and merged to nvme-7.3
2. Fixes a real bug that affects users? **PASS** — OOB read on FDP
   namespace setup
3. Important issue (crash/security/corruption/deadlock)? **PASS** —
   HIGH, kernel OOB from device data
4. Small and contained? **PASS** — 1 line, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** for this codebase’s pre-fix
   form (`S8_MAX - 1` allocation + unclamped `nruhsd`). HEAD already has
   the evolved clamp; that does not make the fix inapplicable to this
   lineage.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device-ID/quirk/DT/build/docs exception). It is a
normal memory-safety fix.

**Step 9.4: MAKE YOUR DECISION**
This tree’s NVMe host core has the FDP RUH-status query, and using the
controller’s `nruhsd` as the copy bound without capping it to the
allocated descriptor count is a real overflow. The fix is the smallest
correct change. This 7.3 checkout already contains that logic (then
raised the cap to `U8_MAX`); that is the upstream landing, not a reason
to treat the overflow as unworthy of stable. Benefit vs risk is strongly
in favor of backporting.

### What the commit solves, and why it matters
A Flexible Data Placement controller returns how many Reclaim Unit
Handle status descriptors it has (`nruhsd`). The driver only allocated
room for 126, then indexed `ruhs->ruhsd[i]` up to the raw reported
count. That is a kernel heap OOB read during namespace setup, including
from a remote NVMe/TCP target.

### Stable rules
Small, obviously correct, no new API, real memory-safety bug.

### Risk vs benefit
One `min()` vs device-triggered OOB: take the fix.

### Concerns
Patch 2/2 does not need patch 1/2. Trees that already switched
allocation to `NVME_MAX_PLIDS` should keep clamp and allocation in sync
(already true here via `53cdaeab2e30e`). Trees still on `S8_MAX - 1`
should get this commit as-is.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Christoph Hellwig; SOBs Hari
  Mishal, Greg KH, Keith Busch; no Fixes/Reported-by/Cc stable
- [Phase 2] Diff: 1 line in `nvme_query_fdp_info()`;
  `le16_to_cpu(ruhs->nruhsd)` → `min(..., S8_MAX - 1)`
- [Phase 2] Struct sizes verified in `include/linux/nvme.h`: 16-byte
  header + 32-byte descriptors; 126 descriptors → 4048-byte buffer;
  `nruhsd` up to 65535
- [Phase 3] Blame: allocation `30b5f20bb2dda`, copy loop
  `38e8397dde633`; both `git describe --contains --match 'v*'` →
  v6.16-rc1
- [Phase 3] `git merge-base --is-ancestor 29261f8bb4166 HEAD` → commit
  is in this tree; `describe --contains` → v7.3-rc1
- [Phase 3] Parent of candidate still has `size = struct_size(ruhs,
  ruhsd, S8_MAX - 1)` and unclamped `nr_plids`
- [Phase 4] `b4 dig -c` → msgid 2026070932-fried-frying-9c36@gregkh;
  `-a` v1 only; `-w` nvme maintainers; `-m` full thread
- [Phase 4] mbox: Christoph R-b; Keith “applied to nvme-7.3”; no NAK
- [Phase 4] lore.kernel.org and patch.msgid.link HTTP 403; LKML mirrors
  agree with mbox
- [Phase 5] grep callers: only `nvme_alloc_ns_head()` when
  `NVME_CTRL_ATTR_FDPS`
- [Phase 6] `git describe HEAD` / `make kernelversion`: v7.3-rc4 /
  7.3.0-rc4; current clamp is `min(..., NVME_MAX_PLIDS)` from
  `53cdaeab2e30e`
- [Phase 8] Failure mode: OOB read of `ruhs->ruhsd[]`, severity HIGH
- UNVERIFIED: stable@ mailing-list history (HTTP 403); no runtime
  reproducer in the commit message

**YES**

 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5ed62e070f715..ad725e346c94e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2313,7 +2313,7 @@ static int nvme_query_fdp_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 		goto free;
 	}
 
-	head->nr_plids = le16_to_cpu(ruhs->nruhsd);
+	head->nr_plids = min(le16_to_cpu(ruhs->nruhsd), S8_MAX - 1);
 	if (!head->nr_plids)
 		goto free;
 
-- 
2.53.0

