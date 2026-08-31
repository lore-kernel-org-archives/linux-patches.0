Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EF64B5CA2;
	Mon, 31 Aug 2026 13:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184371; cv=none; b=F/IUYmo11o7tN5+EQLrZqcdUszFw9xpqx/8Dc4ev29FA9nSM8L/tn2HJvfy6IaKZgcDw7ChfAiCybWD+KULDMpjXlDhgrQBgprqFnA4cADGJxlu76ZiZFdiUwYr9VYu6K/wMXFxgqniXjbfFvP+4vLKMWfJK1yV7rDdPLNoflBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184371; c=relaxed/simple;
	bh=/9UqlPhhe7+ygd1GkSO3VgeE+YarX18Xs1szpJ0i2Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IDsoUMW72hLYy9QvClSqJBO+AvjV+k4GnLYrx3O77Avc4bHzZ3yA123e245q2gTk84PkKds2fj20HcQyPo3NjMCk0LWaQ2eOjWrCpkfk7kBHz3bsyElapbWU12lKiOd/GkqASPwHMhT8m736URje220jJ/UhEGJUnMpRdTruXi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iv1p65Vb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iv1p65Vb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30E71F00A3D;
	Mon, 31 Aug 2026 13:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184368;
	bh=xHZ8Z3uhEE9sHeEynKza9pRWytrjKi05lYcLTcYnbwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iv1p65Vbq2pF/wgGrCiQrfYZ6sl4g911WdYG3kium1pLBr7X3BjR9cEDdQocthcxU
	 /orkQgWQVEUojHy2Cz/E8rhRPS0uswF217WFG/sccGTtn+lxmtWYLslRJScWXm+8D1
	 tDADhF2RNVh4rC8yU5OzYRGC8g7qovXLqxapTENvGibdV23Fvj5XnpF+PoDokmUfN1
	 mrDUgJKB4Qirqqjv6RPeSbsyojq/7/MmCzQKUzHdR5blgR6ouJOqXTuOO8kBImbfqy
	 CCooONVt+4dVZMMKncUwyD0D9KUl3jlV7bOWUxpZ3wZIsGDAL+fu/MTUrv7ue4bk/p
	 OjFfHJk0AdLUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Linus Walleij <linusw@kernel.org>,
	=?UTF-8?q?Micha=C5=82=20K=C4=99pie=C5=84?= <kernel@kempniu.pl>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	albeu@free.fr,
	brgl@kernel.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: ath9k: Obtain system GPIOS from descriptors
Date: Mon, 31 Aug 2026 09:31:20 -0400
Message-ID: <20260831133314.4125787-652-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 34a5329beee86a22a446e27eb37f06caa63479ca ]

The ath9k has an odd use of system-wide GPIOs: if the chip
does not have internal GPIO capability, it will try to obtain a
GPIO line from the system GPIO controller:

  if (BIT(gpio) & ah->caps.gpio_mask)
        ath9k_hw_gpio_cfg_wmac(...);
  else if (AR_SREV_SOC(ah))
        ath9k_hw_gpio_cfg_soc(ah, gpio, out, label);

Where ath9k_hw_gpio_cfg_soc() will attempt to issue
gpio_request_one() passing the local GPIO number of the controller
(0..31) to gpio_request_one().

This is somewhat peculiar and possibly even dangerous: there is
nowadays no guarantee of the numbering of these system-wide
GPIOs, and assuming that GPIO 0..31 as used by ath9k would
correspond to GPIOs 0..31 on the system as a whole seems a bit
wild.

Register all 32 GPIOs at index 0..31 directly in the ATH79K
GPIO driver and associate with the NULL device (making them
widely available) if and only if we are probing ATH79K wifi
from the AHB bus (used for SoCs). We obtain these offsets from
the NULL device if necessary.

These GPIOs should ideally be defined in the device tree
instead, but we have no control over that for the legacy
code path.

Testcompiled with the ath79 defconfig.

