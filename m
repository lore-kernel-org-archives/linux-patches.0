Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E523E7166;
	Mon, 20 Apr 2026 13:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691498; cv=none; b=aKctecLGXKjKB+iqAaVfuIkdzqalKppXmT6Lc0hzDopfJ7w4ERogTIKq+9gPIRJKUvIaVf8NSDwMkv6/RCoBtDHMDI51aHjgfDReyzfFBa80Ow2ee+zxY7OrJ2zRPrrBghuzasMPFThrwDX0y3QIZDjH82EVkYF/A3yzqV5AD+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691498; c=relaxed/simple;
	bh=D/KY3CXEA4uS9ZMY1EoHy6Ds7GIOb+DiXDkig6qzfpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sb3g7gZCi+3dlkaUGebTfKg8LmLooz/gecMEYFaEfAte08S/HssHmVB3DV4RVNSYoajmlMfBIkLxvYERjnf6gX2e9iO3GCxZ3caKnSlKXpItiXaCvzAQLk++xwUvwQY9TMDN+7CdioVJL8J4zQdDO3jkwXrZ81PxtQBY2n+PhG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpLoVcsz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpLoVcsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDC3C19425;
	Mon, 20 Apr 2026 13:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691498;
	bh=D/KY3CXEA4uS9ZMY1EoHy6Ds7GIOb+DiXDkig6qzfpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpLoVcszkqSYm8D80yN+Z1Jq/+rI2S6Y0uVGYBBid96SV0VuYzY+SKvMLJO/cc52m
	 EniPyThtYAMM1ju3Qr3bL4fcKHDZpBTP2Kxwk1MamHYHxMTGSO7sUuPtxKgbA3ec94
	 nCDpCN8I3YEbF0x2sFIwzZJqI2PPwaWzxXcojYPhk+51o/M0cY8nAR5kxcrLpFGg29
	 l2ZVa6c93pymqGcg1iT5aciS+2i/1bmD/Vcen7cu4z94HhV8XV1zGv0faDWhRloRVc
	 T7/74bzpJfDLIlhgSv0voEBZTcw9MdIC6Za/cNUr/bZ0J7QTFv1VMu6N9UvpcFVhDQ
	 F5Jh9aMRkZKLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Philipp Hahn <phahn-oss@avm.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sj1557.seo@samsung.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] exfat: Fix bitwise operation having different size
Date: Mon, 20 Apr 2026 09:17:39 -0400
Message-ID: <20260420132314.1023554-65-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Philipp Hahn <phahn-oss@avm.de>

[ Upstream commit 3dce5bb82c97fc2ac28d80d496120a6525ce3fb7 ]

cpos has type loff_t (long long), while s_blocksize has type u32. The
inversion wil happen on u32, the coercion to s64 happens afterwards and
will do 0-left-paddding, resulting in the upper bits getting masked out.

Cast s_blocksize to loff_t before negating it.

Found by static code analysis using Klocwork.

Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. Now I have all the information needed for the complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [subsystem: exfat (fs/exfat)] [action verb: Fix] [summary: Fix a
type mismatch in bitwise operation where `~(sb->s_blocksize - 1)`
operates at `unsigned long` width, clearing upper bits of 64-bit `cpos`]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by: Philipp Hahn <phahn-oss@avm.de>** - author from AVM
  (router/embedded device vendor, makes Fritz!Box etc.)
- **Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>** - exfat
  subsystem maintainer accepted the patch
- No Fixes: tag (expected for candidates under review)
- No Cc: stable tag (expected)
- No Reported-by: (found by static analysis)
- No Link: tag

Record: Minimal tags. Author is from an embedded device company.
Maintainer signed off.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit describes:
- `cpos` is `loff_t` (long long, 64-bit)
- `s_blocksize` is `unsigned long` (32-bit on 32-bit platforms)
- The `~` (bitwise NOT) operates at `unsigned long` width
- When the result is coerced to `loff_t`, zero-extension clears upper 32
  bits
