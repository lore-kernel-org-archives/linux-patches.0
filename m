Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706885440B7;
	Mon, 19 Oct 2026 13:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418189; cv=none; b=V6FHvtVS8928PXS7jwJfKfqmE/oMUqNrnnhB61vA5d0fbc0Xbv5kfej/6kXFmE0sG3tlMUJSlopE2YWTH3/j7CYWhZwGC9E1otn41gwE6H0/FIFyHjJ+N7+LQ2DRd+bmSKm7rjSV+Ud3PITbvPCrlNzsgY3F3ShzjDdA6bAZqrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418189; c=relaxed/simple;
	bh=Su7odCwld2ZEjjMbvsIuAfENW70V/LsYaDrgciEWvtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u9p7F9maHicTOQPeCz2UB69urLhkn9c2n5XOigZ8zdBUn2yF3tDGfwMXJISc4A7wFMzJu+E5fFCUSyEboCm1N6UOOlE+oPsmEsHbgEcrWLJZPhiRG5wEjUrgQUhOztQA79K1V1FIJb9pHpYMl5XzuRuS6rCyN+PyOyte2T8xc1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnAchmJu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnAchmJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE1C1F000C7;
	Mon, 19 Oct 2026 13:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418186;
	bh=IADk5RTBOjulE82dL7hv754PZj7PHSe/oQHD0jA6uiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnAchmJuKWxMjqrZ70rMAeemhFBNJZwEb7A9EofkYIvYL+sd7cSl3yuLG4teHT/nU
	 0tpeE9qFFJNc2rDAx+H0VocfFDakI1kzTW1cI9aqxn/NoA4Mk0ollcpj2oq4pb5HZE
	 0qvuJqN3RAPHGT4vLJLBoc3gXSDX3hJOKNE1zL/h8ZxvowPQAZ+djNJCjEDgyTgQWB
	 e1D92CnkUeVqtXw6ebZWzt7rQLTEtRBpv6PueXkH2frMp+HgvPR3+zZr9uBnEriXAm
	 bsO/Ecj0cJB2VJMrmhlJ8le7YLlAE/TLpO4ChvldKfB4eTmRi3v53b6JXj/5VPDd+5
	 jbMSrS9eTqPrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Maximiliano Hermitte <davemadmaxxx@gmail.com>,
	syzbot+97e301b4b82ae803d21b@syzkaller.appspotmail.com,
	George Anthony Vernon <contact@gvernon.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>,
	frank.li@vivo.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] hfs: validate catalog CNIDs before instantiating inodes
Date: Mon, 19 Oct 2026 09:46:04 -0400
Message-ID: <20261019135441.1420968-73-sashal@kernel.org>
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

From: David Maximiliano Hermitte <davemadmaxxx@gmail.com>

[ Upstream commit 53c3c138d672765c26884c55728307a65c634328 ]

hfs_cat_find_brec() first resolves a catalog thread record by CNID and
then looks up the corresponding catalog record by parent/name. On a
corrupted filesystem image, the second lookup may find a record whose
CNID does not match the CNID that was requested.

Validate the record found by the second lookup before returning it.
Read the already-found record with hfs_bnode_read(), require the exact
fixed size for file and directory records, reject other record types,
and verify that the stored CNID matches the requested CNID.

Also validate reserved CNIDs in hfs_read_inode() before populating the
inode, propagate hfs_read_inode() failures from the resource-fork lookup
path, and reject bad resource-fork and root inodes.

Keep hfs_write_inode() unchanged, so corrupted catalog records are
rejected before reaching its existing reserved-CNID BUG() path.

Reported-by: syzbot+97e301b4b82ae803d21b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=97e301b4b82ae803d21b
Cc: George Anthony Vernon <contact@gvernon.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: David Maximiliano Hermitte <davemadmaxxx@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260708215636.73815-1-davemadmaxxx@gmail.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
commit is `53c3c138d6727` and is already in this mainline history (first
contained in `v7.3-rc1`). The evaluation below is whether that fix is
suitable to take into stable from this tree: HFS is present, the `BUG()`
path is ancient, and the patch is self-contained.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[hfs] [validate] Validate catalog CNIDs before instantiating
inodes** — “validate” here is a correctness/safety check, not a feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Reported-by:** syzbot+97e301b4b82ae803d21b@syzkaller.appspotmail.com
  (fuzzer, reproducible)
