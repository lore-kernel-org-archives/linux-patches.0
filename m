Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B6621C160;
	Sat, 14 Feb 2026 01:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031094; cv=none; b=FBPeJaggMipQYc03h8WvLzDwZHu7T2USleLHftl3aFcsA+NxcDR24ZNDes3g/uRG1tfhS9wynfaFikBU3W3Vcwdhr8FjBv8w7zxNPY+9mvj+GrErBTOdzEuVk+0bFOFNLdMxkWLpSepSBZKtyAGwrqRZf+c/euiwrenSnNufv5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031094; c=relaxed/simple;
	bh=2VGAo08dODV63An3m4c94VUPN0NVWGBxMHC+S8J6YHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tfej+A5ko0+3ApcDHi8FpDKLejh/MxM3+Mu1ya5fn+iQHzEnovnQZam2q/h+ZPlMmiaqERxiQ2dLXTK6HpBy8Mp2vPpx3i43WMhFOGQSWBIj6+eDREcIhkY49sEHJHZ3UlT9sLfXW9sHtMbNCcnvahIBE3spkdA29fzKgvN3SzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NPC2GBUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NPC2GBUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233CBC16AAE;
	Sat, 14 Feb 2026 01:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031094;
	bh=2VGAo08dODV63An3m4c94VUPN0NVWGBxMHC+S8J6YHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPC2GBUeVOyaWwfPIF9/+qGQyg3/CQa/yYJiNm4i7gR23WPV+ooBgc0CrXRo0G3xT
	 Lo1jn5i/XR9z1CY67rDepQ/P6rnsNp244Nt/ys5PIFvaveLZ2kar9kSBMarQg7ynK8
	 +/dAOoHSWGo/09V9lfZd0utB58HOoIr9JLJ/gHnYd4KtOoWh8vdRZfju5hsj3Tc66V
	 Q9Nn0k0JD2HzZdgoHZ7KybWhaCZiJCgOk2RoCtO+jiDDezke9C9tjtZ0Rwt8S5ZO0r
	 flAmNsnzicCM8vkZmn/kpWg0aWJTTqNZkJXi9Y1acp7OzbTjBRDgkApefa0OlxfUpC
	 OkFf6Z50aDKaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Suraj Kandpal <suraj.kandpal@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jani.nikula@intel.com,
	lumag@kernel.org,
	neil.armstrong@linaro.org,
	tzimmermann@suse.de,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-6.1] drm/display/dp_mst: Add protection against 0 vcpi
Date: Fri, 13 Feb 2026 19:58:58 -0500
Message-ID: <20260214010245.3671907-58-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit 342ccffd9f77fc29fe1c05fd145e4d842bd2feaa ]

When releasing a timeslot there is a slight chance we may end up
with the wrong payload mask due to overflow if the delayed_destroy_work
ends up coming into play after a DP 2.1 monitor gets disconnected
which causes vcpi to become 0 then we try to make the payload =
~BIT(vcpi - 1) which is a negative shift. VCPI id should never
really be 0 hence skip changing the payload mask if VCPI is 0.

