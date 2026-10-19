Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0597F621530;
	Mon, 19 Oct 2026 14:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418686; cv=none; b=B9m4MNXuSxMkq52zUyhizQaO99BqkQSgoA6RXoDcyBm8r+BipAG7Z8ubzwvyjH4JGseoH8jBSnfjHarMpIM2MlKCFyuN8nFLVo+N127EdiAkI/FtVkhiCjWipKzQ8K+M5WeP+ewBxXpaXdJm07jrJPgGdsyRg9cw1umAih7lvQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418686; c=relaxed/simple;
	bh=UxgYAVt7T7mKJm1EEapzlYzDOLV68JxCW59NobJA8xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dq2+INt8Gn4koinFJiClFfIbKYYF0SNz6eIZ3TFu9HPitROoFhDK/rE9nkMeq73/FgFbdMobxJiYp9EtJjwBcBvSspw79Her9JfEZ8d94+uaQIqrVzqHtdCqp3HFmyTNjNNwhiECMQ7Q6DiEDV7Ikn1Pqp4wRk8hPRwui7Qrd7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jza5pUxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jza5pUxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B581F000C4;
	Mon, 19 Oct 2026 14:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418682;
	bh=28ddZe0ZAUTWgPWrbXLSWvpXeelnwH5XNSDrOpcjeMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jza5pUxAfrQcps4/981xHjGpUzdFnb49+zN1BEcGMwKw6ZNGJjNA613otOo59Kpjo
	 miaew/pvmEYW83rBZBOLK2DkSkmvJWynDBRZQnfuo1GCAmjW7dkXSIJHLEDnrG4wPX
	 emeGzV3f6E+xWzox1wy5O0wYP1qCASO0HbMlkJZKNY5zu14EwCw8AmMu9hSJ2PeI/L
	 pIQLOQY1vDHmFgMSPoPVa00mtQm/I60hTszNwft8SxexYMKy9X3c9q2g/+NwXYMSJ1
	 juklYgk25aTigfiq/zEy2BWMhvcqdl4qHgWaOzD2LNWFuiXvmU6xD4JG78Gcte8QDd
	 +Chduc6jpDwVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	syzbot+905d785c4923bea2c1db@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ntfs3: fix info-leak in ntfs_rename()
Date: Mon, 19 Oct 2026 09:51:53 -0400
Message-ID: <20261019135441.1420968-422-sashal@kernel.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 2fa56613b25d0c983ef3ff6d3e865d4254280abe ]

Hard to say about copy_to_user_iter(), but at least the first splat
looks correct. At the end of fill_name_de(), data layout is:

struct NTFS_DE *e = buf;
...

    |<- data_size + sizeof(struct NTFS_DE) ->|<- XXX ->|
buf |-----------------------------------------------------------
    |<- ALIGN(data_size, 8) + sizeof(struct NTFS_DE) ->|   ;; e->size

If 'buf' was allocated with kmalloc(), XXX remains uninitialized and
passed as such to memcpy() called from hdr_insert_de().

So using kzalloc() for all buffers passed to fill_name_de() looks
the simplest and most safe solution. OTOH if someone would have
said that an overhead of PAGE_SIZE'd memset() is too large, more
fine-granted solution is to memset() XXX only.

Reported-by: syzbot+905d785c4923bea2c1db@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=905d785c4923bea2c1db
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real KMSAN kernel infoleak in ntfs3 rename: 8-byte alignment
padding in directory entries is copied from uninitialized `kmalloc()`
memory onto the volume. The local tree is **7.3.0-rc4**
(`v7.3-rc4-27-gf0100363d8c37`); ntfs3 and `fill_name_de()` exist here,
and the fix is small, correct, and reachable from `rename(2)`.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ntfs3] [fix] info-leak in `ntfs_rename()`**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Reported-by:**
  `syzbot+905d785c4923bea2c1db@syzkaller.appspotmail.com` (syzbot /
  KMSAN)
- **Closes:**
  `https://syzkaller.appspot.com/bug?extid=905d785c4923bea2c1db`
- **Signed-off-by:** Dmitry Antipov (author of the analysis/patch);
  Konstantin Komarov (ntfs3 maintainer, applied it)
- **No Fixes:** tag on the committed version (v1 on-list had `Fixes:
  ca2a04e84af7`, dropped later)
- **No Cc: stable** (expected for this review)
- **No Tested-by / Reviewed-by / Acked-by / Link:** (Closes URL is the
  bug tracker)

