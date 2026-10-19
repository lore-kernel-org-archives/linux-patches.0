Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C576084A8;
	Mon, 19 Oct 2026 14:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418608; cv=none; b=UCKtjJQJ9hK6j4xCJheKiJvXbX5bCaJ35eK8R4A8N1TVqZnYCfD3lQo+xG1ooLKRF9O9vuFuvMjmq6zIF1F9xhPXWTaEyfL28k8BlKxcNl5SSFLZQOS7PFiKlnyZyk1wwaIIYY+KAmeu+/zmzREDnWEJmdx5rM/FS64eHoShr6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418608; c=relaxed/simple;
	bh=5QRl7BX3YpiojXh2pE0ZlOHiQypdjv7gvEL8for7rrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oh0Xpr88l82J7fCr5oBm62R8DrhMawBk+JleWPplHbl3fobpLyhJ/7JT8IecX68iZFMq/gztzzsKVzYCuNbWJGsipSU9s0b+d4UehrEYYQyT+B+x1JMssVWGRnyv467Rn5yl1sMTUCXzlM/++9YXbgESdjI14CUAN496DTBxPIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ksdl2Fz8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksdl2Fz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526D31F000C5;
	Mon, 19 Oct 2026 14:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418605;
	bh=ZOoa3I7RJdQVV4M/T4G5/lPnov2/TcGipFrQwjqbOE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksdl2Fz8A8Hc+CTtxrF0P96dokeD/bI6cm7ymr+P2fWOecfr6bCpqkqqni1mdvqvo
	 4SW6jcU08dMlzOMRf0sBK069hguWleHjold9OVsD9G7yvC5b6xk53qVJsCFK22WXlA
	 ns/dwItE0FaHwZzGxdLbPsg9gCQcW/gY2qLO8FbKloaBKb0zs2yBbzDptDzN0QyYlE
	 GDOZ1E97OiSTac80/4U45gMM0M4XrN5/sX76XHJSYmO+XsHJ+DsH4gwrtNuqE8qfiA
	 lACv5nBe1ChjcRjW8xgi5m9ihrALu8NOs7mpshVOkhI8+UTDLzY7orfDvFgbajxnex
	 gVNCWIkBaOyoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiaming Zhang <r772577952@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>,
	frank.li@vivo.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] hfsplus: validate extent record length before writing it back
Date: Mon, 19 Oct 2026 09:50:58 -0400
Message-ID: <20261019135441.1420968-367-sashal@kernel.org>
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

From: Jiaming Zhang <r772577952@gmail.com>

[ Upstream commit 627b7865c062ff642c0000f3a4775f1a44b986a4 ]

__hfsplus_ext_write_extent() writes the cached extent record back into a
B-tree node using fd->entrylength as the length, and fd->entrylength is
derived in __hfs_brec_find() from two on-disk values:

	fd->entrylength = len - keylen;

A crafted image can keep both len and keylen valid but make fd->entrylength
negative (keylen > len). __hfsplus_ext_write_extent() doesn't check
fd->entrylength before consuming it, and hfs_bnode_write() takes the length
as u32, so the negative value turns into a huge one. The copy then reads
data past the end of hip->cached_extents, which is only
sizeof(hfsplus_extent_rec) bytes long, and leaks kernel memory into the
image.

Reject an fd->entrylength that does not match sizeof(hfsplus_extent_rec) in
__hfsplus_ext_write_extent(), mirroring the check already performed in
__hfsplus_ext_read_extent().

Link: https://lore.kernel.org/lkml/cbd7003314c530d4f910eacf019ff80adad6687e.camel@dubeyko.com/
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260810092422.1691377-1-r772577952@gmail.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The two-line write-side
length check is missing here, the buggy path is present, and the patch
applies cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[hfsplus] [validate] [reject a corrupt overflow-extent record
length before writing it back into the extents B-tree]**

- Subsystem: `hfsplus`
- Verb: “validate” — a missing safety check, not a feature
- Intent: stop `__hfsplus_ext_write_extent()` from using an on-disk
  `entrylength` that does not match `sizeof(hfsplus_extent_rec)`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Mainline commit: `627b7865c062ff642c0000f3a4775f1a44b986a4` (not in this
tree).

Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Viacheslav Dubeyko `<slava@dubeyko.com>` (HFS/HFS+
  maintainer)
