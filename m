Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4718059A927;
	Mon, 31 Aug 2026 13:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184297; cv=none; b=COf4JUN8vSbir36AoaC0jTE6HF70n1mqvaMf9CKseRomwvMcI2oeQASMU5107gGjlwv29eIJ6v8alZg3zf4ERRc3T8aiGTENCpQLkNtuWVKQCJNX1qlPqbONbSuQ0xH31JQQar+GtwFP4ovoWOQMoupkE5o2HlwbpQkFclNMm2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184297; c=relaxed/simple;
	bh=1Nm2ZaQpqBqpUL/5b0lmlu8yQ4fq3bT6NS1kI4ExaiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M04VRpf4alHzxyaZFjd9mJshoBGmVmRBujFiq7rOVnCHALrCc6CmJMsNmAQI5MYE70tL/J9xFHS/3LIr7Z+OCv118so2oaA/yi5mkH8Iz5yZkScHzmIf7YlLjqu8Q9rQJF4Lj22K6+7pWOUrX3etTDtofjs4bEaaaTfQgF1pnDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+rE62eW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+rE62eW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2912C1F000E9;
	Mon, 31 Aug 2026 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184295;
	bh=1YK8RCCxN+JmaqmdcfLeXR05/qFM3jVW1ABh4Q0B8yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+rE62eW2hD0447YYLHmDvBDJoTNYVSNqNK7aixG6vOQHATSwkjjIzKw1oz7U52vu
	 MwLweMOHy+TvhZWSphifrpNBLgSvM/Mz2ul6r0Ll2gsWQNHTsDkEIxHY3H5Edu/oH4
	 1dMmqSHprNuwThDEALK5DSHtYcxBPrKQdZLcz3q55hvYaj2hRsGj6BLfL7PVFKQjCw
	 B3915Ysx+P5jIVjL6R73bV5iMNweJ/+B+H5fwiqyPkkbx+etISFqBYm8vlocH2rnuz
	 PV2SHmi8SkcKaE3+ZXvRSfpupNSm/8wD17qur7tYzVtghqL9jDIVBHYR3g1zvtqpfs
	 CHP0S4DMhmFmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Imre Deak <imre.deak@intel.com>,
	Lyude Paul <lyude@redhat.com>,
	Shawn C Lee <shawn.c.lee@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/dp: Add DSC virtual DPCD quirk for Realtek MST branch device
Date: Mon, 31 Aug 2026 09:30:35 -0400
Message-ID: <20260831133314.4125787-607-sashal@kernel.org>
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

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit bff2da7aa0020eb72e42d63868dc5adaa0fb85d3 ]

The ASUS DC301 USB-C dock containing a Realtek MST branch device
supports the DSC decompression functionality on each of the dock's
downstream connectors, even though there is no discoverable peer-to-peer
virtual device in the MST topology (which the DP Standard
requires/suggests to control the DSC functionality on a per-DFP basis).
Add the DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD quirk for this branch
device as well to enable the DSC decompression functionality on all DFP
connectors of the dock, similarly to how this is done for dock's
containing older Synaptics branch devices.

Cc: Lyude Paul <lyude@redhat.com>
Reported-and-tested-by: Shawn C Lee <shawn.c.lee@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260525125516.2794636-1-imre.deak@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: drm/dp DSC virtual DPCD quirk for Realtek
MST

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/dp]` `[Add]` — Add DSC virtual DPCD quirk for Realtek
MST branch device

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Cc: | Lyude Paul \<lyude@redhat.com\> |
| Reported-and-tested-by: | Shawn C Lee \<shawn.c.lee@intel.com\> |
| Reviewed-by: | Mika Kahola \<mika.kahola@intel.com\> |
| Reviewed-by: | Lyude Paul \<lyude@redhat.com\> |
| Signed-off-by: | Imre Deak \<imre.deak@intel.com\> (author SOB; ignore
pipeline SOBs) |
| Link: |
https://patch.msgid.link/20260525125516.2794636-1-imre.deak@intel.com |

**Notable patterns:** Real hardware reporter+tester; two Reviewed-by
including DRM maintainer Lyude Paul. No syzbot, no Fixes: tag (expected
for manual review).

### Step 1.3: Body analysis
**Record:**
- **Bug:** ASUS DC301 USB-C dock (Realtek MST branch, OUI `0x00:e0:4c`)
  supports DSC decompression on downstream connectors but does not
  expose discoverable peer-to-peer virtual DPCD devices as the DP
  standard expects for per-DFP DSC control.
- **Symptom:** DSC decompression cannot be enabled on the dock's
  downstream display outputs; high-bandwidth modes that require DSC will
  fail or fall back incorrectly.
- **Root cause:** Kernel only applies the
  `DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD` workaround to Synaptics
  (`0x90:CC:24`) MST hubs, not Realtek.
- **Fix approach:** Add Realtek branch-device quirk entry matching OUI
  `0x00, 0xe0, 0x4c` and device ID `'Dp1.4'`.

### Step 1.4: Hidden bug fix?
**Record:** Yes — described as "Add quirk" but it fixes broken display
functionality on a specific USB-C dock. This is a hardware
quirk/workaround, not a cosmetic change.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/gpu/drm/display/drm_dp_helper.c` (+2 lines)
- **Functions modified:** None directly; `dpcd_quirk_list[]` static
  table only
