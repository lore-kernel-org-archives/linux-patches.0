Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A24B47D927;
	Mon, 20 Apr 2026 13:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691861; cv=none; b=nKRQ5ouGxPEFjsXCGfD2xgzK2RQIf8PKKyr048oVJFn7tPepq6kVdlKSXV5VqHUSeESoGz6NHvwzw5hul3WlXOziSYgZl+bx+1hgdyc+1GWSNSCe0WLrcgPRIU0Ahky10Eh4gLQk4fTy4CG1+imyukoJ2cEWbLZBMvTFHazorMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691861; c=relaxed/simple;
	bh=48JtW9cCcmV/lE6IItbeHK7PJgdusZOtDdUqSrtKxPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HMVgAXH1m/JRAp4mQZXPcKGgB/Wh4ZEGI+O/4k8++LWYEbjarG64OZgwoBPaJtMKCzEsUVJX5ukBKiF7spBtUybEjs/WZX+nc6nxteLTj4LQw+slZbUp1P4sIySE8rx8eJIlBy3x9RBG8lS3e6igohFlEuI7im+7eQFi/jshXts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOHzJf8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOHzJf8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159D9C19425;
	Mon, 20 Apr 2026 13:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691861;
	bh=48JtW9cCcmV/lE6IItbeHK7PJgdusZOtDdUqSrtKxPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOHzJf8Wn+daNTJmbSVd1Y6aTbH1pifOJvIUZm1xM0e6A4+HrErP9ZEttDwRF7IhX
	 L55U8Twq12GWGGGbOPb6Kokbut9P1kkQ2cuHQEnAq69lGbVCKACUI3l9pZYhJw2NlL
	 DN5jawpONnxBxzGRPmOMZLf6VnOJNHE207fZLEuyYv6DsTp/PUlVQpluz2fRp0JqEU
	 AEHFff9x4z61KplWVMg/bL+Cm7tCDsV/xPF5zRAGgEFKpeCc+1ya76ME/UCQQukFdW
	 agKnBHMabNQIfGx1Ep+mdMLcrQYbJ+AJNzWdAQkoCGttfb04kizUQeIwr+b0hLnx0G
	 TIPumgpQgLpmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] pstore: fix ftrace dump, when ECC is enabled
Date: Mon, 20 Apr 2026 09:20:31 -0400
Message-ID: <20260420132314.1023554-237-sashal@kernel.org>
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

From: Andrey Skvortsov <andrej.skvortzov@gmail.com>

[ Upstream commit 4ef6255cc56343bc90d82420b49dab1b11dee414 ]

total_size is sum of record->size and record->ecc_notice_size (ECC: No
errors detected). When ECC is not used, then there is no problem.
When ECC is enabled, then ftrace dump is decoded incorrectly after
restart.

First this affects starting offset calculation, that breaks
reading of all ftrace records.

  CPU:66 ts:51646260179894273 3818ffff80008002  fe00ffff800080f0  0x3818ffff80008002 <- 0xfe00ffff800080f0
  CPU:66 ts:56589664458375169 3818ffff80008002  ff02ffff800080f0  0x3818ffff80008002 <- 0xff02ffff800080f0
  CPU:67 ts:13194139533313 afe4ffff80008002  1ffff800080f0  0xafe4ffff80008002 <- 0x1ffff800080f0
  CPU:67 ts:13194139533313 b7d0ffff80008001  100ffff80008002  0xb7d0ffff80008001 <- 0x100ffff80008002
  CPU:67 ts:51646260179894273 8de0ffff80008001  202ffff80008002  0x8de0ffff80008001 <- 0x202ffff80008002

Second ECC notice message is printed like ftrace record and as a
result couple of last records are completely wrong.