Reported-by: Michał Kępień <kernel@kempniu.pl>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Tested-by: Michał Kępień <kernel@kempniu.pl>
Link: https://patch.msgid.link/20260317-descriptors-wireless-v6-1-b19ecff9cd2b@kernel.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 2)...
Retry attempt 2...
# Stable Backport Analysis: `wifi: ath9k: Obtain system GPIOS from
descriptors`

**Local tree:** Linux **6.18.43** (`git describe HEAD` → `v6.18.43`,
`make kernelversion` → `6.18.43`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[wifi: ath9k]` `[obtain]` — Switch ath9k SoC GPIO handling
from legacy global GPIO numbers to GPIO descriptors obtained via lookup
tables.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
| Tag | Value |
|-----|-------|
| Reported-by | Michał Kępień \<kernel@kempniu.pl\> |
| Tested-by | Michał Kępień \<kernel@kempniu.pl\> |
| Acked-by | Toke Høiland-Jørgensen, Bartosz Golaszewski |
| Reviewed-by | Andy Shevchenko |
| Signed-off-by | Linus Walleij, Jeff Johnson |
| Link | https://patch.msgid.link/20260317-descriptors-
wireless-v6-1-b19ecff9cd2b@kernel.org |
| Fixes: | Not present (expected) |
| Cc: stable | Not present (expected) |

**Notable patterns:** Real-world reporter who also tested the fix; GPIO
subsystem maintainer (Bartosz Golaszewski) and GPIO expert (Andy
Shevchenko) reviewed/acked. No syzbot report.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug description:** On ath79 SoC platforms, when ath9k lacks internal
  GPIO capability for a line, `ath9k_hw_gpio_cfg_soc()` calls
  `gpio_request_one()` with chip-local offsets (0–31), assuming they map
  to global GPIO numbers 0–31. That assumption is invalid with modern
  dynamic GPIO base allocation.
- **Symptom/failure mode:** GPIO request fails or maps to the wrong
  system GPIO line; LED, rfkill, and other SoC GPIO-dependent features
  break.
- **Root cause:** Legacy global GPIO API used with dynamically allocated
  GPIO chip bases after gpio-ath79 moved to `gpio_generic_chip`.
- **Fix approach:** Register a `gpiod_lookup_table` in gpio-ath79 (when
  `CONFIG_ATH9K_AHB`) and obtain descriptors via `gpiod_get_index(NULL,
  "ath9k", gpio, flags)` in ath9k.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised cleanup — explicitly a correctness fix for
broken GPIO mapping on ath79/ath9k AHB SoCs. Falls under the hardware
quirk/workaround exception category.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
| File | +/- | Functions modified |
|------|-----|-------------------|
| `drivers/gpio/gpio-ath79.c` | +56/-1 |
`ath79_gpio_register_wifi_descriptors()` (new), `ath79_gpio_probe()` |
| `drivers/net/wireless/ath/ath9k/hw.c` | +22/-11 |
`ath9k_hw_gpio_cfg_soc()`, `ath9k_hw_gpio_free()`,
`ath9k_hw_gpio_get()`, `ath9k_hw_set_gpio()` |
| `drivers/net/wireless/ath/ath9k/hw.h` | +2/-1 | `struct ath_hw`,
`struct ath9k_hw_capabilities` |

**Scope:** Multi-file but surgical (~80 lines total). Self-contained
within gpio-ath79 + ath9k.

### Step 2.2: CODE FLOW CHANGE (per hunk)
**Record:**
1. **gpio-ath79.c probe:** After `devm_gpiochip_add_data()`, register 32
   lookup entries mapping chip offsets 0–31 to consumer `"ath9k"`
   indices 0–31 on the NULL device.
2. **ath9k_hw_gpio_cfg_soc():** `devm_gpio_request_one(ah->dev, gpio,
   ...)` → `gpiod_get_index(NULL, "ath9k", gpio, flags)`; store in
   `ah->gpiods[gpio]`.
3. **ath9k_hw_gpio_get/set_gpio():** `gpio_get_value(gpio)` /
   `gpio_set_value(gpio, val)` → `gpiod_get_value()` /
   `gpiod_set_value()` on stored descriptors.
4. **ath9k_hw_gpio_free():** Clear bit in `gpio_requested` →
   `gpiod_put()` and NULL the descriptor.
5. **hw.h:** Replace `caps.gpio_requested` bitmask with `struct
   gpio_desc *gpiods[32]`.

### Step 2.3: BUG MECHANISM
**Record:** **Category:** Logic/correctness + hardware workaround.
- **Broken:** `gpio_request_one()` and
  `gpio_get_value()`/`gpio_set_value()` used chip-local GPIO indices as
  global GPIO numbers.
