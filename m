Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE6157FEEC;
	Mon, 19 Oct 2026 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418322; cv=none; b=eXPDe3u0VEeehEUz1YjEs1hQSLZt2fqJh15cL0IF4aP0ylUrWPjUN13CB+Kp2MPCxymRcEyXFsNWJ4/BXSU44r7VkbvCUDEPpalXlEqPitR1Z3JiuRSV0cRMDXW33l0YcPxrL5LrGiUodKsT+G9QsebMRAUOkc/su/lmetngQuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418322; c=relaxed/simple;
	bh=3kzk2ncx0AKK8E1fRXwGJNVurNhp41OPqBFbAI1QNFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PgtqcmUbVPO6nKJhMfvUKVqMQMA0PLnRgSEOkW/p1NzaIpkReexJUZuYvBWcOapOByv4svWvmhwmcMyzFwb8bV0E1lyxT0RLKDK5Dgg5j5DBC/wRbM8rpASwntwhKVg8d6ZLMfpm9MtRXBgmVdtEoX9fx8nPYzcV58hqkc2TbDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RqT50PV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RqT50PV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDDD1F000C6;
	Mon, 19 Oct 2026 13:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418318;
	bh=t2J4oa2G2anLKCm1uUaK5xU3F+A5S4QmXS8HeEIgNSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RqT50PV9Og7OyYUp3WIF5ZRcrRMzhP+AI+QwbbWci7XooqUzPgVAH0zfgLfHlUbH3
	 fRH18qBxzSzw7KPshQHQ4taO4XFhSLh9CcmuVtpdvHWGuegn0VKPivKfAYL3b4w5Hc
	 AS7nvs9I2halxzHqX4GmSmVDRcwY1Rdx71YXeMHtXaTIfiID0SVRuRXQdwQ/IVjzzG
	 tQrgvSZly+P9faX5IcTLxFYtwRCf5GuvthxMDqmJSzX4RsGzUeRvih9qfjE7KwDsBb
	 0Be8Qrjibm9Yh2TYlsMnYVwG7B54CUSzJi0VGPaoferGfnvmwb3magqX4xMiLSkIRe
	 m/MBjvHb0WmkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] fbdev: maxine: fix 64-bit build error
Date: Mon, 19 Oct 2026 09:47:33 -0400
Message-ID: <20261019135441.1420968-162-sashal@kernel.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 3adec5c640dc09dca5605043e138412fd5a0629d ]

The KSEG1ADDR() macro is only defined for non-64BIT builds.
Use the CKSEG1ADDR() macro instead.

In file included from ../drivers/video/fbdev/maxinefb.c:34:
../drivers/video/fbdev/maxinefb.c: In function 'maxinefb_ims332_write_register':
../include/video/maxinefb.h:16:41: error: implicit declaration of function 'KSEG1ADDR'; did you mean 'CKSEG1ADDR'? [-Wimplicit-function-declaration]
   16 | #define MAXINEFB_IMS332_ADDRESS         KSEG1ADDR(0x1c140000)
../drivers/video/fbdev/maxinefb.c:66:49: note: in expansion of macro 'MAXINEFB_IMS332_ADDRESS'
   66 |         register unsigned char *regs = (char *) MAXINEFB_IMS332_ADDRESS;
../drivers/video/fbdev/maxinefb.c:66:40: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   66 |         register unsigned char *regs = (char *) MAXINEFB_IMS332_ADDRESS;

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **6.12.111** (`pending-6.12`). The buggy `KSEG1ADDR()` use
is still in `include/video/maxinefb.h`; the candidate is a two-line
build fix and belongs in this tree.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[fbdev/maxine] [fix] [64-bit build error]` — subsystem `fbdev:
maxine`, action verb **fix**, intent is to make the DECstation Maxine
framebuffer driver compile on 64-bit MIPS.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Randy Dunlap <rdunlap@infradead.org>` (author)
- `Acked-by: Maciej W. Rozycki <macro@orcam.me.uk>` (MIPS/DECstation
  expert)
