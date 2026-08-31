Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E9A54DAE7;
	Mon, 31 Aug 2026 13:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184005; cv=none; b=m5Qjy7Z0Rij6SUlZfrHkwaMTBzKUSoPhJIYFAtcPAoTCXuNQ/hnEKUBHdyNGqYaVQJ5y99g2D9XsryxnOzN2Ft6eOriiSqim/c0KQdo80NFy1gys8Udg7DnrRLNN1spSZPHXDTbf6VK15wVumnoH5iCU2Y9oeNi749df5bwAl1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184005; c=relaxed/simple;
	bh=2iAWs8qCol/chD+6YoW9/BtvKg6zSl5IQF4RltOx+Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ESnEcLf2k1jmcpzYHq6nFtGQ2xwZ/3e76fmJLqEIGxuImEV+mApU40Ss//6t1qEruHt+q/3pbI0RO3kziDpMsaqSZQXtND0hmKnw9HLlvRCCV3SAPDc0pBZEaUYI0cf6oedNVjfq0FyD0XP0H9A0DF8GJeh3gsYCZPtUuc9Wcwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nJC/7C6t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nJC/7C6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996931F00ADB;
	Mon, 31 Aug 2026 13:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184000;
	bh=x9z6R+bGLRyvAbJrsqZMgU4J0bW9Kw89de+7a516MMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJC/7C6thG3XzhlNAu+f5FsgFOItnq8WGTi5lZOetApJwKIBtDtoX2/c7NcEvG7dR
	 jYoM/ZQ9sCET/KmWeDu68TJOYDzcNrwMEeDiup9Bap6+QOX6u+F6ItvKxBCHYS6ztT
	 CX8nYwByfYEOlK+U7EnHxIz4C9CfJ5FwRSYn+Ta7Da7zdQ68c2zeDZghEJh0gr8TKK
	 PNk2j81DCZPXVQIg3NQ6iuVyULneXpG2c5EmP7X85LDTN9QMx2f9p9BwfOui3+/tqC
	 JNDjefxd0v6inaXajpFcp5BrRKeKQtJBJ2vg/4N8OHqzvz5GrEBRE//+bl3U19dHoV
	 qoHBEHkNXpuRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Patrick <gregspatrick@hotmail.com>,
	Manuel Stocker <mensi@mensi.ch>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux@armlinux.org.uk,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: phy: sfp: detect presence via I2C when no MOD_DEF0 GPIO
Date: Mon, 31 Aug 2026 09:27:38 -0400
Message-ID: <20260831133314.4125787-430-sashal@kernel.org>
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

From: Greg Patrick <gregspatrick@hotmail.com>

[ Upstream commit 8ac44d24c3a148c4177bd3ad790c377279f4674f ]

An SFP cage (compatible "sff,sfp") whose MOD_DEF0 signal is not wired to a
GPIO currently falls back to sff_gpio_get_state(), which unconditionally
reports the module as present. An empty cage therefore fails its probe and
is parked in SFP_MOD_ERROR forever; because SFP_F_PRESENT never deasserts
there is no REMOVE event to recover the state machine, so a module inserted
after boot is never detected, and empty cages spam -EIO at boot.

This affects boards that route none of the cage presence signal to a
software-readable input. On the NicGiga S100-0800S-M (RTL9303, 8x SFP+) the
cage I2C bus is the switch's SMBus master; TX_DISABLE is driven via a
PCA9534 I/O expander, but no MOD_ABS/MOD_DEF0 line reaches a readable GPIO
(the RTL9303 gpio0 lines read stuck-low, the single PCA9534 is fully
consumed by TX_DISABLE, and there is no RTL8231). The Horaco ZX-SW82TS-L2P
(RTL9302D, 2x SFP+) is independently affected in the same way.

For such an SFP cage, derive presence from a throttled single-byte I2C read
of the module EEPROM instead: a successful read asserts SFP_F_PRESENT,
R_PROBE_ABSENT consecutive failures clear it (to ride out a transient error
on a live module). The existing poll then emits SFP_E_INSERT / SFP_E_REMOVE
normally, giving working hot-plug and silencing the boot-time -EIO spam on
empty cages. Presence is re-probed every T_PROBE_PRESENT, so insertion is
detected within that interval and removal within
T_PROBE_PRESENT * R_PROBE_ABSENT.

