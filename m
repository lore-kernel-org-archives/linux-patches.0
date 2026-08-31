Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAC7559C95;
	Mon, 31 Aug 2026 13:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184044; cv=none; b=OFvuMq+FEEQ+KP8855tuxYZufnz5d0unjdrWLAcgKEFIi3XKNK1YObEVpC3KJPpC1HUHwiQGsmjosotv86Nm6cOP9IzeuAFm+sr5jUonY8nEA0Rp9oOlOp2XSB/ltuRZhhkQAJrb6TsRUodHPpPCLENlF4xz8W0fSLpqYjDDw+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184044; c=relaxed/simple;
	bh=i93HCWGA/JFobA3bYW4rbZe4fM5yYwVTI9PEUaRiFoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cA+9eFwMAsUmBMfscSdg4zeMQrMjhvqjvoo7aswAiwshpDdq+pTbKqoTJYcXdhiPRGA7X4fO7D559VQmp3NxMwgw3kz/OskOHcUEKytTKqv4sVTH/KikoHcBuFYaF820341etZMkZwsaWQ8ZLOLscymm+Lf0oEk7pX1ThJIGbEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efw6zRWI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efw6zRWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860761F00ACF;
	Mon, 31 Aug 2026 13:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184040;
	bh=Hdu4+GtK41jXaYYgIInfUbCFakWKJWd6HnjzDk02YUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=efw6zRWIBYpVS9PZZJoyme5DDb2RennU45+fFdCXcwKsxPkfhIIVOti3f/esxFviO
	 JhxG1K/yYNRzP8WeYK1zid/lAnKt2qO8k5mv0H97x5DUIA64AXhpJ2AOqc1WNexxsC
	 AbhtAx2mY2U/HH83NyV8KoRhxtOwWe5jny5oUea5KsJGrjeTmcAb7WogUfnGpGZEz/
	 wo3FKGnDGTuPlle/F1OMM3/45LlAUO8yakKnGsQQZpB4weA6C9m8JplY6XdRlHksnc
	 DD2utPnL24wqMK/RNE6LoX7K5tj2OH3vQOhWF2UfHYVVBMq33P0sF18tD8FRFQJlUS
	 f+MwnfbnlRDGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tzung-Bi Shih <tzungbi@kernel.org>,
	Gwendal Grignou <gwendal@chromium.org>,
	Sasha Levin <sashal@kernel.org>,
	bleung@chromium.org,
	chrome-platform@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] platform/chrome: Resolve kb_wake_angle visibility race
Date: Mon, 31 Aug 2026 09:28:04 -0400
Message-ID: <20260831133314.4125787-456-sashal@kernel.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit c40f5f9927b5bf6062daa1e293ae32d83afc963e ]

A race condition exists between the probe of cros-ec-sysfs and
cros-ec-sensorhub.

The `kb_wake_angle` attribute should only be visible if the sensor hub
detects two or more accelerometers.  If cros_ec_sysfs_probe() runs
before cros_ec_sensorhub_register() completes sensor enumeration, the
sysfs attributes are created while `has_kb_wake_angle` is still false,
hiding `kb_wake_angle` incorrectly.

Store the created attribute group pointer in `ec_dev->group`.  When
the sensor hub completes sensor enumeration, it checks for this group
and calls sysfs_update_group() to notify the sysfs core to re-evaluate
attribute visibility.  This ensures the `kb_wake_angle` attribute
visibility is correctly updated regardless of the driver probe order.

Co-developed-by: Gwendal Grignou <gwendal@chromium.org>
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Link: https://lore.kernel.org/r/20260407102615.1605317-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `platform/chrome: Resolve kb_wake_angle
visibility race`

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[platform/chrome]` `[Resolve]` — fix a race affecting
`kb_wake_angle` sysfs attribute visibility between `cros-ec-sysfs` and
`cros-ec-sensorhub` probe paths.

### Step 1.2: Commit message tags
**Record:**
| Tag | Value |
|-----|-------|
| Co-developed-by | Gwendal Grignou \<gwendal@chromium.org\> |
| Signed-off-by | Gwendal Grignou, Tzung-Bi Shih \<tzungbi@kernel.org\>
|
| Link |
https://lore.kernel.org/r/20260407102615.1605317-1-tzungbi@kernel.org |

**Notable absences (expected, not negative):** No `Fixes:`, no `Cc:
stable@vger.kernel.org`, no `Reported-by:`, no `Reviewed-by:`, no
`Tested-by:`.

