Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0AC57EDBA;
	Mon, 31 Aug 2026 13:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184184; cv=none; b=SDrHFaRzOgvaMSulvEO3IFOAJgeMZHiNXAfkc1CDtAC5NUUdVIibk/JIWUPUsVsHeOGHHVzItQLOloaeBXO2P3F2B5ZXPjLMK8MYHPc6TpK3MmThVpUvOb9ifgHq5Nnykwj5Xo77pp5H6dbm/lQl8EHlQ7XmxgewwEQOiyPhZKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184184; c=relaxed/simple;
	bh=g4hdznl5v6aW6xOr5tnu19RpNERqg6Gyi0mX7EttdT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omGfxiKlrQB71gxjCOEpaowxdRXothFSd/opk+Lkj4QgweG77X7Zv6COY4EbZcgqWvZrPbDYVVmhS1+p4442ypx9GlbaZLC7U4cSH6rmbDkalkYeI0PHIESndBZd8c89OGQKZazQ0Tcr06HTRnpEOYPs4Hhv0cROexIuludeR2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W3vApgS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W3vApgS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C771F00A3D;
	Mon, 31 Aug 2026 13:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184182;
	bh=OWqo+hM81GruAeZ/02oZr+I8zvMhMMYyhoN918CSZBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3vApgS+Vhb76jUTQTEQhx7KDS6/4LgV51pplJujANPnSb5TY32RlyDnu027Ajh63
	 9kfZBjoA3Qhco8TZ/aKM3JSsjaeAM9P66w/SFUpTxohQ0VFek9jHVWF54rXVjUE+bF
	 jjNAafURuaJgu7U/nK0LKPIqvmbShIvWX9cYDDGtchmcCH98yk9/LERFDKkeJOD0Ne
	 1D8kShsG4sjBRCGryA6gaGms41k+vNN3bVedxed7xh2hmd962js7NIETgLeMiNyEpe
	 iJbNoBXi0wMo7H0HXqn6vonLYzkCM+wZb4R8URcwjNxUQt2TqLg8ksww7O3+lgOVjl
	 H5OlY2YjjAKlg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>,
	linusw@kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] pinctrl: renesas: rzv2m: Use -ENOTSUPP instead of -EOPNOTSUPP
Date: Mon, 31 Aug 2026 09:29:28 -0400
Message-ID: <20260831133314.4125787-540-sashal@kernel.org>
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 01f94d53947df35ba77cdb3992a4e3ef9d9dc1ad ]

The pinctrl and GPIO core code make exceptions for the -ENOTSUPP error
code. One such example is gpio_set_config_with_argument_optional(), which
returns success when gpio_set_config_with_argument() returns -ENOTSUPP, but
reports failure for all other error codes.

Returning -EOPNOTSUPP from the pinctrl driver on the unsupported pinctrl
operation may lead to boot failures when pinctrl drivers implements
struct gpio_chip::set_config, the system uses GPIO hogs, and the
struct gpio_chip::set_config implementation returns -EOPNOTSUPP for the
unsupported operations.

Currently, the driver does not implement struct gpio_chip::set_config().
To avoid future failures, return -ENOTSUPP from
rzv2m_pinctrl_pinconf_set().

rzv2m_pinctrl_pinconf_group_get() is used when dumping pinctrl
configuration. pinconf_generic_dump_one(), which calls it, makes
exceptions for the -EINVAL and -ENOTSUPP error codes. The documentation
for struct pinconf_ops::pin_config_group_get states that it "should
return -ENOTSUPP and -EINVAL using the same rules as pin_config_get()".
The documentation for struct pinconf_ops::pin_config_get states:

"get the config of a certain pin, if the requested config is not available
on this controller this should return -ENOTSUPP and if it is available but
disabled it should return -EINVAL".

Return -ENOTSUPP for the unsupported pinctrl operation.

Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260522105717.1727837-1-claudiu.beznea@kernel.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `pinctrl: renesas: rzv2m: Use -ENOTSUPP
instead of -EOPNOTSUPP`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`,
`make kernelversion` → `6.18.44`)

**Upstream commit:** `01f94d53947df` (on `master`; **not** in this
6.18.44 checkout)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[pinctrl: renesas: rzv2m]` — action: **Use** (correctness
fix) — return the proper `-ENOTSUPP` errno instead of `-EOPNOTSUPP` for
unsupported pinconf operations.

