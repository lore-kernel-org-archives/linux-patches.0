Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B5A33DEF9;
	Fri,  7 Aug 2026 14:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114474; cv=none; b=s9hAuk4nk0a1+8pmbrHIxAjXlkSeNqkS+dNJCpXsG9ZmuQBMwSNbUSDI0TtoOIWRKAhgMv09PvaLkGrka2Eme2pLJJwEo4In52uhJC8rXdMVmmoNWfxZMe+aLDTq7SNp/MCIHhHFYru5VEpwiwOfl3hwgBDJesRYVJaV/c8DP/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114474; c=relaxed/simple;
	bh=3+M2US+hrY6BIYZIPYc4uvm6vLAQYVYxGObihIiL2+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAniWsfhfFA0jLtF4M93qFYYiv8zqU2v9wqXNznBFk4k4t8BQSCBW9AZUFFj1IO4py6XHVZMDOqMRMIA5zthGdrHn4NmN3S7gPMaK3JXRxBlo+EMUeK0Uqw19bpFmKg9AeDkQ/1mq1rUv7uRK2VNZ1hKLobh9P+MuuP8WTZLAn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqH2Tp9S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqH2Tp9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128581F00A3A;
	Fri,  7 Aug 2026 14:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114467;
	bh=uAN41R8gcLtAeHWbAaCk3szfsJRbittz2a2p/tXv+00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqH2Tp9S5lyezIRRPzWNfd9F9JmT9UUdQ0R3Hg5wuZiQC3ab3hVCYc8nnAxUJmkql
	 +OIhEI3Yuc1pKA3YkwmuCGB0AFNajAnqLUtzu8+d07anuCvDX8rWojnde/sfFohKpD
	 R1CVDi62xI1N5vvqVGX+YiBsH3bEruAxuRJg4qv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 275/337] drm/xe: Apply whitelist to engine save-restore
Date: Fri,  7 Aug 2026 16:37:58 +0200
Message-ID: <20260807143424.498564739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 3fcf68d7393fd622b96cd45124ccb1eddf77684c ]

Changes in xe_guc_ads.c in the above commit are not needed for linux-6.12.y.

Instead of handling the whitelist directly in the GuC ADS
initialization, make it follow the same logic as other engine registers
that are save-restored. Main benefit is that then the SW tracking then
shows it in debugfs and there's no risk of an engine workaround to write
to the same nopriv register that is being passed directly to GuC.

This means that xe_reg_whitelist_process_engine() only has to process
the RTP and convert them to entries for the hwe.  With that all the
registers should be covered by xe_reg_sr_apply_mmio() to write to the HW
and there's no special handling in GuC ADS to also add these registers
to the list of registers that is passed to GuC.

Example for DG2:

	# cat  /sys/kernel/debug/dri/0000\:03\:00.0/gt0/register-save-restore
	...
	Engine
	rcs0
		...
		REG[0x24d0] clr=0xffffffff set=0x1000dafc masked=no mcr=no
		REG[0x24d4] clr=0xffffffff set=0x1000db01 masked=no mcr=no
		REG[0x24d8] clr=0xffffffff set=0x0000db1c masked=no mcr=no
	...
	Whitelist
	rcs0
		REG[0xdafc-0xdaff]: allow read access
		REG[0xdb00-0xdb1f]: allow read access
		REG[0xdb1c-0xdb1f]: allow rw access

v2:
  - Use ~0u for clr bits so it's just a write (Matt Roper)
  - Simplify helpers now that unused slots are not written

Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241209232739.147417-6-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt.c            |  4 +-
 drivers/gpu/drm/xe/xe_hw_engine.c     |  1 -
 drivers/gpu/drm/xe/xe_reg_sr.c        | 53 ---------------------------
 drivers/gpu/drm/xe/xe_reg_whitelist.c | 37 +++++++++++++++++++
 4 files changed, 38 insertions(+), 57 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index 292947e44a8a8..e2ac1589dfbf6 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -722,10 +722,8 @@ static int do_gt_restart(struct xe_gt *gt)
 
 	xe_mocs_init(gt);
 
-	for_each_hw_engine(hwe, gt, id) {
+	for_each_hw_engine(hwe, gt, id)
 		xe_reg_sr_apply_mmio(&hwe->reg_sr, gt);
-		xe_reg_sr_apply_whitelist(hwe);
-	}
 
 	/* Get CCS mode in sync between sw/hw */
 	xe_gt_apply_ccs_mode(gt);