- **Scope:** Single-file, surgical quirk-table addition

### Step 2.2: Code flow change
**Record:**
- **Hunk (quirk table):** Before → only Synaptics MST hubs matched
  `DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD`. After → Realtek DP1.4 MST
  branch devices (`OUI 0x00:e0:4c`, device ID `Dp1.4`, `is_branch=true`)
  also get the quirk bit set when `drm_dp_get_quirks()` runs during
  `drm_dp_read_desc()`.

### Step 2.3: Bug mechanism
**Record:** **Category (h): Hardware workaround**

Without the quirk, `drm_dp_mst_dsc_aux_for_port()` in
`drm_dp_mst_topology.c` does not find a valid DSC aux for Realtek MST
dock ports:

```6159:6176:drivers/gpu/drm/display/drm_dp_mst_topology.c
        if (drm_dp_has_quirk(&desc,
DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD)) {
                // ... reads DSC caps from physical upstream aux ...
                        return immediate_upstream_aux;
        }
```

When this returns `NULL`, i915 sets `connector->dp.dsc_decompression_aux
= NULL` at MST connector creation, and amdgpu similarly gets no
`dsc_aux`. DSC decompression is never enabled on dock downstream
connectors.

### Step 2.4: Fix quality
**Record:** Obviously correct — mirrors the proven Synaptics quirk
(added 2019, commit `5b03f9d8688071`). Uses a specific device ID
(`'Dp1.4'`) rather than `DEVICE_ID_ANY`, limiting scope. **Regression
risk:** Very low; only affects devices matching Realtek OUI + exact
device ID on branch devices.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Synaptics `DSC_WITHOUT_VIRTUAL_DPCD` entry introduced by
Mikita Lipski, 2019-09-20 (`5b03f9d8688071`). Quirk infrastructure and
`drm_dp_mst_dsc_aux_for_port()` logic are ancestors of HEAD and present
in 6.18.44. Realtek entry is **not** in this tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** Recent `drm_dp_helper.c` changes are unrelated (backlight,
AUX probe address). No competing fix for Realtek DSC. Standalone single-
patch fix.

### Step 3.4: Author context
**Record:** Imre Deak is an active Intel DRM contributor; prior commits
to this file include Synaptics HBLANK-expansion and MediaTek DSC quirks
— same subsystem and pattern.

### Step 3.5: Dependencies
**Record:** **No dependencies.** Requires only:
- `DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD` enum (present in
  `include/drm/display/drm_dp_helper.h`)
- `drm_dp_mst_dsc_aux_for_port()` quirk handling (present in
  `drm_dp_mst_topology.c`)
- `dpcd_quirk_list[]` table (present in `drm_dp_helper.c`)

