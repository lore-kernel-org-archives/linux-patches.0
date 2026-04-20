Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC9D44B683;
	Mon, 20 Apr 2026 13:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691812; cv=none; b=r+IwmZSC2fiNQgicgWd/Wvd8Q0g2uZjHQG5A/L9WOPyPH4C1fXroT+C08PsTHIhEnQlb9MwEtUn5RbQtkJDpp6WME9po/KBwiPtiMv0PAk/96GFUigOgM1tikE5uQVMnQEBlMcwre8TT+Y10rrAsvyiI00hi1AArBfzKOsseXsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691812; c=relaxed/simple;
	bh=YiA0Fxr6zIQMlNB4F93jq52OlcC6xrj3s5JwzMSri9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=alUzWD4bAB1IMqC3LYno7JtbKyDdDtDS6edsy+Sj9uQOUMGQfWn27lAIlG9QOY3mVOUc5boSva4pz8KgXlx60G8dacsnQ5jJhfPKs3oEkfrHLUoSx17Jd/MtZ6/q7WKNhL9TfyMuYCMsdQS9AlBehMYRMld8ZH6KC6+d956iocU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2iKRqSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2iKRqSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3940FC2BCC4;
	Mon, 20 Apr 2026 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691812;
	bh=YiA0Fxr6zIQMlNB4F93jq52OlcC6xrj3s5JwzMSri9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2iKRqSYFvIsc7Z3glR04GW/eTqxYPUlOaqfs11C3ipfv2NlaCVFf5vimTHQJqFRm
	 GkZwO0eNJwYF9A6EdEx8zfB1Ygo2JOY3SeqXzgnICim8wsVF2NH1+aHYnUGnd2TkSU
	 0MdqNc/mGlx0l5R0zBV6GrBSpFaC2+U8zq11kSbPMa62ztiqbLeJcMJedtex1mmesR
	 gAdAS/EAQxoYFQ1418tk8EUcDjEGLYxxBBUdfBOKrYSzX2txSKD7xw7GEdwTUmq0HR
	 B6Gifp6Ne9GF+e6d9P/dzQdzwoPVP3OopgNtrND7SLme0wsNm12FRUr4IVTM1+6ehU
	 7E0NlVPkoNNcw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yang Wen <anmuxixixi@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sj1557.seo@samsung.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] exfat: use truncate_inode_pages_final() at evict_inode()
Date: Mon, 20 Apr 2026 09:20:03 -0400
Message-ID: <20260420132314.1023554-209-sashal@kernel.org>
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

From: Yang Wen <anmuxixixi@gmail.com>

[ Upstream commit 4637b4cdd7aebfa2e38fa39f4db91fa089b809c5 ]

Currently, exfat uses truncate_inode_pages() in exfat_evict_inode().
However, truncate_inode_pages() does not mark the mapping as exiting,
so reclaim may still install shadow entries for the mapping until
the inode teardown completes.

In older kernels like Linux 5.10, if shadow entries are present
at that point,clear_inode() can hit

    BUG_ON(inode->i_data.nrexceptional);

To align with VFS eviction semantics and prevent this situation,
switch to truncate_inode_pages_final() in ->evict_inode().

