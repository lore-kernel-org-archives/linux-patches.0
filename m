Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20985045BD;
	Mon, 19 Oct 2026 14:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418404; cv=none; b=PAgbI9BMg56faZ9JheBzx/Nzd+f+Ko/0qAYA8sRU6lWv08i3CJ45x7BDDJVobYYizv8+NBr3T71jfXEjzdN2hXdT3YDKHIwcqvcPYVrK7FZkc+pVxif59OMVocMp8pNlXV3bU92u/dMIlK5XeA36K6fB4NsINddHclfrEPOBhXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418404; c=relaxed/simple;
	bh=eCpd0bciKuxFgznG6LMVfPYwxYpve4cdhZknkVTjqQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oZLtgx1A7Om0SZBsCF1IrRAsBwupengAQXmIfhqJ94SgLPOKbTSIwQ6H9yLGHM2GN/Q6n5c8DFZgiSF5YaBhBQMkhgFz6fzmzlKs7Hqrfi2EJUyfPWaWelDSKfL+j95RN6ctQCRgP+XVLxR2oVyU13URcQ/1hR5XzsKg12bZ6+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hobk8cfg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hobk8cfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04ED21F000C8;
	Mon, 19 Oct 2026 14:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418401;
	bh=jht7pw9u/wfie8PUcFFd5RpIB9cO4cBkWZiCGj/+V5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hobk8cfgRJ0PXI5IenxTyrMvb6qMGWJ/LosUf96WPzte8JaGk29j2ifW+HXq9Bfzm
	 tTjyNd92KXYGiqws980hYugsnX3Ba3L2ySFtMe4h9AfegITKEtbhJB8MyNzZWlktpL
	 0Uu+QaFM80tWH6KhZO5qhT9xycNbsVRO2utV4hlCQV7xAiXrqXafFIweealCwqjGpA
	 Mw7GL2SqWe/ygSixsnVJ5j1alp2eirM88KxDxCGXlNHubCYZOfN9YuB5ck8MKwIY5E
	 nsS7t9hEtkRaT3XanetzeLEcCscMdiPn9BU8RL5AW9u5QX+ipif9qvpyowlHWbrUov
	 zQ3b4gD4isX9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] fs/ntfs3: Fix memory leak in indx_find_sort()
Date: Mon, 19 Oct 2026 09:48:35 -0400
Message-ID: <20261019135441.1420968-224-sashal@kernel.org>
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

[ Upstream commit 194491be54e1c9e4d29d3ee777b05ff031c4b670 ]

When popping a level from the index lookup stack, indx_find_sort() frees
the struct indx_node but not the index buffer it owns. Every call that
descends and then pops a level leaks that allocation.

Free n->index before freeing the node itself.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a one-line leak fix in
`indx_find_sort()`, the buggy code is in this 7.3-rc4 tree, and it meets
the stable rules.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[fs/ntfs3] [fix] memory leak in `indx_find_sort()`** —
subsystem `fs/ntfs3`, action verb **fix**, claimed intent is to stop
leaking the index buffer when a lookup level is popped.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Commit `194491be54e1c9e4d29d3ee777b05ff031c4b670` (Author: Konstantin
Komarov, 2026-07-30):

- **Fixes:** none (expected for this review)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** none in the commit message
- **Cc: stable:** none (expected)
- **Signed-off-by:** Konstantin Komarov \<almaz.alexandrovich@paragon-
  software.com\> (author/maintainer)

No syzbot, no multi-user reports, no explicit stable nomination. Author
is the NTFS3 maintainer.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** When popping a level from the index lookup stack,
  `indx_find_sort()` frees `struct indx_node` but not the index buffer
  it owns (`n->index`).
- **Symptom:** Every call that descends into a child index block and
  later pops that level leaks that allocation (typically a 4 KiB
  `kmalloc` of `INDEX_BUFFER`).
- **Failure mode:** kernel memory leak on NTFS3 `$SDH` index walks.
- **Version info:** none in the message.
- **Root cause (author):** `kfree(n)` without `kfree(n->index)`.
- **Fix:** free `n->index` before freeing the node.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Subject and body state a leak fix. It is a
classic missing-`kfree` resource-leak fix, not cleanup-only.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `fs/ntfs3/index.c` — **+1 / −0**
- Function: `indx_find_sort()`
- Scope: **single-file surgical fix** (one line in the `pop_level` path)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record (before → after):
- Before: `fnd_pop(fnd); kfree(n);` — node struct freed; `n->index` (and
  buffer heads in `n->nb`) left allocated.
- After: `fnd_pop(fnd); kfree(n->index); kfree(n);` — index buffer and
  node struct freed.