Otherwise it leads to
<7> [515.287237] xe 0000:03:00.0: [drm:drm_dp_mst_get_port_malloc
[drm_display_helper]] port ffff888126ce9000 (3)
<4> [515.287267] -----------[ cut here ]-----------
<3> [515.287268] UBSAN: shift-out-of-bounds in
../drivers/gpu/drm/display/drm_dp_mst_topology.c:4575:36
<3> [515.287271] shift exponent -1 is negative
<4> [515.287275] CPU: 7 UID: 0 PID: 3108 Comm: kworker/u64:33 Tainted: G
S U 6.17.0-rc6-lgci-xe-xe-3795-3e79699fa1b216e92+ #1 PREEMPT(voluntary)
<4> [515.287279] Tainted: [S]=CPU_OUT_OF_SPEC, [U]=USER
<4> [515.287279] Hardware name: ASUS System Product Name/PRIME Z790-P
WIFI, BIOS 1645 03/15/2024
<4> [515.287281] Workqueue: drm_dp_mst_wq drm_dp_delayed_destroy_work
[drm_display_helper]
<4> [515.287303] Call Trace:
<4> [515.287304] <TASK>
<4> [515.287306] dump_stack_lvl+0xc1/0xf0
<4> [515.287313] dump_stack+0x10/0x20
<4> [515.287316] __ubsan_handle_shift_out_of_bounds+0x133/0x2e0
<4> [515.287324] ? drm_atomic_get_private_obj_state+0x186/0x1d0
<4> [515.287333] drm_dp_atomic_release_time_slots.cold+0x17/0x3d
[drm_display_helper]
<4> [515.287355] mst_connector_atomic_check+0x159/0x180 [xe]
<4> [515.287546] drm_atomic_helper_check_modeset+0x4d9/0xfa0
<4> [515.287550] ? __ww_mutex_lock.constprop.0+0x6f/0x1a60
<4> [515.287562] intel_atomic_check+0x119/0x2b80 [xe]
<4> [515.287740] ? find_held_lock+0x31/0x90
<4> [515.287747] ? lock_release+0xce/0x2a0
<4> [515.287754] drm_atomic_check_only+0x6a2/0xb40
<4> [515.287758] ? drm_atomic_add_affected_connectors+0x12b/0x140
<4> [515.287765] drm_atomic_commit+0x6e/0xf0
<4> [515.287766] ? _pfx__drm_printfn_info+0x10/0x10
<4> [515.287774] drm_client_modeset_commit_atomic+0x25c/0x2b0
<4> [515.287794] drm_client_modeset_commit_locked+0x60/0x1b0
<4> [515.287795] ? mutex_lock_nested+0x1b/0x30
<4> [515.287801] drm_client_modeset_commit+0x26/0x50
<4> [515.287804] __drm_fb_helper_restore_fbdev_mode_unlocked+0xdc/0x110
<4> [515.287810] drm_fb_helper_hotplug_event+0x120/0x140
<4> [515.287814] drm_fbdev_client_hotplug+0x28/0xd0
<4> [515.287819] drm_client_hotplug+0x6c/0xf0
<4> [515.287824] drm_client_dev_hotplug+0x9e/0xd0
<4> [515.287829] drm_kms_helper_hotplug_event+0x1a/0x30
<4> [515.287834] drm_dp_delayed_destroy_work+0x3df/0x410
[drm_display_helper]
<4> [515.287861] process_one_work+0x22b/0x6f0
<4> [515.287874] worker_thread+0x1e8/0x3d0
<4> [515.287879] ? __pfx_worker_thread+0x10/0x10
<4> [515.287882] kthread+0x11c/0x250
<4> [515.287886] ? __pfx_kthread+0x10/0x10
<4> [515.287890] ret_from_fork+0x2d7/0x310
<4> [515.287894] ? __pfx_kthread+0x10/0x10
<4> [515.287897] ret_from_fork_asm+0x1a/0x30

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6303
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20251119094650.799135-1-suraj.kandpal@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The other `BIT(payload->vcpi - 1)` at line 5389 is safe because it's
always guarded by `if (!payload->vcpi)` at line 5385 — that block only
runs when vcpi is 0 and assigns a new non-zero value before using it in
the BIT macro.

Here is my complete analysis:

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit message is very clear and detailed:
- **Bug**: A UBSAN shift-out-of-bounds error occurs when `payload->vcpi`
  is 0 and the code computes `~BIT(payload->vcpi - 1)`, which is
  `~BIT(-1)` — a negative shift, which is undefined behavior in C.
- **Trigger**: A DP 2.1 MST monitor gets disconnected, and
  `drm_dp_delayed_destroy_work` fires. The destroy work triggers a
  hotplug event, leading to an atomic check that calls
  `drm_dp_atomic_release_time_slots()`. At this point, the payload
  exists but its VCPI hasn't been assigned yet (still 0 from `kzalloc`
  initialization).
- **Evidence**: A full kernel UBSAN stack trace is provided, clearly
  showing the crash path through `drm_dp_delayed_destroy_work` ->
  `drm_kms_helper_hotplug_event` -> ... ->
  `drm_dp_atomic_release_time_slots.cold`.
- **Tracking**: Closes a real bug report at
  `gitlab.freedesktop.org/drm/xe/kernel/-/issues/6303`.
- **Reviews**: Both `Reviewed-by: Imre Deak` (Intel DRM developer) and
  `Reviewed-by: Lyude Paul` (Red Hat, primary MST maintainer) signed off
  on this.

### 2. Code Change Analysis

The fix is exactly **2 lines changed** (1 line replaced with 2 lines):

**Before:**
```c
topology_state->payload_mask &= ~BIT(payload->vcpi - 1);
```

**After:**
```c
if (payload->vcpi > 0)
    topology_state->payload_mask &= ~BIT(payload->vcpi - 1);
```