- **Acked-by:** none
- **Link:** `https://lore.kernel.org/lkml/cbd7003314c530d4f910eacf019ff8
  0adad6687e.camel@dubeyko.com/` (maintainer discussion that prompted
  the patch)
- **Link:** `https://lore.kernel.org/r/20260810092422.1691377-1-
  r772577952@gmail.com` (patch submission)
- **Cc: stable:** none (expected)
- **Signed-off-by:** Jiaming Zhang (author); Viacheslav Dubeyko
  (maintainer)

Notable: the sent patch CCs `syzkaller@googlegroups.com`. No explicit
syzbot hash in the committed message.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `__hfs_brec_find()` sets `fd->entrylength = len - keylen`
  from two on-disk u16s. A crafted node can keep both values “valid”
  while `keylen > len`, so `entrylength` is negative.
- **Symptom:** `__hfsplus_ext_write_extent()` passes that signed length
  into `hfs_bnode_write()`, which takes `u32 len`. The negative value
  becomes a huge length. The copy reads past `hip->cached_extents` (only
  `sizeof(hfsplus_extent_rec)` bytes) and **writes kernel memory into
  the filesystem image**.
- **Version info:** none in the message. The write site has existed
  since early HFS+ code; `hfs_bnode_write()` taking `u32` is already in
  this 6.12 tree.
- **Root cause:** write path never checks `entrylength`; the read path
  already does.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not hidden.** This is an explicit memory-safety / info-leak
fix, described as such.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `fs/hfsplus/extents.c` — **+2 / -0**
- **Function:** `__hfsplus_ext_write_extent()`
- **Scope:** single-file surgical fix (two lines)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** on the existing-record path (`!(extent_state &
  HFSPLUS_EXT_NEW)`), a successful `hfs_brec_find()` is followed
  immediately by `hfs_bnode_write(..., fd->entryoffset,
  fd->entrylength)`.
- **After:** if `fd->entrylength != sizeof(hfsplus_extent_rec)`, return
  `-EIO` and do not write.
- **Path:** overflow-extent **update** (not the `HFSPLUS_EXT_NEW` insert
  path, which already passes `sizeof(hfsplus_extent_rec)`).
- Insert path is unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** memory safety — out-of-bounds read of kernel memory,
  leaked into the on-disk B-tree node (info leak + image corruption).
  Also a logic/correctness gap: write did not mirror the read-side check
  that has existed since `1da177e4c3f41` (Linux-2.6.12-rc2).
- **Mechanism verified in this tree:**
  - `fd->entrylength` is `int` (`fs/hfsplus/hfsplus_fs.h`).
  - `__hfs_brec_find()` does `fd->entrylength = len - keylen` with `u16
    len, keylen` (`fs/hfsplus/bfind.c`). Integer promotions make `keylen
    > len` a **negative int**.
  - `hfs_bnode_write()` takes `u32 len` (`fs/hfsplus/bnode.c`), already
    true here via `350183396918f` (“hfs/hfsplus: prevent getting
    negative values of offset/length”).
  - `cached_extents` is `hfsplus_extent_rec` = 8 × `{start, count}` =
    **64 bytes**.
  - `check_and_correct_requested_length()` caps the **destination** to
    the remaining node size, but `memcpy_to_page()` still reads `len`
    bytes from the **source** `cached_extents`. A huge/mismatched length
    over-reads adjacent inode-slab memory and writes it into the node.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct. Same predicate as
  `__hfsplus_ext_read_extent()`. Valid HFS+ overflow records are a fixed
  64-byte extent array; a different size is corrupt.
