Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D4957EDBF;
	Mon, 19 Oct 2026 13:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418379; cv=none; b=m0OqvVlSKMrKtF7ckYgIqbNrY0AuUiydxoGfwZ4fk8kwGmxN9QdjWKKl+IAbogWdjlDnQ5hcVHseia1Rs0XQDFTPjkTq9ZVQeHN8gmEkzQUys2MjhIKAozBfn//4r/rzeZFGq9JNNEb6bPOWmiohvnQy0gDspTB4eZpsiLN9QpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418379; c=relaxed/simple;
	bh=LKgIQ48AmDvXyXo9YRM5zua3D1bBio9qsOb4K6rBQ/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GVX8Osv4PapY7mjmRlmiZWeuGh6h34FNyZgRhUPGHHJTT4lQqYGI7iYLWPc9wYvXnTYU/QDryuUPZKB7PsWrCVmy7rsRDpMMCKEkQdVq/oBgUOWIKGXc3oFpMdWgHp4lbYJLo1TT4MOzb9OMd5ImGv8vXRQ7tsnxhq/VRV8Obp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RlfsetLK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RlfsetLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8E71F000C7;
	Mon, 19 Oct 2026 13:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418376;
	bh=2aiXacUqa3HJ0eFYiF3nQ9dTMRrcDK2sDMLYdQpdihU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlfsetLKZER58pXHKKzx4KFq7A52UIP+DnfWUdz0shG3T6Fw+v/u/asSIc1v/1iRP
	 zt//Wyekns3gTICBnPhReyPhcGc6YtATjZqL88nvUfeFStNQzGCfhshiHwXpjM/DCt
	 zFj1v2cSS0Ks9c/9CDc1uaatfkn6GAlFiGan/KZ98LYoE4MWYPiARqvimjGI3bDdzG
	 uVAuL7gT2Q4vDqHKxjZ+ERtmfxPBPhFHc56cSlYQGlO5BtMQuRhLr8i7wESanfMR3j
	 r8D9eASEfKsNzjAt78mfezCXN8I5//5AgNzaIPB7UBY+SbQhd1t8kLg2RXO2hfezSo
	 gGDBukBXt5jlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kyle Zeng <kylebot@openai.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] fs/ntfs3: reserve NUL byte when converting UTF-16 names
Date: Mon, 19 Oct 2026 09:48:16 -0400
Message-ID: <20261019135441.1420968-205-sashal@kernel.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 4871fedaabbfd574ac0a075b80e75afdd532e11e ]

ntfs_utf16_to_nls() appends a trailing NUL to the converted output,
but it passes the caller-supplied size directly to the conversion loop.
For the UTF-8 path, utf16s_to_utf8s() can legitimately fill all
buf_len bytes and return buf_len, after which ntfs_utf16_to_nls()
writes the terminator one byte past the end of the destination buffer.

The same contract problem exists for the NLS path when a converted
character consumes the last available byte.

