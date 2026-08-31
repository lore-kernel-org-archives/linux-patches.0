Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F10E44C4F2;
	Mon, 31 Aug 2026 13:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183263; cv=none; b=aBotEJ6b09nW84XREoaa850sFgtLfUZ3FYrft9L8siMaVZwApM08pycazSLRGnOi87AufKrZ78TmwQy/KfnfgTOthR8Njix+TChOnpAJlfafZgFnyuCkSYFfezEOt1H2T+k27YsTT3cmGwUpIFYMZhYIoU7v99ue341kSnPji8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183263; c=relaxed/simple;
	bh=4dwgWVwz4ZRqbMOX6hL1Y835EV4fxFoNSlSJJOu9CuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XqdGvtO+Qj98ijcPWXzye/BYsavtMwjzVNiCmUv6noZbUWRuYy2CJq2g5kgWoWM9LYtY4XQACKsd4GpT/8MGh3p+SIeX8qn+W1Fcyxf5K8hJh8ihljLh2Cfl3m5XGH9tinF1eo0iTdCmgRP70zFoH5PPUFlu+URghiBnmbPt1fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YSI8qjiM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSI8qjiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03F31F00ACA;
	Mon, 31 Aug 2026 13:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183260;
	bh=FVEIMvQRhEEYabIx3Us3sDKbsfe1vi4QRyuPrzSIVew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSI8qjiM39dMfsQL5VLIsN279pgF7LShWDjcaU6DIJmp2oYwQAOmo+3DSB91BqVkb
	 3zsFQWq8G9Xt3pDIsTw+mVJoqdOVymGL8jBvRWDEvI5aA9fR3KPb6lGOtyhQFZKTev
	 jrH7imdLNpx45H4J0vIRevJYfKMneaQ9txc3ZbRpMOc2FYVnXU6aeNyD1UIBM7YPRB
	 M7qeExVwR2ofzWLeMa90VptLSbhAZQ1JmTIgCldkQSdK0rmlAPTYXjsnCm+pR6xx8D
	 nmZyPKsTazkLRG7+dNqzE7qhR3tsA0fSZx+ePdWfSm0Yk3La4+WV9dU7zNi67TN3Re
	 lTesZS9lAISYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Goldwyn Rodrigues <rgoldwyn@suse.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ima: return error early if file xattr cannot be changed
Date: Mon, 31 Aug 2026 09:21:10 -0400
Message-ID: <20260831133314.4125787-42-sashal@kernel.org>
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

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

[ Upstream commit 69fc6474236d9edda6983623e4282f2bdfd8e3d8 ]

During early boot, the filesystem is read-only and any changes
to xattrs are not allowed. This fails in case of ext4 because
changing xattr starts an ext4 transaction which fails with the
following warning.

WARNING: fs/ext4/ext4_jbd2.c:75 at ext4_journal_check_start+0x63/0xa0 [ext4], CPU#1: systemd-sysroot/561
CPU: 1 UID: 0 PID: 561 Comm: systemd-sysroot Not tainted 6.19.12-1-default #1 PREEMPT(voluntary) openSUSE Tumbleweed  c2dfc3c9d9f6f1233251c5d4410574fe82a348ee
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
RIP: 0010:ext4_journal_check_start+0x63/0xa0 [ext4]
Call Trace:
  __ext4_journal_start_sb+0x3e/0x180 [ext4 6d025f3bc52c89a957b89a89d211fadf5e9434e1]
  ext4_xattr_set+0x104/0x150 [ext4 6d025f3bc52c89a957b89a89d211fadf5e9434e1]
  __vfs_setxattr+0x9a/0xd0
  __vfs_setxattr_noperm+0x76/0x1f0
  ima_appraise_measurement+0x23e/0xe40
  ima_d_path+0x5a/0xd0
  process_measurement+0xb29/0xc40
  ? copy_from_kernel_nofault+0x21/0xe0
  ? fscrypt_file_open+0xc0/0xe0
  ? ext4_file_open+0x60/0x490 [ext4 6d025f3bc52c89a957b89a89d211fadf5e9434e1]
  ? bpf_prog_31efb7c56239148b_restrict_filesystems+0xab/0x126
  ? __bpf_prog_exit+0x23/0xd0
  ? __bpf_tramp_exit+0xd/0x50
  ? bpf_trampoline_6442530367+0x9f/0xea
  ima_file_check+0x57/0x80
  security_file_post_open+0x50/0xf0
  path_openat+0x493/0x1650
  do_filp_open+0xc7/0x170

