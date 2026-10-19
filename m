Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB80D352009;
	Mon, 19 Oct 2026 14:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418425; cv=none; b=YvlfY9tH92SZOVskq6GYUJNuDVm1UAoJiYQeBFL+TgJBpIp0XmlKleUh/p4SPmPLFNTsBr9ss4qg4HHgst7ULH2YXZxYqSy0+cTtJOJQsIfcB/UB/9V/mlnSRQZlpOfinoOJ9cXOB4c6qyNBFe54SRQqb5gaaszu/kmD2qKNs/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418425; c=relaxed/simple;
	bh=6PwSBrS2ZGfT06hFAOJC6dWaXblSkBfSl5CfCBq/Ec0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gyVZwV9Sb14cwaYRKp/Sofzbl1eia7IW4wWUAktTJHZaaL0aeQ2jjfoMGh2tOb9vuIaTlktqqtZ857lnRVllCYfAFAAPrCFUbiXbR7+l/CM6S9hcUOddmcggQXGwzwBWlhTbVo/hcPpu2p2IGqWVMr35LTtIQYcwc8QDiXQF8Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dlvTZ10o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dlvTZ10o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016821F000C4;
	Mon, 19 Oct 2026 14:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418422;
	bh=a/KgmAAZ3k/Z5sTWmZqE+o4FWT0QypiHnRzefYdkXpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlvTZ10of5mqT7vWgBNJX2DZWrRI/SDJ0T4srfEt/0ZsJZLkAiyVlL5ZzsXOrs5zb
	 Gq62nSE+6cPyitOVDbX7fh/f1G+FCiYvV/FzP0qa0PirkBl74WrcwCm1J9Nqqfpk1k
	 ebNezwscN61pmQFAjZ6g6uzmfN21NFGufezyiu8oPUHArt3X1ic/cR+K7RKJH3lM5W
	 WGYyX+0tthyOENa8Fq1U2con0rW2zQUVtSt8peImxmwHk9xojb9E7RF6nLDZx+Hws3
	 HdxuomrQk9diiZI7tG1+n7qisGiNcMaG3wcPUjAuCCLfF1M/MgBJfzK/UynayM46rT
	 zY8qvWT5WTxsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Senjin <senjin@hatchling.org>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] fs/ntfs3: load ATTR_BITMAP run extents from $MFT extension records
Date: Mon, 19 Oct 2026 09:48:49 -0400
Message-ID: <20261019135441.1420968-238-sashal@kernel.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit e31886cb6e0e14cf65e27da0bf1a422ff419d893 ]

When $MFT's ATTR_BITMAP attribute is heavily fragmented, its run list
can span multiple MFT extension records (attribute list entries with
vcn > 0). The non-primary segment handler in ntfs_read_mft() only
processed ATTR_DATA extension segments for MFT_REC_MFT, silently
skipping any ATTR_BITMAP segments. This left sbi->mft.bitmap.run
incomplete, causing wnd_init() to fail with -ENOENT when wnd_rescan()
tried to look up a VCN not covered by the truncated run list.

Observed on a 16 TB NTFS volume (0xFFFFFEFF total clusters) whose MFT
bitmap run list was split across 97 extents in extension records.
wnd_rescan() successfully looked up VCNs 0-122 from the runs loaded
from the base record, then failed at VCN 123 (the last cluster of the
bitmap) whose run was only present in an extension record.

Fix by extending the MFT_REC_MFT special case to also handle
ATTR_BITMAP extension segments, storing their runs into
sbi->mft.bitmap.run the same way the primary segment does.

Signed-off-by: Senjin <senjin@hatchling.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to judge this: a real NTFS3 mount failure, a small first-
pass run-list fix, and a related later `super.c` workaround already in
this 7.3 tree. Writing the full 9-phase analysis next.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[fs/ntfs3] [load] load ATTR_BITMAP run extents from $MFT
extension records**

The verb is “load”, not “fix”, but the body describes a mount failure
and a missing code path. Intent is a bug fix.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Commit: `e31886cb6e0e14cf65e27da0bf1a422ff419d893`

