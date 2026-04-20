Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEFB44DB68;
	Mon, 20 Apr 2026 13:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691826; cv=none; b=PO7WIR0DZH7ZJt1UjzudemeeMtfHk26qFaLDAJ+LmoeMg2Fe5EGR5TeXj4G9soY+X68tlYyi7XHX06pB8uscy62cnjUTXBu9oRm2uTn4xxj6JQhayqgMNNjuBg4zKdfHjFzvTlN73l/hhs+eFr5A0TMFVK3X7llI+R3GbF3SwUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691826; c=relaxed/simple;
	bh=qidpnksWH8YCgvNCmhvq/DCXQiiTWg4VFcR0Pg+sVQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JKoajvNw42fsic2X3OWyP/2bXwKSuKbJZXwJ84P1OV1V6udQSBSPny0TPyySEwlpLN2nxDDiO3B9rdIfulJ2sqZCcm0WHzr13FeB4/w2Pw3mGOZW1aql7ug8YI2rr/1KacXHsXKWHa1NN1J8PpjQvpVSgq9hpnR595ICoHRP8PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Flak9/wH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Flak9/wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174D0C2BCB6;
	Mon, 20 Apr 2026 13:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691826;
	bh=qidpnksWH8YCgvNCmhvq/DCXQiiTWg4VFcR0Pg+sVQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Flak9/wHQzuekj31x9Y94yO+iB24xsaBvFQbJFoCz1yQD/9iiZG7//EkBzq+3KC6t
	 faoX0Xbh6XbjKUFWClPZI/TE0wxTgXrY4ic/acBD0u5pYoyuHVMG3ITRaqrCyIGScD
	 TS7BA1CfjlkkJ7+wqjhnLvT9pFZ52I6dalVXBy32hwuO/BwOjkyIjXkvMivdfEl3Pr
	 wgx3cBHtpta/OwzEpfXavMk0Rx/iKI8oGKGXPmLxbIl7vl0DvVkPc9BOKwAVQnk4Ew
	 5Y+kYV0VHUlI44lsWrk8o3jal+go6qKmw5MhNVzP7RQg/T68pmQR98ZCHK64SA7Njc
	 bmvX5mgP4tlCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hyungjung Joo <jhj140711@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] affs: bound hash_pos before table lookup in affs_readdir
Date: Mon, 20 Apr 2026 09:20:11 -0400
Message-ID: <20260420132314.1023554-217-sashal@kernel.org>
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

From: Hyungjung Joo <jhj140711@gmail.com>

[ Upstream commit 6fa253b38b9b293a0de2a361de400557ca7666ca ]

affs_readdir() decodes ctx->pos into hash_pos and chain_pos and then
dereferences AFFS_HEAD(dir_bh)->table[hash_pos] before validating
that hash_pos is within the runtime table bound. Treat out-of-range
positions as end-of-directory before the first table lookup.

Signed-off-by: Hyungjung Joo <jhj140711@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
- **Subsystem**: `affs` (Amiga Fast File System)
- **Action verb**: "bound" — implies adding a missing bounds check
- **Summary**: Bound `hash_pos` before using it as an array index into
  `AFFS_HEAD(dir_bh)->table[]` in `affs_readdir()`

Record: [affs] [bound/validate] [Add missing bounds check on hash_pos
before table array lookup in readdir]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by**: Hyungjung Joo <jhj140711@gmail.com> — the author
- **Reviewed-by**: David Sterba <dsterba@suse.com> — the AFFS maintainer
- **Signed-off-by**: David Sterba <dsterba@suse.com> — the AFFS
  maintainer applied it
- No Fixes: tag, no Reported-by:, no Link:, no Cc: stable — all expected
  for autosel candidates.

Record: Patch was reviewed AND applied by the subsystem maintainer
(David Sterba is listed as AFFS maintainer in MAINTAINERS). Strong
quality signal.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The message explains:
1. `affs_readdir()` decodes `ctx->pos` into `hash_pos` and `chain_pos`.
2. It then dereferences `AFFS_HEAD(dir_bh)->table[hash_pos]` **before**
   validating that `hash_pos` is within the runtime bound
   (`s_hashsize`).
3. The fix treats out-of-range positions as end-of-directory before the
   first table lookup.

Record: Bug = out-of-bounds array access. Symptom = potential read
beyond buffer. The author clearly understands the bug mechanism.

### Step 1.4: DETECT HIDDEN BUG FIXES
This is NOT hidden — it's explicitly a missing bounds check (a real out-
of-bounds access fix).

