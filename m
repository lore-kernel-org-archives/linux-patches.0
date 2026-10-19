Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85105A0816;
	Mon, 19 Oct 2026 13:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418373; cv=none; b=XDeiqRkrGJyJeis7PIX9FS0rYa3i1WvdItdNxN01nTLMD2XUByaD7gerjd80JoBMEKtzk89hm6qQOIKKApx0eYKKCDHzaRVgTsFcf8v6hyrcHuTUG6UepWFa51SzyldB91D0XdyO2LWFgnQMX7euQfcORYGZNGCBJQTOy+TD25k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418373; c=relaxed/simple;
	bh=GpIRrF7NM4tnNYCQX6pjk/kwOcQ+MGgVoKCJfXhDx6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nro9+nNPvKJY6px4s2GSmtEmFw1e+AKq4KRgMP6IfG8K7MC1CHbBm1CJaM20b0qMf7c6wt+qip+sQ2Jrje0yDLp6oa18g+FOgPA25d5YXlQ47mnAeBdxd+uH/W7fyi06tPY/XLEHWAbKm6r3ZhxepJZDboWQDAeE0Zf8v7+WqZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/WK4afo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/WK4afo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D631F000C6;
	Mon, 19 Oct 2026 13:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418370;
	bh=MRueXzJ9oUHfr/CERlmJuoHcDUsGkil+1KAQ/9bDjuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/WK4afoIMWq0rg1IfdiV6o8DV+RX3PlsmRvUk17rN2BkNtmWayUX0BKhzNPvfMmK
	 MxlihQFcglHuMnAAHj2WE95EdvR7QlG/+Y1mjhv8ji7BGGB8bYvIJFxx29GKBuEwai
	 1uiw+f5NV5HImSnGGbiZx5M8DBDdfMynblOFwe3wGg7QMfvtWgtL2+T2J9DVf5Idkh
	 jtwfPwYOnINpE5hWqLHmVIpINOY/j9xcKzJwbxTTybjuqyZdzhWH424lHTfEANB0MU
	 FDriBSDUKf+TmG+FqahYYwoOwC+6c1CTE7EKE7hSQHKB4eOkn2KDq2ZhUJGVBysoz/
	 4ft2JGLWL6WRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?=EC=9D=B4=EC=83=81=ED=98=B8?= <kudo3228@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] romfs: detect hard link cycles
Date: Mon, 19 Oct 2026 09:48:11 -0400
Message-ID: <20261019135441.1420968-200-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: 이상호 <kudo3228@gmail.com>

[ Upstream commit d30b5a954e0a4dcc16bba9c310c13709a6169a52 ]

romfs_iget() follows on-disk hard link entries until it reaches a non-hard
link inode:

	pos = be32_to_cpu(ri.spec) & ROMFH_MASK;

The target position is image-controlled, and the loop does not detect
cycles. A crafted romfs image can make the root inode a hard link. The hard
link can point back to itself and leave mount(2) spinning in the kernel.

Reject excessive hard link indirection with -ELOOP. Normal romfs images do
not need long hard link chains. This bounds corrupted-image traversal.
Propagate romfs_iget() errors from lookup because hard link traversal can
now fail with -ELOOP.

Signed-off-by: 이상호 <kudo3228@gmail.com>
Link: https://patch.msgid.link/20260701220729.822112-1-kudo3228@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.1.188** (`pending-6.1`). The unbounded hard-link
walk is present here; the fix is not.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

- Subsystem prefix: `romfs:`
- Action verb: `detect` (bug-fix language: find/stop a cycle that
  currently is not handled)
- Claimed intent: stop unbounded on-disk hard-link traversal

Record: **[romfs] [detect] [bound hard-link walk so a crafted image
cannot spin forever]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Verified from `d30b5a954e0a4` on `origin/master` (mainline), not from
this 6.1 HEAD:

