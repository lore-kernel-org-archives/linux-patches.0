Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84A25166C1;
	Mon, 19 Oct 2026 13:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418235; cv=none; b=eGyDH/yaa3XbCsMWAxRfb8M3LCzZ2qVrzU909KoVml/e8+uP1UIjJZAs5YSwztFl66V/udS8vP9imtrw8xR6WdyRvkN814cMTgysHAo8eP7V7rXPQ0gylolI9JOUhGVjuiwelbVrAsXbyvZIWfiImDqX5TUaCsVVL4Sm01j0gSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418235; c=relaxed/simple;
	bh=lbMmLm9G5YM72FqoghLJ0G+lr0vi9UdNq3CXCwb0O+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T6o/4mLHRqOeMiBGu+iYFGU+BGliVghUAnBCJ33KvHlxOXNfqxmTbfkgbmaDhsJ2eBO6m8Pqah2bRcTlVRo8c6rur981FXoFBQ8bzjSzAoiURpyCOcQ92t5Epf1hO4tU6Y1n9XoPX1hGZxW7AzhEbzboEP0BIlrd3CRc7faBP/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aNwhine3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aNwhine3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6751F000C8;
	Mon, 19 Oct 2026 13:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418232;
	bh=TPOZYxFE3P5IBWQB1G3Ayw3DKPbFfiq02jE58DxcHus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNwhine3pS999mmkZZPqV5HdhmHRukmVChhZRgf7/pcctcEjXPGEfCzlOXkFV0l11
	 enuJeTW7JQZmGS7Tlo/UgnBtbxnkMwchncF+PvECB5HyABBC1lKa5JiHic4lI9bbRd
	 ++Kr3zk1eIxSfJF0CpggR92zu4xo8rb5MH/4NdNNc6Z/tgd3VUWb7VlZpanzlfkw/p
	 AbqOS7CiRDISXJ/JghEtMB/158LnEKF1FyvVUEASRyM72Tt7q61iXtvYOmR25WCaKq
	 ZqsO3ZoMI/41atcrq34kiv4mcI+oJwtt2MQdSZQClo/vs2Ht5faR+7pHJvRlb4FuZy
	 cxEW4ba+xPjbA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jay Vadayath <jay@artiphishell.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>,
	jack@suse.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] udf: bound lengthAllocDescs from unallocated space entry
Date: Mon, 19 Oct 2026 09:46:37 -0400
Message-ID: <20261019135441.1420968-106-sashal@kernel.org>
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

From: Jay Vadayath <jay@artiphishell.com>

[ Upstream commit b8228f59dc58aea06dc024efd8f64c2d048c4578 ]

udf_read_inode() copies the on-disk lengthAllocDescs field of a USE
(unallocSpaceEntry) inode into iinfo->i_lenAlloc without checking that
it fits in the i_data buffer that is subsequently allocated for the
inode. udf_count_free_table(), called from udf_statfs(), then walks the
allocation descriptor array up to i_lenAlloc bytes, so a crafted UDF
image with lengthAllocDescs larger than (blocksize - sizeof(struct
unallocSpaceEntry)) causes udf_get_fileshortad() to read past the end
of the kmalloc'd i_data buffer.

KASAN report from mounting a crafted UDF image and calling statfs()
from an unprivileged process:

  BUG: KASAN: slab-out-of-bounds in udf_get_fileshortad+0x126/0x130
  Read of size 4 at addr ffff8880042137d8 by task poc/65
  Call Trace:
   dump_stack_lvl+0x53/0x70
   print_report+0xce/0x610
   kasan_report+0xce/0x100
   udf_get_fileshortad+0x126/0x130
   udf_current_aext+0x3c4/0xa10
   udf_next_aext+0x241/0x440
   udf_statfs+0xb7d/0x11c0
   statfs_by_dentry+0x117/0x1e0
   user_statfs+0xac/0x130
   __do_sys_statfs+0x80/0xe0
   do_syscall_64+0x102/0x5a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reject USE inodes whose lengthAllocDescs would place descriptors past
the end of the i_data buffer, mirroring the checks the rest of the UDF
code performs on descriptor lengths.

This bug was discovered by Artiphishell's vTriage pipeline, which
generated a userspace reproducer that reliably triggers the KASAN
report on an unpatched kernel. The fix below was drafted with the
Claude coding assistant; a userspace reproducer (and the crafted UDF
image) is available on request.