Tags present:
- `Signed-off-by: Senjin <senjin@hatchling.org>` (author of the fix)
- `Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-
  software.com>` (ntfs3 maintainer)

Tags absent (expected for this pipeline): `Fixes:`, `Cc: stable`,
`Reported-by`, `Tested-by`, `Reviewed-by`, `Acked-by`, `Link:`.

AuthorDate: 2026-07-02; CommitDate: 2026-07-24 (maintainer applied it).

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** When `$MFT`’s `ATTR_BITMAP` is heavily fragmented, its run
  list spans MFT extension records (`le->vcn > 0`). `ntfs_read_mft()`
  only unpacked `ATTR_DATA` extension segments for `MFT_REC_MFT` and
  skipped `ATTR_BITMAP` segments.
- **Symptom:** `sbi->mft.bitmap.run` is truncated. `wnd_init()` →
  `wnd_rescan()` → `run_lookup_entry()` returns `-ENOENT`. Mount fails.
- **Evidence:** 16 TB volume (`0xFFFFFEFF` clusters). Bitmap run list
  split across 97 extents. VCNs 0–122 found from the base record; VCN
  123 (last bitmap cluster) only in an extension record.
- **Root cause:** Non-primary segment handler too narrow (`ino !=
  MFT_REC_MFT || attr->type != ATTR_DATA`).
- **Fix:** Same special case also unpacks `ATTR_BITMAP` into
  `sbi->mft.bitmap.run`.
- **Versions:** None named in the message. Observation used
  `CONFIG_NTFS3_64BIT_CLUSTER=y` (from the v2 cover letter).

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. Explicit mount-failure fix; “load” is
the mechanism.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `fs/ntfs3/inode.c` — **+8 / −2** (net +6)
- Function: `ntfs_read_mft()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Before (parent `e31886cb6e0e1^`):

```c
if (le && le->vcn) {
    /* non-primary segment */
    if (ino != MFT_REC_MFT || attr->type != ATTR_DATA)
        goto next_attr;
    run = &ni->file.run;
    ...
    goto attr_unpack_run;
}
```

After:

```c
if (le && le->vcn) {
    if (ino != MFT_REC_MFT)
        goto next_attr;
    if (attr->type == ATTR_DATA)
        run = &ni->file.run;
    else if (attr->type == ATTR_BITMAP)
        run = &sbi->mft.bitmap.run;
    else
        goto next_attr;
    ...
    goto attr_unpack_run;
}
```

Record: Non-primary `$MFT` `ATTR_BITMAP` segments now take the same
`attr_unpack_run` path the primary `ATTR_BITMAP` case already uses (`run
= &sbi->mft.bitmap.run` around inode.c:323–333). Other inodes and other
attribute types still skip non-primary segments.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Logic / correctness]** Incomplete run-list construction.
Missing handling of `$MFT` `ATTR_BITMAP` extension segments left
`sbi->mft.bitmap.run` short, so `wnd_rescan()` failed with `-ENOENT` at
an uncovered VCN.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: it mirrors the existing `ATTR_DATA` special case
  and the primary `ATTR_BITMAP` assignment.
- Minimal: one condition split, one extra branch.
- Regression risk: low. `run_add_entry()` allows overlapping runs, so a
  later second unpack is safe.
- No API / locking / data-structure change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record: Buggy test `if (ino != MFT_REC_MFT || attr->type != ATTR_DATA)`
comes from **`82cae269cfa953`** (“fs/ntfs3: Add initialization of super
block”, 2021-08-13) — original ntfs3 merge. Present since **v5.15**.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Introducer is `82cae269cfa953`, ancestor of
HEAD (`git merge-base --is-ancestor` exit 0).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Related commit already in this tree:

**`6d979b64287fb`** — `ntfs3: fix mount failure on volumes with
fragmented MFT bitmap` (2026-04-07, contained in **v7.1-rc1**).

That patch:
1. Moves `ni_load_all_mi()` before `wnd_init()`.
2. Walks attributes and `run_unpack_ex()`s `$BITMAP` extents with `svcn
   != 0`.

Same symptom (`wnd_init` / `-ENOENT`), different site (`super.c` second
pass vs `inode.c` first pass). `6d979b64287fb` is an ancestor of
`e31886cb6e0e1`.

Series context: mailing-list **v2 1/2**. Patch 2/2 is `789af83e41aef`
(`lseek EINVAL` on 64-bit clusters) — independent, not a prerequisite.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Applied by **Konstantin Komarov**, listed `M:` for NTFS3
(`MAINTAINERS`: Supported). Senjin also authored the sibling lseek fix.
Maintainer SOB is a strong quality signal.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Standalone. Uses existing `attr_unpack_run`,
`sbi->mft.bitmap.run`, and the `MFT_REC_MFT` special case from 2021. No
new helpers. Patch 2/2 is unrelated.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c e31886cb6e0e1` **failed**: lore.kernel.org returned errors.
- Found via web search:
  - v1: 2026-06-10, `[PATCH] fs/ntfs3: load ATTR_BITMAP run extents...`
  - v2: 2026-06-13, `[PATCH v2 1/2]` — **hunk-header fix only, no code
    change**
  - Cover: `[PATCH v2 0/2] fs/ntfs3: two fixes for large NTFS volumes`
  - Openwall: https://lists.openwall.net/linux-kernel/2026/06/13/668 and
    `/669`