- Fix: cast `s_blocksize` to `loff_t` before negation

Record: Bug mechanism is clearly explained. Found by Klocwork static
analysis. This is a C integer promotion/type width bug on 32-bit
platforms.

### Step 1.4: DETECT HIDDEN BUG FIXES
Record: This is an explicitly stated bug fix, not hidden. The word "Fix"
is in the subject.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- **File:** `fs/exfat/dir.c`
- **Change:** 1 line modified (replace `~(sb->s_blocksize - 1)` with
  `~(loff_t)(sb->s_blocksize - 1)`)
- **Function modified:** `exfat_iterate()` (line 252)
- **Scope:** Single-file, single-line surgical fix

Record: Minimal change. One file, one line, one cast added.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
The changed line is in `exfat_iterate()` at the error recovery path when
`exfat_readdir()` returns `-EIO`:

```c
if (err == -EIO) {
    cpos += 1 << (sb->s_blocksize_bits);
    cpos &= ~(loff_t)(sb->s_blocksize - 1);  // <-- fix here
}
```

**Before:** `~(sb->s_blocksize - 1)` operates at `unsigned long` width.
On 32-bit: produces 32-bit mask, zero-extended to 64 bits, clearing
upper 32 bits of `cpos`.
**After:** `~(loff_t)(sb->s_blocksize - 1)` operates at 64-bit width.
Upper 32 bits of `cpos` are preserved.

Record: Error recovery path. Before: incorrect masking on 32-bit. After:
correct 64-bit masking.

### Step 2.3: IDENTIFY THE BUG MECHANISM
Category: **Type / endianness bug** (specifically, integer
promotion/width bug)

On 32-bit systems, `sb->s_blocksize` is `unsigned long` = 32 bits:
- `sb->s_blocksize - 1` = 0x00000FFF (for 4K blocks)
- `~(sb->s_blocksize - 1)` = 0xFFFFF000 (32-bit unsigned)
- When AND'd with 64-bit `cpos`, this zero-extends to 0x00000000FFFFF000
- Bits 32-63 of `cpos` are incorrectly cleared

Record: Type width mismatch bug on 32-bit platforms. Incorrect zero-
extension of unsigned 32-bit mask when used with 64-bit value.

### Step 2.4: ASSESS THE FIX QUALITY
- **Obviously correct?** YES - the cast ensures the negation operates at
  64-bit width
- **Minimal?** YES - one cast addition
- **Regression risk?** ZERO - identical behavior on 64-bit systems
  (where `unsigned long` is already 64-bit), and correct behavior on
  32-bit
- **Red flags?** None

Record: Perfect fix quality. Zero regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The buggy code was introduced in commit `ca06197382bde0` by Namjae Jeon
on 2020-03-02, titled "exfat: add directory operations." This was part
of the initial exfat merge into the kernel for Linux 5.7.

Record: Bug present since initial exfat creation (v5.7, 2020). Affects
all stable trees that contain exfat (5.10+, 5.15+, 6.1+, 6.6+, 6.12+,
7.0).

### Step 3.2: FOLLOW THE FIXES TAG
No Fixes: tag present. The implicit fix target is `ca06197382bde0`.

Record: N/A (no explicit Fixes: tag, which is expected).

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
55 commits to `fs/exfat/dir.c` since the initial creation. The file has
been actively developed. Notable: commit `6b151eb5df78d` was a recent
cleanup of `exfat_readdir()` but did not touch the buggy line.

Record: Active file history. The buggy line has been untouched since
initial creation. No prerequisites needed.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Philipp Hahn (phahn-oss@avm.de) has 5 commits in the tree, mostly
documentation and quirk-related. AVM is a German embedded device company
(Fritz!Box routers). Not the exfat maintainer, but the maintainer
(Namjae Jeon) signed off on this fix.

Record: External contributor from embedded device company. Maintainer
accepted.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
The fix is a single cast to an existing line. No dependencies on other
commits.