- `Signed-off-by: 이상호 <kudo3228@gmail.com>` — author
- `Link:
  https://patch.msgid.link/20260701220729.822112-1-kudo3228@gmail.com` —
  original submission
- `Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>` —
  VFS maintainer applied it
- **No** `Fixes:` tag
- **No** `Reported-by:` / syzbot
- **No** `Tested-by:` / `Reviewed-by:` / `Acked-by:`
- **No** `Cc: stable@vger.kernel.org` (expected for this review
  pipeline)

Record: **Author SOB + VFS-maintainer SOB + lore Link. No syzbot, no
Fixes, no stable CC.**

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

- Bug: `romfs_iget()` follows `ri.spec` while the entry type is
  `ROMFH_HRD`. The target is image-controlled. There is no cycle/depth
  check.
- Symptom: a crafted image can make the root inode a self-referential
  hard link; `mount(2)` never returns (kernel-side infinite loop).
- Fix: cap hard-link hops at 64 and return `-ELOOP`. Also return
  `romfs_iget()` errors from lookup so `-ELOOP` is visible to userspace.
- Author: normal images do not need long hard-link chains.

Record: **[crafted-image infinite hard-link walk] [mount hangs in
kernel] [no version bound in message] [missing cycle/depth check on
image-controlled `spec`]**

**Step 1.4: DETECT HIDDEN BUG FIXES**

Not hidden. The subject and body describe a hang. The lookup `IS_ERR`
check is supporting error propagation, not cleanup-for-style.

Record: **Explicit hang fix, not a disguised cleanup.**

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Verified via `git show --stat d30b5a954e0a4`: **8 insertions, 0
deletions, one file `fs/romfs/super.c`.**

Functions:
- `romfs_lookup()` — after `romfs_iget()`, return `ERR_CAST(inode)` on
  error
- `romfs_iget()` — `depth` counter; abort after
  `ROMFS_MAX_HARDLINK_DEPTH` (64)

The provided candidate diff also shows `inode_state_read_once(i)` in
**unchanged context**. That helper does **not** exist in this 6.1 tree
(`grep` found zero hits). The **changed** lines do not use it.

Record: **[+8 / -0, one file] [romfs_lookup, romfs_iget] [single-file
surgical fix]**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Hunk 1 (`romfs_lookup`): on name match, optionally one hard-link hop,
then `romfs_iget()`. Before: any `ERR_PTR` was passed to
`d_splice_alias()`. After: lookup returns the error immediately.

Hunk 2 (`romfs_iget`): `for (;;)` reads the header, breaks only when
type is not `ROMFH_HRD`, else sets `pos` from `spec` with no hop limit.
After: 65th hop returns `-ELOOP`.

Affected paths: mount (`romfs_fill_super` → `romfs_iget`) and lookup of
hard-linked names.

Record: **[unbounded HRD walk → depth-capped walk; lookup now fails
closed on iget errors]**

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Category: **logic / correctness plus unbounded iteration** (crafted-
image hang). Not UAF, not a leak.

Mechanism: on-disk `spec` is trusted as the next header. A cycle (or a
long in-image HRD chain) never hits a non-HRD type. `romfs_dev_read()`
only fails on I/O or out-of-image `pos` (`pos >= limit` in
`fs/romfs/storage.c`), so a **valid in-image cycle** never exits.

Record: **[unbounded image-controlled loop] [depth limit + -ELOOP]**

**Step 2.4: ASSESS THE FIX QUALITY**

Obviously correct: same pattern as symlink `MAX_NESTED_LINKS` /
`-ELOOP`. 64 hops is generous (VFS symlink cap in this tree is 8).
Legitimate genromfs images use hard links for `.` / `..` (one hop),
documented in `Documentation/filesystems/romfs.rst`.

Regression risk is low. The lookup `IS_ERR` check is slightly redundant
here because `d_splice_alias()` already does `if (IS_ERR(inode)) return
ERR_CAST(inode);` (`fs/dcache.c:3147`), but it is still correct.