- No NAKs found. Maintainer merged it into `ntfs3_for_7.3`.
- Cover letter: both bugs seen on a 16 TB volume with
  `CONFIG_NTFS3_64BIT_CLUSTER=y`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: `b4 dig -w` failed. Recipients from the archived mail:
`ntfs3@lists.linux.dev`, `almaz.alexandrovich@paragon-software.com`,
`linux-kernel@vger.kernel.org`. Maintainer was CC’d and later signed
off. No other `Reviewed-by` on the commit.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: Reporter is Senjin (author), with a concrete 16 TB / 97-extent
case. No syzbot/bugzilla. Cover does not mention `6d979b64287fb`, so
Senjin likely reproduced on a kernel without that later-pass workaround
(UNVERIFIED which exact release they ran).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: v2 0/2 is two independent large-volume fixes. 2/2 is not
required for 1/2.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search did not return discussion of this
commit (403/irrelevant hits). No documented reason to keep it out of
stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `ntfs_read_mft()`; uses `ni_enum_attr_ex()`, `attr_unpack_run` →
`run_unpack_ex()`. Failure path: `wnd_init()` → `wnd_rescan()` →
`run_lookup_entry()`.

**Step 5.2: TRACE CALLERS**

Record:
- `ntfs_read_mft()` is static; only caller is `ntfs_iget5()` when
  `I_NEW`.
- Mount: `ntfs_fill_super()` → `ntfs_iget5($MFT)` → `ntfs_read_mft()`.
- Not IRQ; mount/iget path.

**Step 5.3: TRACE CALLEES**

Record: `ni_enum_attr_ex()` loads ATTR_LIST records via `ni_load_mi()`.
Matching segments go to `run_unpack_ex()` into `sbi->mft.bitmap.run`.
Later `wnd_init(&sbi->mft.bitmap)` scans that run list.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: `mount -t ntfs3` → `ntfs_fill_super` → load `$MFT` → incomplete
bitmap runs → `wnd_init` fails → mount fails. **Userspace-reachable.**
Unprivileged users cannot trigger it without mount rights; operators
with NTFS volumes can. Volume is unusable until remounted with another
driver.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Primary `ATTR_BITMAP` already sets `run = &sbi->mft.bitmap.run`.
`6d979b64287fb` unpacks the same extents later in `ntfs_fill_super()`.
`run_add_entry()` documents that new runs may overlap existing ones, so
both paths together are safe.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: **`v7.3-rc4-27-gf0100363d8c37`**, `make kernelversion` =
  **7.3.0-rc4** (mainline-style checkout, detached HEAD).
