Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A69C50F130;
	Mon, 19 Oct 2026 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418205; cv=none; b=iX9eDJXtTJsxTC9sA9UqGuBBxnuKy+h1pWYdXDaj+El6+jONsoauLf2vOTlczYr07K2LFzCj1f71GRX0wviJiqq+QlcQyfN7RzgimBY4PKFwZitAKgNkgpqlF2SaNgL+2b0lYhSEkX3b9FQhDNTWJX4a//eAYFLJwa0Oe2uWC7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418205; c=relaxed/simple;
	bh=Ytt74OlAQWAzGZejgRM7nZtecD4cqe6XClSMPFty4rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tPCikX5ZQwIH2NXPC8ggJXtxZHYW8AIC9Gn4A57ac9yEEPjOu6x2KI/UTStR/WHpE7WlHaGGUtJlnSOj5xkV3E/thMOfKqHYb32GLBkcchd+q0V2jwP6wKI5C4xpLvIStlnApX+IVEctZtwJ2FNpjrOnQVJo7p/aLbWP80WJ4CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cx/oQlts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cx/oQlts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB1D1F000C4;
	Mon, 19 Oct 2026 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418203;
	bh=X5l/PeQWyKEsygszYjiV/pa7+VjW8R0NTAuDDSYj86w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cx/oQltsrPyWdUb56qaVffi7ruRhxsN79U5/YEm0u2NWGGjCz6Fest4mAfCkZXXm3
	 UigU/P26Y9fDt7sFv1sRavZOAQMsPFMyr6fMdYXPc/dJckLWQkdM4/biDZIObRIr3c
	 4DVU4kaOx1KDJPnuMgW4p54Bv1WOYLa9ONdgOEFRXb4ukkxVQqHbf4gG5mqnY3QaPZ
	 21v+hRaeSZ8oRQvyPRqVUvRFSnWLg3bdZwrCYRUGAolEmlz0hza+cRLExye4xt1spY
	 GBEgi947JfYVyd+HQ1c59CSH9GB/UDnDt4NSOR4OJjDYE7zWDIAQ0dx/7Pf5WV3CSX
	 IEo96FhA45QRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kyle Zeng <kylebot@openai.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>,
	jack@suse.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] udf: validate extent partition references in udf_current_aext()
Date: Mon, 19 Oct 2026 09:46:16 -0400
Message-ID: <20261019135441.1420968-85-sashal@kernel.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 120ec50984b8645232c2c004310dd94ceff5520e ]

Long allocation descriptors carry an on-disk
extLocation.partitionReferenceNum. udf_current_aext() copies that value
into a kernel_lb_addr and returns it to several consumers.

If the partition reference is outside s_partitions, callers can later
index s_partmaps out of bounds. The truncate/free path can pass such an
extent to udf_free_blocks(), where the invalid partition reference
causes a slab out-of-bounds read.

Validate eloc->partitionReferenceNum in udf_current_aext() before
returning a decoded extent. This rejects invalid file extents and
indirect allocation descriptor extents in the common parser, so callers
do not need to duplicate the partition-map bounds check.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20260612225846.97678-1-kylebot@openai.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **v7.3-rc4** (`7.3.0-rc4`). This is a real UDF
slab out-of-bounds on crafted long allocation descriptors; the
vulnerable parser and `udf_free_blocks()` indexing both exist here, and
the 7-line check is the right place to reject them.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[udf] [validate] reject out-of-range on-disk extent partition
references in udf_current_aext()`
- Subsystem: `udf` (UDF filesystem)
- Verb: `validate` — safety-check language; this is a bounds-check bug
  fix, not a feature

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Assisted-by: Codex:gpt-5.5` — LLM-assisted; not a quality veto by
  itself
- `Signed-off-by: Kyle Zeng <kylebot@openai.com>` — author
- `Link:
  https://patch.msgid.link/20260612225846.97678-1-kylebot@openai.com`
- `Signed-off-by: Jan Kara <jack@suse.cz>` — UDF maintainer (listed in
  MAINTAINERS)
