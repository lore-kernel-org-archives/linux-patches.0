Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A96503BDF;
	Mon, 31 Aug 2026 13:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183727; cv=none; b=YaRGQ0+xM82J1YyanRqZg99EkpVZG5TUG9h15Vbn9rbYr0r5Fmofz0z6Ddt4CzIJvF3w06vTsyiGWHPR8i2HSojSEx0Ds/9BhHYrzuhG7wyz4X0SQTxwV435LT7Lj2djeXhj7+7Q1KnFvRpdWDq59aA8aRwMXx5OaEg7nFpLMig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183727; c=relaxed/simple;
	bh=ErK8VEajhzGycChOxhSNwg67bkKQ1CqjODyFYK6rvao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=POWqxRJfBUmFZYQljm+OnFP08u7hJj6SEK0bypZw4xkUV7nvjC9el9dptqMfLUamSDg24W9jhxn2hzIvaHPe55TiL+OS8N92GQM4JvovlQnBTipcdpPzB/whRVIcOOI8UprzHDozYc2Vo7FJ1pzj6SDVMgN87vE2rFsXvwsOMc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CEevhqv9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEevhqv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE3C1F00A3E;
	Mon, 31 Aug 2026 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183723;
	bh=6bkSnFuT4z0ZDgVR+dCP91I857eDaDQj4JMTa1PfVzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CEevhqv9fM89GIp85XFA22TkS9TQRtCOhiH3Ip+pLMiilItAOGk1NmnUbIM4yV30z
	 weBHBWRKm3Gqv82cNCtBJHVHBN3+GIZseqCO3Y/EYK/dWRkCe4EqwpP3+pJDJijMng
	 P1qBKjE4f5ywTsdQFGgMfdW3hYShwuXFGnmR2UNMQVZRMhPIasRdhazr/WCPEUS8DW
	 yy37k8tXz67MA+JnraYurEVspbHSiP/q42kpuU1CQib55smIaOISoZQikAgf7RLMdc
	 +/UIQWeKax/iKVEpRsNvTFrUpF8jjMmjFpItdEh8g7kH9We+SLL2peLYhYshxNIwsw
	 kBZ4CBMMHdSVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhengYuan Huang <gality369@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] fs/ntfs3: validate index entry key bounds
Date: Mon, 31 Aug 2026 09:24:54 -0400
Message-ID: <20260831133314.4125787-266-sashal@kernel.org>
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

[ Upstream commit 98d6e5d9dc1d34dcffc61549617581a5fe1ef807 ]

[BUG]
A malformed NTFS directory index entry can advertise a key_size larger
than the bytes actually present in its NTFS_DE payload. Directory lookup
then passes that malformed key to cmp_fnames(), which can read past the
end of the kmalloc'ed index buffer.

BUG: KASAN: slab-out-of-bounds in fname_full_size fs/ntfs3/ntfs.h:590 [inline]
BUG: KASAN: slab-out-of-bounds in cmp_fnames+0x1ea/0x230 fs/ntfs3/index.c:46
Read of size 1 at addr ffff88801c313018 by task syz.6.3365/9279

Call Trace:
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xbe/0x130 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xd1/0x650 mm/kasan/report.c:482
 kasan_report+0xfb/0x140 mm/kasan/report.c:595
 __asan_report_load1_noabort+0x14/0x30 mm/kasan/report_generic.c:378
 fname_full_size fs/ntfs3/ntfs.h:590 [inline]
 cmp_fnames+0x1ea/0x230 fs/ntfs3/index.c:46
 hdr_find_e.isra.0+0x3ed/0x670 fs/ntfs3/index.c:762
 indx_find+0x4b5/0x900 fs/ntfs3/index.c:1186
 dir_search_u+0x2c0/0x460 fs/ntfs3/dir.c:254
 ntfs_lookup+0x1cc/0x2a0 fs/ntfs3/namei.c:85
 __lookup_slow+0x241/0x450 fs/namei.c:1816
 lookup_slow fs/namei.c:1833 [inline]
 walk_component+0x31c/0x570 fs/namei.c:2151
 link_path_walk+0x592/0xd60 fs/namei.c:2519
 path_lookupat+0x138/0x660 fs/namei.c:2675
 filename_lookup+0x1f3/0x560 fs/namei.c:2705
 filename_setxattr+0xad/0x1c0 fs/xattr.c:660
 path_setxattrat+0x1d8/0x280 fs/xattr.c:713
 __do_sys_lsetxattr fs/xattr.c:754 [inline]
 __se_sys_lsetxattr fs/xattr.c:750 [inline]
 __x64_sys_lsetxattr+0xd0/0x150 fs/xattr.c:750
 ...

