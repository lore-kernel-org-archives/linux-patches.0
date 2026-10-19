Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518AA5649D1;
	Mon, 19 Oct 2026 13:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418255; cv=none; b=nhNP4Jjr3KYNOdRtg5Xvbn/nZ6vTZlZGEOYIJTqsVsMXQqXU/W2JGLI7lcIk+CSc8/Nh4vM+zOTqMO0YuZKYjBRDLZ07DZxNfKXvi91jHAd7MEtCIcFlqXc2Evvu+tFF8LefrjFHB5EQTZUjzuwwtkUWl0xEwarpYW1pioF41Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418255; c=relaxed/simple;
	bh=g4PTO7lnP6jmMLinerXH5KGJQ1+uOwXMR5HVPq3zdJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ca3YAQAn/agdbJdjuuVAcP5kbgas1VJIcYngxVVUHfVtJe0Q5oKaqgPT4d5spQa8pDK+A/6F3QBMkn4LW/vEv8gziiFs5+WNpFeP76S8TyuPAZf9eu2OgjJAuVv/yhl6hnOjuARu35FH922/7xniBaLspa0efExYwEVKIPzO8UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O6kVQQSn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O6kVQQSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5331F000C5;
	Mon, 19 Oct 2026 13:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418251;
	bh=i1Qy+90BenJPcLfIAdefa7A1eHguDbzBBjH+pknHFrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6kVQQSnnJ6TXx+oBnL+F+9bkLWT/rY2LPBGa/Aeh4CoLW5cl5NJuSjm5Mc5ywJN2
	 YgPE9h8gpsTqwjK3Tl+Kd3FURww9RHtkPoTMuE/3A1SKxBR+zasVB97O7VnnsAoEUW
	 92YoUIVjeZ7qPKDdGkJwMO/or3d0T53kzb+cmEB73QY6tL/ocGlMpkDFzO3Wg3Qb6E
	 fZZd+bnvrTxQ9gPacvRkiNu+/CHrqZzxrwUvEI/H1rYBweC05Iak50L2/3t0rhnPio
	 FT50QfgAOb8iHcVEU6DuP2QuvC4Q/U/v47VtRrx4CeaQp453/WgyHd++7oTKr/1dHE
	 aGXDOu285dzDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Yury Norov <ynorov@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	yury.norov@gmail.com,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] bitops: make the *_bit_le functions use unsigned long
Date: Mon, 19 Oct 2026 09:46:51 -0400
Message-ID: <20261019135441.1420968-120-sashal@kernel.org>
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

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 1c61b0a6e5c472737619f74f79c390363ee258df ]

The *_bit_le functions use a signed integer for the bit number.
However, the *_bit functions can use an unsigned long. This causes
problems if there is a large bitmap and a bit number > 0x80000000 is
passed in. Since that is a negative int, it will get sign extended to a
long when getting passed to the *_bit function, turning it into a huge
bit number. This usually ends up with the memory address wrapping around
and the function accessing memory before the start of the bitmap.

Avoid this by making the *_bit_le functions take an unsigned long.

This can be triggered by faking an almost 4TB dm-mirror device, which
uses bitmaps to track the mirror regions:

$ dmsetup create bigzero --table '0 8589934590 zero'
$ dmsetup create mymirror --table '0 8589934590 mirror core 2 2 nosync 2 /dev/mapper/bigzero 0 /dev/mapper/bigzero 0'

This will access memory before the start of the sync_bits bitmap, and
likely hit the guard page of the previously allocated clean_bits bitmap,
causing a kernel panic with the old code.