Detect the state of the file early and return the error.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `ima: return error early if file xattr
cannot be changed`

**Local tree:** `v6.18.43` (`make kernelversion` → 6.18.43)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ima]` `[return]` — Early-return from IMA xattr fix path
when the inode cannot accept xattr changes.

### Step 1.2: Commit message tags
**Record:**
- **Signed-off-by:** Goldwyn Rodrigues `<rgoldwyn@suse.com>` (author)
- **Signed-off-by:** Mimi Zohar `<zohar@linux.ibm.com>` (IMA maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable tags (absence is expected per review pipeline)

**Notable:** Maintainer sign-off from Mimi Zohar carries weight for IMA
changes.

### Step 1.3: Commit body analysis
**Record:**
- **Bug:** With `IMA_APPRAISE_FIX`, IMA tries to write `security.ima`
  xattrs during file open even when the filesystem is read-only (typical
  early boot before remount-rw).
- **Symptom:** ext4 starts a journal transaction for xattr set, hits
  `WARN_ON_ONCE(sb_rdonly(sb))` in `ext4_journal_check_start()`, logs a
  kernel warning.
- **Reproducer:** `systemd-sysroot` opening files on read-only ext4
  during early boot on openSUSE Tumbleweed 6.19.12; full stack trace
  provided.
- **Root cause (author):** IMA does not check whether the
  file/filesystem is writable before calling `__vfs_setxattr_noperm()`.
- **Fix approach:** Detect read-only/immutable state early in
  `ima_fix_xattr()` and return `-EROFS`/`-EPERM`.

### Step 1.4: Hidden bug fix detection
**Record:** Yes — despite not using "fix" in the subject verb, this is a
correctness bug fix. IMA was attempting an operation guaranteed to fail,
driving filesystem code down an error/warning path. Not cosmetic
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change inventory
**Record:**
- **Files:** `security/integrity/ima/ima_appraise.c` (+5 lines, 0
  removed)
- **Function modified:** `ima_fix_xattr()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk (ima_fix_xattr):**
  - **Before:** Always prepared xattr data and called
    `__vfs_setxattr_noperm()`, even on read-only filesystems or
    immutable inodes.
  - **After:** Returns `-EROFS` if `IS_RDONLY(d_inode(dentry))`,
    `-EPERM` if `IS_IMMUTABLE(d_inode(dentry))`, before touching xattr
    data or calling VFS.
  - **Path affected:** `IMA_APPRAISE_FIX` path in
    `ima_appraise_measurement()` (line 602) and `ima_update_xattr()`
    (line 646).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness fix — missing precondition checks
  before VFS xattr write.
- **Mechanism:** `IS_RDONLY()` expands to `sb_rdonly((inode)->i_sb)` —
  the same condition ext4 warns on at `ext4_jbd2.c:76`. Early return
  avoids the pointless journal start and `WARN_ON_ONCE`.

### Step 2.4: Fix quality
**Record:**
- **Quality:** Obviously correct; mirrors existing EVM guard pattern in
  `evm_main.c:267-269`.
- **Regression risk:** Very low. On failure paths the code already
  received `-EROFS` from ext4; this only avoids the warning and
  unnecessary FS work.
- **Minor gap vs EVM:** EVM also checks `s_readonly_remount`; this patch
  does not. That is a pre-existing difference, not a regression from
  this fix. The reported early-boot RO-root case is covered by
  `IS_RDONLY()`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** Stable tree blame shows `ima_fix_xattr()` at lines 88–106
without the guard checks. Function and `nop_mnt_idmap` usage are present
in v6.18.43. Exact mainline introduction commit not traceable in this
stable snapshot (single base commit in file history).

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** Recent IMA commits in this tree include `b6766b171a5c4`,
`148e4f7ece720`, `9e1f51c1ad57c`, etc. No related fix for this issue
already present. Standalone one-patch series (v1 only).

### Step 3.4: Author context
**Record:** Goldwyn Rodrigues (SUSE). Mimi Zohar (IMA maintainer)
reviewed and signed off. Author has other commits in tree (e.g., btrfs
tracepoint fix).

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses `IS_RDONLY`, `IS_IMMUTABLE`,
`d_inode()` — all present. `nop_mnt_idmap` and `__vfs_setxattr_noperm`
already used in the same function. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **b4 dig URL:** https://patch.msgid.link/aposxvqsrlbe7gtyvtsdh5nyg5sgo
  fimerqpt6ez4fbxhtqyjj@4u3othdcgipp
