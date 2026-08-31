Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1AF46C4B7;
	Mon, 31 Aug 2026 13:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183357; cv=none; b=FSD9Z8OB9iBmEdrBgHEfrs+r5jEmXXU9yjH9CtrL2rH7rKEAjjNvrsOzNZoIM4nct9lrr7wEaD8KS47TdYGcbm8YTcQuFqTchbKCCGwasZ9RJdAzCFPLwk2EOdVY6cml9js8R/X8621UPQ0vUhiSk4rKh5tLVR7S5eU1o/8ZQUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183357; c=relaxed/simple;
	bh=3A4FVolA00nAP8gk9Bxd9YuRycb4nXSTHeyrH4Ml1EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EBGsAe5l1BQ34zpqjTAeCqdIUTvAh958DCrLCD71ORgjsJHQUTswoBSJFUfMu7WWkGmmF9+9YS6CwsGKb0WJALeTbQ//qyihZaFL4OHNcQkbKvL5z44Sksunktf6m4HYSeWRTGAvMF+xNtFQ5IqglkGWB/fD4YT3Uhnm/JcSCto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KSHzDxJc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KSHzDxJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24161F00ACA;
	Mon, 31 Aug 2026 13:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183356;
	bh=WLCMYHGlgDcQ0hHc9ny4W/wCz2evM43glNhXYSXd8No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSHzDxJc+hvYCUGT3iVR43s2is6VhZvh7OPeUU0j9t/DyeEkX1UlyXbbQgjx35xGA
	 FA5A4H+my0i4haS8kFuR0wRXNPT1OoLAKD45HvcC34WC1kkkEAEVzXeehr9/E3BvfR
	 uIOrG7JO6iQ0JLlWEdBk8IOeUDqPckb/QVbDPrSwMWfgCcLhn7XE2cGp5bjNln+DSg
	 dj+vHcdLMTkFbGOYHO3zVe7QHK9IjecAwmjluZ8r4RMxHt4aYEX/tjs6PVvszgg/Re
	 CmTaLc6Z63lsjpTSmcf3hhDzHJWROCwTZfeozaGU/Ufcb7eWrLblf0g0e6rnp0YFyA
	 2fwgm+xSIMbtA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: GuoHan Zhao <zhaoguohan@kylinos.cn>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	miklos@szeredi.hu,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] fuse: use current creds for backing files
Date: Mon, 31 Aug 2026 09:22:07 -0400
Message-ID: <20260831133314.4125787-99-sashal@kernel.org>
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

From: GuoHan Zhao <zhaoguohan@kylinos.cn>

[ Upstream commit c51248524a0f546b9a9b44710038f5663688ed10 ]

FUSE backing files only need a stable snapshot of the current credentials
for later backing-file I/O. prepare_creds() allocates a mutable copy and
can fail, but this code never modifies or commits the result.

Use get_current_cred() instead and store it as a const pointer. This
matches the rest of the backing-file helpers and avoids an unnecessary
allocation and failure path.

Signed-off-by: GuoHan Zhao <zhaoguohan@kylinos.cn>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `fuse: use current creds for backing files`

