Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0532472A5;
	Tue, 20 May 2025 14:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750372; cv=none; b=CjtMwsjBDhjNlv5t86ba9SU85si2lzGBw0GowFhdIJNVSJ8tTYssd90ueDzYNkuFYmITXOwa5mgQ6H35gnQYBkcmn6jZNhIchjm/AI0kmd/mGpkn+6dUsmrDu6JQJF1mwoXrp3Fm6Bl/NKQduat29r3r+MSzzRYYlWAo39jItFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750372; c=relaxed/simple;
	bh=/mF2QeXjFb7XujuhQirbwcKnoGIII7R8Zr5GzZ2cO9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6IUCTXlB69NH8UoUvZntpdIMfepDTut4yaqhc4mgDRr+Fq0Uj4txwmDOooCVBPkwSfL7qe+haHfIGdOrQcUjncFFShjLcZ3x8qXJ9uckThv/+qOvfpee4mxLVNfmRUl0JFpFijbc2x/Eqwb4s5DG50c/XNwodgRhE6W+iTaCt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R10ux++y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R10ux++y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB23C4CEE9;
	Tue, 20 May 2025 14:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750372;
	bh=/mF2QeXjFb7XujuhQirbwcKnoGIII7R8Zr5GzZ2cO9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R10ux++yKAnzOo0Qy3eXx9uzTMpyqBltPNHwmDOgnp7RFRShSz1eZOcWs5RChpeeh
	 NSBVByaP3lU8wn1JL6LTPmY0+jHlRlPBrqJTzK3BM5z4LohraPIj2IT2/EEZB5lCyw
	 bJ+y8WMn2EEuQZdkeKecOhna6AYlGpsEuuPTzIvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.12 130/143] drm/xe/gsc: do not flush the GSC worker from the reset path
Date: Tue, 20 May 2025 15:51:25 +0200
Message-ID: <20250520125815.131401459@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

commit 03552d8ac0afcc080c339faa0b726e2c0e9361cb upstream.

The workqueue used for the reset worker is marked as WQ_MEM_RECLAIM,
while the GSC one isn't (and can't be as we need to do memory
allocations in the gsc worker). Therefore, we can't flush the latter
from the former.

The reason why we had such a flush was to avoid interrupting either
the GSC FW load or in progress GSC proxy operations. GSC proxy
operations fall into 2 categories:

1) GSC proxy init: this only happens once immediately after GSC FW load
   and does not support being interrupted. The only way to recover from
   an interruption of the proxy init is to do an FLR and re-load the GSC.

2) GSC proxy request: this can happen in response to a request that
   the driver sends to the GSC. If this is interrupted, the GSC FW will
   timeout and the driver request will be failed, but overall the GSC
   will keep working fine.

Flushing the work allowed us to avoid interruption in both cases (unless
the hang came from the GSC engine itself, in which case we're toast
anyway). However, a failure on a proxy request is tolerable if we're in
a scenario where we're triggering a GT reset (i.e., something is already
gone pretty wrong), so what we really need to avoid is interrupting
the init flow, which we can do by polling on the register that reports
when the proxy init is complete (as that ensure us that all the load and
init operations have been completed).

Note that during suspend we still want to do a flush of the worker to
make sure it completes any operations involving the HW before the power
is cut.

v2: fix spelling in commit msg, rename waiter function (Julia)

Fixes: dd0e89e5edc2 ("drm/xe/gsc: GSC FW load")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4830
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Julia Filipchuk <julia.filipchuk@intel.com>
Link: https://lore.kernel.org/r/20250502155104.2201469-1-daniele.ceraolospurio@intel.com
(cherry picked from commit 12370bfcc4f0bdf70279ec5b570eb298963422b5)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gsc.c       |   22 ++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_gsc.h       |    1 +
 drivers/gpu/drm/xe/xe_gsc_proxy.c |   11 +++++++++++
 drivers/gpu/drm/xe/xe_gsc_proxy.h |    1 +
 drivers/gpu/drm/xe/xe_gt.c        |    2 +-
 drivers/gpu/drm/xe/xe_uc.c        |    8 +++++++-
 drivers/gpu/drm/xe/xe_uc.h        |    1 +
 7 files changed, 44 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_gsc.c
+++ b/drivers/gpu/drm/xe/xe_gsc.c
@@ -564,6 +564,28 @@ void xe_gsc_remove(struct xe_gsc *gsc)
 	xe_gsc_proxy_remove(gsc);
 }
 