Reserve one byte for the terminator before doing either conversion.
The function continues to return the number of converted bytes,
excluding the NUL terminator.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (`7.3.0-rc4`). `ntfs_utf16_to_nls()` is
present here, and the bug is a real one-byte heap overflow on long
reparse/symlink conversion. Below is the full checklist.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[fs/ntfs3] [reserve] reserve one NUL byte when converting
UTF-16 names**
- Subsystem: `fs/ntfs3`
- Verb: “reserve” — a missing-safety-check fix (keep a terminator byte)
- Intent: stop `ntfs_utf16_to_nls()` from writing `'\0'` one byte past
  the caller buffer

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Assisted-by: Codex:gpt-5.5` — LLM-assisted; still needs code review
  (done below)
- `Signed-off-by: Kyle Zeng <kylebot@openai.com>` — author
- `Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-
  software.com>` — ntfs3 maintainer
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable` (absence is expected for this review)
- Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  ...]` — none on this commit

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `ntfs_utf16_to_nls()` always stores a trailing NUL, but
  passes the full caller `buf_len` into conversion.
- **UTF-8 path:** `utf16s_to_utf8s()` may write `buf_len` bytes and
  return `buf_len`; then `buf[ret] = '\0'` is one past the end.
- **NLS path:** a converted character can consume the last byte; `*op =
  '\0'` is then one past the end.
- **Fix:** reject `buf_len <= 0`; do `buf_len -= 1` before conversion;
  still return converted length **excluding** NUL.
- **Symptom:** 1-byte heap buffer overflow (memory corruption / KASAN
  slab-out-of-bounds write).
- **Versions in the message:** none.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. It is an explicit off-by-one / OOB write fix, not
cleanup or a new feature.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `fs/ntfs3/dir.c` — **+5 / −0**
- Function: `ntfs_utf16_to_nls()`
- Scope: single-function, surgical

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record (pre-fix from `4871fedaabbfd^`):
```
ret = utf16s_to_utf8s(..., buf, buf_len);
buf[ret] = '\0';
return ret;
```
and NLS loop using full `buf_len`, then `*op = '\0'`.

After: if `buf_len <= 0` → `-EINVAL`; else `buf_len -= 1`; conversion
and NUL write use the reduced size. Return value is still converted
bytes without the terminator.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Memory safety — 1-byte out-of-bounds write.**

Verified `utf16s_to_utf8s()` in `fs/nls/nls_base.c`: it loops `while
(inlen > 0 && maxout > 0)` and for ASCII does `*op++ = ...; maxout--;`.
It can write exactly `maxout` bytes and return that count. `buf[ret] =
'\0'` is then OOB.

NLS: `uni2char()` is called only when `buf_len >= NLS_MAX_CHARSET_SIZE`
(6). If `charlen == buf_len`, remaining space becomes 0 and `*op = '\0'`
is OOB. Same class of contract bug.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Correct and minimal: reserve the byte the function already uses for
  NUL.
- Return contract unchanged (length without NUL) — matches
  `ntfs_dir_emit()`, `ntfs_readlink_hlp()`, ADS listing.
- Regression risk: **low**. Worst case is truncating one extra byte on a
  max-length conversion instead of overflowing.
- `buf_len <= 0` → `-EINVAL` is defensive; current callers pass
  `PATH_MAX` or `PAGE_SIZE`.
- No API/ABI/feature change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Unconditional `buf[ret] = '\0'` / `*op = '\0'` from
  **`4342306f0f0d5`** (“fs/ntfs3: Add file operations and
  implementation”, 2021-08-13).
- Contained in **v5.15-rc1**.
- UTF-8 call adjusted in `2c69078851b3d` (“Rework ntfs_utf16_to_nls”,
  2021-10) but still passed full `buf_len`.
- Bug is old (since ntfs3 landed), not last-month code.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Buggy code is the original function body from
5.15, present in this tree’s ntfs3.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Same-class NUL bug: `a6cd43fe9b083` (“terminate the cached volume
  label after UTF-8 conversion”) — `utf16s_to_utf8s()` does not NUL-
  terminate; filling the buffer overruns `%s`.
- Related bounds: `aa1bdbb39f49c` (OOB **read** of names in
  `ntfs_dir_emit`) — different bug.
- Later `be310476e8868` (ADS) adds a third caller; not a prerequisite.
- Standalone 5-line fix, not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Only this ntfs3 commit from Kyle Zeng. Applied by **Konstantin
Komarov** (ntfs3 maintainer) in the `ntfs3_for_7.3` pull
(`dc83d18cdd904`).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `utf16s_to_utf8s()` / NLS loop. Applies on
top of the long-standing function.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 4871fedaabbfd` →
  https://patch.msgid.link/20260611213331.16763-1-kylebot@openai.com
- Only **v1** (`b4 dig -a`); that version was applied.
- Lore HTTP fetch returned 403; full thread saved via `b4 dig -m
  /tmp/ntfs3-nul.mbox`.
- Maintainer (23 Jul 2026): “Your patch was applied, thank you.” **No
  NAK.**
- XIAO WU replied about a **different** remount/`sbi->options` UAF
  (getdents vs remount). That is not this overflow and is not caused by
  this patch. The nls load is unchanged.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To `ntfs3@lists.linux.dev`; Cc maintainer
Konstantin Komarov, LKML, `outbounddisclosures@openai.com`. Maintainer
applied it. No extra `Reviewed-by`.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla/`Reported-by`. Bug is from code inspection.
Reachability is from callers (Phase 5), not a public crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone v1. Not part of a multi-patch series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search via WebFetch → 403. No stable-list
discussion in the saved mbox. **UNVERIFIED:** whether AUTOSEL already
queued it for some -stable series (irrelevant to this tree’s technical
decision).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `ntfs_utf16_to_nls()` only.

**Step 5.2: TRACE CALLERS**
Record (this tree):
1. **`ntfs_dir_emit()`** (`fs/ntfs3/dir.c`) — readdir/`getdents`. Buffer
   `kmalloc(PATH_MAX)` (`PATH_MAX=4096`). `static_assert(NTFS_NAME_LEN *
   4 < PATH_MAX)` (`NTFS_NAME_LEN=255` → max 1020 UTF-8 bytes). **This
   caller cannot fill PATH_MAX**, so the NUL OOB does not fire on normal
   filenames.