A soldered-down module (compatible "sff,sff") has no presence signal and is
genuinely always present, so it continues to use sff_gpio_get_state(); the
new path is gated on the cage type advertising SFP_F_PRESENT.

Signed-off-by: Greg Patrick <gregspatrick@hotmail.com>
Tested-by: Manuel Stocker <mensi@mensi.ch>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Tested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260611175341.2223184-1-gregspatrick@hotmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: phy: sfp: detect presence via I2C when
no MOD_DEF0 GPIO`

**Local tree:** `v6.18.44` (Makefile: 6.18.44)
**Commit under review:** `8ac44d24c3a14` (on `master`, **not** in
current HEAD)
**Verdict target:** Should this be backported to **this** 6.18.y tree?

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[net: phy: sfp]` `[detect]` — SFP cage presence detection
via I2C when MOD_DEF0 GPIO is unwired.

### Step 1.2: Tags
**Record:**
- **Fixes:** — none (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** Manuel Stocker `<mensi@mensi.ch>`, Maxime Chevallier
  `<maxime.chevallier@bootlin.com>`
- **Reviewed-by:** Maxime Chevallier `<maxime.chevallier@bootlin.com>`
- **Link:** https://patch.msgid.link/20260611175341.2223184-1-
  gregspatrick@hotmail.com
- **Cc: stable:** — absent (expected, not a negative signal)
- **Signed-off-by:** Greg Patrick (author), Jakub Kicinski (netdev
  maintainer)
- **Notable:** Two independent hardware testers; subsystem reviewer
  endorsement; no syzbot/sanitizer involvement.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `sff,sfp` cages without MOD_DEF0 GPIO fall back to
  `sff_gpio_get_state()`, which unconditionally sets `SFP_F_PRESENT`. An
  empty cage probes EEPROM, fails, lands in `SFP_MOD_ERROR`, but
  `SFP_F_PRESENT` never clears → no `SFP_E_REMOVE` → hot-insert after
  boot never works; boot logs spam `-EIO`.
- **Symptom:** SFP ports permanently broken on affected switches; boot
  error noise on empty cages.
- **Affected hardware:** NicGiga S100-0800S-M (RTL9303), Horaco ZX-
  SW82TS-L2P (RTL9302D).
- **Root cause:** Treating “no MOD_DEF0 GPIO” as “module always present”
  is correct for soldered `sff,sff` modules but wrong for socketed
  `sff,sfp` cages.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Subject says “detect” rather than “fix”, but the
mechanism is a functional bug fix: broken state machine + missing hot-
plug on specific hardware. This is a hardware-workaround pattern (like
quirks), not a new user-facing API.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/phy/sfp.c` only (+80 / -3 lines)
- **Functions added:** `sfp_module_present_i2c()`, `sfp_i2c_get_state()`
- **Functions modified:** `sfp_probe()`
- **Struct fields added:** `i2c_present`, `i2c_present_nak`,
  `i2c_present_next`
- **Constants added:** `T_PROBE_PRESENT` (500 ms), `R_PROBE_ABSENT` (3)
- **Scope:** Single-file, surgical driver fix.

### Step 2.2: Code flow changes
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Probe path | No MOD_DEF0 GPIO → always `sff_gpio_get_state()` (always
present) | `sff,sfp` cage without MOD_DEF0 → `sfp_i2c_get_state()` with
throttled I2C EEPROM probe; `sff,sff` soldered modules unchanged |
| Presence source | Hardcoded `SFP_F_PRESENT` bit | I2C single-byte read
at `SFP_PHYS_ID` (0); ACK = present, NAK = absent |
| Polling | May not poll without GPIO IRQs | Sets `need_poll = true` so
`sfp_poll()` drives INSERT/REMOVE events |
| Removal detection | Never on empty cage | 3 consecutive I2C failures
clear presence (1.5 s debounce) |

### Step 2.3: Bug mechanism
**Record:** **Category:** Logic/correctness fix + hardware workaround.

Verified boot path in current tree:

```3161:3190:drivers/net/phy/sfp.c
        /* Modules that have no detect signal are always present */
        if (!(sfp->gpio[GPIO_MODDEF0]))
                sfp->get_state = sff_gpio_get_state;
        // ...
        sfp->state = sfp_get_state(sfp) | SFP_F_TX_DISABLE;
        // ...
        if (sfp->state & SFP_F_PRESENT) {
                rtnl_lock();
                sfp_sm_event(sfp, SFP_E_INSERT);
                rtnl_unlock();
        }
```

With `sff_gpio_get_state()` always OR-ing `SFP_F_PRESENT`, empty cages
always get `SFP_E_INSERT` at probe. Probe fails → `SFP_MOD_ERROR` (line
2602). `SFP_MOD_ERROR` is a terminal state with no recovery unless
`SFP_F_PRESENT` deasserts (lines 2662–2664, 3020–3022).

### Step 2.4: Fix quality
**Record:**
- **Correctness:** Sound. Gating on `sff->gpios & SFP_F_PRESENT`
  distinguishes `sff,sfp` (has presence bit in `sfp_data`) from
  `sff,sff` (no presence in `sff_data` at line 315).
- **Minimal:** Uses existing `sfp_read()`, poll infrastructure, and
  state machine.
- **Regression risk:** Low — only affects `sff,sfp` + missing MOD_DEF0
  GPIO; all other paths unchanged.
- **Reviewer note:** Maxime Chevallier confirmed no regressions on
  boards he tested.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy always-present fallback introduced in `259c8618b0099b`
(Russell King, 2017-12-14, “sfp: add sff module support”). Present since
v4.15 era; long-lived generic SFP driver bug exposed by newer RTL930x
switch boards.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag. Original intent (2017) was correct for
soldered `sff,sff` but was over-applied to socketed `sff,sfp` cages
without MOD_DEF0.

### Step 3.3: Related file history
**Record:**
- Prerequisite `bef389a210e7d` (“initialize i2c_block_size at adapter
  configure time”) **is already in this tree** — sets `i2c_block_size`
  in `sfp_i2c_configure()` (line 823).
- Patch is standalone (v3 final revision); not part of a multi-commit
  series.
- `git apply --check` on this tree: **applies cleanly**.

### Step 3.4: Author context
**Record:** Greg Patrick is a hardware-focused contributor for RTL930x
switch platforms. netdev maintainers (Kicinski) and SFP reviewer
(Chevallier) involved.

### Step 3.5: Dependencies
**Record:**
- Depends on existing SFP driver, I2C/SMBus read path, and `SFP_PHYS_ID`
  (defined in `include/linux/sfp.h` line 341) — all present in 6.18.44.
- `bef389a` (i2c_block_size init) already merged; patch also seeds
  `i2c_block_size` in probe as extra safety.
- **Can apply standalone:** Yes.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://patch.msgid.link/20260611175341.2223184-1-
  gregspatrick@hotmail.com
- **Revisions:** v1 (2026-06-02), v2 (2026-06-04), v3 (2026-06-11,
  committed version)
- **Key feedback:** Maxime Chevallier Reviewed-by + Tested-by; no NAKs;
  suggested optional follow-up dmesg warning about broken HW design (not
  blocking).
- **Stable nomination:** No explicit “Cc: stable” in thread; not a
  negative signal.

### Step 4.2: Reviewers
**Record:** Russell King, Andrew Lunn, Heiner Kallweit,
netdev@vger.kernel.org CC'd. Maxime Chevallier (Bootlin, SFP reviewer)
provided Reviewed-by and Tested-by.

### Step 4.3: Bug reports
**Record:** No syzbot/bugzilla. Real hardware reports from NicGiga and
Horaco board users via author and testers.

### Step 4.4: Series context
**Record:** Standalone 1-patch series (v1→v3 refinements only).

### Step 4.5: Stable list
**Record:** No stable@vger.kernel.org discussion found for this specific
fix. Not searched exhaustively due to lore bot protection; b4 mbox had
no stable nomination.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `sfp_module_present_i2c()`, `sfp_i2c_get_state()`,
`sfp_probe()`, plus existing `sfp_check_state()`, `sfp_poll()`,
`sfp_gpio_get_state()`, `sff_gpio_get_state()`.

### Step 5.2: Callers
**Record:**
- `sfp_i2c_get_state()` → via `sfp->get_state` from `sfp_get_state()` →
  `sfp_check_state()` (poll/IRQ path, `st_mutex` held) and `sfp_probe()`
  (init path, documented as safe without mutex).
- `sfp_poll()` runs on `system_percpu_wq` every 100 ms when `need_poll`
  is set.
- Impact surface: SFP platform devices with `compatible = "sff,sfp"` and
  no MOD_DEF0 GPIO only.

### Step 5.3: Callees
**Record:** `sfp_read()` → `sfp_i2c_read()` or `sfp_smbus_byte_read()`;
on empty cage, I2C NAK returns negative errno,
`sfp_module_present_i2c()` returns false.

### Step 5.4: Reachability
**Record:** Triggered at boot probe and ongoing poll for affected DT
configurations. Not syscall-reachable directly, but affects network port
availability — a primary function for switch/router users.

### Step 5.5: Similar patterns
**Record:** SFP subsystem already has extensive quirk/workaround
patterns for broken hardware. I2C-based presence is consistent with that
philosophy.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **Yes.** Lines 3161–3163 in current tree still use
unconditional `sff_gpio_get_state()` when MOD_DEF0 GPIO is absent. Bug
present since 2017 code landed in this tree.

### Step 6.2: Backport complications
**Record:** **Clean apply** verified via `git apply --check`. No
structural conflicts with recent `sfp.c` changes in 6.18.44.

### Step 6.3: Related fixes already present?
**Record:** Prerequisite `bef389a` (i2c_block_size) is present. The I2C
presence fix itself is **not** in HEAD (`git merge-base --is-ancestor
8ac44d24c3a14 HEAD` → NOT IN HEAD).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/phy/sfp.c` — **IMPORTANT** (network driver
infrastructure for SFP/SFF modules). Not core kernel, but affects
primary connectivity on network appliances.

### Step 7.2: Subsystem activity
**Record:** Actively maintained — frequent quirk additions and SMBus
support commits in 6.18.y history.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** **Platform-specific** — boards with `sff,sfp` DT nodes where
MOD_DEF0/MOD_ABS is not wired to a readable GPIO. Confirmed:
RTL9302/9303-based managed switches. Unaffected: boards with MOD_DEF0
GPIO, soldered `sff,sff` modules, or non-SFP configurations.

### Step 8.2: Trigger conditions
**Record:**
- **Trigger:** Boot with empty SFP cage, or insert module after boot on
  affected hardware.
- **Likelihood:** 100% on affected board designs.
- **Unprivileged trigger:** No direct security vector; requires specific
  hardware.

### Step 8.3: Failure mode severity
**Record:**
- **Failure mode:** SFP ports permanently non-functional; hot-plug
  broken; boot `-EIO` spam on empty cages.
- **Severity:** **HIGH** for affected users (complete loss of SFP
  functionality), but **not CRITICAL** (no kernel panic, deadlock, data
  corruption, or security exploit).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores working SFP and hot-plug on real production
  hardware; silences boot errors.
- **Risk:** Very low — narrow activation conditions, throttled I2C
  polling, reviewed and hardware-tested.
- **Ratio:** Strong benefit for affected platforms; minimal risk to
  others.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes a real, reproducible functional bug on shipping hardware
  (NicGiga, Horaco).
- Long-standing incorrect assumption since 2017, now exposed by newer
  boards.
- Small, single-file, applies cleanly to 6.18.44.
- Reviewed-by + dual Tested-by on real hardware.
- Hardware-workaround category (stable-appropriate).
- Prerequisites already in tree.

**AGAINST backport:**
- Not a crash/security/data-corruption issue.
- Affects a narrow hardware subset.
- Adds I2C polling behavior (new code path), though gated and throttled.
- No explicit stable nomination in mailing list.

**Unresolved:** Whether older stable branches (e.g., 6.6.y) without
RTL930x users would benefit — irrelevant here; decision is for **this**
6.18.y tree only.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — Reviewed-by, two Tested-by,
   clear mechanism.
2. Fixes a real bug affecting users? **PASS** — SFP ports broken on
   affected switches.
3. Important issue? **PASS** — Complete functional failure on affected
   hardware (HIGH, not CRITICAL).
4. Small and contained? **PASS** — ~80 lines, one file.
5. No new features/APIs? **PASS** — Fixes broken presence detection; no
   userspace API changes.
6. Can apply to local tree? **PASS** — Clean apply verified;
   prerequisites present.

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — boards with broken/missing
MOD_DEF0 presence wiring.

### Step 9.4: Decision rationale

For **linux 6.18.y** specifically: the buggy code is present, the fix
applies cleanly, prerequisites are merged, and affected RTL930x switch
platforms running 6.18 need this to get working SFP ports and hot-plug.
The fix is conservative (only activates for `sff,sfp` without MOD_DEF0
GPIO), well-reviewed, and hardware-tested. This is appropriate stable
material as a driver hardware workaround fixing a real functional
regression.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no Fixes:/Reported-by/syzbot;
  found Tested-by ×2, Reviewed-by, Link.
- [Phase 2] Analyzed full diff from `git show 8ac44d24c3a14`; confirmed
  +80/-3 lines in `sfp.c`.
- [Phase 2] Read `sff_gpio_get_state()` (lines 649–651): unconditionally
  sets `SFP_F_PRESENT`.
- [Phase 2] Read `sfp_data` vs `sff_data` gpios masks (lines 314–340):
  gating logic verified.
- [Phase 2] Read `SFP_MOD_ERROR` terminal behavior (lines 2601–2602,
  2662–2664).
- [Phase 2] Read `sfp_check_state()` INSERT/REMOVE dispatch (lines
  3020–3022).
- [Phase 3] `git blame` lines 3161–3163 → `259c8618b0099b` (2017-12-14).
- [Phase 3] `git show 259c8618b0099b`: original sff module support
  commit.
- [Phase 3] `git merge-base --is-ancestor 8ac44d24c3a14 HEAD` → NOT IN
  HEAD.
- [Phase 3] `git apply --check` → APPLIES CLEANLY.
- [Phase 3] Verified `bef389a210e7d` in tree (i2c_block_size init at
  line 823).
- [Phase 4] `b4 dig -c 8ac44d24c3a14` → lore URL found.
- [Phase 4] `b4 dig -a` → v1/v2/v3 revisions; v3 is committed version.
- [Phase 4] `b4 dig -w` → Russell King, Andrew Lunn,
  netdev@vger.kernel.org CC'd.
- [Phase 4] `b4 dig -m /tmp/sfp_i2c_presence.mbox` → Maxime Chevallier
  Reviewed-by + Tested-by, no NAKs, no stable Cc.
- [Phase 5] Traced `sfp_get_state()` → `sfp_check_state()` →
  `sfp_poll()` call chain.
- [Phase 5] Verified `SFP_PHYS_ID = 0` in `include/linux/sfp.h`.
- [Phase 5] Verified `sfp_i2c_read()` returns negative on I2C failure
  (lines 715–717).
- [Phase 6] `git describe HEAD` → v6.18.44; Makefile 6.18.44.
- [Phase 6] Confirmed buggy lines 3161–3163 exist in current tree.
- [Phase 8] Failure mode: functional SFP failure + boot -EIO spam;
  severity HIGH for affected hardware.

**YES**The background search found the commit on `master` as
`8ac44d24c3a14` (`net: phy: sfp: detect presence via I2C when no
MOD_DEF0 GPIO`). It is not in the current 6.18.44 tree, but it applies
cleanly there.

**Recommendation for this 6.18.y tree: YES** — it fixes broken SFP/hot-
plug on boards without a MOD_DEF0 GPIO (e.g. RTL9302/9303 switches), is
small and well-tested, and matches stable’s hardware-workaround pattern.

 drivers/net/phy/sfp.c | 83 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index e242c1a1238f9..1c4340b3777f6 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -206,6 +206,16 @@ static const enum gpiod_flags gpio_flags[] = {
 #define T_PROBE_RETRY_SLOW	msecs_to_jiffies(5000)
 #define R_PROBE_RETRY_SLOW	12
 
+/* Polling interval and consecutive-failure threshold for the I2C presence
+ * probe used on boards without a MOD_DEF0 GPIO (see sfp_i2c_get_state()).
+ * A single successful read asserts presence immediately; R_PROBE_ABSENT
+ * consecutive failures are required to declare a live module removed, to ride
+ * out a transient I2C error. Insertion is thus detected within
+ * T_PROBE_PRESENT and removal within T_PROBE_PRESENT * R_PROBE_ABSENT.
+ */
+#define T_PROBE_PRESENT		msecs_to_jiffies(500)
+#define R_PROBE_ABSENT		3
+
 /* SFP modules appear to always have their PHY configured for bus address
  * 0x56 (which with mdio-i2c, translates to a PHY address of 22).
  * RollBall SFPs access phy via SFP Enhanced Digital Diagnostic Interface
@@ -249,6 +259,13 @@ struct sfp {
 
 	bool need_poll;
 
+	/* I2C-probed presence, for boards without a MOD_DEF0 GPIO.
+	 * Access rules: st_mutex held (updated from the poll/state machine).
+	 */
+	bool i2c_present;
+	u8 i2c_present_nak;
+	unsigned long i2c_present_next;
+
 	/* Access rules:
 	 * state_hw_drive: st_mutex held
 	 * state_hw_mask: st_mutex held
@@ -863,6 +880,45 @@ static int sfp_read(struct sfp *sfp, bool a2, u8 addr, void *buf, size_t len)
 	return sfp->read(sfp, a2, addr, buf, len);
 }
 
+/* Probe whether a module is physically present by attempting a single-byte
+ * I2C read of the EEPROM identifier (an empty cage NAKs). Used as the presence
+ * source on boards that do not wire MOD_DEF0 to a GPIO.
+ */
+static bool sfp_module_present_i2c(struct sfp *sfp)
+{
+	u8 id;
+
+	return sfp_read(sfp, false, SFP_PHYS_ID, &id, sizeof(id)) == sizeof(id);
+}
+
+/* get_state variant for boards without a MOD_DEF0 GPIO. Instead of assuming
+ * the module is always present, derive SFP_F_PRESENT from a throttled I2C
+ * probe so that hot-insertion and removal are detected. A single ACK asserts
+ * presence; R_PROBE_ABSENT consecutive failures clear it, to ride out a
+ * transient I2C error on a live module.
+ */
+static unsigned int sfp_i2c_get_state(struct sfp *sfp)
+{
+	unsigned int state = sfp_gpio_get_state(sfp);
+
+	if (time_after_eq(jiffies, sfp->i2c_present_next)) {
+		if (sfp_module_present_i2c(sfp)) {
+			sfp->i2c_present = true;
+			sfp->i2c_present_nak = 0;
+		} else if (sfp->i2c_present &&
+			   ++sfp->i2c_present_nak >= R_PROBE_ABSENT) {
+			sfp->i2c_present = false;
+			sfp->i2c_present_nak = 0;
+		}
+		sfp->i2c_present_next = jiffies + T_PROBE_PRESENT;
+	}
+
+	if (sfp->i2c_present)
+		state |= SFP_F_PRESENT;
+
+	return state;
+}
+
 static int sfp_write(struct sfp *sfp, bool a2, u8 addr, void *buf, size_t len)
 {
 	return sfp->write(sfp, a2, addr, buf, len);
@@ -3168,9 +3224,30 @@ static int sfp_probe(struct platform_device *pdev)
 	sfp->get_state = sfp_gpio_get_state;
 	sfp->set_state = sfp_gpio_set_state;
 
-	/* Modules that have no detect signal are always present */
-	if (!(sfp->gpio[GPIO_MODDEF0]))
-		sfp->get_state = sff_gpio_get_state;
+	/* An SFP cage with no MOD_DEF0 GPIO has no hardware presence signal.
+	 * Assuming the module is always present traps an empty cage in
+	 * MOD_ERROR and never detects hot-insertion, so derive presence from a
+	 * throttled I2C probe and poll for changes instead. sfp_i2c_configure()
+	 * has already set i2c_max_block_size; seed i2c_block_size so the
+	 * presence read does not issue a zero-length transfer before the first
+	 * EEPROM read. Seed i2c_present_next to jiffies so the first probe
+	 * happens immediately (a zero value would be in the past relative to
+	 * the negative INITIAL_JIFFIES at boot and delay detection).
+	 *
+	 * A soldered-down module (sff,sff) has no presence signal and is
+	 * genuinely always present, so it keeps the always-present behaviour;
+	 * the I2C probe is gated on the cage type advertising SFP_F_PRESENT.
+	 */
+	if (!sfp->gpio[GPIO_MODDEF0]) {
+		if (sff->gpios & SFP_F_PRESENT) {
+			sfp->get_state = sfp_i2c_get_state;
+			sfp->i2c_block_size = sfp->i2c_max_block_size;
+			sfp->i2c_present_next = jiffies;
+			sfp->need_poll = true;
+		} else {
+			sfp->get_state = sff_gpio_get_state;
+		}
+	}
 
 	device_property_read_u32(&pdev->dev, "maximum-power-milliwatt",
 				 &sfp->max_power_mW);
-- 
2.53.0