- **With dynamic bases** (gpio-ath79 uses `gpio_generic_chip` in this
  tree), local offset 11 ≠ global GPIO 523 (512+11 as seen on OpenWrt).
- **Fix:** Descriptor-based GPIO via lookup table bridges ath9k consumer
  to the correct ath79 GPIO chip lines.

### Step 2.4: FIX QUALITY
**Record:** Fix is obviously correct for the stated problem. Minimal,
follows established `gpiod_add_lookup_table()` patterns. Uses non-devm
`gpiod_get_index()` with manual `gpiod_put()` — appropriate for NULL-
device legacy lookup. Low regression risk; guarded by `CONFIG_ATH9K_AHB`
in gpio-ath79. v6 incorporated reporter feedback from v2 (NULL device
matching, correct `GPIO_LOOKUP_IDX` offsets).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** `git blame` on `hw.c:2719–2735` attributes all lines to
merge commit `5d324e5159d9e` (stable tree squash). Limited per-line
history in this checkout. Buggy `devm_gpio_request_one()` pattern is
present in current 6.18.43 tree at line 2727.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** `git log --oneline -20 -- hw.c` and `gpio-ath79.c` only show
merge commits in this stable checkout (shallow/squashed history). Patch
evolved v1→v2→v3→v4→v6 per `b4 dig -a`; v6 is the committed/applied
version. Standalone — not dependent on other patches in the original 1/6
series.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Linus Walleij is GPIO subsystem maintainer. Long-running
effort to remove global GPIO numbers from ath9k (since v1 in Jan 2024).

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** Requires gpio-ath79 `gpio_generic_chip` refactor (already
present in 6.18.43). Requires `linux/gpio/machine.h`, `gpiod_get_index`,
`gpiod_set_consumer_name`, `struct_size` — all verified present. Uses
`ctrl->chip.gc.label` which matches current gpio-ath79 structure. **Can
apply standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: ORIGINAL PATCH DISCUSSION
**Record:**
- **URL:** https://patch.msgid.link/20260317-descriptors-
  wireless-v6-1-b19ecff9cd2b@kernel.org
- **Series:** v1 (2024-01-31) → v2 (2024-04-23) → v3/v4 (2026-03) → **v6
  (2026-03-17, final)**
- **Key reviewer feedback (v2, Michał Kępień):** Original v2 had wrong
  lookup table `dev_id` and `chip_hwnum`; suggested NULL-device +
  `"ath9k"` con_id matching — incorporated in final patch.
- **Stable nominations:** None found in saved mbox thread.

### Step 4.2: WHO REVIEWED
**Record (`b4 dig -w`):** Linus Walleij, Jeff Johnson, Andy Shevchenko,
Arnd Bergmann, Alban Bedel, Bartosz Golaszewski, Toke Høiland-Jørgensen,
Michał Kępień; CC'd linux-wireless@, linux-gpio@.

### Step 4.3: BUG REPORT
**Record:**
- **OpenWrt issue:** Mikrotik RouterBOARD 951Ui-2HnD (AR9344) WLAN LED
  broken since ath79 switched to dynamic GPIO base allocation (July
  2024). Reporter confirmed GPIO chip works at global offset 523
  (=512+11) but ath9k driver could not reach it via legacy API.
- **Severity:** Functional hardware breakage on ath79 routers; not a
  kernel crash.

### Step 4.4: RELATED PATCHES
**Record:** Part of a longer ath9k GPIO-descriptor migration series, but
this commit is self-contained for the ath79 AHB legacy path.

### Step 4.5: STABLE MAILING LIST
**Record:** No stable-specific discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
**Record:** `ath79_gpio_register_wifi_descriptors()`,
`ath9k_hw_gpio_cfg_soc()`, `ath9k_hw_gpio_get()`, `ath9k_hw_set_gpio()`,
`ath9k_hw_gpio_free()`, `ath9k_hw_gpio_request()`.

### Step 5.2: TRACE CALLERS
**Record:** `ath9k_hw_gpio_request_{in,out}()` called from:
- `gpio.c` — WLAN LED (`ath_fill_led_pin`, led on/off)
- `gpio.c` — rfkill GPIO read
- `btcoex.c` — Bluetooth coexistence GPIOs
- `main.c` — LED pin setup
- `hw.c` — rfkill init, chainmask GPIO read