- **Closes:**
  https://syzkaller.appspot.com/bug?extid=97e301b4b82ae803d21b
- **Cc:** George Anthony Vernon, Tetsuo Handa
- **Signed-off-by:** David Maximiliano Hermitte (author); Viacheslav
  Dubeyko (HFS maintainer, twice)
- **Reviewed-by:** Viacheslav Dubeyko
- **Link:** https://lore.kernel.org/r/20260708215636.73815-1-
  davemadmaxxx@gmail.com
- **No Fixes:** tag (expected)
- **No Cc: stable** (expected; not a negative)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `hfs_cat_find_brec()` resolves a thread by CNID, then looks
  up the catalog record by parent/name. On a corrupted image that second
  lookup can return a record whose stored CNID does not match the
  requested CNID.
- **Symptom/failure mode:** A corrupted catalog record is turned into an
  inode with a reserved CNID (`i_ino < HFS_FIRSTUSER_CNID` and not
  root/extents/catalog). Later writeback hits `BUG()` in
  `hfs_write_inode()`.
- **Version info:** none in the message; syzbot first crash is
  2022-11-25.
- **Root cause (author):** missing validation of the second catalog
  lookup, plus missing reserved-CNID checks at inode instantiation;
  resource-fork lookup ignored `hfs_read_inode()` failures.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. Explicit syzbot crash fix: reject bad
catalog records so they never reach the reserved-CNID `BUG()`.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `fs/hfs/catalog.c`: +40 / -1 — add `hfs_cat_validate_found_cnid()`,
  call it from `hfs_cat_find_brec()`
- `fs/hfs/hfs_fs.h`: +19 — add inline `hfs_is_valid_cnid()`
- `fs/hfs/inode.c`: +12 / -1 — CNID checks in `hfs_read_inode()`;
  propagate errors and `is_bad_inode()` in `hfs_file_lookup()`
- `fs/hfs/super.c`: +5 — reject bad root inode in `hfs_fill_super()`
- **Total:** +76 / -2 across 4 HFS files
- **Scope:** single-subsystem surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **`hfs_cat_find_brec`:** Before: thread lookup, then `return
  hfs_brec_find(fd)` with no check that the found record’s CNID matches.
  After: on success, read the found record, require exact file/dir size,
  reject other types, require `found_cnid == cnid`, else `-EIO`.
- **`hfs_read_inode`:** Before: populate inode from any file/dir record,
  including reserved CNIDs 0,1,5–15. After: `hfs_is_valid_cnid()`;
  invalid → `-EIO` before `i_ino` is set.
- **`hfs_file_lookup` (rsrc):** Before: ignored `hfs_read_inode()`
  return, then `mark_inode_dirty()`. After: propagate errors;
  `is_bad_inode()` → `-EIO` + `iput`.
- **`hfs_fill_super`:** After `hfs_iget()`, `is_bad_inode(root)` →
  `iput` and fail mount instead of `d_make_root()` on a bad inode.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** memory-safety / logic — corrupted on-disk metadata →
  kernel `BUG()` (oops, invalid opcode).
- **Mechanism:** Reserved CNIDs instantiated as normal inodes; writeback
  `hfs_write_inode()` does `BUG()` in the default branch of
  `inode->i_ino < HFS_FIRSTUSER_CNID`. Also bounds/type checks on
  catalog record length.
- **Not:** leak, UAF, or locking fix.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct relative to HFS CNID rules: user CNIDs ≥ 16;
  reserved 2=root dir, 3=extents file, 4=catalog file; others invalid
  for catalog-instantiated inodes.
- `iget5_locked` `set()` returning non-zero → `inode_insert5()` returns
  NULL; `hfs_iget()` already treats NULL as failure.
- New `hfs_read_inode()` code does not sleep (safe under
  `inode_hash_lock`).
- Maintainer asked to leave `hfs_write_inode()` unchanged; defense is at
  instantiation. Remaining `BUG()` is only if some other path still
  creates a reserved-CNID inode.
- **Regression risk:** low. Could reject a theoretically weird volume
  with catalog entries using CNIDs 1 or 5–15; that is invalid HFS and
  those inodes would `BUG()` on writeback anyway.
