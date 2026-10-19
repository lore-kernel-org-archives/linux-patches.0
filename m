Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0295D4C8474;
	Mon, 19 Oct 2026 14:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418498; cv=none; b=DlWFdHhZIelrn4n1G33zBVLKjNmfyN4vx7n9QvGAmAT5KL9h2ds2+04KcDZ94aig3a/fBq3yqbbdwxsAVmguXeQq6CnTgXb+LSO2JlvGS0RlfFXSPyth6FnIEJkfNh7Izi59yQ4xWNSb5QQvg0yScGpQ4zPrPCuWaCeItcejFq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418498; c=relaxed/simple;
	bh=pevl2x+Sn9X3Q1eeZFj4P3E3HsMDmNjoMM46qKfxo+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ElRlpeVRhgq/6fQtDRObDRljRTtKhbwgpeursQpoEI/MrhsTkr6R3yoykbW+OFemg9RzptIKV5kS2J62bjifeKoyIqxMUaOFh2yFDUmCrqqkWD4oOd37+iazCqsX6TN17+h5pU7cgp3hdzuPtF4tOmcz7mnxIjhjNSHBtlaxy4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KY+YqmQi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KY+YqmQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBE61F000CB;
	Mon, 19 Oct 2026 14:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418495;
	bh=voAvVSk4YB+tIdoJj1CiH8tlxU0aSwXAsmGz8e3GhrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KY+YqmQij6N712OhXheZT12pHfyISXnJIqNJSOoz2zJstfxBR8kPZqs77LwQXHkpz
	 D8JH+aFBacEEi09dTsDkIsd30ij3FLaZHXgblHYAtM79XKGj/qKkNxLJAevAVBHiAZ
	 nuyIFvooGJCUY2kw2qbIe3iPwwOM0XQaCwa64+wEOV5i2307kf8QGDxNX5dNlWbBhn
	 wv2RznOklEi9XKu+FXJoAFGMTCA6yuF3b7jIK53c5z9R/1E/9DYxTQglprQpKqdWmD
	 tGpOs3wdLhODE6zWobrbFTIPtXFYiVD0ZAwWoIpnVxoFfoxpPJZz8gy/38c2IQIRhQ
	 w50uoU1Umr8hQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Sebastian Reichel <sre@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	vireshk@kernel.org,
	nm@ti.com,
	sboyd@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] opp: Use clk_get_optional() to avoid leaving opp_table->clk as an error pointer
Date: Mon, 19 Oct 2026 09:49:40 -0400
Message-ID: <20261019135441.1420968-289-sashal@kernel.org>
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

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

[ Upstream commit 84f05af0975c9f9c8ffee0361d6f7cbb1f289231 ]

_update_opp_table_clk() uses clk_get(dev, NULL) to acquire the
device's clock. On platforms where the perf domain device has no
Linux clock and is instead managed entirely by firmware via
devm_pm_opp_of_add_table() (through
of_genpd_add_provider_simple()/onecell()), clk_get() returns
-ENOENT. That case is treated as valid (the OPP table can still
have entries sourced from firmware), but opp_table->clk is left
holding ERR_PTR(-ENOENT) rather than being reset to NULL:

	opp_table->clk = clk_get(dev, NULL);
	ret = PTR_ERR_OR_ZERO(opp_table->clk);
	...
	if (ret == -ENOENT) {
		opp_table->clk_count = 1;
		return opp_table;   /* opp_table->clk is still ERR_PTR(-ENOENT) */
	}

Consumers that only check IS_ERR(opp_table->clk) treat this as a
valid clk and pass it straight into the clk consumer API. In
particular, dev_pm_opp_set_rate() calls
clk_round_rate(opp_table->clk, target_freq), and clk_round_rate()
only guards against a NULL clk, so it dereferences the error pointer
to read clk->exclusive_count and crashes:

  Unable to handle kernel NULL pointer dereference at virtual
  address 000000000000002e
  ...
  pc : clk_round_rate+0x3c/0x188
  ...
  Call trace:
   clk_round_rate+0x3c/0x188 (P)
   dev_pm_opp_set_rate+0x114/0x33c

