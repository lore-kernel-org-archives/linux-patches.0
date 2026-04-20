Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0404D8D98;
	Mon, 20 Apr 2026 13:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692009; cv=none; b=esryWscuuRx1+55a5w+Z3+MImGIqQysp8kEwmUlpC7MwOcfE3O397pEbICCxV0J91q0zfBoLsed/XkxxNiqXiZB8F1zGeN92AGU3G/O0gihT62DrR+OnXJRkr8782QrBFRq4Q5DyrI4yjRV20yJBTY6bIjbnJD7xJrJGye8cwyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692009; c=relaxed/simple;
	bh=dHAmhZks5wq6gGmCRgQQFtQcmWxQnoTOM5kp8zBG1ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AMtc7mOK3KhNdXvnstZ62Buw1+Q39UGHtNMNacJPl38HcM0q0Z+PwTXLfoVpUC/sVUV7Utbc6eayC/lYxl/Y9RP4PCeo0CfVAALUIm3B7T0HsoC6mg1cPQeWXxDO70W/gAAQ4brxcP51NuqrhYB5eWHH/pAGOh0ITZmPQqoJUQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GniJVXAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GniJVXAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C12C19425;
	Mon, 20 Apr 2026 13:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692008;
	bh=dHAmhZks5wq6gGmCRgQQFtQcmWxQnoTOM5kp8zBG1ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GniJVXAL2LHbLwtughI/M9kZPZTe53ld6/wl4cA1tjGSr3S5GjjQymRTd9t/xzc1s
	 eLpz1MxUvjG1DEL2Ft5W2JDik1DRICdmFY2cdbbFwgd9lPVpWuvpesOMh89cgGphJT
	 8vUg1u3romNOUDTi/pc8m33gxIYP4+eaohoHkVdTLdq+x93jnd5KinHNQ+T6UpXyxt
	 PvvY5tnWySpXV2p750VHRDabGlmOQ9uMPTLUtyQLQOV59pkc6ak7e93wpTdKE/lkho
	 jWTZuIgRdzFWJByA90UGL8hyxDuWdC3CKeSZ+Cd0r7DexUtUgBryPa56CeZBmK3OQC
	 QbKW7b/Zt1zaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chi Zhiling <chizhiling@kylinos.cn>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] exfat: fix incorrect directory checksum after rename to shorter name
Date: Mon, 20 Apr 2026 09:21:53 -0400
Message-ID: <20260420132314.1023554-319-sashal@kernel.org>
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

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit ff37797badd831797b8a27830fe5046d7e23fdc3 ]

When renaming a file in-place to a shorter name, exfat_remove_entries
marks excess entries as DELETED, but es->num_entries is not updated
accordingly. As a result, exfat_update_dir_chksum iterates over the
deleted entries and computes an incorrect checksum.

This does not lead to persistent corruption because mark_inode_dirty()
is called afterward, and __exfat_write_inode later recomputes the
checksum using the correct num_entries value.

Fix by setting es->num_entries = num_entries in exfat_init_ext_entry.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the complete
analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `exfat` (filesystem)
- Action verb: "fix"
- Summary: Fix incorrect directory checksum computed after in-place
  rename to a shorter filename.

**Step 1.2: Tags**
- `Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>` - author, KylinOS
  developer
- `Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>` - Samsung, known
  exfat maintainer
- `Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>` - Sony, major exfat
  contributor (authored the dentry cache conversion)
- `Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>` - exfat subsystem
  maintainer, committed the patch
- No Fixes: tag, no Cc: stable, no Reported-by (expected for manual
  review candidates)

**Step 1.3: Commit Body**
- Bug: When renaming in-place to a shorter name, `exfat_remove_entries`
  marks excess entries as DELETED, but `es->num_entries` is NOT updated.
  Then `exfat_update_dir_chksum` iterates over the stale (larger) count,
  including DELETED entries in the checksum calculation.
- The author states this does NOT lead to persistent corruption under
  normal operation because `__exfat_write_inode` later recomputes the
  checksum correctly.
- Fix: Set `es->num_entries = num_entries` in `exfat_init_ext_entry`.

**Step 1.4: Hidden Bug Fix Detection**
This is explicitly labeled as a "fix" - no disguise needed. It's a clear
correctness fix.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file changed: `fs/exfat/dir.c`
- 1 line added: `es->num_entries = num_entries;`
- Function modified: `exfat_init_ext_entry()`
- Scope: single-file, single-line surgical fix

**Step 2.2: Code Flow Change**
In `exfat_init_ext_entry` (line 486-507):
- BEFORE: The function updates `file.num_ext`, stream entry, and name
  entries, then calls `exfat_update_dir_chksum(es)` which uses
  `es->num_entries` (which may be stale/larger).
- AFTER: The function first sets `es->num_entries = num_entries`,
  ensuring `exfat_update_dir_chksum` uses the correct count.

**Step 2.3: Bug Mechanism**
Category: **Logic/correctness fix** - stale state variable leading to
incorrect checksum computation.