Record: This is a direct bug fix adding a missing safety check.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- **Files changed**: 1 (`fs/affs/dir.c`)
- **Lines added**: 2
- **Lines removed**: 0
- **Function modified**: `affs_readdir()`
- **Scope**: Single-file, single-function, 2-line surgical fix.

Record: Extremely minimal change — 2 lines added in one function in one
file.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE

The fix adds this check between lines 121 and 123 (before the first
array dereference):

```c
if (hash_pos >= AFFS_SB(sb)->s_hashsize)
    goto done;
```

**BEFORE**: `hash_pos` derived from `(ctx->pos - 2) >> 16` is used
directly as an index into `table[]` with no validation. The only bounds
check is in the later `for` loop at line 139.

**AFTER**: If `hash_pos >= s_hashsize`, we jump to `done` which cleanly
saves state and returns (end-of-directory).

### Step 2.3: IDENTIFY THE BUG MECHANISM

This is a **buffer overflow / out-of-bounds read** (category g -
logic/correctness + category d - memory safety):

- `struct affs_head` has a flexible array member `__be32 table[]` (from
  `amigaffs.h` line 84)
- `table` occupies space within the disk block buffer. Its valid size is
  `s_hashsize = blocksize / 4 - 56` entries (set in `super.c` line 401)
- `hash_pos` comes from `(ctx->pos - 2) >> 16`. Since `ctx->pos` is a
  `loff_t` and can be set via `lseek()` on the directory file
  descriptor, a user can set it to any value
- An out-of-range `hash_pos` reads past the allocated block buffer,
  which is a heap buffer overread

Contrast with other callers: `affs_hash_name()` (used in `namei.c` and
`amigaffs.c`) returns `hash % AFFS_SB(sb)->s_hashsize` — always bounded.
But `affs_readdir()` is the ONLY place where `hash_pos` comes from user-
controlled `ctx->pos` without bounds validation.

Record: Out-of-bounds array read. `hash_pos` from user-controlled
`ctx->pos` used as index into `table[]` without bounds check. Fix adds
the check before the first dereference.

### Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct**: Yes. The check `hash_pos >= s_hashsize` is the
  exact same condition used in the `for` loop at line 139. The `goto
  done` label already exists and is the correct cleanup path.
- **Minimal/surgical**: Yes. 2 lines, single function, no side effects.
- **Regression risk**: Essentially zero. For valid `hash_pos` values,
  behavior is unchanged. For invalid values that previously caused OOB
  access, we now cleanly return end-of-directory.

Record: Fix is trivially correct, minimal, and carries no regression
risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
From git blame, line 123 (`ino =
be32_to_cpu(AFFS_HEAD(dir_bh)->table[hash_pos]);`) is attributed to
`^1da177e4c3f41` — Linus Torvalds, 2005-04-16 — the initial Linux
2.6.12-rc2 commit.

Record: The buggy code has been present since **Linux 2.6.12-rc2
(2005)**. This means the bug exists in **every stable tree ever**.

### Step 3.2: FOLLOW THE FIXES TAG
No Fixes: tag present. However, the bug effectively traces back to
`1da177e4c3f41` (Linux 2.6.12-rc2).

Record: Bug predates all current stable trees.

### Step 3.3: CHECK FILE HISTORY
The file `fs/affs/dir.c` has been remarkably stable. Between v5.15 and
v6.6, there were **zero changes**. The only change between v6.6 and v7.0
was `bad74142a04bf` (affs: store cookie in private data, 2024-08-30)
which refactored how the iversion cookie is stored. The core readdir
logic including the buggy lines hasn't changed since 2005.

Record: Very stable file. No prerequisites needed. The fix is
standalone.

### Step 3.4: CHECK THE AUTHOR
Hyungjung Joo doesn't appear to have other commits in this tree (not a
regular contributor). However, the patch was reviewed and applied by
David Sterba, who is the AFFS maintainer per MAINTAINERS.

Record: External contributor, but vetted by the subsystem maintainer.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
The fix adds a simple check using `AFFS_SB(sb)->s_hashsize` and the
existing `done` label — both present in all kernel versions since 6.6+
(and much earlier). No dependencies.