Notable: syzbot + maintainer SOB.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** After `fill_name_de()`, `e->size` is 8-byte-aligned
  (`ALIGN(data_size, 8) + sizeof(NTFS_DE)`). The pad between `data_size
  + sizeof(NTFS_DE)` and that aligned size (`XXX`) is never written if
  `buf` came from `kmalloc()`.
- **Failure mode:** That pad is `memcpy()`’d in `hdr_insert_de()`,
  written out with the index/MFT record, then observed as a **KMSAN
  kernel-infoleak** when the block is later read into userspace
  (`copy_to_user_iter` / `filemap_read`).
- **Root cause (author):** uninitialized alignment padding, not a
  `rename()` copy_to_user of the name buffer itself.
- **Fix chosen:** memset only `XXX` (0–7 bytes), instead of
  `kzalloc(PATH_MAX)` for every caller.
- **Version info in message:** none.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Subject and body describe a KMSAN infoleak. The
“fine-grained memset” wording is the fix, not cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `fs/ntfs3/namei.c` only (`+7 / -2`)
- **Function:** `fill_name_de()`
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `e->size = cpu_to_le16(ALIGN(data_size, 8) + sizeof(struct
  NTFS_DE));` with no write of the pad.
- **After:** compute `real_size` and `aligned_size`; if they differ,
  `memset` the pad; then set `e->size` to `aligned_size`.
- **Path:** every `fill_name_de()` caller (rename still uses
  `kmalloc(PATH_MAX)`; create/link/unlink already `kzalloc`).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** uninitialized data / kernel infoleak (KMSAN)
- **Mechanism:** `hdr_insert_de()` does `memcpy(before, de, de_size)`
  with `de_size = le16_to_cpu(de->size)` including alignment pad. Pad
  bytes are slab leftovers. They land in the directory index, get
  written via `ni_write_inode` → `ntfs_write_bh`, then leak through
  `blkdev_read_iter` / `filemap_read`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: pad length is `ALIGN(x,8)-x` ∈ [0,7]; memset only
  when needed.
- Minimal; no API/locking/refcount changes.
- Regression risk very low: those bytes were garbage; NTFS index entries
  are 8-byte aligned and pad should be zero.
- Completeness: this matches the KMSAN “Bytes 404-407 of 1536” (4-byte
  pad). `ni_add_name()` still fills `ref`/`home`/`dup` after
  `fill_name_de()`, so this is not trying to zero the whole
  `ATTR_FILE_NAME`.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Alignment-in-`e->size` comes from **4342306f0f0d5** (`fs/ntfs3: Add
  file operations and implementation`, 2021-08-13; originally
  `QuadAlign(data_size)`).
- **fa3cacf544636** only switched `QuadAlign` to `ALIGN`.
- Bug present since ntfs3 was added (**v5.15-era**).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: Committed version has **no Fixes:** tag. On-list v1 used `Fixes:
ca2a04e84af7` (`ntfs: ->d_compare() must not block`), which swapped
`__getname()` for `kmalloc()` — both uninitialized. That tag is
**wrong**; the leak is as old as `fill_name_de()`. `ca2a04e84af79`
**is** an ancestor of this HEAD, but is **not** a prerequisite for the
memset.

**Step 3.3: CHECK FILE HISTORY**
Record: Recent `namei.c` work is ADS, mkdir, vfs `->create`. **No
follow-up** to this infoleak. Not patch X/Y. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Dmitry Antipov has no other recent ntfs3 commits in this
history. Konstantin Komarov is the ntfs3 maintainer and applied the
memset form.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses existing `fill_name_de`, `ALIGN`, `fname_full_size`,
`NTFS_DE`. **Applies standalone.** `ntfs_rename` can keep `kmalloc`.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **b4 dig:**
  https://patch.msgid.link/20260609123618.712961-1-dmantipov@yandex.ru
- **Series:** v1 only (`[PATCH] ntfs3: fix info-leak in ntfs_rename()`),
  2026-06-09
- **v1 diff:** `kmalloc` → `kzalloc` in `ntfs_rename` only
- **Al Viro** asked how that buffer reaches `copy_to_user_iter()`, then
  guessed a deeper metadata/bh reuse bug
- **Dmitry** explained the pad/`hdr_insert_de` path and posted the
  memset version (what landed)
- **Konstantin (2026-07-15):** “The patch is applied, thank you.” No
  NAK. No Cc: stable in-thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (**b4 dig -w**): Dmitry Antipov, Konstantin Komarov, Al Viro,