Record: Fully standalone. No dependencies.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.5: MAILING LIST INVESTIGATION
b4 dig could not find the commit (it may be very recent).
lore.kernel.org was behind Anubis anti-scraping protection. Web searches
didn't return the specific lore thread.

Record: Could not access lore discussion. The commit was signed off by
the exfat maintainer Namjae Jeon, confirming acceptance.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS
Modified function: `exfat_iterate()` - the VFS directory iteration
callback for exfat.

### Step 5.2: TRACE CALLERS
`exfat_iterate` is wrapped by `WRAP_DIR_ITER(exfat_iterate)` and used as
`.iterate_shared` in `exfat_dir_operations`. It's called by the VFS when
userspace reads a directory (e.g., `ls`, `readdir()`). This is a very
common operation.

### Step 5.3-5.4: CALL CHAIN
Userspace `getdents64()` syscall -> VFS `iterate_dir()` ->
`exfat_iterate()`. The buggy path is triggered when `exfat_readdir()`
returns `-EIO`.

Record: Reachable from common syscalls. Error path triggered by I/O
errors on storage media.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
The same pattern `& ~(sb->s_blocksize - 1)` with `loff_t` or `ctx->pos`
variables exists in:
- `fs/ext4/dir.c` (line 255) - same type mismatch with `ctx->pos`
- `fs/ocfs2/dir.c` (line 1912) - same pattern
- `fs/jfs/xattr.c` (multiple places)
- `fs/ntfs3/ntfs_fs.h` (line 1109) - **already fixed** with
  `~(u64)(sb->s_blocksize - 1)` cast

The ntfs3 code already has this fix, confirming this is a known bug
pattern.

Record: Similar bug exists in ext4, ocfs2, jfs. ntfs3 already fixed it.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
The buggy code was introduced in `ca06197382bde0` (v5.7). exfat exists
in all active stable trees (5.10, 5.15, 6.1, 6.6, 6.12, 7.0). The
specific buggy line at line 252 has been untouched since creation.

Record: Bug present in ALL active stable trees.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
The surrounding code context is clean and unchanged since the initial
creation. The patch should apply cleanly to all stable trees.

Record: Clean apply expected for all stable trees.