Record: Completely standalone. No prerequisites.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Steps 4.1-4.5
Lore.kernel.org was not accessible due to bot protection. b4 dig could
not find the commit hash (the commit isn't in this tree). However:

- The patch was reviewed by the AFFS maintainer David Sterba (`Reviewed-
  by:`)
- David Sterba also applied it (`Signed-off-by:` as committer)
- The "Odd Fixes" maintenance status in MAINTAINERS means this subsystem
  only gets bug fixes, which is consistent with this patch being a fix.

Record: Could not fetch lore discussion due to bot protection. The
maintainer's review and sign-off provide sufficient confidence.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS
Modified function: `affs_readdir()`

### Step 5.2: TRACE CALLERS
`affs_readdir` is registered as `.iterate_shared` in
`affs_dir_operations`. It is called by the VFS `getdents`/`readdir`
syscall path when reading entries from an AFFS directory. This is
directly reachable from userspace by any user who can mount and read
AFFS filesystems.

### Step 5.3-5.4: CALL CHAIN
Userspace path: `getdents64()` syscall -> `iterate_dir()` ->
`affs_readdir()` -> `AFFS_HEAD(dir_bh)->table[hash_pos]` (OOB access)

The user controls `ctx->pos` via `lseek()` on the directory fd. Setting
it to a large value produces a large `hash_pos` that triggers the OOB
read.

Record: Directly reachable from userspace. Any user with access to an
AFFS mount can trigger this.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
Other AFFS table accesses (in `namei.c`, `amigaffs.c`) use
`affs_hash_name()` which returns `hash % s_hashsize` — always bounded.
The `readdir` path is the only one that computes `hash_pos` from user-
controlled input without bounds checking.

Record: This is the only vulnerable access pattern; other paths are
properly bounded.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
Yes. The buggy line (line 123) is from the original 2005 commit. It
exists in **all** stable trees. Verified that `fs/affs/dir.c` had zero
changes between v5.15 and v6.6, and only one minor refactor
(`bad74142a04bf`) between v6.6 and v7.0.

Record: Bug exists in all active stable trees.

### Step 6.2: BACKPORT COMPLICATIONS
The patch context differs slightly between v7.0 (where `data->ino` and
`data->cookie` are used) and v6.6 and older (where `file->private_data`
and `file->f_version` are used). However, the fix inserts between the
iversion check and the table lookup, and the critical line `ino =
be32_to_cpu(AFFS_HEAD(dir_bh)->table[hash_pos])` is identical across all
versions. The patch may need minor context adjustment for trees before
v6.12, but the fix itself is trivially portable.

Record: Clean apply on v6.12+; may need minor context fixup for v6.6 and
older. Trivially adaptable.

### Step 6.3: RELATED FIXES ALREADY IN STABLE
No related fixes found. This specific OOB access has never been patched
before.

Record: No duplicate fix exists.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY SUBSYSTEM AND CRITICALITY
- **Subsystem**: `fs/affs/` — Amiga Fast File System
- **Criticality**: PERIPHERAL — niche filesystem, but used for Amiga
  disk image access and retro-computing communities
- **Maintenance status**: "Odd Fixes" — only bug fixes accepted,
  consistent with this patch

Record: Peripheral subsystem. However, filesystem bugs can cause data
corruption or security issues, and the fix is trivially safe.

### Step 7.2: SUBSYSTEM ACTIVITY
Very low activity — a handful of commits over years. This is a mature,
stable codebase. The bug has been latent for 20 years.

Record: Mature subsystem. Bug has been present since the beginning.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: AFFECTED USERS
Users who mount AFFS filesystems (Amiga-format media). This is niche but
real — retro-computing, disk image forensics, embedded systems with
Amiga hardware.

Record: Niche filesystem users, but any system that processes AFFS
images is affected.

### Step 8.2: TRIGGER CONDITIONS
- Mount an AFFS filesystem
- Open a directory
- `lseek()` the directory fd to a position where `(pos - 2) >> 16 >=
  s_hashsize`
- Call `getdents()` (or any readdir)

This is **trivially triggerable by an unprivileged local user** with
access to the mount, or by a **crafted disk image** (e.g., automounted
removable media).

Record: Easily triggered. Unprivileged user can trigger via lseek +
getdents. Also triggerable via crafted disk images.

### Step 8.3: FAILURE MODE SEVERITY
The OOB read on `AFFS_HEAD(dir_bh)->table[hash_pos]` reads beyond the
block buffer (`dir_bh->b_data`). This can:
- **Read garbage data** from adjacent slab objects → potential
  **information leak**
- **Trigger KASAN** reports (slab-out-of-bounds)
- **Crash** if the read hits an unmapped page
- Use the garbage value as a block number for `affs_bread()`, leading to
  further **unpredictable behavior**

Record: Severity = **HIGH**. Out-of-bounds heap read with potential for
crash, information leak, or cascading corruption.

### Step 8.4: RISK-BENEFIT RATIO
- **BENEFIT**: Fixes an OOB read reachable from userspace, present in
  all stable trees for 20 years. Prevents potential crash/info-leak.
- **RISK**: 2 lines, uses existing check pattern and existing `done`
  label. Effectively zero regression risk.
- **Ratio**: Very high benefit, near-zero risk.

Record: Excellent risk/benefit ratio.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**Evidence FOR backporting:**
- Fixes a real out-of-bounds array read bug
- Directly reachable from unprivileged userspace (lseek + getdents)
- Also triggerable by crafted disk images
- Bug exists since Linux 2.6.12-rc2 (2005) — present in ALL stable trees
- Fix is 2 lines, obviously correct, and uses existing patterns
- Reviewed and applied by the AFFS maintainer (David Sterba)
- Zero regression risk
- No dependencies on other patches

**Evidence AGAINST backporting:**
- AFFS is a niche filesystem (low user population)
- Minor context adjustment may be needed for pre-6.12 stable trees
- No syzbot report or Reported-by (but the bug is clearly real from code
  inspection)

**Unresolved:**
- Could not access lore discussion due to bot protection (not impactful
  — maintainer review provides sufficient confidence)

### Step 9.2: STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES — trivial bounds check,
   reviewed by maintainer
2. **Fixes a real bug?** YES — out-of-bounds array read from user-
   controlled input
3. **Important issue?** YES — potential crash, info leak, or undefined
   behavior from userspace
4. **Small and contained?** YES — 2 lines in one function in one file
5. **No new features or APIs?** CORRECT — purely a safety check
6. **Can apply to stable trees?** YES — clean or near-clean apply across
   all active stable trees

### Step 9.3: EXCEPTION CATEGORIES
Not an exception category — this is a standard bug fix.

### Step 9.4: DECISION
This is a small, obviously correct bounds check that prevents an out-of-
bounds array access reachable from unprivileged userspace. It has been
reviewed and applied by the subsystem maintainer, carries no regression
risk, and applies to all stable trees. This is a textbook stable
backport candidate.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by David Sterba (AFFS maintainer), SOB
  from David Sterba as committer
- [Phase 2] Diff analysis: 2 lines added in `affs_readdir()`, adds
  bounds check `if (hash_pos >= s_hashsize) goto done;` before first
  `table[hash_pos]` access
- [Phase 2] Verified `struct affs_head` has `__be32 table[]` flexible
  array member (`amigaffs.h:77-85`)
- [Phase 2] Verified `s_hashsize = blocksize / 4 - 56` (`super.c:401`)
- [Phase 2] Verified `hash_pos = (ctx->pos - 2) >> 16` derived from
  user-controllable file position
- [Phase 3] git blame: buggy line 123 from commit `1da177e4c3f41` (Linux
  2.6.12-rc2, 2005), present in all stable trees
- [Phase 3] git log: zero changes to dir.c between v5.15 and v6.6; one
  unrelated refactor `bad74142a04bf` between v6.6 and v7.0
- [Phase 3] MAINTAINERS: David Sterba listed as AFFS maintainer, status
  "Odd Fixes"
- [Phase 5] Verified `affs_hash_name()` returns `hash % s_hashsize`
  (bounded), but `affs_readdir` computes hash_pos from unchecked user
  input
- [Phase 5] Verified `affs_readdir` is called via `.iterate_shared` in
  VFS readdir path — directly reachable from getdents syscall
- [Phase 6] Verified v6.6 `fs/affs/dir.c` has identical buggy code at
  the same location
- [Phase 6] No duplicate fix found in any stable tree
- UNVERIFIED: Could not access lore discussion due to bot protection
  (does not affect decision — maintainer review confirmed via tags)

**YES**

 fs/affs/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/affs/dir.c b/fs/affs/dir.c
index 5c8d83387a394..075c18c4ccde6 100644
--- a/fs/affs/dir.c
+++ b/fs/affs/dir.c
@@ -119,6 +119,8 @@ affs_readdir(struct file *file, struct dir_context *ctx)
 		pr_debug("readdir() left off=%d\n", ino);
 		goto inside;
 	}
+	if (hash_pos >= AFFS_SB(sb)->s_hashsize)
+		goto done;
 
 	ino = be32_to_cpu(AFFS_HEAD(dir_bh)->table[hash_pos]);
 	for (i = 0; ino && i < chain_pos; i++) {
-- 
2.53.0