For example, when the starting offset is fixed:

 CPU:0 ts:113 ffffffc00879bd04  ffffffc0080dc08c  cpuidle_enter <- do_idle+0x20c/0x290
 CPU:0 ts:114 ffffffc00879bd04  ffffffc0080dc08c  cpuidle_enter <- do_idle+0x20c/0x290
 CPU:100 ts:28259048229270629 6f4e203a4343450a  2073726f72726520  0x6f4e203a4343450a <- 0x2073726f72726520

Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Link: https://patch.msgid.link/20260215185156.317394-1-andrej.skvortzov@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information for a thorough analysis. Let me compile my
findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `pstore`
- **Action verb**: "fix" — explicitly a bug fix
- **Summary**: Fix ftrace dump decoding when ECC is enabled

Record: [pstore] [fix] [ftrace dump decoded incorrectly when ECC is
enabled]

### Step 1.2: Tags
- **Signed-off-by**: Andrey Skvortsov <andrej.skvortzov@gmail.com>
  (author)
- **Tested-by**: Guilherme G. Piccoli <gpiccoli@igalia.com> (independent
  tester)
- **Link**: https://patch.msgid.link/20260215185156.317394-1-
  andrej.skvortzov@gmail.com
- **Signed-off-by**: Kees Cook <kees@kernel.org> (pstore subsystem
  maintainer — applied the patch)

Record: Patch tested independently by Guilherme Piccoli and applied by
subsystem maintainer Kees Cook. No syzbot, but this is a real-world ECC
usage bug.