All verified present in 6.18.44.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c <commit>` could not run — commit is not in this
tree (no commitish available). WebFetch of patch link and
lore.kernel.org blocked by Anubis bot protection. **UNVERIFIED:** full
mailing-list thread content.

### Step 4.2: Reviewers
**Record:** Commit message confirms Lyude Paul (DRM maintainer) and Mika
Kahola reviewed. Cc'd Lyude Paul.

### Step 4.3: Bug report
**Record:** Reported-and-tested-by Shawn C Lee (Intel) on ASUS DC301
USB-C dock hardware. No syzbot/CVE.

### Step 4.4: Series context
**Record:** Standalone 1-patch fix, not part of a series.

### Step 4.5: Stable list history
**Record:** **UNVERIFIED** — could not access lore stable archive due to
bot protection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** Modified indirectly via quirk table lookup in
`drm_dp_get_quirks()` → consumed by `drm_dp_has_quirk()` → used in
`drm_dp_mst_dsc_aux_for_port()`.

### Step 5.2: Callers
**Record:** `drm_dp_mst_dsc_aux_for_port()` called from:
- `intel_dp_mst.c` — MST connector probe
  (`connector->dp.dsc_decompression_aux`)
- `amdgpu_dm_mst_types.c` — `validate_dsc_caps_on_connector()`
- `drm_dp_mst_topology.c` — `drm_dp_mst_add_affected_dsc_crtcs()`

All are MST hotplug/enumeration and atomic modeset paths — reachable
when a user plugs in a USB-C dock.

### Step 5.3: Callees
**Record:** Quirk path reads DPCD via `drm_dp_read_desc()`,
`drm_dp_dpcd_read_data()`, `drm_dp_read_dpcd_caps()` — standard AUX
reads, no new kernel APIs.

### Step 5.4: Reachability
**Record:** Triggered by plugging ASUS DC301 (or other matching Realtek
MST branch) into a DP MST-capable GPU. Userspace display configuration
is the entry point. Affects i915 and amdgpu MST users.

### Step 5.5: Similar patterns
**Record:** Identical pattern to Synaptics quirk at line 2538–2539. Same
author added related Synaptics/MediaTek DSC quirks in this file.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **YES.** The quirk table has Synaptics entry but lacks
Realtek entry. The `DSC_WITHOUT_VIRTUAL_DPCD` handling code exists and
would work once the table entry is added. Bug affects users of Realtek
MST docks on kernels ≥6.18.44 (and any earlier kernel with the Synaptics
quirk but not Realtek).

### Step 6.2: Backport complications
**Record:** **Clean apply.** `patch -p1 --dry-run` succeeded with fuzz 1
(offset 1 line) against current `drm_dp_helper.c`. No structural
conflicts.

### Step 6.3: Related fixes already present?
**Record:** Synaptics `DSC_WITHOUT_VIRTUAL_DPCD` quirk is present
(`5b03f9d8688071` is ancestor of HEAD). No Realtek equivalent found
(`grep` for `0x00, 0xe0, 0x4c` in quirk table: no match).

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/gpu/drm/display** — IMPORTANT. Affects display
output through USB-C/MST docks on Intel and AMD GPUs.

### Step 7.2: Activity
**Record:** Actively maintained; recent commits in `drm_dp_helper.c` and
`drm_dp_mst_topology.c` within this stable cycle.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of Realtek MST branch USB-C docks (specifically
tested: ASUS DC301) connected via DP MST to Intel/AMD GPUs with DSC-
capable outputs. Config-dependent: `CONFIG_DRM`, MST, DSC support.

### Step 8.2: Trigger conditions
**Record:** Plug dock into MST-capable port; attempt modes requiring DSC
decompression on downstream connectors. Not timing-dependent;
deterministic hardware identification failure. Unprivileged users can
trigger via normal display hotplug.

### Step 8.3: Failure mode severity
**Record:** **MEDIUM** — DSC decompression disabled → high-
resolution/high-refresh modes through dock may not work or may not use
optimal compression. Not a kernel crash, oops, or data corruption, but
real functional breakage on production hardware.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Enables DSC on Realtek MST docks; restores display
  functionality matching hardware capability. Tested on real hardware.
- **Risk:** Minimal — 2-line quirk entry, narrowly matched by OUI +
  device ID + branch flag.
- **Ratio:** Strong benefit for affected hardware, negligible risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Hardware quirk — explicit stable exception category
- Fixes real, tested bug on ASUS DC301 USB-C dock
- 2-line, surgical change using existing infrastructure
- Reviewed by DRM maintainer (Lyude Paul)
- Mirrors proven Synaptics quirk (in tree since 2019)
- Applies cleanly to 6.18.44
- No new APIs, no refactoring

**AGAINST backport:**
- Display functionality issue, not crash/security/corruption
- Affects narrow hardware population (Realtek MST docks)
- Mailing-list discussion not independently verified

**UNRESOLVED:**
- Full lore thread content (bot protection)
- Whether other Realtek device IDs beyond `'Dp1.4'` need the same quirk

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — mirrors Synaptics;
Reported-and-tested-by on real hardware; maintainer reviewed |
| 2. Fixes a real bug affecting users? | **PASS** — DSC broken on
Realtek MST dock downstream ports |
| 3. Important issue? | **PASS** (hardware quirk) — display modes broken
on affected dock; not crash-level but real user impact |
| 4. Small and contained? | **PASS** — 2 lines, one file |
| 5. No new features/APIs? | **PASS** — quirk table entry only |
| 6. Can apply to local tree? | **PASS** — clean apply with fuzz 1 |

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — directly matches the stable
exception for device-specific quirks that fix real-world hardware
issues.

### Step 9.4: Decision rationale

This commit adds a Realtek MST branch device to the existing
`DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD` quirk table. All handling code
already exists in 6.18.44 (introduced for Synaptics docks in 2019).
Without this entry, DSC decompression is silently unavailable on Realtek
MST USB-C docks such as the ASUS DC301, breaking display functionality
on downstream connectors.

This is textbook stable material: a small, maintainer-reviewed hardware
quirk that enables existing functionality on real hardware, with no API
changes and negligible regression risk.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Diff analysis: +2 lines to `dpcd_quirk_list[]` in
  `drm_dp_helper.c`
- **[Phase 2]** Read `drm_dp_mst_dsc_aux_for_port()` quirk handling at
  lines 6159–6176
- **[Phase 2]** Read `drm_dp_get_quirks()` matching logic at lines
  2558–2583
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; Makefile confirms
  6.18.44
- **[Phase 3]** `git blame` on lines 2535–2545: Synaptics quirk from
  `5b03f9d8688071` (2019)
- **[Phase 3]** `git merge-base --is-ancestor 5b03f9d8688071 HEAD` →
  prerequisite commit present
- **[Phase 3]** `git log --grep="DSC virtual DPCD quirk for Realtek"` →
  no results (commit not in tree)
- **[Phase 4]** `b4 dig` requires commitish not available in tree —
  **UNVERIFIED**
- **[Phase 4]** WebFetch of patch link and lore.kernel.org — blocked by
  Anubis — **UNVERIFIED**
- **[Phase 5]** `grep drm_dp_mst_dsc_aux_for_port` → callers in i915,
  amdgpu, drm_dp_mst_topology.c
- **[Phase 5]** Read `intel_dp_mst.c:1745` — `dsc_decompression_aux =
  drm_dp_mst_dsc_aux_for_port(port)`
- **[Phase 5]** Read `amdgpu_dm_mst_types.c:276` — same pattern
- **[Phase 6]** `grep "0x00, 0xe0, 0x4c"` in quirk table → no match (bug
  present, fix absent)
- **[Phase 6]** `grep DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD` → enum and
  usage confirmed in tree
- **[Phase 6]** `patch -p1 --dry-run` on constructed patch → succeeds
  with fuzz 1
- **[Phase 7]** Subsystem: `drivers/gpu/drm/display` — DRM display
  helper
- **[Phase 8]** Failure mode: DSC unavailable on dock ports — MEDIUM
  severity, real hardware impact

**YES**The background checks finished:

- **Tree:** Linux **6.18.44** (`v6.18.44`)
- **Commit search:** No match for the Realtek DSC quirk commit in this
  tree — it isn’t applied here yet
- **Prerequisites:** The Synaptics `DSC_WITHOUT_VIRTUAL_DPCD` quirk and
  handling code are present; only the Realtek table entry is missing

That matches the earlier analysis: this is a small hardware quirk that
should be backported to this tree.

**YES**

 drivers/gpu/drm/display/drm_dp_helper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/display/drm_dp_helper.c
index 8c858ba40c6c6..77336bc3e62c2 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -2537,6 +2537,8 @@ static const struct dpcd_quirk dpcd_quirk_list[] = {
 	{ OUI(0x00, 0x00, 0x00), DEVICE_ID('C', 'H', '7', '5', '1', '1'), false, BIT(DP_DPCD_QUIRK_NO_SINK_COUNT) },
 	/* Synaptics DP1.4 MST hubs can support DSC without virtual DPCD */
 	{ OUI(0x90, 0xCC, 0x24), DEVICE_ID_ANY, true, BIT(DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD) },
+	/* Realtek DP1.4 MST hubs can support DSC without virtual DPCD */
+	{ OUI(0x00, 0xe0, 0x4c), DEVICE_ID('D', 'p', '1', '.', '4', 0), true, BIT(DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD) },
 	/* Synaptics DP1.4 MST hubs require DSC for some modes on which it applies HBLANK expansion. */
 	{ OUI(0x90, 0xCC, 0x24), DEVICE_ID_ANY, true, BIT(DP_DPCD_QUIRK_HBLANK_EXPANSION_REQUIRES_DSC) },
 	/* MediaTek panels (at least in U3224KBA) require DSC for modes with a short HBLANK on UHBR links. */
-- 
2.53.0