### Step 6.3: RELATED FIXES IN STABLE
A similar exfat overflow fix (`2e9ceb6728f1d` "exfat: fix overflow for
large capacity partition") was explicitly tagged with `Cc:
stable@vger.kernel.org # v5.19+`, establishing precedent for
type/overflow fixes in exfat going to stable.

Record: Precedent exists for similar exfat type fixes going to stable.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
**Subsystem:** fs/exfat - exFAT filesystem
**Criticality:** IMPORTANT - exFAT is used on SD cards, USB drives, and
external storage across millions of devices, especially embedded/IoT
devices that run 32-bit ARM.

### Step 7.2: SUBSYSTEM ACTIVITY
Very active - 55+ commits to this file, 20+ recent exfat commits.
Actively maintained by Namjae Jeon.

Record: Important subsystem, actively maintained.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
Users of exFAT filesystems on **32-bit systems** (ARM, MIPS). This
includes many embedded devices, IoT systems, and older hardware. 64-bit
systems are unaffected.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
- **Platform:** 32-bit systems only
- **Trigger:** Reading a directory on an exFAT filesystem where
  `exfat_readdir()` returns `-EIO` AND `cpos` > 2^32 (>4GB directory
  position)
- **Likelihood:** LOW - requires very large directory + I/O error +
  32-bit system
- **Unprivileged trigger:** Yes, any user can `ls` a directory

### Step 8.3: FAILURE MODE SEVERITY
When triggered, the upper 32 bits of `cpos` are zeroed, causing the
directory position to jump backward, potentially causing:
- Incorrect directory listing
- Potential infinite loop in directory iteration
- Severity: MEDIUM (incorrect behavior, potential loop)

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit:** LOW-MEDIUM (fixes correctness bug on 32-bit, rare
  trigger)
- **Risk:** EXTREMELY LOW (one cast addition, provably correct, zero
  regression risk on 64-bit)
- **Ratio:** Strongly favorable - near-zero risk for a provable
  correctness fix

Record: Benefit is low-medium, risk is near-zero. Ratio strongly favors
backporting.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Provably correct fix for a real C type promotion bug
- One-line change with zero regression risk
- Bug present in all stable trees since v5.7
- Similar fixes in exfat have been backported before (Cc: stable)
- ntfs3 already has the same fix applied, confirming the pattern is
  recognized
- exFAT is widely used on 32-bit embedded systems (SD cards, USB drives)
- Signed off by the exfat maintainer
- Clean apply expected for all stable trees
- Author is from embedded device company (AVM) - directly affected use
  case

**AGAINST backporting:**
- Very low probability trigger (32-bit + huge directory + I/O error)
- Found by static analysis, no user reports
- No Fixes: tag, no Cc: stable (expected for candidates)

### Step 9.2: STABLE RULES CHECKLIST
1. **Obviously correct and tested?** YES - trivially correct cast,
   signed off by maintainer
2. **Fixes a real bug?** YES - provable type width bug on 32-bit
   platforms
3. **Important issue?** BORDERLINE - low probability but real
   correctness issue
4. **Small and contained?** YES - one line, one file
5. **No new features or APIs?** YES
6. **Can apply to stable trees?** YES - untouched line since initial
   creation

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
No exception category applies. This is a standard correctness fix.

### Step 9.4: DECISION
The fix has essentially zero regression risk (a single type cast that is
provably correct) and fixes a real, if unlikely to trigger, bug. The
risk-benefit ratio overwhelmingly favors backporting. Similar
type/overflow fixes in exfat have been backported before. The code
exists unchanged in all stable trees.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by from author (AVM) and maintainer
  (Namjae Jeon). No Fixes/Cc:stable (expected).
- [Phase 2] Diff analysis: Single line change in `exfat_iterate()`, adds
  `(loff_t)` cast to ensure 64-bit mask width.
- [Phase 3] git blame: Buggy code introduced in ca06197382bde0 (v5.7,
  2020-03-02), "exfat: add directory operations"
- [Phase 3] git log: 55 commits to file since creation; buggy line
  untouched since initial creation
- [Phase 3] Author check: Philipp Hahn has 5 commits, external
  contributor from AVM (embedded device company)
- [Phase 4] b4 dig: Could not find the commit (may be too recent). Lore
  blocked by anti-scraping.
- [Phase 5] Callers: `exfat_iterate()` is the VFS `.iterate_shared`
  callback, reached via `getdents64()` syscall
- [Phase 5] Similar patterns: Same bug exists in ext4/dir.c,
  ocfs2/dir.c, jfs/xattr.c. ntfs3 already fixed with `~(u64)` cast.
- [Phase 6] Code exists in all active stable trees (5.10, 5.15, 6.1,
  6.6, 6.12, 7.0) - verified via git history
- [Phase 6] Precedent: commit 2e9ceb6728f1d ("exfat: fix overflow for
  large capacity partition") was tagged Cc: stable
- [Phase 6] Clean apply expected - buggy line unchanged since v5.7
- [Phase 7] `s_blocksize` type verified as `unsigned long` in
  `include/linux/fs/super_types.h:136`
- [Phase 8] Failure mode: incorrect directory position on 32-bit,
  potential loop - severity MEDIUM
- UNVERIFIED: Could not verify lore discussion or reviewer comments due
  to anti-scraping protection

**YES**

 fs/exfat/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index 3a4853693d8bf..e710dd196e2f0 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -249,7 +249,7 @@ static int exfat_iterate(struct file *file, struct dir_context *ctx)
 		 */
 		if (err == -EIO) {
 			cpos += 1 << (sb->s_blocksize_bits);
-			cpos &= ~(sb->s_blocksize - 1);
+			cpos &= ~(loff_t)(sb->s_blocksize - 1);
 		}
 
 		err = -EIO;
-- 
2.53.0