Allocated by task 9279:
 kasan_save_stack+0x39/0x70 mm/kasan/common.c:56
 kasan_save_track+0x14/0x40 mm/kasan/common.c:77
 kasan_save_alloc_info+0x37/0x60 mm/kasan/generic.c:573
 poison_kmalloc_redzone mm/kasan/common.c:400 [inline]
 __kasan_kmalloc+0xc3/0xd0 mm/kasan/common.c:417
 kasan_kmalloc include/linux/kasan.h:262 [inline]
 __do_kmalloc_node mm/slub.c:5650 [inline]
 __kmalloc_noprof+0x2bd/0x900 mm/slub.c:5662
 kmalloc_noprof include/linux/slab.h:961 [inline]
 indx_read+0x41d/0xad0 fs/ntfs3/index.c:1059
 indx_find+0x447/0x900 fs/ntfs3/index.c:1179
 dir_search_u+0x2c0/0x460 fs/ntfs3/dir.c:254
 ntfs_lookup+0x1cc/0x2a0 fs/ntfs3/namei.c:85
 __lookup_slow+0x241/0x450 fs/namei.c:1816
 lookup_slow fs/namei.c:1833 [inline]
 walk_component+0x31c/0x570 fs/namei.c:2151
 link_path_walk+0x592/0xd60 fs/namei.c:2519
 path_lookupat+0x138/0x660 fs/namei.c:2675
 filename_lookup+0x1f3/0x560 fs/namei.c:2705
 filename_setxattr+0xad/0x1c0 fs/xattr.c:660
 path_setxattrat+0x1d8/0x280 fs/xattr.c:713
 __do_sys_lsetxattr fs/xattr.c:754 [inline]
 __se_sys_lsetxattr fs/xattr.c:750 [inline]
 __x64_sys_lsetxattr+0xd0/0x150 fs/xattr.c:750
 ...

[CAUSE]
The index-header validators only validated INDEX_HDR-level geometry.
They did not walk each NTFS_DE to verify entry alignment, subnode
layout, or that key_size fit inside the entry payload. They also
allowed a last sentinel entry to carry a non-zero key_size.

[FIX]
Walk every NTFS_DE in ntfs3's index-header validators and reject
entries with invalid layout, mismatched subnode state, oversized
key_size, or non-zero sentinel keys before lookup or log replay can
consume them.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `fs/ntfs3: validate index entry key bounds`

**Local tree:** `v6.18.44-1-gef4bf62bccf3c` (Linux **6.18.44**)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the Subject Line
**Record:** `[fs/ntfs3]` `[validate]` — Add validation of per-entry
`key_size` bounds in NTFS directory index headers before lookup/log
replay consumes them.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — not in message body (but KASAN stack trace
  identifies syzbot task `syz.6.3365/9279`)
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable:** — none (expected)
- **Signed-off-by:** ZhengYuan Huang, Konstantin Komarov (ignore
  pipeline SOB)

**Notable pattern:** Full KASAN slab-out-of-bounds report with syscall
reachability (`__x64_sys_lsetxattr`).

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** Malformed `NTFS_DE` index entry can advertise `key_size`
  larger than bytes available in the entry payload.
- **Symptom:** `cmp_fnames()` → `fname_full_size()` reads past the end
  of the kmalloc'd index buffer; KASAN slab-out-of-bounds.
- **Root cause:** `index_hdr_check()` and `check_index_header()` only
  validated INDEX_HDR-level geometry, not per-entry `key_size` fit; last
  sentinel entry could have non-zero `key_size`.
- **Version info:** Not specified; bug is in long-standing validation
  code.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised — explicitly labeled `[BUG]` with KASAN trace.
