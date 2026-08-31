Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0470E443AAB;
	Mon, 31 Aug 2026 13:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183569; cv=none; b=MNlnsp57hqU0Vbe2FjrHVU1MgdkgryshNwHOYM7aDVEV7jA1Xmu05q2HEmA5JsW69cfPpRN/17sek0W1LEsC1q3MoMSdXkNQV0aHA+UdKZ0K8ZIlIYOHD3MRMeFHFnvFK2EvWWX1ngSCfNP6KpvlFiopwutzK1+3jT1G7V7ATOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183569; c=relaxed/simple;
	bh=sLuQfM5Fa6NsZzaM/d86XT1RxLWz8+BxqdYLRFMdYRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZlY2zCyZ+PPMM489z9KoXJhJSnv7Pm4UOEBl7Z5YWoSY7IP0UmptLRgavvrBaXNFRf2CWs2f6WgwuCN8A4vYMJMDEIW2ntVZTkBZeNT1dRUhxIhKhijmjmrx+C0AmqwyW0f4QwZtDuLhZYnZOs0/K2Oa7aXQ+GO3mscTTKKCwU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXKj2xWl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXKj2xWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CB21F00ACA;
	Mon, 31 Aug 2026 13:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183566;
	bh=zoeHzATJIOgGVjlLRQUI6U1h8vDJRiolLUK4FvNtRgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VXKj2xWlMzNewndO6oWRT+yXy4MrLLriu8NcP+dziY/iPOCYBw5tO4AASiwZfKMg/
	 kqdIdM4cgAFOaOfCzH3eiM9TMdoY2lTyvinDqSIwUiynIvNjYaioJZSKNpwti6snGE
	 x0tw6M28VkAFi5yyrC51+v1BCKfe/yVg+IrfAOn7fA3hlYbFx2x3MlaRiSLPJE4VZd
	 RLOqU027ATkqs4eh/luyK/BPTn5xqC+xCkF8G9hKFP5mgORNc7O7Y5AuUKqZDb9K8P
	 Noi7eL3YTluI+cIJu+Bcn2jP4fYy0heTYcBJHF6QfERcN8r06TXJiHs0ndx7YGOcIe
	 QbXXYfS865f8w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen-Yu Tsai <wenst@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sean.wang@kernel.org,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-mediatek@lists.infradead.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18] pinctrl: mediatek: common-v1: bypass pinctrl GPIO layer in set GPIO direction
Date: Mon, 31 Aug 2026 09:23:21 -0400
Message-ID: <20260831133314.4125787-173-sashal@kernel.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 3982db2df3ed4c195e5f0a9a4513545a15901107 ]

pinctrl_gpio_direction_input() / pinctrl_gpio_direction_output() take
the pinctrl mutex. This causes a gpiochip operations to need to sleep.
Worse yet, the .can_sleep field in the gpiochip is not set. This causes
the shared GPIO proxy to trip over, as it uses gpiod_cansleep() to check
whether it can use a spinlock or needs a mutex. In this case, it ends
up taking a spinlock, then calls pinctrl_gpio_direction_output(), which
takes a mutex. This causes a huge warning.

Since the Mediatek hardware has separate clear/set registers, there is
no risk of clobbering other bits like with a read-modify-write pattern.
Also, once the GPIO function is selected / muxed in, further GPIO
operations do not involve pinctrl operations or state. The GPIO direction
and level values do not require toggling the pinmux or any other pin config
options.

Switch to directly calling mtk_pmx_gpio_set_direction() in the GPIO set
direction callbacks to avoid taking the pinctrl mutex. Drop the
.gpio_set_direction field in mtk_pmx_ops to signal we are no longer using
the pinctrl GPIO layer for setting the direction.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `pinctrl: mediatek: common-v1: bypass
pinctrl GPIO layer in set GPIO direction`

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`, `make kernelversion` → `6.18.43`)

**Upstream commit:** `3982db2df3ed4c195e5f0a9a4513545a15901107`
**Status in this tree:** Buggy code is **present**; fix is **not**
applied (`git apply --check` succeeds).

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[pinctrl: mediatek: common-v1]` `[bypass]` — bypass the
pinctrl GPIO helper layer when setting GPIO direction on MediaTek
common-v1 pinctrl.

