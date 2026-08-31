Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD805237AD;
	Mon, 31 Aug 2026 13:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183948; cv=none; b=NrlDY6g32mM85Algp/muE5m0bbqmC8Mgf/GroQBBX/o+hestsgNJSflFWEpevsfYNvuraiaUFl7DjIPFupfNIxtciy5L3WLu+tu+1gaQws3IT5S0YiObDAxQho71OMf14tytK8hd6kVWilDzixLFCBa6G3XF1FTFEsCmNvvgV68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183948; c=relaxed/simple;
	bh=VFTank4KnXrqoWA9IhKfAWTKMrP6v9SuYh+ZIK1Pt0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GMWVR9G/jTRnhAk/I0WZW14HSaVMKVMCw5I6LGy0NhQNmYXOdp/G0zaQJuWTYuqOCtDGNQPs1LkkQvln+ySV95i+0XCB8K6nUrEPLtkC//eZwEpGZetTPBrClySK8WUBoTMsDQT7YGjhxtUcqVvdAVCD5rHDTo0o5R+WIXiZOgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHp9wzzu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHp9wzzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8AA1F00A3E;
	Mon, 31 Aug 2026 13:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183945;
	bh=BuW2cvZUIHyrbTuNd4aMOXqsgxrULTBSLmkEYC9dwwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHp9wzzuAjDLO3Ji5rS0DjEGoCI+1CODl+qIGVtVYJDanBWtzDPZMs6nSGGwOuJWx
	 8zafGX78oDEM4dQxtbSujED606QFR07KqD+OUqC6VlrGOYgM92G4x23rgcd1xjn6EZ
	 M5aR0BhdoaouNF/5DLOo/g335AFaXJEdPeZPcPAupmb/IOVFjhjKJBhcucaTYJZoBn
	 UxvxBnZTeF5vGGJw4gq58BfbTbyy5Q7axuJ+vAgqsP7rx5r/rnr8IQbe1p8XIfu8vt
	 0U89Rd1A9JSZS3V3oMn3yRFB8szXR2fwoQ8gSvxjCgY/QH09iheWfR1KDeZdyYGoi3
	 ggIgCBLGZtdlA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stepan Ionichev <sozdayvek@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] iio: adc: qcom-spmi-iadc: balance enable_irq_wake() on driver unbind
Date: Mon, 31 Aug 2026 09:27:04 -0400
Message-ID: <20260831133314.4125787-396-sashal@kernel.org>
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

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit 929fec2964f71d4b1ac664ee963d8226c5cf01c6 ]

iadc_probe() calls enable_irq_wake() after a successful
devm_request_irq(), but the driver has no remove callback or
matching disable_irq_wake(), so the wake reference count on the
IRQ is leaked on module unload or driver unbind.

Check the IRQ request error first, then register a devm action
that calls disable_irq_wake() so the wake reference is released
in the same scope as the enable. While here, drop the inverted
"if (!ret) ... else return ret" in favour of the standard
"if (ret) return ret;" pattern.

Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `iio: adc: qcom-spmi-iadc: balance
enable_irq_wake() on driver unbind`

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[iio: adc: qcom-spmi-iadc]` `[balance]` — fix unbalanced
`enable_irq_wake()` / missing `disable_irq_wake()` on driver teardown.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Stepan Ionichev `<sozdayvek@gmail.com>` (author)
- **Signed-off-by:** Jonathan Cameron `<jic23@kernel.org>` (IIO
  maintainer, committer)
- **Fixes:** `ce0694841ea6` (in v3 submission; absent from user-provided
  message but verified in lore v3)
- No Reported-by, Tested-by, Cc: stable, or Link: tags in provided
  message
- Notable: v3 lore thread has **Reviewed-by: Konrad Dybcio** (Qualcomm)

### Step 1.3: Body analysis
**Record:**
- **Bug:** `iadc_probe()` calls `enable_irq_wake()` after successful
  `devm_request_irq()`, but there is no `.remove` callback and no
  matching `disable_irq_wake()`.
- **Symptom:** IRQ `wake_depth` reference count is leaked on module
  unload or driver unbind.
- **Root cause:** Asymmetric IRQ wake enable/disable lifecycle.
- **Fix approach:** Register `devm_add_action_or_reset()` to call
  `disable_irq_wake()` at device teardown; also check
  `enable_irq_wake()` return value and normalize error-handling style.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit resource-leak / PM lifecycle bug
fix, not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/iio/adc/qcom-spmi-iadc.c` (+15 / -3 lines)
- **Functions:** new `iadc_disable_irq_wake()`, modified `iadc_probe()`
- **Scope:** Single-file, surgical driver fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (new helper):** Adds `iadc_disable_irq_wake()` that calls
  `disable_irq_wake((unsigned long)data)`.