Record: **[minimal, obviously correct] [low regression risk; 64 is well
above real romfs usage]**

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

`git blame fs/romfs/super.c` around the loop:

- Hard-link walk in `romfs_iget()`: **da4458bda237aa** (David Howells,
  2009-02-12), “NOMMU: Make it possible for RomFS to use MTD devices
  directly”
- `git describe --contains da4458bda237aa` → **v2.6.30-rc1**
- `git merge-base --is-ancestor da4458bda237aa HEAD` → **yes, in this
  tree**

The unbounded loop has been here for the entire 6.1 line.

Record: **[da4458bda237aa / v2.6.30] [buggy walk present in 6.1.188]**

**Step 3.2: FOLLOW THE FIXES: TAG**

No `Fixes:` tag. The introducing commit is identified by blame, not by
the message.

Record: **[No Fixes tag] [introducer da4458bda237aa is in this tree]**

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Path-limited `git log --oneline -- fs/romfs/super.c` on this tree:
recent work is `romfs: check sb_set_blocksize() return value` (already
here), `read_folio`, inode alloc. No prior cycle check.

On `origin/master` after this fix: merge of vfs-7.3 plus unrelated `fs:
add dedicated block device open helpers`. **No follow-up correction** of
this patch.

`40e2c71d57565` (“romfs: fix returm err while getting inode in
fill_super”) already makes `romfs_fill_super()` check `IS_ERR(root)` —
mount will fail with `-ELOOP` once `romfs_iget()` can return it.

Record: **[standalone; no prerequisite series; fill_super already
propagates iget errors]**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

`git log --author="kudo3228@gmail.com"` on this tree: Bluetooth HIDP
payload/header validation. Same author pattern (image/packet bounds),
not the romfs maintainer.

Record: **[contributor, not romfs maintainer] [applied by VFS maintainer
Brauner]**

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

The patch is `[PATCH]` (single), not `n/m`. It only uses `IS_ERR` /
`ERR_PTR` / `ERR_CAST` / `ELOOP`, all present in 6.1. It does **not**
require `inode_state_read_once`.

Record: **[no dependencies] [can apply standalone to this tree]**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

`b4 dig -c <sha>` cannot match a commit that is not HEAD. `b4 mbox` on
Message-ID `20260701220729.822112-1-kudo3228@gmail.com` saved
`/tmp/romfs-hardlink.mbox`: **2 messages**.

1. Submission 2026-07-02 to linux-kernel and linux-fsdevel, subject
   `[PATCH] romfs: detect hard link cycles`
2. Christian Brauner 2026-07-03: applied to `vfs-7.3.misc` as
   `c4d617e5d28d`

No v2/v3. No NAK. No reviewer-requested respin. Direct-to-maintainer
apply.

Record: **[lore thread via msgid
20260701220729.822112-1-kudo3228@gmail.com] [single revision] [applied
by Brauner] [no NAK]**

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Original To/Cc: `linux-kernel@vger.kernel.org`, `linux-
fsdevel@vger.kernel.org`. No extra reviewer list. Brauner applied it
(VFS maintainer per `MAINTAINERS`: FILESYSTEMS (VFS and
infrastructure)).

Record: **[linux-fsdevel + VFS maintainer apply; no Reviewed-by
trailers]**

**Step 4.3: SEARCH FOR THE BUG REPORT**

No `Reported-by` or bugzilla/syzbot link. The hang is reasoned from the
code, not from a public crash report.

lore.kernel.org HTTP fetches returned **403**; discussion was recovered
via `b4 mbox`.

Record: **[no public bug report] [author describes mount hang from
crafted root HRD cycle]**

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Standalone `[PATCH] 1/1`. No related romfs cycle patches in the mbox or
in `git log origin/master -- fs/romfs/super.c` after it.

Record: **[standalone, not part of a multi-patch series]**

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