**Context:** Device probe and runtime on ath79 SoC routers with
`CONFIG_ATH9K_AHB`.

### Step 5.3: TRACE CALLEES
**Record:** `gpiod_get_index()`, `gpiod_get_value()`,
`gpiod_set_value()`, `gpiod_put()`, `gpiod_add_lookup_table()`,
`GPIO_LOOKUP_IDX()`.

### Step 5.4: CALL CHAIN / REACHABILITY
**Record:** Triggered during ath9k AHB WiFi driver probe and
LED/rfkill/btcoex operation on AR9340/AR9531/AR9550/AR9561 SoCs
(`AR_SREV_SOC`). GPIOs outside `gpio_mask` (e.g., AR9340 mask = `0xF`,
LED on GPIO 11) take the broken `ath9k_hw_gpio_cfg_soc()` path.
**Reachable on every boot** for affected ath79 boards with external GPIO
lines.

### Step 5.5: SIMILAR PATTERNS
**Record:** Other drivers use `gpiod_add_lookup_table()` +
`GPIO_LOOKUP_IDX()` for board-specific GPIO wiring (e.g.,
`sound/soc/samsung/speyside.c`, `drivers/usb/dwc3/dwc3-pci.c`). Same
established pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.43)

### Step 6.1: DOES THE BUGGY CODE EXIST?
**Record:** **YES.** Current tree has:
- `devm_gpio_request_one(ah->dev, gpio, ...)` at `hw.c:2727`
- `gpio_get_value(gpio)` / `gpio_set_value(gpio, val)` at
  `hw.c:2826,2850`
- `gpio-ath79.c` already uses `gpio_generic_chip` (dynamic GPIO bases)
- `CONFIG_ATH9K_AHB` exists in Kconfig; enabled in
  `arch/mips/configs/ath79_defconfig`

The fix is **not** yet in 6.18.43 (mainline commit `34a5329`, dated
2026-03-17).

### Step 6.2: BACKPORT COMPLICATIONS
**Record:** **Clean apply expected.** Current gpio-ath79 structure
(`ctrl->chip.gc.label`, `gpio_generic_chip_init`) matches the patch. No
conflicting changes detected.

### Step 6.3: RELATED FIXES ALREADY PRESENT?
**Record:** `git log --grep` found no related fix already in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM AND CRITICALITY
**Record:** **Subsystem:** `drivers/gpio` +
`drivers/net/wireless/ath/ath9k` — **IMPORTANT** (embedded router
WiFi/GPIO, not core kernel path).

### Step 7.2: SUBSYSTEM ACTIVITY
**Record:** gpio-ath79 recently refactored to `gpio_generic_chip`
(dynamic bases), which exposed this long-standing ath9k assumption.
Active area for ath79/OpenWrt platforms.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
**Record:** **Platform-specific:** MIPS ath79 SoC devices with built-in
ath9k WiFi (`CONFIG_ATH9K_AHB=y`). Common in OpenWrt routers (TP-Link,
Mikrotik, etc.). Not universal.

### Step 8.2: TRIGGER CONDITIONS
**Record:** Boot with ath9k AHB on AR9340/AR9531/AR9550/AR9561 when a
GPIO line outside the chip's internal `gpio_mask` is needed (WLAN LED,
rfkill, btcoex). **Common on affected hardware.** Not a userspace-
triggerable security issue.

### Step 8.3: FAILURE MODE SEVERITY
**Record:**
- GPIO request failure → WLAN LED non-functional, rfkill/btcoex GPIO
  broken
- Wrong GPIO mapping → could toggle unrelated hardware lines (author:
  "possibly even dangerous")
- **Severity: MEDIUM-HIGH** for affected platforms (functional breakage
  + potential wrong-pin control); **not CRITICAL** (no crash,
  corruption, or security CVE)

### Step 8.4: RISK-BENEFIT
**Record:**
- **Benefit:** Restores correct GPIO operation on ath79 routers; fixes
  user-reported OpenWrt breakage; eliminates dangerous wrong-GPIO
  mapping
- **Risk:** Very low — ~80 lines, well-reviewed, compile-time gated,
  established API pattern