### Step 1.2: Tags
**Record:**
- **Suggested-by:** Geert Uytterhoeven (maintainer suggested the fix)
- **Signed-off-by:** Claudiu Beznea (author), Geert Uytterhoeven
  (committer on master)
- **Reviewed-by:** Geert Uytterhoeven (subsystem maintainer)
- **Link:** https://patch.msgid.link/20260522105717.1727837-1-
  claudiu.beznea@kernel.org
- **No** Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org
  (absence of Cc: stable is expected per review instructions)
- **Notable:** Maintainer-reviewed, maintainer-suggested; no syzbot or
  user bug reports

### Step 1.3: Body analysis
**Record:**
- **Bug:** Driver returns `-EOPNOTSUPP` where pinctrl/GPIO core expects
  `-ENOTSUPP` for “unsupported configuration”
- **Symptoms:**
  - Potential **boot failure** if `gpio_chip::set_config` is added and
    GPIO hogs trigger optional config paths
    (`gpio_set_config_with_argument_optional()` treats only `-ENOTSUPP`
    as benign)
  - **Incorrect debugfs dumps**: `pinconf_generic_dump_one()` treats
    `-ENOTSUPP` and `-EINVAL` as legal; `-EOPNOTSUPP` prints `"ERROR
    READING CONFIG SETTING"`
- **Root cause:** Violation of documented `pinconf_ops` API contract
  (`include/linux/pinctrl/pinconf.h`)
- **Version info:** None in message; driver has existed since 2022

### Step 1.4: Hidden bug fix?
**Record:** **Yes.** Despite neutral “Use X instead of Y” wording, this
fixes a real API-contract bug with concrete debugfs impact and a
documented boot-failure class for GPIO hog + `set_config` paths.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/pinctrl/renesas/pinctrl-rzv2m.c` — 2 lines changed
  (+2/-2)
- **Functions:** `rzv2m_pinctrl_pinconf_set()`,
  `rzv2m_pinctrl_pinconf_group_get()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow per hunk

**Hunk 1 — `rzv2m_pinctrl_pinconf_set()` default case:**
- **Before:** Unknown `PIN_CONFIG_*` param → `-EOPNOTSUPP`
- **After:** → `-ENOTSUPP`
- **Path:** DT pinconf apply / explicit pin configuration for
  unsupported parameters

**Hunk 2 — `rzv2m_pinctrl_pinconf_group_get()` mismatch check:**
- **Before:** Pins in group disagree on config value → `-EOPNOTSUPP`
- **After:** → `-ENOTSUPP`
- **Path:** `pinconf_generic_dump_one()` → `pin_config_group_get()`
  during debugfs pinconf dumps

### Step 2.3: Bug mechanism
**Record:** **Logic / API correctness fix (category g).** Core
GPIO/pinconf code special-cases `-ENOTSUPP` but not `-EOPNOTSUPP`. The
driver already returns `-ENOTSUPP` correctly in
`rzv2m_pinctrl_pinconf_get()` (line 548); these two sites were
inconsistent.

### Step 2.4: Fix quality
**Record:** Obviously correct, minimal, matches kernel-wide convention
and sibling `rzg2l` fix. Regression risk: **very low** (only changes
error codes on unsupported/mismatched-config paths).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `-EOPNOTSUPP` in `pinconf_set` default case introduced in
`92a9b82525761` (“Add RZ/V2M pin and gpio controller driver”, June
2022). Present in this 6.18.44 tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:**
- Identical fix for `rzg2l` already backported to **this tree**:
  `6876f767b0490` (upstream `c1492da3939c`)
- Related but separate: `ec642ab9b76f8` (type fix in
  `pin_config_group_get`) is on `master` but **not** in 6.18.44 — not a
  prerequisite for this 2-line errno change
- Standalone single-patch series (v1 only per `b4 dig -a`)

### Step 3.4: Author context
**Record:** Claudiu Beznea is an active Renesas pinctrl contributor;
Geert Uytterhoeven is the Renesas maintainer who committed and reviewed.

### Step 3.5: Dependencies
**Record:** **None.** Patch applies cleanly (`git apply --check` → exit
0). Does not assume code absent from 6.18.44.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://patch.msgid.link/20260522105717.1727837-1-
  claudiu.beznea@kernel.org
- **Series:** v1 only (no revisions)
- **Review:** Geert Uytterhoeven Reviewed-by + “will queue in renesas-
  devel for v7.2”
- **No** NAKs, no explicit stable nomination in thread
- Lore web fetch blocked by bot protection; content obtained via `b4 dig
  -m`