The chain of events:
1. `exfat_rename_file()` calls `exfat_remove_entries(&old_es,
   ES_IDX_FIRST_FILENAME + 1)` which marks entries 3..old_num-1 as
   DELETED
2. `exfat_init_ext_entry(&old_es, num_new_entries, ...)` sets
   `file.num_ext = num_new_entries - 1` but doesn't update
   `es->num_entries`
3. `exfat_update_dir_chksum(es)` iterates `i = 0..es->num_entries-1` -
   this includes DELETED entries
4. Wrong checksum stored in file entry's `checksum` field
5. Written to disk via `exfat_put_dentry_set`

**Step 2.4: Fix Quality**
- Obviously correct: the function takes `num_entries` parameter and
  already uses it for loop bounds and `num_ext`; syncing
  `es->num_entries` is clearly the right thing.
- Minimal: 1 line.
- No regression risk: For all callers where `es->num_entries` already
  equals `num_entries`, this is a harmless no-op. Only the buggy rename-
  to-shorter path gets different behavior.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- `exfat_init_ext_entry` was created in `ca06197382bde0` (v5.7-rc1,
  Namjae Jeon, 2020-03-02) when exfat was first added.
- Converted to dentry cache in `d97e060673906d` (v6.9-rc1, Yuezhang Mo,
  2022-08-05).
- `exfat_update_dir_chksum(es)` added inside the function by
  `4d71455976891` (v6.9-rc1, Yuezhang Mo, 2022-08-05) - THIS is the
  commit that introduced the bug.