- `Signed-off-by: Helge Deller <deller@gmx.de>` (fbdev maintainer)
- No `Fixes:` tag (expected for this review)
- No `Reported-by:`, `Tested-by:`, `Cc: stable`, or `Link:`
- Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  ...]`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `KSEG1ADDR()` is used in `include/video/maxinefb.h` but is
  only defined when `!CONFIG_64BIT` in
  `arch/mips/include/asm/addrspace.h`.
- **Symptom:** compile failure:
  `error: implicit declaration of function 'KSEG1ADDR'` plus `warning:
  cast to pointer from integer of different size`.
- **Root cause:** 32-bit-only KSEG macros used in a driver that Kconfig
  allows on 64-bit `MACH_DECSTATION`.
- **Fix:** use `CKSEG1ADDR()`, which exists for both 32-bit and 64-bit.
- **Version info:** none in the message; series cover says the code is
  “from the beginning of git time.”

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. This is an explicit build-error fix, not a cleanup
in disguise. It is patch 03/03 of “fbdev: maxine: clean up build
issues”; patches 01/02 are warning/cleanup in `maxinefb.c` and are
independent of this header change.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `include/video/maxinefb.h` only
- Two `#define` substitutions: `KSEG1ADDR` → `CKSEG1ADDR`
- ~2 insertions / 2 deletions
- No functions added or rewritten; macros `MAXINEFB_IMS332_ADDRESS` and
  `DS5000_xx_ONBOARD_FBMEM_START`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: both MMIO/FB base macros expand via `KSEG1ADDR()`, which does
  not exist under `CONFIG_64BIT`.
- After: same physical addresses mapped through `CKSEG1ADDR()`.
- Affected path: compile of `maxinefb.c` (register access and
  framebuffer base). Runtime on 32-bit is unchanged because the two
  macros are identical there.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: **build / type correctness** (implicit declaration; 32-bit
  integer treated as a pointer on 64-bit).