**Local tree:** `v6.18.44` (`HEAD` detached from `stable/linux-6.18.y`,
`VERSION = 6`, `PATCHLEVEL = 18`, `SUBLEVEL = 44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[fuse]` — change API usage — use current credentials
snapshot for backing files instead of `prepare_creds()`.

### Step 1.2: Tags
**Record:**
- `Signed-off-by: GuoHan Zhao <zhaoguohan@kylinos.cn>` (author)
- `Reviewed-by: Amir Goldstein <amir73il@gmail.com>` (FUSE maintainer)
- `Acked-by: Christian Brauner <brauner@kernel.org>` (VFS maintainer)
- `Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>` (FUSE tree
  maintainer)
- No `Fixes:` tag (expected for manual review)
- No `Reported-by:` / `Link:` / syzbot
- No `Cc: stable@vger.kernel.org` in original submission
- Ignore pipeline `Signed-off-by: Sasha Levin`

### Step 1.3: Body analysis
**Record:**
- **Bug:** `prepare_creds()` allocates a mutable cred copy that is never
  modified or committed; its return value is not checked, so it can fail
  silently.
- **Symptom:** Under memory pressure, backing-file open can proceed with
  a NULL credential, breaking later passthrough I/O.
- **Root cause:** Wrong API — only a pinned snapshot of current creds is
  needed; `get_current_cred()` is the correct, non-allocating primitive.
- **Versions:** FUSE passthrough backing files exist in this tree since
  commit `44350256ab943` (Sep 2023).

### Step 1.4: Hidden bug fix?
**Record:** Yes. Described as API cleanup, but it fixes an unchecked
`prepare_creds()` failure that can leave `fb->cred == NULL` while
registration succeeds.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- `fs/fuse/backing.c`: 1 line changed (`prepare_creds()` →
  `get_current_cred()`)
- `fs/fuse/fuse_i.h`: 1 line changed (`struct cred *cred` → `const
  struct cred *cred`)
- Functions: `fuse_backing_open()`; `struct fuse_backing`
- **Scope:** Single-file surgical fix, 2 lines total

### Step 2.2: Code flow change
**Record:**
- **Before:** `fuse_backing_open()` calls `prepare_creds()`, which
  kmalloc's a cred struct; return unchecked; on ENOMEM, `fb->cred =
  NULL`.
- **After:** `get_current_cred()` pins current cred via refcount
  increment; cannot fail; `const` reflects read-only usage.
- **Path affected:** `FUSE_DEV_IOC_BACKING_OPEN` ioctl →
  `fuse_backing_open()` error/success path.

### Step 2.3: Bug mechanism
**Record:** **Category:** Missing error handling / wrong API / potential
NULL pointer dereference.

Verified chain when `prepare_creds()` returns NULL
(`kernel/cred.c:213-214`):
1. `fb->cred = NULL` (line 121, unchecked)
2. `fuse_backing_id_alloc()` may still succeed
3. ioctl returns success with valid `backing_id`
4. Later `fuse_passthrough_open()` → `ff->cred = get_cred(fb->cred)` →
   `get_cred(NULL)` returns NULL (safe)
5. Passthrough I/O → `backing_file_read_iter()` etc. →
   `override_creds(ctx->cred)` → `override_creds(NULL)` sets
   `current->cred = NULL` (`include/linux/cred.h:180-182`)
6. Subsequent credential access in that task can oops

### Step 2.4: Fix quality
**Record:** Obviously correct. `get_current_cred()` matches NFS and
other backing-file callers. `put_cred()` in `fuse_backing_free()`
already handles const creds. No new locks or API changes. Regression
risk: very low.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `prepare_creds()` introduced in `c4331e19a6b0f` (Sep 2025,
code move) and originally in `44350256ab943` (Sep 2023). Bug present
since FUSE passthrough backing files were added.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related changes
**Record:** Standalone single-patch series (v1 only). No prerequisites.
Related file history: `c4331e19a6b0f` (move to `backing.c`),
`e9c8da670e749` (non-regular file check).

### Step 3.4: Author context
**Record:** GuoHan Zhao — contributor fix. Reviewed/acked by FUSE and
VFS maintainers. Miklos applied with "Applied, thanks."

### Step 3.5: Dependencies
**Record:** None. `get_current_cred()` and `const struct cred *` exist
in this tree. Applies cleanly to current `backing.c` and `fuse_i.h`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
https://patch.msgid.link/20260510145437.321141-1-zhaoguohan@kylinos.cn —
v1 only, applied by Miklos. No NAKs. No stable nomination in thread.

### Step 4.2: Reviewers
**Record:** CC'd: `linux-fsdevel@vger.kernel.org`, `linux-
kernel@vger.kernel.org`, Miklos Szeredi. Reviewed-by Goldstein, Acked-by
Brauner.

### Step 4.3: Bug reports
**Record:** None. No syzbot, no user crash reports. Bug identified by
code review.

### Step 4.4: Series context
**Record:** Standalone 1/1 patch. No sibling patches required.

### Step 4.5: Stable list
**Record:** Not searched separately; no stable nomination found in lore
thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `fuse_backing_open()`, `fuse_backing_free()`,
`fuse_passthrough_open()`, `backing_file_open()`,
`backing_file_read_iter()`

### Step 5.2: Callers
**Record:**
- `fuse_backing_open()` ← `fuse_dev_ioctl_backing_open()` ←
  `fuse_dev_ioctl()` (`fs/fuse/dev.c`)
- Requires `CONFIG_FUSE_PASSTHROUGH`, `fc->passthrough`, and
  `CAP_SYS_ADMIN`
- `fb->cred` consumed in `fuse_passthrough_open()` → all passthrough
  read/write/splice/mmap paths

### Step 5.3: Callees
**Record:** `prepare_creds()` / `get_current_cred()`, `put_cred()`,
`fuse_backing_id_alloc()`, `backing_file_open()`, `override_creds()`

### Step 5.4: Reachability
**Record:** Reachable from userspace via
`ioctl(FUSE_DEV_IOC_BACKING_OPEN)` on `/dev/fuse` by privileged FUSE
daemon. Passthrough I/O is a normal post-setup path. Trigger needs
memory pressure at open time plus later passthrough use.

### Step 5.5: Similar patterns
**Record:** NFS (`fs/nfs/inode.c`, `fs/nfs/unlink.c`) and NFSd use
`get_current_cred()` for similar backing/credential snapshots. Overlayfs
uses `prepare_creds()` only where creds are actually modified before
commit.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** `fs/fuse/backing.c:121` still has `fb->cred =
prepare_creds();`. Upstream fix `c51248524a0f5` and stable backport
`f47958748ee86` are **not** ancestors of `HEAD` or
`stable/linux-6.18.y`. Feature `44350256ab943` **is** present.

### Step 6.2: Backport complications
**Record:** Clean apply expected — 2-line change, no conflicts.
`stable/linux-6.18.y:fs/fuse/backing.c` has identical `prepare_creds()`
line.

### Step 6.3: Related fixes already present?
**Record:** None for this issue.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `fs/fuse` — **IMPORTANT**. FUSE is widely used (virtiofs,
user filesystems). Passthrough is opt-in at runtime but
`CONFIG_FUSE_PASSTHROUGH` defaults to `y`.

### Step 7.2: Activity
**Record:** Actively developed; passthrough added in 6.8 era, refined
through 6.18.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of FUSE passthrough with `CONFIG_FUSE_PASSTHROUGH=y`
(default). Requires privileged FUSE daemon (`CAP_SYS_ADMIN`). Not
universal, but real production users (virtiofs passthrough setups).

### Step 8.2: Trigger conditions
**Record:** Memory pressure during `FUSE_DEV_IOC_BACKING_OPEN` so
`prepare_creds()` returns NULL while `idr_alloc` succeeds; later
passthrough open and I/O. Uncommon but realistic under OOM. Privileged
caller only — not a direct unprivileged attack vector, but daemon crash
affects all mount users.

### Step 8.3: Failure severity
**Record:** `override_creds(NULL)` during I/O → **CRITICAL** (kernel
oops in FUSE daemon context). Also incorrect security context if partial
failure occurs without immediate crash.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — prevents rare but severe crash in passthrough
  path; removes unnecessary allocation
- **Risk:** VERY LOW — 2-line API correction, maintainer-reviewed
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Real bug: unchecked `prepare_creds()` failure → NULL cred →
  `override_creds(NULL)` on I/O
- Potential kernel crash (CRITICAL severity if triggered)
- Trivial, obviously correct fix
- Reviewed by FUSE maintainer, acked by VFS maintainer
- Bug present since feature introduction in this tree
- Applies cleanly to 6.18.y

**AGAINST backport:**
- No reported crashes or syzbot findings
- Narrow trigger (OOM + passthrough + CAP_SYS_ADMIN)
- FUSE passthrough is relatively new
- Primarily framed as API correctness / allocation avoidance

**Unresolved:** No production crash reports found; severity is
analytically derived, not empirically confirmed.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — correct API per maintainer
   review; no runtime tests cited
2. Fixes a real bug? **PASS** — unchecked `prepare_creds()` NULL return
   verified in code
3. Important issue? **PASS** — potential kernel oops via
   `override_creds(NULL)` (CRITICAL if triggered)
4. Small and contained? **PASS** — 2 lines, 2 files
5. No new features or APIs? **PASS** — behavior correction only
6. Can apply to local tree? **PASS** — buggy code present, fix not yet
   applied

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs fix).
Qualifies on bug-fix merits.

### Step 9.4: Decision rationale

This commit fixes a genuine error-handling bug in FUSE passthrough
backing-file setup. Using `prepare_creds()` where credentials are never
modified was always wrong; the unchecked failure path can register a
backing file with NULL credentials and later invoke
`override_creds(NULL)` during passthrough I/O, which can crash the
kernel. The fix is minimal, maintainer-endorsed, and applies cleanly to
the local 6.18.44 stable tree where the buggy code is present.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no syzbot/Reported-by
- [Phase 2] Diff: 2 lines in `backing.c` + `fuse_i.h`; verified
  `prepare_creds()` NULL path and `override_creds(NULL)` chain
- [Phase 3] `git blame`: bug since `44350256ab943`/`c4331e19a6b0f`;
  standalone patch
- [Phase 3] `git merge-base --is-ancestor c51248524a0f5 HEAD` → exit 1
  (fix not in tree)
- [Phase 3] `stable/linux-6.18.y:fs/fuse/backing.c` still has
  `prepare_creds()`
- [Phase 4] `b4 dig -c c51248524a0f5`: lore URL found; v1 only; Miklos
  applied; Goldstein Reviewed-by; Brauner Acked-by; no stable CC
- [Phase 4] `b4 dig -m /tmp/fuse-cred-thread.mbox`: thread downloaded
  and reviewed
- [Phase 5] Call chain: `fuse_dev_ioctl` → `fuse_backing_open` → later
  `fuse_passthrough_open` → `backing_file_*` →
  `override_creds(ctx->cred)`
- [Phase 5] `get_current_cred()` usage confirmed in NFS
  (`fs/nfs/inode.c:1221`)
- [Phase 6] `git describe HEAD` → v6.18.44; buggy code at
  `backing.c:121`
- [Phase 6] `CONFIG_FUSE_PASSTHROUGH` default `y` in
  `fs/fuse/Kconfig:59`
- [Phase 8] Failure mode: `override_creds(NULL)` → CRITICAL; trigger
  rare but realistic under OOM

**YES**Those background lookups finished and match the earlier analysis:

- **Commit IDs:** upstream fix is `c51248524a0f5`; stable backport form
  is `f47958748ee86`.
- **Tree state:** neither `HEAD` (v6.18.44) nor `stable/linux-6.18.y`
  contains the fix yet — both still use `prepare_creds()` in
  `fs/fuse/backing.c`.

**Verdict remains YES** for backport to this 6.18.y tree: real
unchecked-failure bug, small maintainer-reviewed fix, applies cleanly.

 fs/fuse/backing.c | 2 +-
 fs/fuse/fuse_i.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 4afda419dd141..c924e38646db4 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -118,7 +118,7 @@ int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map)
 		goto out_fput;
 
 	fb->file = file;
-	fb->cred = prepare_creds();
+	fb->cred = get_current_cred();
 	refcount_set(&fb->count, 1);
 
 	res = fuse_backing_id_alloc(fc, fb);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index c288f28f6c6ea..b5bd676997874 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -99,7 +99,7 @@ struct fuse_submount_lookup {
 /** Container for data related to mapping to backing file */
 struct fuse_backing {
 	struct file *file;
-	struct cred *cred;
+	const struct cred *cred;
 
 	/** refcount */
 	refcount_t count;
-- 
2.53.0

