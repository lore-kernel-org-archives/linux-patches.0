Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4E74734C0;
	Mon, 31 Aug 2026 13:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184256; cv=none; b=X0UnK/rIOkcrumH8HwPFN6OVAiJ+QcFIXcW+oUachDxMus0XZYHutPTwV6lGfhavJJQPcnR7ruWPfR8A49MhcOaVioX36XKmlv1rTtpmbWKemd7u8wdMiQZtE9H5wDLy5h4TLgzstVwLEHm2vzOL10BYgaJ5Uu+hH+v5P9ZhPss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184256; c=relaxed/simple;
	bh=wNpRLIMNxg6h25O17HXeJEaRPRi2PG0SDh5iMyL9ldE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TU3RljkUvoh0tJs4UEJt4eUqYgCM7BOn32NsteTzcyDOfS9DMevA3NfVMsjWutt91lGOC1pKEgfrTaw04FLtaF1VNizBiJ15bwm1Wh4hPn1xVIrWZbLuDS/CWzzXsGvrq7D3tgHaZJpZT7EF0qN7au96R8/XxPOYwj4iu4HPvhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nl0HyGdz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nl0HyGdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30801F00A3E;
	Mon, 31 Aug 2026 13:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184254;
	bh=zM/idayx0HjalNQMFo2rfpy+0qt2uCjMLtsJ8zOF8Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nl0HyGdzjuFkyUt26mNoALnOglhYPwDH7V/PXxgjmFuqPRvCED5aav/PEE8FyatUm
	 PpL71kQzx2Bub9jmS65skzgWCCcgcLAdTSgDPQAcsgvUuZv8LXtHRaRfK6Ea0CT0/+
	 F+inaANlo/H3zVg664A0ov+2V0cMHXJ6P9Tyi1KuexI+nqhMFlgD/2EheKDkIK12Jj
	 51wgKEhIEIAC0Mi1maRie22ZoAc2JsdQukQ/z3I3s88A7oK0O0kE3/D9WqwIuFQ9Ug
	 ysR2W5Y3dT4qiB6y5yVjAOJ11/p16P2lJmp9nwhoTiGklMCnU4ERKPCYeQAZx9lf48
	 wuB11qrj0Ei8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alessandro Schino <7991aleschino@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ntfs3: fix out-of-bounds read in ntfs_dir_emit() and hdr_find_e()
Date: Mon, 31 Aug 2026 09:30:11 -0400
Message-ID: <20260831133314.4125787-583-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alessandro Schino <7991aleschino@gmail.com>

[ Upstream commit aa1bdbb39f49c5bc9779316891c40005517842a5 ]

The bounds check in ntfs_dir_emit() compares fname->name_len (a
character count) against e->size (a byte count) without accounting
for the 2-byte-per-character UTF-16LE encoding or the ATTR_FILE_NAME
header size:

  if (fname->name_len + sizeof(struct NTFS_DE) > le16_to_cpu(e->size))

This computes: name_len + 16 > e_size

The correct check must account for the ATTR_FILE_NAME header (66 bytes
before the name) and the UTF-16LE character size (2 bytes each):

  sizeof(NTFS_DE) + offsetof(ATTR_FILE_NAME, name) +
  name_len * sizeof(short) > e_size

Which computes: 16 + 66 + name_len * 2 > e_size

The correct calculation already exists as fname_full_size() in ntfs.h
and is used in cmp_fnames(), namei.c, and fslog.c, but was not used
in the readdir path.

A crafted NTFS image with an index entry containing a small e->size
but large fname->name_len bypasses the current check, causing
ntfs_utf16_to_nls() to read past the entry boundary.

Additionally, add a key_size validation in hdr_find_e() to ensure the
declared key_size does not exceed the available entry data, preventing
comparison functions from reading past entry boundaries on the lookup
path.