**Notable patterns:** Co-developed by a Chromium engineer; cover letter
says *"This is an old patch and we still need it. Revive the patch."*
with v3 dating to August 2021.

### Step 1.3: Body analysis
**Record:**
- **Bug:** Race between `cros_ec_sysfs_probe()` and
  `cros_ec_sensorhub_register()` during sensor enumeration.
- **Symptom:** `/sys/class/chromeos/<ec>/kb_wake_angle` is permanently
  hidden when sysfs is created while `has_kb_wake_angle` is still
  `false`, even on hardware with ≥2 accelerometers.
- **Root cause:** `cros_ec_ctrl_visible()` is evaluated once at
  `sysfs_create_group()` time; later setting `has_kb_wake_angle = true`
  does not re-evaluate visibility without `sysfs_update_group()`.
- **Fix:** Store the attribute group pointer in `ec_dev->group`; call
  `sysfs_update_group()` after sensor enumeration sets
  `has_kb_wake_angle`.

### Step 1.4: Hidden bug fix detection
**Record:** Yes — despite "Resolve" rather than "fix", this is a
synchronization/race bug fix disguised as a visibility correction.
Permanent functional regression on affected Chromebooks.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change inventory
**Record:**
| File | Changes | Functions |
|------|---------|-----------|
| `cros_ec_sensorhub.c` | +4 lines | `cros_ec_sensorhub_register()` |
| `cros_ec_sysfs.c` | +3/-2 lines | `cros_ec_sysfs_probe()`,
`cros_ec_sysfs_remove()` |
| `cros_ec_proto.h` | +2 lines | `struct cros_ec_dev` |

**Scope:** 3 files, ~10 insertions / 3 deletions — single-subsystem,
surgical fix.

### Step 2.2: Code flow per hunk

**Hunk 1 — `cros_ec_sensorhub.c`:**
- **Before:** Set `ec->has_kb_wake_angle = true` when ≥2 accelerometers
  found; sysfs never notified.
- **After:** Same flag set, plus if `ec->group` exists, call
  `sysfs_update_group()` to re-run `is_visible()`.

**Hunk 2 — `cros_ec_sysfs.c` probe:**
- **Before:** `sysfs_create_group(..., &cros_ec_attr_group)` directly.
- **After:** Store `ec_dev->group = &cros_ec_attr_group` first, then
  create using stored pointer.

**Hunk 3 — `cros_ec_sysfs.c` remove:**
- **Before:** Remove using static `&cros_ec_attr_group`.
- **After:** Remove using `ec_dev->group` (consistent with stored
  pointer).

**Hunk 4 — `cros_ec_proto.h`:**
- **Before:** No `group` field in `struct cros_ec_dev`.
- **After:** Add `const struct attribute_group *group`.

### Step 2.3: Bug mechanism
**Record:** **Category:** Race condition / sysfs visibility lifecycle
bug.

**Mechanism:** `cros_ec_ctrl_visible()` gates `kb_wake_angle` on
`ec->has_kb_wake_angle`:

```377:384:drivers/platform/chrome/cros_ec_sysfs.c
static umode_t cros_ec_ctrl_visible(struct kobject *kobj,
                                    struct attribute *a, int n)
{
        struct device *dev = kobj_to_dev(kobj);
        struct cros_ec_dev *ec = to_cros_ec_dev(dev);

        if (a == &dev_attr_kb_wake_angle.attr && !ec->has_kb_wake_angle)
                return 0;
```

`has_kb_wake_angle` is set later in sensorhub enumeration:

```125:126:drivers/platform/chrome/cros_ec_sensorhub.c
        if (sensor_type[MOTIONSENSE_TYPE_ACCEL] >= 2)
                ec->has_kb_wake_angle = true;
```

Kernel documentation for `sysfs_update_group()` explicitly states it
exists *"after making a change that affects group visibility"* —
confirming the missing step in current code.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes — standard sysfs pattern; `ec` is
  `kzalloc()`'d so `group` starts NULL; `if (ec->group && ...)` guards
  the update path safely.