- **Ratio:** Strong benefit for affected users, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE SUMMARY

**FOR backport:**
- Real user-reported bug (Michał Kępień / OpenWrt, Mikrotik AR9344)
- Tested-by reporter on real hardware
- Reviewed by GPIO and wireless maintainers
- Buggy code confirmed present in 6.18.43
- gpio-ath79 already uses dynamic GPIO bases — legacy ath9k code is
  broken
- Small, surgical, self-contained fix
- Hardware quirk/workaround exception applies
- Wrong GPIO line control is a safety concern on embedded hardware

**AGAINST backport:**
- Only affects ath79 + ATH9K_AHB platforms (niche vs. entire kernel)
- Primary visible symptom is WLAN LED / GPIO features, not crashes
- No explicit stable nomination in review thread
- Part of a longer GPIO-descriptor migration (though this patch stands
  alone)

**Unresolved:** Exact kernel version when gpio-ath79 gained
`gpio_generic_chip` cannot be determined from this stable tree's git
history (squashed).

### Step 9.2: STABLE RULES CHECKLIST
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — Reviewed by GPIO
maintainers; Tested-by reporter |
| 2. Fixes a real bug affecting users? | **PASS** — OpenWrt/ath79 router
GPIO breakage confirmed |
| 3. Important issue? | **PASS** — Functional hardware breakage + wrong
GPIO mapping risk on embedded platforms |
| 4. Small and contained? | **PASS** — ~80 lines, 3 files |
| 5. No new features/APIs? | **PASS** — Uses existing gpiod lookup
infrastructure; legacy workaround only |
| 6. Can apply to local tree? | **PASS** — Code matches; prerequisites
present |

### Step 9.3: EXCEPTION CATEGORY
**Record:** **Hardware quirk/workaround** — legacy ath79/ath9k GPIO path
fix for SoCs where device tree does not describe these lines.

### Step 9.4: DECISION RATIONALE

For **Linux 6.18.43**, this commit should be backported. The buggy
legacy GPIO code is present, gpio-ath79 already uses dynamic GPIO
numbering that breaks the old assumptions, and real users on ath79
routers (OpenWrt, Mikrotik, etc.) have confirmed WLAN LED and related
GPIO functionality is broken without this fix. The patch is small, well-
reviewed, tested on hardware, and applies cleanly to the current tree
structure.

---

## Verification

- [Phase 1] Parsed tags: Reported-by/Tested-by Michał Kępień; Reviewed-
  by Andy Shevchenko; Acked-by Bartosz Golaszewski, Toke Høiland-
  Jørgensen
- [Phase 1] No Fixes:/Cc: stable tags (expected)
- [Phase 2] Diff: 3 files, ~+80/-13; gpio lookup table + gpiod
  descriptor migration in ath9k
- [Phase 2] Verified buggy code: `devm_gpio_request_one()` at hw.c:2727,
  `gpio_get_value(gpio)` at hw.c:2826
- [Phase 3] `git describe HEAD`: v6.18.43; `make kernelversion`: 6.18.43
- [Phase 3] `git blame hw.c:2719-2735`: lines present with legacy API
  (history squashed to merge commit)
- [Phase 3] No Fixes: tag to follow
- [Phase 4] `b4 dig -c 34a5329`: matched v6 thread at
  patch.msgid.link/20260317-descriptors-
  wireless-v6-1-b19ecff9cd2b@kernel.org
- [Phase 4] `b4 dig -a`: v1→v2→v3→v4→v6 series; v6 is latest
- [Phase 4] `b4 dig -w`: GPIO and wireless maintainers CC'd
- [Phase 4] Spinics v2 reply from Michał Kępień: documents OpenWrt
  breakage and lookup table fixes
- [Phase 4] OpenWrt PR #17402: Mikrotik AR9344 WLAN LED broken since
  dynamic GPIO bases
- [Phase 4] No stable nomination found in mbox thread
- [Phase 5] Callers verified via grep: gpio.c, btcoex.c, main.c, hw.c
- [Phase 5] AR9340_GPIO_MASK = 0xF — GPIO 11 (reported LED pin) uses soc
  path outside mask
