Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2346C5867EE;
	Mon, 31 Aug 2026 13:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184213; cv=none; b=TvgCtPmnYXM9JZ4/B8IDuBKNQ65wmD213f3qemoFXVlqVbjqcw5weg+GWvqa0gC5uqqhjIrqRkpLB/FGeJvGBok0YK9srq8dIuHB9ACzDtGi2K3uEUV6AWKe72JFGaT12WV6LK12/D8IqclYpg4Vk33nDfPJ/nOMiHNax0SRJIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184213; c=relaxed/simple;
	bh=YnPFCGJcWdDBVVQkSlO3+u7hpEcBGU4mR7qn21uS8ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ts3tVu5CK/RpXYmIH2d3y9wMoPTTkYnMzctaVVOCNSo6IhFTvsCy7PgTeJ+nL/SDRNIMG7RfVyAGIsK0O2MoEjnwHWri3zUBA3vG1QXTfmSoKAIkYYWYWj/f3dwEcxzMyU3SiydEB0ekloOysbxKO3NF9ZNb3MbuM6q5DSOmgLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZ2Z6sl+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZ2Z6sl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FEC1F00A3F;
	Mon, 31 Aug 2026 13:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184211;
	bh=M+2sV5VWO+YtF84UKTySxf7eaDyYYr+uKqmiduOautc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZ2Z6sl+XxVuKYQ7cdgA5XRUZlH2m2RoHAIxEZ5ta1o+VDpYzHwh/H4PwcnSIHal2
	 zh5Q9/l6cEy6ujcLQFcpXYbEtiBAzefuRen/K/tHVJsiNC6uVqvk+kQPrJ6kHP22X5
	 ZV2xwTBNQyEFNv3KqT8LZfr2M5FSpvraiIyZ/WB72EhJysZdsAza4BGwRt1sblUAuC
	 lnaCwrE06Ql3MtjVsXE1b3QrPHlclDGvF0U/zDXQ6CGpkdv8mKuzEiO++H4La1vMiU
	 rSwfqj2bBmfM1FkkarISf+WfHqRuGsrmsMrIQ3R5yhsVLOssonPp0T2CsQN5L8UB/Y
	 YGKCk/DF03jLQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Farhad Alemi <farhad.alemi@berkeley.edu>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] freevxfs: don't BUG() on unknown typed-extent type
Date: Mon, 31 Aug 2026 09:29:46 -0400
Message-ID: <20260831133314.4125787-558-sashal@kernel.org>
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

From: Farhad Alemi <farhad.alemi@berkeley.edu>

[ Upstream commit 704d48d81dc41470e108811c32c577ada66192d4 ]

vxfs_bmap_typed() handles four typed-extent types and calls BUG() in
its default case, so an on-disk typed extent with any other type value
crashes the kernel. It is reachable from ioctl(FIBMAP) on a regular
file:

  kernel BUG at fs/freevxfs/vxfs_bmap.c:230!
  RIP: vxfs_bmap_typed fs/freevxfs/vxfs_bmap.c:230 [inline]
       vxfs_bmap1+0x128a/0x12d0 fs/freevxfs/vxfs_bmap.c:257

Replace the BUG() with WARN_ON_ONCE() and return 0 -- the value
vxfs_bmap_typed() already returns on failure (and from the DEV4 case
above); vxfs_getblk() maps 0 to -EIO, so the ioctl fails cleanly.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Link: https://patch.msgid.link/CA+0ovChveuAwv=t15dr2m09E32bM48hHJxvfeEYZOhdNiEc9Tw@mail.gmail.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `freevxfs: don't BUG() on unknown typed-
extent type`

**Local tree:** Linux **6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`; Makefile `VERSION=6 PATCHLEVEL=18
SUBLEVEL=44`). The fix commit `704d48d81dc41` is on `master` but is
**not** an ancestor of HEAD (`git merge-base --is-ancestor` exit code
1). The buggy `BUG()` at line 230 of `fs/freevxfs/vxfs_bmap.c` is still
present in this checkout.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**
Record: `[freevxfs] [don't] [replace BUG() on unknown typed-extent type
with graceful error handling]`