Rather than teaching every clk consumer API to special-case
ERR_PTR(-ENOENT), fix it at the source: use clk_get_optional()
instead of clk_get() in _update_opp_table_clk(), which already
translates -ENOENT into a NULL clk. This documents that the clock is
genuinely optional for such devices, and keeps opp_table->clk holding
either a valid clk or NULL, never a lingering -ENOENT error pointer.
_opp_config_clk_single() is only wired up via opp_table->config_clks
when a clk was actually found, and every other opp_table->clk
consumer already tolerates NULL through the standard clk API (which
treats a NULL clk as a no-op), so no other call site needs to change.

Suggested-by: Sebastian Reichel <sre@kernel.org>
Reviewed-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the crash path is in this 6.12 tree, the fix is
small, and it should apply cleanly. Full analysis follows.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[opp] [Use] Use `clk_get_optional()` so `opp_table->clk` is
never left as `ERR_PTR(-ENOENT)`.** Subsystem is the OPP core
(`drivers/opp/`). “Use X to avoid Y” is a correctness fix, not a
feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Suggested-by:** Sebastian Reichel `<sre@kernel.org>` (linux-pm /
  power maintainer)
- **Reviewed-by:** Sebastian Reichel `<sre@kernel.org>`
- **Signed-off-by:** Praveen Talari `<praveen.talari@oss.qualcomm.com>`
  (author)
- **Signed-off-by:** Viresh Kumar `<viresh.kumar@linaro.org>` (OPP
  maintainer; applied the patch)
- **No Fixes:** tag (expected for this review pipeline)
- **No Cc: stable@vger.kernel.org** (expected; not a negative)
- **No Reported-by / Tested-by / Link / Acked-by**
- Pipeline markers (`[Upstream commit …]`, Sasha Levin SOB) ignored per
  instructions

Upstream SHA (from public history, **not** in this tree):
`84f05af0975c9f9c8ffee0361d6f7cbb1f289231`.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `_update_opp_table_clk()` treats `clk_get()` returning
  `-ENOENT` as valid (firmware-managed / clockless OPP tables) but
  leaves `opp_table->clk = ERR_PTR(-ENOENT)`.
- **Symptom:** kernel oops. `dev_pm_opp_set_rate()` calls
  `clk_round_rate(opp_table->clk, …)`. `clk_round_rate()` only NULL-
  checks, then reads `clk->exclusive_count`. Error pointer wraps to a
  low address (`000000000000002e` in the report).
- **Stack:** `clk_round_rate` ← `dev_pm_opp_set_rate`
- **Trigger:** platforms whose perf-domain / OPP device has no Linux
  clock (`devm_pm_opp_of_add_table()` via
  `of_genpd_add_provider_simple()`/`onecell()`), then a consumer calls
  `dev_pm_opp_set_rate()`.
- **Root cause:** consumers use `IS_ERR()` (true for `-ENOENT`) vs clk
  APIs that only accept NULL as “no clock”.
