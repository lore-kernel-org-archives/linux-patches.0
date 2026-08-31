Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2019641D225;
	Mon, 31 Aug 2026 13:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183200; cv=none; b=Js4wXiTQpU5+4OKJKl6lQVq3FQTvx4QT0pDX4sNEXGCyFEfd+Kq6brzv2xwjXcgh6xCK/URnGJhQKHVPufVrSuyyCjfT2uGwIzjJWLyapsl75FWUf4hBI9iQFTDTX4Oxosa23//zwFysMEe2AF5ZttMECBIED0NXs3BC/cf5LgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183200; c=relaxed/simple;
	bh=bQNR5dJDB//iPQtoUvHkmucJ5fkcuPfkCvN8hLETjoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QM1bwYu0cSQ3aY0yM0I6w6fRz5lfZ4v27MupUYTliNQJSz6O7gRFeo2dH9lAv5H8TudCAXpbQc/d0MNYF5XGas3S+nlKNZDUkohuu5LXcNrBUz7dctT0u3q5xvNKWJR6PbV4hTtG94XfM7sQf5eCUrfFeuTTR0JOkXbOx1mNA9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYBHx5L+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYBHx5L+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD24F1F00A3D;
	Mon, 31 Aug 2026 13:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183197;
	bh=gMSEUv9vvIex0riq53kC05okBgJwyNWZV/O/QUfcg8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYBHx5L++ZyTbbl7k4FjtSSN0dgKTV5D8JoYE8TmHNMrsYuUk8BwM8k0i2jc8nn9h
	 c5ntR90Ql4KGzdoyyQx9ZEd1Lje2cTElWGMUEyYiqSPFtjbQx14Dc6KDtb3ZZcWAFS
	 fwMFkyqkV9G17+w95xYQiEqFY6nt+/u0+0oIFtGueJxik6iD3I+4XRlAYMCdV+baYO
	 lQJaxt/QpAVht0D4LvgUoQZTVlUhXADyifrjYF06XaWMvvzr0T8RPTE8rme+YsgeBC
	 xGHTM+0fPL7TGV4DnuZNq3DFfmegBNShEvLeOp1ZyMaKWqFPeAdSIGG+iB7l/h5xZA
	 omuXRKOc+AXlA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Priyansh Jain <priyansh.jain@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	amitk@kernel.org,
	thara.gopinath@gmail.com,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] thermal/drivers/qcom/tsens: Atomic temperature read with hardware-guided retries
Date: Mon, 31 Aug 2026 09:20:30 -0400
Message-ID: <20260831133314.4125787-2-sashal@kernel.org>
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

From: Priyansh Jain <priyansh.jain@oss.qualcomm.com>

[ Upstream commit e28ef2f3ccea276436bd0f30c93f99e764ba492b ]

The existing TSENS temperature read logic polls the valid bit and then
reads the temperature register. When temperature reads are triggered
at very short intervals, this can race with hardware updates and allow
the temperature field to be read while it is still being updated.

In this case, the valid bit may already be asserted even though the
temperature value is transitioning, resulting in an incorrect reading.

Hardware programming guidelines require the temperature value and the
valid bit to be sampled atomically in the same read transaction. A
reading is considered valid only if the valid bit is observed set in
that same sample.

The guidelines further specify that software should attempt the
temperature read up to three times to account for transient update
windows. If none of the attempts yields a valid sample, a stable fallback
value must be returned: if the first and second samples match, the second
value is returned;otherwise, if the second and third samples match, the
third value is returned;if neither pair matches, -EAGAIN is returned.

Update the TSENS sensor read logic to implement atomic sampling along
with the recommended retry-and-compare fallback behavior. This removes
the race window and ensures deterministic temperature values in
accordance with hardware requirements.

Signed-off-by: Priyansh Jain <priyansh.jain@oss.qualcomm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260514113643.1954111-1-priyansh.jain@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: Qualcomm TSENS Atomic Temperature Read