This is a memory-safety validation fix, not cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the Changes
**Record:**
| File | Change | Functions |
|------|--------|-----------|
| `fs/ntfs3/fslog.c` | ~+35 / -10 lines | `check_index_header()` |
| `fs/ntfs3/index.c` | ~+35 / -3 lines | `index_hdr_check()` |

**Scope:** Two-file, surgical validation enhancement (~70 lines total).
No new functions or APIs.

### Step 2.2: Code Flow Change (per hunk)

**`check_index_header()` (fslog.c):**
- **Before:** Walked entries checking `esize >= min_de`, end offset, and
  subnode flag mask; did not validate `key_size`.
- **After:** Also checks 8-byte alignment, cumulative offset bounds via
  `size_add()`, rejects non-last entries with `key_size > data_size`,
  rejects last sentinel with non-zero `key_size`.

**`index_hdr_check()` (index.c):**
- **Before:** Only checked header fields (`off`, `tot`, `end`, minimum
  first-entry size); returned true without walking entries.
- **After:** Full entry walk with same per-entry validations as above,
  using `de_has_vcn(e) != has_subnode`.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds read (memory safety)
- **Mechanism:** `hdr_find_e()` at line 760–762 reads `e_key_len =
  le16_to_cpu(e->key_size)` and passes it to `cmp_fnames(key, key_len, e
  + 1, e_key_len, ctx)`. With inflated `key_size`, `cmp_fnames()` calls
  `fname_full_size(f2)` which reads `fname->name_len` beyond the kmalloc
  buffer boundary.

```760:762:fs/ntfs3/index.c
        e_key_len = le16_to_cpu(e->key_size);

        diff2 = (*cmp)(key, key_len, e + 1, e_key_len, ctx);
```

```46:48:fs/ntfs3/index.c
        fsize2 = fname_full_size(f2);
        if (l2 < fsize2)
                return -1;
```

### Step 2.4: Fix Quality Assessment
**Record:** Fix is obviously correct — standard on-disk structure
validation. Minimal regression risk: only rejects already-malformed data
that would cause OOB reads. Uses existing helpers (`size_add`,
`IS_ALIGNED`, `de_is_last`, `de_has_vcn`). No locking changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame Changed Lines
**Record:**
- `index_hdr_check()` introduced in `0e8235d28f3a0e` (Konstantin
  Komarov, 2022-10-10) — always lacked per-entry `key_size` validation.
- `check_index_header()` core loop from `b46acd6a6a627d` (2021-08-13) —
  walked entries but never checked `key_size`.
- Bug present since ntfs3 driver introduction; affects all 6.18.y users
  with CONFIG_NTFS3.

### Step 3.2: Follow Fixes: Tag
**Record:** No `Fixes:` tag present — N/A.

### Step 3.3: File History for Related Changes
**Record:** Recent ntfs3 hardening series in this tree from same author
(ZhengYuan Huang):
- `50b5e83384e7f` — bound `attr_off` in UpdateResidentValue
- `09fddd52c1b0c` — bound DeleteIndexEntryAllocation memmove
- `be306b8d9143a` — bound NTFS_DE view.data_off
- `908c9243ba309` — depth limit in indx_find_buffer

This commit is standalone; same validation-hardening theme but no series
dependency.

### Step 3.4: Author's Other Commits
**Record:** ZhengYuan Huang is an active ntfs3 hardening contributor.
Konstantin Komarov is original ntfs3 author/maintainer. Both are
credible subsystem contributors.

### Step 3.5: Prerequisites
**Record:** No prerequisites. Uses `size_add`, `IS_ALIGNED`,
`de_has_vcn`, `hdr_has_subnode` — all present in this tree. Patch
applies cleanly against current code (verified: pre-patch functions
match diff context exactly).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Patch Discussion
**Record:** Commit not in local tree; `b4 dig -c` not possible. Subject
search via `b4 dig` returned no match. **UNVERIFIED:** Could not
retrieve lore.kernel.org thread (Anubis bot protection blocked fetch).

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** — could not access mailing list recipients.

### Step 4.3: Bug Report
**Record:** KASAN report embedded in commit message. Trigger path:
`lsetxattr` → `path_lookupat` → `ntfs_lookup` → `dir_search_u` →
`indx_find` → `hdr_find_e` → `cmp_fnames` → OOB. Syzbot task name in
trace (`syz.6.3365`). Severity: reproducible slab OOB from syscall path
on mounted NTFS.