- Candidate **is already an ancestor of HEAD**.
- Buggy skip has existed since `82cae269cfa953` (v5.15). Parent of this
  commit still has it.
- `6d979b64287fb` (v7.1-rc1) is also in this tree and tries to paper
  over the same gap in `super.c`.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Expected apply: **clean** on any tree with the original
`MFT_REC_MFT`/`ATTR_DATA` special case (all ntfs3 trees since 5.15).
Hunk is isolated.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: `6d979b64287fb` is here. It is a second-pass unpack after
`ni_load_all_mi()`, not a replacement for loading during
`ntfs_read_mft()`. No later commit reverts or replaces `e31886cb6e0e1`.
ADS/iomap commits after it do not touch this branch.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **fs/ntfs3** — **IMPORTANT** (supported RW Windows filesystem,
not staging). Not core VFS/mm, but mount failure is serious for dual-
boot, NAS, and large Windows volumes.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively maintained (Paragon tree, multiple 7.x ntfs3 pulls).
This is a targeted correctness fix, not drive-by churn.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Filesystem-specific / config-specific.** Users of
`CONFIG_NTFS3_FS` with a fragmented `$MFT` `$BITMAP` (large or long-
lived NTFS). The 16 TB report also used `CONFIG_NTFS3_64BIT_CLUSTER`.
Fragmentation itself is not limited to 64-bit clusters; `6d979b64287fb`
reproduced on a 664 GB volume.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Every mount of an affected volume. Not a race. Needs mount
capability, not an unprivileged syscall gadget. Common on large/aged
NTFS.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **Mount failure (`-ENOENT`)** — volume cannot be mounted with
ntfs3. **HIGH** (not a panic, but the filesystem is unusable).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** High for affected volumes (mount works). Completes the
  `$MFT` parse the same way `ATTR_DATA` was always handled. Helps trees
  that lack `6d979b64287fb`; on trees that have it, it is still the
  right first-pass fix and is overlap-safe.
- **Risk:** Very low (6 lines in one function, existing unpack helper).
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real mount failure, observed on a 16 TB volume (97 extents; fail at
  last VCN).
- Independent 664 GB report of the same class (`6d979b64287fb`).
- Bug in ntfs3 since v5.15.
- 8-line, obviously correct extension of an existing special case.
- Maintainer SOB; merged to `ntfs3_for_7.3`.
- Standalone (series 2/2 is unrelated).
- `run_add_entry()` allows overlap with the v7.1 second-pass unpack.

**AGAINST:**
- `6d979b64287fb` already in **this** 7.3 tree may already make mount
  succeed via a later unpack.
- No `Fixes:`/`Cc: stable` (not a negative in this pipeline).
- Affects ntfs3 only, not all kernel users.

**UNRESOLVED:**
- Whether Senjin’s 16 TB kernel included `6d979b64287fb` (cover letter
  never mentions it).
- lore.kernel.org was unreachable for `b4 dig` / WebFetch; discussion
  recovered from Openwall/LKML mirrors.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — mirrors `ATTR_DATA`; tested
   on a real 16 TB volume; maintainer applied it.
2. Fixes a real bug that affects users? **PASS** — mount `-ENOENT` on
   fragmented `$MFT` bitmap.
3. Important issue? **PASS** — filesystem unmountable (HIGH).
4. Small and contained? **PASS** — +8/−2, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — code and helpers are present;
   hunk matches `ntfs_read_mft()`.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: None of the ID/quirk/DT/build/doc exceptions. It qualifies as a
normal important bug fix.

**Step 9.4: DECISION**

This checkout is 7.3-rc4 and already contains the commit; the question
is still whether that fix is stable material for this lineage. It is.

`6d979b64287fb` is a later-pass workaround, not a reason to drop the
first-pass unpack. Silently skipping `$MFT` `ATTR_BITMAP` extents in
`ntfs_read_mft()` is a real bug. The patch is small, correct,
maintainer-acked, and prevents a user-visible mount failure on
large/fragmented NTFS volumes.

---