- No public API / data-structure change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: `hfs_write_inode()` reserved-CNID `BUG()` and
`hfs_cat_find_brec()` date to **1da177e4c3f41 (Linux-2.6.12-rc2,
2005)**. Long-standing, not a newly introduced bug.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Buggy behavior is original HFS catalog/inode
code, not a recent regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Nearby HFS work (`hfs_correct_next_unused_CNID`, MDB locking) is
independent. This commit is standalone, not `patch X/Y`. After it, later
`fs/hfs/{inode,catalog,super,hfs_fs.h}` commits are unrelated (MDB,
delayed work, ENOSPC). No follow-up fix to this patch.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Only this HFS commit from David Maximiliano Hermitte. Weight
comes from **Reviewed-by / Signed-off-by Viacheslav Dubeyko** (HFS
maintainer). Earlier related attempts: George Vernon, Tetsuo Handa
(syzbot thread).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses existing `hfs_bnode_read()`, `hfs_brec_find()`,
`is_bad_inode()`, `HFS_*_CNID`, `hfs_read_inode()` already returning
`int` since 2.6.12. **Can apply standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **b4 dig:**
  https://patch.msgid.link/20260708215636.73815-1-davemadmaxxx@gmail.com
- **Revisions:** v1 (2026-07-02) → v3 RESEND → v4 → **v5 (applied)**
- Maintainer review drove exact size checks, signed `rec_len`, keep
  `hfs_write_inode()` unchanged, preserve `hfs_file_lookup()` error
  codes
- v5: Slava: “Looks good. Thanks a lot for the fix.” + Reviewed-by
- Tetsuo: not a NAK; points at sashiko notes on *pre-existing* issues
- Author revalidated with HFS build and QEMU syzbot repro
- **No NAKs** of the committed approach

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (b4 dig -w): Viacheslav Dubeyko, Tetsuo Handa, George Vernon,
Jori Koolstra, linux-fsdevel, syzbot. Maintainer reviewed and merged.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record (syzbot, live page):
- Title: **kernel BUG in hfs_write_inode**
- First crash: **2022-11-25**; last listed ~35d before the page
  snapshot; **243695 crashes**; C and syz reproducers
- Stack: `hfs_write_inode` ← writeback `wb_workfn` (kworker), invalid
  opcode at `BUG()`
- Security assessment: DenialOfService yes, FilesystemTrigger yes,
  **Unprivileged: no** (needs a mountable image)
- Duplicate: “invalid opcode in hfs_write_inode”
- Fix commit listed as `53c3c138d672`

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Single-patch series (v1–v5 of the same change). Earlier
alternate approaches (replace `BUG()` with `-EIO`/`-EFSCORRUPTED`,
broader `BUG()` removal) were **not** what merged; this validation-at-
instantiation patch is standalone.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — lore.kernel.org fetches returned 403. No `Cc:
stable` in the fsdevel thread. That absence is not a reason to reject.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `hfs_cat_validate_found_cnid` (new), `hfs_cat_find_brec`,
`hfs_is_valid_cnid` (new inline), `hfs_read_inode`, `hfs_file_lookup`,
`hfs_fill_super`. `hfs_write_inode` unchanged.

**Step 5.2: TRACE CALLERS**
Record:
- `hfs_cat_find_brec()` — only `hfs_fill_super()` (root at mount)
- `hfs_read_inode()` — `iget5_locked` set callback from `hfs_iget()`
  (`hfs_lookup` / `hfs_fill_super`) and direct call from
  `hfs_file_lookup()` (rsrc)
- `hfs_write_inode()` — `s_op->write_inode` from writeback (crash site)