### Step 4.4: Related Patches/Series
**Record:** Part of ongoing ntfs3 on-disk validation hardening;
standalone fix, not "patch X/Y".

### Step 4.5: Stable Mailing List
**Record:** **UNVERIFIED** — lore stable list search blocked.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `index_hdr_check()`, `check_index_header()` (validators);
`hdr_find_e()`, `cmp_fnames()` (vulnerable consumers).

### Step 5.2: Callers
**Record:**
- `index_hdr_check()` ← `index_buf_check()` ← `indx_read()` (every index
  block read) and `indx_init()` (root at mount)
- `check_index_header()` ← `check_index_buffer()`, `check_index_root()`
  (log replay), `hdr_delete_de()` (index delete path)
- `hdr_find_e()` ← `indx_find()` ← `dir_search_u()` ← `ntfs_lookup()`
  and other directory operations

### Step 5.3: Callees
**Record:** Validators use `le16_to_cpu`, `le32_to_cpu`, `size_add`,
`de_is_last`, `de_has_vcn`, `hdr_has_subnode`. No allocation in
validator loops.

### Step 5.4: Call Chain / Reachability
**Record:**
```
userspace syscall (lsetxattr/lookup/open/...)
  → VFS path walk
    → ntfs_lookup()
      → dir_search_u()
        → indx_find()
          → hdr_find_e()  [uses unvalidated key_size]
            → cmp_fnames() → fname_full_size() [OOB read]
```
**Userspace-reachable:** YES — any path lookup on a mounted NTFS with
malformed index data triggers this.

**Gap in current validation:** `indx_read()` calls `index_buf_check()` →
weak `index_hdr_check()` at line 1096, which currently passes malformed
entries through to subsequent `hdr_find_e()` calls.

### Step 5.5: Similar Patterns
**Record:** Multiple prior slab-OOB fixes in ntfs3 backported to stable
in this tree (`731ab1f982880` ntfs_listxattr OOB, `ab84eee4c7ab9`
hdr_delete_de OOB, `b8c44949044e5` indx_insert_into_buffer OOB). Same
bug class, same subsystem, same treatment.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Does Buggy Code Exist?
**Record:** **YES.** Current `index_hdr_check()` (lines 614–627) returns
true after only header-level checks — no entry walk. Current
`check_index_header()` (lines 2609–2649) walks entries but does not
validate `key_size`. Fix is **not** present (`key_size > data_size` grep
returns no matches).

### Step 6.2: Backport Complications
**Record:** Expected **clean apply**. Pre-patch code matches diff
context exactly. No structural refactoring since introduction. Two
functions, same pattern in both files.

### Step 6.3: Related Fixes Already Present?
**Record:** No duplicate fix for this specific `key_size` validation
gap. Related but distinct hardening commits are present (depth limits,
memmove bounds, etc.).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `fs/ntfs3` — filesystem driver. **IMPORTANT** for NTFS3
users; not universal core, but security-relevant when CONFIG_NTFS3_FS is
enabled.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained with frequent validation fixes (10+
syzbot-related ntfs3 commits in this tree's history).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users who mount NTFS volumes with CONFIG_NTFS3_FS (built-in
or module). Includes anyone mounting untrusted/corrupt NTFS images.

### Step 8.2: Trigger Conditions
**Record:** Malformed NTFS directory index with `key_size` exceeding
entry payload, followed by any directory lookup (open, stat, xattr,
etc.). Triggerable by mounting a crafted image. **Unprivileged users**
can trigger via syscalls on mounted filesystem.

### Step 8.3: Failure Mode Severity
**Record:** Slab out-of-bounds read — **HIGH** severity (memory safety,
potential info leak or further exploitation depending on adjacent slab
content; KASAN-detected).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — closes userspace-reachable OOB on common
  filesystem operation path
- **Risk:** VERY LOW — ~70 lines of defensive validation, rejects only
  corrupt data
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backport:**
- Real KASAN slab-out-of-bounds bug with full stack trace
- Userspace-reachable via path lookup syscalls on mounted NTFS
- Syzbot-reproducible (task name in trace)
- Long-standing bug since ntfs3 validation was introduced (2021–2022)
- Small, surgical, obviously correct fix
- No new APIs or features
- Buggy code confirmed present in 6.18.44 tree; fix not yet applied
- Consistent with numerous prior ntfs3 OOB fixes already in stable
- Applies cleanly