### What the commit solves

`$MFT`’s bitmap run list can spill into extension records.
`ntfs_read_mft()` unpacked only `ATTR_DATA` there, so
`sbi->mft.bitmap.run` was truncated and `wnd_init()` failed with
`-ENOENT`. Mount failed. The patch stores those bitmap extents the same
way the primary segment already does.

### Stable rules

Meets all six criteria: small, obviously correct, real important bug, no
new API, applies here.

### Risk vs benefit

Benefit: restores mount on affected NTFS volumes. Risk: very low;
overlap with `6d979b64287fb` is handled by `run_add_entry()`.

### Concerns

- Series 1/2: 2/2 is an unrelated lseek fix; not required.
- `6d979b64287fb` already in this 7.3 tree: complementary, not a
  blocker.
- No extra prerequisites beyond original ntfs3 `MFT_REC_MFT` handling
  (v5.15).

---

## Verification

- **[Phase 1]** Parsed `e31886cb6e0e1`: Senjin + Konstantin SOBs only;
  no Fixes/stable/Reported-by.
- **[Phase 2]** `git show e31886cb6e0e1`: +8/−2 in `ntfs_read_mft()`;
  `ATTR_BITMAP` → `sbi->mft.bitmap.run`.
- **[Phase 2]** Read `inode.c` ATTR_BITMAP primary case (lines 323–333)
  and `attr_unpack_run` (399–414).
- **[Phase 2]** Read `wnd_rescan()`: missing run → `err = -ENOENT`.
- **[Phase 3]** `git blame` on parent: buggy line from `82cae269cfa953`
  (2021-08-13).
- **[Phase 3]** `git merge-base --is-ancestor 82cae269cfa953 HEAD` →
  yes.
- **[Phase 3]** Related fix `6d979b64287fb` in tree (`v7.1-rc1~76^2~6`);
  ancestor of this commit.
- **[Phase 3]** `git log --author=Konstantin Komarov -- fs/ntfs3/`:
  maintainer.
- **[Phase 4]** `b4 dig -c e31886cb6e0e1`: lore error; UNVERIFIED via
  b4.
- **[Phase 4]** Openwall v2 0/2 and 1/2: 16 TB repro; v2 is hunk-header
  only; 2/2 independent.
- **[Phase 4]** WebFetch spinics/lore: 500/403; used Openwall/LKML
  mirrors.
- **[Phase 4]** No stable@ discussion found.
- **[Phase 5]** Only caller of `ntfs_read_mft`: `ntfs_iget5`
  (mount/`I_NEW`).
- **[Phase 5]** `run_add_entry()` documents overlap is allowed.
- **[Phase 6]** `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` = 7.3.0-rc4.
- **[Phase 6]** Candidate is ancestor of HEAD; parent still has the
  skip.
- **[Phase 7]** `MAINTAINERS`: NTFS3 Supported, M: Konstantin Komarov.
- **[Phase 8]** Failure mode: mount `-ENOENT`, severity HIGH.
- **UNVERIFIED:** Exact kernel Senjin reproduced on; whether
  `6d979b64287fb` alone would have mounted that 16 TB volume.

The local tree has the ntfs3 code path, the bug dates to the original
driver, the patch is a small contained mount fix, and it should be
backported.

**YES**

 fs/ntfs3/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 120691bc71ee9..99fdba7b403cb 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -126,10 +126,16 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 
 	if (le && le->vcn) {
 		/* This is non primary attribute segment. Ignore if not MFT. */
-		if (ino != MFT_REC_MFT || attr->type != ATTR_DATA)
+		if (ino != MFT_REC_MFT)
+			goto next_attr;
+
+		if (attr->type == ATTR_DATA)
+			run = &ni->file.run;
+		else if (attr->type == ATTR_BITMAP)
+			run = &sbi->mft.bitmap.run;
+		else
 			goto next_attr;
 
-		run = &ni->file.run;
 		asize = le32_to_cpu(attr->size);
 		goto attr_unpack_run;
 	}
-- 
2.53.0