- **Fix:** `clk_get_optional()` maps `-ENOENT` → NULL at the source.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not hidden.** Explicit crash fix with a stack trace. Not
cleanup/refactor-only.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/opp/core.c` only (`+24 / -30` upstream)
- **Function:** `_update_opp_table_clk()`
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record (this tree’s `_update_opp_table_clk` at
`drivers/opp/core.c:1511`):

**Before:**
1. `opp_table->clk = clk_get(dev, NULL)`
2. Success (`ret == 0`): set `config_clks = _opp_config_clk_single`,
   `clk_count = 1`
3. `-ENOENT`: set `clk_count = 1`, **leave `clk` as
   `ERR_PTR(-ENOENT)`**, return the table
4. Other errors: `dev_pm_opp_put_opp_table()`, `dev_err_probe()`, return
   `ERR_PTR(ret)`

**After:**
1. `opp_table->clk = clk_get_optional(dev, NULL)` (`-ENOENT` becomes
   NULL)
2. `IS_ERR(clk)`: put table, `dev_err_probe()`, return `ERR_CAST(clk)`
   (real errors, e.g. `-EPROBE_DEFER`)
3. If `clk` is non-NULL: set `config_clks`
4. Always `clk_count = 1` and return the table (clock present **or**
   optional-absent)

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Memory safety / NULL-vs-ERR_PTR] [Logic / correctness]**

Mechanism: `ERR_PTR(-ENOENT)` is not NULL. `clk_round_rate()` in this
tree (`drivers/clk/clk.c:1799`) does `if (!clk) return 0;` then
`clk->exclusive_count`. `ERR_PTR(-2)` plus `offsetof(struct clk,
exclusive_count)` wraps to `0x2e`, matching the oops.
`_find_current_opp` and table release already use
`!IS_ERR(opp_table->clk)` and therefore skip the error pointer;
`dev_pm_opp_set_rate()` does not.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct. `clk_get_optional()` is the documented
  helper for this case (`include/linux/clk.h:1195`). `config_clks` is
  still only set when a real clk exists — same as before.
- **Surgical:** one helper, no API change.
- **Regression risk (low):**
  - After NULL, early-return `!IS_ERR(opp_table->clk)` is true, so later
    lookups do not retry `clk_get`. Previously `-ENOENT` was `IS_ERR`
    and would retry. Correct for “no clock” devices.
  - `_find_current_opp` may now call `clk_get_rate(NULL)` (returns 0)
    instead of skipping. Lowest available OPP vs first list entry;
    acceptable.
  - Error path uses `opp_table->clk` **after**
    `dev_pm_opp_put_opp_table()`. Old code saved `ret` first.
    Theoretical UAF if the last ref frees the table before the
    `PTR_ERR`/`ERR_CAST`. Mainline accepted this; not the common
    `-ENOENT` success path.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- `_update_opp_table_clk` introduced in `32439ac7535a8` (“opp: Defer
  acquiring the clk until OPPs are added”, 2021-02-02).
- `-ENOENT` treated as valid in `d4a4c7a41153d` (“opp: Don't ignore
  clk_get() errors other than -ENOENT”, 2021-02-02) — **this is the
  commit that left the error pointer in the table**.
- ENOENT comment / `clk_count = 1` / `config_clks` wiring from
  `2083da24eb56ce` (“OPP: Allow multiple clocks for a device”,
  2022-06-10).
- `dev_pm_opp_set_rate()` dropped its `IS_ERR(clk)` guard in
  `1d3c42cabbd35` (“opp: No need to check clk for errors”, 2021-01-20) —
  “Clock is not optional for users who call into
  `dev_pm_opp_set_rate()`”, which is false for firmware-managed clocks.

Bug present since ~v5.12, definitely in 6.12.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Introducers `d4a4c7a41153d` and
`1d3c42cabbd35` **are both ancestors of HEAD**.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent `drivers/opp/core.c` work is other OPP fixes (level,
bandwidth, genpd). No later local rewrite of `_update_opp_table_clk`.
**Standalone**, not “patch X/Y”.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Praveen Talari has **no** prior commits in `drivers/opp/` on
this tree. Viresh Kumar (OPP maintainer) signed off and applied it.
Sebastian Reichel suggested and reviewed.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- `clk_get_optional()` exists here: `60b8f0ddf1a92` (2019-02-06),
  `include/linux/clk.h:1203`.
- Function body in this tree **matches** the patch’s “before” hunk.
  **Standalone apply.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 84f05af0975c9f9c8ffee0361d6f7cbb1f289231` → https://patch.m
  sgid.link/20260727-fix_ptr_check_on_clk-v4-1-
  97969fa7826a@oss.qualcomm.com
- **v1:** guard `clk_round_rate()` against error pointers (and a
  `drivers/clk/clk.c` change)
- **v2:** per Reichel, fix OPP core with `clk_get_optional()`; drop clk-
  core change