Assisted-by: LLM
Signed-off-by: Jay Vadayath <jay@artiphishell.com>
Link: https://patch.msgid.link/20260717184021.13476-1-jay@artiphishell.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a four-line UDF bounds check for a
KASAN out-of-bounds read on crafted images, and it applies to this tree.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[udf]** **[bound]** bound `lengthAllocDescs` from an
unallocated space entry (USE) inode so descriptor walking cannot run
past the `i_data` buffer.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Assisted-by:** LLM (drafted with Claude)
- **Signed-off-by:** Jay Vadayath \<jay@artiphishell.com\> (author)
- **Link:**
  https://patch.msgid.link/20260717184021.13476-1-jay@artiphishell.com
- **Signed-off-by:** Jan Kara \<jack@suse.cz\> (UDF maintainer; applied
  the patch)
- **No Fixes:** tag (expected for this review)
- **No Cc: stable** (expected; absence is not a negative)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by**
- Ignored: any pipeline “already selected” markers (none on the real
  commit)

Notable: no syzbot tag, but a concrete KASAN stack and a userspace
reproducer are in the body. A later independent patch (Baul Lee, Cc:
stable) reports the same bug.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `udf_read_inode()` copies on-disk `lengthAllocDescs` from a
  USE inode into `iinfo->i_lenAlloc` with no check that it fits in the
  later `i_data` allocation (`bs - sizeof(struct unallocSpaceEntry)`).
- **Symptom:** KASAN slab-out-of-bounds read in `udf_get_fileshortad()`
  after mount + `statfs()`.
- **Failure path:** `statfs` → `udf_statfs` → `udf_count_free_table` →
  `udf_next_aext` → `udf_current_aext` → `udf_get_fileshortad`.
- **Trigger:** crafted UDF image; `statfs()` from an unprivileged
  process after the image is mounted.
- **Root cause:** USE branch returns before the FE/EFE
  `lengthAllocDescs` sanity checks.
- **Fix:** reject USE inodes whose `lengthAllocDescs` would extend past
  `i_data`.
- **Version info:** none in the message; the USE path dates to ~2008.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. Explicit KASAN OOB fix with a
reproducer.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `fs/udf/inode.c` — **+4 / −0**
- **Function:** `udf_read_inode()`
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record (USE branch in `udf_read_inode`):
- **Before:** set `i_lenAlloc` from on-disk `lengthAllocDescs`, allocate
  `i_data` of size `bs - sizeof(struct unallocSpaceEntry)`, memcpy that
  many bytes, return 0. Oversized `lengthAllocDescs` is trusted.
- **After:** if `i_lenAlloc > bs - sizeof(struct unallocSpaceEntry)`,
  return `-EFSCORRUPTED` via `out:` (which `brelse`s `bh`). Check is
  **before** `udf_alloc_i_data()`, so no `i_data` leak on the new error
  path.
- **Path:** mount-time inode load for USE (unalloc space table), not a
  hot write path.

Verified pre-fix code at `b8228f59dc58a^`:

```
iinfo->i_lenAlloc = le32_to_cpu(... lengthAllocDescs);
ret = udf_alloc_i_data(inode, bs - sizeof(struct unallocSpaceEntry));
```

No bound check. FE/EFE checks at lines 1588–1592 are after this early
`return 0`, so USE never hit them.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Memory safety — out-of-bounds read** of on-disk length.

Mechanism (verified in this tree):
1. `udf_count_free_table()` starts `epos.offset = sizeof(struct
   unallocSpaceEntry)`, `epos.bh = NULL`.
2. `udf_current_aext()` (in-ICB) sets `alen =
   udf_file_entry_alloc_offset(inode) + iinfo->i_lenAlloc`. For USE,
   offset is `sizeof(struct unallocSpaceEntry)`.
3. `udf_get_fileshortad(ptr, alen, &offset, inc)` only checks `*offset +
   sizeof(struct short_ad) > maxoffset` (`alen`). Inflated `i_lenAlloc`
   makes that check pass while `ptr` walks off the kmalloc’d `i_data`.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** Obviously correct. Same idea as the 2015 FE/EFE checks
  (`udf_file_entry_alloc_offset() + i_lenAlloc > bs`). Equal length is
  allowed (`>` not `>=`), matching a full-block descriptor array.
- **Jan Kara** changed the submitted `goto out` (ret still `-EIO`) to
  `-EFSCORRUPTED`, consistent with other UDF corruption returns in this
  tree.
- **Regression risk:** Low. Only crafted/corrupt USE inodes with
  `lengthAllocDescs` larger than remaining block space fail to load;
  mount then fails instead of later OOB. Valid images are unchanged.
