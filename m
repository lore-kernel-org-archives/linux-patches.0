Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2E151D50F;
	Wed, 30 Sep 2026 18:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792790; cv=none; b=tB1BjCT4WPLKNTv23F3jkE2tJQAYvht4FMejjaZ6tlynqTpvQrYO/LcUHgClGfj/kkWUGoUthy5JM5mAXGFgs1bYrCSNVl9zgx1LSWUB2uAME2sIpafiK0fLQoQqSCyIsCcPH/wr44TwEFPzh5KrZQ89E5FSKHbnMCMHbfhGRFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792790; c=relaxed/simple;
	bh=wj3ROfw4fSqPT+fS7uJAFgGUT5aJRCFpPPEGha6whvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoPXXKedDfzJDlv6BVggVP/IIy+tmhnnAFwL2eRrh9BREkUx/jUDajPcIIXA+i0+sMs3d708j9OgKwA4WSKyDPUnKl/Di17pry+eB6YdFakQ78XH3e8q0zNpTRZ1SymkIkibM6lvOQrLUus2qkNBGq14eHpviOWXTKHla++VVSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eY/hUE5M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eY/hUE5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACECA1F000FF;
	Wed, 30 Sep 2026 18:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792789;
	bh=Gg8Fb7NuPKUNlkPUpXLHTxgF3H7jJN3xqOx4sAK4VQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eY/hUE5MGybqVQCsttXDpSuqcK2Vxznu1WnpsU9rRTYPlZiGUxit094OCk4v7ZVYp
	 XmJPxHJrTVwqOZmEZHkc/k/rLbB323M2GpzqC97wfAeClGKu3cl7hM33C0nU6XSa1c
	 JxkYSANxhvnxE32ZTGDCLaerTMFjeTIpqYLTvaeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/395] drm/amd/display: Atomize IRQ register read/modify/write ops
Date: Wed, 30 Sep 2026 17:24:25 +0200
Message-ID: <20260930152340.674600339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Li <sunpeng.li@amd.com>

[ Upstream commit 63e19ef3ddab806c472748c825f4dc88dcd994e8 ]

[Why]

The OTG_GLOBAL_SYNC_STATUS register controls various HW IRQ sources for
the output timing generator (OTG). VUPDATE_NO_LOCK is one of them.

To enable the IRQ, driver sets the VUPDATE_NO_LOCK_EN bit in the
GLOBAL_SYNC_STATUS register.

To ack the IRQ after it fires, the driver sets the VUPDATE_NO_LOCK_CLEAR
bit in the same GLOBAL_SYNC_STATUS register.

The bit sets are done through read/modify/write operations, which are
not atomic. Thus, the following race is possible:

    Thread A:                       IRQ handler:
                                    *HW IRQ fires*
    # IRQ disable
    val = read(GLOBAL_SYNC_STATUS)
    unset(val, VUPDATE_NO_LOCK_EN)
    write(val, GLOBAL_SYNC_STATUS)
                                    # ACK reads VUPDATE_NO_LOCK_EN unset
                                    val1 = read(GLOBAL_SYNC_STATUS)
                                    set(val1, VUPDATE_NO_LOCK_CLEAR)
    # IRQ enable
    val = read(GLOBAL_SYNC_STATUS)
    set(val, VUPDATE_NO_LOCK_EN)
    write(val, GLOBAL_SYNC_STATUS)
                                    # BAD! clears VUPDATE_NO_LOCK_EN
                                    write(val1, GLOBAL_SYNC_STATUS)

Regarding the tagged Fixes: change, it appears the change made this race
more likely to occur. Since VUPDATE_NO_LOCK is now the sole IRQ source
for vblank handling, a single race on high refresh panels can lead to a
time out.

[How]

The GLOBAL_SYNC_STATUS register is only one example, other IRQ control
registers also share the same scheme. On top of GLOBAL_SYNC_STATUS,
let's clean up those as well.

To keep things simple, Let's atomize the IRQ rmw ops via a single
driver-wide spinlock. Due to the small scope of this lock, it is
unlikely to cause noticeable overhead on top of all the existing locking
within the IRQ set/handle paths.