The `vcpi` field is `u8` in `struct drm_dp_mst_atomic_payload`. When a
payload is allocated via `kzalloc` in `drm_dp_atomic_find_time_slots()`
(line 4482), `vcpi` starts at 0. VCPI assignment happens later in
`drm_dp_mst_atomic_check_mgr_topology()` (lines 5385-5389). The race
window is:

1. Payload is created with `vcpi = 0`
2. Monitor disconnects, `drm_dp_delayed_destroy_work` fires
3. This triggers `drm_kms_helper_hotplug_event()`
4. The hotplug event leads to an atomic check path that calls
   `drm_dp_atomic_release_time_slots()`
5. The function retrieves the payload (which exists and has `delete ==
   false`)
6. It tries to compute `~BIT(payload->vcpi - 1)` = `~BIT(0 - 1)` =
   `~BIT(-1)` = undefined behavior

When `vcpi` is 0, there is no corresponding bit to clear in
`payload_mask` (VCPI IDs are 1-indexed per the assignment logic
`ffz(mask) + 1`), so skipping the mask update is the correct behavior.

### 3. Bug Classification

- **Type**: Undefined behavior (negative shift exponent), UBSAN-detected
- **Severity**: Medium-High. While UBSAN catches it as UB, the practical
  effect is that `payload_mask` gets corrupted (on most architectures, a
  negative shift produces an implementation-defined result, potentially
  setting or clearing wrong bits). Corrupted `payload_mask` means future
  VCPI assignments via `ffz(mst_state->payload_mask) + 1` could assign
  duplicate or invalid VCPI IDs, leading to further issues.
- **Trigger**: Real-world scenario — disconnecting a DP 2.1 MST monitor

### 4. Scope and Risk Assessment

- **Lines changed**: 2 (one line becomes two lines — a simple guard
  condition)
- **Files changed**: 1 (`drm_dp_mst_topology.c`)
- **Risk**: Extremely low. The guard only activates when `vcpi == 0`,
  which is the exact case that triggers UB. For all other cases (`vcpi >
  0`, the normal path), behavior is unchanged.
- **No functional change** for the common (non-buggy) code path.

### 5. Applicability to Stable Trees

The vulnerable code (`payload_mask &= ~BIT(payload->vcpi - 1)`) was
introduced by commit `4d07b0bc40340` ("drm/display/dp_mst: Move all
payload info into the atomic state"), which landed in v6.1. I confirmed
the exact same vulnerable line exists in:
- **v6.1** (line 4333)
- **v6.6** (line 4416)
- **v6.12** (line 4503)

The surrounding code context is virtually identical in all stable trees.
The patch will apply cleanly (with trivial line offset adjustments).
Note: In v6.1, there's an extra `drm_dp_mst_put_port_malloc(port)` call
inside the `if (!payload->delete)` block, but it's before the vulnerable
line and doesn't affect the patch context.

### 6. User Impact

This affects any user with a DP 2.1 MST monitor (increasingly common
with modern displays and docking stations). Disconnecting the monitor
can trigger UBSAN warnings and potentially corrupt the payload mask,
leading to incorrect VCPI management for remaining MST payloads.
Affected drivers include Intel (i915/xe), AMD (amdgpu), and Nouveau —
all call `drm_dp_atomic_release_time_slots()`.

### 7. Dependency Check

This fix is entirely self-contained. It adds a simple guard check to an
existing code path. No other commits are required.

### Summary

This is a textbook stable backport candidate:
- Fixes a real bug (UBSAN undefined behavior + potential payload_mask
  corruption)
- Triggered by a common user action (monitor disconnect)
- Minimal, surgical 2-line fix
- Reviewed by the MST subsystem maintainer (Lyude Paul) and Intel DRM
  developer (Imre Deak)
- Has a linked bug report from a real user
- Applies cleanly to all current stable trees (v6.1, v6.6, v6.12)
- Zero risk of regression — only adds a guard for an impossible-to-be-
  correct code path (VCPI 0)

**YES**

 drivers/gpu/drm/display/drm_dp_mst_topology.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 64e5c176d5cce..be749dcad3b58 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -4572,7 +4572,8 @@ int drm_dp_atomic_release_time_slots(struct drm_atomic_state *state,
 	if (!payload->delete) {
 		payload->pbn = 0;
 		payload->delete = true;
-		topology_state->payload_mask &= ~BIT(payload->vcpi - 1);
+		if (payload->vcpi > 0)
+			topology_state->payload_mask &= ~BIT(payload->vcpi - 1);
 	}
 
 	return 0;
-- 
2.51.0

