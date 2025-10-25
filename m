Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF10C305053;
	Sat, 25 Oct 2025 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409305; cv=none; b=R3PCjVXxVYSii1PZ5t+h7rqU9azl6MLkv2TWGHKZ5BgPKbC3FammkJejHEFiLDvAs9SsIv6s7mpHyI7FNsS1YBQFhXah7n6InWnx/tHVBmBx138NQ+4SQeVcRRvGriMSRC6hrYB3kl3azCJHo2so25MSs7jx3nF9zuz/Wil55pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409305; c=relaxed/simple;
	bh=aD9oYzwsg7RI70oVAmJ7ZuirpQru5RwbcwHaGSh0OS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=APgk0Q3Fs+4LmH+MMOJTJJ8bjCPCug9PNfSf6QV/1YsH897kwWlhYLyqXIVzNbq/rS2rTY6DZDTQRrgCa2Gl1T8wjuVozKdyLfbEucCJ8q8s7pFxKP3XBIbPdSsZFLHU/1CHyclnpij1+cLjvLKrnOBQGWj4S4hfpUTXUISIZD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ArFpiZLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ArFpiZLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F184C2BC9E;
	Sat, 25 Oct 2025 16:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409304;
	bh=aD9oYzwsg7RI70oVAmJ7ZuirpQru5RwbcwHaGSh0OS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArFpiZLFuvyQ9wkBNZfl3/0xknjxyxFz+9YfOKmPhVXHmXnho+VTvFoeu7xYouYhF
	 1w93zinfQ9X9RLvzZmRDWXu01vf+Fyp1cVCGaozGZnNZWXjvX1GmixH8Ud0n0lNI1D
	 gMAv22Wgoc6AUG7cNAmf5x3actXyhTsg5IdEUkkZtUzLx6vcy6zK1kDx5mdT+Z1Iid
	 lA9oLo/HNjtVru2HSdrfHTpWWHnK/k2gFqbAl3mgS7h6b/9e7hw4KVrlKaCpb2GMWl
	 nzHIvV2hwEwd7eosLPNkEbdZGmnLTQMAoM4idRaxKs35AN02k2gXcQiSe5PTR3i4S9
	 yiO6DGYoRDigA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/xe/guc: Always add CT disable action during second init step
Date: Sat, 25 Oct 2025 11:58:22 -0400
Message-ID: <20251025160905.3857885-271-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 955f3bc4af440bb950c7a1567197aaf6aa2213ae ]

On DGFX, during init_post_hwconfig() step, we are reinitializing
CTB BO in VRAM and we have to replace cleanup action to disable CT
communication prior to release of underlying BO.

But that introduces some discrepancy between DGFX and iGFX, as for
iGFX we keep previously added disable CT action that would be called
during unwind much later.

To keep the same flow on both types of platforms, always replace old
cleanup action and register new one.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Link: https://lore.kernel.org/r/20250908102053.539-2-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - The second-stage init `xe_guc_ct_init_post_hwconfig` now always
    rebinds the device-managed cleanup for disabling CT, not only on
    dGFX.
  - Before: early return on non-dGFX skipped cleanup rebind, leaving the
    original `guc_action_disable_ct` action in its earlier position in
    the devres stack.
    - Reference: previous flow in `drivers/gpu/drm/xe/xe_guc_ct.c` where
      a `return 0` occurred for non-dGFX after the `!IS_DGFX(xe)` check.
  - After: `IS_DGFX(xe)` gates only the VRAM reinit, but the function
    always removes/releases the existing disable action and re-adds it.
    - Reference (current code structure):
      `drivers/gpu/drm/xe/xe_guc_ct.c:294` definition; VRAM reinit in
      `drivers/gpu/drm/xe/xe_guc_ct.c:303` and rebind sequence at
      `drivers/gpu/drm/xe/xe_guc_ct.c:309` (remove) and
      `drivers/gpu/drm/xe/xe_guc_ct.c:310` (re-add).