Since DM is responsible for locking, wrap dc_interrupt_set/ack with the
spinlock in the new amdgpu_dm_irq_set/ack functions. Migrate/drop all
references in DM to dc_interrupt_set/ack to use amdgpu_dm_irq_set/ack
instead.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5616
Fixes: c87e6635d2db ("drm/amd/display: consolidate DCN vblank/flip handling onto vupdate_no_lock")
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 70de0a0216583a53c946155f8c8adedfdca6b4e7)
Cc: stable@vger.kernel.org
(cherry picked from commit 63e19ef3ddab806c472748c825f4dc88dcd994e8)
Modified for unit tests not present in 7.2.y
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  4 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h | 12 ++++
 .../amd/display/amdgpu_dm/amdgpu_dm_crtc.c    |  3 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c |  3 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c | 62 +++++++++++--------
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_irq.h | 28 +++++++++
 6 files changed, 82 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 89686abcaf92d..a9b9d7d911f25 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3100,7 +3100,7 @@ static void dm_gpureset_toggle_interrupts(struct amdgpu_device *adev,
 		if (acrtc && state->stream_status[i].plane_count != 0 &&
 		    amdgpu_ip_version(adev, DCE_HWIP, 0) == 0) {
 			irq_source = IRQ_TYPE_PFLIP + acrtc->otg_inst;
-			rc = dc_interrupt_set(adev->dm.dc, irq_source, enable) ? 0 : -EBUSY;
+			rc = amdgpu_dm_irq_set(adev, irq_source, enable) ? 0 : -EBUSY;
 			if (rc)
 				drm_warn(adev_to_drm(adev), "Failed to %s pflip interrupts\n",
 					 enable ? "enable" : "disable");
@@ -3124,7 +3124,7 @@ static void dm_gpureset_toggle_interrupts(struct amdgpu_device *adev,
 			/* During gpu-reset we disable and then enable vblank irq, so
 			 * don't use amdgpu_irq_get/put() to avoid refcount change.
 			 */
-			if (!dc_interrupt_set(adev->dm.dc, irq_source, enable))
+			if (!amdgpu_dm_irq_set(adev, irq_source, enable))
 				drm_warn(adev_to_drm(adev), "Failed to %sable vblank interrupt\n", enable ? "en" : "dis");
 
 		} else if (acrtc && state->stream_status[i].plane_count != 0) {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index caf6f7387a20a..a83fdd7b644ab 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -527,6 +527,18 @@ struct amdgpu_display_manager {
 	struct common_irq_params
 	vupdate_params[DC_IRQ_SOURCE_VUPDATE6 - DC_IRQ_SOURCE_VUPDATE1 + 1];
 
+	/**
+	 * @irq_reg_lock:
+	 *
+	 * Serializes the read-modify-writes of the HW interrupt control
+	 * registers. Several interrupt sources share one register - e.g. the
+	 * enable and clear bits of both VSTARTUP (vblank) and VUPDATE_NO_LOCK
+	 * live in OTG_GLOBAL_SYNC_STATUS. Therefore, enabling one source must
+	 * not race with acking another. Held only across amdgpu_dm_irq_set()
+	 * and amdgpu_dm_irq_ack().
+	 */
+	spinlock_t irq_reg_lock;
+
 	/**
 	 * @dmub_trace_params:
 	 *
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 7880683031524..9082b862e7aa9 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -31,6 +31,7 @@
 #include "amdgpu_dm_psr.h"
 #include "amdgpu_dm_replay.h"
 #include "amdgpu_dm_crtc.h"
+#include "amdgpu_dm_irq.h"
 #include "amdgpu_dm_plane.h"
 #include "amdgpu_dm_trace.h"
 #include "amdgpu_dm_debugfs.h"
@@ -86,7 +87,7 @@ int amdgpu_dm_crtc_set_vupdate_irq(struct drm_crtc *crtc, bool enable)
 
 	irq_source = IRQ_TYPE_VUPDATE + acrtc->otg_inst;
 
-	rc = dc_interrupt_set(adev->dm.dc, irq_source, enable) ? 0 : -EBUSY;
+	rc = amdgpu_dm_irq_set(adev, irq_source, enable) ? 0 : -EBUSY;
 
 	DRM_DEBUG_VBL("crtc %d - vupdate irq %sabling: r=%d\n",
 		      acrtc->crtc_id, enable ? "en" : "dis", rc);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index ddda474d58788..7633af2429198 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -1189,12 +1189,13 @@ void dm_helpers_free_gpu_mem(
 
 bool dm_helpers_dmub_outbox_interrupt_control(struct dc_context *ctx, bool enable)
 {
+	struct amdgpu_device *adev = ctx->driver_context;
 	enum dc_irq_source irq_source;
 	bool ret;
 
 	irq_source = DC_IRQ_SOURCE_DMCUB_OUTBOX;
 
-	ret = dc_interrupt_set(ctx->dc, irq_source, enable);
+	ret = amdgpu_dm_irq_set(adev, irq_source, enable);
 
 	DRM_DEBUG_DRIVER("Dmub trace irq %sabling: r=%d\n",
 			 enable ? "en" : "dis", ret);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
index a1c722112c224..59c7efc60c901 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c
@@ -424,6 +424,7 @@ int amdgpu_dm_irq_init(struct amdgpu_device *adev)
 	DRM_DEBUG_KMS("DM_IRQ\n");
 
 	spin_lock_init(&adev->dm.irq_handler_list_table_lock);
+	spin_lock_init(&adev->dm.irq_reg_lock);
 
 	for (src = 0; src < DAL_IRQ_SOURCES_NUMBER; src++) {
 		/* low context handler list init */
@@ -495,7 +496,7 @@ void amdgpu_dm_irq_suspend(struct amdgpu_device *adev)
 		hnd_list_l = &adev->dm.irq_handler_list_low_tab[src];
 		hnd_list_h = &adev->dm.irq_handler_list_high_tab[src];
 		if (!list_empty(hnd_list_l) || !list_empty(hnd_list_h))
-			dc_interrupt_set(adev->dm.dc, src, false);
+			amdgpu_dm_irq_set(adev, src, false);
 
 		DM_IRQ_TABLE_UNLOCK(adev, irq_table_flags);
 
@@ -529,7 +530,7 @@ void amdgpu_dm_irq_resume_early(struct amdgpu_device *adev)
 		hnd_list_l = &adev->dm.irq_handler_list_low_tab[src];
 		hnd_list_h = &adev->dm.irq_handler_list_high_tab[src];
 		if (!list_empty(hnd_list_l) || !list_empty(hnd_list_h))
-			dc_interrupt_set(adev->dm.dc, src, true);
+			amdgpu_dm_irq_set(adev, src, true);
 	}
 
 	DM_IRQ_TABLE_UNLOCK(adev, irq_table_flags);
@@ -553,7 +554,7 @@ void amdgpu_dm_irq_resume_late(struct amdgpu_device *adev)
 		hnd_list_l = &adev->dm.irq_handler_list_low_tab[src];
 		hnd_list_h = &adev->dm.irq_handler_list_high_tab[src];
 		if (!list_empty(hnd_list_l) || !list_empty(hnd_list_h))
-			dc_interrupt_set(adev->dm.dc, src, true);
+			amdgpu_dm_irq_set(adev, src, true);
 	}
 
 	DM_IRQ_TABLE_UNLOCK(adev, irq_table_flags);
@@ -637,6 +638,21 @@ static void amdgpu_dm_irq_immediate_work(struct amdgpu_device *adev,
 	DM_IRQ_TABLE_UNLOCK(adev, irq_table_flags);
 }
 
+bool amdgpu_dm_irq_set(struct amdgpu_device *adev, enum dc_irq_source src,
+		       bool enable)
+{
+	guard(spinlock_irqsave)(&adev->dm.irq_reg_lock);
+
+	return dc_interrupt_set(adev->dm.dc, src, enable);
+}
+
+void amdgpu_dm_irq_ack(struct amdgpu_device *adev, enum dc_irq_source src)
+{
+	guard(spinlock_irqsave)(&adev->dm.irq_reg_lock);
+
+	dc_interrupt_ack(adev->dm.dc, src);
+}
+
 /**
  * amdgpu_dm_irq_handler - Generic DM IRQ handler
  * @adev: amdgpu base driver device containing the DM device
@@ -657,7 +673,7 @@ static int amdgpu_dm_irq_handler(struct amdgpu_device *adev,
 			entry->src_id,
 			entry->src_data[0]);
 
-	dc_interrupt_ack(adev->dm.dc, src);
+	amdgpu_dm_irq_ack(adev, src);
 
 	/* Call high irq work immediately */
 	amdgpu_dm_irq_immediate_work(adev, src);
@@ -695,7 +711,7 @@ static int amdgpu_dm_set_hpd_irq_state(struct amdgpu_device *adev,
 	enum dc_irq_source src = amdgpu_dm_hpd_to_dal_irq_source(type);
 	bool st = (state == AMDGPU_IRQ_STATE_ENABLE);
 
-	dc_interrupt_set(adev->dm.dc, src, st);
+	amdgpu_dm_irq_set(adev, src, st);
 	return 0;
 }
 
@@ -729,7 +745,7 @@ static inline int dm_irq_state(struct amdgpu_device *adev,
 	if (dc && dc->caps.ips_support && dc->idle_optimizations_allowed)
 		dc_allow_idle_optimizations(dc, false);
 
-	dc_interrupt_set(adev->dm.dc, irq_source, st);
+	amdgpu_dm_irq_set(adev, irq_source, st);
 	return 0;
 }
 
@@ -783,7 +799,7 @@ static int amdgpu_dm_set_dmub_outbox_irq_state(struct amdgpu_device *adev,
 	enum dc_irq_source irq_source = DC_IRQ_SOURCE_DMCUB_OUTBOX;
 	bool st = (state == AMDGPU_IRQ_STATE_ENABLE);
 
-	dc_interrupt_set(adev->dm.dc, irq_source, st);
+	amdgpu_dm_irq_set(adev, irq_source, st);
 	return 0;
 }
 
@@ -809,7 +825,7 @@ static int amdgpu_dm_set_dmub_trace_irq_state(struct amdgpu_device *adev,
 	enum dc_irq_source irq_source = DC_IRQ_SOURCE_DMCUB_OUTBOX0;
 	bool st = (state == AMDGPU_IRQ_STATE_ENABLE);
 
-	dc_interrupt_set(adev->dm.dc, irq_source, st);
+	amdgpu_dm_irq_set(adev, irq_source, st);
 	return 0;
 }
 
@@ -873,9 +889,7 @@ void amdgpu_dm_set_irq_funcs(struct amdgpu_device *adev)
 }
 void amdgpu_dm_outbox_init(struct amdgpu_device *adev)
 {
-	dc_interrupt_set(adev->dm.dc,
-		DC_IRQ_SOURCE_DMCUB_OUTBOX,
-		true);
+	amdgpu_dm_irq_set(adev, DC_IRQ_SOURCE_DMCUB_OUTBOX, true);
 }
 
 /**
@@ -896,7 +910,7 @@ void amdgpu_dm_hpd_init(struct amdgpu_device *adev)
 
 	/* First, clear all hpd and hpdrx interrupts */
 	for (i = DC_IRQ_SOURCE_HPD1; i <= DC_IRQ_SOURCE_HPD6RX; i++) {
-		if (!dc_interrupt_set(adev->dm.dc, i, false))
+		if (!amdgpu_dm_irq_set(adev, i, false))
 			drm_err(dev, "Failed to clear hpd(rx) source=%d on init\n",
 				i);
 	}
@@ -918,7 +932,7 @@ void amdgpu_dm_hpd_init(struct amdgpu_device *adev)
 		 * of dm. Note that only hpd interrupt types are registered with
 		 * base driver; hpd_rx types aren't. IOW, amdgpu_irq_get/put on
 		 * hpd_rx isn't available. DM currently controls hpd_rx
-		 * explicitly with dc_interrupt_set()
+		 * explicitly with amdgpu_dm_irq_set()
 		 */
 		if (dc_link->irq_source_hpd != DC_IRQ_SOURCE_INVALID) {
 			irq_type = dc_link->irq_source_hpd - DC_IRQ_SOURCE_HPD1;
@@ -927,23 +941,21 @@ void amdgpu_dm_hpd_init(struct amdgpu_device *adev)
 			 * and what bios reports as the # of connectors with hpd
 			 * sources. Since the # of hpd source types registered
 			 * with base driver == mode_info.num_hpd, we have to
-			 * fallback to dc_interrupt_set for the remaining types.
+			 * fallback to amdgpu_dm_irq_set for the remaining types.
 			 */
 			if (irq_type < adev->mode_info.num_hpd) {
 				if (amdgpu_irq_get(adev, &adev->hpd_irq, irq_type))
 					drm_err(dev, "DM_IRQ: Failed get HPD for source=%d)!\n",
 						dc_link->irq_source_hpd);
 			} else {
-				dc_interrupt_set(adev->dm.dc,
-						 dc_link->irq_source_hpd,
-						 true);
+				amdgpu_dm_irq_set(adev, dc_link->irq_source_hpd,
+						  true);
 			}
 		}
 
 		if (dc_link->irq_source_hpd_rx != DC_IRQ_SOURCE_INVALID) {
-			dc_interrupt_set(adev->dm.dc,
-					dc_link->irq_source_hpd_rx,
-					true);
+			amdgpu_dm_irq_set(adev, dc_link->irq_source_hpd_rx,
+					  true);
 		}
 	}
 	drm_connector_list_iter_end(&iter);