- **Minimal:** Yes — no unrelated changes.
- **Regression risk:** Very low — only affects attribute visibility
  timing; failure path logs `dev_warn` and leaves sysfs in prior state.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Shallow repository (`rev-parse --is-shallow-repository` →
`true`). `git blame` attributes all relevant lines to `5d324e5159d9e`
(merge base). Cannot determine exact introduction commit from local
history. Buggy `has_kb_wake_angle` + `is_visible` logic **is present**
in current tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** `git log --oneline -30` on modified files returns only the
shallow merge base — insufficient local history. External evidence
(patch v3 from August 2021) indicates the race has existed since
conditional visibility was introduced years ago.

### Step 3.4: Author context
**Record:** Tzung-Bi Shih is an active `platform/chrome` maintainer. Co-
developer Gwendal Grignou is from Chromium. Patch cover letter
explicitly states production need.

### Step 3.5: Dependencies
**Record:** Standalone — no series dependencies, no prerequisite commits
referenced. Applies directly to existing `has_kb_wake_angle` /
`is_visible` infrastructure already in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Thread at https://yhbt.net/lore/chrome-
platform/20260407102615.1605317-1-tzungbi@kernel.org/T/ (v4, April
2026). Patch went through v1→v4 revisions. Queued in linux-next as
`c40f5f9927b5` (May 2026). Merged to mainline via `chrome-platform-v7.2`
pull. `b4 dig -c HEAD` could not match this commit (not in local tree).
No explicit stable nomination found in available thread content.

### Step 4.2: Reviewers
**Record:** Could not retrieve full recipient list (lore
blocked/redirected). Signed-off-by from subsystem maintainer Tzung-Bi
Shih and Chromium co-developer.