- No `Fixes:` tag (expected for this review queue)
- No `Cc: stable@vger.kernel.org` (expected)
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:`
- Ignore pipeline SOBs; none were present beyond author + maintainer

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Long ADs copy on-disk `extLocation.partitionReferenceNum`
  into `kernel_lb_addr`. That value can be `>= s_partitions`.
- **Symptom:** Callers later index `s_partmaps[]` out of bounds. The
  truncate/free path passes the extent to `udf_free_blocks()`, which
  does a **slab out-of-bounds read**.
- **Root cause:** Common extent decoder does not bounds-check the
  partition reference.
- **Fix:** Check `eloc->partitionReferenceNum >= s_partitions` in
  `udf_current_aext()` and return `-EFSCORRUPTED`.
- **Version info in message:** none. Git shows the long-AD copy dates to
  `28de7948a89676` (contained in v2.6.23-rc1).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. The message names a slab OOB and a concrete consumer
(`udf_free_blocks()`). This is an explicit memory-safety fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `fs/udf/inode.c` — **+7 / -0**
- Function: `udf_current_aext()` only
- Scope: single-file surgical fix

Committed form (Jan Kara dropped a misplaced `sbi` local from the mailed
v2):

```2316:2321:fs/udf/inode.c
        if (eloc->partitionReferenceNum >=
UDF_SB(inode->i_sb)->s_partitions) {
                udf_debug("invalid partition reference %u (partitions
%u)\n",
                          eloc->partitionReferenceNum,
                          UDF_SB(inode->i_sb)->s_partitions);
                return -EFSCORRUPTED;
        }
```

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** After decoding a short or long AD, return `1` with `eloc`
  filled. Long ADs take `partitionReferenceNum` from disk
  (`lelb_to_cpu(lad->extLocation)`). Short ADs copy the inode’s already-
  checked location.
- **After:** Same decode, then reject `partitionReferenceNum >=
  s_partitions` with `-EFSCORRUPTED`.
- Path: every extent walk through `udf_current_aext()` /
  `udf_next_aext()`, including truncate, bmap, directory iteration.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Memory safety / out-of-bounds** (category d).
Verified in this tree: `udf_free_blocks()` still indexes with no
partition check:

```664:669:fs/udf/balloc.c
void udf_free_blocks(struct super_block *sb, struct inode *inode,
                     struct kernel_lb_addr *bloc, uint32_t offset,
                     uint32_t count)
{
        uint16_t partition = bloc->partitionReferenceNum;
        struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
```

`extent_trunc()` in `fs/udf/truncate.c` passes `eloc` from
`udf_current_aext()` into `udf_free_blocks()`. `udf_get_pblock()`
already bounds-checks, so reads are safer; the crash is the
free/truncate path.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: same pattern as `udf_read_inode()`
  (`iloc->partitionReferenceNum >= sbi->s_partitions`) and
  `udf_get_pblock()`.
- Minimal: one check before the success return.
- Regression risk: **low**. Callers already treat `ret <= 0` as failure
  (`ee703a7068f95` / `b405c1e58b739`). Truncate does `while (... > 0)`
  then `if (ret < 0) return ret`. `-EFSCORRUPTED` is already used across
  `fs/udf/`.
- Short-AD false positives: unlikely; `udf_read_inode()` already
  validates `i_location.partitionReferenceNum` (`1d82a56bc5bf8`).
- Mailed v2 put `sbi` in `udf_write_aext()` (wrong function); LKP failed
  to compile. Jan applied the check with `UDF_SB()` inline. The commit
  under review is that corrected form.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Long-AD copy: `28de7948a89676` (Cyrill Gorcunov, 2007), contained in
  **v2.6.23-rc1**
- Function skeleton: `^1da177e4c3f41` (2.6.12-rc2)
- Error-return API: `ee703a7068f95` (2024), contained in **v6.12-rc2**
- The new check: `120ec50984b86` (this commit), contained in
  **v7.3-rc1**

The buggy decode has been in UDF for a long time.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Introducer is the long-standing long-AD decode,
not a recent regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- `1d82a56bc5bf8` — partition check in `udf_read_inode()` (v4.11-rc1);
  inode location only, not file extents
- `ee703a7068f95` / `b405c1e58b739` — `udf_current_aext`/`udf_next_aext`
  return `-errno`; **present in this tree** (prerequisite for a clean
  `-EFSCORRUPTED` return)
- `5f0419457f89d` — related truncate OOB in `udf_free_blocks()` (wrong
  end-block vs partition length); **present**; still does not check
  partition index
- Standalone patch (v2 of a single patch), not `X/Y`

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Only this UDF commit from Kyle Zeng in this tree. Weight comes
from **Jan Kara** applying it, not from the author being the maintainer.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `udf_current_aext()` to return `-errno` (`ee703a7068f95`).
That **is** in this tree. No missing helpers or struct fields. Can apply
standalone here.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 120ec50984b86` →
  https://patch.msgid.link/20260612225846.97678-1-kylebot@openai.com
- `b4 dig -a`: **v2** is the matching series (`[PATCH v2] udf: validate
  extent partition references...`)
- v1 (LKML): `[PATCH] udf: validate partition reference before freeing
  blocks` — check inside `udf_free_blocks()` instead
- Thread (`/tmp/udf-thread.mbox`): LKP compile errors from `sbi`
  declared in `udf_write_aext` and used in `udf_current_aext`
- Jan Kara (18 Jun 2026): “Thanks! I've added the patch to my tree (just
  deleting the spurious sbi variable addition).”