**AGAINST backport:**
- Only affects CONFIG_NTFS3_FS users (not all kernel users)
- No independent runtime testing evidence beyond KASAN report in commit
  message

**UNRESOLVED:**
- Mailing list review discussion (lore blocked)
- Whether reviewers explicitly nominated for stable

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is straightforward;
   KASAN provides concrete repro
2. Fixes real bug affecting users? **PASS** — OOB on directory lookup
3. Important issue? **PASS** — memory safety, userspace-triggerable
4. Small and contained? **PASS** — ~70 lines, 2 files
5. No new features/APIs? **PASS** — validation only
6. Can apply to local tree? **PASS** — code exists, clean apply expected

### Step 9.3: Exception Categories
**Record:** Not a device-ID/quirk/DT/doc fix. Standard
security/stability bug fix.

### Step 9.4: Decision Rationale

For Linux **6.18.44**, the vulnerable validation code is present and the
fix is absent. A malformed NTFS index entry with an oversized `key_size`
can cause `hdr_find_e()` to pass an invalid length to `cmp_fnames()`,
resulting in a slab out-of-bounds read on any directory lookup —
reachable from unprivileged syscalls on a mounted NTFS volume. This is
the same class of bug that has been repeatedly backported for ntfs3. The
fix is minimal, self-contained, and closes the validation gap in both
the runtime path (`index_hdr_check`) and log-replay path
(`check_index_header`).

---

## Verification

- **[Phase 1]** Parsed commit message: KASAN slab-OOB,
  `[BUG]`/`[CAUSE]`/`[FIX]` sections, authors Huang/Komarov
- **[Phase 2]** Read diff and current source: 2 files, `index_hdr_check`
  + `check_index_header`, ~70 lines
- **[Phase 2]** Confirmed OOB path: `hdr_find_e:760-762` →
  `cmp_fnames:46-48` → `fname_full_size`
- **[Phase 3]** `git describe HEAD`: v6.18.44-1-gef4bf62bccf3c
- **[Phase 3]** `git blame`: `index_hdr_check` from 0e8235d28f3a0e
  (2022); `check_index_header` loop from b46acd6a6a627d (2021)
- **[Phase 3]** `git log --oneline -20 -- fs/ntfs3/index.c`: related
  Huang hardening commits present; this fix absent
- **[Phase 3]** `git log --grep='validate index entry key bounds'`: no
  match — commit not in tree
- **[Phase 4]** `b4 dig` subject search: no match
- **[Phase 4]** WebFetch lore.kernel.org: blocked by Anubis —
  **UNVERIFIED**
- **[Phase 5]** Traced callers:
  `indx_read→index_buf_check→index_hdr_check`,
  `indx_init→index_hdr_check`, `indx_find→hdr_find_e`
- **[Phase 5]** Traced userspace path:
  `ntfs_lookup→dir_search_u→indx_find` (namei.c:85, dir.c:254)
- **[Phase 6]** Grep `key_size > data_size` in fs/ntfs3: no matches —
  fix not applied
- **[Phase 6]** Read current `index_hdr_check` (614-627) and
  `check_index_header` (2609-2649): buggy code confirmed
- **[Phase 6]** Pre-patch code matches provided diff context — clean
  apply expected
- **[Phase 7]** CONFIG_NTFS3_FS present in fs/ntfs3/Kconfig
- **[Phase 8]** `git log --grep='syzbot' -- fs/ntfs3/`: extensive prior
  syzbot OOB fixes backported to this tree

**YES**The background searches finished and match the earlier analysis:

- **Commit search:** `validate index entry key bounds` is **not** in
  this 6.18.44 tree. Recent `fs/ntfs3/index.c` history shows related
  hardening (depth limits, memmove bounds, etc.), but not this fix.
- **Author search:** ZhengYuan Huang’s commits here are mostly other
  subsystems (ocfs2, btrfs, raid5). The targeted ntfs3 search did find
  his validation work in this tree (`bound attr_off`, `bound
  DeleteIndexEntryAllocation`, etc.).