### Step 4.2: Reviewers
**Record:** CC’d: `geert+renesas@glider.be`, `linusw@kernel.org`,
`brgl@kernel.org`, `linux-renesas-soc@`, `linux-gpio@`, `linux-kernel@`
— appropriate maintainer coverage.

### Step 4.3: Bug report
**Record:** N/A — no external bug report; preventive/correctness fix
identified by maintainer (Suggested-by Geert).

### Step 4.4: Related patches
**Record:** Part of a Renesas-wide errno cleanup; `rzg2l` variant
already in this stable tree.

### Step 4.5: Stable list
**Record:** Not searched (lore blocked); `rzg2l` sibling carried `Cc:
stable@vger.kernel.org` and was backported here.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `rzv2m_pinctrl_pinconf_set`,
`rzv2m_pinctrl_pinconf_group_get`

### Step 5.2: Callers
**Record:**
- `pinconf_set` → `pinconf_apply_setting()` during pinctrl DT binding
  (boot)
- `pinconf_group_get` → `pin_config_group_get()` →
  `pinconf_generic_dump_one()` (debugfs via
  `pinconf_generic_dump_config`; driver sets `is_generic = true`)

### Step 5.3: Callees
**Record:** `rzv2m_pinctrl_pinconf_get()` (group_get),
`pinconf_to_config_param()` (set)

### Step 5.4: Reachability
**Record:**
- **Boot:** `pinconf_set` path reachable on RZ/V2M boot with unsupported
  DT pinconf properties (both errnos fail equally today via
  `pinconf_apply_setting`)
- **GPIO hog boot failure:** **Not currently reachable** —
  `rzv2m_gpio_register()` does not set `chip->set_config`;
  `gpio_do_set_config()` returns `-ENOTSUPP` when `set_config` is NULL
- **Debugfs:** `pinconf_group_get` path **is reachable** on RZ/V2M when
  dumping pinconf; wrong errno causes spurious error strings
- **RZ/V2M EVK** (`r9a09g011-v2mevk2.dts`): no `gpio-hog` nodes found

### Step 5.5: Similar patterns
**Record:** `rzv2m_pinctrl_pinconf_get()` already uses `-ENOTSUPP` (line
548). `rzg2l` fix already backported in this tree. Kernel-wide
convention: pinctrl drivers return `-ENOTSUPP` for unsupported configs.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **Yes.** Lines 664 and 713 in `pinctrl-rzv2m.c` still return
`-EOPNOTSUPP`. Driver present since v6.x (2022).

### Step 6.2: Backport complications
**Record:** **Clean apply** — verified with `git show 01f94d53947df |
git apply --check`.

### Step 6.3: Related fixes already present?
**Record:** `rzg2l` errno fix (`6876f767b0490`) is in this tree; `rzv2m`
fix is **not** yet applied.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem / criticality
**Record:** `drivers/pinctrl/renesas` — **PERIPHERAL** (RZ/V2M /
`ARCH_R9A09G011` platform-specific), but uses generic pinconf
infrastructure shared with GPIO core.

### Step 7.2: Activity
**Record:** Active — recent rzv2m fixes in this tree (NULL deref,
of_node_put, GPIO callback updates).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** RZ/V2M (`CONFIG_PINCTRL_RZV2M`) users — embedded/industrial
platforms. Not universal.

### Step 8.2: Trigger conditions
**Record:**
- **Current:** Debugfs pinconf dump with heterogeneous pin groups; API
  misuse if unsupported pinconf applied via DT
- **Future:** `set_config` + GPIO hogs with optional bias/config flags
- **Likelihood today:** Low for boot (no `set_config`, no gpio-hogs on
  rzv2m boards); moderate for debugfs correctness

### Step 8.3: Failure mode severity
**Record:**
- Boot failure (future `set_config` path): **CRITICAL** if triggered
- Debugfs spurious errors today: **LOW**
- API contract violation: correctness issue, not crash by itself

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Medium — aligns with already-backported `rzg2l` fix,
  fixes debugfs behavior, prevents future boot regression, correct per
  `pinconf.h`
- **Risk:** Very low — 2 errno changes on error paths only
- **Ratio:** Favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Identical `rzg2l` fix already accepted into **this** 6.18.44 tree
- Documented API contract (`pinconf.h` requires `-ENOTSUPP`)
- Internal driver inconsistency (`pinconf_get` already uses `-ENOTSUPP`)
- Real debugfs impact via `pinconf_generic_dump_one()`
- Preventive boot-failure fix when `set_config` is added
- 2-line change, applies cleanly, maintainer-reviewed
- Bug present since driver introduction (2022)