- No NAK. No reviewer `Cc: stable`. Maintainer accepted.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Kyle Zeng, `linux-kernel@vger.kernel.org`, Jan
Kara, `outbounddisclosures@openai.com`. Jan is the UDF maintainer.
`linux-fsdevel` was not on the original To/Cc; Jan still took the patch.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla `Reported-by`. The message describes a slab
OOB on truncate/free of a crafted long AD. A sibling UDF truncate OOB
(`5f0419457f89d`) documents `ftruncate(2)` after a user-mount of
removable UDF (UDisks/polkit) as a local availability issue. Same
trigger class; that report is for a different bounds bug, not this exact
partition-index hole.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: v1 was a `udf_free_blocks()` defense; v2 moved the check to the
common parser so all consumers are covered. Only v2 was merged.
`udf_free_blocks()` in this tree still has no partition-index check, so
this parser check is the defense for that OOB.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Web search of lore.kernel.org/stable for this subject did not
find a dedicated stable discussion. Absence of stable-list traffic is
not a negative signal here.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `udf_current_aext()`

**Step 5.2: TRACE CALLERS**
Record (verified with grep):
- `udf_next_aext()` — `ret = udf_current_aext(...); if (ret <= 0) return
  ret;`
- `udf_truncate_extents()` / tail of truncate loop — `while ((ret =
  udf_current_aext(...)) > 0)`, then `if (ret < 0) return ret`
- `__udf_add_aext` setup in `inode.c:2053` — `if (err <= 0) goto
  err_out`

`udf_next_aext()` is used from `inode_bmap()`, `extent_trunc` callers,
`directory.c`, `balloc.c`, `super.c`. Impact surface is **all UDF extent
walks**.

**Step 5.3: TRACE CALLEES**
Record: `udf_get_fileshortad` / `udf_get_filelongad`, `lelb_to_cpu`,
`UDF_SB()`. No new locks or allocations.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace-reachable after a UDF mount: `ftruncate` / file delete
/ write that frees extents. `inode_bmap()` is also on read, but
`udf_get_pblock()` already rejects a bad partition. The OOB is
truncate/free. Mount often needs `CAP_SYS_ADMIN`; desktop udisks can
still allow unprivileged mounts of removable UDF (documented on the
sibling truncate OOB).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same check already in `udf_read_inode()` and `udf_get_pblock()`.
`udf_free_blocks()`, `udf_prealloc_blocks()`, and `udf_new_block()`
still index `s_partmaps[partition]` without that check. Fixing the
decoder covers those consumers.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.**
- `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`
- `make kernelversion` → `7.3.0-rc4`
- Long-AD decode and `udf_free_blocks()` OOB index are in this checkout
- Bug introduced ~v2.6.23, long before this branch

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** on this tree. `udf_current_aext()` already
returns `int` / `-errno`. Context around the switch matches the hunk.
`git merge-base --is-ancestor ee703a7068f95 HEAD` is true.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `5f0419457f89d` is here (partition *length* on free, not
partition *index*). `1d82a56bc5bf8` only covers inode location. Nothing
else closes this hole except this check.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `fs/udf/` — **IMPORTANT** (real filesystem, not core VFS; not
staging). Data-path OOB on mountable media.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained by Jan Kara; recent 7.3 UDF work includes
integrity, leaks, deadlock, and other OOB/corruption checks. Mature code
with ongoing fuzz/LLM-found hardening.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Filesystem-specific / config-specific** (`CONFIG_UDF_FS`).
Anyone who mounts UDF (optical, ISO, some USB). Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Crafted/corrupted image with long ADs and `partitionReferenceNum
>= s_partitions`, then truncate/free. Not every boot. Reachable from
`ftruncate` after mount. Unprivileged trigger if the image can be
mounted without `CAP_SYS_ADMIN` (udisks/removable media).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Slab out-of-bounds read in `udf_free_blocks()` →
KASAN/oops/panic. **HIGH** (crash / local availability; not shown to be
a write primitive). Sibling UDF truncate OOB was described as a local
availability panic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** High for UDF users — stops a kernel OOB on corrupted
  media
- **Risk:** Very low — 7 lines, existing error API, maintainer-applied
- **Ratio:** Strongly favors applying the fix on this tree

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real slab OOB in `udf_free_blocks()` when a long AD carries a bad
  partition index
- That index path is still unchecked in this tree
- Truncate/free is a normal file operation after mount
- 7-line decoder check; same pattern as existing UDF partition checks
- Maintainer applied it (after fixing the mailed unused/`sbi` mistake)
- Callers already propagate `-errno`
- Prerequisite error-return refactor is in this tree
- Bug is old (long ADs since ~2.6.23)