### Step 1.2: Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none (Linus Walleij merged with "Patch applied")
- **Acked-by:** — none
- **Link:** — none in commit; v2 references v1 at `https://lore.kernel.o
  rg/all/20260427061720.2393355-1-wenst@chromium.org/`
- **Cc: stable:** — none
- **Signed-off-by:** Chen-Yu Tsai `<wenst@chromium.org>`, Linus Walleij
  `<linusw@kernel.org>`

**Notable:** Author is from Chromium; patch went through v1→v2. No
syzbot/fuzzer report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `pinctrl_gpio_direction_input/output()` take the pinctrl
  mutex, making GPIO direction ops sleepable, but the MediaTek gpiochip
  does not set `.can_sleep`. A shared GPIO proxy/forwarder uses
  `gpiod_cansleep()` to choose spinlock vs mutex; it picks spinlock,
  then direction ops take a mutex → large kernel warning.
- **Symptom:** Lockdep / invalid-context warnings (mutex under
  spinlock).
- **Root cause:** Mismatch between advertised non-sleeping GPIO chip and
  sleeping pinctrl mutex path.
- **Fix rationale:** After muxing to GPIO, direction changes are plain
  register writes (separate set/clear regs); no pinmux state change
  needed.

### Step 1.4: Hidden bug fix?
**Record:** **Yes** — despite “bypass” wording, this is a real lock-
context / `can_sleep` contract bug, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/pinctrl/mediatek/pinctrl-mtk-common.c` (+10 / −3,
  13 lines net)
- **Functions:** new `mtk_gpio_direction_input()`; modified
  `mtk_gpio_direction_output()`; `mtk_pmx_ops`, `mtk_gpio_chip`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow per hunk
**Record:**
1. **Remove `.gpio_set_direction` from `mtk_pmx_ops`:** pinmux layer no
   longer exposes direction via pinctrl GPIO API (returns 0/no-op if
   called through `pinmux_gpio_direction()`).
2. **Add `mtk_gpio_direction_input()`:** calls
   `mtk_pmx_gpio_set_direction()` directly via `pctl->pctl_dev`.
3. **Change `mtk_gpio_direction_output()`:** replaces
   `pinctrl_gpio_direction_output()` with direct
   `mtk_pmx_gpio_set_direction()`.
4. **Wire `.direction_input`:** `pinctrl_gpio_direction_input` →
   `mtk_gpio_direction_input`.

**Before:** gpiochip direction callbacks → `pinctrl_gpio_direction_*()`
→ `mutex_lock(&pctldev->mutex)` → `mtk_pmx_gpio_set_direction()`.
**After:** gpiochip direction callbacks → `mtk_pmx_gpio_set_direction()`
directly (regmap write, no mutex).

### Step 2.3: Bug mechanism
**Record:** **Category:** synchronization / lock-context violation
(mutex-from-non-sleeping-GPIO path).
**Mechanism:** Driver advertises fast GPIO (`can_sleep` unset/false) but
direction ops sleep on pinctrl mutex. GPIO forwarder (`gpio-
aggregator.c`) uses spinlock when `!chip->can_sleep`, creating mutex-
under-spinlock when direction changes propagate through the forwarder.

### Step 2.4: Fix quality
**Record:** **Obviously correct** for this hardware —
`mtk_pmx_gpio_set_direction()` already does atomic set/clear register
writes and is used directly elsewhere in the same file (pinconf, EINT
setup). **Low regression risk** — removes redundant mutex layer; pinconf
paths unchanged. **Minor note:** removing `.gpio_set_direction` makes
pinctrl-framework direction calls no-ops, which is intentional since
GPIO chip handles direction directly.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** In this shallow stable checkout, blame points to merge
`5d324e5159d9e`. Verified at tags: **v6.6, v6.12, v6.18** all contain
`pinctrl_gpio_direction_input` in direction callbacks (bug predates 6.18
branch).

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** In 6.18.43 tree, only two commits touch this file
(`936a3c0c10e2b` EINT probe fix, merge import). On mainline
(`build/master`), file was re-added in `a293ec25d59dd` (May 2026
refactor) already containing the buggy pattern; fix landed 7 days later
in `3982db2df3ed`.

### Step 3.4: Author context
**Record:** Chen-Yu Tsai (Chromium). Linus Walleij (pinctrl/gpio
maintainer) merged. Related nearby work: Bartosz Golaszewski’s GPIO
setter callback conversion (`23a5fa371c772`).

### Step 3.5: Dependencies
**Record:** **Standalone.** Requires `mtk_pinctrl::pctl_dev` and
`mtk_pmx_gpio_set_direction()` — both present in 6.18.43. `git apply
--check` on upstream diff: **clean apply**.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 3982db2df3ed` →
https://patch.msgid.link/20260505104056.1812343-1-wenst@chromium.org
**Series:** v2 only in matched thread (v1 at separate URL). Linus
Walleij: “Patch applied.”
**Stable nomination:** None found.
**NAKs/concerns:** None in thread.

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC’d Sean Wang, Matthias Brugger,
AngeloGioacchino Del Regno, Linus Walleij, linux-mediatek, linux-gpio,
linux-arm-kernel.