**Step 5.3: TRACE CALLEES**
Record: `hfs_bnode_read`, `hfs_brec_find`, `be32_to_cpu`,
`is_bad_inode`, `iput`. No new allocations/locks.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from **mounting an HFS image** and from **lookup /
rsrc** on a mounted volume. Syzbot C repro mounts a crafted image;
writeback then `BUG()`s. Userspace-triggerable if the caller can mount
HFS (`CONFIG_HFS_FS`).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: HFS+ already special-cases reserved vs user CNIDs in
`hfsplus_iget()` (`fs/hfsplus/super.c`). Classic HFS lacked that for
catalog-instantiated inodes. Same class of bug, HFS-only fix.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `BUG()` still in `hfs_write_inode()` at `fs/hfs/inode.c`
(lines 479–491), present since 2.6.12. Validation from this commit is
already applied here (`hfs_is_valid_cnid` in `hfs_fs.h`,
`hfs_cat_validate_found_cnid` in `catalog.c`). Introduced: original HFS
port, not post-7.3.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Expected apply: clean / minor context** on trees that still
have `hfs_cat_find_brec`, `hfs_read_inode`, `hfs_file_lookup`,
`hfs_fill_super`. New code does not depend on `inode_set_ctime_to_ts`,
`set_default_d_op`, or CNID-correction helpers. Constants live in
`include/linux/hfs_common.h` here; older trees may still have them in
`fs/hfs/hfs.h` — only a context/include issue, not a logic dependency.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This is the fix (`53c3c138d6727`). No earlier equivalent in-
tree. Not in `v7.2`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **fs/hfs** — **PERIPHERAL** (legacy Mac HFS, `CONFIG_HFS_FS`,
not the VFS core). Still a real on-disk filesystem; a `BUG()` on
corrupted images is a kernel crash, not a cosmetic warning.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained under Viacheslav Dubeyko (`hfs-v7.3-tag1`
and other recent HFS tags). Mature code with ongoing syzbot/hardening.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Config/driver-specific:** `CONFIG_HFS_FS`. Anyone who can
mount HFS (including fuzzers, forensic mounts, old Mac volumes). Not
universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Mount / use a **corrupted HFS image**. Syzbot has a C repro;
240k+ crashes over ~4 years. Not unprivileged without mount capability.
Timing-independent once the bad inode is instantiated and dirtied
(`hfs_file_lookup` does `mark_inode_dirty` on rsrc).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **`BUG()` / invalid opcode in writeback kworker → oops.**
**Severity: CRITICAL** (kernel crash). DoS, not a demonstrated
privilege-escalation.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** high for HFS users and any tree that enables HFS — stops
  a years-old reproducible `BUG()`.
- **Risk:** low — +76 lines, HFS-only, reviewed, tested with QEMU repro;
  failure mode on bad images becomes `-EIO` / failed mount instead of
  oops.
- **Ratio:** strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Syzbot kernel `BUG()` since 2022, C repro, hundreds of thousands of
  crashes
- Crash in writeback (`wb_workfn` → `hfs_write_inode`)
- Small, contained HFS-only change (+76/-2)
- Maintainer Reviewed-by after v1–v5
- Bug in code since 2.6.12; no missing prerequisites in this tree
- Matches stable rules: real crash, obviously correct validation, no new
  API

**AGAINST:**
- HFS is a legacy/peripheral FS
- Needs ability to mount HFS (not unprivileged syscall-only)
- `hfs_write_inode()` `BUG()` remains as a backstop if another path
  instantiates a reserved CNID
- No `Cc: stable` (expected for this review queue)

**UNRESOLVED:**
- lore.kernel.org/stable search (HTTP 403)
- Whether every older stable series has identical hunk context
  (`hfs_common.h` vs `hfs.h`)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — maintainer review, QEMU
   repro, syzbot
2. Fixes a real bug that affects users? **PASS** — reproducible `BUG()`
   on corrupted HFS
3. Important issue? **PASS** — kernel oops (CRITICAL)
4. Small and contained? **PASS** — 4 files, +76/-2, HFS only
5. No new features or APIs? **PASS** — validation only
6. Can apply to the local tree? **PASS** — code is present; patch is
   self-contained (already merged here as of 7.3-rc1)

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not ID/quirk/DT/docs. Ordinary **crash fix** on filesystem
corruption.

**Step 9.4: MAKE YOUR DECISION**
This is a real, long-standing, syzbot-reproduced kernel `BUG()` on
corrupted HFS catalog data. The fix is small, reviewed, and stops bad
CNIDs from becoming inodes that writeback will crash on. That is
appropriate for stable.

---

### What the commit solves and why it matters
On a corrupted HFS catalog, a thread lookup by CNID can be followed by a
parent/name lookup that returns a **different** record. That record can
carry a reserved CNID (0, 1, 5–15, …). Instantiating it and dirtying it
(notably the resource-fork path, which previously ignored
`hfs_read_inode()` errors) causes **writeback to `BUG()`** in
`hfs_write_inode()`. Stable kernels that still ship HFS will oops the
same way; rejecting the record with `-EIO` is the right user-visible
behavior.