`ntfs3@lists.linux.dev`, `lvc-project@linuxtesting.org`, syzbot.
Maintainer applied it after VFS questions.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record (syzkaller):
- Title: **KMSAN: kernel-infoleak in filemap_read**
- First crash 2023-12-20; C repro; **9090** crashes; prio:high
- Uninit created at `kmalloc` in `ntfs_rename`; stored in
  `hdr_insert_de` → `indx_insert_into_root` → `ni_rename`; written via
  `ntfs_write_bh`; copied out via `blkdev_read_iter` (sample: **udevd**)
- Syzbot lists **2fa56613b25d** as the fix commit

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone. Related local infoleak: `35d1ea92c7d94` (LZNT
decompress) — different path.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — lore.kernel.org/stable returned 403. No local
evidence this was rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: KEY FUNCTIONS**
Record: `fill_name_de()`; leak sink `hdr_insert_de()`; user entry
`ntfs_rename()` → `ni_rename()` → `ni_add_name()` →
`indx_insert_entry()`.

**Step 5.2: TRACE CALLERS**
Record (`git grep`):
- `ntfs_rename()` — `rename(2)`; `kmalloc(PATH_MAX)` (**the syzbot
  path**)
- `ntfs_create_inode()` — create/mkdir/symlink; already `kzalloc`
- `ntfs_link_inode()` — `link(2)`; already `kzalloc`
- `ntfs_unlink_inode()` — unlink/rmdir; already `kzalloc`

**Step 5.3: TRACE CALLEES**
Record: `ntfs_nls_to_utf16` / `memcpy` for the name; `fname_full_size`;
then `memset` of pad.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace `rename()` on ntfs3 → directory index insert →
MFT/index write → later `read()` of the block device (udev) copies pad
to userspace. **Reachable from a normal syscall** on a mounted ntfs3
volume.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Other `fill_name_de` callers already `kzalloc`. Rename is the
remaining `kmalloc` caller; fixing `fill_name_de` covers all of them.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: **7.3.0-rc4** (`git describe`: `v7.3-rc4-27-gf0100363d8c37`)
- `fs/ntfs3/namei.c` and `fill_name_de()` exist
- Bug introduced **4342306f0f0d5** (ntfs3 add, ~5.15); **is ancestor of
  HEAD**
- Current `fill_name_de()` **already contains** this memset (`git merge-
  base --is-ancestor 2fa56613b25d0 HEAD` → yes)
- `ntfs_rename` still does `de = kmalloc(PATH_MAX, GFP_KERNEL)` — the
  memset is what stops the leak

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Hunk is local to `fill_name_de` and matches the long-standing
function shape (`QuadAlign`/`ALIGN` + `e->size`). **Clean apply** on any
tree with original `fill_name_de`. No structural prereq.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This **is** the fix (`2fa56613b25d0`). No later replacement.
LZNT infoleak is separate.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **fs/ntfs3** — **IMPORTANT** (in-tree RW NTFS since 5.15; not
core VFS, but a real production FS). Not staging.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Actively maintained (Paragon / Komarov); mix of features and
sanitizer/bounds fixes.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: WHO IS AFFECTED**
Record: **Filesystem-specific** — `CONFIG_NTFS3_FS` users who rename on
ntfs3. Trigger is rename, not an obscure ioctl.

**Step 8.2: TRIGGER CONDITIONS**
Record: `rename(2)` when the new name is inserted into a directory
index. Common. Unprivileged users with write access to an ntfs3 mount
can write slab leftovers into on-disk index entries. The syzbot read
path is `blkdev_read_iter` (typically privileged udev), but the
**confidentiality failure is writing kernel heap into the volume**.

**Step 8.3: FAILURE MODE SEVERITY**
Record: **KMSAN kernel-infoleak** of uninitialized kmalloc memory onto
disk / into a later userspace read. **Severity: HIGH** (security
infoleak; not a panic). Syzbot prio:high; C repro; thousands of crashes.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** high — stops a real, fuzzer-reproduced kernel infoleak on
  a syscall path
- **Risk:** very low — 5-line memset of 0–7 pad bytes
- **Ratio:** strongly favors taking the fix

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Syzbot KMSAN kernel-infoleak with C repro and a clear `kmalloc` →
  `hdr_insert_de` → disk → `copy_to_user` chain
- Small, obviously correct memset of alignment padding
- ntfs3 maintainer applied it after discussion with Al Viro
- Bug present since ntfs3 introduction; code exists in this tree
- No new API, no locking, no series dependencies
- Rename still uses `kmalloc`; without this, the leak remains

AGAINST:
- Al Viro first wondered if `copy_to_user` meant a deeper metadata-reuse
  bug; Dmitry’s pad explanation is what was applied, and it matches the
  first splat