- **No** public API / feature / locking change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- USE branch and unvalidated `lengthAllocDescs` load: **Marcin Slusarz,
  2008** (`48d6d8ff7dca80` / `4b11111aba6c80`), in **v2.6.25-rc1**.
- FE/EFE bounds checks that USE skips: **Jan Kara, 2015**
  (`23b133bdc452aa` “udf: Check length of extended attributes and
  allocation descriptors”), which itself had `CC: stable`.
- The four new lines: this commit (`b8228f59dc58ae`).

The hole is long-standing, not new-subsystem code.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Equivalent introduction is the 2008 USE caching
plus the 2015 checks that never ran for USE. Both are ancestors of this
HEAD.

A later duplicate patch used `Fixes: 23b133bdc452`. That commit is the
missed-check explanation, not the only origin of the OOB.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- `3bd5e45c2ce30` (“fs: udf: fix OOB read in lengthAllocDescs handling”)
  — different bug (AED `lengthAllocDescs` vs `bh->b_size` in
  `udf_current_aext`). Already in this tree; not a substitute for the
  USE `i_data` check.
- `d95094d4c0a62` (“udf: Fix bh leak for unallocated space entries”) —
  **after** this commit; adds `brelse(bh)` on the USE success path.
  Independent; this fix does not need it.