### Step 4.3: Bug report
**Record:** No external bug tracker or syzbot report. Production need
documented by Chromium in cover letter (*"old patch... we still need
it"*).

### Step 4.4: Series context
**Record:** Standalone 1-patch fix. v3 predecessor from 2021 at https://
lore.kernel.org/all/20210804213139.4139492-2-gwendal@chromium.org/

### Step 4.5: Stable list history
**Record:** No stable-list discussion found in accessible sources.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `cros_ec_sensorhub_register()`, `cros_ec_sysfs_probe()`,
`cros_ec_ctrl_visible()`, `ec_device_probe()` (MFD parent).

### Step 5.2: Callers / probe ordering
**Record:** In `drivers/mfd/cros_ec_dev.c`:
- Line 241–248: `cros-ec-sensorhub` MFD child registered **first** (when
  sensors present).
- Line 333–338: `cros-ec-sysfs` registered **last** among platform
  cells.

However, sensorhub probe calls `cros_ec_sensorhub_register()` which
loops over sensors with up to 50 EBUSY retries at 5–6 ms each
(`CROS_EC_CMD_INFO_RETRIES`). Meanwhile, numerous other MFD children are
registered and probed between sensorhub registration and sysfs
registration. **Sysfs probe can run while sensorhub_register() is still
enumerating sensors** — confirmed race window.

### Step 5.3: Callees
**Record:** `sysfs_create_group()`, `sysfs_update_group()`,
`cros_ec_cmd_xfer_status()` — all standard, well-understood APIs.

### Step 5.4: Reachability
**Record:** Triggered on every boot of Chromebook/ChromeOS hardware with
`CONFIG_CROS_EC_SENSORHUB` and ≥2 accelerometers. Userspace reads/writes
`/sys/class/chromeos/*/kb_wake_angle` (documented ABI since kernel
4.17). Not a syscall path, but standard sysfs interface for ChromeOS
power/tablet-mode configuration.

### Step 5.5: Similar patterns
**Record:** `sysfs_update_group()` used elsewhere for dynamic visibility
(e.g., `drivers/usb/typec/class.c`, `fs/btrfs/sysfs.c`). Same
established pattern.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **YES.** Current tree lacks `ec_dev->group` field and
`sysfs_update_group()` call. Full buggy race infrastructure is present
(`has_kb_wake_angle`, `cros_ec_ctrl_visible`, sensorhub enumeration).

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — no conflicting refactors in these
files; patch matches current code structure exactly.

### Step 6.3: Related fixes already present?
**Record:** **No** — `grep sysfs_update_group drivers/platform/chrome/`
returns no matches. Fix not yet applied.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/platform/chrome/` — **PERIPHERAL** (ChromeOS EC
platform driver). Important for Chromebook users; not core kernel.

### Step 7.2: Activity
**Record:** Actively maintained subsystem with ongoing chrome-platform
development.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Chromebook/convertible devices with ChromeOS EC,
`CONFIG_CROS_EC_SENSORHUB`, and ≥2 accelerometers. Config- and platform-
specific, but affects a widely deployed hardware class.

### Step 8.2: Trigger conditions
**Record:** Probe-order/timing race during boot — sysfs probes before
sensorhub finishes enumerating accelerometers. Plausible on every boot
when timing aligns; sensorhub EC communication can take hundreds of
milliseconds with EBUSY retries. Not userspace-triggerable; unprivileged
users cannot force it, but they suffer the consequence (missing sysfs
node).

### Step 8.3: Failure mode severity
**Record:** `kb_wake_angle` sysfs attribute **permanently hidden for
that boot** (sysfs does not re-evaluate `is_visible` without update).
Userspace cannot read/write keyboard wake lid angle. **Severity:
MEDIUM** — functional regression on documented ABI; no crash,
corruption, deadlock, or security impact.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — restores documented sysfs control on affected
  convertibles; long-standing Chromium production issue.
- **Risk:** VERY LOW — 10-line change using documented sysfs API.
- **Ratio:** Favorable — low-risk fix for a real, persistent functional
  bug.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verifiable race with permanent per-boot impact
- Buggy code confirmed present in Linux 6.18.43
- Small, surgical, obviously correct fix using standard
  `sysfs_update_group()` API
- Long-standing issue (known since ~2021); Chromium explicitly still
  needs it
- Documented userspace ABI (`Documentation/ABI/testing/sysfs-class-
  chromeos`)
- No dependencies; clean apply expected

**AGAINST backport:**
- Not crash/security/corruption/deadlock — functional sysfs visibility
  only
- ChromeOS-specific driver; limited to one hardware ecosystem
- No syzbot report, no explicit stable nomination
- Failure is degraded functionality, not system instability

**Unresolved:** Exact commit that introduced `has_kb_wake_angle`
visibility (shallow clone limits local history). Full lore review thread
not accessible.

### Step 9.2: Stable rules checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — standard sysfs pattern;
maintainer SOB; v4 after review |
| 2. Fixes real bug affecting users? | **PASS** — permanent missing
sysfs attr on affected Chromebooks |
| 3. Important issue? | **PASS (borderline)** — functional regression on
production hardware with documented ABI; not crash-level but persistent
and user-visible |
| 4. Small and contained? | **PASS** — 3 files, ~10 lines |
| 5. No new features/APIs? | **PASS** — fixes existing attribute
visibility only |
| 6. Can apply to local tree? | **PASS** — buggy code present; clean
apply |

### Step 9.3: Exception categories
**Record:** Not a device-ID/quirk/DT/build/docs exception. Qualifies as
a driver probe race fix for existing hardware functionality.

### Step 9.4: Decision rationale
For **Linux 6.18.43**, the race exists today: `has_kb_wake_angle`
conditional visibility without `sysfs_update_group()` means
`kb_wake_angle` can be permanently hidden on convertible Chromebooks
when sysfs probes before sensor enumeration completes. The fix is
minimal, uses the kernel's intended API for exactly this scenario, and
addresses a production issue Chromium has tracked since 2021. While
severity is functional rather than catastrophic, the bug is persistent
per boot, affects a documented userspace interface, and the backport
risk is negligible.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message;
  fetched v4 cover letter from ratatoskr.run
- **[Phase 2]** Read current `cros_ec_sysfs.c`, `cros_ec_sensorhub.c`,
  `cros_ec_proto.h`; confirmed diff matches tree structure
- **[Phase 2]** Read `sysfs_update_group()` documentation in
  `fs/sysfs/group.c` lines 271–287
- **[Phase 3]** `git describe HEAD` → v6.18.43; `rev-parse --is-shallow-
  repository` → true
- **[Phase 3]** `git blame` on modified lines → all from shallow base
  `5d324e5159d9e`
- **[Phase 3]** `git log --grep=kb_wake_angle` → empty (shallow history)
- **[Phase 4]** ratatoskr.run thread: v4, linux-next queue, v3 from
  2021, Chromium co-developer
- **[Phase 4]** lore.kernel.org direct fetch blocked; yhbt.net returned
  Tor redirect
- **[Phase 4]** `b4 dig -c HEAD` failed to match (commit not in tree)
- **[Phase 5]** Read `ec_device_probe()` in `drivers/mfd/cros_ec_dev.c`
  — sensorhub at 241, sysfs at 333
- **[Phase 5]** Confirmed `CROS_EC_CMD_INFO_RETRIES 50` with 5–6ms
  sleeps in sensorhub enumeration
- **[Phase 5]** `grep sysfs_update_group drivers/platform/chrome/` → no
  matches (fix absent)
- **[Phase 6]** Confirmed `struct cros_ec_dev` lacks `group` field in
  local tree
- **[Phase 6]** Confirmed `has_kb_wake_angle` + `is_visible` logic
  present (bug exists)
- **[Phase 7]** Read `Documentation/ABI/testing/sysfs-class-chromeos` —
  kb_wake_angle documented since 4.17
- **[Phase 8]** Confirmed `ec = kzalloc()` in `ec_device_probe()` —
  `group` implicitly NULL-initialized

**YES**

 drivers/platform/chrome/cros_ec_sensorhub.c | 6 +++++-
 drivers/platform/chrome/cros_ec_sysfs.c     | 5 +++--
 include/linux/platform_data/cros_ec_proto.h | 2 ++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_sensorhub.c b/drivers/platform/chrome/cros_ec_sensorhub.c
index 9bad8f72680ea..f938c3fc84e4f 100644
--- a/drivers/platform/chrome/cros_ec_sensorhub.c
+++ b/drivers/platform/chrome/cros_ec_sensorhub.c
@@ -122,8 +122,12 @@ static int cros_ec_sensorhub_register(struct device *dev,
 		sensor_type[sensorhub->resp->info.type]++;
 	}
 
-	if (sensor_type[MOTIONSENSE_TYPE_ACCEL] >= 2)
+	if (sensor_type[MOTIONSENSE_TYPE_ACCEL] >= 2) {
 		ec->has_kb_wake_angle = true;
+		if (ec->group && sysfs_update_group(&ec->class_dev.kobj,
+						    ec->group))
+			dev_warn(dev, "Unable to update sysfs");
+	}
 
 	if (cros_ec_check_features(ec,
 				   EC_FEATURE_REFINED_TABLET_MODE_HYSTERESIS)) {
diff --git a/drivers/platform/chrome/cros_ec_sysfs.c b/drivers/platform/chrome/cros_ec_sysfs.c
index f22e9523da3e8..9d3767ab15480 100644
--- a/drivers/platform/chrome/cros_ec_sysfs.c
+++ b/drivers/platform/chrome/cros_ec_sysfs.c
@@ -405,7 +405,8 @@ static int cros_ec_sysfs_probe(struct platform_device *pd)
 	struct device *dev = &pd->dev;
 	int ret;
 
-	ret = sysfs_create_group(&ec_dev->class_dev.kobj, &cros_ec_attr_group);
+	ec_dev->group = &cros_ec_attr_group;
+	ret = sysfs_create_group(&ec_dev->class_dev.kobj, ec_dev->group);
 	if (ret < 0)
 		dev_err(dev, "failed to create attributes. err=%d\n", ret);
 
@@ -416,7 +417,7 @@ static void cros_ec_sysfs_remove(struct platform_device *pd)
 {
 	struct cros_ec_dev *ec_dev = dev_get_drvdata(pd->dev.parent);
 
-	sysfs_remove_group(&ec_dev->class_dev.kobj, &cros_ec_attr_group);
+	sysfs_remove_group(&ec_dev->class_dev.kobj, ec_dev->group);
 }
 
 static const struct platform_device_id cros_ec_sysfs_id[] = {
diff --git a/include/linux/platform_data/cros_ec_proto.h b/include/linux/platform_data/cros_ec_proto.h
index de14923720a53..6ed1c4c5ce2ef 100644
--- a/include/linux/platform_data/cros_ec_proto.h
+++ b/include/linux/platform_data/cros_ec_proto.h
@@ -228,6 +228,7 @@ struct cros_ec_platform {
 /**
  * struct cros_ec_dev - ChromeOS EC device entry point.
  * @class_dev: Device structure used in sysfs.
+ * @group: sysfs attributes groups for this EC.
  * @ec_dev: cros_ec_device structure to talk to the physical device.
  * @dev: Pointer to the platform device.
  * @debug_info: cros_ec_debugfs structure for debugging information.
@@ -237,6 +238,7 @@ struct cros_ec_platform {
  */
 struct cros_ec_dev {
 	struct device class_dev;
+	const struct attribute_group *group;
 	struct cros_ec_device *ec_dev;
 	struct device *dev;
 	struct cros_ec_debugfs *debug_info;
-- 
2.53.0