diff --git a/drivers/gpu/drm/xe/xe_hw_engine.c b/drivers/gpu/drm/xe/xe_hw_engine.c
index 45d0ae074e652..ca4c2dee276bc 100644
--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -546,7 +546,6 @@ static int hw_engine_init(struct xe_gt *gt, struct xe_hw_engine *hwe,
 	xe_gt_assert(gt, gt->info.engine_mask & BIT(id));
 
 	xe_reg_sr_apply_mmio(&hwe->reg_sr, gt);
-	xe_reg_sr_apply_whitelist(hwe);
 
 	hwe->hwsp = xe_managed_bo_create_pin_map(xe, tile, SZ_4K,
 						 XE_BO_FLAG_VRAM_IF_DGFX(tile) |
diff --git a/drivers/gpu/drm/xe/xe_reg_sr.c b/drivers/gpu/drm/xe/xe_reg_sr.c
index ae9e6df2f4e12..01ee54d53531b 100644
--- a/drivers/gpu/drm/xe/xe_reg_sr.c
+++ b/drivers/gpu/drm/xe/xe_reg_sr.c
@@ -24,7 +24,6 @@
 #include "xe_hw_engine_types.h"
 #include "xe_macros.h"
 #include "xe_mmio.h"
-#include "xe_reg_whitelist.h"
 #include "xe_rtp_types.h"
 
 static void reg_sr_fini(struct drm_device *drm, void *arg)
@@ -194,58 +193,6 @@ void xe_reg_sr_apply_mmio(struct xe_reg_sr *sr, struct xe_gt *gt)
 	xe_gt_err(gt, "Failed to apply, err=%d\n", err);
 }
 
-void xe_reg_sr_apply_whitelist(struct xe_hw_engine *hwe)
-{
-	struct xe_reg_sr *sr = &hwe->reg_whitelist;
-	struct xe_gt *gt = hwe->gt;
-	struct xe_device *xe = gt_to_xe(gt);
-	struct xe_reg_sr_entry *entry;
-	struct drm_printer p;
-	u32 mmio_base = hwe->mmio_base;
-	unsigned long reg;
-	unsigned int slot = 0;
-	int err;
-
-	if (xa_empty(&sr->xa))
-		return;
-
-	drm_dbg(&xe->drm, "Whitelisting %s registers\n", sr->name);
-
-	err = xe_force_wake_get(gt_to_fw(gt), XE_FORCEWAKE_ALL);
-	if (err)
-		goto err_force_wake;
-
-	p = drm_dbg_printer(&xe->drm, DRM_UT_DRIVER, NULL);
-	xa_for_each(&sr->xa, reg, entry) {
-		if (slot == RING_MAX_NONPRIV_SLOTS) {
-			xe_gt_err(gt,
-				  "hwe %s: maximum register whitelist slots (%d) reached, refusing to add more\n",
-				  hwe->name, RING_MAX_NONPRIV_SLOTS);
-			break;
-		}
-
-		xe_reg_whitelist_print_entry(&p, 0, reg, entry);
-		xe_mmio_write32(gt, RING_FORCE_TO_NONPRIV(mmio_base, slot),
-				reg | entry->set_bits);
-		slot++;
-	}
-
-	/* And clear the rest just in case of garbage */
-	for (; slot < RING_MAX_NONPRIV_SLOTS; slot++) {
-		u32 addr = RING_NOPID(mmio_base).addr;
-
-		xe_mmio_write32(gt, RING_FORCE_TO_NONPRIV(mmio_base, slot), addr);
-	}
-
-	err = xe_force_wake_put(gt_to_fw(gt), XE_FORCEWAKE_ALL);
-	XE_WARN_ON(err);
-
-	return;
-
-err_force_wake:
-	drm_err(&xe->drm, "Failed to apply, err=%d\n", err);
-}
-
 /**
  * xe_reg_sr_dump - print all save/restore entries
  * @sr: Save/restore entries
diff --git a/drivers/gpu/drm/xe/xe_reg_whitelist.c b/drivers/gpu/drm/xe/xe_reg_whitelist.c
index d88261921ae46..ef1bb1b47af09 100644
--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -10,7 +10,9 @@
 #include "regs/xe_oa_regs.h"
 #include "regs/xe_regs.h"
 #include "xe_gt_types.h"
+#include "xe_gt_printk.h"
 #include "xe_platform_types.h"
+#include "xe_reg_sr.h"
 #include "xe_rtp.h"
 #include "xe_step.h"
 
@@ -86,6 +88,40 @@ static const struct xe_rtp_entry_sr register_whitelist[] = {
 	{}
 };
 
+static void whitelist_apply_to_hwe(struct xe_hw_engine *hwe)
+{
+	struct xe_reg_sr *sr = &hwe->reg_whitelist;
+	struct xe_reg_sr_entry *entry;
+	struct drm_printer p;
+	unsigned long reg;
+	unsigned int slot;
+
+	xe_gt_dbg(hwe->gt, "Add %s whitelist to engine\n", sr->name);
+	p = xe_gt_dbg_printer(hwe->gt);
+
+	slot = 0;
+	xa_for_each(&sr->xa, reg, entry) {
+		struct xe_reg_sr_entry hwe_entry = {
+			.reg = RING_FORCE_TO_NONPRIV(hwe->mmio_base, slot),
+			.set_bits = entry->reg.addr | entry->set_bits,
+			.clr_bits = ~0u,
+			.read_mask = entry->read_mask,
+		};
+
+		if (slot == RING_MAX_NONPRIV_SLOTS) {
+			xe_gt_err(hwe->gt,
+				  "hwe %s: maximum register whitelist slots (%d) reached, refusing to add more\n",
+				  hwe->name, RING_MAX_NONPRIV_SLOTS);
+			break;
+		}
+
+		xe_reg_whitelist_print_entry(&p, 0, reg, entry);
+		xe_reg_sr_add(&hwe->reg_sr, &hwe_entry, hwe->gt);
+
+		slot++;
+	}
+}
+
 /**
  * xe_reg_whitelist_process_engine - process table of registers to whitelist
  * @hwe: engine instance to process whitelist for
@@ -99,6 +135,7 @@ void xe_reg_whitelist_process_engine(struct xe_hw_engine *hwe)
 	struct xe_rtp_process_ctx ctx = XE_RTP_PROCESS_CTX_INITIALIZER(hwe);
 
 	xe_rtp_process_to_sr(&ctx, register_whitelist, &hwe->reg_whitelist);
+	whitelist_apply_to_hwe(hwe);
 }
 
 /**
-- 
2.53.0