- **Minimal:** two lines, no unrelated edits.
- **Regression risk:** very low. Valid images already satisfy this on
  read; insert already uses `sizeof`. Invalid images now get `-EIO`
  instead of a kernel leak. `HFSPLUS_EXT_DIRTY` is left set, so a later
  write_inode can retry; that is existing dirty-extent behavior, not a
  new API.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- The `hfs_bnode_write(..., fd->entrylength)` site dates to
  `6af502de224c37` (Christoph Hellwig, 2010) in current blame; the
  surrounding write function is older (`^1da177e4c3f41`, 2.6.12).
- The matching **read-side** check is `^1da177e4c3f41` (2005). The
  write-side gap is long-standing.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Not applicable. Bug is missing validation on
a path that has been in the tree for many releases, not a recently
introduced regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Related in this tree: `99202d94909d3` (KMSAN in
  `__hfsplus_ext_cache_extent`), `350183396918f` (signed offset/length →
  `u32`), `c91bbd6193c70` / `7898beee166c1` (other on-disk record size
  checks).
- On origin: `00aedd67d75d7` “hfsplus: validate B-tree record offset
  table” is a **separate** larger patch, **not** in this tree and
  **not** required for these two lines.
- **Standalone.** Not patch X/Y of a series that must land together.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record:
- Author Jiaming Zhang has no other `fs/hfsplus/` commits in this
  checkout.
- Reviewer/committer Viacheslav Dubeyko is the HFS maintainer; this tree
  already carries many of his HFS+ fuzz/corruption fixes.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- No new helpers or structs.
- Relies on existing `sizeof(hfsplus_extent_rec)` and `fd->entrylength`.
- `hfs_bnode_write()` being `u32` is already here; the check is valid
  even without that conversion.
- **`git apply --check` of `627b7865c062f` succeeded** on this tree. The
  only nearby mainline difference (`HFSPLUS_EXT_TREE_I` extra `set_bit`)
  is **after** this hunk and does not block the apply.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 627b7865c062f` → `https://patch.msgid.link/20260810092422.1
  691377-1-r772577952@gmail.com`
- Direct lore/WebFetch returned **403**; thread was recovered with `b4
  dig -m`.
- `b4 dig -a` shows earlier revisions were a **different** patch
  (“validate B-tree record offset table”, v1–v6). This extent-length
  check is a **new standalone v1** (2026-08-10), not a later revision of
  the offset-table series.
- Maintainer reply
  (`5f60c60a03b3d3e4b6d4adc2f241371b72977206.camel@dubeyko.com`):
  **“Looks good.”** + `Reviewed-by`. **No NAK, no stability concern.**
- No reviewer `Cc: stable` in the two-message thread (absence is not a
  negative).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record:
- Recipients (from the mbox): Viacheslav Dubeyko, Yangtao Li, John Paul
  Adrian Glaubitz, linux-fsdevel, linux-kernel, syzkaller.
- Reviewed by the subsystem maintainer.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record:
- No syzbot hash / bugzilla in the commit.
- Body describes a crafted-image trigger; patch CCs syzkaller.
- Original Dubeyko lore URL could not be fetched (403). Unverified
  beyond the Link: tag existing.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record:
- Offset-table series is related thematically, not a dependency.
- No follow-up on `origin/master` after `627b7865c062f` touching
  `fs/hfsplus/extents.c`.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search returned 403. **UNVERIFIED**
whether stable@ already discussed this SHA. Decision does not depend on
that.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

semcode MCP tools are **not available**; callers/callees traced with
grep and file reads.

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `__hfsplus_ext_write_extent()` only.

**Step 5.2: TRACE CALLERS**

Record:
- `hfsplus_ext_write_extent_locked()` → `hfsplus_ext_write_extent()`
  (`hfsplus_write_inode` in `super.c`) and `hfsplus_file_extend()`
  (`insert_extent`).
- `__hfsplus_ext_cache_extent()` writes a dirty cache before reading
  another extent; used from `hfsplus_ext_read_extent()` →
  `hfsplus_get_block()`, and from `hfsplus_file_truncate()`.
- Context: inode writeback, file extend, truncate, block mapping —
  normal file I/O on HFS+, not init-only.

**Step 5.3: TRACE CALLEES**

Record: `hfsplus_ext_build_key`, `hfs_brec_find`, `hfs_bmap_reserve` /
`hfs_brec_insert` (new records), `hfs_bnode_write` (updates). The new
check sits immediately before `hfs_bnode_write`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record:
- Userspace: mount HFS+ → write/truncate/fsync/umount on a file with
  overflow extents.
- Crafted images are the trigger (USB/disk image, fuzzing). Mount
  typically needs privilege, but that is the usual model for filesystem
  image bugs already backported here.
- **Reachable from VFS file ops**, not an obscure debug path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record:
- Read path already has the identical check (`extents.c` ~170–171).
- Catalog paths already reject bad `entrylength` (`dir.c`, `catalog.c`,
  `inode.c`).
- This is the overflow-extent **write** hole in that same pattern.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** Local `__hfsplus_ext_write_extent()` still does:

```113:114:fs/hfsplus/extents.c
                hfs_bnode_write(fd->bnode, hip->cached_extents,
                                fd->entryoffset, fd->entrylength);