**Step 3.2: Bug Introduction**
The bug was introduced in commit `4d71455976891` ("exfat: remove unused
functions"), first in v6.9-rc1. Before this, `exfat_update_dir_chksum`
was called separately where the correct `num_entries` was used. After
this commit, the checksum computation moved into `exfat_init_ext_entry`
but relied on `es->num_entries` being correct, which isn't always the
case.

**Step 3.3: Affected Stable Trees**
- `4d71455976891` IS in v6.12: **YES** (verified with `git merge-base
  --is-ancestor`)
- `4d71455976891` is NOT in v6.6: **YES** (verified)
- `4d71455976891` is NOT in v6.1: **YES** (verified)
- So only v6.12.y and later are affected.

**Step 3.4: Author Context**
Chi Zhiling has other exfat contributions (cache improvements). Yuezhang
Mo is the author of the original dentry cache conversion that
contributed to this bug, and reviewed this fix. The fix was applied by
Namjae Jeon, the exfat maintainer.

**Step 3.5: Dependencies**
None. The fix is self-contained - it adds one line to an existing
function. No prerequisites needed.

## PHASE 4: MAILING LIST RESEARCH

Lore.kernel.org is currently behind anti-bot protection, preventing
direct access. Unable to fetch mailing list discussion.

Record: Could not verify mailing list discussion due to lore access
restrictions.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Function**
`exfat_init_ext_entry()` is modified.

**Step 5.2: Callers**
Four call sites found:
1. `namei.c:512` - `exfat_add_entry()` (new file/dir creation) - `es` is
   freshly created, `num_entries` matches. Safe.
2. `namei.c:1057` - `exfat_rename_file()`, new entry path (rename to
   longer name) - `new_es` freshly created. Safe.
3. `namei.c:1073` - `exfat_rename_file()`, in-place path (rename to
   shorter name) - **THIS IS THE BUGGY CALLER**. `old_es.num_entries` is
   stale.
4. `namei.c:1117` - `exfat_move_file()` - `new_es` freshly created.
   Safe.

**Step 5.3: Callees**
`exfat_init_ext_entry` calls `exfat_update_dir_chksum(es)` which
iterates `es->num_entries` entries. This is where the wrong checksum is
computed.

**Step 5.4: Reachability**
The buggy path is reached via: `rename(2)` → `exfat_rename()` →
`__exfat_rename()` → `exfat_rename_file()` (else branch when
`old_es.num_entries >= num_new_entries`). This is triggered by any user
renaming a file to a shorter name on an exfat filesystem. **Directly
reachable from userspace.**

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable**
The bug (commit `4d71455976891`) exists in v6.12.y but NOT in v6.6.y or
v6.1.y.

**Step 6.2: Backport Complications**
The patch is a single-line addition. The `exfat_init_ext_entry` function
exists with the same structure in all affected stable trees. Should
apply cleanly.

**Step 6.3: Related Fixes Already in Stable**
No related fixes found.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
- Filesystem: exfat (`fs/exfat/`)
- Criticality: IMPORTANT. exfat is the standard filesystem for SDXC
  cards, USB drives >32GB, and cross-platform file exchange. Very widely
  used.

**Step 7.2: Activity**
Active subsystem with regular contributions from Samsung and Sony
engineers. Stable with well-maintained code.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who Is Affected**
All users of exfat filesystems who rename files to shorter names. This
includes USB drive users, SD card users, and any system mounting exfat
volumes.

**Step 8.2: Trigger Conditions**
- Trigger: Renaming a file where the new name requires fewer directory
  entries (shorter name).
- Frequency: Common operation - users rename files regularly.
- Reachable from unprivileged user: Yes (any user with write access to
  the filesystem).

**Step 8.3: Failure Mode**
- Under normal operation: Transient incorrect checksum, corrected by
  inode writeback within ~30 seconds. Severity: LOW.
- Under crash (USB yank, power loss): On-disk checksum mismatch
  persists. Other OS (Windows, macOS) that validate exfat checksums may
  refuse to read the file. fsck.exfat tools will report corruption.
  Severity: MEDIUM.
- The Linux exfat driver does NOT validate checksums on read (confirmed
  by code review of `exfat_get_dentry_set`), so Linux itself would still
  read the entry, but cross-platform compatibility is compromised.

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: HIGH for crash resilience and cross-platform correctness.
  exfat is designed for removable media where surprise removal is
  common.
- RISK: VERY LOW. Single line, no-op for all callers except the buggy
  one, reviewed by two domain experts.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Fixes a real filesystem correctness bug (incorrect on-disk checksum)
- Single line fix, obviously correct, minimal risk
- Reviewed by Sungjong Seo (Samsung) and Yuezhang Mo (Sony) - the two
  primary exfat reviewers
- Applied by the subsystem maintainer (Namjae Jeon)
- Triggered by common user operation (rename) reachable from userspace
- exfat is widely used on removable media where crash/surprise removal
  is common
- Crash during the window leaves persistent checksum corruption visible
  to other OS

AGAINST backporting:
- Author states no persistent corruption under normal operation
  (writeback corrects it)
- Linux exfat driver doesn't validate checksums on read (so Linux users
  won't notice)
- Impact only manifests on crash during rename + subsequent read by
  another OS or fsck

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** - single line, reviewed by two
   experts
2. Fixes a real bug? **YES** - incorrect checksum written to disk
3. Important issue? **YES** - filesystem data integrity (checksum
   corruption on crash)
4. Small and contained? **YES** - 1 line in 1 file
5. No new features or APIs? **YES** - pure bug fix
6. Can apply to stable? **YES** - should apply cleanly

**Step 9.3: Exception Categories**
Not applicable - this is a standard bug fix.

**Verification:**
- [Phase 1] Parsed tags: Reviewed-by from two key exfat contributors
  (Seo, Mo), applied by maintainer (Jeon)
- [Phase 2] Diff analysis: 1 line added (`es->num_entries =
  num_entries;`) in `exfat_init_ext_entry()`
- [Phase 3] git blame: `exfat_update_dir_chksum(es)` added to the
  function by commit `4d71455976891` (v6.9-rc1)
- [Phase 3] git describe --contains: bug commit `4d71455976891` first in
  v6.9-rc1
- [Phase 3] git merge-base: confirmed present in v6.12, NOT in v6.6 or
  v6.1
- [Phase 5] Grep for callers: 4 call sites, only `namei.c:1073` (rename-
  in-place to shorter name) is affected
- [Phase 5] Code review of `exfat_update_dir_chksum`: confirmed it uses
  `es->num_entries` for loop bound
- [Phase 5] Code review of `exfat_remove_entries`: confirmed it does NOT
  update `es->num_entries`
- [Phase 5] Code review of `exfat_get_dentry_set`: confirmed Linux
  driver doesn't validate checksums on read
- [Phase 6] Verified `exfat_rename_file` rename path at
  namei.c:1066-1075 shows the sequence: remove_entries then
  init_ext_entry
- [Phase 6] Verified `__exfat_write_inode` at inode.c:20-98 re-reads
  dentry set with correct count and recomputes checksum
- [Phase 8] Verified `exfat_rename()` at namei.c:1282-1285 calls
  `mark_inode_dirty(old_inode)` after rename, confirming eventual
  writeback
- UNVERIFIED: Could not access lore.kernel.org to read mailing list
  discussion (anti-bot protection)

The fix is a minimal, obviously correct single-line change that fixes a
real filesystem correctness bug (incorrect checksum written to disk
during rename-to-shorter-name). The incorrect checksum creates a crash-
vulnerability window where surprise removal or power loss can leave
persistent corruption visible to other operating systems and filesystem
checkers. The fix was reviewed by two exfat domain experts and applied
by the subsystem maintainer.

**YES**

 fs/exfat/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index e710dd196e2f0..2a4f6a131fbe7 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -490,6 +490,7 @@ void exfat_init_ext_entry(struct exfat_entry_set_cache *es, int num_entries,
 	unsigned short *uniname = p_uniname->name;
 	struct exfat_dentry *ep;
 
+	es->num_entries = num_entries;
 	ep = exfat_get_dentry_cached(es, ES_IDX_FILE);
 	ep->dentry.file.num_ext = (unsigned char)(num_entries - 1);
 
-- 
2.53.0

