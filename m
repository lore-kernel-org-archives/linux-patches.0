Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED818501F25;
	Mon, 19 Oct 2026 14:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418590; cv=none; b=HhfPR+5IMj/wPPOYi72C6egNOPqFRWDncHQvRcnXejKjhG2WDn/y0ahjuGJzdNFOuvjHrwyAtQCeCXfwi4FaOTzSqACBps85aMbZ1Gd+UOOH6VS9U1p/oaa9rK7s4emdfefUrqy/MLnC0lQf3Xq/OyzIQPyzHKEUEx84XjVLiBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418590; c=relaxed/simple;
	bh=OLVGoswyQ/TRqc+Zx5c8BPwrw6fbIxyRFacQ20bze1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DOueLRADufByaoqI9GJjOKQAmagxxJgzHfjX0rvd1eZdj+axzTI/ToxpBjeQn/U6aJRRfVy1ByIUrrzaY0HRBzvJZV6qDh1crwc3vuZhIoSKfNboNOEjEnhxQpgka+v1NvT8ehFersZ4/6VZd1NTlWoj0hiE0U1k1wMnsvz69mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PUevxqf3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PUevxqf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0741F1F000C6;
	Mon, 19 Oct 2026 14:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418587;
	bh=ZEkpzJm/Fz1AhN269JabheOuxq5CAfN3wBBhNvPXViE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUevxqf3qSR5rq6Dd7olmieaBbCc767tte8MeKrPpybO92n0LfHIrxR5V1B3YKICH
	 oqwhyjq2kcfa13IO6DB1+vreUcTqKlVvFithHIJzCieWEz0rtALw9brQyGGpqBX0kX
	 bMThzv6/kts6nQsh12FG8U+Z3YvoF/S0rI/r4kKNJ6PG0+zLUOhom97o7ZYjB73l57
	 78ApoSr8CRFH8HQAEUviBdodPgL9dx9pOPBRaxxSMvf3XbWzXfkOyyRzKGhahEfPZF
	 Yhf8xm+ihtUPN1Ov9XkSrjtmvMTz1p+FW1LY9kQun5xDEWIbhRSB9wJGzlwBxpcIH5
	 dI3jzq3uO3JMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: v4l2-tpg: reduce stack usage for kasan builds
Date: Mon, 19 Oct 2026 09:50:45 -0400
Message-ID: <20261019135441.1420968-354-sashal@kernel.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c49cdaafa443ccf861a72d3191121294742c28c7 ]

tpg_fill_plane_buffer() is a rather complex function. While there is
nothing wrong with it per se, I have run into corner cases with clang-22
on s390 using KASAN that makes it run out of registers and blow the
stack warning limit from excessive spills:

drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:2629:6: error: stack frame size (1560) exceeds limit (1536)
      in 'tpg_fill_plane_buffer' [-Werror,-Wframe-larger-than]
 2629 | void tpg_fill_plane_buffer(struct tpg_data *tpg, v4l2_std_id std,

Forcing the two largest callees out of line completely avoids the problem
and prevents all the register spills, with the stack usage for each function
going down to a few bytes for the local variables.

Arguably this is a problem caused by clang rather than the code, but
a noinline_for_stack annotation is an easy workaround.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough history, diff, and mailing-list evidence to walk through
all nine phases and decide for this 7.3-rc4 tree.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[media/v4l2-tpg] [reduce] Reduce stack usage of
  tpg_fill_plane_buffer() for clang+KASAN builds so -Wframe-larger-than
  does not fail the build.`

**Step 1.2: Tags**
- Record:
  - `Signed-off-by: Arnd Bergmann <arnd@arndb.de>` (author)
  - `Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>` (media
    maintainer)
  - No `Fixes:`
  - No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:` /
    `Link:` / `Cc: stable`
  - Absence of `Fixes:` / `Cc: stable` is expected for this pipeline and
    is not a negative signal
  - Notable: author is Arnd Bergmann (kbuild/clang/stack-usage); applied
    by Hans Verkuil (V4L2 maintainer). No syzbot, no user crash reports.

**Step 1.3: Body**
- Record:
  - **Bug:** `tpg_fill_plane_buffer()` is large; clang-22 on s390 with
    KASAN spills so many temporaries that the compile-time stack-frame
    warning fires as an error.
  - **Symptom:** `error: stack frame size (1560) exceeds limit (1536) in
    'tpg_fill_plane_buffer' [-Werror,-Wframe-larger-than]`
  - **Root cause:** clang register allocator + KASAN instrumentation,
    not incorrect C logic. Author: “nothing wrong with it per se” / “a
    problem caused by clang rather than the code”.
  - **Fix:** `noinline_for_stack` on the two largest callees so they are
    not inlined into the parent; per-function stack then drops to a few
    bytes.
  - **Version info:** clang-22, s390, KASAN. No kernel-version range
    given.

**Step 1.4: Hidden bug fix?**
- Record: Not a disguised UAF/leak/race. It is a **build-failure
  workaround**. Cover letter in the mbox also offers an LLVM bug if
  reviewers want one. Not a hidden runtime fix.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record:
  - File: `drivers/media/common/v4l2-tpg/v4l2-tpg-core.c` — 8
    insertions, 6 deletions (net +2)
  - Functions: `tpg_fill_plane_extras()`, `tpg_fill_plane_pattern()` —
    declaration only
  - Scope: single-file surgical annotation change; no logic, locking, or
    API change

**Step 2.2: Code flow**
- Record:
  - **Before:** both helpers are `static void`, so the compiler may
    inline them into `tpg_fill_plane_buffer()`.
  - **After:** both are `static noinline_for_stack void`; they remain
    callable from the same loop in `tpg_fill_plane_buffer()` (lines
    2707–2710) but cannot be inlined.
  - Path affected: compile-time inlining of the per-line fill helpers.
    Runtime control flow is unchanged.

**Step 2.3: Bug mechanism**
- Record: **Build / compiler-workaround (hardware-workaround
  analogue).** Not UAF, leak, race, NULL deref, or overflow.
  `noinline_for_stack` is `noinline` in `include/linux/compiler_types.h`
  “to prevent stack consumption”.

**Step 2.4: Fix quality**
- Record: Obviously correct and minimal. Regression risk is very low:
  extra calls in a test-pattern generator, not a production hot path.
  Arnd reports stack usage of each function drops. No public API /
  struct / locking change.

## Phase 3: Git history

**Step 3.1: Blame**
- Record: The two functions date to Hans Verkuil’s vivid TPG (2015),
  exported as `drivers/media/common/v4l2-tpg/v4l2-tpg-core.c` in
  `e07d46e7e0da8` (2016). The `noinline_for_stack` lines are this commit
  (`c49cdaafa443c`, 2026-06-18 / applied 2026-07-10). Long-lived code;
  the warning is from clang-22+KASAN inlining, not a new logic bug.

**Step 3.2: Fixes: tag**
- Record: None. Not applicable.

**Step 3.3: File history**
- Record: Recent TPG work is formats/patterns (`5a3757801e58a`,
  `5a531791edb24`), a div-by-zero fix, memleak fix. No prerequisite
  refactor. Standalone, not `N/M`.

**Step 3.4: Author**
- Record: Arnd Bergmann; many similar media stack-usage fixes
  (`c03b7dec3c4dd` rkvdec, `1a03f91c2c241` vivid clang stack,
  `ad4729225d93f` mxl5005s, etc.). This is the established
  `noinline_for_stack` pattern. Hans Verkuil applied it.

**Step 3.5: Dependencies**
- Record: Only `noinline_for_stack`, present in this tree as `#define
  noinline_for_stack noinline`. Applies standalone.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
- Record:
  - `b4 dig -c c49cdaafa443c` →
    https://patch.msgid.link/20260618143252.1885475-1-arnd@kernel.org
  - `b4 dig -a`: **v1 only**, 2026-06-18. No later revision.
  - mbox is the patch plus: “If anyone thinks we should track this as an
    llvm bug, I can help come up with a reproducer”. **No replies, no
    NAK, no Cc: stable suggestion.**
  - lore.kernel.org WebFetch returned 403; thread recovered via `b4 dig
    -m`.

**Step 4.2: Recipients (`b4 dig -w`)**
- Record: Mauro Chehab, Nathan Chancellor, Nick Desaulniers, Bill
  Wendling, Justin Stitt, linux-media, LKML, llvm@lists.linux.dev. Right
  maintainers and LLVM list. No review tags in-tree beyond Hans’s SOB on
  apply.

**Step 4.3: Bug report**
- Record: No syzbot/bugzilla. The “report” is Arnd’s own clang-22 s390
  KASAN build. Severity: compile error under `-Werror`, not a runtime
  crash.

**Step 4.4: Series**
- Record: Standalone v1. Not part of a multi-patch series.

**Step 4.5: Stable list**
- Record: lore.kernel.org/stable WebFetch 403. **UNVERIFIED:** whether
  this was discussed on stable@. Nothing in the mbox nominates it.

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
- Record: `tpg_fill_plane_extras`, `tpg_fill_plane_pattern`
  (annotations). Indirectly `tpg_fill_plane_buffer` (the function named
  in the warning).

**Step 5.2: Callers**
- Record: Both helpers are static and only called from
  `tpg_fill_plane_buffer()`. That function is `EXPORT_SYMBOL_GPL` and
  called from:
  - `tpg_fillbuffer()` (same file)
  - `drivers/media/test-drivers/vivid/vivid-kthread-cap.c`
  - `drivers/media/test-drivers/vimc/vimc-sensor.c`
  - `drivers/media/test-drivers/visl/visl-dec.c`
- Userspace-reachable only if a **virtual V4L2 test driver**
  (vivid/vimc/visl) is loaded. Not IRQ/core.

**Step 5.3: Callees**
- Record: memcpy of pattern lines, rectangle/pillar drawing, pixel-
  format switches. No locks, no alloc in the changed signatures.

**Step 5.4: Reachability**
- Record: Yes from userspace via vivid/vimc/visl, but those Kconfigs say
  “When in doubt, say N.” The failure being fixed is **compile-time**,
  so it hits anyone who *builds* `VIDEO_V4L2_TPG` (selected by those
  drivers; allmodconfig will build it).

**Step 5.5: Similar patterns**
- Record: Same `noinline_for_stack` workaround exists elsewhere in media
  (vivid 2019, rkvdec 2026). This instance is the TPG core helper, not a
  duplicate of those.

## Phase 6: This checkout

**Step 6.1: Local tree and buggy code**
- Record:
  - `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`
  - `make kernelversion` → `7.3.0-rc4`
  - Makefile: VERSION=7 PATCHLEVEL=3 SUBLEVEL=0 EXTRAVERSION=-rc4
  - File and functions exist. Pre-patch form was `static void
    tpg_fill_plane_*`. TPG present since 2016 (`e07d46e7e0da8` is an
    ancestor).
  - `git merge-base --is-ancestor c49cdaafa443c HEAD` is true (commit is
    in this development tree). That is **not** treated as “already
    selected for stable”.

**Step 6.2: Backport difficulty**
- Record: Clean apply on this tree. Only the two `static void`
  prototypes change. `noinline_for_stack` exists.

**Step 6.3: Related fixes already here**
- Record: No earlier equivalent TPG stack workaround. `1a03f91c2c241` is
  a similar vivid kthread workaround from 2019, different file/function.

## Phase 7: Subsystem context

**Step 7.1**
- Record: Subsystem `drivers/media/common/v4l2-tpg` (V4L2 test pattern
  generator). **PERIPHERAL** — only vivid/vimc/visl test drivers. Not
  mm/fs/net core.

**Step 7.2**
- Record: Mature (2015–2016), occasional format additions. Not a high-
  churn core path.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: Config-specific: `CONFIG_VIDEO_V4L2_TPG` via vivid/vimc/visl,
  plus clang-22, KASAN, `-Werror`, and `CONFIG_FRAME_WARN=1536` (error
  text). Default 64-bit `FRAME_WARN` is **2048** (`lib/Kconfig.debug`);
  1560 < 2048, so **default s390 64-bit allmodconfig would not fail**.
  1536 is the 32-bit Xtensa default, or a non-default int in
  randconfig/custom CI.

**Step 8.2: Trigger**
- Record: Building that file with that toolchain/config. Not a runtime
  trigger. Unprivileged users cannot “hit” it except as a failed kernel
  build.

**Step 8.3: Failure mode**
- Record: Compile error under `-Werror` (WERROR defaults to
  COMPILE_TEST). Runtime stack on s390 is 16KiB, 64KiB with KASAN
  (`arch/s390/Makefile`); 1560 bytes is not a runtime overflow.
  Severity: **MEDIUM for CI/debug builds with a lowered FRAME_WARN; LOW
  for production stable users.**

**Step 8.4: Risk-benefit**
- Record:
  - Benefit: unblocks clang+KASAN+Werror builds of TPG/vivid; tiny
    annotation.
  - Risk: very low (2 annotations, no behavior change).
  - Ratio: favorable **if** treated as a build fix; modest user benefit
    because the default 64-bit limit is 2048.

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Official `stable-kernel-rules.rst` lists **build error** (not
  CONFIG_BROKEN).
- Build-fix exception in the evaluation rubric.
- 8/6-line, obviously correct `noinline_for_stack` — the kernel’s
  standard answer to clang+KASAN frame-size errors.
- Author Arnd Bergmann; applied by Hans Verkuil; LLVM Linux people on
  Cc.
- Helpers and macro exist in this 7.3-rc4 tree; applies cleanly; no
  series deps.
- Similar media workarounds have been used for years.

AGAINST:
- Not a crash, UAF, deadlock, corruption, or security bug.
- Author: clang problem, not a logic bug.
- Only vivid/vimc/visl (test drivers, “When in doubt, say N”).
- Reproduced with FRAME_WARN **1536**; 64-bit default is **2048**, so
  typical s390 KASAN allmodconfig may not fail.
- clang-22 + s390 + KASAN is a narrow toolchain.
- No stable nomination, no user reports, v1 with no review discussion.

UNRESOLVED:
- Whether default `FRAME_WARN=2048` allmodconfig on this tree fails with
  clang-22+KASAN (reported size 1560 suggests no).
- Whether 32-bit clang+KASAN exceeds the 1280 default (not claimed;
  unverified).
- Whether stable@ ever discussed this (lore 403).

**Step 9.2: Stable rules checklist**
1. Obviously correct and tested? **PASS** — two `noinline_for_stack`
   marks; Arnd built it; maintainer applied v1.
2. Real bug that affects users? **PASS** as a **build error** for the
   configs that hit it; **weak** for production runtime users.
3. Important (crash/security/corruption/deadlock)? **PASS only via the
   documented build-error clause**, not via runtime severity. Frame 1560
   vs 1536 is a warning-as-error, not an oops.
4. Small and contained? **PASS** — one file, ~14-line diff, well under
   100 lines.
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — file, functions, and
   `noinline_for_stack` are all here.

**Step 9.3: Exception category**
- Record: **Build fix** (compilation error/warning under `-Werror`). Not
  a device-ID, quirk, DT, or docs exception.

**Step 9.4: Decision**

This tree is **Linux 7.3-rc4** (mainline). The TPG helpers are present;
the patch is self-contained and matches the code here.

It is not a runtime stability fix. It is the documented class of **build
error** that stable rules allow: clang-22 + KASAN inlines two large
`static` helpers into `tpg_fill_plane_buffer()` until `-Wframe-larger-
than` fails with `-Werror`. The change is two `noinline_for_stack`
annotations, no semantic change, negligible regression risk.

That is enough for this tree: the affected code exists, the workaround
is the usual one, and blocking KASAN/clang builds of `VIDEO_V4L2_TPG` is
a real compile failure even though vivid is a test driver.

## What the commit solves for this tree

`tpg_fill_plane_buffer()` grows a 1560-byte frame when clang-22+KASAN
inlines `tpg_fill_plane_extras()` and `tpg_fill_plane_pattern()`. With
`CONFIG_FRAME_WARN=1536` and `CONFIG_WERROR`, the build dies. Forcing
those callees out of line removes the spill storm. Stable users who
build this kernel with clang+KASAN+Werror (CI, debug kernels) need that
to compile; production runtime behavior is unchanged.

## Risk vs benefit

Benefit is restoring those builds; risk is two extra calls in a test-
pattern path. The FRAME_WARN=1536 vs default 2048 gap means default
64-bit configs may already pass, but the official build-error rule still
covers the failure Arnd hit, and the patch is too small to justify
withholding it.

## Verification
- [Phase 1] Parsed message/tags: Arnd + Hans SOB only; no
  Fixes/Reported-by/Link/Cc:stable
- [Phase 2] `git show c49cdaafa443c --stat`: 1 file, +8/-6; only two
  function signatures
- [Phase 2] Read `v4l2-tpg-core.c` ~2350–2712: loop still calls both
  helpers; no logic change
- [Phase 2] `noinline_for_stack` is `#define noinline` in
  `include/linux/compiler_types.h:264`
- [Phase 3] `git blame` on the annotations: `c49cdaafa443c`; older
  `static void` from 2015 vivid TPG
- [Phase 3] Origin `e07d46e7e0da8` (2016) is an ancestor of HEAD
- [Phase 3] No Fixes: tag to follow
- [Phase 3] `git log --oneline -20 --
  drivers/media/common/v4l2-tpg/v4l2-tpg-core.c`: no prerequisite series
- [Phase 4] `b4 dig -c c49cdaafa443c`: lore msgid
  `20260618143252.1885475-1-arnd@kernel.org`
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: media + LLVM maintainers Cc’d
- [Phase 4] `b4 dig -m /tmp/tpg-thread.mbox`: patch + LLVM-bug offer; no
  replies
- [Phase 4] WebFetch lore/stable: 403 — UNVERIFIED stable-list history
- [Phase 5] `git grep tpg_fill_plane_buffer`: vivid, vimc, visl only
- [Phase 5] No semcode MCP; used grep/read
- [Phase 6] `git describe HEAD` / `make kernelversion`: v7.3-rc4 /
  7.3.0-rc4
- [Phase 6] `git merge-base --is-ancestor c49cdaafa443c HEAD`: yes
  (original commit in this tree; not used as circular “already
  selected”)
- [Phase 6] Parent blobs still have `static void
  tpg_fill_plane_extras/pattern`
- [Phase 7] Kconfig: `VIDEO_V4L2_TPG` tristate selected by
  vivid/vimc/visl test drivers
- [Phase 8] `lib/Kconfig.debug`: FRAME_WARN default 2048 if 64BIT, 1536
  only if !64BIT && XTENSA; s390 `STACK_SIZE` 16K/64K with KASAN
- [Phase 8] `init/Kconfig`: WERROR default COMPILE_TEST
- UNVERIFIED: allmodconfig with default FRAME_WARN=2048 on clang-22 s390
  KASAN (1560 suggests it would pass)
- UNVERIFIED: 32-bit clang KASAN frame size vs 1280 default

**YES**

 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index 931e5dc453b90..e1d5c220f7381 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -2346,9 +2346,11 @@ static void tpg_fill_params_extras(const struct tpg_data *tpg,
 			(params->is_60hz ? V4L2_FIELD_TOP : V4L2_FIELD_BOTTOM);
 }
 
-static void tpg_fill_plane_extras(const struct tpg_data *tpg,
-				  const struct tpg_draw_params *params,
-				  unsigned p, unsigned h, u8 *vbuf)
+/* noinline to work around clang KASAN issues */
+static noinline_for_stack void
+tpg_fill_plane_extras(const struct tpg_data *tpg,
+		      const struct tpg_draw_params *params,
+		      unsigned p, unsigned h, u8 *vbuf)
 {
 	unsigned twopixsize = params->twopixsize;
 	unsigned img_width = params->img_width;
@@ -2483,9 +2485,9 @@ static void tpg_fill_plane_extras(const struct tpg_data *tpg,
 	}
 }
 
-static void tpg_fill_plane_pattern(const struct tpg_data *tpg,
-				   const struct tpg_draw_params *params,
-				   unsigned p, unsigned h, u8 *vbuf)
+static noinline_for_stack void
+tpg_fill_plane_pattern(const struct tpg_data *tpg, const struct tpg_draw_params *params,
+		       unsigned p, unsigned h, u8 *vbuf)
 {
 	unsigned twopixsize = params->twopixsize;
 	unsigned img_width = params->img_width;
-- 
2.53.0

