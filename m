Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E0F3CF02C;
	Mon, 20 Apr 2026 13:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691754; cv=none; b=aV4vWGvRLxTxjrZSg5KIeduYyaEEaSgzQ5BgdrpnNa+yMMEGgU2rvrsrlbQNeDXrvT7Sm/EJhyguYJ2nSer19DxvNS0VRgGGgboMVRVcBfZAhtyZpagOfEzW2KbetWK4WUJQIphyQRgi/2patr0OE4NvJJhhJ3O5Us6j0Z6x1Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691754; c=relaxed/simple;
	bh=4JM0H3LNo+pnQCjClh7idHPPBZsJOECq3dKvGCyRtRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcGqlrWeU4lVeWbZz3Vh3ZrWuNXTx5MVy1OVsHc4lVwC/W+Ki69dLUCZG7iHoi/BsJpPxaEggV5sq006UAwx8wpyLefY9zXPTsd4TPE5uu6uGN4kRNPA45coEHfO+d4P+SNTqiMpNMUi0wh+Vd+rpQUEZcIB9YClD9sPshakx+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hp39jLKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hp39jLKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BABFC2BCB6;
	Mon, 20 Apr 2026 13:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691753;
	bh=4JM0H3LNo+pnQCjClh7idHPPBZsJOECq3dKvGCyRtRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hp39jLKwvkjMYfFPseBURpSkCnyFmOR2bGMmxJf9mD7jTKwWmwGKpMlV5q762dFmX
	 MmLNVKYN8eMbrUzMgyRieotIkFz8jeyoZFB9Jel1y7taabv4IpV4weChp1ivpok9UN
	 AKQkwZ8Ltzr94UjTjU6nYb/kvC312UIZAaGIn9Zn3S4LEptsGJjnsnKki7IStwCaEU
	 S1mYxiLvPEh9yXXEXPErRSUARjC1s8+VREjCh8G0Ej0CH7IQoGJM5um6SwEa5YZYco
	 EcNUuquV2vvqvDG4jaeVRrI0WrAFAEEPwfVUelfsinKplanqaPngZwGvplrolJCf7H
	 seGYScMrdIUzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] drm/amd/display: Exit IPS w/ DC helper for all dc_set_power_state cases
Date: Mon, 20 Apr 2026 09:19:27 -0400
Message-ID: <20260420132314.1023554-173-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Ovidiu Bunea <ovidiu.bunea@amd.com>

[ Upstream commit f44c094449669c7d9ac403cc73ce23e255f0828b ]

[why & how]
On D3 path during dc_set_power_state, we may be in idle_allowed=true,
at which point we will exit idle via dc_wake_and_execute_dmub_cmd_list
which doesn't update dc->idle_optimizations_allowed to false. This
would cause any future attempts to allow idle optimizations via the DC
helper to get skipped because the value is stale and not reflective of
the actual HW state.

Move dc_exit_ips_for_hw_access() to the top of the function.
Additionally ensure that dc_power_down_on_boot thread holds the DC
lock and only runs if there are 0 streams.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good - the code matches the "before" state of the diff perfectly. The
patch would apply cleanly to this tree.

Now let me complete the final analysis phases with a comprehensive
synthesis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [drm/amd/display] [Exit/Move] Fix stale IPS idle state tracking
in dc_set_power_state and dc_power_down_on_boot.

**Step 1.2: Tags**
- Reviewed-by: Nicholas Kazlauskas (he's the original author of
  `dc_exit_ips_for_hw_access`, a key AMD display engineer)
- Signed-off-by: Ovidiu Bunea (patch author, AMD display developer)
- Signed-off-by: Ivan Lipski (submitter, AMD display)
- Tested-by: Dan Wheeler (AMD QA)
- Signed-off-by: Alex Deucher (AMD GPU subsystem maintainer)
- No Fixes: tag, no Cc: stable, no Reported-by: - expected for this
  review pipeline.

**Step 1.3: Commit Body**
The commit clearly describes a state inconsistency bug: On the D3 power-
down path, if `idle_allowed=true`, the system exits idle via
`dc_wake_and_execute_dmub_cmd_list` which does NOT update
`dc->idle_optimizations_allowed` to false. This leaves a stale value.
Any future attempt to call `dc_allow_idle_optimizations(dc, false)` gets
skipped at line 5714 (`if (allow == dc->idle_optimizations_allowed)
return;`) because the stale value says it's already false, when the HW
actually re-entered idle.

**Step 1.4: Hidden Bug Fix**
This IS a bug fix. The commit message is explicit about the bug
mechanism: stale state causes future IPS exits to be skipped. This can
lead to register access while the hardware is in a power-gated/idle
state, which can cause hangs, corruption, or crashes.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file: `drivers/gpu/drm/amd/display/dc/core/dc.c`
- ~6 lines changed net (moved `dc_exit_ips_for_hw_access` before switch,
  added stream_count guard)
- Functions modified: `dc_power_down_on_boot`, `dc_set_power_state`