- Why it matters (ordering bug/consistency)
  - `guc_action_disable_ct` is first registered in the initial init path
    so CT is disabled before CTB BO teardown during managed cleanup.
    - Reference: first registration in `xe_guc_ct_init` at
      `drivers/gpu/drm/xe/xe_guc_ct.c:281`.
  - In the dGFX path, `xe_managed_bo_reinit_in_vram` replaces the SMEM
    BO with a VRAM BO and executes the old BO’s managed action
    immediately.
    - Reference: `drivers/gpu/drm/xe/xe_bo.c:2679` uses
      `devm_release_action(...)` to release the old BO pin/map action
      during reinit.
  - Without re-registering `guc_action_disable_ct` after the new BO is
    created, the devres LIFO order can invert: the new BO’s cleanup runs
    before CT is disabled, risking CT activity referencing a BO that is
    being torn down. This was corrected for dGFX and is now made
    consistent for iGFX by always re-registering.
  - The function asserts CT is not enabled at this stage, so
    removing/re-adding (or releasing/re-adding) the disable action is
    safe and purely affects future cleanup ordering, not current state.
    - Reference: `drivers/gpu/drm/xe/xe_guc_ct.c:301` `xe_assert(xe,
      !xe_guc_ct_enabled(ct));`

- Impact scope and risk
  - Scope: one function in the Xe GuC CT path,
    `drivers/gpu/drm/xe/xe_guc_ct.c:294`.
  - Behavior change: only the devres cleanup ordering for
    `guc_action_disable_ct` relative to resources registered around the
    post-hwconfig phase. No API/ABI changes, no functional changes at
    runtime beyond safer teardown/unwind ordering.
  - Low regression risk: re-registering the same action is idempotent
    with respect to runtime, and improves consistency between dGFX and
    iGFX flows. If `devm_release_action` is used (as in the patch text),
    `guc_action_disable_ct` executes immediately; this is safe because
    CT is asserted disabled at this point and the action is a no-op
    state transition to DISABLED.
    - Reference: `guc_action_disable_ct` body at
      `drivers/gpu/drm/xe/xe_guc_ct.c:257` sets `ct->state =
      XE_GUC_CT_STATE_DISABLED`.

- Stable backport criteria
  - Fixes a real (if timing-dependent) bug class: mismatched cleanup
    ordering between platform variants that could allow CT communication
    to outlive its buffer during teardown/error-unwind.
  - Minimal, contained change in a driver subsystem; no architectural
    changes.
  - No new features; improves correctness and consistency.
  - Touches only DRM Xe GuC control transport; not a core subsystem.

- Additional context
  - This function is invoked during the post-hwconfig phase:
    `drivers/gpu/drm/xe/xe_guc.c:837`. Ensuring the disable action is
    re-registered here makes its cleanup ordering correct relative to
    the newly created VRAM BO (on dGFX) and consistent on iGFX as
    further managed resources are registered after this step.

Given the low risk, small scope, and correctness benefit (unified and
safe cleanup ordering), this is a good candidate for stable backporting.

 drivers/gpu/drm/xe/xe_guc_ct.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index ff622628d823f..22eff8476ad48 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -300,12 +300,11 @@ int xe_guc_ct_init_post_hwconfig(struct xe_guc_ct *ct)
 
 	xe_assert(xe, !xe_guc_ct_enabled(ct));
 
-	if (!IS_DGFX(xe))
-		return 0;
-
-	ret = xe_managed_bo_reinit_in_vram(xe, tile, &ct->bo);
-	if (ret)
-		return ret;
+	if (IS_DGFX(xe)) {
+		ret = xe_managed_bo_reinit_in_vram(xe, tile, &ct->bo);
+		if (ret)
+			return ret;
+	}
 
 	devm_release_action(xe->drm.dev, guc_action_disable_ct, ct);
 	return devm_add_action_or_reset(xe->drm.dev, guc_action_disable_ct, ct);
-- 
2.51.0