Signed-off-by: Alessandro Schino <7991aleschino@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[ntfs3]` `[fix]` — Correct out-of-bounds read bounds checks
in `ntfs_dir_emit()` and `hdr_find_e()`.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none (the underlying syzbot issue was reported on
  the earlier incomplete fix `e841ecb`)
- **Tested-by:** — none
- **Reviewed-by / Acked-by / Link / Cc: stable:** — none
- **Signed-off-by:** Alessandro Schino, Konstantin Komarov (ignore
  pipeline-added SOBs)

Notable pattern: no syzbot tag on this commit itself, but it corrects an
incomplete syzbot-driven fix.

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** `ntfs_dir_emit()` compares `fname->name_len` (UTF-16
  character count) directly against `e->size` (bytes), ignoring the
  66-byte `ATTR_FILE_NAME` header and 2-byte-per-character encoding.
- **Symptom:** A crafted NTFS index entry with small `e->size` but large
  `fname->name_len` bypasses the check; `ntfs_utf16_to_nls()` reads past
  the directory entry boundary.
- **Second bug:** `hdr_find_e()` passes `e_key_len` to comparison
  callbacks without verifying it fits in the entry, so lookup paths can
  also read past the entry.
- **Root cause:** The readdir path used a wrong formula; the correct one
  already exists as `fname_full_size()` and is used elsewhere
  (`cmp_fnames()`, `namei.c`, `fslog.c`).
- **Version info:** none in the commit message.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not hidden — this is an explicit memory-safety bug fix,
correcting an earlier incomplete bounds check (`e841ecb`).

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory the Changes
**Record:**
- `fs/ntfs3/dir.c`: +3 / -1 lines
- `fs/ntfs3/index.c`: +4 lines
- **Functions modified:** `ntfs_dir_emit()`, `hdr_find_e()`
- **Scope:** Single-subsystem, two-file surgical fix (~7 lines net)

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (`ntfs_dir_emit`):** Before: `name_len + sizeof(NTFS_DE) >
  e->size` (wrong units). After: `sizeof(NTFS_DE) +
  offsetof(ATTR_FILE_NAME, name) + name_len * sizeof(short) > e->size`
  (equivalent to `sizeof(NTFS_DE) + fname_full_size(fname)`). Affected
  path: directory enumeration before UTF-16→NLS conversion.
- **Hunk 2 (`hdr_find_e`):** Before: `e_key_len` used immediately in
  `(*cmp)()`. After: return `NULL` if `e_key_len > e->size -
  sizeof(NTFS_DE)`. Affected path: index binary search on lookup.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds read (memory safety)
- **Mechanism:** Unit confusion (characters vs bytes) plus missing
  header-size accounting in readdir; missing `key_size` cap in index
  lookup. Crafted on-disk metadata passes the weak check and drives
  reads beyond the kmalloc’d index buffer.

### Step 2.4: Fix Quality
**Record:** Obviously correct — mirrors `fname_full_size()` already used
in `cmp_fnames()` and other ntfs3 paths. Minimal, no API changes. Low
regression risk: only tightens validation on corrupted/crafted images;
legitimate entries already satisfy the stronger check.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame the Changed Lines
**Record:** The weak check in `ntfs_dir_emit()` was introduced by
`e841ecb1393396` ("fs/ntfs3: Add sanity check for file name",
2025-06-06, Lizhi Xu), which itself was a syzbot-driven incomplete fix.
`hdr_find_e()` binary-search path dates to 2021 (`162333efa8dc49`)
without `key_size` validation.

### Step 3.2: Follow Fixes: Tag
**Record:** N/A — no `Fixes:` tag. The introducing commit for the weak
readdir check is `e841ecb`, which **is** in this tree.

### Step 3.3: File History for Related Changes
**Record:** Recent ntfs3 OOB fixes in this tree include `f3624cc`
(split-point offset), `aaa1f956` (to_move bound), `908c9243` (depth
limit). This fix is standalone and complementary. On `master`, it landed
via merge `f0e6f20cb52b1` (ntfs3_for_7.2 tag); it is **not** in current
`HEAD`.

### Step 3.4: Author's Other Commits
**Record:** Alessandro Schino has no other ntfs3 commits in this
checkout. Konstantin Komarov is the ntfs3 maintainer (Paragon) with a
long history of ntfs3 security/bounds fixes.

### Step 3.5: Prerequisites
**Record:** No dependencies. `fname_full_size()`, `offsetof(struct
ATTR_FILE_NAME, name)` (0x42), and `sizeof(struct NTFS_DE)` (0x10) all
exist in this tree. `git show aa1bdbb39f49c -- fs/ntfs3/dir.c
fs/ntfs3/index.c | git apply --check` succeeds on `HEAD`.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig -c aa1bdbb39f49c` →
https://patch.msgid.link/20260511181516.220-1-7991aleschino@gmail.com.
Single v1 submission (no v2/v3). Lore thread fetch blocked by bot
protection; could not read inline review replies.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC'd: `ntfs3@lists.linux.dev`, Konstantin
Komarov, `linux-kernel@vger.kernel.org`.

### Step 4.3: Bug Report
**Record:** Related syzbot issue
https://syzkaller.appspot.com/bug?extid=598057afa0f49e62bd23 — **KASAN:
slab-out-of-bounds Read in `ntfs_utf16_to_nls`**, triggered via
`getdents64` → `ntfs_readdir` → `ntfs_dir_emit`. Marked "fixed" by
`e841ecb`, but that fix used the wrong formula and remains bypassable.