- Path: **normal** pop-level path when the current directory entry is
  the last in that index block and the walk moves to the parent. Not
  init-only.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Memory leak / resource leak]**
- `indx_read()` / `indx_read_ra()` allocates `struct indx_node` and
  `in->index` (`kmalloc(bytes, GFP_NOFS)` where `bytes = 1u <<
  indx->index_bits`, typically 4096).
- Correct teardown is `put_indx_node()`: `kfree(in->index);
  nb_put(&in->nb); kfree(in);`.
- Sibling `indx_find_raw()` already does `fnd_pop()` +
  `put_indx_node(n)`.
- `indx_find_sort()` used `kfree(n)` only. This patch adds
  `kfree(n->index)` on the pop path.
- Mechanism: missing free of owned `kmalloc` buffer.

Note (verified, not a reason to reject): the patch does **not** call
`nb_put(&n->nb)`, so buffer_head refs can still leak on this path. Two
other `kfree(n)` sites in the same function (invalid-entry error paths
at the `de_has_vcn_ex` loop) are also unchanged.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct for the stated leak: `kfree(n->index)` matches the
  first action of `put_indx_node()`; `kfree(NULL)` is safe; `fnd_pop()`
  NULLs the stack slot so later `fnd_clear()`/`put_indx_node()` will not
  double-free.
- Minimal: one line, no unrelated edits, no API change.
- Regression risk: **very low**. Does not change lookup results,
  locking, or on-disk layout.
- Residual risk: incomplete vs `put_indx_node()` (BH leak remains). That
  is an unfixed sibling leak, not a regression introduced by this line.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Pop-level `kfree(n)` / `ntfs_free(n)` present since
  **`82cae269cfa95`** (“fs/ntfs3: Add initialization of super block”,
  2021-08-13) — NTFS3 introduction.
- `ntfs_free(n)` → `kfree(n)` in **`195c52bdd5d5e`** (“Do not use driver
  own alloc wrappers”, 2021-08-24); `ntfs_free` was just `kfree`, so the
  leak is original, not introduced by that conversion.
- This leak has existed for the entire life of NTFS3 in mainline (~5.15
  onward).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Buggy code is the original `indx_find_sort()`
implementation in `82cae269cfa95`, which **is an ancestor of HEAD**.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Recent `fs/ntfs3/index.c` work is mostly bounds checks and cosmetics.
- Related leak: `87ac077d6ea86` “ntfs3: fix memory leak in
  indx_create_allocate()” — different function.
- No later commit after `194491be54e1c` changes this site (`git log
  194491be54e1c..HEAD -- fs/ntfs3/index.c` is empty).
