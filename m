Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C89581252;
	Mon, 31 Aug 2026 13:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184192; cv=none; b=Ca8najd0VnvP7N2exzz6MdCge/YpZhhPG9ghviPNayutoYtqyx4IA93ttkcy4SwlXRTV/nNmLkaFErSmrGkEPUD/kJLGWar5CEG8fMX0LzcGXbDIByyoSZwNsXWIIi6xDrrPme+OGBZgdvipxFBc7hSTOMWg+Z+tzKSN3t+o9Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184192; c=relaxed/simple;
	bh=3rVMO+1l3g7xklmBAuPt3uj9YNlTPFwa8bHpqgSrX5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WEyDn5WronoQYRLfR1+Dsmyq8CxoguUJ1pfRYlvb9NiENShMO13VHhNBXbkf7iZVt7lqqxtCb5ec0pbrUfQZCJDlvTeK6c0GZRzEMDsQRUNuimuybV8XBzivSoJ+fpf+W0vjKK8N9J/3kwv2z6BYTpFoO0i8JsYPpaiyqPEuka8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ycpp7BsU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ycpp7BsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6731F000E9;
	Mon, 31 Aug 2026 13:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184189;
	bh=N6fURMI7uBvTjM8tKOZYWgJgAFkJWInlkr0MoI+eQD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ycpp7BsUTesX9qh8csWYLF7dgJqtfCqt7uWGg9QP1woR2iF1Jhl76s+WuhxLHso2p
	 VYlLUCLsBDYQ4ycSTokBQAj5cJt6Vy9uTO/KP8lhrGwuWZLWpZ35gRVh6WQbqXdzbc
	 hnHAwE/rpZdIp8qI5CYWEtSyXh7N+buoZJb7nOrQMPId8eylXwRJsiifATSICn6WT6
	 hwAx/2qSm2+CuME4Gwl1cHZQdOD4fYzEVTHRW02cr1UqJUM2xSmbJ3BVa1ze2bSqKr
	 vBTHNYqX3sbXJdgMT08BWdSM5f8dU6GxauOD+vtFWR8I3W9UMBGGflUxX5L3scqF5c
	 Kq8HhfORZ911A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhengYuan Huang <gality369@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] fs/ntfs3: preserve non-DOS attribute bits in system.dos_attrib
Date: Mon, 31 Aug 2026 09:29:33 -0400
Message-ID: <20260831133314.4125787-545-sashal@kernel.org>
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

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit b1c1101067d9536bcb0fe023b96ee2dde5535959 ]

[BUG]
A corrupted ntfs3 image can hit a NULL function pointer call in
generic_perform_write() after toggling system.ntfs_attrib and then
overwriting system.dos_attrib on the same file.