- **Hunk 2 (probe IRQ path):**
  - **Before:** `devm_request_irq()` → on success call
    `enable_irq_wake()` (return value ignored); on failure return.
  - **After:** `devm_request_irq()` → return on error →
    `enable_irq_wake()` with error check →
    `devm_add_action_or_reset(iadc_disable_irq_wake)` with error check.
  - **After:** `disable_irq_wake()` runs automatically when the device
    is released (unbind/remove), balancing the earlier
    `enable_irq_wake()`.

### Step 2.3: Bug mechanism
**Record:** **Category:** Resource leak / reference-counting (IRQ wake
depth).
- `enable_irq_wake()` → `irq_set_irq_wake(irq, 1)` increments
  `desc->wake_depth` (see `kernel/irq/manage.c:872`).
- Without matching `disable_irq_wake()`, `wake_depth` never returns to
  zero on unbind.
- IRQ remains in `IRQD_WAKEUP_STATE`; repeated probe/unbind cycles can
  accumulate `wake_depth`.

### Step 2.4: Fix quality
**Record:** Obviously correct; mirrors established pattern in
`drivers/rtc/rtc-isl1208.c` (`isl1208_disable_irq_wake_action` +
`devm_add_action_or_reset`). Minimal regression risk. Slight behavior
change: `enable_irq_wake()` failure now fails probe (old code ignored
its return value); reviewers confirmed this is acceptable for QC SPMI
platforms.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `enable_irq_wake(irq_eoc)` at line 542 in local tree. `git
show ce0694841ea6` confirms `enable_irq_wake` was present in the
original 2014 driver import — bug present since driver introduction.