- Standalone 1-line patch, not “X/Y” of a series.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Konstantin Komarov is the NTFS3 maintainer (Paragon). Many
recent NTFS3 commits are his. Weight: high.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. The patch only uses existing `kfree`, `fnd_pop`, and
`n->index`. Those exist in this tree. **Can apply standalone.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 194491be54e1c` → https://patch.msgid.link/20260724111443.14
  728-1-almaz.alexandrovich@paragon-software.com
- `b4 dig -a`: single revision **v1** only (2026-07-24). Committed
  version matches v1.
- lore.kernel.org fetch returned 403; patch text confirmed via
  Openwall/IU mirrors. No replies found on those archives (no NAK, no
  Cc: stable in-thread).
- Earlier independent patch (Jan 2026) from Jiasheng Jiang: “[PATCH v2]
  fs/ntfs3: Fix memory and resource leak in indx_find_sort” replacing
  **all three** `kfree(n)` with `put_indx_node(n)` and adding `Fixes:
  82cae269cfa9`. That fuller patch was **not** merged; the maintainer
  later landed this narrower 1-line version.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc: Konstantin Komarov,
`ntfs3@lists.linux.dev`, `linux-kernel@vger.kernel.org`, `linux-
fsdevel@vger.kernel.org`. No extra reviewer SOB on the commit.
Maintainer self-applied.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / bugzilla / syzbot. Bug established from code
(missing free vs `put_indx_node` / `indx_find_raw`). User-report count:
**unverified / none found**.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Jiang’s Jan 2026 patch is the more complete form of the same
fix. This commit is a subset (pop path `n->index` only). No series
dependency for applying this one line.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search was 403; web search did not turn
up a stable-list thread for this subject. **No verified stable-list NAK
or prior selection discussion.**

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `indx_find_sort()` only.

**Step 5.2: TRACE CALLERS**
Record: Only caller in this tree is `ntfs_insert_security()` in
`fs/ntfs3/fsntfs.c` (SDH index walk when inserting a security
descriptor). That is called from:
- `inode.c` file/inode create when a new default/dir security id must be
  stored
- `xattr.c` when setting a security descriptor xattr

Not interrupt context. Process context, under `ni->ni_lock`. Finder is
released with `fnd_put()` → `fnd_clear()` → `put_indx_node()` for
**remaining** stack nodes; popped nodes are supposed to be freed in
`indx_find_sort` itself.

**Step 5.3: TRACE CALLEES**
Record: `fnd_pop`, `kfree`, `indx_read`/`hdr_first_de`/`de_is_last` on
the surrounding path. `indx_read_ra` allocates node + index buffer +
buffer_heads.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace NTFS3 create/`setxattr` → `ntfs_insert_security` →
`indx_find` then loop `indx_find_sort`. **Reachable from userspace** on
a mounted ntfs3 volume. Not every I/O; triggered when inserting (or
searching duplicate) security descriptors in `$Secure::$SDH`. If the SDH
B-tree is deeper than root, pop_level runs and leaked before this fix.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same function still has `kfree(n)` without `kfree(n->index)` on
two **error** paths. `indx_find_raw` already uses `put_indx_node`.
Pattern is systematic in `indx_find_sort`, only partly fixed here.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Local tree: **`v7.3-rc4-27-gf0100363d8c37`**, `make kernelversion` =
  **7.3.0-rc4**.
- `fs/ntfs3/index.c` `indx_find_sort()` exists. Pre-image is `fnd_pop` +
  `kfree(n)` without freeing `n->index`.
- Bug introduced with NTFS3 in **`82cae269cfa95` (2021)**, present in
  this tree (`git merge-base --is-ancestor 82cae269cfa95 HEAD`
  succeeded).
- This is not “new code after this branch point.”

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Surrounding function text is the original
structure; the hunk is one added line. No conflicting refactor of
`indx_find_sort` in this tree. `put_indx_node()` already exists if a
slightly richer backport were used, but this exact diff applies as-is.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier alternative (Jiang `put_indx_node`) in this history.
This commit **is** the fix that landed (`ntfs3_for_7.3` merge
`dc83d18cdd904`). No competing fix for the same `kfree(n)` pop site.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **[fs/ntfs3] [IMPORTANT]** — real RW filesystem
(CONFIG_NTFS3_FS), not staging. Not core VFS/mm, but used on Windows
volumes, dual-boot, and some appliances. Leak is in metadata index walk
for `$Secure`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (many 7.3 NTFS3 fixes). The leak itself is old (2021),
not a bug in brand-new code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **filesystem-specific / config-specific** — `CONFIG_NTFS3_FS`
users who insert security descriptors (file create with new/default SD,
security xattr). Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Trigger: `indx_find_sort()` after a descent into an index allocation
  block, then last-entry pop.
- How common: not every syscall; **per unique-SD insert / SDH hash-chain
  walk**, not a once-per-boot init-only leak. Repeated unique ACLs leak
  repeatedly.
- Unprivileged users: if they can create files or set security xattrs on
  ntfs3, yes. Typical create after `def_security_id` is cached may not
  re-enter insert; still reachable.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **[kernel memory leak of index buffers (and remaining BH refs)]
[HIGH for the kmalloc leak on a live FS path; not panic/corruption].**
Unbounded across many unique SD inserts; can contribute to memory
pressure. Not a crash or data-corruption bug.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium-high for ntfs3 users — stops a real leak on a used
  lookup path; 4 KiB+ per popped level.
- **Risk:** very low — 1 line, same pattern as `put_indx_node`’s first
  free, no lock/API change.
- **Ratio:** strongly in favor of taking the fix.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real leak: `kfree(n)` drops the node without freeing `n->index`
  allocated in `indx_read_ra()`.
- Normal pop path, not style-only.
- 1 line, obviously correct, maintainer-authored.
- Code and bug exist in this 7.3-rc4 tree since NTFS3 was added.
- Applies cleanly; no prerequisites.
- Same class as many stable leak fixes; sibling `indx_find_raw` already
  frees via `put_indx_node()`.
- Reachable from userspace ntfs3 create/xattr.

AGAINST:
- Not a crash, deadlock, or corruption issue.
- Incomplete: no `nb_put()`, two error-path `kfree(n)` sites remain.
- Single caller (`ntfs_insert_security`), not a hot readdir path.
- No syzbot/user `Reported-by`, no in-commit tests.

UNRESOLVED:
- Could not fetch lore.kernel.org (403) or confirm stable-list
  discussion.
- No public reply thread found on mirrors for the July v1 mail.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — correctness is visible from
   `put_indx_node()` / `indx_find_raw()`. Testing is only implied by
   maintainer merge, not a Tested-by tag.
2. Fixes a real bug that affects users? **PASS** — leaked kernel
   allocations on ntfs3 SD insert/lookup.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   memory leak on a live FS path (stable routinely takes these). Not
   CRITICAL severity, but it is a real resource leak, not cosmetic.
4. Small and contained? **PASS** — +1 line, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — context matches; ntfs3 and
   `indx_find_sort()` are present.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. It is a normal
leak fix.

**Step 9.4: MAKE YOUR DECISION**
This tree is **7.3.0-rc4**. The leak exists in `indx_find_sort()` here
and has since NTFS3 landed. The patch is a one-line `kfree(n->index)` on
pop, matching the node’s ownership. Residual BH/error-path leaks do not
make this line wrong or risky. Benefit outweighs risk.

===============================================================
What problem this solves for this tree
===============================================================
`indx_find_sort()` walks the NTFS `$SDH` B-tree. After `indx_read()`
fills a child `indx_node`, popping that level used to `kfree` only the
node object. The owned index buffer stayed allocated for every descent-
then-pop. NTFS3 users inserting security descriptors (file create /
security xattr) leak that memory. This commit frees `n->index` first,
which is the correct teardown for that allocation.

It meets stable rules: obviously correct, real leak, small, no new API,
applies here. Risk is a single `kfree` on a pointer the node exclusively
owns after `fnd_pop()`.

Concerns: the fuller `put_indx_node()` replacement was proposed earlier
and would also drop buffer heads and fix two error paths; this commit is
a partial fix. That is acceptable for stable — it still plugs the main
pop-path kmalloc leak without depending on other commits.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed commit `194491be54e1c`: subject/body leak fix; tags =
  author SOB only; no Fixes/Reported-by/Cc: stable.
- [Phase 2] Diff: +1 line `kfree(n->index)` before `kfree(n)` in
  `indx_find_sort()` pop_level; confirmed `put_indx_node()` does
  `kfree(in->index); nb_put(); kfree(in)`.
- [Phase 2] Confirmed `indx_read_ra()` `kmalloc`s `ib` and assigns
  `in->index = ib`.
- [Phase 2] Confirmed `indx_find_raw()` uses `put_indx_node(n)` after
  `fnd_pop`.
- [Phase 3] `git blame`: pop path from `82cae269cfa95` (2021);
  `kfree(n)` from `195c52bdd5d5e`; this line from `194491be54e1c`.
- [Phase 3] `git merge-base --is-ancestor 82cae269cfa95 HEAD` and
  `194491be54e1c HEAD`: both true.
- [Phase 3] `git log 194491be54e1c..HEAD -- fs/ntfs3/index.c`: no later
  change to this file.
- [Phase 3] No `Fixes:` tag to follow.
- [Phase 4] `b4 dig -c 194491be54e1c`: lore msgid
  `20260724111443.14728-1-almaz.alexandrovich@paragon-software.com`;
  `-a` v1 only; `-w` ntfs3/fsdevel/lkml.
- [Phase 4] Openwall/IU mirrors: patch text matches commit; no replies
  found.
- [Phase 4] Found unmerged Jan 2026 Jiasheng Jiang `put_indx_node` patch
  (lkml.iu.edu / gnuweeb).
- [Phase 4] lore.kernel.org WebFetch: 403. Stable-list hit:
  **UNVERIFIED**.
- [Phase 5] `git grep indx_find_sort`: only `ntfs_insert_security` +
  declaration.
- [Phase 5] `ntfs_insert_security` `out:` calls `fnd_put(fnd_sdh)`.
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = 7.3.0-rc4.
- [Phase 6] Pre-fix source at `194491be54e1c^` still has `kfree(n)`
  without `kfree(n->index)`.
- [Phase 8] Failure mode: kmalloc leak of index buffers on SDH pop;
  severity HIGH for leak class, not oops/corruption.
- UNVERIFIED: whether any user actually hit OOM from this; mailing-list
  review comments beyond the isolated patch mail.

The fix is small, surgical, and meets the stable criteria for this tree.

**YES**

 fs/ntfs3/index.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index edfcd28573ef9..03ae5a817c1b4 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1325,6 +1325,7 @@ int indx_find_sort(struct ntfs_index *indx, struct ntfs_inode *ni,
 		/* Pop one level. */
 		if (n) {
 			fnd_pop(fnd);
+			kfree(n->index);
 			kfree(n);
 		}
 
-- 
2.53.0