- Mechanism: `KSEG1ADDR` is inside `#else /* !CONFIG_64BIT */`.
  `CKSEG1ADDR` is defined in both branches. On 32-bit, `CKSEG1ADDR(a)`
  is `(CPHYSADDR(a) | KSEG1)`, same as `KSEG1ADDR`. On 64-bit it uses
  `CKSEG1` (`0xffffffffa0000000`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: compiler even suggested `CKSEG1ADDR`.
- Minimal; no API or struct changes.
- Regression risk: very low. 32-bit generated addresses match. 64-bit
  previously did not compile, so there is no working 64-bit runtime to
  regress.
- Acked by the DECstation/MIPS expert.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: Both macros come from `1da177e4c3f41` (“Linux-2.6.12-rc2”,
2005). Present since git history began. `git merge-base --is-ancestor
1da177e4c3f41 HEAD` succeeds.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. The broken use is the original
driver code, not a later regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record (this tree, path-limited):
- `e4f10ea729670 fbdev/maxinefb: Use fbdev I/O helpers`
- `6304da8a91da8 fbdev: Remove FBINFO_DEFAULT from static structs`
- `8c13c9de80b51 fbdev: maxinefb: Remove trailing whitespaces`
- plus older const/__initdata moves
None of these touch the `KSEG1ADDR` macros. Header last changed at git
genesis. Standalone vs series: submitted as 03/03, but this hunk does
not depend on 01/02.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Randy Dunlap has many fbdev build/Kconfig fixes in this tree
(`sh7760fb`, `hgafb`, `uvesafb`, `geode`, `atyfb`, …). No prior maxinefb
commit here. Helge Deller is the fbdev maintainer who merged it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. `CKSEG1ADDR` has existed in `addrspace.h` for as long as
this tree’s MIPS headers. The patch applies to the current header as-is.
Cover letter patches 01/02 only change `maxinefb.c` (static, drop unused
`maxinefb_ims332_read_register`).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c <sha>` cannot run: this commit is **not in the local
  tree**.
- `b4 dig` on Message-ID `20260813232934.2718291-4@infradead.org` also
  found no local commit.
- Original submission (13 Aug 2026): [PATCH 03/03] on linux-kernel;
  cover [PATCH 00/03] “fbdev: maxine: clean up build issues”. Randy:
  “Now builds cleanly on 32-bit and 64-bit MACH_DECSTATION.”
- Helge’s fbdev pull for v7.3-rc1 lists it under **Fixes**: “maxine: fix
  64-bit build error and code cleanups”.
- Review: Maciej Acked-by only; no NAK, no stable-tag request found in
  the retrieved thread text.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: To/Cc included Helge Deller, linux-fbdev, dri-devel, Maciej W.
Rozycki. Maciej acked. Helge merged.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Failure is a compiler error reproduced in
the commit message (typical Randy Dunlap / kbuild-style report).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Series of 3 (+ later two maxine cleanups in the same pull: init
return value, `MODULE_LICENSE()`). Only 03/03 is required to fix the
implicit-declaration **error**. 01/02 are warning-level.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned **403**. UNVERIFIED
whether stable@ already discussed this. Openwall/Indiana archives show
no stable nomination in the review replies retrieved.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No functions modified. Macros used in
`maxinefb_ims332_write_register()`, `maxinefb_ims332_read_register()`,
and `maxinefb_init()`.

**Step 5.2: TRACE CALLERS**
Record:
- `MAXINEFB_IMS332_ADDRESS` / `DS5000_xx_ONBOARD_FBMEM_START`: only
  `drivers/video/fbdev/maxinefb.c`.
- `maxinefb_ims332_write_register`: `maxinefb_setcolreg()` and
  `maxinefb_init()` (cursor RAM wipe).
- `maxinefb_ims332_read_register`: defined, **never called** in this
  tree (that is series patch 02).
- `maxinefb_init`: `module_init`. Probe path after `mips_machtype ==
  MACH_DS5000_XX`.

**Step 5.3: TRACE CALLEES**
Record: Direct volatile MMIO via the mapped KSEG1/CKSEG1 addresses;
`register_framebuffer()` in init. No new callees.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable at boot on Personal DECstation 5000/xx with
`CONFIG_FB_MAXINE=y`. The **compile** failure is reachable for any
`MACH_DECSTATION` + `64BIT` + `FB_MAXINE` config, including 64-bit R4x00
DECstation kernels that can still select this bool (Kconfig does not
restrict it to R3000). Userspace does not trigger the compile error.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Other DECstation code already uses `CKSEG1ADDR` (e.g.
`drivers/net/ethernet/amd/declance.c`). Remaining `KSEG1ADDR` in fbdev
is `au1100fb.c` (Alchemy, 32-bit-oriented). This is the only use in
`include/video/`.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `include/video/maxinefb.h` lines 16 and 22 still use
`KSEG1ADDR`. `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
kernelversion` → **6.12.111**. Introduced at 2.6.12-rc2 genesis; present
for the entire 6.12 life.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Local header matches the patch context exactly.
`CKSEG1ADDR` is already defined for both 32- and 64-bit in this tree’s
`addrspace.h`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `git log --grep="fix 64-bit build error" --
include/video/maxinefb.h` is empty. No equivalent fix in this checkout.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/video/fbdev` + `include/video` — MIPS DECstation
onboard framebuffer. **PERIPHERAL** (vintage workstation). Still a real
in-tree driver, not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: maxinefb itself is dormant (whitespace/helpers only).
MACH_DECSTATION is mature. fbdev still receives small fixes (this series
landed in the v7.3 fbdev pull).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Config-specific: `CONFIG_MACH_DECSTATION` && `CONFIG_FB_MAXINE`
&& `CONFIG_64BIT`. 32-bit Maxine builds already compile. 64-bit
DECstation + this driver cannot build today.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Trigger is **building** that config, every time. Not a race.
Unprivileged userspace is irrelevant. Valid Kconfig: `MACH_DECSTATION`
selects `SYS_SUPPORTS_64BIT_KERNEL`; `CPU_R4X00` selects
`CPU_SUPPORTS_64BIT_KERNEL`; `FB_MAXINE` depends only on `FB=y &&
MACH_DECSTATION`.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Build error** — driver (and thus that kernel config) does not
compile. Local `Documentation/process/stable-kernel-rules.rst` lists “a
**build error** (but not for things marked CONFIG_BROKEN)” as a
qualifying bug. `FB_MAXINE` is not `BROKEN`. Implicit declaration is a
hard GCC error, independent of `CONFIG_WERROR` (which defaults to
`COMPILE_TEST` in this tree).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** 64-bit MACH_DECSTATION + Maxine fb builds again; 32-bit
  behavior unchanged.
- **Risk:** very low (2 equivalent-on-32-bit macro lines, expert ack).
- Ratio: favorable. Niche hardware, but build-break fixes are in-policy
  even for small drivers.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real compile failure with a pasted compiler log
- `KSEG1ADDR` confirmed undefined under `CONFIG_64BIT` in this tree
- `CKSEG1ADDR` is the portable replacement; 32-bit expansion is
  identical
- Two-line, single-file, applies cleanly
- Buggy code present since 2.6.12, still in 6.12.111
- Acked by Maciej W. Rozycki; merged by Helge Deller
- Stable rules in this tree explicitly allow build-error fixes
- Standalone vs the rest of the series

AGAINST:
- Very small user population (1990s Personal DECstation)
- Maxine silicon is R3000-class; 64-bit+FB_MAXINE is a Kconfig-legal
  combo more than a common production image
- No `Cc: stable` (not a negative per the review rules)

UNRESOLVED:
- Exact mainline SHA (commit not in this checkout)
- `b4 dig` / lore.kernel.org 403
- Whether stable@ already discussed it

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — compiler suggestion, Maciej
   ack, 32-bit equivalence verified in `addrspace.h`
2. Fixes a real bug that affects users? **PASS** — cannot build a valid
   64-bit DECstation config with this driver
3. Important issue? **PASS** — build error, listed in this tree’s
   stable-kernel-rules
4. Small and contained? **PASS** — 2 lines, one header
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — identical context,
   prerequisite macro already present

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Build fix** — qualifies under the documented exception /
“build error” clause.

**Step 9.4: MAKE YOUR DECISION**
Backport. The bug exists here, the fix is the standard MIPS portable
mapping, and the stable rules call out build errors. Niche hardware does
not outweigh a zero-risk compile fix that applies cleanly.

---

### What the commit solves for this tree
On 6.12, `include/video/maxinefb.h` still maps IMS332 MMIO and onboard
FB memory with `KSEG1ADDR()`. That macro is compiled out for
`CONFIG_64BIT`, while `FB_MAXINE` can still be enabled on
`MACH_DECSTATION` 64-bit kernels. The result is an implicit-declaration
error and a 32-vs-64 pointer-cast warning. `CKSEG1ADDR()` is already the
32/64-safe helper used elsewhere on DECstation.

### Stable-rules fit
Obviously correct, two lines, no new API, no prerequisites missing in
6.12, not `CONFIG_BROKEN`.

### Risk vs benefit
Benefit is restoring a previously impossible 64-bit DECstation+maxinefb
build. Risk on 32-bit Maxine (the real hardware) is nil because the
macros match.

### Concerns
None that block backport: series mates 01/02 are not required; header
matches; `CKSEG1ADDR` exists.

---

Verification:
- [Phase 1] Parsed subject/tags/body: fix 64-bit build; SOB Randy
  Dunlap, Ack Maciej, SOB Helge Deller; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: two `KSEG1ADDR` → `CKSEG1ADDR` in
  `include/video/maxinefb.h`
- [Phase 2] `addrspace.h`: `KSEG1ADDR` only in `#else` of
  `CONFIG_64BIT`; `CKSEG1ADDR` in both; 32-bit expansions identical
- [Phase 3] `git blame include/video/maxinefb.h`: lines from
  `1da177e4c3f41` (2.6.12-rc2)
- [Phase 3] `git merge-base --is-ancestor 1da177e4c3f41 HEAD`: yes
- [Phase 3] `git log --oneline -- include/video/maxinefb.h`: only
  genesis; no later equivalent fix
- [Phase 3] No `Fixes:` tag to follow
- [Phase 4] Cover + 03/03 on lists.openwall.net (2026-08-13); Maciej Ack
  on lkml.indiana.edu 2608.2/02341
- [Phase 4] Helge GIT PULL lists this under Fixes for v7.3-rc1
- [Phase 4] `b4 dig`: no local commit (candidate not in tree);
  lore.kernel.org 403
- [Phase 5] Macros only used from `maxinefb.c`; `FB_MAXINE` depends on
  `MACH_DECSTATION` only
- [Phase 5] `MACH_DECSTATION` selects `SYS_SUPPORTS_64BIT_KERNEL`;
  `CPU_R4X00` selects `CPU_SUPPORTS_64BIT_KERNEL`
- [Phase 6] `git describe HEAD` = `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` = 6.12.111
- [Phase 6] Local file still has `KSEG1ADDR`; patch context matches
- [Phase 7] Peripheral fbdev driver, not staging
- [Phase 8] Failure: compile error; this tree’s stable-kernel-rules.rst
  line 19 includes “a build error”
- [Phase 8] `CONFIG_WERROR` defaults to `COMPILE_TEST`; implicit
  declaration is still a GCC error without it
- UNVERIFIED: exact upstream SHA; stable@ archives (lore 403); whether
  anyone already requested this for 6.12.y

**YES**

 include/video/maxinefb.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/video/maxinefb.h b/include/video/maxinefb.h
index 6aeb4acca2bdb..2b66b32f355cf 100644
--- a/include/video/maxinefb.h
+++ b/include/video/maxinefb.h
@@ -13,13 +13,13 @@
 /*
  * IMS332 video controller register base address
  */
-#define MAXINEFB_IMS332_ADDRESS		KSEG1ADDR(0x1c140000)
+#define MAXINEFB_IMS332_ADDRESS		CKSEG1ADDR(0x1c140000)
 
 /*
  * Begin of DECstation 5000/xx onboard framebuffer memory, default resolution
  * is 1024x768x8
  */
-#define DS5000_xx_ONBOARD_FBMEM_START	KSEG1ADDR(0x0a000000)
+#define DS5000_xx_ONBOARD_FBMEM_START	CKSEG1ADDR(0x0a000000)
 
 /*
  *      The IMS 332 video controller used in the DECstation 5000/xx series
-- 
2.53.0