**Verdict unchanged:** backport **YES** — the vulnerable
`index_hdr_check()` / `check_index_header()` code is present, the fix is
absent, and it closes a userspace-reachable slab OOB on NTFS directory
lookup.

 fs/ntfs3/fslog.c | 26 ++++++++++++++++++++------
 fs/ntfs3/index.c | 37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index a0503a3344237..a23683f2b95fb 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -2608,11 +2608,12 @@ static int read_next_log_rec(struct ntfs_log *log, struct lcb *lcb, u64 *lsn)
 
 bool check_index_header(const struct INDEX_HDR *hdr, size_t bytes)
 {
+	const bool has_subnode = hdr_has_subnode(hdr);
 	__le16 mask;
 	u32 min_de, de_off, used, total;
 	const struct NTFS_DE *e;
 
-	if (hdr_has_subnode(hdr)) {
+	if (has_subnode) {
 		min_de = sizeof(struct NTFS_DE) + sizeof(u64);
 		mask = NTFS_IE_HAS_SUBNODES;
 	} else {
@@ -2629,20 +2630,33 @@ bool check_index_header(const struct INDEX_HDR *hdr, size_t bytes)
 		return false;
 	}
 
-	e = Add2Ptr(hdr, de_off);
+	e = (const struct NTFS_DE *)((const u8 *)hdr + de_off);
 	for (;;) {
 		u16 esize = le16_to_cpu(e->size);
-		struct NTFS_DE *next = Add2Ptr(e, esize);
+		u16 key_size = le16_to_cpu(e->key_size);
+		u16 data_size;
 
-		if (esize < min_de || PtrOffset(hdr, next) > used ||
+		if (!IS_ALIGNED(esize, 8) || esize < min_de ||
 		    (e->flags & NTFS_IE_HAS_SUBNODES) != mask) {
 			return false;
 		}
 
-		if (de_is_last(e))
+		if (size_add(de_off, esize) > used)
+			return false;
+
+		if (de_is_last(e)) {
+			if (key_size)
+				return false;
+
 			break;
+		}
+
+		data_size = esize - min_de;
+		if (key_size > data_size)
+			return false;
 
-		e = next;
+		de_off += esize;
+		e = (const struct NTFS_DE *)((const u8 *)hdr + de_off);
 	}
 
 	return true;
diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index a9c5dcc23a5ce..dd54c966babca 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -613,16 +613,51 @@ static const struct NTFS_DE *hdr_insert_head(struct INDEX_HDR *hdr,
  */
 static bool index_hdr_check(const struct INDEX_HDR *hdr, u32 bytes)
 {
+	const bool has_subnode = hdr_has_subnode(hdr);
+	const u16 min_size = sizeof(struct NTFS_DE) +
+			     (has_subnode ? sizeof(u64) : 0);
 	u32 end = le32_to_cpu(hdr->used);
 	u32 tot = le32_to_cpu(hdr->total);
 	u32 off = le32_to_cpu(hdr->de_off);
+	const struct NTFS_DE *e;
 
 	if (!IS_ALIGNED(off, 8) || tot > bytes || end > tot ||
-	    size_add(off, sizeof(struct NTFS_DE)) > end) {
+	    size_add(off, min_size) > end) {
 		/* incorrect index buffer. */
 		return false;
 	}
 
+	/* Ensure every key stays inside its entry before lookup walks it. */
+	e = (const struct NTFS_DE *)((const u8 *)hdr + off);
+	for (;;) {
+		u16 e_size = le16_to_cpu(e->size);
+		u16 key_size = le16_to_cpu(e->key_size);
+		u16 data_size;
+
+		if (!IS_ALIGNED(e_size, 8) || e_size < min_size ||
+		    de_has_vcn(e) != has_subnode) {
+			/* incorrect index entry. */
+			return false;
+		}
+
+		if (size_add(off, e_size) > end)
+			return false;
+
+		if (de_is_last(e)) {
+			if (key_size)
+				return false;
+
+			break;
+		}
+
+		data_size = e_size - min_size;
+		if (key_size > data_size)
+			return false;
+
+		off += e_size;
+		e = (const struct NTFS_DE *)((const u8 *)hdr + off);
+	}
+
 	return true;
 }
 
-- 
2.53.0

