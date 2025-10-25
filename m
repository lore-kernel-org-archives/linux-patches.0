Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730C22FC893;
	Sat, 25 Oct 2025 16:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409185; cv=none; b=iO2HVXg342k/xeM66MNNhe3J10ebfw7CLYTVUcwfEC6XrKQx+wIep/Q0UDmagbXRMOyKf5PWWVt86xp9kaiNlyyB3ZDeR4UIG/uDSEuU1BWiTrzRYiYzJGpU9GjAM4Abpy/SeGbwMFVrjd8SZcYJ8vvB7m0EY1JLWHH04znwbdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409185; c=relaxed/simple;
	bh=WgYIwV2KeVONWXyJp4I5bJQyfVFMcbdbebE2gsjQuSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rx1tHh6O2/YN5poiXEPmfzBTRFDU/PFRThzDSLKbUwxREbTCq4kAIhmcxXTtrDaiLXgFPEL+EuOUfAMA6i1ab1jP/k6L49I4yRV5DHvUIvD1PcHftDYjIllbPeosvKSOzWYBuP84Q2c0QWfhH3tWKWZaTbwcEaqiDZXfrfX74yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dgv+KdNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dgv+KdNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C679C4CEF5;
	Sat, 25 Oct 2025 16:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409185;
	bh=WgYIwV2KeVONWXyJp4I5bJQyfVFMcbdbebE2gsjQuSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dgv+KdNoPO45UlCzcVtusrE2Cu1hHW2ZJOOd5b1V3xfecWJIOM94FAv69a8OCfsi5
	 LEceWh6c+Jd3QZ2HpHmASM6L/p6G/G7FoKDWG326wi0IapZhOls7OI9fDlqD57//eu
	 E30F9VNjJ4yfzcTSWSatDXrNx8WqIZKrpU+lWYAy09lqLiBGzJ2g2jpcLkxLH07zXx
	 meDDrHfNUcQ9xgwFFMg6oZqYFE9YXEdG+hO/fTLgLsijcDyJ0qmjPJFNiSWwMUj+eH
	 9Ilw8uBNEUQYiahF0pSBTAbm9Fb8/U26xQZMuhoKW1GRu6KQ78inBr7qShalXQ7N3K
	 A7y3YoP8OBaeg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Summers Stuart <stuart.summers@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/xe/guc: Add devm release action to safely tear down CT
Date: Sat, 25 Oct 2025 11:57:44 -0400
Message-ID: <20251025160905.3857885-233-sashal@kernel.org>
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

From: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>

[ Upstream commit ee4b32220a6b41e71512e8804585325e685456ba ]

When a buffer object (BO) is allocated with the XE_BO_FLAG_GGTT_INVALIDATE
flag, the driver initiates TLB invalidation requests via the CTB mechanism
while releasing the BO. However a premature release of the CTB BO can lead
to system crashes, as observed in:

Oops: Oops: 0000 [#1] SMP NOPTI
RIP: 0010:h2g_write+0x2f3/0x7c0 [xe]
Call Trace:
 guc_ct_send_locked+0x8b/0x670 [xe]
 xe_guc_ct_send_locked+0x19/0x60 [xe]
 send_tlb_invalidation+0xb4/0x460 [xe]
 xe_gt_tlb_invalidation_ggtt+0x15e/0x2e0 [xe]
 ggtt_invalidate_gt_tlb.part.0+0x16/0x90 [xe]
 ggtt_node_remove+0x110/0x140 [xe]
 xe_ggtt_node_remove+0x40/0xa0 [xe]
 xe_ggtt_remove_bo+0x87/0x250 [xe]

Introduce a devm-managed release action during xe_guc_ct_init() and
xe_guc_ct_init_post_hwconfig() to ensure proper CTB disablement before
resource deallocation, preventing the use-after-free scenario.

Signed-off-by: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Summers Stuart <stuart.summers@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Link: https://lore.kernel.org/r/20250901072541.31461-1-satyanarayana.k.v.p@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real crash/UAF: The commit addresses a use-after-free when BOs
  allocated with `XE_BO_FLAG_GGTT_INVALIDATE` trigger GGTT TLB
  invalidations during teardown via the GuC CTB path, while the CTB BO
  may have already been released. The reported call trace shows the GuC
  CT send path being used during BO removal, leading to a crash if CT
  resources are torn down too early (h2g_write → guc_ct_send_locked →
  send_tlb_invalidation → ggtt_* → xe_ggtt_remove_bo).

- Core fix (devm-managed CT disable): A devm release action is added so
  CT is transitioned to the disabled state during device-managed
  teardown before dependent resources are freed. This is implemented by
  registering a managed action that calls `guc_ct_change_state(ct,
  XE_GUC_CT_STATE_DISABLED)`:
  - New action: `guc_action_disable_ct()` calls the internal state
    change to disabled, canceling fences, quiescing paths and preventing
    further CT traffic (drivers/gpu/drm/xe/xe_guc_ct.c:257).
  - Action registration in init: `devm_add_action_or_reset(xe->drm.dev,
    guc_action_disable_ct, ct)` ensures the disable runs during teardown
    (drivers/gpu/drm/xe/xe_guc_ct.c:281).
  - This is small, contained, and only affects the XE GuC CT teardown
    behavior.

- Ensures correct teardown ordering across reinit: The CT buffer is
  reallocated into VRAM post-hwconfig for dGFX, which changes devres
  ordering. To keep the “disable CT” action running before releasing the
  (new) CT BO, the patch removes and re-adds the devm action after the
  VRAM reinit so the disable action is the last registered and runs
  first (LIFO) during teardown:
  - CT VRAM reinit helper: `xe_guc_ct_init_post_hwconfig()` performs
    `xe_managed_bo_reinit_in_vram()` for `ct->bo` and then removes and
    re-adds the devm action to fix ordering
    (drivers/gpu/drm/xe/xe_guc_ct.c:294-311).
  - The GuC-level post-hwconfig flow calls this new helper after generic
    reallocations (drivers/gpu/drm/xe/xe_guc.c:833,
    drivers/gpu/drm/xe/xe_guc.c:837-839). This also removes the previous
    attempt to reinit `guc->ct.bo` in the generic realloc function to
    avoid ordering issues.

- Prevents the UAF in practice: TLB invalidation uses the CT path only
  if CT is enabled; otherwise it falls back to a safe MMIO path:
  - The GGTT invalidation path checks `xe_guc_ct_enabled(&guc->ct)` and
    submission state; if disabled, it uses MMIO-based invalidation
    instead (drivers/gpu/drm/xe/xe_guc_tlb_inval.c:64-72,
    drivers/gpu/drm/xe/xe_guc_tlb_inval.c:72-90).
  - By setting CT state to disabled via the devm action before CT BO or
    other resources are freed, teardown-time invalidations avoid the CT
    path, eliminating the use-after-free.

- Scope and risk:
  - Driver-only fix confined to the XE GuC/CT code paths
    (drivers/gpu/drm/xe/*).
  - No ABI changes, no feature additions, no architectural refactor.
  - The devm action calls the same internal state transition used by
    existing disable flows, with proper locking and fence cancelation.
    The change is minimal and low risk.

- Stable suitability:
  - Clearly fixes an important, user-affecting crash (Oops/UAF) during
    teardown.
  - Small, self-contained, and limited to the XE GuC CT
    initialization/teardown ordering.
  - Aligns with stable rules: bugfix, minimal risk, no new features,
    confined to a subsystem.
  - Note: Depending on stable branch, the helper used to drop/re-add the
    devm action may be `devm_remove_action` vs `devm_release_action`;
    trivial adaptation may be required, but the logic remains the same.

Given the crash it prevents, the minimal and targeted nature of the
changes, and the clear correctness rationale tied to teardown ordering
and the CT-enabled check in TLB invalidation, this is a strong candidate
for backporting to stable.

 drivers/gpu/drm/xe/xe_guc.c    |  8 +++----
 drivers/gpu/drm/xe/xe_guc_ct.c | 41 +++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/xe/xe_guc_ct.h |  1 +
 3 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index 9e0ed8fabcd54..62c76760fd26f 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -701,10 +701,6 @@ static int xe_guc_realloc_post_hwconfig(struct xe_guc *guc)
 	if (ret)
 		return ret;
 
-	ret = xe_managed_bo_reinit_in_vram(xe, tile, &guc->ct.bo);
-	if (ret)
-		return ret;
-
 	return 0;
 }
 
@@ -839,6 +835,10 @@ int xe_guc_init_post_hwconfig(struct xe_guc *guc)
 	if (ret)
 		return ret;
 
+	ret = xe_guc_ct_init_post_hwconfig(&guc->ct);
+	if (ret)
+		return ret;
+
 	guc_init_params_post_hwconfig(guc);
 
 	ret = xe_guc_submit_init(guc, ~0);
diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index 3f4e6a46ff163..6d70dd1c106d4 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -39,6 +39,8 @@ static void receive_g2h(struct xe_guc_ct *ct);
 static void g2h_worker_func(struct work_struct *w);
 static void safe_mode_worker_func(struct work_struct *w);
 static void ct_exit_safe_mode(struct xe_guc_ct *ct);
+static void guc_ct_change_state(struct xe_guc_ct *ct,
+				enum xe_guc_ct_state state);
 
 #if IS_ENABLED(CONFIG_DRM_XE_DEBUG)
 enum {
@@ -252,6 +254,13 @@ int xe_guc_ct_init_noalloc(struct xe_guc_ct *ct)
 }
 ALLOW_ERROR_INJECTION(xe_guc_ct_init_noalloc, ERRNO); /* See xe_pci_probe() */
 
+static void guc_action_disable_ct(void *arg)
+{
+	struct xe_guc_ct *ct = arg;
+
+	guc_ct_change_state(ct, XE_GUC_CT_STATE_DISABLED);
+}
+
 int xe_guc_ct_init(struct xe_guc_ct *ct)
 {
 	struct xe_device *xe = ct_to_xe(ct);
@@ -268,10 +277,40 @@ int xe_guc_ct_init(struct xe_guc_ct *ct)
 		return PTR_ERR(bo);
 
 	ct->bo = bo;
-	return 0;
+
+	return devm_add_action_or_reset(xe->drm.dev, guc_action_disable_ct, ct);
 }
 ALLOW_ERROR_INJECTION(xe_guc_ct_init, ERRNO); /* See xe_pci_probe() */
 
+/**
+ * xe_guc_ct_init_post_hwconfig - Reinitialize the GuC CTB in VRAM
+ * @ct: the &xe_guc_ct
+ *
+ * Allocate a new BO in VRAM and free the previous BO that was allocated
+ * in system memory (SMEM). Applicable only for DGFX products.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int xe_guc_ct_init_post_hwconfig(struct xe_guc_ct *ct)
+{
+	struct xe_device *xe = ct_to_xe(ct);
+	struct xe_gt *gt = ct_to_gt(ct);
+	struct xe_tile *tile = gt_to_tile(gt);
+	int ret;
+
+	xe_assert(xe, !xe_guc_ct_enabled(ct));
+
+	if (!IS_DGFX(xe))
+		return 0;
+
+	ret = xe_managed_bo_reinit_in_vram(xe, tile, &ct->bo);
+	if (ret)
+		return ret;
+
+	devm_release_action(xe->drm.dev, guc_action_disable_ct, ct);
+	return devm_add_action_or_reset(xe->drm.dev, guc_action_disable_ct, ct);
+}
+
 #define desc_read(xe_, guc_ctb__, field_)			\
 	xe_map_rd_field(xe_, &guc_ctb__->desc, 0,		\
 			struct guc_ct_buffer_desc, field_)
diff --git a/drivers/gpu/drm/xe/xe_guc_ct.h b/drivers/gpu/drm/xe/xe_guc_ct.h
index 18d4225e65024..cf41210ab30ae 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.h
+++ b/drivers/gpu/drm/xe/xe_guc_ct.h
@@ -13,6 +13,7 @@ struct xe_device;
 
 int xe_guc_ct_init_noalloc(struct xe_guc_ct *ct);
 int xe_guc_ct_init(struct xe_guc_ct *ct);
+int xe_guc_ct_init_post_hwconfig(struct xe_guc_ct *ct);
 int xe_guc_ct_enable(struct xe_guc_ct *ct);
 void xe_guc_ct_disable(struct xe_guc_ct *ct);
 void xe_guc_ct_stop(struct xe_guc_ct *ct);
-- 
2.51.0