- **Series:** v1 only (no v2/v3)
- **Mimi Zohar reply:** "Thank you! The patch makes a lot of sense."
- No NAKs found. No explicit stable nomination in thread.

### Step 4.2: Reviewers
**Record:** CC'd to `linux-integrity@vger.kernel.org`. Mimi Zohar
(maintainer) responded positively and signed off in the committed
version.

### Step 4.3: Bug report
**Record:** Concrete stack trace in commit message from openSUSE
Tumbleweed / QEMU, `systemd-sysroot` during early boot. Severity from
reporter: kernel WARNING (not oops/panic).

### Step 4.4: Related patches
**Record:** Part of a larger SUSE series on mainline (`[PATCH 02/19]` in
mirror), but this specific patch is self-contained with no series
dependencies.

### Step 4.5: Stable list history
**Record:** Not searched on lore stable list (no indication of prior
stable discussion). Not a negative signal.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ima_fix_xattr()` (modified); callers
`ima_appraise_measurement()`, `ima_update_xattr()`.

### Step 5.2: Callers
**Record:**
- `ima_appraise_measurement()` ← `process_measurement()` ←
  `ima_file_check()` (LSM `file_post_open` hook)
- `ima_update_xattr()` ← post-write xattr update path
- **Context:** File open during boot (`systemd-sysroot`), common
  security hook path.

### Step 5.3: Callees
**Record:** `__vfs_setxattr_noperm()` → `__vfs_setxattr()` → filesystem
`xattr_set` (ext4 starts journal).

### Step 5.4: Reachability
**Record:**
- Trigger: `CONFIG_IMA_APPRAISE` + `IMA_APPRAISE_FIX` mode + read-only
  root during early boot + files opened that fail IMA appraisal.
- Reachable from normal file open syscall path via LSM hook. Not obscure
  module-init-only code.

### Step 5.5: Similar patterns
**Record:** EVM already guards identically before xattr update:

```267:273:security/integrity/evm/evm_main.c
                        } else if (!IS_RDONLY(inode) &&
                                   !(inode->i_sb->s_readonly_remount) &&
                                   !IS_IMMUTABLE(inode) &&
                                   !is_unsupported_hmac_fs(dentry)) {
                                evm_update_evmxattr(dentry, xattr_name,
                                                    xattr_value,
                                                    xattr_value_len);
```

IMA was missing the equivalent guard — clear oversight.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (v6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** `ima_fix_xattr()` at lines 88–106 lacks
`IS_RDONLY`/`IS_IMMUTABLE` checks. Fix is not yet applied (`grep` found
no matches).

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Context matches exactly (same
function, same `nop_mnt_idmap` usage, same line structure).

### Step 6.3: Related fixes already present?
**Record:** **No.** No prior commit in this tree addresses this issue.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **security/integrity/ima** — IMPORTANT. IMA is used on
secure-boot and integrity-measurement deployments (enterprise Linux,
embedded secure systems).

### Step 7.2: Subsystem activity
**Record:** Active — multiple IMA fixes in v6.18.y stable queue already.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Systems with `CONFIG_IMA_APPRAISE` and `IMA_APPRAISE_FIX`
(or `ima_appraise=fix` boot param) on read-only root during early boot.
Relevant to dracut/initramfs/systemd-sysroot workflows on ext4 (and
potentially other journaled FS).

### Step 8.2: Trigger conditions
**Record:**
- Early boot, RO root filesystem
- IMA appraise-fix mode attempting to repair missing/wrong
  `security.ima` xattrs on file open
- **Likelihood:** Moderate for IMA-enabled distros during every boot
  until rw remount
- **Unprivileged trigger:** Indirectly — any file open during sysroot
  phase can trigger it

### Step 8.3: Failure mode severity
**Record:** `WARN_ON_ONCE` from ext4 journal layer. **Severity: MEDIUM**
— no crash, panic, corruption, or deadlock, but spurious kernel warnings
on every affected file open during early boot. Pollutes logs and may
trigger monitoring alerts on security-hardened systems.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Eliminates reproducible boot-time warnings; aligns IMA
  with EVM; avoids pointless FS journal operations.
- **Risk:** Minimal (5 lines, well-understood checks).
- **Ratio:** Favorable — low risk, real (if non-critical) user-visible
  bug fix.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Reproducible bug with full stack trace (openSUSE)
- IMA maintainer endorsed ("makes a lot of sense") and signed off
- 5-line surgical fix, obviously correct
- Mirrors existing EVM pattern in same subsystem
- Buggy code confirmed present in v6.18.43
- Clean apply, no dependencies
- Real logic bug (attempting impossible xattr write)

**AGAINST backport:**
- Failure mode is WARNING only, not crash/corruption/security
- Requires `IMA_APPRAISE_FIX` — narrower than default IMA enforce mode
- Does not add EVM's `s_readonly_remount` check (minor, pre-existing
  gap)

**Unresolved:** Exact mainline commit that introduced `ima_fix_xattr()`
without guards (not traceable in stable snapshot history).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic mirrors EVM;
   maintainer reviewed; reproducer provided.
2. Fixes a real bug affecting users? **PASS** — concrete openSUSE early-
   boot warning.
3. Important issue? **PASS (borderline)** — WARN_ON spam during boot on
   IMA systems; not crash-level but user-visible on security
   deployments.
4. Small and contained? **PASS** — 5 lines, 1 file.
5. No new features or APIs? **PASS** — defensive checks only.
6. Can apply to local tree? **PASS** — code exists, patch applies
   cleanly.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build fix, or docs).
Standard bug fix.

### Step 9.4: Decision rationale

For **v6.18.43**, this commit fixes a real, reproducible bug in the IMA
appraisal-fix path where the kernel incorrectly attempts xattr writes on
read-only filesystems during early boot. The result is ext4
`WARN_ON_ONCE` spam — not a crash, but a genuine defect in security
subsystem code that EVM already handles correctly. The fix is minimal,
maintainer-approved, and applies cleanly to this tree.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; identified IMA early-boot RO
  xattr warning bug
- **[Phase 2]** Diff analysis: +5 lines in `ima_fix_xattr()`, adds
  `IS_RDONLY`/`IS_IMMUTABLE` guards
- **[Phase 3]** `git describe HEAD` → v6.18.43; `git blame`/`git show`
  confirm buggy code at lines 88–106 without guards
- **[Phase 3]** No Fixes: tag; no related fix in tree; standalone patch
- **[Phase 4]** `b4 dig -c 69fc6474236d9edda6983623e4282f2bdfd8e3d8`:
  lore URL found; v1 only
- **[Phase 4]** `b4 dig -w`: CC'd linux-integrity@vger.kernel.org
- **[Phase 4]** Mbox thread: Mimi Zohar — "The patch makes a lot of
  sense"
- **[Phase 5]** Call chain verified: `ima_file_check` →
  `process_measurement` → `ima_appraise_measurement` → `ima_fix_xattr`
- **[Phase 5]** EVM parallel check at `evm_main.c:267-269` verified via
  grep
- **[Phase 5]** `IS_RDONLY` → `sb_rdonly()` verified at
  `include/linux/fs.h:2546`
- **[Phase 5]** ext4 warning at `fs/ext4/ext4_jbd2.c:76` —
  `WARN_ON_ONCE(sb_rdonly(sb))` verified
- **[Phase 6]** `grep IS_RDONLY` in ima: no matches — fix not present
- **[Phase 6]** `ima_fix_xattr` and `nop_mnt_idmap` present in v6.18.43
- **[Phase 8]** Failure mode: WARN_ON_ONCE, severity MEDIUM

**YES**The background history search (`git log --all -S
"ima_fix_xattr"`) was stopped — `--all` scans too many branches and had
hung. That didn’t change the backport conclusion.

For **v6.18.43**, the important part is already verified:
`ima_fix_xattr()` is present **without** the `IS_RDONLY`/`IS_IMMUTABLE`
guards, so the early-boot ext4 warning is a real issue here. Pinning the
exact mainline commit that introduced `ima_fix_xattr` isn’t possible in
this stable snapshot (file history collapses to the release base), and
it isn’t needed for the decision.

**Verdict for this tree: YES** — small, maintainer-reviewed fix for a
reproducible IMA appraise-fix warning on read-only root during early
boot.

 security/integrity/ima/ima_appraise.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 5149ff4fd50d2..d5f7de58caac5 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -90,6 +90,11 @@ static int ima_fix_xattr(struct dentry *dentry, struct ima_iint_cache *iint)
 	int rc, offset;
 	u8 algo = iint->ima_hash->algo;
 
+	if (IS_RDONLY(d_inode(dentry)))
+		return -EROFS;
+	if (IS_IMMUTABLE(d_inode(dentry)))
+		return -EPERM;
+
 	if (algo <= HASH_ALGO_SHA1) {
 		offset = 1;
 		iint->ima_hash->xattr.sha1.type = IMA_XATTR_DIGEST;
-- 
2.53.0