lore.kernel.org/stable search returned 403. `git log origin/master
--grep="detect hard link cycles" -- fs/romfs/super.c` finds only the
mainline commit. No evidence of a stable NAK.

Record: **[no stable-list discussion recovered; UNVERIFIED beyond 403 on
lore/stable]**

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

`romfs_lookup()`, `romfs_iget()`. New macro `ROMFS_MAX_HARDLINK_DEPTH`.

**Step 5.2: TRACE CALLERS**

`git grep romfs_iget` in `fs/romfs/super.c`:

- `romfs_lookup()` — directory lookup (`->lookup`)
- `romfs_fill_super()` line 536 — get root inode during mount

`romfs_lookup` is `romfs_dir_inode_operations.lookup`.

**Step 5.3: TRACE CALLEES**

`romfs_iget` calls `romfs_dev_read`, `romfs_dev_strnlen`, `iget_locked`.
`romfs_dev_read` rejects `pos >= romfs_maxsize(sb)` with `-EIO`, so
**out-of-image** pointers stop; **in-image cycles** do not.

**Step 5.4: FOLLOW THE CALL CHAIN**

`mount("romfs")` → `romfs_get_tree` → `romfs_fill_super` →
`romfs_iget(root)`. If that root header is `ROMFH_HRD` pointing at
itself, the syscall never returns.

Lookup of a cyclic hard link after a successful mount has the same hang
in `romfs_iget`.

`romfs_fs_type.fs_flags = FS_REQUIRES_DEV` only — **no
`FS_USERNS_MOUNT`**. Mount needs `CAP_SYS_ADMIN` (or equivalent). Still
reachable from `mount(2)` on a loop/MTD/block image.

Record: **[reachable from mount and lookup] [needs mount privilege, not
unprivileged userns]**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

No `ROMFS_MAX_HARDLINK` elsewhere. VFS uses `MAX_NESTED_LINKS = 8` in
`include/linux/namei.h`. SMB client uses the same `-ELOOP` hop bound.
This is the standard “bound image-controlled indirection” pattern.

Romfs docs (`Documentation/filesystems/romfs.rst`) say it is the **image
creator’s** job not to make hard-link loops. The kernel still must not
spin if they do.

Record: **[same class as VFS ELOOP bounds; romfs previously trusted the
image]**

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Yes. Local `fs/romfs/super.c`:

```291:303:fs/romfs/super.c
        for (;;) {
                ret = romfs_dev_read(sb, pos, &ri, sizeof(ri));
                if (ret < 0)
                        goto error;
                nextfh = be32_to_cpu(ri.next);
                if ((nextfh & ROMFH_TYPE) != ROMFH_HRD)
                        break;
                pos = be32_to_cpu(ri.spec) & ROMFH_MASK;
        }
```

No `ROMFS_MAX_HARDLINK_DEPTH`. `git merge-base --is-ancestor
d30b5a954e0a4 HEAD` is false. Introduced in v2.6.30, still here.

Record: **[yes, romfs_iget HRD loop] [since v2.6.30]**

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Local `romfs_lookup` / `romfs_iget` match the patch hunks. The only
mainline-only context is `inode_state_read_once`, which this patch does
not change. 6.1 still uses `i->i_state & I_NEW`.

Record: **[clean apply expected; no `inode_state_read_once`
dependency]**

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

No cycle detection. Related: fill_super already returns `PTR_ERR(root)`
(`40e2c71d57565`). Another crafted-image romfs fix (`sb_set_blocksize`)
is already in this 6.1 tree — same class of image-validation bug.

Record: **[no existing cycle fix] [fill_super error path ready]**

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

`fs/romfs/` — small read-only FS for initrd/embedded/MTD. **PERIPHERAL**
relative to ext4/VFS, but it is a real in-tree filesystem used on 6.1
devices that enable `CONFIG_ROMFS_FS`.

**Step 7.2: SUBSYSTEM ACTIVITY**