+void xe_gsc_stop_prepare(struct xe_gsc *gsc)
+{
+	struct xe_gt *gt = gsc_to_gt(gsc);
+	int ret;
+
+	if (!xe_uc_fw_is_loadable(&gsc->fw) || xe_uc_fw_is_in_error_state(&gsc->fw))
+		return;
+
+	xe_force_wake_assert_held(gt_to_fw(gt), XE_FW_GSC);
+
+	/*
+	 * If the GSC FW load or the proxy init are interrupted, the only way
+	 * to recover it is to do an FLR and reload the GSC from scratch.
+	 * Therefore, let's wait for the init to complete before stopping
+	 * operations. The proxy init is the last step, so we can just wait on
+	 * that
+	 */
+	ret = xe_gsc_wait_for_proxy_init_done(gsc);
+	if (ret)
+		xe_gt_err(gt, "failed to wait for GSC init completion before uc stop\n");
+}
+
 /*
  * wa_14015076503: if the GSC FW is loaded, we need to alert it before doing a
  * GSC engine reset by writing a notification bit in the GS1 register and then
--- a/drivers/gpu/drm/xe/xe_gsc.h
+++ b/drivers/gpu/drm/xe/xe_gsc.h
@@ -16,6 +16,7 @@ struct xe_hw_engine;
 int xe_gsc_init(struct xe_gsc *gsc);
 int xe_gsc_init_post_hwconfig(struct xe_gsc *gsc);
 void xe_gsc_wait_for_worker_completion(struct xe_gsc *gsc);
+void xe_gsc_stop_prepare(struct xe_gsc *gsc);
 void xe_gsc_load_start(struct xe_gsc *gsc);
 void xe_gsc_remove(struct xe_gsc *gsc);
 void xe_gsc_hwe_irq_handler(struct xe_hw_engine *hwe, u16 intr_vec);
--- a/drivers/gpu/drm/xe/xe_gsc_proxy.c
+++ b/drivers/gpu/drm/xe/xe_gsc_proxy.c
@@ -71,6 +71,17 @@ bool xe_gsc_proxy_init_done(struct xe_gs
 	       HECI1_FWSTS1_PROXY_STATE_NORMAL;
 }
 
+int xe_gsc_wait_for_proxy_init_done(struct xe_gsc *gsc)
+{
+	struct xe_gt *gt = gsc_to_gt(gsc);
+
+	/* Proxy init can take up to 500ms, so wait double that for safety */
+	return xe_mmio_wait32(gt, HECI_FWSTS1(MTL_GSC_HECI1_BASE),
+			      HECI1_FWSTS1_CURRENT_STATE,
+			      HECI1_FWSTS1_PROXY_STATE_NORMAL,
+			      USEC_PER_SEC, NULL, false);
+}
+
 static void __gsc_proxy_irq_rmw(struct xe_gsc *gsc, u32 clr, u32 set)
 {
 	struct xe_gt *gt = gsc_to_gt(gsc);
--- a/drivers/gpu/drm/xe/xe_gsc_proxy.h
+++ b/drivers/gpu/drm/xe/xe_gsc_proxy.h
@@ -13,6 +13,7 @@ struct xe_gsc;
 int xe_gsc_proxy_init(struct xe_gsc *gsc);
 bool xe_gsc_proxy_init_done(struct xe_gsc *gsc);
 void xe_gsc_proxy_remove(struct xe_gsc *gsc);
+int xe_gsc_wait_for_proxy_init_done(struct xe_gsc *gsc);
 int xe_gsc_proxy_start(struct xe_gsc *gsc);
 
 int xe_gsc_proxy_request_handler(struct xe_gsc *gsc);
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -828,7 +828,7 @@ void xe_gt_suspend_prepare(struct xe_gt
 {
 	XE_WARN_ON(xe_force_wake_get(gt_to_fw(gt), XE_FORCEWAKE_ALL));
 
-	xe_uc_stop_prepare(&gt->uc);
+	xe_uc_suspend_prepare(&gt->uc);
 
 	XE_WARN_ON(xe_force_wake_put(gt_to_fw(gt), XE_FORCEWAKE_ALL));
 }
--- a/drivers/gpu/drm/xe/xe_uc.c
+++ b/drivers/gpu/drm/xe/xe_uc.c
@@ -241,7 +241,7 @@ void xe_uc_gucrc_disable(struct xe_uc *u
 
 void xe_uc_stop_prepare(struct xe_uc *uc)
 {
-	xe_gsc_wait_for_worker_completion(&uc->gsc);
+	xe_gsc_stop_prepare(&uc->gsc);
 	xe_guc_stop_prepare(&uc->guc);
 }
 
@@ -275,6 +275,12 @@ again:
 		goto again;
 }
 
+void xe_uc_suspend_prepare(struct xe_uc *uc)
+{
+	xe_gsc_wait_for_worker_completion(&uc->gsc);
+	xe_guc_stop_prepare(&uc->guc);
+}
+
 int xe_uc_suspend(struct xe_uc *uc)
 {
 	/* GuC submission not enabled, nothing to do */
--- a/drivers/gpu/drm/xe/xe_uc.h
+++ b/drivers/gpu/drm/xe/xe_uc.h
@@ -18,6 +18,7 @@ int xe_uc_reset_prepare(struct xe_uc *uc
 void xe_uc_stop_prepare(struct xe_uc *uc);
 void xe_uc_stop(struct xe_uc *uc);
 int xe_uc_start(struct xe_uc *uc);
+void xe_uc_suspend_prepare(struct xe_uc *uc);
 int xe_uc_suspend(struct xe_uc *uc);
 int xe_uc_sanitize_reset(struct xe_uc *uc);
 void xe_uc_remove(struct xe_uc *uc);