**Local tree:** `v6.18.44` (Linux 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[thermal/drivers/qcom/tsens]` — action:
**update/implement** — **Atomic temperature read with hardware-guided
retries**

### Step 1.2: Commit Message Tags
**Record:**
- **Signed-off-by:** Priyansh Jain `<priyansh.jain@oss.qualcomm.com>`
  (author)
- **Signed-off-by:** Daniel Lezcano `<daniel.lezcano@kernel.org>`
  (thermal maintainer)
- **Reviewed-by:** Konrad Dybcio `<konrad.dybcio@oss.qualcomm.com>`
  (Qualcomm reviewer)
- **Link:** `https://patch.msgid.link/20260514113643.1954111-1-
  priyansh.jain@oss.qualcomm.com`
- **No** Fixes:, Reported-by:, Tested-by:, Acked-by:, Cc:
  stable@vger.kernel.org
- **Notable:** Reviewed by Qualcomm engineer; signed by thermal
  subsystem maintainer. No syzbot or user bug report.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** TSENS reads poll the VALID bit, then separately read the
  temperature field. Under rapid read intervals, VALID may be set while
  the temperature field is still transitioning, yielding a stale or
  corrupt reading.
- **Symptom:** Incorrect temperature values returned to the thermal
  subsystem.
- **Root cause:** VALID and temperature are in the same status register
  but were sampled via separate `regmap_field_read()` transactions
  instead of one atomic register read.
- **Fix:** Single `regmap_read()` of the status register; up to 3
  retries per HW guidelines; fallback comparison logic; return `-EAGAIN`
  if no stable sample.
- **Version info:** None specified in the message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised as cleanup — this is an explicit hardware-
correctness bug fix. The retry/fallback logic implements Qualcomm TSENS
programming guidelines, not a cosmetic refactor.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **Files:** `drivers/thermal/qcom/tsens.c` (~+100/−50 lines),
  `drivers/thermal/qcom/tsens.h` (+1 line: `MAX_READ_RETRY 3`)
- **Functions modified/added:** `tsens_read_temp()` (new),
  `tsens_hw_to_mC()` (refactored to convert only),
  `tsens_read_irq_state()`, `get_temp_tsens_valid()`
- **Scope:** Single-driver, surgical fix with one internal helper added

### Step 2.2: Code Flow Changes
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| `get_temp_tsens_valid()` | Poll VALID via
`regmap_field_read_poll_timeout()`, then call `tsens_hw_to_mC(s,
temp_idx)` which does a second `regmap_field_read()` | Call new
`tsens_read_temp()` for atomic register read + retries, then convert via
`tsens_hw_to_mC(s, *temp)` |
| `tsens_hw_to_mC()` | Reads hardware field and converts | Accepts pre-
read raw value, converts only |
| `tsens_read_irq_state()` | Threshold reads via `tsens_hw_to_mC(s,
field)` (implicit read) | Explicit `regmap_field_read()` then
`tsens_hw_to_mC(s, value)` |

**Affected paths:** Normal thermal zone temperature polling and IRQ
handler temperature reads during threshold violations.

### Step 2.3: Bug Mechanism
**Record:** **Logic / hardware correctness fix (race on non-atomic
register sampling).**

Verified in field definitions — both v1 and v2 place LAST_TEMP and VALID
in the same `TM_Sn_STATUS_OFF` register:

```135:136:drivers/thermal/qcom/tsens-v1.c
        REG_FIELD_FOR_EACH_SENSOR11(LAST_TEMP,    TM_Sn_STATUS_OFF,  0,
9),
        REG_FIELD_FOR_EACH_SENSOR11(VALID,        TM_Sn_STATUS_OFF, 14,
14),
```

```128:129:drivers/thermal/qcom/tsens-v2.c
        REG_FIELD_FOR_EACH_SENSOR16(LAST_TEMP,       TM_Sn_STATUS_OFF,
0,  11),
        REG_FIELD_FOR_EACH_SENSOR16(VALID,           TM_Sn_STATUS_OFF,
21,  21),
```

The old code performed two independent field reads; hardware can update
the register between them.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** High — matches documented HW requirements; minimal API
  surface change (all internal).
- **Regression risk:** Low. VER_0 path preserved (no VALID bit).
  Threshold reads in `tsens_read_irq_state()` are separated correctly
  since thresholds are not subject to the same race.
- **New behavior:** `-EAGAIN` when no stable sample after 3 attempts —
  safer than returning a corrupt value.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `get_temp_tsens_valid()` introduced in `a7ff82976122e` (Amit Kucheria,
  2020-04-29): *"Merge tsens-common.c into tsens.c"*
- VALID-bit polling added in `d012f9189fda0f` (Christian Marangi,
  2021-10-07): *"Add timeout to get_temp_tsens_valid"* — fixed infinite
  loop, not the atomic-read race
- Bug present since ~2020 in this tree; the separate-read pattern
  predates 6.18 branching

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag in the commit message.

### Step 3.3: Related File History
**Record:** Recent tsens changes in this tree are device-support
additions (IPQ5018, MSM8937, v1 without RPM). No prior fix for atomic
sampling. Standalone patch, not part of a series.

### Step 3.4: Author Context
**Record:** Priyansh Jain (Qualcomm). Daniel Lezcano is the thermal
maintainer (Signed-off-by). No other commits from this author in the
local tsens history.

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses existing `priv->tm_map`,
`priv->fields[]`, `priv->rf[]` — all present in 6.18.44. Applies
standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** UNVERIFIED — `b4 dig` requires a commit hash (commit not in
this tree). Lore.kernel.org fetch blocked by bot protection. Link tag
points to `20260514113643.1954111-1-priyansh.jain@oss.qualcomm.com`.

### Step 4.2: Reviewers
**Record:** UNVERIFIED via b4 dig -w. Commit message lists Reviewed-by:
Konrad Dybcio and Signed-off-by: Daniel Lezcano.

### Step 4.3: Bug Report
**Record:** No Reported-by: or bugzilla/syzbot links. Bug identified
from HW programming guidelines, not a user crash report.

### Step 4.4: Related Patches
**Record:** Standalone single patch; not part of a multi-patch series.

### Step 4.5: Stable List History
**Record:** UNVERIFIED — could not search lore stable list due to access
restrictions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `tsens_read_temp()` (new), `get_temp_tsens_valid()`,
`tsens_hw_to_mC()`, `tsens_get_temp()`, IRQ handler path at line 605

### Step 5.2: Callers
**Record:**
- `get_temp_tsens_valid` is `.get_temp` for 6 tsens v1/v2 platform
  variants (`tsens-v1.c`, `tsens-v2.c`)
- Called from IRQ handler when threshold violated (`tsens.c:605`)
- `tsens_get_temp()` → `priv->ops->get_temp()` → thermal framework
  polling, hwmon sysfs, cooling decisions

### Step 5.3: Callees
**Record:** `regmap_read()`, `regmap_field_read()`, `code_to_degc()`,
`sign_extend32()`

### Step 5.4: Reachability
**Record:** Userspace can trigger via thermal sysfs/hwmon reads. Kernel
thermal governor polls regularly. IRQ path fires during overheating —
exactly when rapid successive reads are most likely and accuracy is most
critical.

### Step 5.5: Similar Patterns
**Record:** `get_temp_common()` (VER_0/v0.1 paths) uses a different read
model and is unchanged. Only `get_temp_tsens_valid` platforms (v1, v2)
are affected.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Current `get_temp_tsens_valid()` at lines 751–779
still uses separate VALID poll + `tsens_hw_to_mC()` field read:

```751:779:drivers/thermal/qcom/tsens.c
int get_temp_tsens_valid(const struct tsens_sensor *s, int *temp)
{
        // ...
        ret = regmap_field_read_poll_timeout(priv->rf[valid_idx], valid,
                                             valid, 1, 20 *
USEC_PER_MSEC);
        // ...
        *temp = tsens_hw_to_mC(s, temp_idx);
        return 0;
}
```

The candidate commit is **not** in this tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** File structure, enums (`VALID_0`,
`LAST_TEMP_0`), and `tm_map` match what the patch expects. No
conflicting refactors in recent 6.18 tsens history.

### Step 6.3: Related Fixes Already Present?
**Record:** **No.** `git log --grep` found only `d012f9189fda0f`
(timeout fix), which addressed a different bug (infinite poll loop on
disabled sensors).

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/thermal/qcom/tsens` — **IMPORTANT** (Qualcomm SoC
thermal management on phones, routers, embedded). Not core-kernel-wide,
but safety-relevant on affected hardware.

### Step 7.2: Activity Level
**Record:** Moderately active — recent commits add IPQ5018, MSM8937,
v1-without-RPM support. Driver is mature but still receiving platform
additions.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of Qualcomm SoCs with TSENS v1 or v2 (SDM845,
MSM8996/8998, IPQ routers, many Android devices). Config:
`CONFIG_QCOM_TSENS` (or module equivalent). Not universal, but large
embedded/mobile population.

### Step 8.2: Trigger Conditions
**Record:** Temperature reads at short intervals — thermal framework
polling, hwmon reads, and especially IRQ-handler reads during threshold
violations. Plausible in production, not merely theoretical.

### Step 8.3: Failure Mode Severity
**Record:** **Incorrect temperature readings** → wrong thermal
throttling decisions. Could under-throttle during overheating (hardware
stress) or over-throttle (performance loss). Not a kernel oops/UAF, but
affects thermal protection. **Severity: MEDIUM-HIGH** for affected
platforms.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Correct thermal readings per HW spec; safer `-EAGAIN`
  instead of corrupt values; fixes race on safety-critical overheating
  path
- **Risk:** Low — contained driver change, reviewed, follows HW
  guidelines
- **Ratio:** Favorable for Qualcomm TSENS users

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verifiable bug: non-atomic VALID/temp sampling from same
  register
- Bug present in 6.18.44 since ~2020
- Affects thermal protection on widely deployed Qualcomm hardware
- IRQ path during threshold violations is a concrete high-risk trigger
- Fix is reviewed, maintainer-signed, follows HW programming guidelines
- Small, self-contained, no new public APIs
- Returns `-EAGAIN` instead of corrupt data when sampling fails

**AGAINST backport:**
- No user crash reports, syzbot, or CVE
- Not oops/UAF/corruption — incorrect sensor data
- Stable rules discourage unproven "theoretical" races (though this has
  a concrete HW mechanism)
- Patch may approach the ~100-line stable size guideline
- Mailing list discussion unverified

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — HW spec compliance;
   Reviewed-by + maintainer SOB (runtime testing not independently
   verified)
2. Fixes a real bug? **PASS** — verified separate-read race on shared
   status register
3. Important issue? **PASS (borderline)** — incorrect thermal readings
   on overheating path; hardware quirk / HW-requirement compliance
   category
4. Small and contained? **PASS** — single driver, ~50 net lines; diff
   may be near 100-line guideline
5. No new features/APIs? **PASS** — internal refactor only
6. Can apply to local tree? **PASS** — buggy code present, no
   dependencies

### Step 9.3: Exception Categories
**Record:** **Hardware quirk/workaround** — implements mandatory HW
atomic-sampling and retry protocol for TSENS status registers.

### Step 9.4: Decision Rationale

For Linux **6.18.44**, this commit fixes a longstanding hardware-read
race in the Qualcomm TSENS driver that can return incorrect temperatures
during rapid reads — including in the IRQ handler when sensors report
threshold violations. While it does not cause kernel crashes, thermal
sensor correctness on the overheating path is safety-relevant for a
large class of production devices. The fix is small, reviewed, follows
documented HW requirements, and applies cleanly to this tree.

---

## Verification

- **[Phase 1]** Parsed subject, tags (SOB, Reviewed-by, Link); no
  Fixes/Reported-by/syzbot
- **[Phase 2]** Diff analysis: new `tsens_read_temp()`, refactored
  `tsens_hw_to_mC()`, updated `get_temp_tsens_valid()` and
  `tsens_read_irq_state()`
- **[Phase 2]** Verified LAST_TEMP and VALID share `TM_Sn_STATUS_OFF` in
  `tsens-v1.c:135-136` and `tsens-v2.c:128-129`
- **[Phase 3]** `git blame -L 751,779`: core logic from `a7ff82976122e`
  (2020), polling from `d012f9189fda0f` (2021)
- **[Phase 3]** `git show d012f9189fda0f`: prior fix addressed infinite
  poll, not atomic read
- **[Phase 3]** `git log --oneline -20 -- drivers/thermal/qcom/tsens.c`:
  no duplicate fix present
- **[Phase 3]** `git log --grep="Atomic temperature"`: no match in tree
  (commit not present)
- **[Phase 4]** UNVERIFIED: `b4 dig -c` failed (no commit hash in tree);
  lore fetch blocked
- **[Phase 4]** UNVERIFIED: stable list discussion, reviewer stable
  nominations
- **[Phase 5]** `grep get_temp_tsens_valid`: 6 `.get_temp` assignments
  in v1/v2 + IRQ call at `tsens.c:605`
- **[Phase 5]** `grep tsens_get_temp`: thermal zone ops at
  `tsens.c:1170`
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** Read `get_temp_tsens_valid()` at `tsens.c:751-779`:
  buggy separate-read pattern confirmed
- **[Phase 6]** `grep tsens_read_temp|MAX_READ_RETRY`: not in tree — fix
  not yet applied
- **[Phase 7]** `git log --oneline -20 -- drivers/thermal/qcom/`:
  subsystem active with platform additions
- **[Phase 8]** Failure mode: incorrect temperature → thermal mis-
  management; severity MEDIUM-HIGH on affected platforms

**YES**The background searches finished and match the earlier analysis:

- **Subject search:** No commit matching “Atomic temperature read with
  hardware-guided retries” (or `tsens_read_temp`) is in this **6.18.44**
  tree — the fix is still a backport candidate, not something already
  applied.
- **Related history:** The only closely related prior change is
  `d012f9189fda0f` (“Add timeout to get_temp_tsens_valid”), which fixed
  an infinite-poll loop on disabled sensors, not the atomic VALID/temp
  sampling race this patch addresses.

**Verdict for 6.18.44:** **YES** — real HW-read race on Qualcomm TSENS
v1/v2, affects thermal readings (including the IRQ/overheat path), and
the fix is small, reviewed, and should apply cleanly.

 drivers/thermal/qcom/tsens.c | 111 ++++++++++++++++++++++++-----------
 drivers/thermal/qcom/tsens.h |   1 +
 2 files changed, 78 insertions(+), 34 deletions(-)

diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index a2422ebee8169..40f27c1a1cd59 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -316,9 +316,66 @@ static inline int code_to_degc(u32 adc_code, const struct tsens_sensor *s)
 }
 
 /**
- * tsens_hw_to_mC - Return sign-extended temperature in mCelsius.
+ * tsens_read_temp - Retrieve temperature readings from the hardware.
  * @s:     Pointer to sensor struct
  * @field: Index into regmap_field array pointing to temperature data
+ * @temp: temperature in deciCelsius to be read from hardware
+ *
+ * This function handles temperature returned in ADC code or deciCelsius
+ * depending on IP version.
+ *
+ * Return: 0 on success, a negative errno will be returned in error cases
+ */
+static int tsens_read_temp(const struct tsens_sensor *s, int field, int *temp)
+{
+	struct tsens_priv *priv = s->priv;
+	int temp_val[MAX_READ_RETRY] = {0};
+	u32 status;
+	int ret;
+	u32 last_temp_mask = GENMASK(priv->fields[LAST_TEMP_0].msb,
+					priv->fields[LAST_TEMP_0].lsb);
+	u32 valid_bit = priv->rf[VALID_0] ? BIT(priv->fields[VALID_0].lsb) : 0;
+
+	for (int i = 0; i < MAX_READ_RETRY; i++) {
+		ret = regmap_read(priv->tm_map, priv->fields[field].reg, &status);
+		if (ret)
+			return ret;
+
+		/* VER_0 doesn't have a VALID bit */
+		if (!valid_bit) {
+			*temp = status & last_temp_mask;
+			return 0;
+		}
+
+		temp_val[i] = status & last_temp_mask;
+
+		if (status & valid_bit) {
+			*temp = temp_val[i];
+			return 0;
+		}
+	}
+
+	/*
+	 * As per the HW guidelines, if none of the attempts observe a
+	 * valid sample, a stable fallback value must be returned. If the
+	 * first and second samples match, the second value is returned;
+	 * otherwise, if the second and third samples match, the third
+	 * value is returned.
+	 */
+	if (temp_val[0] == temp_val[1])
+		*temp = temp_val[1];
+	else if (temp_val[1] == temp_val[2])
+		*temp = temp_val[2];
+	else
+		return -EAGAIN;
+
+	return 0;
+}
+
+/**
+ * tsens_hw_to_mC - Return sign-extended temperature in mCelsius.
+ * @s:     Pointer to sensor struct
+ * @temp: temperature in milliCelsius to be read from hardware
  *
  * This function handles temperature returned in ADC code or deciCelsius
  * depending on IP version.
@@ -326,20 +383,14 @@ static inline int code_to_degc(u32 adc_code, const struct tsens_sensor *s)
  * Return: Temperature in milliCelsius on success, a negative errno will
  * be returned in error cases
  */