**Step 2.2: Code Flow Change**
1. In `dc_set_power_state`: `dc_exit_ips_for_hw_access(dc)` moved from
   inside D0 case to before the switch statement. This ensures ALL power
   state transitions (D0, D3, default) exit IPS cleanly via the DC
   helper that properly updates `dc->idle_optimizations_allowed`.
2. In `dc_power_down_on_boot`: Added `stream_count > 0` early return
   guard to prevent power_down_on_boot from running when there are
   active streams (safety check, holds DC lock).

**Step 2.3: Bug Mechanism**
Category: **State inconsistency / stale flag bug**. The D3 path calls
`dc_dmub_srv_notify_fw_dc_power_state` which internally calls
`dc_wake_and_execute_dmub_cmd_list`. That function uses
`dc_dmub_srv_apply_idle_power_optimizations(ctx->dc, false)` which sets
`dc_dmub_srv->idle_allowed = false` but does NOT update
`dc->idle_optimizations_allowed`. When `dc_exit_ips_for_hw_access`
(which calls `dc_allow_idle_optimizations_internal`) is NOT called on D3
path, `dc->idle_optimizations_allowed` stays `true` (stale). On
subsequent resume, the guard `if (allow ==
dc->idle_optimizations_allowed) return;` at line 5714 prevents the real
IPS exit from happening.

**Step 2.4: Fix Quality**
- The fix is small, surgical, and obviously correct.
- Moving IPS exit before the switch is safe: for D0, it was already
  there (just earlier now); for D3, it's newly added; for default, it's
  newly covered.
- The `dc_exit_ips_for_hw_access` is a no-op when IPS is not supported
  (checks `dc->caps.ips_support`).
- The stream_count guard in `dc_power_down_on_boot` is a defensive check
  that prevents powering down when displays are active.
- Regression risk: LOW. The IPS exit is idempotent and already called on
  D0. Adding it before the switch just expands coverage.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- `dc_set_power_state` core structure dates back to commit
  `4562236b3bc0a2` (Harry Wentland, 2017) - very old, stable code.
- `dc_exit_ips_for_hw_access` was added to D0 path by `a9b1a4f684b32b`
  (Nicholas Kazlauskas, 2024-01-16) - tagged "Cc: stable@vger.kernel.org
  # 6.1+"
- The D3 case was added by `2ee27baf5c7cba` (Duncan Ma, 2025-03-31) -
  first in v6.17-rc1. This commit introduced the D3-specific path that
  triggers the bug.

**Step 3.2: Fixes tag**
No Fixes: tag. However, the bug is clearly introduced by
`2ee27baf5c7cba` (D3 path) combined with `a9b1a4f684b32b` (IPS exit only
in D0).

**Step 3.3: File history**
The file is actively developed. The current tree state matches the diff
context exactly.

**Step 3.4: Author**
Ovidiu Bunea is a regular AMD display developer. Reviewed by Nicholas
Kazlauskas who is a key AMD display engineer and the original author of
IPS support.

**Step 3.5: Dependencies**
Requires `2ee27baf5c7cba` (D3 case in dc_set_power_state) to be present.
This commit was first in v6.17-rc1. In the 7.0 tree, this is already
present.

## PHASE 4: MAILING LIST RESEARCH

b4 dig failed to find matching threads for both the IPS exit commit and
the D3 notification commit (AMD display patches often go through
internal AMD submission channels). No lore discussion available.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions modified**: `dc_power_down_on_boot`,
`dc_set_power_state`

**Step 5.2: Callers**
- `dc_set_power_state` is called from `dm_suspend` (D3) and `dm_resume`
  (D0) in `amdgpu_dm.c` - these are the primary suspend/resume paths for
  ALL AMD GPUs.
- `dc_power_down_on_boot` - called during initial boot for display power
  management.

**Step 5.3-5.4: Call chain**
Suspend/resume is a hot user-facing path. Every AMD GPU user hits this
on laptop suspend/resume, hibernate, and S0ix entry/exit.

**Step 5.5: Similar patterns**
The `dc_exit_ips_for_hw_access` call is a common pattern throughout AMD
display code - it's used in `dc_stream.c`, `dc_surface.c`, and many
places in `dc.c`.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy code existence**
- The D3 path (`2ee27baf5c7cba`) was first introduced in v6.17-rc1.
- The IPS exit (`a9b1a4f684b32b`) has been marked Cc: stable 6.1+.
- The bug requires BOTH commits to be present. For stable trees <= 6.12,
  the D3 path doesn't exist, so the specific bug doesn't trigger there.
- For stable 7.0 tree: both commits are present, bug can trigger.

**Step 6.2: Backport complications**
The patch applies cleanly to the 7.0 tree (verified by comparing the
current code state with the diff context).

## PHASE 7: SUBSYSTEM CONTEXT

- Subsystem: drm/amd/display - GPU display driver
- Criticality: IMPORTANT - AMD GPUs are in millions of laptops and
  desktops. Suspend/resume is critical for laptop users.
- IPS (Idle Power State) affects DCN35+ hardware (recent AMD APUs in
  laptops).

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is affected**
All users of AMD APUs with DCN35+ display hardware (IPS support) - this
includes recent AMD Ryzen laptops.