### Step 3.2: Fixes: tag
**Record:** `Fixes: ce0694841ea6` ("iio: iadc: Qualcomm SPMI PMIC
current ADC driver", Oct 2014). That commit exists in this tree; driver
and buggy `enable_irq_wake` call are present.

### Step 3.3: Related file history
**Record:** Autosel checkout has flattened history (`git log --
drivers/iio/adc/qcom-spmi-iadc.c` shows only one unrelated commit). File
content verified directly. No evidence of a prior fix for this issue in
the tree.

### Step 3.4: Author context
**Record:** Stepan Ionichev submitted multiple IIO driver fixes in 2026.
Jonathan Cameron (IIO maintainer) reviewed and merged. Konrad Dybcio
(Qualcomm) reviewed v3.

### Step 3.5: Dependencies
**Record:** Standalone. Uses `devm_add_action_or_reset()` (available in
`include/linux/device/devres.h` in this tree). No series dependencies.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- v1: https://lkml.iu.edu/2605.2/09223.html (May 20, 2026)
- v3 review: https://lists.openwall.net/linux-kernel/2026/07/06/2032
- Jonathan Cameron reviewed v1 (May 26, 2026); v3 got Reviewed-by from
  Konrad Dybcio
- Merged via Jonathan Cameron's 7.2-rc1 IIO pull (June 22, 2026)
- No explicit stable nomination found in fetched threads

### Step 4.2: Reviewers
**Record:** Jonathan Cameron (IIO maintainer), Konrad Dybcio (Qualcomm),
CC'd linux-iio, linux-arm-msm.

### Step 4.3: Bug reports
**Record:** No syzbot or user crash reports. Bug identified via code
review / static lifecycle analysis.

### Step 4.4: Series context
**Record:** v1 → v3 revisions; cast style adjusted per maintainer
feedback. Final committed version matches v3.

### Step 4.5: Stable list
**Record:** No stable-list discussion found (not searched exhaustively
due to lore access limits).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iadc_disable_irq_wake()` (new), `iadc_probe()` (modified),
`iadc_isr()` (unchanged, IRQ handler).

### Step 5.2: Callers
**Record:** `iadc_probe()` registered as `.probe` in `iadc_driver`
platform driver; invoked during device enumeration on `qcom,spmi-iadc`
compatible nodes. `iadc_isr()` called from IRQ context during ADC
conversions.

### Step 5.3: Callees
**Record:** `devm_request_irq()`, `enable_irq_wake()`,
`devm_add_action_or_reset()`, `disable_irq_wake()` (via devm action on
teardown).

### Step 5.4: Reachability
**Record:** Probe runs at boot on Qualcomm SPMI PMIC platforms. Leak
triggers on driver unbind (`rmmod` if modular) or device rebinding —
uncommon in production but real in development/testing and modular
builds.

### Step 5.5: Similar patterns
**Record:** Identical devm pattern in `rtc-isl1208.c`. Other IIO drivers
(e.g. `st_lsm6dsx`) balance enable/disable via suspend/resume PM ops;
this driver has no PM ops, making devm action the correct approach.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at `drivers/iio/adc/qcom-spmi-
iadc.c:538-544`:

```538:544:drivers/iio/adc/qcom-spmi-iadc.c
        if (!iadc->poll_eoc) {
                ret = devm_request_irq(dev, irq_eoc, iadc_isr, 0,
                                        "spmi-iadc", iadc);
                if (!ret)
                        enable_irq_wake(irq_eoc);
                else
                        return ret;
```

No `iadc_disable_irq_wake()` or `devm_add_action_or_reset()` present.
Bug has existed since driver introduction (2014).

### Step 6.2: Backport complications
**Record:** Clean apply expected — local file matches the diff's
"before" state exactly. No conflicting changes detected.

### Step 6.3: Related fixes already present?
**Record:** None found.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/iio/adc** — IMPORTANT for Qualcomm
ARM/embedded/mobile platforms using SPMI PMIC current sensing. Not core-
kernel-wide, but affects real hardware users.

### Step 7.2: Activity
**Record:** Driver is mature (2014); recent fix is lifecycle
correctness, not new functionality.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of `qcom,spmi-iadc` on Qualcomm platforms (phones,
tablets, embedded) where the IRQ (non-polling) path is used.

### Step 8.2: Trigger conditions
**Record:** Driver probe with valid IRQ, then driver unbind/module
unload. Uncommon in typical built-in deployments; more relevant for
modular builds, driver rebinding, or test harnesses. Not userspace-
triggerable for unprivileged crash.

### Step 8.3: Failure mode severity
**Record:** IRQ wake reference leak → `wake_depth` stuck elevated,
`IRQD_WAKEUP_STATE` may persist incorrectly, possible accumulation on
re-probe. **Severity: MEDIUM** — PM/wakeup correctness issue, not a
direct crash or data corruption, but a real kernel resource leak with
long-standing presence.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Correct IRQ wake lifecycle; prevents refcount leak and
  incorrect wakeup state on teardown/re-probe.
- **Risk:** Very low — ~15 lines, established devm pattern, maintainer +
  Qualcomm review.
- **Ratio:** Moderate benefit, very low risk → favorable for stable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verified resource leak (`wake_depth` refcount)
- Bug present since 2014 in this tree
- Small, surgical, obviously correct fix
- IIO maintainer + Qualcomm reviewer endorsement
- Matches in-tree precedent (`rtc-isl1208.c`)
- Also improves ignored `enable_irq_wake()` error handling

**AGAINST backport:**
- Only manifests on driver unbind (rare in production built-in use)
- No crash reports or syzbot findings
- Severity is PM correctness, not crash/corruption

**Unresolved:** No explicit stable nomination in lore; no runtime crash
reports.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic verified against
   `irq_set_irq_wake()` refcount semantics; maintainer-reviewed.
2. Fixes a real bug? **PASS** — unbalanced IRQ wake enable/disable.
3. Important issue? **PASS (moderate)** — PM/wakeup refcount leak with
   accumulation potential; fits stable resource-leak category.
4. Small and contained? **PASS** — 1 file, ~18 lines.
5. No new features/APIs? **PASS** — lifecycle fix only.
6. Can apply to local tree? **PASS** — buggy code confirmed present;
   clean apply expected.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs fix).

### Step 9.4: Decision rationale
For **Linux 6.18.44**, the `qcom-spmi-iadc` driver contains the long-
standing unbalanced `enable_irq_wake()` call. The fix is minimal,
follows an established devm pattern already used elsewhere in this tree,
and corrects a real IRQ wake refcount leak on driver teardown. While the
trigger is infrequent in typical built-in deployments, the bug has been
present since 2014, can affect suspend/wakeup state, and can accumulate
across re-probes. This is appropriate stable material for a conservative
driver lifecycle fix.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user query; cross-
  checked v3 lore for Fixes:/Reviewed-by
- **[Phase 2]** Diff analyzed; read `kernel/irq/manage.c:857-893` for
  `wake_depth` refcount semantics
- **[Phase 2]** Compared with `drivers/rtc/rtc-isl1208.c:825-847` —
  identical devm pattern
- **[Phase 3]** `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- **[Phase 3]** `git show ce0694841ea6` — original 2014 driver commit
  exists; contains `enable_irq_wake`
- **[Phase 3]** `git blame` on lines 530-560 — buggy code present
  (history flattened in autosel repo)
- **[Phase 4]** Web search + WebFetch of lkml/openwall threads — v1/v3
  discussion, Jonathan Cameron + Konrad Dybcio review
- **[Phase 4]** b4 dig -c HEAD failed (commit not in tree) — used web
  sources instead
- **[Phase 5]** Read `iadc_probe()`, `iadc_isr()`, platform driver
  registration
- **[Phase 6]** Grep confirmed buggy `enable_irq_wake` without matching
  disable in local tree
- **[Phase 6]** Grep confirmed `devm_add_action_or_reset` available in
  `include/linux/device/devres.h`
- **[Phase 6]** No prior fix for this issue found in tree
- **[Phase 8]** Assessed trigger (unbind) and severity (MEDIUM PM leak)

**YES**

 drivers/iio/adc/qcom-spmi-iadc.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/qcom-spmi-iadc.c b/drivers/iio/adc/qcom-spmi-iadc.c
index b64a8a407168b..0ec3a0c4b1de0 100644
--- a/drivers/iio/adc/qcom-spmi-iadc.c
+++ b/drivers/iio/adc/qcom-spmi-iadc.c
@@ -481,6 +481,11 @@ static const struct iio_chan_spec iadc_channels[] = {
 	},
 };
 
+static void iadc_disable_irq_wake(void *data)
+{
+	disable_irq_wake((unsigned long)data);
+}
+
 static int iadc_probe(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
@@ -538,9 +543,16 @@ static int iadc_probe(struct platform_device *pdev)
 	if (!iadc->poll_eoc) {
 		ret = devm_request_irq(dev, irq_eoc, iadc_isr, 0,
 					"spmi-iadc", iadc);
-		if (!ret)
-			enable_irq_wake(irq_eoc);
-		else
+		if (ret)
+			return ret;
+
+		ret = enable_irq_wake(irq_eoc);
+		if (ret)
+			return ret;
+
+		ret = devm_add_action_or_reset(dev, iadc_disable_irq_wake,
+					       (void *)(unsigned long)irq_eoc);
+		if (ret)
 			return ret;
 	} else {
 		ret = devm_device_init_wakeup(iadc->dev);
-- 
2.53.0