- Infoleak, not a crash (still stable-worthy)
- lore.kernel.org HTTP 403; stable-list history not independently
  fetched

UNRESOLVED:
- Whether older stable series already carried a different zeroing
  approach (not this 7.3 tree)
- Whether KMSAN instances still listed as “missing” are stale vs. a
  second leak

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — pad math is local; syzbot +
   maintainer apply
2. Fixes a real bug that affects users? **PASS** — KMSAN infoleak, C
   repro, udev read of written metadata
3. Important (crash/security/corruption/deadlock)? **PASS** — kernel
   infoleak / security, HIGH
4. Small and contained? **PASS** — `fill_name_de` only, ~5 lines
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — same function exists; no
   missing helpers

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not an ID/quirk/DT/build/doc exception). It is a normal
memory-safety fix.

**Step 9.4: DECISION**
This tree has ntfs3 and the buggy `fill_name_de`/`ntfs_rename` design.
The change is a contained KMSAN infoleak fix with a documented syscall
trigger. It meets stable criteria on technical merit.

Verification:
- [Phase 1] Tags: syzbot Reported-by + Closes URL; maintainer SOB; no
  Fixes on committed form
- [Phase 2] Diff: +7/-2 in `fill_name_de`; memset of `aligned_size -
  real_size`
- [Phase 2] `hdr_insert_de` (index.c:873): `memcpy(before, de, de_size)`
  with `de_size` from `de->size`
- [Phase 3] Blame: 4342306f0f0d5 introduced QuadAlign size;
  fa3cacf544636 switched to ALIGN
- [Phase 3] `git merge-base --is-ancestor 4342306f0f0d5 HEAD` → 0 (bug
  origin in this tree)
- [Phase 3] `git merge-base --is-ancestor 2fa56613b25d0 HEAD` → 0 (this
  SHA is in HEAD)
- [Phase 3] Original v1 Fixes: ca2a04e84af79 is in HEAD but is not
  required for the memset
- [Phase 4] `b4 dig -c 2fa56613b25d0`: lore msgid
  `20260609123618.712961-1-dmantipov@yandex.ru`
- [Phase 4] `b4 dig -a`: v1 only; committed code is Dmitry’s follow-up
  memset, not v1 kzalloc
- [Phase 4] `b4 dig -w`: ntfs3 list, Komarov, Al Viro, syzbot, lvc-
  project
- [Phase 4] mbox: Viro questions; Dmitry pad diagram; Komarov “patch is
  applied”
- [Phase 4] WebFetch lore.kernel.org → 403; used b4 mbox instead
- [Phase 4] syzbot: KMSAN infoleak, C repro, uninit at ntfs_rename
  kmalloc, store at hdr_insert_de
- [Phase 5] Callers: rename (kmalloc), create/link/unlink (kzalloc)
- [Phase 5] `ni_add_name` fills ref/home/dup after fill_name_de; then
  `indx_insert_entry`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] Current namei.c lines 56–61 already have the memset
- [Phase 8] Failure mode: kernel heap bytes written into NTFS index and
  readable via blkdev read
- UNVERIFIED: stable@ mailing-list discussion (lore 403)

**YES**

 fs/ntfs3/namei.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 64cde1a856f44..f547ce82520f8 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -22,7 +22,7 @@ int fill_name_de(struct ntfs_sb_info *sbi, void *buf, const struct qstr *name,
 {
 	int err;
 	struct NTFS_DE *e = buf;
-	u16 data_size;
+	u16 data_size, real_size, aligned_size;
 	struct ATTR_FILE_NAME *fname = (struct ATTR_FILE_NAME *)(e + 1);
 
 #ifndef CONFIG_NTFS3_64BIT_CLUSTER
@@ -53,7 +53,12 @@ int fill_name_de(struct ntfs_sb_info *sbi, void *buf, const struct qstr *name,
 	fname->type = FILE_NAME_POSIX;
 	data_size = fname_full_size(fname);
 
-	e->size = cpu_to_le16(ALIGN(data_size, 8) + sizeof(struct NTFS_DE));
+	real_size = data_size + sizeof(struct NTFS_DE);
+	aligned_size = ALIGN(data_size, 8) + sizeof(struct NTFS_DE);
+	if (aligned_size > real_size)
+		memset((char *)buf + real_size, 0, aligned_size - real_size);
+
+	e->size = cpu_to_le16(aligned_size);
 	e->key_size = cpu_to_le16(data_size);
 	e->flags = 0;
 	e->res = 0;
-- 
2.53.0