### Step 4.3: Bug report
**Record:** No external bug report. Author notes **“Only compile
tested”** and initially fixed wrong file (target used `pinctrl-
paris.c`).

### Step 4.4: Series context
**Record:** Standalone 1-patch fix for `pinctrl-mtk-common.c`
(common-v1). Paris driver may need a separate fix (out of scope).

### Step 4.5: Stable list
**Record:** Not searched on lore stable (WebFetch blocked for lore). No
stable discussion in mbox thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `mtk_gpio_direction_input()` (new),
`mtk_gpio_direction_output()`, `mtk_pmx_gpio_set_direction()`,
`pinctrl_gpio_direction()` in `core.c`.

### Step 5.2: Callers
**Record:** Direction callbacks invoked from gpiolib
(`gpiod_direction_input/output` → `gpiochip_direction_*`). Reachable
from device drivers, GPIO forwarder (`gpio_fwd_direction_input/output`
in `gpio-aggregator.c`), and userspace via gpio-cdev.

### Step 5.3: Callees
**Record:** `mtk_pmx_gpio_set_direction()` → `regmap_write()` on
set/clear direction registers — no mutex, no sleeping primitives.

### Step 5.4: Reachability
**Record:** **Userspace-reachable** via GPIO character device. **Driver-
reachable** on any MediaTek v1 pinctrl platform (`CONFIG_PINCTRL_MTK`).
Trigger is most visible when GPIOs are accessed through a GPIO
forwarder/proxy that assumes non-sleeping ops.

### Step 5.5: Similar patterns
**Record:** Same `pinctrl_gpio_direction_*` pattern exists in `pinctrl-
moore.c`, `pinctrl-airoha.c` (same subsystem, different drivers — not
fixed by this commit).

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree at lines 805, 818, 898 uses
`pinctrl_gpio_direction_input/output` and `.gpio_set_direction =
mtk_pmx_gpio_set_direction`. `can_sleep` is never set on the gpiochip.

### Step 6.2: Backport complications
**Record:** **Clean apply** verified. No structural conflicts in
6.18.43.

### Step 6.3: Related fixes already present?
**Record:** **No** — `git log --grep="bypass pinctrl GPIO"` returns
nothing in this tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem / criticality
**Record:** `drivers/pinctrl/mediatek/` — **IMPORTANT** (ARM/ARM64
embedded SoCs: MT27xx, MT81xx, MT83xx families via
`CONFIG_PINCTRL_MTK`).