- [Phase 6] Buggy code confirmed present; fix NOT present in 6.18.43
- [Phase 6] gpio-ath79 uses `gpio_generic_chip` in current tree
- [Phase 6] `CONFIG_ATH9K_AHB` exists; `linux/gpio/machine.h` and
  `gpiod_*` APIs present
- [Phase 6] Patch uses `ctrl->chip.gc.label` matching current gpio-ath79
  structure
- [Phase 8] Failure mode: GPIO misrouting / LED-rfkill-btcoex breakage
  on ath79 SoCs; severity MEDIUM-HIGH for affected hardware
- UNVERIFIED: Exact upstream commit that introduced gpio-ath79
  `gpio_generic_chip` refactor (stable tree history is squashed)

**YES**

 drivers/gpio/gpio-ath79.c           | 57 ++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.c | 33 +++++++++++------
 drivers/net/wireless/ath/ath9k/hw.h |  3 +-
 3 files changed, 80 insertions(+), 13 deletions(-)

diff --git a/drivers/gpio/gpio-ath79.c b/drivers/gpio/gpio-ath79.c
index 2ad9f6ac66362..85bd994d15d48 100644
--- a/drivers/gpio/gpio-ath79.c
+++ b/drivers/gpio/gpio-ath79.c
@@ -11,6 +11,7 @@
 #include <linux/device.h>
 #include <linux/gpio/driver.h>
 #include <linux/gpio/generic.h>
+#include <linux/gpio/machine.h> /* For WLAN GPIOs */
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/mod_devicetable.h>
@@ -214,6 +215,56 @@ static const struct of_device_id ath79_gpio_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ath79_gpio_of_match);
 
+#if IS_ENABLED(CONFIG_ATH9K_AHB)
+/*
+ * This registers all of the ath79k GPIOs as descriptors to be picked
+ * directly from the ATH79K wifi driver if the two are jitted together
+ * in the same SoC.
+ */
+#define ATH79K_WIFI_DESCS 32
+static int ath79_gpio_register_wifi_descriptors(struct device *dev,
+						const char *label)
+{
+	struct gpiod_lookup_table *lookup;
+	int i;
+
+	/* Create a gpiod lookup using gpiochip-local offsets + 1 for NULL */
+	lookup = devm_kzalloc(dev,
+			      struct_size(lookup, table, ATH79K_WIFI_DESCS + 1),
+			      GFP_KERNEL);
+	if (!lookup)
+		return -ENOMEM;
+
+	/*
+	 * Ugly system-wide lookup for the NULL device: we know this
+	 * is already NULL but explicitly assign it here for people to
+	 * know what is going on. (Yes this is an ugly legacy hack, live
+	 * with it.)
+	 */
+	lookup->dev_id = NULL;
+
+	for (i = 0; i < ATH79K_WIFI_DESCS; i++) {
+		lookup->table[i] =
+			/*
+			 * Set the HW offset on the chip and the lookup
+			 * index to the same value, so looking up index 0
+			 * will get HW offset 0, index 1 HW offset 1 etc.
+			 */
+			GPIO_LOOKUP_IDX(label, i, "ath9k", i, GPIO_ACTIVE_HIGH);
+	}
+
+	gpiod_add_lookup_table(lookup);
+
+	return 0;
+}
+#else
+static int ath79_gpio_register_wifi_descriptors(struct device *dev,
+						const char *label)
+{
+	return 0;
+}
+#endif
+
 static int ath79_gpio_probe(struct platform_device *pdev)
 {
 	struct gpio_generic_chip_config config;
@@ -276,7 +327,11 @@ static int ath79_gpio_probe(struct platform_device *pdev)
 		girq->handler = handle_simple_irq;
 	}
 