- **v3:** add OPP maintainers
- **v4:** rebase; drop local `ret` (applied)
- Applied version is v4 (latest). No NAK. Viresh: “Applied. Thanks.”
  (only nit: extra `---` in the changelog)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): Viresh Kumar, Nishanth Menon, Stephen Boyd (OPP
maintainers), Konrad Dybcio, Sebastian Reichel, linux-pm, linux-kernel,
clk maintainer Boyd. Right audience.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla. Concrete oops in the message from a Qualcomm
engineer. Real hardware, not theoretical.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Single-patch series. v1’s clk-core change was dropped; this does
not depend on other patches.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: **UNVERIFIED** for lore.kernel.org/stable (HTTP 403). No
evidence this was rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `_update_opp_table_clk()` only.

**Step 5.2: TRACE CALLERS**

Record:
- Only caller: `_add_opp_table_indexed()` (`core.c:1623`)
- DT path `_of_add_table_indexed()` uses `getclk=true` (`of.c:1150`) —
  **every** `dev_pm_opp_of_add_table()` / `devm_pm_opp_of_add_table()` /
  genpd `of_genpd_add_provider_simple()` that adds an OPP table
- Also `dev_pm_opp_add_dynamic()` (`core.c:2894`, getclk=true)
- Crash consumer: `dev_pm_opp_set_rate()` (`core.c:1352`) — used by
  Qualcomm UART/SPI/MMC/GPU/Venus, Tegra, cpufreq-dt,
  panfrost/panthor/lima, etc.

**Step 5.3: TRACE CALLEES**

Record: `clk_get` → `clk_get_optional`; on hard error
`dev_pm_opp_put_opp_table` + `dev_err_probe`. No new locks/allocs.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Device probe (`dev_pm_opp_of_add_table`) →
`_update_opp_table_clk` stores `ERR_PTR(-ENOENT)` → later
`dev_pm_opp_set_rate` from driver/cpufreq/devfreq → oops. **Reachable
from normal device operation**, not a debug-only path.

Verified clk NULL-safety in this tree:
- `clk_round_rate`: NULL → 0 (`clk.c:1804`)
- `clk_get_rate`: NULL → 0 (`clk.c:2005`)
- `clk_set_rate`: NULL → 0 (`clk.c:2600`)
- `__clk_put`: NULL returns immediately (`clk.c:4748`)

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Other `opp_table->clk` users already use `!IS_ERR()`
(`_find_current_opp`, kref release). `set_rate` is the one that passes
the error pointer into clk APIs. Fixing storage is the right place (as
Reichel requested).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** Local tree is **6.12.111** (`pending-6.12`,
`p-6.12-2-gd38d58a4e0359`). `_update_opp_table_clk` still uses
`clk_get(dev, NULL)` and the `-ENOENT` early return
(`core.c:1526-1551`). `git merge-base --is-ancestor
84f05af0975c9f9c8ffee0361d6f7cbb1f289231 HEAD` failed (not present). Bug
since ~2021.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** Function text matches the patch context; only
surrounding line numbers differ. `clk_get_optional()` already in
`include/linux/clk.h`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: `d4a4c7a41153d` (ENOENT allowed) and `1d3c42cabbd35` (set_rate
dropped IS_ERR) are here. No `clk_get_optional` OPP commit. **No
alternate fix.**

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **OPP core** (`drivers/opp/`) — **IMPORTANT**. Shared by
cpufreq, devfreq, DRM, MMC, serial, genpd performance states. Not
staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature (OPP since well before 6.12) with ongoing correctness
fixes. This bug is old, not a brand-new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Config/driver-specific:** `CONFIG_PM_OPP` plus devices with an
OPP table and **no** unnamed Linux clock, that then call
`dev_pm_opp_set_rate()`. Includes firmware-managed perf domains
(Qualcomm-class, genpd OPP). Not every box, but production SoCs.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Probe adds OPP table (`getclk=true`); `clk_get` → `-ENOENT`;
later `dev_pm_opp_set_rate()`. Common on clockless firmware DVFS, not
every boot on x86. Not a syzbot/unprivileged syscall primitive;
driver/cpufreq context.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **Kernel oops / NULL deref** in `clk_round_rate`. **Severity:
CRITICAL** (crash; can strand DVFS/device).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit: HIGH** — prevents a real oops on clockless OPP devices;
  6.12 LTS includes those platforms.