Other filesystems were updated to use truncate_inode_pages_final()
in ->evict_inode() by commit 91b0abe36a7b ("mm + fs: store shadow
entries in page cache")'.

Signed-off-by: Yang Wen <anmuxixixi@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information for a comprehensive analysis. Let me
compile the full assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `exfat` (filesystem)
- Action verb: "use" — implies correcting an incorrect API usage
- Summary: Switch from `truncate_inode_pages()` to
  `truncate_inode_pages_final()` in `evict_inode()`
- Record: [exfat] [use/correct] [Switch to correct VFS eviction API]

**Step 1.2: Tags**
- Signed-off-by: Yang Wen <anmuxixixi@gmail.com> (author)
- Signed-off-by: Namjae Jeon <linkinjeon@kernel.org> (exfat maintainer —
  approval)
- No Fixes: tag, no Cc: stable — expected for this review pipeline
- No Reported-by, Link, or Tested-by tags
- Record: Maintainer (Namjae Jeon) signed off — strong quality signal.

**Step 1.3: Commit Body**
The commit explains:
1. exfat uses `truncate_inode_pages()` in `evict_inode()`, which doesn't
   set `AS_EXITING`
2. Without `AS_EXITING`, reclaim can install shadow entries into the
   page cache after truncation
3. On Linux 5.10, leftover shadow entries trigger
   `BUG_ON(inode->i_data.nrexceptional)` in `clear_inode()` — a kernel
   crash
4. Other filesystems were already converted by commit 91b0abe36a7b
   (2014), but exfat was added later (2020) and missed this
- Record: Bug = incorrect VFS API usage allowing race with reclaim;
  Symptom = BUG_ON crash on 5.10, semantic incorrectness on all
  versions; Root cause = exfat added after the 91b0abe36a7b mass
  conversion and missed the pattern.

**Step 1.4: Hidden Bug Fix?**
This is an explicit bug fix, not hidden. The commit clearly describes
incorrect VFS semantics that can cause a kernel crash.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file: `fs/exfat/inode.c`
- Single line changed: `-1 / +1`
- Function modified: `exfat_evict_inode()`
- Scope: Minimal surgical fix — a single API call replacement
- Record: [fs/exfat/inode.c: +1/-1] [exfat_evict_inode] [single-file
  surgical fix]

**Step 2.2: Code Flow Change**
- BEFORE: `truncate_inode_pages(&inode->i_data, 0)` — truncates pages
  but does NOT set `AS_EXITING` flag
- AFTER: `truncate_inode_pages_final(&inode->i_data)` — sets
  `AS_EXITING` flag, cycles the xarray lock, then truncates pages

Looking at the implementation of `truncate_inode_pages_final()`:

```495:521:mm/truncate.c
 - Filesystems have to use this in the .evict_inode path to inform the
 - VM that this is the final truncate and the inode is going away.
 */
void truncate_inode_pages_final(struct address_space *mapping)
{
        mapping_set_exiting(mapping);
        // ... lock cycling for memory ordering ...
        truncate_inode_pages(mapping, 0);
}
```

The function literally just adds `mapping_set_exiting()` + a lock cycle,
then calls `truncate_inode_pages(mapping, 0)` — the exact same call
being replaced.

**Step 2.3: Bug Mechanism**
- Category: Race condition / incorrect VFS API usage
- Without `AS_EXITING`, page reclaim can race with inode teardown and
  install shadow entries into the address space mapping after truncation
  but before `clear_inode()`. On 5.10 kernels, `clear_inode()` had
  `BUG_ON(inode->i_data.nrexceptional)` which would fire.
- Record: [Race condition] [Reclaim installs shadow entries during inode
  teardown; BUG_ON crash on 5.10]

**Step 2.4: Fix Quality**
- Obviously correct — `truncate_inode_pages_final()` is the documented
  mandatory API for `.evict_inode` paths
- The VFS default path already uses it (line 848 of `fs/inode.c`)
- All 40+ other filesystems use it
- FAT (exfat's closest relative) uses it
- Zero regression risk — `truncate_inode_pages_final()` is a strict
  superset of `truncate_inode_pages(mapping, 0)`
- Record: [Obviously correct, zero regression risk]

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The buggy line was introduced in commit `5f2aa075070cf5` ("exfat: add
inode operations") by Namjae Jeon, dated 2020-03-02, merged for v5.7.
The `truncate_inode_pages()` call has been present since the first
commit of exfat.

**Step 3.2: Fixes Tag**
No Fixes: tag present. The bug was introduced when exfat was added
(5f2aa075070cf5). The referenced commit 91b0abe36a7b from 2014 converted
most filesystems but exfat didn't exist yet.

**Step 3.3: File History**
Recent changes to `fs/exfat/inode.c` are mostly cleanups and multi-
cluster support — none touching `evict_inode()`. This fix is standalone
with no dependencies.

**Step 3.4: Author**
Yang Wen (anmuxixixi@gmail.com) appears to be a contributor to exfat.
The fix is signed off by Namjae Jeon, the exfat maintainer.

**Step 3.5: Dependencies**
None. The fix uses `truncate_inode_pages_final()` which has existed
since 2014 (v3.15+). It's available in every stable tree.

## PHASE 4: MAILING LIST RESEARCH

Could not access lore.kernel.org directly due to Anubis protection. Web
search found other patches by Yang Wen for exfat but not this specific
patch. The commit is likely very recent and may not be fully indexed
yet. The maintainer sign-off by Namjae Jeon indicates proper review.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Function**
Modified function: `exfat_evict_inode()`

**Step 5.2: Callers**
`exfat_evict_inode` is the `.evict_inode` callback in exfat's
super_operations. It's called by the VFS `evict()` function in
`fs/inode.c` (line 846) during inode teardown — a very common operation
triggered by:
- File deletion (`unlink` -> last `iput`)
- Cache eviction (memory pressure)
- Unmounting filesystems

**Step 5.3-5.4: Call chain**
The VFS default itself uses `truncate_inode_pages_final()` when no
`.evict_inode` is defined (line 848). This confirms exfat MUST use it
too.

**Step 5.5: Similar Patterns**
Only exfat still uses `truncate_inode_pages()` in an evict_inode
context. All other filesystems (fat, ext4, btrfs, xfs, f2fs, ntfs3,
etc.) already use `truncate_inode_pages_final()`. The gfs2 commits
`a9dd945ccef07` and `ee1e2c773e4f4` fixed similar missing calls and were
considered important bug fixes.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable?**
The buggy code exists in ALL active stable trees since v5.7. exfat was
added in v5.7 (commit 5f2aa075070cf5). Active LTS trees affected:
5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y.

Critical: On **5.10.y**, `clear_inode()` still contains
`BUG_ON(inode->i_data.nrexceptional)` — the nrexceptional BUG_ON removal
(commit 786b31121a2ce) was merged in v5.13. So on 5.10 LTS, this bug can
cause a kernel crash.

**Step 6.2: Backport Complications**
None. The fix is a single-line change to a function that hasn't been
modified since its creation. Will apply cleanly to all stable trees.

**Step 6.3: Related Fixes Already in Stable?**
No. No other fix for this issue exists.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem Criticality**
exfat is an IMPORTANT filesystem — widely used for USB flash drives, SD
cards, and Windows/Linux interoperability. It's the default filesystem
for SDXC cards (64GB+) and is used on Android devices.

**Step 7.2: Activity**
exfat is actively maintained by Namjae Jeon. Regular bug fixes and
improvements flow through.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
All exfat users on all stable kernel versions.

**Step 8.2: Trigger Conditions**
Inode eviction — extremely common operation. Triggered by: deleting
files, dropping caches, memory pressure, unmounting. The race with
reclaim requires memory pressure during inode eviction, which is
realistic on systems with limited memory (embedded, mobile).

**Step 8.3: Failure Mode Severity**
- On 5.10.y: `BUG_ON` -> kernel crash -> **CRITICAL**
- On 5.13+: Semantic incorrectness, potential for reclaim to interact
  incorrectly with dying inodes -> **MEDIUM-HIGH**

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Prevents kernel crashes on 5.10.y; fixes incorrect VFS
  semantics on all versions; aligns with all other filesystems
- RISK: Effectively ZERO — `truncate_inode_pages_final()` is a strict
  superset that adds `AS_EXITING` before doing exactly the same thing
- Ratio: Extremely favorable

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
1. Fixes a real bug: race between reclaim and inode teardown
2. On 5.10 LTS: can trigger `BUG_ON` crash (CRITICAL severity)
3. Single-line change — absolute minimum risk
4. Obviously correct — documented VFS requirement ("Filesystems have to
   use this in the .evict_inode path")
5. All other filesystems already use the correct API
6. FAT filesystem (exfat's closest relative) already uses it
7. Approved by exfat maintainer (Namjae Jeon)
8. Applies cleanly to all stable trees
9. No dependencies — uses an API available since v3.15
10. exfat is a widely-used filesystem (USB, SD cards, cross-platform)

**Evidence AGAINST backporting:**
- None identified

**Stable Rules Checklist:**
1. Obviously correct and tested? **YES** — trivial API replacement,
   maintainer-approved
2. Fixes a real bug? **YES** — crash on 5.10, incorrect semantics on all
   versions
3. Important issue? **YES** — kernel crash (CRITICAL)
4. Small and contained? **YES** — single line change, one file
5. No new features or APIs? **YES** — uses existing API
6. Can apply to stable? **YES** — no dependencies, clean apply expected

## Verification

- [Phase 1] Parsed tags: Signed-off-by from author (Yang Wen) and
  maintainer (Namjae Jeon)
- [Phase 2] Diff analysis: 1 line changed in `exfat_evict_inode()`,
  replaces `truncate_inode_pages()` with `truncate_inode_pages_final()`
- [Phase 3] git blame: buggy code from commit `5f2aa075070cf5` (v5.7,
  2020-03-02), present in all stable trees since v5.7
- [Phase 3] git show `91b0abe36a7b`: confirmed this 2014 commit
  converted other filesystems but predates exfat
- [Phase 3] git show `786b31121a2ce`: confirmed BUG_ON(nrexceptional)
  was removed in v5.13 — still present in 5.10.y
- [Phase 5] Read `mm/truncate.c:489-522`: Confirmed documentation says
  "Filesystems have to use this in the .evict_inode path"
- [Phase 5] Read `fs/inode.c:845-850`: VFS default uses
  `truncate_inode_pages_final()`, confirming it's mandatory
- [Phase 5] Grep: Confirmed all other filesystems (fat, ext4, btrfs,
  xfs, etc.) use `truncate_inode_pages_final()`; only exfat still uses
  the wrong function in evict_inode
- [Phase 6] git log v5.7 -- fs/exfat/inode.c: Confirmed exfat exists
  since v5.7, present in 5.10.y+
- [Phase 6] No conflicting changes to `exfat_evict_inode()` — function
  unchanged since creation
- [Phase 7] Namjae Jeon confirmed as exfat maintainer via git log
- [Phase 8] Risk: zero — `truncate_inode_pages_final()` is a strict
  superset of `truncate_inode_pages(mapping, 0)`
- UNVERIFIED: Could not access lore.kernel.org discussion thread due to
  Anubis protection (does not affect decision — the technical merit is
  clear)

**YES**

 fs/exfat/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 2fb2d2d5d503a..567308aff726a 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -686,7 +686,7 @@ struct inode *exfat_build_inode(struct super_block *sb,
 
 void exfat_evict_inode(struct inode *inode)
 {
-	truncate_inode_pages(&inode->i_data, 0);
+	truncate_inode_pages_final(&inode->i_data);
 
 	if (!inode->i_nlink) {
 		i_size_write(inode, 0);
-- 
2.53.0

