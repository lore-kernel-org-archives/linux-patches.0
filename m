Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169CF57AF4E;
	Mon, 31 Aug 2026 13:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184166; cv=none; b=aFKDpHAa0LBA/6UdOUZ7/vwgEp2oD9iDtSieOMGxUYvo8FYjUKnps1+3u3MAiYf20X7oL2NIqxa7DfRc1s6sPawdmRyfc4DiUrERBJ+B7kSpdxcfMkNZpSIjlRrEVDal4Q8C4PzYPfL5tIm59Ml7yoN/5HYIn05/3WbWGD0AmoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184166; c=relaxed/simple;
	bh=siNDq8U9Y94jeeWCiLQz5TclaZvcIbyTOdymaUH9XlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QqqaShfdr6rasTCEn3rBWl+BWl2VGp9M7vHiMy4VYfxZR0KY+z0e1t1LVzvIJSJfWUb/m7CWW8aciABGlNPhfEfqJ5XRCZAfcDm8WPAjOVKSVPiKBHoefk79rOCKNgPW37m45XvTAVroqFWN4YMbiJLc9SGZvPoYjgoMZRMU0AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eVeItwJd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVeItwJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803BA1F00ACA;
	Mon, 31 Aug 2026 13:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184164;
	bh=0Q1y66WfB+Ah+19IjrF3LGQAdiAiYv1WRhXpM89rYFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVeItwJd35lLDNW7edD6jNs1vkA0O2GNMjCZ6PmCuSy0BI6DN2cgEAPpnrWCiEtFM
	 h9qDewt81mIYXSvS9A3oqVIZ309OucgZ+N7Jwb1OqcPsW5HPBS15WqgUqvvVPhGZ5O
	 KsWQFWbw/JefcIWrUNdeQPnIK5YYBUiWRUPFYCWa+QKwzEryc6auW0doWjwgbvwEmw
	 zr+MaS0IqK2jsJtm9KyHroCHGPyXiU5ZLbU9HRne01fHqcBFEGPAtqOGqBWH7FsV3J
	 BZuFYJrbedzx00Y9EwpMg2hZqCkL69vgM3tdP6rN+fYDl+GTJxs/+9GI+hysTpor9l
	 EWg7b6WQM9hmw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
	Bryan O'Donoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] media: qcom: camss: avoid format string warning
Date: Mon, 31 Aug 2026 09:29:17 -0400
Message-ID: <20260831133314.4125787-529-sashal@kernel.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 797c1cbf672f372d6a464df0dcedf476fc715969 ]

clang-22 warns about csiphy_match_clock_name() taking a variable format
string that is not checked against the 'int index' argument:

drivers/media/platform/qcom/camss/camss-csiphy.c:566:44: error: diagnostic behavior may be improved by
      adding the 'format(printf, 2, 3)' attribute to the declaration of 'csiphy_match_clock_name'
      [-Werror,-Wmissing-format-attribute]
  561 | static bool csiphy_match_clock_name(const char *clock_name, const char *format,
      | __attribute__((format(printf, 2, 3)))
  562 |                                     int index)
  563 | {
  564 |         char name[16]; /* csiphyXXX_timer\0 */
  565 |
  566 |         snprintf(name, sizeof(name), format, index);
      |                                                   ^
drivers/media/platform/qcom/camss/camss-csiphy.c:561:13: note: 'csiphy_match_clock_name' declared here
  561 | static bool csiphy_match_clock_name(const char *clock_name, const char *format,
      |             ^

Change the function to use a snprintf() style format string that allows this
to be checked at the call site.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 Record:** Subsystem `media: qcom: camss`; action verb
`avoid`; claimed intent is to silence/fix a clang-22 `-Wmissing-format-
attribute` diagnostic in `csiphy_match_clock_name()`.

**Step 1.2 Record:** Tags present in the submission (verified via lore):
- `Fixes: 0727615fb975 ("media: qcom: camss: Functionally decompose
  CSIPHY clock lookups")`
- `Signed-off-by: Arnd Bergmann <arnd@arndb.de>`
- `Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>`
- `Signed-off-by: Bryan O'Donoghue <bod@kernel.org>`
- No `Reported-by`, `Tested-by`, `Cc: stable`, or bug-report `Link`
  tags.

**Step 1.3 Record:** Bug is a **build failure**, not a runtime defect.
With clang-22 and `-Werror,-Wmissing-format-attribute`,
`csiphy_match_clock_name()` passes a variable `format` to `snprintf()`
without a printf-style attribute, so the compiler errors out. Symptom:
kernel build fails when `CONFIG_VIDEO_QCOM_CAMSS` is enabled under those
compiler flags. Root cause: helper takes `const char *format, int index`
and uses `snprintf(name, ..., format, index)` without `__printf(2, 3)`.

**Step 1.4 Record:** Not a hidden runtime bug fix. This is an explicit
compiler-warning/build fix disguised as "avoid warning," but it does
prevent real build breakage in clang-22 + Werror configurations.

---

## Phase 2: Diff Analysis

**Step 2.1 Record:** One file changed:
`drivers/media/platform/qcom/camss/camss-csiphy.c` (+7/-3). Function
modified: `csiphy_match_clock_name()`. Scope: single-file, surgical.

**Step 2.2 Record:**
- **Before:** `csiphy_match_clock_name(clock_name, format, index)` calls
  `snprintf(name, sizeof(name), format, index)`.
- **After:** Function becomes `__printf(2, 3)
  csiphy_match_clock_name(clock_name, format, ...)` using `va_list` +
  `vsnprintf()`. Call sites are unchanged and still pass literal format
  strings plus `csiphy->id`.

**Step 2.3 Record:** Bug category: **build fix / compiler diagnostic
fix**. Mechanism: adding `__printf(2, 3)` lets clang verify format
strings at call sites; variadic args preserve existing behavior.

**Step 2.4 Record:** Fix is obviously correct and minimal. Call sites at
lines 678–692 still pass `"csiphy%d_timer"`, `"csi%d_phy"`, and
`"csiphy%d"` with `csiphy->id` — compatible with variadic calling.
Regression risk is very low; behavior is equivalent to the old
`snprintf()` path. `linux/kernel.h` (already included) provides
`va_list` support, matching the pattern used in the already-backported
`clk: qoriq` fix in this tree.

---

## Phase 3: Git History Investigation

**Step 3.1 Record:** Current tree at `camss-csiphy.c:561–567` still has
the pre-fix code. `git blame` attributes those lines to merge commit
`5d324e5159d9e`. The `csiphy_match_clock_name()` helper pattern dates to
commit `0727615fb975` (Oct 2023, "Functionally decompose CSIPHY clock
lookups").

**Step 3.2 Record:** `Fixes: 0727615fb975` exists in the object database
and introduced the helper. The buggy pattern is present in the checked-
out `6.18.43` tree. The fix commit itself is **not** yet in this tree.

**Step 3.3 Record:** Related recent camss commits in this tree are
runtime fixes (RDI streaming, VFE lite clocks). No duplicate fix for
this warning. **Precedent:** `558b2eb623f2f` (`clk: qoriq: avoid format
string warning`) — same author, same clang-22 issue, same
variadic/`__printf` pattern — was already backported to this `6.18.y`
tree by Greg Kroah-Hartman.

**Step 3.4 Record:** Arnd Bergmann is a frequent contributor of clang
build-warning fixes across the kernel. Bryan O'Donoghue is the camss
subsystem author/maintainer and reviewed the patch.

**Step 3.5 Record:** No series dependencies. Standalone, self-contained.
Call sites require no changes.

---

## Phase 4: Mailing List and External Research

**Step 4.1 Record:** Original submission at [lore.kernel.org patch
thread](https://lkml.iu.edu/2603.2/11306.html) (2026-03-20). Bryan
O'Donoghue replied with `Reviewed-by` ([spinics
thread](https://www.spinics.net/lists/kernel/msg6110456.html)). No NAKs
found. No explicit stable nomination in the thread. `b4 dig -c <hash>`
failed (commit not present locally); lore fetch used instead.

**Step 4.2 Record:** CC list included linux-media, linux-arm-msm, llvm@,
and subsystem maintainers (Hans Verkuil, Bryan O'Donoghue, etc.).
Appropriate reviewers were involved.

**Step 4.3 Record:** No user bug report or syzbot report. Failure mode
documented only via clang compiler output in the commit message.

**Step 4.4 Record:** Standalone patch, not part of a multi-patch series.
Autosel pipeline has nominated a variant for `6.12.y` (seen in web
search), indicating automated stable consideration of this class of fix.

**Step 4.5 Record:** No stable-list discussion found beyond autosel
nomination. Not applicable otherwise.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 Record:** Modified function: `csiphy_match_clock_name()`.
Caller context: `msm_csiphy_subdev_init()` clock-setup loop.

**Step 5.2 Record:** Three call sites in `msm_csiphy_subdev_init()`
(lines 678, 685, 692), all during CSIPHY probe/initialization when
`CONFIG_VIDEO_QCOM_CAMSS` is enabled on Qualcomm platforms.

**Step 5.3 Record:** Callees: `va_start`, `vsnprintf`, `va_end`,
`strcmp`. No allocation, no locking.

**Step 5.4 Record:** Reachable during device probe for Qualcomm camera
hardware. Not syscall-reachable directly, but affects kernel
buildability for that driver — not a runtime user-triggerable crash.

**Step 5.5 Record:** Identical pattern fixed in `drivers/clk/clk-
qoriq.c` in this same tree (`558b2eb623f2f`). Part of a broader clang-22
`-Wmissing-format-attribute` cleanup effort by Arnd Bergmann.

---

## Phase 6: Cross-Referencing Against the Local Tree

**Step 6.1 Record:** Local tree is **Linux 6.18.43** (`git describe
HEAD` → `v6.18.43-1-gc7f0dac02d232`, `Makefile` VERSION 6.18.43). Buggy
code **is present** at `camss-csiphy.c:561–567`. Fix is **not** yet
applied.

**Step 6.2 Record:** Expected backport difficulty: **clean apply**. File
structure matches the upstream diff index (`62623393f414` parent in lore
matches current content pattern).

**Step 6.3 Record:** No equivalent fix already in tree. Sibling fix
`clk: qoriq: avoid format string warning` is present; camss variant is
not.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 Record:** Subsystem: `drivers/media/platform/qcom/camss` —
media platform driver for Qualcomm camera ISP. Criticality:
**PERIPHERAL** (hardware-specific, `CONFIG_VIDEO_QCOM_CAMSS`, ARM QCOM +
IOMMU).

**Step 7.2 Record:** camss is actively maintained in stable with recent
runtime fixes (RDI streaming, VFE lite). This patch is orthogonal to
those.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 Record:** Affected population: kernel **builders** compiling
`CONFIG_VIDEO_QCOM_CAMSS=y/m` with clang-22 and extra warnings (`W=1`
enables `-Wmissing-format-attribute` per
`scripts/Makefile.extrawarn:115`; `W=e` or `CONFIG_WERROR` promotes
warnings to errors per `scripts/Makefile.extrawarn:217–219`). Not
universal end-user runtime impact.

**Step 8.2 Record:** Trigger: build with clang-22 + `-Wmissing-format-
attribute` as error (e.g. `make W=1` or `W=e`, or `CONFIG_WERROR=y`).
Default builds without extra warnings are unaffected. Unprivileged users
cannot trigger this at runtime.

**Step 8.3 Record:** Failure mode: **compile-time error** — build abort.
Severity: **LOW** for deployed systems (no runtime crash/corruption);
**MEDIUM** for developers/distributions using clang CI with Werror.

**Step 8.4 Record:** Benefit: restores buildability under clang-22
Werror CI; aligns with already-accepted precedent in this tree. Risk:
very low (7-line localized change, maintainer-reviewed, no behavior
change). Risk-benefit: favorable for stable given build-fix policy and
existing qoriq backport.

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Qualifies as a **build fix** under stable-kernel-rules exceptions.
- Buggy code exists in this `6.18.43` tree; fix not yet applied.
- Small, surgical, maintainer-reviewed (`Reviewed-by: Bryan
  O'Donoghue`).
- **Direct precedent in this tree:** `558b2eb623f2f clk: qoriq: avoid
  format string warning` — identical issue class, same author, already
  backported to `6.18.y`.
- Prevents llvm/clang allmodconfig or `W=1`/`W=e` build failures.

**Evidence AGAINST backport:**
- Zero runtime user impact.
- Only affects non-default build configurations (extra warnings/Werror).
- Narrow scope: one optional driver on Qualcomm platforms.

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — straightforward
   variadic/`__printf` pattern; reviewed by subsystem maintainer.
2. Fixes a real bug affecting users? **PASS** — real build failure for
   clang-22 + Werror builders (not theoretical).
3. Important issue? **PASS (low severity)** — build breakage, not
   crash/corruption/security.
4. Small and contained? **PASS** — 1 file, ~10 lines.
5. No new features or APIs? **PASS** — internal static helper only.
6. Can apply to local tree? **PASS** — code present, clean apply
   expected.

**Exception category:** Build fix.

**Decision rationale for Linux 6.18.y:** The tree already accepts this
exact class of clang-22 format-attribute build fix (qoriq clk driver).
The camss variant is the same technical issue, same fix pattern, same
author, and the pre-fix code is present here. While runtime impact is
nil, stable policy explicitly includes build fixes, and this tree has
established precedent for backporting them.

---

## Verification

- [Phase 1] Parsed commit message and lore submission; tags recorded; no
  syzbot/user reports.
- [Phase 2] Read `camss-csiphy.c:561–692`; confirmed diff changes only
  `csiphy_match_clock_name()`; call sites unchanged.
- [Phase 3] `git describe HEAD` → v6.18.43; `git blame -L 561,570` →
  pre-fix code present; `git show 0727615fb975` → introduced helper Oct
  2023; `git show 558b2eb623f2f` → sibling fix already in tree.
- [Phase 3] `git log --grep="avoid format string warning"` → only qoriq
  fix present, not camss.
- [Phase 4] WebFetch lore submission and Bryan O'Donoghue review; `b4
  dig -c` failed (commit not in local repo).
- [Phase 5] `grep csiphy_match_clock_name` → 3 call sites in
  `msm_csiphy_subdev_init()`.
- [Phase 6] Confirmed tree version 6.18.43; buggy code at lines 561–567;
  fix absent.
- [Phase 6] Read `scripts/Makefile.extrawarn:113–115,217–219` →
  `-Wmissing-format-attribute` requires `W=1`; Werror requires `W=e` or
  `CONFIG_WERROR`.
- [Phase 6] Read `drivers/media/platform/qcom/camss/Kconfig` →
  `CONFIG_VIDEO_QCOM_CAMSS` depends on `ARCH_QCOM && IOMMU_DMA`.
- [Phase 7] `git log --oneline -5 -- drivers/media/platform/qcom/camss/`
  → active subsystem maintenance.
- [Phase 8] Assessed severity as compile-time only, LOW runtime / MEDIUM
  for clang CI builders.

**YES**

 drivers/media/platform/qcom/camss/camss-csiphy.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
index 2de97f58f9ae4..74c77969db7ef 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -558,12 +558,16 @@ static int csiphy_init_formats(struct v4l2_subdev *sd,
 	return csiphy_set_format(sd, fh ? fh->state : NULL, &format);
 }
 
-static bool csiphy_match_clock_name(const char *clock_name, const char *format,
-				    int index)
+static bool __printf(2, 3)
+csiphy_match_clock_name(const char *clock_name, const char *format, ...)
 {
 	char name[16]; /* csiphyXXX_timer\0 */
+	va_list args;
+
+	va_start(args, format);
+	vsnprintf(name, sizeof(name), format, args);
+	va_end(args);
 
-	snprintf(name, sizeof(name), format, index);
 	return !strcmp(clock_name, name);
 }
 
-- 
2.53.0