-	return devm_gpiochip_add_data(dev, &ctrl->chip.gc, ctrl);
+	err = devm_gpiochip_add_data(dev, &ctrl->chip.gc, ctrl);
+	if (err)
+		return err;
+
+	return ath79_gpio_register_wifi_descriptors(dev, ctrl->chip.gc.label);
 }
 
 static struct platform_driver ath79_gpio_driver = {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 14de62c1a32bd..9a32cf683c4fd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -21,7 +21,7 @@
 #include <linux/time.h>
 #include <linux/bitops.h>
 #include <linux/etherdevice.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/unaligned.h>
 
 #include "hw.h"
@@ -2719,19 +2719,28 @@ static void ath9k_hw_gpio_cfg_output_mux(struct ath_hw *ah, u32 gpio, u32 type)
 static void ath9k_hw_gpio_cfg_soc(struct ath_hw *ah, u32 gpio, bool out,
 				  const char *label)
 {
+	enum gpiod_flags flags = out ? GPIOD_OUT_LOW : GPIOD_IN;
+	struct gpio_desc *gpiod;
 	int err;
 
-	if (ah->caps.gpio_requested & BIT(gpio))
+	if (ah->gpiods[gpio])
 		return;
 
-	err = devm_gpio_request_one(ah->dev, gpio, out ? GPIOF_OUT_INIT_LOW : GPIOF_IN, label);
+	/*
+	 * Obtains a system specific GPIO descriptor from another GPIO controller.
+	 * Ideally this should come from the device tree, this is a legacy code
+	 * path.
+	 */
+	gpiod = gpiod_get_index(NULL, "ath9k", gpio, flags);
+	err = PTR_ERR_OR_ZERO(gpiod);
 	if (err) {
 		ath_err(ath9k_hw_common(ah), "request GPIO%d failed:%d\n",
 			gpio, err);
 		return;
 	}
 
-	ah->caps.gpio_requested |= BIT(gpio);
+	gpiod_set_consumer_name(gpiod, label);
+	ah->gpiods[gpio] = gpiod;
 }
 
 static void ath9k_hw_gpio_cfg_wmac(struct ath_hw *ah, u32 gpio, bool out,
@@ -2791,10 +2800,12 @@ void ath9k_hw_gpio_free(struct ath_hw *ah, u32 gpio)
 	if (!AR_SREV_SOC(ah))
 		return;
 
-	WARN_ON(gpio >= ah->caps.num_gpio_pins);
+	if (ah->gpiods[gpio]) {
+		gpiod_put(ah->gpiods[gpio]);
+		ah->gpiods[gpio] = NULL;
+	}
 
-	if (ah->caps.gpio_requested & BIT(gpio))
-		ah->caps.gpio_requested &= ~BIT(gpio);
+	WARN_ON(gpio >= ah->caps.num_gpio_pins);
 }
 EXPORT_SYMBOL(ath9k_hw_gpio_free);
 
@@ -2822,8 +2833,8 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
 			val = REG_READ(ah, AR_GPIO_IN(ah)) & BIT(gpio);
 		else
 			val = MS_REG_READ(AR, gpio);
-	} else if (BIT(gpio) & ah->caps.gpio_requested) {
-		val = gpio_get_value(gpio) & BIT(gpio);
+	} else if (ah->gpiods[gpio]) {
+		val = gpiod_get_value(ah->gpiods[gpio]);
 	} else {
 		WARN_ON(1);
 	}
@@ -2846,8 +2857,8 @@ void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val)
 			AR7010_GPIO_OUT : AR_GPIO_IN_OUT(ah);
 
 		REG_RMW(ah, out_addr, val << gpio, BIT(gpio));
-	} else if (BIT(gpio) & ah->caps.gpio_requested) {
-		gpio_set_value(gpio, val);
+	} else if (ah->gpiods[gpio]) {
+		gpiod_set_value(ah->gpiods[gpio], val);
 	} else {
 		WARN_ON(1);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index eaa07d6dbde00..d9d2f64c55700 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -19,6 +19,7 @@
 
 #include <linux/if_ether.h>
 #include <linux/delay.h>
+#include <linux/gpio/consumer.h>
 #include <linux/io.h>
 #include <linux/firmware.h>
 
@@ -302,7 +303,6 @@ struct ath9k_hw_capabilities {
 	u8 max_rxchains;
 	u8 num_gpio_pins;
 	u32 gpio_mask;
-	u32 gpio_requested;
 	u8 rx_hp_qdepth;
 	u8 rx_lp_qdepth;
 	u8 rx_status_len;
@@ -783,6 +783,7 @@ struct ath_hw {
 	struct ath9k_hw_capabilities caps;
 	struct ath9k_channel channels[ATH9K_NUM_CHANNELS];
 	struct ath9k_channel *curchan;
+	struct gpio_desc *gpiods[32];
 
 	union {
 		struct ar5416_eeprom_def def;
-- 
2.53.0