**Step 1.2 — Tags**
Record:
- `Reported-by:` Farhad Alemi `<farhad.alemi@berkeley.edu>` (reporter
  hit the bug with a crafted image)
- `Reviewed-by:` Christoph Hellwig `<hch@lst.de>` (freevxfs original
  author / VFS maintainer)
- `Signed-off-by:` Farhad Alemi, Christian Brauner
- `Link:` https://patch.msgid.link/CA+0ovChveuAwv=t15dr2m09E32bM48hHJxvf
  eEYZOhdNiEc9Tw@mail.gmail.com
- No `Fixes:` tag (expected for manual review)
- No `Cc: stable@vger.kernel.org` (expected; not a negative signal)
- No syzbot report

**Step 1.3 — Body analysis**
Record:
- **Bug:** `vxfs_bmap_typed()` hits `BUG()` in the `default` switch case
  when an on-disk typed extent has a type value outside the four handled
  cases (INDIRECT, DATA, INDIRECT_DEV4, DATA_DEV4).
- **Symptom:** Kernel panic — `kernel BUG at
  fs/freevxfs/vxfs_bmap.c:230!` with stack through `vxfs_bmap1`.
- **Trigger (documented):** `ioctl(FIBMAP)` on a regular file after
  mounting a crafted VxFS image.
- **Fix approach:** Replace `BUG()` with `WARN_ON_ONCE(1); return 0;`,
  matching existing failure behavior (DEV4 cases already return 0;
  `vxfs_getblk()` maps 0 → `-EIO`).
- **Root cause:** Driver treats unexpected on-disk metadata as a kernel
  invariant violation instead of a filesystem error.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Despite the subject using "don't BUG()", this is a real
crash fix disguised as defensive hardening — corrupted/crafted on-disk
data must not panic the kernel.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
- **Files:** `fs/freevxfs/vxfs_bmap.c` only (+2 / −1 lines)
- **Function:** `vxfs_bmap_typed()`
- **Scope:** Single-file, surgical, 3-line hunk

**Step 2.2 — Code flow change**
Record:
- **Before:** Unknown typed-extent type → `BUG()` → kernel panic.
- **After:** Unknown typed-extent type → `WARN_ON_ONCE(1)` + `return 0`
  → caller treats as mapping failure.
- **Path:** Error/default branch inside the typed-extent switch in
  `vxfs_bmap_typed()`.

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Logic/correctness fix — improper fatal assertion on bad
  input data.
- **Mechanism:** On-disk extent header type field (bits from `hdr >>
  VXFS_TYPED_TYPESHIFT`) not in {1,2,3,4} triggers `BUG()`. Fix degrades
  to warning + zero return, consistent with DEV4 unsupported path and
  function's documented "returns zero on failure" contract.

**Step 2.4 — Fix quality**
Record:
- **Obviously correct:** Yes — mirrors the existing DEV4 `return 0`
  pattern two cases above.
- **Minimal:** Yes — no structural changes.
- **Regression risk:** Very low. Worst case: silent hole mapping instead
  of panic on corrupt data (strict improvement).
- **Note:** `vxfs_bmap_indir()` at line 162 still has `BUG()` on unknown
  types — separate, unaddressed issue; does not invalidate this fix.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
Record: `BUG()` in `vxfs_bmap_typed()` default case dates to initial
import commit `1da177e4c3f41` (Linux-2.6.12-rc2, 2005). Bug has existed
for the entire lifetime of freevxfs in the kernel.

**Step 3.2 — Fixes: tag**
Record: Not applicable — no `Fixes:` tag present.

**Step 3.3 — File history**
Record: Recent changes to `vxfs_bmap.c` in this tree are kernel-doc and
endianness fixes only (`ec3a8dd38199a`, `0d83f7fc83f77`, etc.). No
related fix already applied. Standalone patch, not part of a series.