Low churn. The HRD walk has been stable since 2009. That makes the hang
long-lived, not a new-subsystem mismatch.

Record: **[romfs] [PERIPHERAL but long-present] [mature, little recent
change]**

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Users who mount romfs (`CONFIG_ROMFS_FS`) from block or MTD. Not
universal. Includes initrd, embedded, and anyone mounting an untrusted
image (USB, loop).

**Step 8.2: TRIGGER CONDITIONS**

- Crafted image: root header type `ROMFH_HRD`, `spec` pointing at itself
  (or a cycle).
- Or lookup of a cyclic hard-link directory entry.
- Not every boot; only bad/malicious images.
- Unprivileged users cannot mount romfs in a user namespace
  (`FS_REQUIRES_DEV` only). Admins, installers, and fuzzers can.

**Step 8.3: FAILURE MODE SEVERITY**

Infinite loop in `romfs_iget` during `mount(2)` or lookup. After the
first header is cached, `romfs_dev_read` is a tight CPU loop → hung task
/ soft lockup, one CPU stuck in kernel, mount never completes.

Record: **[kernel hang / soft lockup] [HIGH to CRITICAL for
CONFIG_ROMFS_FS; local DoS with mount cap]**

**Step 8.4: RISK-BENEFIT RATIO**

- Benefit: stops a real hang on corrupted/malicious romfs images; 8
  lines; same validation class already accepted in this tree
  (`sb_set_blocksize`).
- Risk: very low; depth 64 will not break genromfs images.

Record: **[high benefit for romfs users] [very low risk] [favor
backport]**

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

FOR:
- Real unbounded loop; image-controlled `spec`; self-loop hangs
  `mount(2)`
- Code is in this 6.1 tree since v2.6.30
- 8-line, one-file, obviously correct `-ELOOP` bound
- Applied by VFS maintainer; no NAK; no later revert/fix on mainline
- fill_super already handles `IS_ERR` from `romfs_iget`
- Applies without `inode_state_read_once`
- Important: hang/soft lockup, not a style tweak

AGAINST:
- romfs is niche
- Needs mount privilege (not unprivileged userns)
- No syzbot/Reported-by/Tested-by
- Lookup `IS_ERR` is redundant with `d_splice_alias` in 6.1

UNRESOLVED:
- lore.kernel.org HTTP 403; stable-list search not readable via WebFetch
  (mbox via b4 succeeded for the fsdevel thread)

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — trivial depth bound; applied
   by Brauner. Testing is implied by mainline merge, not by a Tested-by.
2. Fixes a real bug that affects users? **PASS** — crafted/corrupt romfs
   hangs mount/lookup.
3. Important (crash, security, corruption, deadlock)? **PASS** — kernel
   hang / soft lockup (local DoS).
4. Small and contained? **PASS** — 8 lines, one file.
5. No new features or APIs? **PASS**.
6. Can apply to this tree? **PASS** — buggy code present; hunks match
   6.1 aside from unrelated `inode_state_read_once` context.

**Step 9.3: EXCEPTION CATEGORIES**

None of device-ID / quirk / DT / build / docs. Ordinary small hang fix.

**Step 9.4: DECISION**

This is a small, correct bound on image-controlled iteration that
prevents a kernel hang on 6.1. Privilege to mount does not make an
infinite kernel loop acceptable for stable. Backport it.

---

### What the commit solves for this tree

`romfs_iget()` walks on-disk hard links with no hop limit. A crafted
image can make that walk a cycle, including at the root inode, so
`mount(2)` spins in the kernel. 6.1.188 still has that loop. Returning
`-ELOOP` after 64 hops stops the hang; lookup error propagation is a
small companion change.

### Risk vs benefit

Benefit is avoiding a hung task on bad romfs images. Risk is near zero:
legitimate images do not need deep HRD chains, and the patch does not
change data structures or APIs.

### Concerns