- **Risk: LOW** — ~50-line rewrite of one helper; `clk_get_optional`
  long-standing; success path equivalent except NULL vs ERR_PTR; clk
  APIs already NULL-safe.
- **Ratio: strongly favors backport.**

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real oops with stack trace (`clk_round_rate` ← `dev_pm_opp_set_rate`)
- Buggy pattern present in **this** 6.12 tree
- Small, obviously correct, no new API
- `clk_get_optional` already here
- Reviewed by Reichel; applied by Viresh
- Clean apply; no missing prerequisites

**AGAINST:**
- Affects firmware-managed / clockless OPP devices, not every machine
- Error-path `opp_table->clk` after put is slightly sloppier than the
  old local `ret` (not the crash path being fixed)
- No Fixes:/Cc:stable (irrelevant per pipeline rules)

**UNRESOLVED:**
- Could not fetch lore.kernel.org/stable (403)
- Could not fetch v1 body (403/404); changelog is enough
- Exact Qualcomm SoC in the oops not named in the v4 mail

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — helper does exactly this;
   maintainer review + apply
2. Fixes a real bug that affects users? **PASS** — oops on clockless OPP
   + `set_rate`
3. Important issue? **PASS** — kernel crash (CRITICAL)
4. Small and contained? **PASS** — one function, one file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — body matches;
   `clk_get_optional` present

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary crash
fix; does not need an exception.

**Step 9.4: MAKE YOUR DECISION**

This is a real NULL-deref oops in OPP core that 6.12 still has. The fix
maps “no clock” to NULL the way the clk API already documents, is tiny,
and applies cleanly here. That is appropriate for this stable tree.

---

### What the commit solves (for this tree)

On 6.12.111, `_update_opp_table_clk()` still does `clk_get(dev, NULL)`
and, on `-ENOENT`, keeps `opp_table->clk` as `ERR_PTR(-ENOENT)` while
treating the table as valid. `dev_pm_opp_set_rate()` then passes that
into `clk_round_rate()`, which only rejects NULL, and the kernel oopses.
That is exactly the path firmware-managed / genpd OPP devices take when
they have no Linux clock.

### Stable rules / risk

Meets the stable criteria: real crash, small, no new API, prerequisites
already in 6.12. Benefit is avoiding an oops; risk is a one-function
change whose success path is equivalent except storing NULL instead of
an error pointer (what clk consumers already expect).

### Verification

- **[Phase 1]** Parsed tags: Suggested-by/Reviewed-by Reichel; SOB
  Talari + Viresh; no Fixes/Cc:stable
- **[Phase 1]** Body: oops at `clk_round_rate` ← `dev_pm_opp_set_rate`,
  address `0x2e`
- **[Phase 2]** Diff: only `_update_opp_table_clk`; `clk_get` →
  `clk_get_optional`; `-ENOENT` → NULL; `config_clks` only if clk non-
  NULL
- **[Phase 2]** `clk_round_rate` in this tree: NULL check only, then
  `clk->exclusive_count` (`clk.c:1804-1809`)
- **[Phase 3]** Blame: `-ENOENT` keep-table from `d4a4c7a41153d` (in
  tree); set_rate dropped IS_ERR in `1d3c42cabbd35` (in tree)
- **[Phase 3]** `clk_get_optional` from `60b8f0ddf1a92` (2019), present
- **[Phase 3]** `git merge-base --is-ancestor 84f05af HEAD` → not in
  tree
- **[Phase 4]** `b4 dig -c 84f05af` → v4 msgid
  `20260727-fix_ptr_check_on_clk-v4-1-97969fa7826a@oss.qualcomm.com`
- **[Phase 4]** `b4 dig -a`: v1→v4; v2 switched to source fix per
  Reichel