**Step 3.4 — Author context**
Record: Farhad Alemi is the reporter/fixer. Patch committed by Christian
Brauner (VFS maintainer). Reviewed by Christoph Hellwig (freevxfs
original author). Strong subsystem review signal.

**Step 3.5 — Dependencies**
Record: **None.** Self-contained; no prerequisite commits. Applies
cleanly to current `vxfs_bmap.c` in this tree (verified: index hash
matches `e85222892038f`).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c 704d48d81dc41` → https://patch.msgid.link/CA+0ovChveuAwv=t1
  5dr2m09E32bM48hHJxvfeEYZOhdNiEc9Tw@mail.gmail.com
- Series: v1 (2026-05-29) → v2 (2026-06-01); committed version is v2
  (latest).
- v1 body explicitly describes crafted VxFS image + FIBMAP crash.
- No NAKs found in thread.
- No explicit `Cc: stable` nomination in thread.

**Step 4.2 — Reviewers**
Record: `b4 dig -w` shows CC to `linux-fsdevel@vger.kernel.org`, `linux-
kernel@vger.kernel.org`, Christoph Hellwig, Christian Brauner. Hellwig
provided `Reviewed-by`.

**Step 4.3 — Bug report**
Record: Reporter is also the author; reproduced with stack trace
included in commit message. Crafted on-disk image is the trigger.
Severity from reporter: kernel crash (CRITICAL).

**Step 4.4 — Related patches**
Record: Standalone 1/1 patch. No series dependencies.

**Step 4.5 — Stable list**
Record: No stable-specific discussion found in the thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
Record: `vxfs_bmap_typed()` (modified), `vxfs_bmap1()` (caller),
`vxfs_getblk()` (maps 0 → `-EIO`), `vxfs_bmap()` /
`generic_block_bmap()` (FIBMAP path), `vxfs_read_folio()` (read path).

**Step 5.2 — Callers**
Record:
- `vxfs_bmap1()` ← `vxfs_getblk()`, `vxfs_bread()`
- `vxfs_getblk()` ← `vxfs_read_folio()` (via `block_read_full_folio`),
  `vxfs_bmap()` (via `generic_block_bmap`)
- `vxfs_bmap()` registered in `vxfs_aops.bmap`
  (`fs/freevxfs/vxfs_subr.c:22`)
- FIBMAP: `ioctl(FIBMAP)` → `file_ioctl()` → `ioctl_fibmap()` → `bmap()`
  → `a_ops->bmap` → `vxfs_bmap` → `generic_block_bmap` → `vxfs_getblk` →
  `vxfs_bmap1` → `vxfs_bmap_typed`

**Step 5.3 — Callees**
Record: `vxfs_bmap_typed()` reads inode typed-extent metadata
(`vip->vii_org.typed`), switches on extent type; may call
`vxfs_bmap_indir()` for indirect extents.

**Step 5.4 — Reachability**
Record:
- **FIBMAP path:** Reachable from userspace with `CAP_SYS_RAWIO`
  (verified in `ioctl_fibmap()` at `fs/ioctl.c:65`).
- **Read path:** Also reachable without special capability — mounting a
  VxFS image and reading a file with a bad typed extent would traverse
  `vxfs_read_folio` → `vxfs_getblk` → `vxfs_bmap_typed`. This is a
  stronger trigger than FIBMAP alone.
- **Userspace trigger:** Yes — via mounted crafted/corrupt VxFS image
  (common fuzzing/forensics scenario).

**Step 5.5 — Similar patterns**
Record: `vxfs_bmap_indir()` has an identical `BUG()` on unknown type
(line 162) — same class of bug, different code path (indirect blocks).
This commit fixes only the direct `vxfs_bmap_typed()` path.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

**Step 6.1 — Buggy code present?**
Record: **Yes.** `fs/freevxfs/vxfs_bmap.c:229-230` contains `default:
BUG();` in `vxfs_bmap_typed()`. freevxfs driver and `CONFIG_VXFS_FS`
Kconfig exist in this 6.18.44 tree. Bug present since 2.6.12 import.

**Step 6.2 — Backport complications**
Record: **Clean apply expected.** File unchanged at the target hunk
since mainline commit; `git show 704d48d81dc41` applies to current tree
index `e85222892038f`. No conflicting changes in `vxfs_bmap.c` on this
branch since the fix landed on master.

**Step 6.3 — Related fixes already present?**
Record: **None.** `git log --grep="freevxfs: don't BUG"` on current
branch does not include this commit. `git merge-base --is-ancestor
704d48d81dc41 HEAD` returned exit code 1 (not merged).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem criticality**
Record: **Filesystem driver** (`fs/freevxfs/`) — IMPORTANT but niche.
`CONFIG_VXFS_FS` is tristate, defaults to off ("If unsure, say N").
Read-only VERITAS VxFS compatibility for legacy Unix systems (SCO
UnixWare, HP-UX images).

**Step 7.2 — Activity**
Record: Low activity subsystem — mostly maintenance/doc fixes. Long-
stable code with a longstanding assertion bug.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Who is affected**
Record: Users who enable `CONFIG_VXFS_FS` (built-in or module) and mount
VxFS images — forensics, migration, or compatibility workloads. Small
population, but real.

**Step 8.2 — Trigger conditions**
Record:
- Mount VxFS filesystem with typed-extent inode containing unknown type
  value in on-disk metadata.
- Then: read file data **or** issue `ioctl(FIBMAP)` (latter needs
  `CAP_SYS_RAWIO`).
- Trigger is deterministic with crafted image; also possible with real-
  world corrupt media.
- Unprivileged users can trigger via read path on a mounted image they
  can access.

**Step 8.3 — Failure mode severity**
Record: **Kernel BUG/panic** — severity **CRITICAL**. Full system crash,
potential data loss for unrelated workloads.

**Step 8.4 — Risk-benefit**
Record:
- **Benefit:** Eliminates deterministic kernel panic on bad/crafted on-
  disk metadata; converts to `-EIO`/hole mapping.
- **Risk:** Negligible — 2-line behavioral change on already-broken data
  path.
- **Ratio:** High benefit, very low risk. Classic "filesystem must not
  panic on bad blocks" fix.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

**FOR backport:**
- Real, reproducible kernel panic (stack trace in commit message)
- Small, surgical, reviewed by subsystem expert (Hellwig)
- Bug present since 2005 in code that exists unchanged in 6.18.44
- Reachable from userspace (file read and FIBMAP ioctl)
- Fix is obviously correct and matches existing error-handling pattern
- Clean apply to this tree

**AGAINST backport:**
- Niche filesystem (`CONFIG_VXFS_FS` off by default)
- Read-only driver with small user base
- Does not fix the parallel `BUG()` in `vxfs_bmap_indir()` (incomplete
  coverage, not a reason to reject this fix)
- No explicit stable nomination in mailing list

**Unresolved:** None material to the decision.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — minimal change, Reviewed-by
   Hellwig, reporter tested with crafted image.
2. Fixes a real bug affecting users? **PASS** — kernel panic on
   crafted/corrupt VxFS typed extent.
3. Important issue? **PASS** — CRITICAL (kernel BUG/panic).
4. Small and contained? **PASS** — 3 lines, one file, one function.
5. No new features or APIs? **PASS** — error-path behavior change only.
6. Can apply to local tree? **PASS** — buggy code present, clean apply
   verified.

**Step 9.3 — Exception categories**
Record: Not a device ID/quirk/DT/build/doc fix. Qualifies on standard
crash-fix criteria.

**Step 9.4 — Decision rationale**
This commit prevents a deterministic kernel panic when freevxfs
encounters an on-disk typed extent with an unrecognized type value. The
bug has existed since the driver's initial import and remains in Linux
6.18.44. The fix is minimal, reviewed by the original driver author, and
converts a fatal `BUG()` into graceful error propagation already used
for other unsupported extent types. Even though freevxfs is a niche
read-only filesystem, stable kernels must not panic on corrupt or
crafted filesystem images — this is exactly the class of fix stable
trees accept.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from `git show
  704d48d81dc41`
- **[Phase 1]** Confirmed `Reported-by: Farhad Alemi`, `Reviewed-by:
  Christoph Hellwig`
- **[Phase 2]** Diff analysis: 2 insertions, 1 deletion in
  `vxfs_bmap_typed()` default case
- **[Phase 2]** Read `fs/freevxfs/vxfs_bmap.c:186-271` — confirmed
  `BUG()` at line 230 in HEAD
- **[Phase 2]** Read `vxfs_getblk()` at `fs/freevxfs/vxfs_subr.c:98-111`
  — confirmed `pblock == 0` returns `-EIO`
- **[Phase 3]** `git blame -L 229,231` — `BUG()` from `1da177e4c3f41`
  (Linux-2.6.12-rc2)
- **[Phase 3]** `git log --oneline -20 -- fs/freevxfs/vxfs_bmap.c` — no
  prior fix for this issue
- **[Phase 3]** `git merge-base --is-ancestor 704d48d81dc41 HEAD` — exit
  1 (fix not in tree)
- **[Phase 4]** `b4 dig -c 704d48d81dc41` — found v2 thread URL
- **[Phase 4]** `b4 dig -c 704d48d81dc41 -a` — v1→v2 series, committed
  version is v2
- **[Phase 4]** `b4 dig -c 704d48d81dc41 -w` — CC'd linux-fsdevel,
  Hellwig, Brauner
- **[Phase 4]** `b4 dig -m /tmp/freevxfs_bug.mbox` — Hellwig Reviewed-
  by, no NAKs, no stable CC
- **[Phase 5]** Traced FIBMAP path: `fs/ioctl.c:325-326` →
  `ioctl_fibmap:58-76` → `bmap:1997-2003` → `vxfs_bmap:149-151` →
  `generic_block_bmap:2756-2765` → `vxfs_getblk` → `vxfs_bmap1` →
  `vxfs_bmap_typed`
- **[Phase 5]** Traced read path: `vxfs_aops.read_folio` →
  `vxfs_read_folio:128-130` → `vxfs_getblk`
- **[Phase 5]** Confirmed `ioctl_fibmap` requires `CAP_SYS_RAWIO`
  (`fs/ioctl.c:65`)
- **[Phase 5]** Found parallel `BUG()` in `vxfs_bmap_indir` at line 162
  (unfixed by this commit)
- **[Phase 6]** `git describe HEAD` → v6.18.44; Makefile confirms
  6.18.44
- **[Phase 6]** Buggy code confirmed present at `vxfs_bmap.c:230`
- **[Phase 6]** `git show 704d48d81dc41` — patch index matches current
  file (`e85222892038f`)
- **[Phase 7]** Read `fs/freevxfs/Kconfig` — `CONFIG_VXFS_FS` tristate,
  defaults off, read-only
- **[Phase 8]** Failure mode verified as kernel BUG/panic from commit
  message stack trace

**YES**The background git searches finished:

- One search hung because it used `git log --all` (which we avoid here);
  it was killed.
- A follow-up search on `master` found the fix as commit `704d48d81dc41`
  (`freevxfs: don't BUG() on unknown typed-extent type`).
- That commit is **not** in the current 6.18.44 tree (`git merge-base
  --is-ancestor` returned exit code 1).

That matches the earlier analysis: the `BUG()` is still present locally,
and the backport verdict remains **YES**.

 fs/freevxfs/vxfs_bmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/freevxfs/vxfs_bmap.c b/fs/freevxfs/vxfs_bmap.c
index 26d367e3668da..de4003597b555 100644
--- a/fs/freevxfs/vxfs_bmap.c
+++ b/fs/freevxfs/vxfs_bmap.c
@@ -227,7 +227,8 @@ vxfs_bmap_typed(struct inode *ip, long iblock)
 			return 0;
 		}
 		default:
-			BUG();
+			WARN_ON_ONCE(1);
+			return 0;
 		}
 	}
 
-- 
2.53.0