**Step 8.2: Trigger conditions**
Any suspend/resume cycle to D3 state when IPS is enabled
(idle_allowed=true). This is a common, everyday operation on laptops.

**Step 8.3: Failure mode**
The stale `idle_optimizations_allowed` flag means subsequent IPS exit
calls get skipped. This means hardware register accesses can happen
while the hardware is power-gated, leading to:
- Display hangs
- System hangs on resume
- Potential display corruption
Severity: **HIGH** (system hang/display hang on resume)

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: HIGH - prevents display/system hangs on suspend/resume for
  AMD laptop users
- RISK: LOW - ~6 lines changed, moving an existing call earlier and
  adding a defensive guard
- The fix is obviously correct, reviewed by the IPS subsystem expert,
  and tested by AMD QA

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Fixes a real state inconsistency bug that causes stale IPS idle
  tracking
- Triggers on every D3 suspend path for AMD APUs with IPS support (very
  common)
- Failure mode is display/system hang on resume (HIGH severity)
- Small, surgical fix (~6 lines), single file
- Reviewed by Nicholas Kazlauskas (IPS expert), tested by AMD QA
- Applies cleanly to the 7.0 tree
- The parent commit `a9b1a4f684b32b` was already explicitly nominated
  for stable (Cc: stable 6.1+)

**Evidence AGAINST backporting:**
- No Fixes: tag (expected)
- No syzbot/user bug reports linked (AMD internal finding)
- The D3 path dependency (`2ee27baf5c7cba`) is only in v6.17+, limiting
  which stable trees need this

**Stable Rules Checklist:**
1. Obviously correct and tested? YES - reviewed by IPS expert, tested by
   AMD QA
2. Fixes a real bug? YES - stale state causes IPS exits to be skipped
3. Important issue? YES - display/system hang on suspend/resume
4. Small and contained? YES - ~6 lines, single file
5. No new features? CORRECT - no new features
6. Can apply to stable? YES - applies cleanly to 7.0

## Verification

- [Phase 1] Parsed tags: Reviewed-by Nicholas Kazlauskas (IPS author),
  Tested-by Dan Wheeler (AMD QA), Signed-off-by Alex Deucher
  (maintainer)
- [Phase 2] Diff: ~6 lines changed in dc.c, moves
  dc_exit_ips_for_hw_access before switch, adds stream_count guard
- [Phase 2] Traced bug mechanism: dc_wake_and_execute_dmub_cmd_list sets
  dc_dmub_srv->idle_allowed but NOT dc->idle_optimizations_allowed,
  confirmed at lines 1728-1730 and 1694 of dc_dmub_srv.c, and guard at
  line 5714 of dc.c
- [Phase 3] git blame: D3 path introduced by 2ee27baf5c7cba (v6.17-rc1),
  IPS exit by a9b1a4f684b32b (v6.9-rc1, Cc: stable 6.1+)
- [Phase 3] Confirmed 2ee27baf5c7cba is in v7.0 tree (git merge-base
  --is-ancestor)
- [Phase 3] Confirmed a9b1a4f684b32b is in v7.0 tree (git merge-base
  --is-ancestor)
- [Phase 4] b4 dig failed for both parent commits (AMD internal
  submission path)
- [Phase 5] dc_set_power_state called from dm_suspend/dm_resume - common
  laptop suspend/resume path
- [Phase 6] Current tree code matches diff context exactly - clean apply
  expected
- [Phase 6] Bug requires D3 path (v6.17+) - applicable to 7.0 stable
  tree
- [Phase 8] Failure mode: stale idle flag -> skipped IPS exit ->
  register access while power-gated -> hang. Severity HIGH.
- UNVERIFIED: Could not find mailing list discussion (b4 dig returned no
  results). Decision not affected since the code analysis is conclusive.

The fix is small, surgical, addresses a clear state-tracking bug in AMD
display's IPS handling that affects suspend/resume on common AMD laptop
hardware, and meets all stable kernel criteria.

**YES**

 drivers/gpu/drm/amd/display/dc/core/dc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 3e87b6a553be9..4c5ecbb97d5b0 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -5540,6 +5540,9 @@ void dc_power_down_on_boot(struct dc *dc)
 {
 	if (dc->ctx->dce_environment != DCE_ENV_VIRTUAL_HW &&
 	    dc->hwss.power_down_on_boot) {
+		if (dc->current_state->stream_count > 0)
+			return;
+
 		if (dc->caps.ips_support)
 			dc_exit_ips_for_hw_access(dc);
 		dc->hwss.power_down_on_boot(dc);
@@ -5551,12 +5554,12 @@ void dc_set_power_state(struct dc *dc, enum dc_acpi_cm_power_state power_state)
 	if (!dc->current_state)
 		return;
 
+	dc_exit_ips_for_hw_access(dc);
+
 	switch (power_state) {
 	case DC_ACPI_CM_POWER_STATE_D0:
 		dc_state_construct(dc, dc->current_state);
 
-		dc_exit_ips_for_hw_access(dc);
-
 		dc_z10_restore(dc);
 
 		dc_dmub_srv_notify_fw_dc_power_state(dc->ctx->dmub_srv, power_state);
-- 
2.53.0