BUG: kernel NULL pointer dereference, address: 0000000000000000
\#PF: supervisor instruction fetch in kernel mode
\#PF: error_code(0x0010) - not-present page
PGD bed5067 P4D bed5067 PUD 0
Oops: Oops: 0010 [#1] SMP KASAN NOPTI
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffff88801025f988 EFLAGS: 00010246
Call Trace:
 generic_perform_write+0x409/0x8c0 mm/filemap.c:4255
 __generic_file_write_iter+0x1bb/0x200 mm/filemap.c:4372
 ntfs_file_write_iter+0xcd9/0x1c20 fs/ntfs3/file.c:1253
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x63b/0xf70 fs/read_write.c:686
 ksys_write+0x133/0x250 fs/read_write.c:738
 __do_sys_write fs/read_write.c:749 [inline]
 __se_sys_write fs/read_write.c:746 [inline]
 __x64_sys_write+0x77/0xc0 fs/read_write.c:746
 ...

[CAUSE]
system.ntfs_attrib updates ATTR_DATA flags via ni_new_attr_flags()
and switches i_mapping->a_ops to ntfs_aops_cmpr when
FILE_ATTRIBUTE_COMPRESSED is set. system.dos_attrib then overwrites
ni->std_fa from a one-byte DOS attribute value, clearing the compression
bit without updating ATTR_DATA or the mapping operations.

Old buffered writes use is_compressed(ni) to choose
__generic_file_write_iter(). That leaves generic_perform_write() calling
a NULL write_begin callback from ntfs_aops_cmpr.

[FIX]
Treat system.dos_attrib as a low-byte DOS attribute update and preserve the
existing non-DOS attribute bits in ni->std_fa. This keeps compressed and
sparse state consistent with ATTR_DATA and the mapping operations while
keeping the existing DOS attribute semantics intact.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[fs/ntfs3]` `[preserve]` — preserve non-DOS attribute bits
when updating `system.dos_attrib` xattr.

### Step 1.2: Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — not present
- **Tested-by:** — not present
- **Reviewed-by:** — not present
- **Acked-by:** — not present
- **Link:** — not present
- **Cc: stable@vger.kernel.org** — not present (expected)
- **Signed-off-by:** ZhengYuan Huang `<gality369@gmail.com>`, Konstantin
  Komarov `<almaz.alexandrovich@paragon-software.com>`

Notable: maintainer (Komarov) Signed-off-by present; no syzbot report,
but commit includes full KASAN oops stack trace.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** NULL function pointer dereference in
  `generic_perform_write()` after setting `system.ntfs_attrib` then
  `system.dos_attrib` on the same file.
- **Symptom:** Kernel oops — `#PF: supervisor instruction fetch`, `RIP:
  0x0`, call chain through `ntfs_file_write_iter` →
  `__generic_file_write_iter` → `generic_perform_write`.
- **Root cause:** `system.ntfs_attrib` sets compression via
  `ni_new_attr_flags()` and switches `i_mapping->a_ops` to
  `ntfs_aops_cmpr`. `system.dos_attrib` then replaces all of
  `ni->std_fa` with a 1-byte DOS value, clearing
  `FILE_ATTRIBUTE_COMPRESSED` without updating ATTR_DATA or `a_ops`.
  `is_compressed(ni)` becomes false, so buffered writes use
  `__generic_file_write_iter()`, but `a_ops` remains `ntfs_aops_cmpr`
  which has no `write_begin` → NULL deref.
- **Fix:** Mask-merge: preserve upper bits of `ni->std_fa`, only update
  low DOS byte.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — explicitly labeled `[BUG]` with stack trace
and root-cause analysis. This is a clear correctness/crash fix, not
cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **Files:** `fs/ntfs3/xattr.c` only (+3 lines, -1 line)
- **Function:** `ntfs_setxattr()`
- **Scope:** Single-file surgical fix in xattr handler

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `SYSTEM_DOS_ATTRIB` setxattr: `new_fa = cpu_to_le32(*(u8
  *)value)` — full 32-bit replace from 1-byte input.
- **After:** `new_fa = (ni->std_fa & ~cpu_to_le32(0xff)) |
  cpu_to_le32(*(u8 *)value)` — merge low byte only.
- **Path affected:** `setxattr("system.dos_attrib", ...)` on regular
  files, then `set_new_fa` label updates `ni->std_fa` without calling
  `ni_new_attr_flags()`.

### Step 2.3: Bug Mechanism
**Record:** **Logic/correctness + NULL pointer dereference.**
Inconsistent inode state: `a_ops` says compressed, `std_fa` says not.
`ntfs_file_write_iter()` at line 1252 branches on `is_compressed(ni)`
(checks `std_fa`), not on `a_ops`. Mismatch leads to
`generic_perform_write()` calling NULL `write_begin` from
`ntfs_aops_cmpr`.

Verified: `ntfs_aops_cmpr` (inode.c:2116-2121) has no `write_begin`;
`ntfs_aops` (2105-2114) does.

### Step 2.4: Fix Quality
**Record:** Obviously correct. `ntfs_getxattr()` for `SYSTEM_DOS_ATTRIB`
already returns only the low byte (`*(u8 *)buffer =
le32_to_cpu(ni->std_fa)` at xattr.c:781), so set/get semantics are now
symmetric. Minimal change, no API changes, very low regression risk.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy line `new_fa = cpu_to_le32(*(u8 *)value)` introduced
in `be71b5cba2e648` (Konstantin Komarov, 2021-08-13, "fs/ntfs3: Add
attrib operations"). `SYSTEM_DOS_ATTRIB` strcmp dispatch added in
`d45da67caedacd` (2022-09-24). Bug present since ntfs3 xattr support was
added.

### Step 3.2: Fixes: Tag
**Record:** No `Fixes:` tag. N/A.

### Step 3.3: Related File History
**Record:** Recent ntfs3 activity in this tree is heavy on
fuzzer/corruption fixes (OOB reads, bounds checks). No prior fix for
this dos_attrib inconsistency. Standalone 1-patch series (b4 dig shows
only v1).

### Step 3.4: Author Context
**Record:** ZhengYuan Huang is a contributor (not maintainer).
Konstantin Komarov (ntfs3 maintainer) Signed-off-by and queued for merge
per lore reply.

### Step 3.5: Dependencies
**Record:** No dependencies. Uses existing `ni->std_fa`, `cpu_to_le32`,
and `set_new_fa` path. `git apply --check` on commit `b1c1101067d9536`
succeeds cleanly against local tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c b1c1101067d9536bcb0fe023b96ee2dde5535959` →
https://patch.msgid.link/20260427032418.2678198-1-gality369@gmail.com.
Single v1 patch (2026-04-27). Komarov replied 2026-05-22: "Queued for
the next merge window, thank you." No NAKs found.

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: To Komarov; Cc ntfs3@lists.linux.dev, linux-
kernel@vger.kernel.org, co-authors. Maintainer engaged.

### Step 4.3: Bug Report
**Record:** Stack trace embedded in commit message (KASAN oops). No
external bugzilla/syzbot link. Reproducible via setxattr sequence +
write syscall.

### Step 4.4: Series Context
**Record:** Standalone patch, not part of multi-patch series.

### Step 4.5: Stable List
**Record:** No stable@vger.kernel.org nomination found in available
thread content. Not a negative signal.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `ntfs_setxattr()`, `ni_new_attr_flags()`, `is_compressed()`,
`ntfs_file_write_iter()`, `generic_perform_write()`.

### Step 5.2: Callers
**Record:** `ntfs_setxattr` registered as `.set` in
`ntfs_other_xattr_handler` (xattr.c:1054-1058), reachable from VFS
`setxattr`/`fsetxattr` syscalls. `ntfs_file_write_iter` reachable from
`write()`/`pwrite()` syscalls.

### Step 5.3: Callees
**Record:** `system.ntfs_attrib` path calls `ni_new_attr_flags()` which
sets `i_mapping->a_ops`. `system.dos_attrib` path skips that and goes
directly to `set_new_fa`.

### Step 5.4: Reachability
**Record:** **Userspace-reachable.** Any file owner on a writable ntfs3
mount can set `system.ntfs_attrib` and `system.dos_attrib` (no
`CAP_SYS_ADMIN` check for these names; only `$LX*` xattrs are restricted
at xattr.c:958-962). Then `write()` triggers the crash.

### Step 5.5: Similar Patterns
**Record:** `system.ntfs_attrib` path correctly calls
`ni_new_attr_flags()` for regular files. Only `system.dos_attrib`
bypasses it while being able to clear non-DOS bits — the inconsistency
is unique to this code path.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is **6.18.44** (`git describe HEAD` →
`v6.18.44-1-gef4bf62bccf3c`). Buggy code at xattr.c:870: `new_fa =
cpu_to_le32(*(u8 *)value)`. Fix commit `b1c1101067d9536` is NOT an
ancestor of HEAD (`git merge-base --is-ancestor` exit 1). ntfs3
subsystem fully present.

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git apply --check` on the upstream diff
succeeds with no conflicts. Line numbers match (867-872 region).

### Step 6.3: Related Fixes Already Present?
**Record:** No existing fix for this issue found via `git log --grep`.
Recent ntfs3 stable fixes address other corruption paths but not this
xattr inconsistency.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** **fs/ntfs3** — filesystem driver. **IMPORTANT** (not
universal like VFS core, but any ntfs3 mount user is affected; crash is
kernel-wide once triggered).

### Step 7.2: Activity
**Record:** Highly active — 20+ recent ntfs3 fixes in this tree for
corruption/crash issues, indicating ongoing hardening of a relatively
young driver.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users with ntfs3 mounted read-write (CONFIG_NTFS3). File
owners who can set xattrs on their files.

### Step 8.2: Trigger Conditions
**Record:**
1. `setxattr("system.ntfs_attrib", FILE_ATTRIBUTE_COMPRESSED)` on empty
   regular file
2. `setxattr("system.dos_attrib", <byte without compression bit>)`
3. Buffered `write()` to the file

Also triggerable by corrupted on-disk metadata that sets the same
inconsistent state. Unprivileged local user can trigger via syscalls.

### Step 8.3: Failure Mode
**Record:** **NULL pointer dereference → kernel oops** (supervisor
instruction fetch at address 0). Severity: **CRITICAL** (system crash /
local DoS).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents reproducible kernel crash from common
  syscall path
- **Risk:** VERY LOW — 3-line mask-merge, matches existing getxattr
  semantics
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real NULL pointer dereference with documented KASAN stack trace
- Userspace-triggerable on writable ntfs3 mounts (setxattr + write)
- Bug present since 2021 in code that exists in 6.18.44
- Tiny, obviously correct fix; applies cleanly
- Semantically aligns setxattr with getxattr (low byte only for
  dos_attrib)
- Maintainer reviewed and signed off
- ntfs3 driver actively maintained in stable with similar crash fixes

**AGAINST backport:**
- Commit not yet merged to this tree (candidate evaluation — that's the
  point)
- Affects only ntfs3 users (not all kernel users) — but crash severity
  outweighs narrow scope
- No syzbot/bugzilla report (but stack trace and code analysis confirm
  the bug)

**Unresolved:** None material to the decision.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic verified against code;
   maintainer SOB; KASAN trace confirms failure mode
2. Fixes a real bug? **PASS** — state inconsistency → NULL deref on
   write
3. Important issue? **PASS** — kernel oops / local DoS (CRITICAL)
4. Small and contained? **PASS** — 3 lines, 1 file
5. No new features/APIs? **PASS** — corrects existing xattr semantics
6. Can apply to local tree? **PASS** — clean `git apply --check`

### Step 9.3: Exception Categories
**Record:** Not applicable (not device ID, quirk, DT, build, or docs).
Standard bug-fix category.

### Step 9.4: Decision Rationale
This commit fixes a long-standing inconsistency in ntfs3 xattr handling
that leaves `i_mapping->a_ops` and `ni->std_fa` out of sync, causing a
NULL `write_begin` dereference on buffered writes. The bug exists in the
local 6.18.44 tree, the fix is minimal and correct, and the crash is
reachable from userspace. This meets all stable kernel criteria.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no Fixes/Reported-
  by/Cc:stable tags
- **[Phase 1]** Identified explicit [BUG] with KASAN oops stack trace
- **[Phase 2]** Diff: 3 lines in `ntfs_setxattr()` SYSTEM_DOS_ATTRIB
  path
- **[Phase 2]** Verified `ntfs_aops_cmpr` lacks `write_begin`
  (inode.c:2116-2121)
- **[Phase 2]** Verified `ntfs_aops` has `write_begin` (inode.c:2107)
- **[Phase 2]** Verified `is_compressed()` checks `ni->std_fa`
  (ntfs_fs.h:1034-1037)
- **[Phase 2]** Verified `ntfs_file_write_iter()` branches on
  `is_compressed(ni)` (file.c:1252-1253)
- **[Phase 2]** Verified `generic_perform_write()` calls
  `a_ops->write_begin` unconditionally (filemap.c:4266-4267)
- **[Phase 3]** `git blame`: buggy line from `be71b5cba2e648`
  (2021-08-13)
- **[Phase 3]** `git log -20 -- fs/ntfs3/xattr.c`: no prior dos_attrib
  fix
- **[Phase 3]** `git apply --check` on b1c1101067d9536 diff: **clean
  apply**
- **[Phase 4]** `b4 dig -c b1c1101067d9536`: lore thread found
- **[Phase 4]** `b4 dig -a`: single v1 patch only
- **[Phase 4]** `b4 dig -w`: Komarov (maintainer) in To, ntfs3 list Cc'd
- **[Phase 4]** Openwall lore: Komarov queued for merge, no objections
- **[Phase 5]** Verified xattr handler has no CAP_SYS_ADMIN gate for
  system.* names (xattr.c:867-891 vs 958-962)
- **[Phase 5]** Verified getxattr returns only low byte for dos_attrib
  (xattr.c:781)
- **[Phase 6]** `git describe HEAD`: v6.18.44-1-gef4bf62bccf3c (6.18.y
  tree)
- **[Phase 6]** `git merge-base --is-ancestor b1c1101067d9536 HEAD`:
  exit 1 (fix NOT in tree)
- **[Phase 6]** Buggy code confirmed at xattr.c:870 in local checkout
- **[Phase 8]** Failure mode: NULL deref kernel oops, CRITICAL severity

**YES**

 fs/ntfs3/xattr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index d719e1073dbb1..b6f365849272e 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -867,7 +867,9 @@ static noinline int ntfs_setxattr(const struct xattr_handler *handler,
 	if (!strcmp(name, SYSTEM_DOS_ATTRIB)) {
 		if (sizeof(u8) != size)
 			goto out;
-		new_fa = cpu_to_le32(*(u8 *)value);
+		/* system.dos_attrib only covers the low DOS attribute byte. */
+		new_fa = (ni->std_fa & ~cpu_to_le32(0xff)) |
+			 cpu_to_le32(*(u8 *)value);
 		goto set_new_fa;
 	}
 
-- 
2.53.0