### Step 7.2: Activity
**Record:** Active; recent stable fix `936a3c0c10e2b` (EINT probe) in
same file.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of MediaTek **common-v1** pinctrl
(`CONFIG_PINCTRL_MTK`), especially platforms using GPIO
forwarding/sharing (Chromebook-class devices per author).

### Step 8.2: Trigger conditions
**Record:** GPIO direction change on a MediaTek v1 GPIO line,
particularly when accessed through a non-sleeping GPIO forwarder. Not
every GPIO toggle hits this — direction changes are the trigger.
Unprivileged users can trigger via GPIO uAPI if lines are
exported/accessible.

### Step 8.3: Failure mode severity
**Record:** **MEDIUM–HIGH** — kernel warnings / lockdep complaints
(“huge warning” per author); mutex under spinlock can escalate to hangs
on debug kernels. Not a typical memory-corruption bug, but a real
correctness violation in a common driver path.

### Step 8.4: Risk vs benefit
**Record:**
- **Benefit:** MEDIUM–HIGH for affected MediaTek platforms; fixes
  longstanding contract violation.
- **Risk:** LOW — 13-line change, maintainer-merged, uses existing
  internal helper already used elsewhere in driver.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: sleeping pinctrl mutex from non-sleeping gpiochip callbacks
- Bug present in 6.18.43 (verified in source)
- Small, self-contained, applies cleanly
- Maintainers merged (Linus Walleij)
- Fixes lock-context violation with concrete failure mode
- Hardware-appropriate: direct register writes are safe post-mux

**AGAINST backport:**
- Author only compile-tested (no runtime Tested-by)
- No syzbot/CVE/user bug report
- Trigger may be most visible on Chromebook + GPIO-proxy setups
- Severity is WARN/lockdep, not proven crash/oops in mainline report

**Unresolved:** Exact in-tree “GPIO proxy” component name unverified in
mainline (likely GPIO forwarder in `gpio-aggregator.c` or ChromeOS-
specific code); runtime reproduction not documented in mailing list.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** (logically correct; compile-
   tested; maintainer merged)
2. Fixes real bug affecting users? **PASS** (lock-context violation on
   real hardware class)
3. Important issue? **PASS** (lockdep / invalid context — MEDIUM–HIGH)
4. Small and contained? **PASS** (1 file, 13 lines)
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** (clean `git apply --check`)

### Step 9.3: Exception categories
**Record:** None (not device-ID/quirk/docs/build fix) — standard driver
bug fix.

### Step 9.4: Decision rationale
For **Linux 6.18.43**, the buggy pattern exists, the fix is minimal and
correct, and it resolves a real synchronization contract violation in a
widely used embedded pinctrl driver. The conservative stable bar is met:
real bug, contained fix, low regression risk, clear maintainer
acceptance.

---

## Verification

- **[Phase 1]** Parsed commit message/tags from `git show 3982db2df3ed`
  and user-provided text
- **[Phase 1]** `b4 dig -c 3982db2df3ed`: lore URL
  https://patch.msgid.link/20260505104056.1812343-1-wenst@chromium.org
- **[Phase 1]** `b4 dig -a`: v2 series found; v1 referenced in mbox body
- **[Phase 1]** `b4 dig -w`: maintainers CC list retrieved
- **[Phase 2]** Read current `pinctrl-mtk-common.c` lines 65–87,
  800–904, 1116–1128
- **[Phase 2]** Read `drivers/pinctrl/core.c` lines 855–876:
  `pinctrl_gpio_direction()` takes `mutex_lock`
- **[Phase 2]** Read `drivers/gpio/gpio-aggregator.c` lines 327–342,
  406–421: spinlock when `!chip->can_sleep`