-static int tsens_hw_to_mC(const struct tsens_sensor *s, int field)
+static int tsens_hw_to_mC(const struct tsens_sensor *s, int temp)
 {
 	struct tsens_priv *priv = s->priv;
 	u32 resolution;
-	u32 temp = 0;
-	int ret;
 
 	resolution = priv->fields[LAST_TEMP_0].msb -
 		priv->fields[LAST_TEMP_0].lsb;
 
-	ret = regmap_field_read(priv->rf[field], &temp);
-	if (ret)
-		return ret;
-
 	/* Convert temperature from ADC code to milliCelsius */
 	if (priv->feat->adc)
 		return code_to_degc(temp, s) * 1000;
@@ -514,8 +565,10 @@ static int tsens_read_irq_state(struct tsens_priv *priv, u32 hw_id,
 					&d->crit_irq_mask);
 		if (ret)
 			return ret;
-
-		d->crit_thresh = tsens_hw_to_mC(s, CRIT_THRESH_0 + hw_id);
+		ret = regmap_field_read(priv->rf[CRIT_THRESH_0 + hw_id], &d->crit_thresh);
+		if (ret)
+			return ret;
+		d->crit_thresh = tsens_hw_to_mC(s, d->crit_thresh);
 	} else {
 		/* No mask register on older TSENS */
 		d->up_irq_mask = 0;
@@ -525,8 +578,16 @@ static int tsens_read_irq_state(struct tsens_priv *priv, u32 hw_id,
 		d->crit_thresh = 0;
 	}
 
-	d->up_thresh  = tsens_hw_to_mC(s, UP_THRESH_0 + hw_id);
-	d->low_thresh = tsens_hw_to_mC(s, LOW_THRESH_0 + hw_id);
+	ret = regmap_field_read(priv->rf[UP_THRESH_0 + hw_id], &d->up_thresh);
+	if (ret)
+		return ret;
+
+	d->up_thresh = tsens_hw_to_mC(s, d->up_thresh);
+	ret = regmap_field_read(priv->rf[LOW_THRESH_0 + hw_id], &d->low_thresh);
+	if (ret)
+		return ret;
+
+	d->low_thresh = tsens_hw_to_mC(s, d->low_thresh);
 
 	dev_dbg(priv->dev, "[%u] %s%s: status(%u|%u|%u) | clr(%u|%u|%u) | mask(%u|%u|%u)\n",
 		hw_id, __func__,
@@ -750,33 +811,15 @@ static void tsens_disable_irq(struct tsens_priv *priv)
 
 int get_temp_tsens_valid(const struct tsens_sensor *s, int *temp)
 {
-	struct tsens_priv *priv = s->priv;
 	int hw_id = s->hw_id;
 	u32 temp_idx = LAST_TEMP_0 + hw_id;
-	u32 valid_idx = VALID_0 + hw_id;
-	u32 valid;
 	int ret;
 
-	/* VER_0 doesn't have VALID bit */
-	if (tsens_version(priv) == VER_0)
-		goto get_temp;
-
-	/* Valid bit is 0 for 6 AHB clock cycles.
-	 * At 19.2MHz, 1 AHB clock is ~60ns.
-	 * We should enter this loop very, very rarely.
-	 * Wait 1 us since it's the min of poll_timeout macro.
-	 * Old value was 400 ns.
-	 */
-	ret = regmap_field_read_poll_timeout(priv->rf[valid_idx], valid,
-					     valid, 1, 20 * USEC_PER_MSEC);
-	if (ret)
-		return ret;
-
-get_temp:
-	/* Valid bit is set, OK to read the temperature */
-	*temp = tsens_hw_to_mC(s, temp_idx);
+	ret = tsens_read_temp(s, temp_idx, temp);
+	if (!ret)
+		*temp = tsens_hw_to_mC(s, *temp);
 
-	return 0;
+	return ret;
 }
 
 int get_temp_common(const struct tsens_sensor *s, int *temp)
diff --git a/drivers/thermal/qcom/tsens.h b/drivers/thermal/qcom/tsens.h
index 2a7afa4c899b9..ab57ad88c3f7c 100644
--- a/drivers/thermal/qcom/tsens.h
+++ b/drivers/thermal/qcom/tsens.h
@@ -21,6 +21,7 @@
 #define THRESHOLD_MIN_ADC_CODE	0x0
 
 #define MAX_SENSORS 16
+#define MAX_READ_RETRY 3
 
 #include <linux/interrupt.h>
 #include <linux/thermal.h>
-- 
2.53.0