- **[Phase 4]** `b4 dig -w`: OPP maintainers + linux-pm on To/Cc
- **[Phase 4]** mbox: Viresh “Applied. Thanks.”; no NAK
- **[Phase 5]** Caller: `_add_opp_table_indexed` ← DT add with
  `getclk=true`; crash via `dev_pm_opp_set_rate`
- **[Phase 5]** clk_get_rate/set_rate/put NULL-safe in this tree
- **[Phase 6]** `git describe` / Makefile: 6.12.111; buggy `clk_get` +
  `-ENOENT` block at `core.c:1526-1551`
- **[Phase 8]** Failure mode: oops, CRITICAL
- **UNVERIFIED:** stable@ lore (403); exact crash SoC; whether later
  mainline fixed the post-put `opp_table->clk` read

**YES**

 drivers/opp/core.c | 54 +++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index a179d57a5a150..a41ad136e90e0 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1579,8 +1579,6 @@ static struct opp_table *_update_opp_table_clk(struct device *dev,
 					       struct opp_table *opp_table,
 					       bool getclk)
 {
-	int ret;
-
 	/*
 	 * Return early if we don't need to get clk or we have already done it
 	 * earlier.
@@ -1589,39 +1587,35 @@ static struct opp_table *_update_opp_table_clk(struct device *dev,
 	    opp_table->clks)
 		return opp_table;
 
-	/* Find clk for the device */
-	opp_table->clk = clk_get(dev, NULL);
+	/*
+	 * There are few platforms which don't want the OPP core to manage
+	 * device's clock settings. In such cases neither the platform
+	 * provides the clks explicitly to us, nor the DT contains a valid
+	 * clk entry. The OPP nodes in DT may still contain "opp-hz" property
+	 * though, which we need to parse and allow the platform to find an
+	 * OPP based on freq later on.
+	 *
+	 * This is a simple solution to take care of such corner cases, i.e.
+	 * make the clk_count 1, which lets us allocate space for frequency
+	 * in opp->rates and also parse the entries in DT. Use
+	 * clk_get_optional() instead of clk_get() so opp_table->clk stays
+	 * NULL for such devices, instead of holding an ERR_PTR(-ENOENT) that
+	 * consumers must remember to special-case.
+	 */
+	opp_table->clk = clk_get_optional(dev, NULL);
 
-	ret = PTR_ERR_OR_ZERO(opp_table->clk);
-	if (!ret) {
-		opp_table->config_clks = _opp_config_clk_single;
-		opp_table->clk_count = 1;
-		return opp_table;
+	if (IS_ERR(opp_table->clk)) {
+		dev_pm_opp_put_opp_table(opp_table);
+		dev_err_probe(dev, PTR_ERR(opp_table->clk), "Couldn't find clock\n");
+		return ERR_CAST(opp_table->clk);
 	}
 
-	if (ret == -ENOENT) {
-		/*
-		 * There are few platforms which don't want the OPP core to
-		 * manage device's clock settings. In such cases neither the
-		 * platform provides the clks explicitly to us, nor the DT
-		 * contains a valid clk entry. The OPP nodes in DT may still
-		 * contain "opp-hz" property though, which we need to parse and
-		 * allow the platform to find an OPP based on freq later on.
-		 *
-		 * This is a simple solution to take care of such corner cases,
-		 * i.e. make the clk_count 1, which lets us allocate space for
-		 * frequency in opp->rates and also parse the entries in DT.
-		 */
-		opp_table->clk_count = 1;
-
-		dev_dbg(dev, "%s: Couldn't find clock: %d\n", __func__, ret);
-		return opp_table;
-	}
+	if (opp_table->clk)
+		opp_table->config_clks = _opp_config_clk_single;
 
-	dev_pm_opp_put_opp_table(opp_table);
-	dev_err_probe(dev, ret, "Couldn't find clock\n");
+	opp_table->clk_count = 1;
 
-	return ERR_PTR(ret);
+	return opp_table;
 }
 
 /*
-- 
2.53.0