### Stable rules / risk
Surgical, HFS-only, no new APIs, maintainer-acked, fuzzer-proven.
Residual risk is failing mount/lookup on already-invalid volumes that
used to oops instead.

### Concerns
Older trees may need a trivial context tweak if CNID macros are still in
`fs/hfs/hfs.h`. No semantic prerequisites. The remaining `BUG()` in
`hfs_write_inode()` is intentional per the maintainer.

### Verification
- **[Phase 1]** Tags: syzbot Reported-by, Closes syzkaller URL,
  Reviewed-by Dubeyko, lore Link; no Fixes/Cc-stable
- **[Phase 2]** Diff: +76/-2 in catalog.c, hfs_fs.h, inode.c, super.c;
  validation + error propagation
- **[Phase 3]** `git describe HEAD` → v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` → 7.3.0-rc4
- **[Phase 3]** Commit `53c3c138d6727`; `git merge-base --is-ancestor
  53c3c138d6727 HEAD` → yes
- **[Phase 3]** `git merge-base --is-ancestor 53c3c138d6727 v7.2` → not
  in v7.2; `git describe --contains` → v7.3-rc1~222^2~9
- **[Phase 3]** Blame: `BUG()` in `hfs_write_inode` from 1da177e4c3f41
  (2.6.12-rc2)
- **[Phase 3]** `hfs_read_inode` already `static int` since 2.6.12; pre-
  fix `hfs_file_lookup` discarded its return value
- **[Phase 4]** `b4 dig -c 53c3c138d6727` → msgid
  20260708215636.73815-1; v1/v3/v4/v5; v5 applied
- **[Phase 4]** `b4 dig -w`: Dubeyko, Handa, fsdevel, syzbot
- **[Phase 4]** `b4 dig -m`: Slava “Looks good” + Reviewed-by; asked to
  leave `hfs_write_inode` unchanged
- **[Phase 4]** WebFetch syzbot: kernel BUG in hfs_write_inode,
  2022-11-25, C repro, 243695 crashes
- **[Phase 4]** lore.kernel.org WebFetch: 403 — stable-list search
  UNVERIFIED
- **[Phase 5]** Callers: `hfs_cat_find_brec` only from `hfs_fill_super`;
  `hfs_iget` from dir lookup + mount; rsrc via `hfs_file_lookup`
- **[Phase 5]** `inode_insert5()` treats failed `set()` as NULL inode
  (verified `fs/inode.c`)
- **[Phase 6]** Local files already contain the new helpers; `BUG()`
  path still present
- **[Phase 8]** Failure mode: oops in kworker writeback, severity
  CRITICAL
- **UNVERIFIED:** stable@ discussion (lore 403); exact hunk context on
  every LTS series

**YES**

 fs/hfs/catalog.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 fs/hfs/hfs_fs.h  | 19 +++++++++++++++++++
 fs/hfs/inode.c   | 13 ++++++++++++-
 fs/hfs/super.c   |  5 +++++
 4 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
index ccdbbffaaf7c1..f3fd84cffed5f 100644
--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -182,6 +182,40 @@ int hfs_cat_keycmp(const btree_key *key1, const btree_key *key2)
 			  key2->cat.CName.name, key2->cat.CName.len);
 }
 
+static int hfs_cat_validate_found_cnid(struct hfs_find_data *fd, u32 cnid)
+{
+	hfs_cat_rec rec;
+	u32 found_cnid;
+	int rec_len;
+
+	rec_len = fd->entrylength;
+	if (rec_len <= 0 || (size_t)rec_len > sizeof(rec))
+		return -EIO;
+
+	memset(&rec, 0, sizeof(rec));
+	hfs_bnode_read(fd->bnode, &rec, fd->entryoffset, rec_len);
+
+	switch (rec.type) {
+	case HFS_CDR_FIL:
+		if ((size_t)rec_len != sizeof(struct hfs_cat_file))
+			return -EIO;
+		found_cnid = be32_to_cpu(rec.file.FlNum);
+		break;
+	case HFS_CDR_DIR:
+		if ((size_t)rec_len != sizeof(struct hfs_cat_dir))
+			return -EIO;
+		found_cnid = be32_to_cpu(rec.dir.DirID);
+		break;
+	default:
+		return -EIO;
+	}
+
+	if (found_cnid != cnid)
+		return -EIO;
+
+	return 0;
+}
+
 /* Try to get a catalog entry for given catalog id */
 // move to read_super???
 int hfs_cat_find_brec(struct super_block *sb, u32 cnid,
@@ -208,7 +242,12 @@ int hfs_cat_find_brec(struct super_block *sb, u32 cnid,
 		return -EIO;
 	}
 	memcpy(fd->search_key->cat.CName.name, rec.thread.CName.name, len);
-	return hfs_brec_find(fd);
+
+	res = hfs_brec_find(fd);
+	if (res)
+		return res;
+
+	return hfs_cat_validate_found_cnid(fd, cnid);
 }
 
 static inline
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 86b5ae62247be..724b28bb8c6c4 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -156,6 +156,25 @@ extern int hfs_cat_move(u32 cnid, struct inode *src_dir,
 extern void hfs_cat_build_key(struct super_block *sb, btree_key *key,
 			      u32 parent, const struct qstr *name);
 
+/*
+ * Validate the CNID of a catalog record.
+ */
+static inline bool hfs_is_valid_cnid(u32 cnid, u8 type)
+{
+	if (likely(cnid >= HFS_FIRSTUSER_CNID))
+		return true;
+
+	switch (cnid) {
+	case HFS_ROOT_CNID:
+		return type == HFS_CDR_DIR;
+	case HFS_EXT_CNID:
+	case HFS_CAT_CNID:
+		return type == HFS_CDR_FIL;
+	default:
+		return false;
+	}
+}
+
 /* dir.c */
 extern const struct file_operations hfs_dir_operations;
 extern const struct inode_operations hfs_dir_inode_operations;
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index f1796e4b07e83..e815e9a8ac6f2 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -365,6 +365,9 @@ static int hfs_read_inode(struct inode *inode, void *data)
 	rec = idata->rec;
 	switch (rec->type) {
 	case HFS_CDR_FIL:
+		if (!hfs_is_valid_cnid(be32_to_cpu(rec->file.FlNum), rec->type))
+			return -EIO;
+
 		if (!HFS_IS_RSRC(inode)) {
 			hfs_inode_read_fork(inode, rec->file.ExtRec, rec->file.LgLen,
 					    rec->file.PyLen, be16_to_cpu(rec->file.ClpSize));
@@ -386,6 +389,9 @@ static int hfs_read_inode(struct inode *inode, void *data)
 		inode->i_mapping->a_ops = &hfs_aops;
 		break;
 	case HFS_CDR_DIR:
+		if (!hfs_is_valid_cnid(be32_to_cpu(rec->dir.DirID), rec->type))
+			return -EIO;
+
 		inode->i_ino = be32_to_cpu(rec->dir.DirID);
 		inode->i_size = be16_to_cpu(rec->dir.Val) + 2;
 		HFS_I(inode)->fs_blocks = 0;
@@ -565,13 +571,18 @@ static struct dentry *hfs_file_lookup(struct inode *dir, struct dentry *dentry,
 	res = hfs_brec_read(&fd, &rec, sizeof(rec));
 	if (!res) {
 		struct hfs_iget_data idata = { NULL, &rec };
-		hfs_read_inode(inode, &idata);
+		res = hfs_read_inode(inode, &idata);
 	}
 	hfs_find_exit(&fd);
 	if (res) {
 		iput(inode);
 		return ERR_PTR(res);
 	}
+
+	if (is_bad_inode(inode)) {
+		iput(inode);
+		return ERR_PTR(-EIO);
+	}
 	HFS_I(inode)->rsrc_inode = dir;
 	HFS_I(dir)->rsrc_inode = inode;
 	igrab(dir);
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 97546d6b41f47..933aa04480899 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -372,6 +372,11 @@ static int hfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (!root_inode)
 		goto bail_no_root;
 
+	if (is_bad_inode(root_inode)) {
+		iput(root_inode);
+		goto bail_no_root;
+	}
+
 	set_default_d_op(sb, &hfs_dentry_operations);
 	res = -ENOMEM;
 	sb->s_root = d_make_root(root_inode);
-- 
2.53.0