### Step 1.3: Commit Body
The commit clearly explains:
- `total_size` = `record->size + record->ecc_notice_size`. When ECC is
  enabled, this includes the ECC notice string (e.g. "ECC: No errors
  detected").
- **Bug 1**: The starting offset calculation `total_size % REC_SIZE` is
  wrong because it should only use the ftrace data size, not total size
  including ECC notice. This corrupts ALL ftrace record offsets.
- **Bug 2**: The boundary check `data->off + REC_SIZE > ps->total_size`
  allows iteration to read into the ECC notice string area, interpreting
  text bytes as ftrace records.
- Concrete examples of corrupted output are provided showing garbled
  entries.

Record: Bug is data corruption in ftrace dump. When ECC is off, no
problem. When ECC is on, two symptoms: (1) wrong starting offset breaks
all records, (2) ECC text is decoded as ftrace records.

### Step 1.4: Hidden Bug Fix Detection
This is an explicit fix, not hidden.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **1 file changed**: `fs/pstore/inode.c`
- **3 lines changed**: Each replaces `ps->total_size` with
  `ps->record->size`
- **Functions modified**: `pstore_ftrace_seq_start()` (2 changes),
  `pstore_ftrace_seq_next()` (1 change)
- **Scope**: Single-file surgical fix

Record: Extremely small, 3-line change in 2 functions, single file.

### Step 2.2: Code Flow Change
- **Before**: Ftrace seq iterators used `ps->total_size` (=
  `record->size + record->ecc_notice_size`) for offset calculation and
  boundary checks
- **After**: They use `ps->record->size` (= just the ftrace data
  portion)

This is correct because:
- Buffer layout: `[ftrace data: record->size bytes][ECC notice:
  ecc_notice_size bytes]`
- Only the first `record->size` bytes contain valid ftrace records

### Step 2.3: Bug Mechanism
**Category**: Logic/correctness fix — wrong size variable used for array
bounds

The code at line 77 computes `total_size % REC_SIZE` to find the
alignment offset of the first ftrace record, but `total_size` includes
the ECC notice string length. Similarly, bounds checks at lines 79 and
97 allow reading past the actual ftrace data into the ECC string.

### Step 2.4: Fix Quality
- **Obviously correct**: Yes — the buffer contains ftrace data in `[0,
  record->size)` and ECC text in `[record->size, total_size)`. The
  ftrace iterator should only read the former.
- **Minimal**: 3 identical substitutions
- **Regression risk**: Essentially zero — this change restricts
  iteration to the valid ftrace region
- **No red flags**: Does not touch locking, APIs, or public interfaces

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy lines were introduced in commit `83f70f0769ddd8` ("pstore: Do
not duplicate record metadata") from 2017-03-04. This commit refactored
`pstore_private` to hold a pointer to `pstore_record` and introduced
`total_size = record->size + record->ecc_notice_size`. When replacing
the old `ps->size` with `ps->total_size` in the ftrace functions, the
semantic change was incorrect — `ps->size` in the old code was already
wrong (it too was set to the total size including ECC).

Verified: The bug was introduced in **v4.12-rc1** (first appeared in
`v4.12-rc1~136^2~8`).

### Step 3.2: Fixes Tag
No explicit Fixes: tag in the commit message (expected for AUTOSEL
candidates). But git blame clearly traces the bug to commit
`83f70f0769ddd8`.

### Step 3.3: File History
Recent changes to `fs/pstore/inode.c` are cosmetic (kmalloc_obj
conversions, cleanup.h adoption, mount API conversion). No conflicting
changes to the ftrace seq functions.

### Step 3.4: Author
Andrey Skvortsov is not a regular pstore contributor. However, the patch
was applied by Kees Cook, the pstore subsystem maintainer, and
independently tested by Guilherme Piccoli.

### Step 3.5: Dependencies
None. The fix replaces `ps->total_size` with `ps->record->size`. Both
fields exist in all stable trees since v4.12. The `pstore_private`
struct has had both `total_size` and `record` pointer since v4.12.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.5
The lore.kernel.org search was blocked by anti-scraping. However:
- The commit was applied by Kees Cook (maintainer SOB confirms)
- It has a Tested-by from Guilherme Piccoli
- The patch Link: uses `patch.msgid.link` confirming it went through
  standard review

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
- `pstore_ftrace_seq_start()` — seq_file start iterator
- `pstore_ftrace_seq_next()` — seq_file next iterator

### Step 5.2: Callers
These are seq_file callbacks registered in `pstore_ftrace_seq_ops`.
Called when userspace reads pstore ftrace files via
`/sys/fs/pstore/ftrace-*`.

### Step 5.3-5.4: Call Chain
Userspace `cat /sys/fs/pstore/ftrace-*` → `pstore_file_read()` →
`seq_read()` → `pstore_ftrace_seq_start/next/show`. Directly user-
triggered.

### Step 5.5: Similar Patterns
No similar patterns elsewhere — this is pstore-specific ftrace iteration
code.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The buggy code was introduced in v4.12 (2017). It exists in **ALL**
active stable trees (5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y, 7.0.y).

### Step 6.2: Backport Complications
The patch should apply cleanly to recent stable trees. The only
complication in older trees would be the `kzalloc_obj()` vs `kzalloc()`
difference and `return_ptr()` vs manual kfree — but the changed lines
themselves only modify `ps->total_size` → `ps->record->size` which is
stable across all trees since v4.12.

### Step 6.3: No related fixes already in stable for this issue.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1
- **Subsystem**: `fs/pstore` — persistent storage for crash diagnostics
  (ftrace, dmesg, console)
- **Criticality**: IMPORTANT — pstore is used in production for crash
  analysis, especially with ramoops on embedded/Android systems

### Step 7.2
pstore is a mature, moderately active subsystem maintained by Kees Cook.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users who have pstore with ECC enabled (ramoops backend with ECC). This
includes embedded systems and Android devices using persistent RAM for
crash diagnostics.

### Step 8.2: Trigger Conditions
Triggered every time a user reads ftrace records from pstore when ECC is
enabled. Common in production crash analysis workflows. The trigger is
simply: `cat /sys/fs/pstore/ftrace-*`.

### Step 8.3: Failure Mode
- **Data corruption**: Ftrace dump output is completely garbled
- **Severity**: MEDIUM-HIGH — crash diagnostic data is unusable, which
  defeats the purpose of pstore ftrace logging
- Not a kernel crash, but renders a key diagnostic feature broken

### Step 8.4: Risk-Benefit
- **Benefit**: HIGH — fixes a fundamental data decoding bug that makes
  ftrace pstore output useless when ECC is enabled
- **Risk**: VERY LOW — 3-line change replacing one size field with
  another, obviously correct from buffer layout analysis
- **Ratio**: Very favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backporting:**
- Fixes a real, clearly documented data corruption bug
- 3-line change, single file — minimal and surgical
- Obviously correct: ftrace records are in `[0, record->size)`, not `[0,
  total_size)`
- Tested independently (Tested-by: tag)
- Applied by subsystem maintainer (Kees Cook)
- Bug has existed since v4.12 (2017) — all stable trees affected
- No dependencies on other patches
- Zero regression risk

**AGAINST backporting:**
- None significant

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — verified by code analysis and
   has Tested-by
2. **Fixes a real bug?** YES — ftrace dump completely broken with ECC
3. **Important issue?** YES — data corruption (diagnostic data unusable)
4. **Small and contained?** YES — 3 lines in 1 file
5. **No new features or APIs?** Correct — no new features
6. **Can apply to stable?** YES — code and fields exist in all stable
   trees

### Step 9.3: Exception Categories
Not applicable — this is a straightforward bug fix.

---

## Verification

- [Phase 1] Parsed tags: Tested-by: Guilherme G. Piccoli, Signed-off-by:
  Kees Cook (maintainer), Link: patch.msgid.link URL
- [Phase 2] Diff analysis: 3 lines changed in
  `pstore_ftrace_seq_start()` and `pstore_ftrace_seq_next()`, replacing
  `ps->total_size` with `ps->record->size`
- [Phase 3] git blame: buggy code introduced in commit 83f70f0769ddd8
  (v4.12, 2017), present in all active stable trees
- [Phase 3] git show 83f70f0769ddd8: confirmed the refactoring that
  introduced `total_size` replacing old `size` field, where both
  incorrectly included ECC notice size for ftrace
- [Phase 3] git describe --contains 83f70f0769ddd8: v4.12-rc1~136^2~8 —
  confirmed version
- [Phase 4] lore.kernel.org blocked by anti-scraping; confirmed commit
  was accepted by maintainer via SOB
- [Phase 5] Callers: seq_file callbacks triggered via userspace read on
  `/sys/fs/pstore/ftrace-*` — user-triggered
- [Phase 5] Verified buffer layout from `ramoops_pstore_read()`:
  `[ftrace data: size bytes][ECC string: ecc_notice_size bytes]`
- [Phase 6] Code exists in all active stable trees (v5.10+, bug
  introduced in v4.12)
- [Phase 6] No conflicting changes — recent changes to the file are
  cosmetic (kmalloc_obj, cleanup.h)
- [Phase 8] Failure mode: complete corruption of ftrace dump output when
  ECC enabled, severity MEDIUM-HIGH
- [Phase 8] Risk: VERY LOW — 3 identical substitutions, obviously
  correct

The fix is small, surgical, obviously correct, independently tested, and
applied by the subsystem maintainer. It fixes a data corruption bug
present since v4.12 that makes pstore ftrace output completely unusable
when ECC is enabled.

**YES**

 fs/pstore/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 83fa0bb3435ac..d0ca91040591c 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -74,9 +74,9 @@ static void *pstore_ftrace_seq_start(struct seq_file *s, loff_t *pos)
 	if (!data)
 		return NULL;
 
-	data->off = ps->total_size % REC_SIZE;
+	data->off = ps->record->size % REC_SIZE;
 	data->off += *pos * REC_SIZE;
-	if (data->off + REC_SIZE > ps->total_size)
+	if (data->off + REC_SIZE > ps->record->size)
 		return NULL;
 
 	return_ptr(data);
@@ -94,7 +94,7 @@ static void *pstore_ftrace_seq_next(struct seq_file *s, void *v, loff_t *pos)
 
 	(*pos)++;
 	data->off += REC_SIZE;
-	if (data->off + REC_SIZE > ps->total_size)
+	if (data->off + REC_SIZE > ps->record->size)
 		return NULL;
 
 	return data;
-- 
2.53.0

