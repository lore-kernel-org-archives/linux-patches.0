Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6EC3FCB21;
	Tue, 28 Apr 2026 10:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372934; cv=none; b=JeahWS9r6MQeG3fZLyrj5xAdLinL8LXkbQFr0LwX2yHOCKy9AKBxjJdUNf8Othkc3dwClNMvz+BIlzyPCBIhS/zUByZYt0wezx0A4Fo95OsvuqfV2rhLEXHs7BHp82r4Rn/rcddS7kdngZRjJzhrSrFgBW2WCG7YFIs69LUhpAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372934; c=relaxed/simple;
	bh=gmKEEq+Q4TJt+EvN1ei9MyLA41JpySIjVno7v3Cfwp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ACvu6bDIH592gd9MVMnozRI9Wpk7DLU644dqOx6xQ/qXlm2MN7f/mAOsRskdO9cvjgcQa3AfGP9/cBp8wlTnDUgY/rUxTPMpsZZYN4VLV47EsHoECIuMKm01K9l6u9jZsa9P2qkOXsGjjzx62uwXbsBd5GjqnvnWvRO9WqLmqEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IJLD1t5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IJLD1t5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BB2C2BCF5;
	Tue, 28 Apr 2026 10:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372934;
	bh=gmKEEq+Q4TJt+EvN1ei9MyLA41JpySIjVno7v3Cfwp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJLD1t5COAuxzwqM5YRhQ1lk7jSvx6B2tExBF0qeRphAHrXaRmJcMpMsyLUwUhYM2
	 eG6Ck2Mj3Mvdtps6o+pIeAm7RJurNV1oslP3afx9UIrdhIaIn0WCf7PooB1UBAwzpf
	 ItcgFuB6MNxWozsKQj1gaXe7a/+R1MhL3jfA5ygsrrhVyuH3QlvV0H4X6Cr+pDA7fn
	 cJBlLjDFEMae0oPCqajvDp0M881nrgKNbqfvm18BmkwrunVIXS/33aXbDIBABR0xXo
	 o4O5nl4mcRiFq3uSlYQCPHZgC9yD7EXMCZYENU+fy3wlQeHCKT56YzEgcl7FtqlFE9
	 QiqAyT3Yas74A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.15] ntfs3: reject inodes with zero non-DOS link count
Date: Tue, 28 Apr 2026 06:40:40 -0400
Message-ID: <20260428104133.2858589-29-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit e10e72f69734a90c8719d160e8efb164ce5d9e26 ]

ntfs_read_mft() counts file name attributes into two variables:
names (all names including DOS 8.3) and links (non-DOS names
only). The validation at line 424 checks names but set_nlink()
at line 436 uses links. A corrupted NTFS image where all file
name attributes have type FILE_NAME_DOS passes the names check
but results in set_nlink(inode, 0).

When such an inode is loaded via a code path that passes name=NULL
to ntfs_iget5() and the nlink=0 inode enters the VFS. The subsequent
unlink, rmdir, or rename targeting this inode calls drop_nlink()
which triggers WARN_ON(inode->i_nlink == 0) in fs/inode.c.

An all-DOS-name MFT record cannot exist on a valid NTFS volume.
Reject such records by checking for links == 0 before
calling set_nlink().

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to write the analysis. Let me finalize my
review.

## Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line parse**
Record: subsystem `ntfs3`, verb `reject`, intent: reject inodes with
zero non-DOS link count (validation check).

**Step 1.2 — Tags**
Record: Only two SoBs (Ziyi Guo, Konstantin Komarov). No Fixes:, no Cc:
stable, no Reported-by:, no Link:, no Reviewed-by:. Absence is expected
per the rules.

**Step 1.3 — Body text**
Record: Author explains a precise bug mechanism: `names` counts all file
name attrs (incl. FILE_NAME_DOS) while `links` counts only non-DOS. The
existing guard `if (!names)` can pass while `set_nlink(inode, links)`
still sets nlink=0 when every ATTR_NAME is DOS-type. Subsequent
unlink/rmdir/rename of such an inode hits `drop_nlink()` which fires
`WARN_ON(inode->i_nlink == 0)` in `fs/inode.c`. Trigger:
corrupted/malicious NTFS image; no version info given.

**Step 1.4 — Hidden fix detection**
Record: Explicitly a fix ("reject"). Not hidden.

### PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record: 1 file `fs/ntfs3/inode.c`, +5/-0, one function
`ntfs_read_mft()`. Single-file surgical fix.