@@ -984,16 +996,14 @@ void amdgpu_dm_hpd_fini(struct amdgpu_device *adev)
 					drm_err(dev, "DM_IRQ: Failed put HPD for source=%d!\n",
 						dc_link->irq_source_hpd);
 			} else {
-				dc_interrupt_set(adev->dm.dc,
-						 dc_link->irq_source_hpd,
-						 false);
+				amdgpu_dm_irq_set(adev, dc_link->irq_source_hpd,
+						  false);
 			}
 		}
 
 		if (dc_link->irq_source_hpd_rx != DC_IRQ_SOURCE_INVALID) {
-			dc_interrupt_set(adev->dm.dc,
-					dc_link->irq_source_hpd_rx,
-					false);
+			amdgpu_dm_irq_set(adev, dc_link->irq_source_hpd_rx,
+					  false);
 		}
 	}
 	drm_connector_list_iter_end(&iter);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.h
index 4f6b58f4f90d7..f0a4577848f35 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.h
@@ -81,6 +81,34 @@ void amdgpu_dm_irq_unregister_interrupt(struct amdgpu_device *adev,
 					enum dc_irq_source irq_source,
 					void *ih_index);
 
+/**
+ * amdgpu_dm_irq_set - enable or disable a DC interrupt source.
+ *
+ * @adev: AMD DRM device
+ * @src: DC interrupt source to toggle
+ * @enable: true to enable the source, false to disable it
+ *
+ * DM-wide replacement for dc_interrupt_set(). As locking is DM's
+ * responsibility, this is a thin wrapper serializes the underlying
+ * read-modify-write against the other interrupt sources sharing HW control
+ * registers with @src, so DM must never call dc_interrupt_set() directly.
+ *
+ * Returns: true if the source was toggled.
+ */
+bool amdgpu_dm_irq_set(struct amdgpu_device *adev, enum dc_irq_source src,
+		       bool enable);
+
+/**
+ * amdgpu_dm_irq_ack - acknowledge a DC interrupt source.
+ *
+ * @adev: AMD DRM device
+ * @src: DC interrupt source to acknowledge
+ *
+ * DM-wide replacement for dc_interrupt_ack(), serialized the same way as
+ * amdgpu_dm_irq_set().
+ */
+void amdgpu_dm_irq_ack(struct amdgpu_device *adev, enum dc_irq_source src);
+
 void amdgpu_dm_set_irq_funcs(struct amdgpu_device *adev);
 
 void amdgpu_dm_outbox_init(struct amdgpu_device *adev);
-- 
2.53.0