I looked and didn't see any crazy code using the signed int to
intentionally try and access bits before some address within the bitmap.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[bitops] [make] make the *_bit_le helpers take unsigned long
instead of signed int`

Subsystem is generic bitops. The verb is “make”, but the body is a sign-
extension / out-of-bounds panic fix, not an API feature.

**Step 1.2: Tags**
Record:
- Signed-off-by: Benjamin Marzinski \<bmarzins@redhat.com\> (author)
- Signed-off-by: Yury Norov \<ynorov@nvidia.com\> (bitmap maintainer,
  applied the patch)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable (absence of Fixes:/Cc: stable is expected here)

**Step 1.3: Body**
Record:
- Bug: `*_bit_le()` takes `int nr` while `*_bit()` takes a wider
  unsigned/long index. A bit number \> `0x80000000` becomes a negative
  `int`, then sign-extends to a huge `long`.
- Symptom: address wrap, access *before* the bitmap, kernel panic (often
  on the guard page of a prior vmalloc).
- Reproducer: ~4TB `dm-zero` + `dm-mirror` with region size 2 (`dmsetup
  create mymirror --table '0 8589934590 mirror core 2 2 nosync ...'`),
  hitting `sync_bits` before the start of the bitmap.
- Root cause: signed `int` bit index vs unsigned/long bitops; author
  found no callers that intentionally used a negative index.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. It is a type-signature change whose purpose is to
stop OOB access and a panic. Not cleanup or a new feature.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `include/asm-generic/bitops/le.h` — 9 insertions, 9 deletions
  (parameter type only)
- Functions: `test_bit_le`, `set_bit_le`, `clear_bit_le`,
  `__set_bit_le`, `__clear_bit_le`, `test_and_set_bit_le`,
  `test_and_clear_bit_le`, `__test_and_set_bit_le`,
  `__test_and_clear_bit_le`
- Scope: single-file surgical type fix

**Step 2.2: Flow change**
Record: Before, each helper took `int nr` and passed `nr ^
BITOP_LE_SWIZZLE` into `test_bit`/`set_bit`/etc. After, `nr` is
`unsigned long`. Bodies are unchanged. Normal path only; no new control
flow.

**Step 2.3: Bug mechanism**
Record: `[Type / integer conversion] [Memory safety / OOB]`

On 64-bit, `unsigned int`/`unsigned long` bit `0x80000000` converted to
`int` is negative, then sign-extends into `set_bit(long nr)` /
`_test_bit(unsigned long nr)` as `0xffffffff80000000`. `BIT_WORD(nr)`
then yields a pointer *before* `addr` (wrap). Confirmed in
`generic___set_bit()`:

```28:33:include/asm-generic/bitops/generic-non-atomic.h
generic___set_bit(unsigned long nr, volatile unsigned long *addr)
{
        unsigned long mask = BIT_MASK(nr);
        unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
```

**Step 2.4: Fix quality**
Record: Obviously correct and minimal. Widening `int` → `unsigned long`
matches `find_*_bit_le()` (already `unsigned long` in
`include/linux/find.h`) and the generic bitops. Negative callers would
still sign-extend into `unsigned long`; the author grepped and found
none. Regression risk is very low: inline helpers, no ABI, no locking,
no new behavior for in-range bits.

Note: atomic `set_bit()` in this tree takes `long nr` (signed), not
`unsigned long`. That does not undo the fix: values in `2^31 .. 2^32-1`
fit in 64-bit `long` after zero-extension. The bug was 32-bit `int` →
64-bit `long` sign extension.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record: Signed `int nr` dates to `a56560b3b2332` (“asm-generic: change
little-endian bitops to take any pointer types”, 2011-03-23, contained
in v2.6.39-rc1). The type was stable for ~15 years. Commit
`1c61b0a6e5c47` (2026-07-06, applied 2026-07-22) is the change under
review.

**Step 3.2: Fixes: tag**
Record: None. Buggy signature is ancient generic bitops, not a recent
regression.

**Step 3.3: File history**
Record: Recent `le.h` work is old (`6b8ecb84f8f64` moved find_*_le to
find.h in 2021). No later commits on this file after `1c61b0a6e5c47`.
Standalone, not patch N/M.

**Step 3.4: Author**
Record: Benjamin Marzinski is a device-mapper contributor (many
`drivers/md/` commits), not the bitmap maintainer. Yury Norov (BITMAP
API maintainer) applied it. Related nearby dm-log work: `c20e36b7631d8`
(region_count overflow, similar ~4TB mirror reproducer) and
`9743132a41f4d` (bitset_size overflow on 32-bit). Those are separate
bugs; this patch does not depend on them.

**Step 3.5: Prerequisites**
Record: None. Only `include/asm-generic/bitops/le.h`. No new helpers.
`git merge-base --is-ancestor 1c61b0a6e5c47 HEAD` succeeded (commit is
already in this checkout).

---

## Phase 4: Mailing list

**Step 4.1: Original discussion**
Record:
- v1: https://lore.kernel.org/linux-
  arch/20260702194307.1805533-1-bmarzins@redhat.com/
- v2 (committed): https://lore.kernel.org/linux-
  arch/20260706202324.1949190-1-bmarzins@redhat.com/
- v1→v2: commit message only (wrong “unsigned int” wording; missing
  reproducer commands). Code unchanged.
- Yury Norov: “Taking the patch in bitmap-for-next.” Asked for a
  reproducer and whether this is production.
- Benjamin: explicit `dmsetup` panic reproducer; LVM default region size
  is 4096 sectors, so default LVM would need ~4PB devices; “I doubt that
  anyone has hit this on a production system,” but “This will crash the
  machine without the fix.”
- No NAKs.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Yury Norov, Arnd Bergmann, Rasmus Villemoes, linux-arch, linux-
kernel. Bitmap maintainer was To: and applied the patch.

**Step 4.3: Bug report**
Record: No syzbot/bugzilla. Author-discovered with a concrete panic
reproducer. Not a theoretical-only issue.

**Step 4.4: Series**
Record: Standalone v1/v2. Not part of a multi-patch series. Related dm-
log overflow fixes are independent.

**Step 4.5: Stable list**
Record: UNVERIFIED. lore.kernel.org returned 403; gnuweeb `/stable/`
search 404. linux-arch thread had no Cc: stable and no stable-list
discussion.

---

## Phase 5: Call graph / impact

**Step 5.1: Functions**
Record: The nine `*_bit_le` inlines listed in 2.1.

**Step 5.2: Callers**
Record (verified via `git grep`):
- `drivers/md/dm-log.c` — `log_test_bit`/`log_set_bit`/`log_clear_bit`
  (`unsigned int bit`); this is the documented panic path
- `drivers/md/md-bitmap.c` — RAID bitmaps
- `virt/kvm/kvm_main.c` — `set_bit_le(rel_gfn, memslot->dirty_bitmap)`
  with `unsigned long rel_gfn`
- Filesystems: ext4/ext2/f2fs/ocfs2/exfat/ntfs3/minix (on-disk LE
  bitmaps)
- Also: RDS congestion, NVDIMM labels, some net drivers

dm-log and KVM are the large-index paths. Filesystem group bitmaps are
typically far below 2^31 bits.

**Step 5.3: Callees**
Record:
`test_bit`/`set_bit`/`clear_bit`/`__set_bit`/`__clear_bit`/`test_and_*`
plus `BITOP_LE_SWIZZLE` (0 on LE; low-bit swap on BE).

**Step 5.4: Reachability**
Record: Yes. Privileged `dmsetup` of a large mirror (author’s
reproducer) panics. KVM dirty logging with `rel_gfn >= 2^31` (memslot ≳
8TiB at 4K pages) would hit the same conversion. Unprivileged users
cannot run `dmsetup`; a VM tenant does not set host memslot size.

**Step 5.5: Similar patterns**
Record: `find_*_bit_le` already use `unsigned long`. This aligns the
set/test/clear LE helpers. No other `le.h` copies; arches include the
generic header (x86, arm64, powerpc, s390, …).

---

## Phase 6: This checkout

**Step 6.1: Does the buggy code exist here?**
Record:
- Tree: `v7.3-rc4-27-gf0100363d8c37`, `VERSION=7 PATCHLEVEL=3 SUBLEVEL=0
  EXTRAVERSION=-rc4` (7.3.0-rc4)
- Live `le.h` already has `unsigned long nr` (this commit is an
  ancestor, merged via `bitmap-for-7.3`)
- Pre-fix `int nr` existed in this lineage from v2.6.39 through the
  parent of `1c61b0a6e5c47`
- Helpers still exist; the bug class is in this codebase’s history, not
  a post-branch feature

**Step 6.2: Backport difficulty**
Record: Clean apply to any tree whose `le.h` still has `int nr`. Same
9-line signature change since 2011. No conflicting local edits.

**Step 6.3: Related fixes already here**
Record: This exact fix is already in HEAD. Independent dm-log overflow
fixes (`c20e36b7631d8`, `9743132a41f4d`) do not replace it: they cap
`region_count` / bitset size; they do not stop sign extension for bits
in `2^31 .. UINT_MAX-1` (the 8589934590 / region-size-2 case is
`region_count = 4294967295`).

---

## Phase 7: Subsystem context

**Step 7.1**
Record: `[bitops / asm-generic] [CORE]` — used by filesystems, DM, KVM,
networking.

**Step 7.2**
Record: Bitmap API is actively maintained (bitmap-for-7.3 pull). `le.h`
itself is mature; this is a long-standing type bug, not churn from a
rewrite.

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Anyone using `*_bit_le` on a bitmap with index \> `INT_MAX`.
Concrete: large dm-mirror with tiny region size; theoretically huge KVM
dirty bitmaps / large md bitmaps. Not universal.

**Step 8.2: Trigger**
Record: Not every boot. Needs a bitmap \> 256MiB (2^31 bits). Author’s
case: ~4TB device, region size 2 sectors. LVM default 4096-sector
regions would need ~4PB. Root/`dmsetup` required. Timing-independent;
deterministic OOB.

**Step 8.3: Failure mode**
Record: `[OOB before bitmap → kernel panic] [Severity: CRITICAL if
triggered, LOW likelihood in default configs]`

**Step 8.4: Risk-benefit**
Record:
- Benefit: medium — real panic with a reproducer; production default
  configs unlikely; still a memory-safety bug in core helpers
- Risk: very low — 9-line type widen, no logic/locking/API userspace
  change
- Ratio: favorable. Cheap, correct panic fix in generic bitops

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Reproducible kernel panic from OOB before a vmalloc bitmap
- Mechanism is standard 32→64 sign extension; the diff matches it
- 9 lines, one header, no new APIs
- Bitmap maintainer took it; v2 only fixed the commit message
- Matches `find_*_bit_le` (`unsigned long`)
- Applies to this tree’s `le.h` with no prerequisites
- dm-log, md-bitmap, and KVM dirty logging are real callers of large
  indexes

Against:
- Author doubts production hits with LVM defaults
- Needs a huge device and a tiny region size (or an enormous KVM slot)
- No syzbot, no Cc: stable, no Fixes:
- This 7.3-rc4 checkout already contains the commit

Unresolved:
- Stable mailing list (HTTP 403/404)
- Whether any caller relied on negative `int` indexes (author searched;
  not independently exhaustively proven)

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — type-only; author reproduced
   panic; maintainer applied it
2. Real bug that affects users? **PASS** — panic on a documented dm-
   mirror table; also reachable from other large LE bitmaps
3. Important (crash/security/corruption/deadlock)? **PASS** — kernel
   panic / OOB. Likelihood is low; severity if hit is high
4. Small and contained? **PASS** — 9 lines, one file
5. No new features/APIs? **PASS** — same helpers, wider index type only
6. Can apply to this tree? **PASS** — file and functions exist;
   identical hunk. (Already applied here; still a clean backport to any
   tree with `int nr`.)

**Step 9.3: Exceptions**
Record: Not a device-ID/quirk/DT/docs exception. Ordinary memory-safety
panic fix.

**Step 9.4: Decision**

This is a small, obviously correct fix for a real panic: signed `int`
bit indexes sign-extend into the generic bitops and walk off the front
of the bitmap. The helpers live in this tree, there are no missing
prerequisites, and the change does not add features. Rare default-config
exposure does not outweigh a zero-logic-change panic fix in core bitops.

The commit is already in this 7.3-rc4 history; that is not used as a
reason to reject it. Technical merit supports taking it on this lineage.

---

## What the commit solves for stable users

On 64-bit, `*_bit_le(int nr)` turns bit numbers ≥ 2^31 into a negative
`int`, which becomes a huge `long` in `test_bit`/`set_bit`. Address
arithmetic wraps and the kernel reads/writes *before* the bitmap,
typically panicking (author: dm-mirror `sync_bits` vs `clean_bits` guard
page).

That matters for large dm-mirror logs (tiny region size on multi-TB
devices) and any other LE bitmap with a high index (e.g. KVM
dirty_bitmap with `unsigned long rel_gfn`). The fix is only changing
`int` to `unsigned long` on nine inlines.

## Risk vs benefit

Benefit is preventing a confirmed panic. Risk is negligible: no control-
flow, locking, or userspace ABI change; widening is source-compatible
for non-negative callers. Worst case for a negative caller is the old
sign-extension behavior, and none were found.

## Concerns

- Trigger is uncommon with LVM’s 4096-sector default.
- No Fixes:/Cc: stable (not a negative by itself).
- Stable-list discussion could not be fetched (403/404).
- Independent dm-log overflow patches are *not* substitutes for this
  type fix.

## Verification
- [Phase 1] Parsed tags: only author + Yury Norov SOBs; no
  Fixes:/Reported-by:/Cc: stable
- [Phase 2] Diff: 9 `int nr` → `unsigned long nr` in `include/asm-
  generic/bitops/le.h`; bodies unchanged
- [Phase 2] `generic___set_bit` uses `BIT_WORD(nr)` pointer math — huge
  nr wraps before `addr`
- [Phase 2] `set_bit` takes `long nr`; `_test_bit`/`___set_bit` take
  `unsigned long nr`
- [Phase 3] `git describe HEAD` / Makefile: 7.3.0-rc4
  (`v7.3-rc4-27-gf0100363d8c37`)
- [Phase 3] `git merge-base --is-ancestor 1c61b0a6e5c47 HEAD`: yes
  (already in this tree)
- [Phase 3] blame: `int nr` from `a56560b3b2332` (v2.6.39-rc1); fix is
  `1c61b0a6e5c47`
- [Phase 3] `git show 1c61b0a6e5c47^:include/asm-generic/bitops/le.h`:
  confirmed `int nr`
- [Phase 3] No follow-up commits on `le.h` after this one
- [Phase 4] `b4 dig -c 1c61b0a6e5c47`: v1 then v2; v2 is what was
  committed
- [Phase 4] `b4 dig -a/-w`: linux-arch; Yury, Arnd, Rasmus CC’d
- [Phase 4] Yury: taking into bitmap-for-next; asked about 256MB bitmaps
  / production
- [Phase 4] Author: machine crashes without the fix; production with LVM
  defaults unlikely
- [Phase 5] Callers: dm-log, md-bitmap, kvm `mark_page_dirty_in_slot`,
  ext4 macros, others
- [Phase 5] dm-log `log_*_bit(..., unsigned int bit)` — values ≥
  0x80000000 hit the old conversion
- [Phase 5] Reproducer math: 8589934590 sectors / region 2 →
  `region_count = 4294967295` (UINT_MAX)
- [Phase 6] Current tree already has `unsigned long nr`; no other `le.h`
  copies
- [Phase 6] Arches include `asm-generic/bitops/le.h` (x86, arm64, etc.)
- [Phase 8] Failure mode: OOB → panic; trigger needs large bitmap
- UNVERIFIED: stable@ discussion (lore 403, gnuweeb stable search 404)
- UNVERIFIED: exhaustive proof no caller passed negative `int` on
  purpose (author stated they looked)

**YES**

 include/asm-generic/bitops/le.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index d51beff603755..e3b0da9a25f1b 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -16,47 +16,47 @@
 #endif
 
 
-static inline int test_bit_le(int nr, const void *addr)
+static inline int test_bit_le(unsigned long nr, const void *addr)
 {
 	return test_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline void set_bit_le(int nr, void *addr)
+static inline void set_bit_le(unsigned long nr, void *addr)
 {
 	set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline void clear_bit_le(int nr, void *addr)
+static inline void clear_bit_le(unsigned long nr, void *addr)
 {
 	clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline void __set_bit_le(int nr, void *addr)
+static inline void __set_bit_le(unsigned long nr, void *addr)
 {
 	__set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline void __clear_bit_le(int nr, void *addr)
+static inline void __clear_bit_le(unsigned long nr, void *addr)
 {
 	__clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline int test_and_set_bit_le(int nr, void *addr)
+static inline int test_and_set_bit_le(unsigned long nr, void *addr)
 {
 	return test_and_set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline int test_and_clear_bit_le(int nr, void *addr)
+static inline int test_and_clear_bit_le(unsigned long nr, void *addr)
 {
 	return test_and_clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline int __test_and_set_bit_le(int nr, void *addr)
+static inline int __test_and_set_bit_le(unsigned long nr, void *addr)
 {
 	return __test_and_set_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
 
-static inline int __test_and_clear_bit_le(int nr, void *addr)
+static inline int __test_and_clear_bit_le(unsigned long nr, void *addr)
 {
 	return __test_and_clear_bit(nr ^ BITOP_LE_SWIZZLE, addr);
 }
-- 
2.53.0