### Step 4.4: Related Patches/Series
**Record:** Standalone 1-patch series; not part of a multi-patch
dependency chain.

### Step 4.5: Stable Mailing List
**Record:** Not searched separately; no stable-list nomination found via
b4.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `ntfs_dir_emit()`, `hdr_find_e()`, `ntfs_utf16_to_nls()`,
`fname_full_size()`, `cmp_fnames()`.

### Step 5.2: Callers
**Record:**
- `ntfs_dir_emit()` ← `ntfs_read_hdr()` ← `ntfs_readdir()`
  (`file_operations::iterate_shared`)
- `hdr_find_e()` ← `hdr_insert_de()`, `indx_find()` (index lookup for
  create/delete/rename paths)

### Step 5.3: Callees
**Record:** `ntfs_utf16_to_nls()` reads `fname->name` for `name_len`
UTF-16 code units (2 bytes each). `(*cmp)()` in `hdr_find_e()` reads `e
+ 1` for `e_key_len` bytes.

### Step 5.4: Reachability
**Record:** **Userspace-reachable.** Malicious NTFS image mounted (loop
device) + `readdir`/`getdents64` triggers the `ntfs_dir_emit` path.
Index lookup paths are reachable on file/directory operations against
the same crafted image. Syzbot stack trace confirms syscall
reachability.

### Step 5.5: Similar Patterns
**Record:** `cmp_fnames()` already uses `fname_full_size(f2)` and checks
`l2 < fsize2`. `namei.c`, `fslog.c`, and `frecord.c` use
`fname_full_size()` correctly. Only readdir and `hdr_find_e` were
missing equivalent validation.

---

## Phase 6: Cross-Referencing Against the Local Tree

### Step 6.1: Does the Buggy Code Exist?
**Record:** **Yes.** Local tree: `v6.18.44` (`git describe HEAD` →
`v6.18.44-1-gef4bf62bccf3c`, `make kernelversion` → `6.18.44`), detached
from `stable/linux-6.18.y`.

Current buggy check at line 307 of `fs/ntfs3/dir.c`:

```307:308:fs/ntfs3/dir.c
        if (fname->name_len + sizeof(struct NTFS_DE) >
le16_to_cpu(e->size))
                return true;
```

`hdr_find_e()` at line 760 has no `key_size` validation before calling
`(*cmp)()`. Fix commit `aa1bdbb39f49c` is **not** an ancestor of `HEAD`;
introducing commit `e841ecb` **is**.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** `git apply --check` of the fix
diff against `HEAD` passes with no conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** The incomplete fix `e841ecb` is present. No correct fix for
this specific bug found in `HEAD`.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **fs/ntfs3** — filesystem driver. **IMPORTANT** (not core
VFS, but any user mounting NTFS3 volumes; security-relevant via crafted
images).

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; multiple recent bounds-check and
validation commits in this tree’s ntfs3 history.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users with `CONFIG_NTFS3_FS` enabled who mount untrusted or
corrupted NTFS volumes (USB drives, downloaded images, fuzzer-generated
images).

### Step 8.2: Trigger Conditions
**Record:** Mount crafted NTFS + directory read (`ls`, `getdents64`) or
index lookup. Common for malicious/removable media scenarios.
Unprivileged users need mount permission, but the attack surface is
standard for filesystem fuzzing/CVE class.

### Step 8.3: Failure Mode Severity
**Record:** **Slab out-of-bounds read** (KASAN-confirmed on related
bug). Severity: **HIGH** — kernel memory safety violation; potential
info leak or further exploitation depending on layout. Not merely a
WARN.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — closes a bypassable OOB read on a common operation
  (directory listing) and hardens index lookup.
- **Risk:** VERY LOW — 7-line validation tightening using an established
  formula.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible memory-safety bug (syzbot KASAN on same code path)
- Crafted filesystem image trigger via `getdents64`
- Incomplete prior fix (`e841ecb`) is in 6.18.y and still bypassable
- Fix is tiny, obviously correct, matches existing `fname_full_size()`
  logic
- Applies cleanly to this tree
- ntfs3 driver and all required symbols exist in 6.18.44

**AGAINST backport:**
- ntfs3 is config-optional (`CONFIG_NTFS3_FS`)
- No explicit syzbot/Reported-by on this specific commit (but mechanism
  is verified)

**Unresolved:** Full lore review thread content (bot-blocked); no
independent runtime test in this environment.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — formula matches
   `fname_full_size()`; maintainer SOB; clean apply.