AGAINST:
- No `Reported-by` / syzbot for this exact hole
- LLM-assisted; mailed v2 did not compile until Jan edited it
- UDF is not a default desktop root filesystem
- No `Cc: stable` (not a negative under these rules)

UNRESOLVED:
- Could not fetch lore.kernel.org HTML (HTTP 403); thread recovered via
  `b4 dig -m`
- No dedicated stable-list thread found
- No in-tree reproducer; mechanism is verified from code, not from a
  crash log in the commit

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — bounds check matches
   existing UDF checks; maintainer applied the compile-fixed version
2. Fixes a real bug that affects users? **PASS** — OOB on
   crafted/corrupted UDF truncate/free
3. Important issue? **PASS** — slab OOB / crash, HIGH
4. Small and contained? **PASS** — +7 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `udf_current_aext()` and
   `-errno` callers exist here

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not an ID/quirk/DT/docs exception. It is a normal memory-safety
filesystem fix.

**Step 9.4: MAKE YOUR DECISION**
This tree’s UDF decoder still hands untrusted long-AD partition
references to `udf_free_blocks()`, which indexes `s_partmaps[]` with no
partition bound. The check is small, already matches local error
handling, and was accepted by the UDF maintainer. It should be in this
tree.

------------------------------------------------
What the commit solves and why it matters here
------------------------------------------------
Long allocation descriptors store `partitionReferenceNum` on disk.
`udf_current_aext()` used to copy that into `eloc` and return success.
Truncate then calls `extent_trunc()` → `udf_free_blocks()`, which does
`s_partmaps[partition]` with no `s_partitions` check. A crafted UDF
image can produce a slab OOB read and a kernel oops. Validating the
reference in the common parser rejects that extent once for every
consumer.

------------------------------------------------
Stable rules / risk vs benefit
------------------------------------------------
The change is obviously correct, tiny, and does not add APIs. Benefit is
preventing a UDF crash on corrupted media; risk is a rejected extent
returning `-EFSCORRUPTED` on a path that already handles `-errno`. No
missing prerequisites in this checkout.

------------------------------------------------
Concerns
------------------------------------------------
The mailed v2 was broken (`sbi` in the wrong function); the committed
diff is the maintainer-corrected version, which is what this evaluation
uses. Older kernels without `ee703a7068f95` would need extra caller
work; **this tree already has that refactor**, so it is not a blocker
here.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed tags: Assisted-by Codex, SOB Kyle Zeng, Link
  patch.msgid.link, SOB Jan Kara; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +7 in `udf_current_aext()`; `udf_free_blocks()` still
  does `s_partmaps[partition]` with no index check
  (`fs/udf/balloc.c:668-669`); `extent_trunc()` calls
  `udf_free_blocks()` (`fs/udf/truncate.c:37-54`, `271`)
- [Phase 3] `git blame`: long-AD copy `28de7948a89676` (v2.6.23-rc1);
  check is `120ec50984b86`; error API `ee703a7068f95` (v6.12-rc2)
- [Phase 3] No Fixes: tag; `git merge-base --is-ancestor ee703a7068f95
  HEAD` true; `1d82a56bc5bf8` and `5f0419457f89d` are ancestors and do
  not close this hole
- [Phase 4] `b4 dig -c 120ec50984b86`: lore URL found; `-a`: v2 only;
  `-w`: Jan Kara CC’d; `-m`: LKP unused/`sbi` errors; Jan: applied after
  deleting spurious `sbi`
- [Phase 4] lore.kernel.org WebFetch returned 403; bodies taken from
  mbox + openwall/LKML mirrors
- [Phase 4] Stable lore search: no dedicated discussion found
- [Phase 5] Callers: `udf_next_aext`, truncate loop, `inode.c:2053`;
  `inode_bmap` propagates `err <= 0`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4; buggy decode and OOB index present
- [Phase 7] MAINTAINERS: UDF → Jan Kara; `fs/udf/` actively patched in
  7.3
- [Phase 8] Failure mode: slab OOB read on truncate/free of crafted long
  AD — HIGH
- UNVERIFIED: live KASAN reproducer for this exact image; unprivileged-
  mount path for *this* hole (documented only for the sibling truncate
  OOB)

**YES**

 fs/udf/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 271e3f0d1fb10..05d4e95ba3c61 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -2312,6 +2312,13 @@ int udf_current_aext(struct inode *inode, struct extent_position *epos,
 		return -EINVAL;
 	}
 
+	if (eloc->partitionReferenceNum >= UDF_SB(inode->i_sb)->s_partitions) {
+		udf_debug("invalid partition reference %u (partitions %u)\n",
+			  eloc->partitionReferenceNum,
+			  UDF_SB(inode->i_sb)->s_partitions);
+		return -EFSCORRUPTED;
+	}
+
 	return 1;
 }
 
-- 
2.53.0