```

No length check. `git merge-base --is-ancestor 627b7865c062f HEAD` is
false. Bug is old (write site 2010 / structure since 2.6.12). `u32`
conversion that turns a negative length into a huge copy **is already in
this 6.12.111 tree**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** (`git apply --check` on `627b7865c062f`
succeeded). Hunk context around `hfs_bnode_write` matches. No rework
needed.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record:
- Read-side check: yes (since 2.6.12).
- Write-side check: **no**.
- `350183396918f` changed the failure mode (negative `int` → huge `u32`)
  but did not add this check.
- No alternate fix for this write-side hole.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **fs/hfsplus** — Apple HFS+. **IMPORTANT** (not core MM/VFS, not
staging). Used for Mac-formatted disks; this tree already backports many
HFS+ crafted-image fixes.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature filesystem, still getting sanitizer/corruption fixes in
6.12.y. Not dead code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Filesystem-specific / config-specific** (`CONFIG_HFSPLUS_FS`).
Anyone who mounts HFS+ (including untrusted/crafted images).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Trigger: mount crafted HFS+ with a malformed extents overflow record
  (`keylen > len` or any `entrylength != 64`), then dirty and write back
  cached overflow extents (write, truncate, writeback).
- Not every boot; requires HFS+ + overflow extent writeback + corrupt
  record.
- Unprivileged users cannot usually mount; a privileged mount of
  untrusted media is still the standard stable threat model for these
  bugs.
- The write-side `hfs_brec_find()` is independent of the earlier read. A
  crafted tree (duplicate keys, confused search after splits) can
  present a bad `entrylength` on update even though the read path has a
  check. The code is also simply wrong: updates trust on-disk length
  instead of the known 64-byte record size.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- **Failure mode:** kernel out-of-bounds read of inode-adjacent memory;
  those bytes are written into the extents B-tree node (info leak on
  disk + corruption of the overflow tree). With KASAN this is an OOB
  report; without it, silent leak/corruption.
- **Severity: HIGH** (memory safety + info leak + image corruption). Not
  a guaranteed panic on production kernels, but not cosmetic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** high for HFS+ users and for the same crafted-image class
  already being fixed in 6.12.y.
- **Risk:** very low (2 lines, same predicate as a 20-year-old read
  check, clean apply).
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real bug: OOB read of `cached_extents` and kernel memory leaked into
  the image.
- Important: memory safety, info leak, B-tree corruption on crafted
  HFS+.
- Tiny, obviously correct, maintainer-reviewed.
- Buggy code and the `u32` write signature are in **this** 6.12.111
  tree.
- Applies cleanly; no prerequisites.
- Matches existing read-side check and other HFS+ validation backports
  already here.

**AGAINST:**
- HFS+ is not universal.
- No `Fixes:` / syzbot hash / `Cc: stable` (expected; not a reason to
  reject).
- Typical flow reads first, so a naive reading might call it
  “defensive.” That does not make the write path safe: find is redone,
  on-disk length is still trusted, and the maintainer accepted the leak
  description.

**UNRESOLVED:**
- Full original Dubeyko lore mail (403).
- Whether stable@ already discussed this SHA (403).
- No public reproducer in the two-message thread.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — mirrors the read check;
   maintainer Reviewed-by.
2. Fixes a real bug that affects users? **PASS** — crafted HFS+ image,
   kernel memory leak into the filesystem.
3. Important issue? **PASS** — OOB read / info leak / image corruption
   (HIGH).
4. Small and contained? **PASS** — +2 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — `git apply --check`
   succeeded; buggy code present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. It is a normal
small bugfix.

**Step 9.4: MAKE YOUR DECISION**

Backport to this 6.12.111 tree. The hole is here, the `u32` conversion
that turns a negative length into a huge copy is here, and the fix is
two lines that valid images already satisfy.

------------------------------------------------
What the commit solves for this tree
------------------------------------------------

`__hfsplus_ext_write_extent()` updates an overflow extent using
`fd->entrylength` from on-disk B-tree fields. A crafted node can make
that length negative or otherwise not 64. `hfs_bnode_write()` treats it
as `u32`, over-reads the 64-byte `cached_extents` in the inode, and
writes kernel memory into the image. The read path has rejected this
since 2.6.12; the write path in 6.12.111 still does not.

It meets the stable rules: real bug, important (memory safety / leak /
corruption), two lines, no new API, clean apply, no missing
prerequisites.

Risk vs benefit: benefit is closing an HFS+ crafted-image leak already
in this tree; risk is negligible because valid overflow records are
fixed-size.

------------------------------------------------
Verification
------------------------------------------------

- **[Phase 1]** Parsed tags on `627b7865c062f`: Reviewed-by Dubeyko; two
  Link: URLs; no Fixes/Reported-by/Cc-stable.
- **[Phase 2]** Diff: +2 lines in `__hfsplus_ext_write_extent()` before
  `hfs_bnode_write()`.
- **[Phase 2]** Confirmed `entrylength` is `int`; `__hfs_brec_find()`
  uses `len - keylen`; `hfs_bnode_write(..., u32 len)`; `cached_extents`
  is 64 bytes; dest length is capped but source is not.
- **[Phase 3]** Blame: write uses `entrylength` since Hellwig 2010;
  read-side check since `1da177e4c3f41`.
- **[Phase 3]** No Fixes: tag. Standalone, not the offset-table series.
- **[Phase 3]** `git apply --check` of `627b7865c062f` on this tree:
  success.
- **[Phase 4]** `b4 dig -c 627b7865c062f`: msgid
  `20260810092422.1691377-1-r772577952@gmail.com`; maintainer “Looks
  good” + Reviewed-by. `b4 dig -a`: this is a new v1, not v7 of the
  offset-table patch.
- **[Phase 4]** lore WebFetch/curl: 403. Thread recovered via `b4 dig
  -m`.
- **[Phase 5]** Callers: `hfsplus_write_inode`, `hfsplus_file_extend`,
  `__hfsplus_ext_cache_extent` (get_block/truncate). semcode
  unavailable.
- **[Phase 6]** `git describe HEAD`: `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion`: 6.12.111.
- **[Phase 6]** `git merge-base --is-ancestor 627b7865c062f HEAD`: not
  an ancestor. Local write path still unchecked.
- **[Phase 6]** `350183396918f` (u32 bnode lengths) **is** in HEAD.
- **[Phase 8]** Failure mode: OOB read + kernel memory leaked into the
  extents tree; severity HIGH.
- **UNVERIFIED:** original Dubeyko prompt mail body; stable@ archive
  discussion.

The fix is small, surgical, present-bug, and meets the stable criteria
for this tree.

**YES**

 fs/hfsplus/extents.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index 8e886514d27f1..11c990d18ac8a 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -110,6 +110,8 @@ static int __hfsplus_ext_write_extent(struct inode *inode,
 	} else {
 		if (res)
 			return res;
+		if (fd->entrylength != sizeof(hfsplus_extent_rec))
+			return -EIO;
 		hfs_bnode_write(fd->bnode, hip->cached_extents,
 				fd->entryoffset, fd->entrylength);
 		hip->extent_state &= ~HFSPLUS_EXT_DIRTY;
-- 
2.53.0