- Not a numbered series.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Jay Vadayath has this one UDF commit here. **Jan Kara** is the
UDF maintainer (`MAINTAINERS`: UDF FILESYSTEM) and applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Standalone. Uses existing `i_lenAlloc`, `bs`,
`unallocSpaceEntry`, `udf_alloc_i_data()`, `-EFSCORRUPTED`.
`EFSCORRUPTED` is used throughout `fs/udf/` in this tree
(`3d2d7e61553db` is an ancestor). No new helpers.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c b8228f59dc58ae`:
  https://patch.msgid.link/20260717184021.13476-1-jay@artiphishell.com
- `b4 dig -a`: **v1 only** (no v2/v3).
- lore.kernel.org fetches returned **403**; original text verified via
  Openwall: https://lists.openwall.net/linux-kernel/2026/07/17/2179
- Submitted 2026-07-17; applied by Jan Kara 2026-07-27.
- Submitted form: comment + `goto out` (ret `-EIO`). Committed form:
  `-EFSCORRUPTED`, comment dropped. No NAK found.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): Jay Vadayath, **Jan Kara**, linux-kernel@. linux-
fsdevel was not on the original To/Cc; the maintainer still applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No public syzbot/bugzilla link. Author cites Artiphishell
vTriage + a reproducer. Independent report nine days later: Baul Lee /
XBOW, https://lists.openwall.net/linux-kernel/2026/07/26/145 — same USE
early-return hole, `Cc: stable@vger.kernel.org`.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Duplicate “udf: fix OOB read for a crafted unallocSpaceEntry” (2
lines, `udf_file_entry_alloc_offset() + i_lenAlloc > bs`). Jan Kara
replied that **this** commit already handles it (Spinics/stable thread
snippet). Equivalent fix, not a dependency.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: Duplicate was sent with `Cc: stable`. Jan pointed at
`b8228f59dc58`. Related AED OOB (`3bd5e45c2ce30`) was already backported
to 5.10/5.15. No NAK of *this* fix for stable. lore.kernel.org/stable
search: **403** (UNVERIFIED full stable archive).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `udf_read_inode()` only. Related: `udf_count_free_table()`,
`udf_current_aext()`, `udf_get_fileshortad()`, `udf_statfs()`,
`__udf_iget()`.

**Step 5.2: TRACE CALLERS**

Record (grep in `fs/udf/`):
- `udf_read_inode()` ← `__udf_iget()`
- `__udf_iget()` ← `udf_iget()` / `udf_iget_special()`
- `udf_iget_special()` ← `udf_load_partition` path in `super.c` when
  `unallocSpaceTable.extLength` is set (line ~1163)
- `udf_statfs` is `s_op->statfs` → `statfs(2)`

**Step 5.3: TRACE CALLEES**

Record: new path only assigns `ret` and `goto out` → `brelse(bh); return
ret`. No alloc/lock on the error path.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Mount UDF with a Type-1 partition unalloc space table →
`udf_iget_special` → `udf_read_inode` USE branch. If the inode loads,
unprivileged `statfs(2)` → `udf_count_free()` → `udf_count_free_table()`
when `UDF_PART_FLAG_UNALLOC_TABLE` is set. **Reachable from userspace**
after mount (optical/USB UDF, loop images, automount). After this fix,
corrupt USE fails at mount (`-EFSCORRUPTED`).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: FE/EFE already checked (2015). AED `lengthAllocDescs` vs `bh`
size already checked (`3bd5e45c2ce30`). USE was the remaining hole
because of the early return.

semcode MCP: **not available**; used grep/read.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: **`v7.3-rc4-27-gf0100363d8c37`**, `VERSION=7 PATCHLEVEL=3
  SUBLEVEL=0 EXTRAVERSION=-rc4` (mainline 7.3-rc4, not an LTS branch).
- UDF USE handling **is** in `fs/udf/inode.c`.
- Bug introduced ~**v2.6.25** (2008); FE/EFE checks since **2015**. Both
  are ancestors of HEAD.
- The candidate commit **is** an ancestor of HEAD (`git merge-base --is-
  ancestor b8228f59dc58a HEAD`). That is expected on mainline and is
  **not** treated as “already selected for stable.”
- Without this check, the USE branch in this file is exactly the buggy
  pattern.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** on this tree: four lines in a USE branch that
has been stable since 2008/2014. Later `brelse` on success
(`d95094d4c0a62`) does not conflict. `-EFSCORRUPTED` is already used in
`fs/udf/` here.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: AED OOB fix is present but **does not** cover USE `i_data`. No
earlier USE `lengthAllocDescs` bound. This is the USE-specific fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **fs/udf** — **IMPORTANT** (not mm/VFS core). UDF is used for
DVD/CD-RW and some USB disks (`fs/udf/Kconfig`). Corrupt-image bugs
still matter for automount and unprivileged `statfs`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature but active under Jan Kara (writeback, extent, corruption
checks in 7.x). This is a missing validation hole, not a refactor of new
code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Filesystem-specific** (`CONFIG_UDF_FS`): users who mount UDF
(optical, some USB, disk images).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Crafted/corrupt USE `lengthAllocDescs`; partition has unalloc
space **table** (not only bitmap). Walk happens on `statfs` if LVID
free-space is 0 and bitmap path doesn’t apply. **Unprivileged `statfs`
after mount.** Mount is usually privileged, but removable media is often
automounted. Two independent finders with a reliable KASAN repro.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **KASAN slab-out-of-bounds read** past `i_data`. Without KASAN:
unstable read of adjacent slab (crash and/or info leak). **Severity:
HIGH** (memory safety, local after mount). Not a guaranteed privilege
escalation by itself.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** High — stops a real, reproducible OOB on a user-reachable
  `statfs` path.
- **Risk:** Very low — 4 lines, error path only, same check style as
  existing UDF validation.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real KASAN OOB with stack and reproducer
- Unprivileged `statfs` after mounting crafted UDF
- Two independent reports; duplicate explicitly `Cc: stable`
- UDF maintainer applied it
- 4-line bounds check; no new API
- Bug in USE code since ~2008; this tree has that code
- FE/EFE already had the same class of check; USE skipped it
- New error path is before allocation; `out:` already releases `bh`

**AGAINST:**
- Affects UDF only, and mainly malicious/corrupt images
- Original submission was LLM-assisted (mitigated: maintainer applied;
  second reporter confirmed)
- No `Fixes:` / `Cc: stable` on the applied commit (not a negative under
  these rules)

**UNRESOLVED:**
- lore.kernel.org 403; discussion taken from b4 + Openwall
- Full stable@ archive not fetched; duplicate + Jan’s “already in my
  tree” reply was enough
- No public crafted image in-tree (author offered it on request)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — bound matches buffer size;
   KASAN repro; maintainer applied; second independent patch.
2. Fixes a real bug that affects users? **PASS** — OOB on mount +
   `statfs`.
3. Important issue? **PASS** — HIGH: slab OOB (crash / info leak), not a
   style tweak.
4. Small and contained? **PASS** — +4 lines, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — USE path and `-EFSCORRUPTED`
   exist; hunk is self-contained.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. It is a normal
**memory-safety bug fix**.

**Step 9.4: DECISION**

This tree (`v7.3-rc4`) contains the long-standing USE inode path. The
commit closes a real out-of-bounds read with a minimal check that
matches existing UDF validation. It should be backported to this tree’s
stable lineage.

### What the commit solves and why it matters

Unallocated-space (USE) inodes trusted on-disk `lengthAllocDescs` and
then walked that many bytes in a smaller `i_data` buffer. A crafted UDF
image mounts, then `statfs` hits KASAN OOB in `udf_get_fileshortad()`.
After the fix, those inodes fail load with `-EFSCORRUPTED` instead of
reading off the end of the slab.

### Stable rules / risk vs benefit

Surgical, maintainer-acked, no new ABI. Benefit is stopping a user-
reachable memory-safety bug; regression risk is limited to already-
invalid images.

### Concerns

None that block backport here. Optional follow-up `d95094d4c0a62` (bh
leak on the USE success path) is separate. `-EFSCORRUPTED` is already
used in this tree’s UDF code.

---

## Verification

- **[Phase 1]** Parsed commit
  `b8228f59dc58aea06dc024efd8f64c2d048c4578`: Assisted-by LLM, Link
  msgid, SOB Jay Vadayath + Jan Kara; no Fixes/Cc stable/Reported-by
- **[Phase 1]** Body includes KASAN stack: `udf_get_fileshortad` ←
  `udf_current_aext` ← `udf_next_aext` ← `udf_statfs` ← `statfs`
- **[Phase 2]** `git show`: +4 lines in `udf_read_inode()` USE branch
  only
- **[Phase 2]** Read `fs/udf/inode.c` USE path (~1475–1493) and FE/EFE
  checks (~1588–1592); USE `return 0` skips those checks
- **[Phase 2]** Read `udf_count_free_table()` (`super.c` ~2508),
  `udf_current_aext()` (`inode.c` ~2269), `udf_get_fileshortad()`
  (`directory.c` ~500) — OOB mechanism confirmed
- **[Phase 2]** Error path is before `udf_alloc_i_data`; `out:` at 1666
  does `brelse(bh); return ret`
- **[Phase 3]** `git blame`: USE `lengthAllocDescs` from 2008
  (`48d6d8ff7dca80`); FE/EFE checks `23b133bdc452aa` (2015)
- **[Phase 3]** `git merge-base --is-ancestor` 48d6d8ff, 23b133bd,
  3d2d7e61, b8228f59 → all ancestors of HEAD
- **[Phase 3]** Related `3bd5e45c2ce30` is AED/bh OOB, not this USE
  `i_data` bug
- **[Phase 3]** Follow-up `d95094d4c0a62` only adds `brelse` on success;
  not required for this fix
- **[Phase 4]** `b4 dig -c`: msgid
  20260717184021.13476-1-jay@artiphishell.com; `-a` v1 only; `-w` Jan
  Kara + LKML
- **[Phase 4]** Openwall original patch verified; committed version adds
  `-EFSCORRUPTED`
- **[Phase 4]** Duplicate patch 2026-07-26 by Baul Lee, `Cc: stable`;
  Jan: this commit already handles it
- **[Phase 4]** lore.kernel.org HTTP 403 — UNVERIFIED full lore thread
  beyond b4/Openwall
- **[Phase 5]** Callers: `__udf_iget` → `udf_iget_special` at
  `super.c:1163` for unalloc space table; `udf_statfs` is `.statfs`
- **[Phase 5]** semcode unavailable; used grep/read
- **[Phase 6]** `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- **[Phase 6]** Pre-fix parent `b8228f59^` shows unvalidated
  `i_lenAlloc` then `udf_alloc_i_data`
- **[Phase 6]** `-EFSCORRUPTED` used in fs/udf/inode.c, super.c,
  namei.c, directory.c, balloc.c, symlink.c
- **[Phase 7]** MAINTAINERS: Jan Kara maintains `fs/udf/`
- **[Phase 8]** Failure mode: slab-OOB read, HIGH; trigger: crafted UDF
  + statfs
- **UNVERIFIED:** Public crafted ISO contents; complete
  lore.kernel.org/stable mailbox beyond the duplicate-patch snippet

The patch is a small, correct bounds check for a real KASAN OOB that
this tree’s UDF USE path has had for years.

**YES**

 fs/udf/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 84b1a0b7b28d2..e50ecd6746104 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1488,6 +1488,10 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		iinfo->i_lenAlloc = le32_to_cpu(
 				((struct unallocSpaceEntry *)bh->b_data)->
 				 lengthAllocDescs);
+		if (iinfo->i_lenAlloc > bs - sizeof(struct unallocSpaceEntry)) {
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
 		ret = udf_alloc_i_data(inode, bs -
 					sizeof(struct unallocSpaceEntry));
 		if (ret)
-- 
2.53.0