**AGAINST backport:**
- No current boot failure (no `set_config`, no gpio-hogs on rzv2m
  boards)
- Platform-specific, limited user base
- No user bug report or syzbot finding
- “Important issue” threshold is borderline for *current* runtime impact

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — errno swap matches API docs
   and `rzg2l` precedent; Reviewed-by maintainer (no Tested-by)
2. Fixes a real bug? **PASS** — API contract violation with verified
   debugfs impact; boot failure class documented
3. Important issue? **PASS (borderline)** — not crashing today, but same
   class of fix already deemed stable-worthy for `rzg2l` in this tree;
   future boot failure is serious
4. Small and contained? **PASS** — 2 lines, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs-only).

### Step 9.4: Decision rationale

The strongest argument is **consistency within this stable tree**:
maintainers already backported the identical `rzg2l` errno fix
(`6876f767b0490`) to 6.18.44. The `rzv2m` driver has the same bug
pattern, the same author/reviewer, and the same API-contract violation.
While current boot impact is limited (no `gpio_chip::set_config`, no
gpio-hogs on RZ/V2M boards), the `pinconf_group_get` path already
produces incorrect debugfs behavior, and the fix is trivial with
negligible regression risk.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query + `git
  show 01f94d53947df`
- **[Phase 2]** Diff analysis: 2 errno changes in `pinctrl-rzv2m.c`;
  read surrounding code at lines 530–744
- **[Phase 3]** `git describe HEAD` → v6.18.44; `git blame` → buggy
  lines from `92a9b82525761` (2022)
- **[Phase 3]** `git log -- drivers/pinctrl/renesas/pinctrl-rzv2m.c` —
  driver history reviewed
- **[Phase 3]** Found `6876f767b0490` (rzg2l sibling fix) already in
  HEAD
- **[Phase 3]** `ec642ab9b76f8` NOT in HEAD — separate type fix, not a
  prerequisite
- **[Phase 4]** `b4 dig -c 01f94d53947df` → lore URL; `b4 dig -a` → v1
  only; `b4 dig -w` → maintainers CC'd
- **[Phase 4]** `b4 dig -m /tmp/rzv2m_enotsupp.mbox` — Geert Reviewed-
  by, no NAKs
- **[Phase 5]** Read `gpio_set_config_with_argument_optional()` in
  `gpiolib.c:2694–2714` — only `-ENOTSUPP` treated as success
- **[Phase 5]** Read `pinconf_generic_dump_one()` in `pinconf-
  generic.c:59–84` — `-ENOTSUPP`/`-EINVAL` skipped
- **[Phase 5]** Read `pinconf.h:24–29` — API documents `-ENOTSUPP`
- **[Phase 5]** Verified `rzv2m` has no `chip->set_config` in
  `rzv2m_gpio_register()` (lines 953–960)
- **[Phase 5]** Grep: no gpio-hogs in `r9a09g011-v2mevk2.dts`
- **[Phase 6]** Grep confirms `-EOPNOTSUPP` still at lines 664, 713 in
  HEAD
- **[Phase 6]** `git show 01f94d53947df | git apply --check` → applies
  cleanly
- **[Phase 6]** `master` has fix at lines 664, 714; HEAD does not

**YES**The background git searches finished successfully and match what
the analysis already used:

- The **rzv2m** fix is upstream commit `01f94d53947df` on `master`; it
  is **not** in this **6.18.44** tree yet (lines 664 and 713 still
  return `-EOPNOTSUPP`).
- The sibling **rzg2l** fix (`6876f767b0490`) **is** already backported
  here.

**Verdict for 6.18.44: YES** — same 2-line errno correction, applies
cleanly, and consistent with the rzg2l backport already in this tree.

 drivers/pinctrl/renesas/pinctrl-rzv2m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzv2m.c b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
index dce68f93d2d57..e08f24d5a89f5 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzv2m.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
@@ -661,7 +661,7 @@ static int rzv2m_pinctrl_pinconf_set(struct pinctrl_dev *pctldev,
 		}
 
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
@@ -710,7 +710,7 @@ static int rzv2m_pinctrl_pinconf_group_get(struct pinctrl_dev *pctldev,
 
 		/* Check config matches previous pins */
 		if (i && prev_config != *config)
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 
 		prev_config = *config;
 	}
-- 
2.53.0