- **[Phase 2]** `git show 3982db2df3ed`: full diff reviewed
- **[Phase 3]** `git describe HEAD`, `make kernelversion`: tree is
  6.18.43
- **[Phase 3]** `git show v6.6/v6.12/v6.18:...`: buggy
  `pinctrl_gpio_direction_input` pattern present at all three tags
- **[Phase 3]** `git apply --check` on upstream patch: succeeds on
  current tree
- **[Phase 4]** `b4 dig -m /tmp/mtk-gpio-thread.mbox`: thread saved;
  Linus Walleij “Patch applied”; author “Only compile tested”
- **[Phase 5]** Traced `gpiod_direction_input/output` → gpiochip
  callbacks in `gpiolib.c`
- **[Phase 6]** `grep` on current tree: buggy code at lines 805, 818,
  898; no `can_sleep` set
- **[Phase 6]** Fix not in HEAD: `merge-base --is-ancestor 3982db2df3ed
  HEAD` → not ancestor
- **[Phase 7]** `drivers/pinctrl/mediatek/Makefile`:
  `CONFIG_PINCTRL_MTK` builds `pinctrl-mtk-common.o`
- **UNVERIFIED:** Exact ChromeOS “GPIO proxy” driver name in mainline
  (no `gpio_proxy` string found; forwarder mechanism verified in `gpio-
  aggregator.c`)

**YES**The backport analysis is complete.

**Verdict for Linux 6.18.43: YES** — the MediaTek common-v1 pinctrl
driver advertises non-sleeping GPIO ops but uses
`pinctrl_gpio_direction_*()` (which takes the pinctrl mutex), causing
lock-context warnings when GPIOs are used through a forwarder/proxy. The
fix is small (13 lines), applies cleanly, and is already merged upstream
by Linus Walleij.

A background `git branch --contains` check for which branches have the
fix failed (likely due to repo size/timeout). That wasn’t needed for the
decision: the fix is **not** in your current 6.18.43 checkout, and the
buggy code is present there.

 drivers/pinctrl/mediatek/pinctrl-mtk-common.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
index 3f518dce6d23f..dd2c8aa039385 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -802,20 +802,27 @@ static const struct pinmux_ops mtk_pmx_ops = {
 	.get_function_name	= mtk_pmx_get_func_name,
 	.get_function_groups	= mtk_pmx_get_func_groups,
 	.set_mux		= mtk_pmx_set_mux,
-	.gpio_set_direction	= mtk_pmx_gpio_set_direction,
 	.gpio_request_enable	= mtk_pmx_gpio_request_enable,
 };
 
+static int mtk_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct mtk_pinctrl *pctl = gpiochip_get_data(chip);
+
+	return mtk_pmx_gpio_set_direction(pctl->pctl_dev, NULL, offset, true);
+}
+
 static int mtk_gpio_direction_output(struct gpio_chip *chip,
 					unsigned offset, int value)
 {
+	struct mtk_pinctrl *pctl = gpiochip_get_data(chip);
 	int ret;
 
 	ret = mtk_gpio_set(chip, offset, value);
 	if (ret)
 		return ret;
 
-	return pinctrl_gpio_direction_output(chip, offset);
+	return mtk_pmx_gpio_set_direction(pctl->pctl_dev, NULL, offset, false);
 }
 
 static int mtk_gpio_get_direction(struct gpio_chip *chip, unsigned offset)
@@ -895,7 +902,7 @@ static const struct gpio_chip mtk_gpio_chip = {
 	.request		= gpiochip_generic_request,
 	.free			= gpiochip_generic_free,
 	.get_direction		= mtk_gpio_get_direction,
-	.direction_input	= pinctrl_gpio_direction_input,
+	.direction_input	= mtk_gpio_direction_input,
 	.direction_output	= mtk_gpio_direction_output,
 	.get			= mtk_gpio_get,
 	.set			= mtk_gpio_set,
-- 
2.53.0