2. **`ntfs_readlink_hlp()` / `ntfs_get_link()`** (`fs/ntfs3/inode.c`) —
   `readlink`/`get_link`. Buffer `kmalloc(PAGE_SIZE)` passed as
   `buflen`. Reparse payload allowed up to `sbi->reparse.max_size`
   (comment **16K**, from `$AttrDef`). A UTF-16 path of ~4096 ASCII
   units fills the page; then `buf[ret]='\0'` and the extra
   `buffer[err]=0` in `ntfs_readlink_hlp()` are **one past the heap
   object**.
3. **ADS listing in `frecord.c`** — `PAGE_SIZE` and `name_len` is `u8`
   (max 255). Same as filenames; **does not fill PAGE_SIZE**. Added
   after this fix; not required for the bug.

**Step 5.3: TRACE CALLEES**
Record: `utf16s_to_utf8s()` / `utf32_to_utf8()`; NLS `uni2char()`.
Conversion, then a terminator store. No new locks/allocs.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace **`readlink(2)`** on an NTFS symlink/junction/reparse
target. Unprivileged if the volume is mounted. Also reachable from a
**crafted NTFS image** (USB, etc.). Readdir is a common path but, given
PATH_MAX vs 255-char names, not the overflow trigger.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Volume label (`a6cd43fe9b083`) is the same `utf16s_to_utf8s()` +
missing terminator class. Confirms the contract bug is real in ntfs3.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD` → **`v7.3-rc4-27-gf0100363d8c37`**
- `make kernelversion` / Makefile → **7.3.0-rc4**
- `ntfs_utf16_to_nls()` exists in `fs/ntfs3/dir.c`; callers exist.
- Bug introduced **v5.15**, well before this branch.
- `git merge-base --is-ancestor 4871fedaabbfd HEAD` → commit is already
  an ancestor (current file already has `buf_len -= 1`). That is **not**
  used as “already selected for stable.”
- Verdict is: this tree’s ntfs3 **has** the function and needed the fix.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean 5-line insert after `static_assert`. Surrounding function
matches the pre-fix form from 5.15-era ntfs3. **Expected apply: clean**
on a tree that still has the unfixed function.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No other commit fixes this terminator OOB in
`ntfs_utf16_to_nls()`. Label NUL fix is a sibling pattern, not a
substitute.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **fs/ntfs3** — **IMPORTANT** (in-tree filesystem, not staging;
`CONFIG_NTFS3_FS`). Not core VFS/mm, but used on removable NTFS volumes.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (7.3 pull has many bounds/UAF/leak fixes). This
particular helper has been stable since 5.15.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Filesystem-specific / config-specific** — `CONFIG_NTFS3_FS`
users, especially `readlink` on reparse/symlink. Default charset is
UTF-8 (`nls` NULL), which is the clearer overflow path.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Trigger: convert a UTF-16 string whose UTF-8 (or NLS) form uses the
  **entire** destination, then write NUL.
- **Common readdir:** unlikely (255-char names vs PATH_MAX).
- **readlink of a long reparse target:** realistic on crafted or unusual
  NTFS images; unprivileged if the fs is mounted.
- Not a race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **1-byte heap overflow** past `kmalloc(PAGE_SIZE)` in
`ntfs_get_link()`. **Severity: HIGH** (memory corruption; crash and
possible security impact). Not a panic on every boot, but it is a real
memory-safety bug.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit: HIGH** — closes a heap OOB on ntfs3 `readlink`, cheap and
  correct.
- **Risk: VERY LOW** — 5 lines, local, return contract unchanged, slight
  extra truncation vs overflow.
- **Ratio: strongly favors applying.**

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real off-by-one write: conversion may fill `buf_len`, then a NUL is
  stored at `buf[buf_len]`.
- Confirmed in `utf16s_to_utf8s()`; NLS path has the same contract hole.
- Reachable from `ntfs_get_link()` (`readlink`, `PAGE_SIZE`, reparse up
  to ~16K).
- Small, obviously correct; return value still excludes NUL.
- Maintainer applied v1; no NAK of the overflow fix.
- Same `utf16s_to_utf8s()` terminator class already fixed for volume
  labels.
- Present in this tree’s ntfs3 since 5.15; no missing helpers.

AGAINST:
- No syzbot/`Reported-by`/reproducer in the message.
- Readdir/`PATH_MAX` cannot hit it for legal 255-char names.
- LLM-assisted; one list reply was about an unrelated remount UAF.
- No `Fixes:`/`Cc: stable` (not a negative for this review).

UNRESOLVED:
- Stable-list AUTOSEL status (lore/stable HTTP 403).
- Exact on-disk `$AttrDef` `$REPARSE_POINT` max on every volume (code
  comments 16K; crafted images can still supply a long path).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — contract is clear;
   maintainer merged it. No extra Tested-by, but the code change is
   verifiable.
2. Fixes a real bug that affects users? **PASS** — heap OOB on
   `readlink` of a long NTFS reparse target.
3. Important (crash/security/corruption/deadlock)? **PASS** — HIGH:
   1-byte heap overflow / memory corruption.
4. Small and contained? **PASS** — +5 lines, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — function and callers exist;
   patch is a trivial insert.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not an ID/quirk/DT/build/docs exception). It is a normal
memory-safety fix.

**Step 9.4: MAKE YOUR DECISION**
This tree is **7.3.0-rc4** with in-tree ntfs3. The helper has written a
NUL past a full conversion buffer since v5.15. On this tree that is hit
by `ntfs_get_link()` with a `PAGE_SIZE` buffer, not by readdir’s
oversized `PATH_MAX` name buffer. The fix is five lines, preserves the
return contract, and is the right way to implement “convert then
terminate.” Benefit vs risk favors applying it here.

### What it solves for this tree
`ntfs_utf16_to_nls()` treated `buf_len` as conversion space **and**
still stored a terminator. `utf16s_to_utf8s()` is allowed to use every
byte. `ntfs_get_link()` then NUL-terminates again at `buffer[err]`. A
long symlink/junction on a mounted NTFS image can corrupt one heap byte.
That is a real, important bug, not a style change.

### Stable rules
Obviously correct, small, no new API, no extra dependencies. Meets the
documented stable criteria for this checkout.

### Risk vs benefit
Very low regression risk; high benefit on a memory-safety path used by
`readlink`.

### Concerns
- Filename readdir is not the realistic trigger (`NTFS_NAME_LEN * 4 <
  PATH_MAX`).
- List discussion mixed in an unrelated remount UAF; this patch does not
  fix or worsen that.
- No fuzzer report; still verified from the conversion contract and
  callers in this tree.

Verification:
- [Phase 1] Subject/tags: overflow + reserve NUL; SOB Kyle Zeng +
  Konstantin Komarov; Assisted-by Codex; no Fixes/Reported-by/Cc stable
- [Phase 2] Diff: +5 in `ntfs_utf16_to_nls()`: `buf_len <= 0` →
  `-EINVAL`, then `buf_len -= 1`
- [Phase 2] `utf16s_to_utf8s()` (`fs/nls/nls_base.c:189-242`) can return
  `maxout`; pre-fix `buf[ret] = '\0'` is OOB
- [Phase 3] Blame: `4342306f0f0d5` (v5.15-rc1); rework `2c69078851b3d`
  did not reserve NUL
- [Phase 3] `git merge-base --is-ancestor 4871fedaabbfd HEAD` — commit
  is in this history; not used as circular “already selected”
- [Phase 3] No prerequisites; later ADS caller is independent
- [Phase 4] `b4 dig -c 4871fedaabbfd` →
  patch.msgid.link/20260611213331.16763-1-kylebot@openai.com; v1 only;
  maintainer applied; XIAO WU UAF is a different bug
- [Phase 4] WebFetch lore/stable: 403; thread recovered via `b4 dig -m`
- [Phase 5] Callers: `ntfs_dir_emit` (PATH_MAX, cannot fill),
  `ntfs_readlink_hlp`/`ntfs_get_link` (PAGE_SIZE, can fill), ADS
  `PAGE_SIZE` (255-char names)
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37;
  `kernelversion` 7.3.0-rc4; ntfs3 and callers present
- [Phase 7] fs/ntfs3, in-tree, not staging
- [Phase 8] Failure: 1-byte heap write past `kmalloc(PAGE_SIZE)` on
  `readlink`; HIGH
- UNVERIFIED: AUTOSEL/stable-list queue status (HTTP 403)

**YES**

 fs/ntfs3/dir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 6e1d2ad8c12ea..6d588efaf9fdf 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -24,6 +24,11 @@ int ntfs_utf16_to_nls(struct ntfs_sb_info *sbi, const __le16 *name, u32 len,
 
 	static_assert(sizeof(wchar_t) == sizeof(__le16));
 
+	if (buf_len <= 0)
+		return -EINVAL;
+
+	buf_len -= 1;
+
 	if (!nls) {
 		/* UTF-16 -> UTF-8 */
 		ret = utf16s_to_utf8s((wchar_t *)name, len, UTF16_LITTLE_ENDIAN,
-- 
2.53.0