**Step 2.2 — Code flow**
Record: Before: after `names` validation, code falls through to
`set_nlink(inode, links)`. After: additional `if (!links) { err =
-EINVAL; goto out; }` short-circuits before `set_nlink` for records
whose only names are DOS 8.3.

**Step 2.3 — Bug mechanism**
Record: Category (g) Logic/correctness + defensive validation for on-
disk corruption. Closes an inconsistency between the validator (`names`)
and the consumer (`links`). Prevents VFS invariant violation
(inode->i_nlink==0 for a living inode), which is what the WARN_ON in
`drop_nlink()` guards.

**Step 2.4 — Quality**
Record: Obviously correct; the branch targets the existing `out:` which
does `iget_failed(inode)` and returns `ERR_PTR(err)`. Adds no lock
changes, no allocation changes. Zero regression risk on valid NTFS
(valid records have `links >= 1`, author states an all-DOS-name MFT
record cannot exist on a valid NTFS volume).

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
Record: `git blame` on the area around the fix shows `set_nlink(inode,
links)` was introduced by `110b24eb1a749b` ("fs/ntfs3: Taking DOS names
into account during link counting", Apr 17 2024, Konstantin Komarov).

**Step 3.2 — Fixes: target**
Record: No Fixes: tag in the commit, but the root cause (splitting
`names` vs `links` and using `links` for nlink while validating `names`)
was introduced by `110b24eb1a749b`. That commit had `Cc:
stable@vger.kernel.org` and `Fixes: 82cae269cfa95 ("fs/ntfs3: Add
initialization of super block")`.

**Step 3.3 — File history**
Record: Standalone commit; not part of any series. Close neighbors in
ntfs3 are independent fixes (e.g. `06909b2549d63`, `4b90f16e4bb56`
handling corrupted metadata).

**Step 3.4 — Author history**
Record: Ziyi Guo has 17 commits in the tree, all small defensive
validation / lock fixes across drivers (net, wifi, USB, ASoC, power) —
typical profile of a researcher/fuzzer-finder. Not the subsystem
maintainer, but the patch was applied by maintainer Konstantin Komarov.

**Step 3.5 — Dependencies**
Record: No dependency. Uses existing locals `links`/`names`, the
existing `out:` label, and `err = -EINVAL`. Self-contained.

### PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — b4 dig / thread**
Record: `b4 dig -c e10e72f69734a` → thread at `https://lore.kernel.org/a
ll/20260210155634.380168-1-n7l8m4@u.northwestern.edu/`. Single revision
(v1). Maintainer Konstantin Komarov replied Feb 24 2026: "Patch looks
good — applied. Thanks." No NAK, no stable nomination, no concerns.

**Step 4.2 — Reviewers**
Record: `b4 dig -w` shows the patch was sent to Konstantin Komarov
(maintainer), ntfs3@lists.linux.dev, linux-kernel@vger.kernel.org.
Appropriate recipients.

**Step 4.3 — Bug report**
Record: No Reported-by:/Link: tags. The commit wording ("A corrupted
NTFS image") and the author's fuzzer-style track record strongly suggest
this was found via fuzzing, though not attributed to syzbot on the list.

**Step 4.4 — Related patches**
Record: No series. Standalone.

**Step 4.5 — Stable discussion**
Record: None found.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key function**
Record: `ntfs_read_mft()`.

**Step 5.2 — Callers**
Record: `ntfs_read_mft` is only called from `ntfs_iget5()`. `ntfs_iget5`
is called with `name=NULL` from many user-reachable paths:
`fs/ntfs3/dir.c:265` (lookup via `indx_find`), `dir.c:337` (readdir /
`ntfs_dir_emit`), `fs/ntfs3/namei.c:371` (`ntfs3_get_parent` — NFS
export / open-by-handle), `fs/ntfs3/frecord.c:2945,3064`, plus super-
block metadata loads. In particular the dir.c:337 readdir path and the
namei.c:371 get_parent path exactly match the commit description's
"name=NULL to ntfs_iget5()".

**Step 5.3 — Callees affected by fix**
Record: Only `set_nlink(inode, links)` is gated behind the new check.
The `out:` path was already correct.

**Step 5.4 — Reachability**
Record: Reachable from userspace via mount + readdir/lookup on a crafted
NTFS image. `drop_nlink()` path reachable via `ntfs_unlink()` and
`ntfs3_rmdir()` in `fs/ntfs3/namei.c` / `fs/ntfs3/inode.c:1838`. End-to-
end chain confirmed.

**Step 5.5 — Similar patterns**
Record: Many recent ntfs3 commits follow the same pattern of hardening
against corrupted on-disk structures (`0dc7117da8f92`, `06909b2549d63`,
`4b90f16e4bb56`, `1732053c8a6b3`, `7443753436620`). Community actively
accepts and backports these.

### PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1 — Bug present in stable?**
Record: The faulty `set_nlink(inode, links)` (without the `!links`
guard) was backported to:
- `stable/linux-5.15.y` as `7ab0c256964ef`
- `stable/linux-6.1.y` as `df40783dc3773`
- `stable/linux-6.6.y` as `e4fd2dce71fbd`
- `stable/linux-6.12.y` as `110b24eb1a749` (same SHA)
So the bug exists in 5.15+, 6.1+, 6.6+, 6.12+ stable trees.

**Step 6.2 — Backport complications**
Record: Verified the code context in `stable/linux-5.15.y` and
`stable/linux-6.6.y` — the surrounding lines (`names !=
le16_to_cpu(rec->hard_links)` block and `set_nlink(inode, links)`) are
identical to mainline. Patch applies cleanly; no rework expected for
5.15.y/6.1.y/6.6.y/6.12.y and newer active LTS branches. Branches
without 110b24eb's equivalent (older than 5.15 or before the April 2024
backport) do not have the bug and do not need this fix.

**Step 6.3 — Existing related stable fixes**
Record: None — no other "reject inodes with zero links" fix exists.

### PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem criticality**
Record: `fs/ntfs3` — filesystem. IMPORTANT. Users of NTFS read-write
support (Windows dual-boot, removable media), plus security surface for
mountable filesystem images.

**Step 7.2 — Activity**
Record: Very active. Multiple corruption-hardening fixes in every recent
merge window.

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Affected users**
Record: Users of ntfs3 who can mount attacker-controlled (or naturally
corrupted) NTFS images. Also anyone who auto-mounts removable media.
Filesystem-specific, not universal.

**Step 8.2 — Trigger**
Record: Crafted NTFS image where an MFT record has only FILE_NAME_DOS
attributes (and no non-DOS name). Valid NTFS never produces this, so the
trigger requires a malformed image. On systems allowing unprivileged
mounting (user namespaces + fuse-style setups, some distros' udisks
configs) the trigger can be reached without root.

**Step 8.3 — Failure mode severity**
Record: `WARN_ON(inode->i_nlink == 0)` → kernel warning with stack. On
`panic_on_warn` systems (common in hardened / KASAN / fuzzing
environments) it becomes a panic / DoS. Also a reliable way to trigger
VFS invariants violation for further exploration. Severity: MEDIUM-HIGH
(DoS via crafted FS image, security-relevant).

**Step 8.4 — Risk/benefit**
Record: Benefit: prevents a WARN/panic on malformed NTFS images, closes
a small attack surface. Risk: extremely low — 5 additional lines on the
error path, using the same `out:` cleanup already there; impossible to
affect a valid NTFS volume per the filesystem semantics described.

### PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence compile**

FOR:
- Small (5 lines), surgical, single-function, no lock/alloc churn.
- Fixes a concrete bug mechanism with clear reachability from user-
  triggerable paths (readdir, lookup, NFS get_parent).
- Bug introduced by `110b24eb1a749b` (already in
  5.15.y/6.1.y/6.6.y/6.12.y stable), so active LTS trees are vulnerable.
- Maintainer applied it with explicit approval ("Patch looks good —
  applied").
- Same pattern (corrupted-FS validation) is standard stable material for
  ntfs3.
- Failure mode is a WARN (or panic with panic_on_warn), security-
  relevant for mountable FS images.
- Applies cleanly to stable branches (verified identical context in
  5.15.y and 6.6.y).

AGAINST:
- No Fixes: / Cc: stable tags, no Reported-by:/Link:, no syzbot
  attribution in message (absence of tags is expected per rules and not
  a negative signal).

**Step 9.2 — Stable rules checklist**
1. Obviously correct & tested? Yes — maintainer-applied, trivial gate
   check before existing code path.
2. Real bug? Yes — WARN triggers on documented code path.
3. Important? Yes — corrupted/malicious FS image → kernel WARN,
   potential DoS; security-relevant.
4. Small/contained? Yes — 5 LOC, one function.
5. No new features/APIs? Correct.
6. Applies to stable? Yes — verified identical context in 5.15.y /
   6.6.y.

**Step 9.3 — Exception**
Record: Fits the "corruption hardening" pattern commonly accepted for
filesystems.

**Step 9.4 — Decision**
The fix is an obvious, minimal validation that prevents a VFS invariant
violation reachable via a crafted NTFS image on all LTS trees that have
commit `110b24eb1a749b` backported (5.15, 6.1, 6.6, 6.12). Benefit
clearly outweighs negligible risk.

## Verification

- [Phase 1] Parsed commit message and tags directly from the commit
  body; confirmed no Fixes:/Cc: stable/Reported-by: tags. No hidden
  framing — patch explicitly says "reject".
- [Phase 2] Read the relevant portion of `fs/ntfs3/inode.c` (lines
  140–230 and 400–500) to confirm `names` is incremented for every
  ATTR_NAME, `links` only for non-DOS names, and the fix goto-targets
  the existing `out:` handler.
- [Phase 3] `git blame` on `fs/ntfs3/inode.c` lines 420–440:
  `set_nlink(inode, links)` originates in `110b24eb1a749b` ("fs/ntfs3:
  Taking DOS names into account during link counting", 2024-04-17); that
  commit has `Cc: stable@vger.kernel.org` and `Fixes: 82cae269cfa95`.
- [Phase 3] `git show 110b24eb1a749b`: confirmed the stable-tagged
  commit that introduced the vulnerability pattern.
- [Phase 3] `git log --author="Ziyi Guo"`: 17 small validation / locking
  fixes across subsystems; not subsystem maintainer.
- [Phase 4] `b4 dig -c e10e72f69734a`: found single-revision thread at `
  https://lore.kernel.org/all/20260210155634.380168-1-
  n7l8m4@u.northwestern.edu/`; saved mbox to `/tmp/thread.mbox` and read
  the maintainer's "applied" reply.
- [Phase 4] `b4 dig -c e10e72f69734a -w`: confirmed recipients
  (Konstantin Komarov, ntfs3@lists.linux.dev, linux-
  kernel@vger.kernel.org).
- [Phase 4] Verified via spinics mirror that only one version was sent
  and only one reply ("applied") was received.
- [Phase 5] `rg ntfs_iget5` in `fs/ntfs3`: enumerated all callers and
  confirmed multiple user-reachable paths pass `name=NULL` (dir.c:337,
  namei.c:371, frecord.c:2945/3064).
- [Phase 5] Read `drop_nlink()` at `fs/inode.c:416-422` to confirm the
  exact `WARN_ON(inode->i_nlink == 0)` location.
- [Phase 5] Located `drop_nlink(inode)` call sites in ntfs3
  (`namei.c:155`, `inode.c:1838`), confirming user unlink/rmdir/rename →
  `drop_nlink` chain.
- [Phase 6] Queried each stable branch directly for the "Taking DOS
  names" backport: found `7ab0c256964ef` in 5.15.y, `df40783dc3773` in
  6.1.y, `e4fd2dce71fbd` in 6.6.y, `110b24eb1a749` in 6.12.y — the buggy
  change is in those stables.
- [Phase 6] `git show stable/linux-6.6.y:fs/ntfs3/inode.c` and
  `stable/linux-5.15.y:fs/ntfs3/inode.c` around the target lines:
  context is identical to mainline, confirming clean application.
- [Phase 6] Searched each stable branch for the fix ("reject inodes" /
  "non-DOS link" in inode.c); not present in any stable, so no
  duplicate.
- [Phase 7] File path identifies subsystem as `fs/ntfs3`; `git log
  --oneline fs/ntfs3` shows active subsystem with frequent corruption-
  hardening fixes.
- [Phase 8] Failure mode verified by reading `drop_nlink()` source and
  tracing the reachable ntfs3 call chain; severity assessed as MEDIUM-
  HIGH (WARN → panic_on_warn).
- UNVERIFIED: Whether a syzbot report specifically mentions this
  signature (no Reported-by in the commit; could not confirm a direct
  syzkaller report link). This does not affect the decision because the
  mechanism is verified by code reading.

The fix is small, obviously correct, fixes a real reachable bug, is
already applied by the maintainer, and applies cleanly to LTS trees that
have the buggy precursor commit. It meets all stable-kernel criteria.

**YES**

 fs/ntfs3/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 6e65066ebcc1a..398913595a551 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -432,6 +432,11 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 		ni->mi.dirty = true;
 	}
 
+	if (!links) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	set_nlink(inode, links);
 
 	if (S_ISDIR(mode)) {
-- 
2.53.0