2. Fixes a real bug affecting users? **PASS** — crafted NTFS → OOB read
   on readdir/lookup.
3. Important issue? **PASS** — memory safety / HIGH severity.
4. Small and contained? **PASS** — 2 files, ~7 lines.
5. No new features or APIs? **PASS** — validation only.
6. Can apply to local tree? **PASS** — `git apply --check` succeeded.

### Step 9.3: Exception Categories
**Record:** N/A (security/bug fix, not device-ID/quirk/build/doc
exception).

### Step 9.4: Problem and Decision

This commit fixes a **unit-mismatch bounds check** in `ntfs_dir_emit()`
that leaves a slab out-of-bounds read reachable when enumerating
directories on a crafted NTFS image. The weak check was added in
`e841ecb` after syzbot found the original missing-check bug, but the
formula `name_len + 16 > e_size` still allows `name_len` up to roughly
twice what the entry can hold (e.g., `e_size=82` permits `name_len=66`
while only ~33 characters fit). It also adds missing `key_size`
validation in `hdr_find_e()` for the index lookup path.

For **linux-6.18.y (6.18.44)**: the ntfs3 driver is present, the buggy
code is present, the fix is absent, and the patch applies cleanly. This
is appropriate stable material.

---

## Verification

- [Phase 1] Parsed commit `aa1bdbb39f49c`: subject, body, tags (no
  Fixes/Reported-by/syzbot on this commit)
- [Phase 2] Read diff: 7 lines across `dir.c` and `index.c`; bounds-
  check correction + `key_size` validation
- [Phase 3] `git blame` line 307 → `e841ecb` (2025-06-06); `hdr_find_e`
  binary_search from 2021
- [Phase 3] `git merge-base --is-ancestor`: `e841ecb` IN HEAD;
  `aa1bdbb39f49c` NOT IN HEAD
- [Phase 3] `git apply --check` of fix patch on HEAD: **success**
- [Phase 4] `b4 dig -c aa1bdbb39f49c`: lore URL found; v1 only
- [Phase 4] `b4 dig -w`: ntfs3 list + Komarov CC'd
- [Phase 4] Syzkaller bug 598057afa0f49e62bd23: KASAN slab OOB in
  `ntfs_utf16_to_nls`, getdents64 path; prior fix `e841ecb` noted
- [Phase 5] Call chain: `ntfs_readdir` → `ntfs_read_hdr` →
  `ntfs_dir_emit` → `ntfs_utf16_to_nls`
- [Phase 5] `fname_full_size()` at `ntfs.h:586-591`;
  `offsetof(ATTR_FILE_NAME, name)==0x42`; `sizeof(NTFS_DE)==0x10`
- [Phase 5] `cmp_fnames()` already uses `fname_full_size()` with `l2 <
  fsize2` check
- [Phase 6] `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- [Phase 6] Buggy code confirmed at `fs/ntfs3/dir.c:307` and missing
  validation at `fs/ntfs3/index.c:760-762`
- [Phase 8] Failure mode: slab OOB read, HIGH severity, userspace-
  triggerable via directory read on mounted image

**YES**

 fs/ntfs3/dir.c   | 4 +++-
 fs/ntfs3/index.c | 4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index d41d02372c747..a68eff8cf1d66 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -304,7 +304,9 @@ static inline bool ntfs_dir_emit(struct ntfs_sb_info *sbi,
 	if (sbi->options->nohidden && (fname->dup.fa & FILE_ATTRIBUTE_HIDDEN))
 		return true;
 
-	if (fname->name_len + sizeof(struct NTFS_DE) > le16_to_cpu(e->size))
+	if (sizeof(struct NTFS_DE) +
+	    offsetof(struct ATTR_FILE_NAME, name) +
+	    fname->name_len * sizeof(short) > le16_to_cpu(e->size))
 		return true;
 
 	name_len = ntfs_utf16_to_nls(sbi, fname->name, fname->name_len, name,
diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index dd54c966babca..edfcd28573ef9 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -794,6 +794,10 @@ static struct NTFS_DE *hdr_find_e(const struct ntfs_index *indx,
 binary_search:
 	e_key_len = le16_to_cpu(e->key_size);
 
+	/* Validate key_size fits within the entry data area. */
+	if (e_key_len > le16_to_cpu(e->size) - sizeof(struct NTFS_DE))
+		return NULL;
+
 	diff2 = (*cmp)(key, key_len, e + 1, e_key_len, ctx);
 	if (diff2 > 0) {
 		if (found) {
-- 
2.53.0