None material. Do not port `inode_state_read_once`; it is not part of
the fix. No prerequisite commits.

---

### Verification

- **[Phase 1]** `git describe HEAD` → `p-6.1-11-g10bc6eb33d95f`; `make
  kernelversion` → **6.1.188**
- **[Phase 1]** `git log origin/master -1 d30b5a954e0a4` — tags: author
  SOB, Brauner SOB, msgid Link; no Fixes/Reported-by/Cc:stable
- **[Phase 2]** `git show --stat d30b5a954e0a4` — `fs/romfs/super.c` +8
- **[Phase 2]** Read local `romfs_iget` / `romfs_lookup` /
  `romfs_fill_super` / `romfs_dev_read` — unbounded HRD loop; out-of-
  image reads fail; in-image cycles do not
- **[Phase 2]** `d_splice_alias` in this tree already handles
  `IS_ERR(inode)` (`fs/dcache.c:3147`)
- **[Phase 3]** `git blame` — HRD walk from **da4458bda237aa**
  (v2.6.30); `git merge-base --is-ancestor da4458bda237aa HEAD` true
- **[Phase 3]** `git merge-base --is-ancestor d30b5a954e0a4 HEAD` false
  — fix **not** in this tree
- **[Phase 3]** `grep ROMFS_MAX_HARDLINK fs/romfs/super.c` — not present
- **[Phase 3]** `git log origin/master d30b5a954e0a4^..origin/master --
  fs/romfs/super.c` — no follow-up fix
- **[Phase 3]** `grep inode_state_read_once` in this tree — **zero
  hits**
- **[Phase 4]** `b4 mbox` msgid
  `20260701220729.822112-1-kudo3228@gmail.com` — 2-message thread;
  Brauner applied to vfs-7.3.misc
- **[Phase 4]** WebFetch lore.kernel.org / patch.msgid.link /
  git.kernel.org → **403** / bot page
- **[Phase 5]** Callers of `romfs_iget`: fill_super (mount) and lookup;
  `fs_flags = FS_REQUIRES_DEV` only
- **[Phase 5]** Docs: hard-link loops called out as image-creator
  responsibility, not kernel-enforced
- **[Phase 6]** Local loop at `fs/romfs/super.c:291-303` matches the
  pre-patch code
- **[Phase 8]** Failure mode: infinite loop in kernel on mount/lookup of
  cyclic HRD
- **UNVERIFIED:** stable@ mailing-list archive (HTTP 403); no public
  crash ID beyond the commit text

**YES**

 fs/romfs/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index e83f9b78d7a16..9b997831a46bc 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -240,6 +240,8 @@ static struct dentry *romfs_lookup(struct inode *dir, struct dentry *dentry,
 			if ((be32_to_cpu(ri.next) & ROMFH_TYPE) == ROMFH_HRD)
 				offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
 			inode = romfs_iget(dir->i_sb, offset);
+			if (IS_ERR(inode))
+				return ERR_CAST(inode);
 			break;
 		}
 
@@ -262,6 +264,8 @@ static const struct inode_operations romfs_dir_inode_operations = {
 	.lookup		= romfs_lookup,
 };
 
+#define ROMFS_MAX_HARDLINK_DEPTH 64
+
 /*
  * get a romfs inode based on its position in the image (which doubles as the
  * inode number)
@@ -273,6 +277,7 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 	struct inode *i;
 	unsigned long nlen;
 	unsigned nextfh;
+	unsigned int depth = 0;
 	int ret;
 	umode_t mode;
 
@@ -289,6 +294,9 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 		if ((nextfh & ROMFH_TYPE) != ROMFH_HRD)
 			break;
 
+		if (++depth > ROMFS_MAX_HARDLINK_DEPTH)
+			return ERR_PTR(-ELOOP);
+
 		pos = be32_to_cpu(ri.spec) & ROMFH_MASK;
 	}
 
-- 
2.53.0

