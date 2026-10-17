Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF383876BA;
	Sat, 17 Oct 2026 16:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253514; cv=none; b=GieGXmZh2dA1TomGJOKVHtMU/0wynaBNAXaURP/ipXHgyFJJUmbtpW4K1vjG+Opn/3zD/RVk6IiZEHnZYbkFNHqKuyGPuMfeuBvLRV2vdqPAglXMGDlTPst/Rh9PJ7erMx+d+Zuoy1xjn3W4Ed69QTdfO8SiZResuWQsl/rleNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253514; c=relaxed/simple;
	bh=89h/ZESUzp/6ixkPJJDHKxX8fwITPtotXzDMCR/1FhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmmlj/WpqWQOdc18/oGc4BbedabI7xOUaCMGfH7BY7uSOTJIBU58UHwcYlSVZVZXrlz0MYZnH3NtgFakvjYomC4VRJdRR+8hkGzvglZzA4fsdcGxezqjSG1jshH+ModsLDdX2HuJW/xYUa7ioijkouHdvp8U+dD51amUVB1B+LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxkXaV2X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxkXaV2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998661F000C5;
	Sat, 17 Oct 2026 16:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253513;
	bh=eZ7jGy+S2nO7JFQWCCBQ5yyRjaBVFi3t4Zlnp+OEBdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxkXaV2X7KxsyF1YdqXWXhVMmjHm+I1CTuPeNqDMd7yqhDMJubJxYg7lTIQZmwDf9
	 4BgeAG02ZqoOe4FIlTz1FdFifJIq9K3qvw7LSFhk/tBtiehVFqaKcFGvT2BY42bEkB
	 KctgS4AgYIFa4oOT/xGB9a0Z6IEDlUVmjonXKliU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Summers Stuart <stuart.summers@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/869] drm/xe/guc: Add devm release action to safely tear down CT
Date: Sat, 17 Oct 2026 17:49:43 +0200
Message-ID: <20261017160040.681830519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/gpu/drm/xe/xe_guc.c    |  8 +++----
 drivers/gpu/drm/xe/xe_guc_ct.c | 41 +++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/xe/xe_guc_ct.h |  1 +
 3 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index bedd9894e182e..d4c8a782e7e56 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -289,10 +289,6 @@ static int xe_guc_realloc_post_hwconfig(struct xe_guc *guc)
 	if (ret)
 		return ret;
 
-	ret = xe_managed_bo_reinit_in_vram(xe, tile, &guc->ct.bo);
-	if (ret)
-		return ret;
-
 	return 0;
 }
 
@@ -397,6 +393,10 @@ int xe_guc_init_post_hwconfig(struct xe_guc *guc)
 	if (ret)
 		return ret;
 
+	ret = xe_guc_ct_init_post_hwconfig(&guc->ct);
+	if (ret)
+		return ret;
+
 	guc_init_params_post_hwconfig(guc);
 
 	ret = xe_guc_submit_init(guc, ~0);
diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index 7619b48dbfe43..e9da1b478cb3d 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -36,6 +36,8 @@ static void receive_g2h(struct xe_guc_ct *ct);
 static void g2h_worker_func(struct work_struct *w);
 static void safe_mode_worker_func(struct work_struct *w);
 static void ct_exit_safe_mode(struct xe_guc_ct *ct);
+static void xe_guc_ct_set_state(struct xe_guc_ct *ct,
+				enum xe_guc_ct_state state);
 
 #if IS_ENABLED(CONFIG_DRM_XE_DEBUG)
 enum {
@@ -206,6 +208,13 @@ static void primelockdep(struct xe_guc_ct *ct)
 	fs_reclaim_release(GFP_KERNEL);
 }
 
+static void guc_action_disable_ct(void *arg)
+{
+	struct xe_guc_ct *ct = arg;
+
+	xe_guc_ct_set_state(ct, XE_GUC_CT_STATE_DISABLED);
+}
+
 int xe_guc_ct_init(struct xe_guc_ct *ct)
 {
 	struct xe_device *xe = ct_to_xe(ct);
@@ -252,7 +261,37 @@ int xe_guc_ct_init(struct xe_guc_ct *ct)
 
 	xe_gt_assert(gt, ct->state == XE_GUC_CT_STATE_NOT_INITIALIZED);
 	ct->state = XE_GUC_CT_STATE_DISABLED;
-	return 0;
+
+	return devm_add_action_or_reset(xe->drm.dev, guc_action_disable_ct, ct);
+}
+
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
 }
 
 #define desc_read(xe_, guc_ctb__, field_)			\
diff --git a/drivers/gpu/drm/xe/xe_guc_ct.h b/drivers/gpu/drm/xe/xe_guc_ct.h
index c7ac9407b861e..398e3adf49c73 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.h
+++ b/drivers/gpu/drm/xe/xe_guc_ct.h
@@ -11,6 +11,7 @@
 struct drm_printer;
 
 int xe_guc_ct_init(struct xe_guc_ct *ct);
+int xe_guc_ct_init_post_hwconfig(struct xe_guc_ct *ct);
 int xe_guc_ct_enable(struct xe_guc_ct *ct);
 void xe_guc_ct_disable(struct xe_guc_ct *ct);
 void xe_guc_ct_stop(struct xe_guc_ct *ct);
-- 
2.53.0



