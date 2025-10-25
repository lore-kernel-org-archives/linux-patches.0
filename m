Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE511F1306;
	Sat, 25 Oct 2025 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408653; cv=none; b=dZwwUuYsmclwtf2vYWGTl8kY83WUG020zuYALdKBxzjkaF0vcd/DK1+v7fDTTypM78oZTDlVTi70V71ot1gpZgXyZ4lbC4jIX5TMaSQLmpmEw+vtQX+0taGWJupUnWtVm41RZZ8q2fXNF5cRRadZLMegAdb3ZHKrgk0iWnXgzDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408653; c=relaxed/simple;
	bh=QfFlxeFpsaY91DywEFRLeDyWm0f6w0H/jGKFI+/RDNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxvF8LGdGcDBIv2VbXWajrSRz1Ng4AUnuIRxFfBIJHEKGqwYLQwqExAOBk9ITnOah+jbj9rrKgF82h8y7Syk8Dj/NoxPQfka2G+OPO26r/tAdSS46Rcoch9aiZ5hTPh6rsNU9kha6HfyvrTQyWlg6hVR/Xs3scVhAKyXwaOg4wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wh49yfTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wh49yfTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4ACC4CEF5;
	Sat, 25 Oct 2025 16:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408652;
	bh=QfFlxeFpsaY91DywEFRLeDyWm0f6w0H/jGKFI+/RDNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wh49yfTUpVnEQl69PWz3HbVmhKLy2viMYWrDWBtTDL0ih+DpH7uDYaxLsZ3vKNvVt
	 UXN7M94PRNj/urNL7FV7MUXGS4d+RhwTPK6XwzFtQwTzauKHh5SGIkwJvWBIxDNzmS
	 AvyDCw/AnNJ7L/Rt2lnvZwptBtjEmpwJ0G5SuC6M4JxRV2Q09agZXiN2eMOgE3trZT
	 54xzOwVMriSLx3jyJQ4nIs90ig7chuCRLSl29hoXHp00Wu6kfOUG2htEzgxvaoLFy9
	 xbpeFMqflvvKM8MEE07QYMjMuptTdX3wZPUj9aIFvLY1O8VOQmspmBiBLEL6ZLUa6G
	 uLNp9Z25VlLeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	alex.hung@amd.com,
	Wayne.Lin@amd.com,
	chiahsuan.chung@amd.com,
	alexandre.f.demers@gmail.com,
	matthew.schwartz@linux.dev
Subject: [PATCH AUTOSEL 6.17] drm/amd/display: fix dmub access race condition
Date: Sat, 25 Oct 2025 11:54:23 -0400
Message-ID: <20251025160905.3857885-32-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit c210b757b400959577a5a17b783b5959b82baed8 ]

Accessing DC from amdgpu_dm is usually preceded by acquisition of
dc_lock mutex. Most of the DC API that DM calls are under a DC lock.
However, there are a few that are not. Some DC API called from interrupt
context end up sending DMUB commands via a DC API, while other threads were
using DMUB. This was apparent from a race between calls for setting idle
optimization enable/disable and the DC API to set vmin/vmax.

Offload the call to dc_stream_adjust_vmin_vmax() to a thread instead
of directly calling them from the interrupt handler such that it waits
for dc_lock.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Addresses a real race where DCN/DM code issues DMUB commands from
    IRQ context without the normal `dc_lock`, while other threads
    concurrently use DMUB. The commit message cites a concrete race
    between idle optimization enable/disable and vmin/vmax updates. This
    is user-visible (VRR/BTR timing adjustments) and can cause
    instability or incorrect behavior.

- Where the race is today
  - `dc_stream_adjust_vmin_vmax()` is invoked directly from high IRQ
    handlers without taking `dc_lock`:
    - `drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:593` inside
      `dm_vupdate_high_irq()` (pre-AI BTR path) calls
      `dc_stream_adjust_vmin_vmax(...)` while holding `event_lock`.
    - `drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:686` inside
      `dm_crtc_high_irq()` (AI and newer path) does the same.
  - Many other DC/DM paths guard DMUB access with `adev->dm.dc_lock`, so
    these IRQ paths are outliers that can race.

- What the patch changes
  - Adds a small offload mechanism to move the vmin/vmax update out of
    IRQ context and under `dc_lock`:
    - New work handler: `dm_handle_vmin_vmax_update()` acquires
      `adev->dm.dc_lock`, calls `dc_stream_adjust_vmin_vmax(adev->dm.dc,
      stream, adjust)`, then releases the lock and cleans up.
    - New helper: `schedule_dc_vmin_vmax(adev, stream, adjust)` retains
      the stream, copies the adjust struct, initializes a work item, and
      `queue_work(system_wq, ...)`.
    - Adds `struct vupdate_offload_work` in
      `drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h` to carry
      `adev`, `stream`, and `adjust` through the workqueue.
  - Replaces the direct IRQ-time calls to `dc_stream_adjust_vmin_vmax()`
    with `schedule_dc_vmin_vmax(...)` in both IRQ paths:
    - `dm_vupdate_high_irq()` patch hunk replaces the direct call (was
      at `drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:593`) with
      `schedule_dc_vmin_vmax(...)`.
    - `dm_crtc_high_irq()` patch hunk replaces the direct call (was at
      `drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:686`) with
      `schedule_dc_vmin_vmax(...)`.

- Why this is a good stable candidate
  - Important bug fix: Prevents concurrent DMUB accesses, which are
    known to cause issues in VRR/BTR updates and idle optimizations.
  - Small and contained: Only touches AMD display (`amdgpu_dm.c`,
    `amdgpu_dm.h`), adds a ~localized work item and defers a single API
    call.
  - Matches established patterns: DM frequently defers DMUB operations
    when it may need `dc_lock` (e.g., ROI/CRC path defers work and
    explicitly notes it may need to wait for `dc_lock`, see
    `drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c:867` and
    related schedule_work usage).
  - No uAPI or architectural changes: Purely internal
    synchronization/dispatch change to align with DC/DM locking rules.
  - Reviewed and tested: Has Reviewed-by/Tested-by/Signed-off-by from
    AMD maintainers, increasing confidence.

- Risk and considerations
  - Timing sensitivity: Moving `dc_stream_adjust_vmin_vmax()` out of the
    IRQ to a worker may slightly delay DRR/VRR timing updates. AMD
    already uses deferred work for DMUB operations elsewhere and the
    patch protects the call with `dc_lock`, so the tradeoff is
    correctness over micro-timing. This should be safe and consistent
    with the rest of DC/DM locking.
  - Allocation in IRQ context: The provided diff shows
    `schedule_dc_vmin_vmax()` uses `kzalloc(..., GFP_KERNEL)` while it
    is invoked from high IRQ context and while holding `event_lock`. In
    IRQ context, `GFP_KERNEL` can sleep and is not permitted; at minimum
    `GFP_ATOMIC` is required, or the allocation should be moved out of
    the locked IRQ region. Stable backport should include any follow-up
    fixing the GFP flags or move the call site outside the spinlock. The
    design (deferral + `dc_lock`) is right, but the allocation flags
    must be IRQ-safe.
  - Stream lifetime: The patch correctly uses `dc_stream_retain()` in
    the IRQ path and `dc_stream_release()` in the worker, preventing
    use-after-free.

- Stable tree fit
  - Fixes a real race affecting users (VRR/FreeSync/BTR correctness).
  - Minimal, localized change to the AMD display driver; no API or broad
    subsystem changes.
  - Aligns with stable rules for important bugfixes with low regression
    risk.
  - Recommendation: Backport together with (or adjusted to include) IRQ-
    safe memory allocation (e.g., use `GFP_ATOMIC` for the offload work
    and adjust-copy allocations, or allocate outside the IRQ spinlock)
    to avoid introducing a new IRQ-sleep regression.

In sum, this is a targeted concurrency fix for DMUB access and a strong
candidate for stable, with the caveat to ensure IRQ-safe allocations in
the offload path when backporting.

 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 55 +++++++++++++++++--
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h | 14 +++++
 2 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 163780030eb16..aca57cc815514 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -541,6 +541,50 @@ static void dm_pflip_high_irq(void *interrupt_params)
 		      amdgpu_crtc->crtc_id, amdgpu_crtc, vrr_active, (int)!e);
 }
 
+static void dm_handle_vmin_vmax_update(struct work_struct *offload_work)
+{
+	struct vupdate_offload_work *work = container_of(offload_work, struct vupdate_offload_work, work);
+	struct amdgpu_device *adev = work->adev;
+	struct dc_stream_state *stream = work->stream;
+	struct dc_crtc_timing_adjust *adjust = work->adjust;
+
+	mutex_lock(&adev->dm.dc_lock);
+	dc_stream_adjust_vmin_vmax(adev->dm.dc, stream, adjust);
+	mutex_unlock(&adev->dm.dc_lock);
+
+	dc_stream_release(stream);
+	kfree(work->adjust);
+	kfree(work);
+}
+
+static void schedule_dc_vmin_vmax(struct amdgpu_device *adev,
+	struct dc_stream_state *stream,
+	struct dc_crtc_timing_adjust *adjust)
+{
+	struct vupdate_offload_work *offload_work = kzalloc(sizeof(*offload_work), GFP_KERNEL);
+	if (!offload_work) {
+		drm_dbg_driver(adev_to_drm(adev), "Failed to allocate vupdate_offload_work\n");
+		return;
+	}
+
+	struct dc_crtc_timing_adjust *adjust_copy = kzalloc(sizeof(*adjust_copy), GFP_KERNEL);
+	if (!adjust_copy) {
+		drm_dbg_driver(adev_to_drm(adev), "Failed to allocate adjust_copy\n");
+		kfree(offload_work);
+		return;
+	}
+
+	dc_stream_retain(stream);
+	memcpy(adjust_copy, adjust, sizeof(*adjust_copy));
+
+	INIT_WORK(&offload_work->work, dm_handle_vmin_vmax_update);
+	offload_work->adev = adev;
+	offload_work->stream = stream;
+	offload_work->adjust = adjust_copy;
+
+	queue_work(system_wq, &offload_work->work);
+}
+
 static void dm_vupdate_high_irq(void *interrupt_params)
 {
 	struct common_irq_params *irq_params = interrupt_params;
@@ -590,10 +634,9 @@ static void dm_vupdate_high_irq(void *interrupt_params)
 				    acrtc->dm_irq_params.stream,
 				    &acrtc->dm_irq_params.vrr_params);
 
-				dc_stream_adjust_vmin_vmax(
-				    adev->dm.dc,
-				    acrtc->dm_irq_params.stream,
-				    &acrtc->dm_irq_params.vrr_params.adjust);
+				schedule_dc_vmin_vmax(adev,
+					acrtc->dm_irq_params.stream,
+					&acrtc->dm_irq_params.vrr_params.adjust);
 				spin_unlock_irqrestore(&adev_to_drm(adev)->event_lock, flags);
 			}
 		}
@@ -683,8 +726,8 @@ static void dm_crtc_high_irq(void *interrupt_params)
 					     acrtc->dm_irq_params.stream,
 					     &acrtc->dm_irq_params.vrr_params);
 
-		dc_stream_adjust_vmin_vmax(adev->dm.dc, acrtc->dm_irq_params.stream,
-					   &acrtc->dm_irq_params.vrr_params.adjust);
+		schedule_dc_vmin_vmax(adev, acrtc->dm_irq_params.stream,
+				&acrtc->dm_irq_params.vrr_params.adjust);
 	}
 
 	/*
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index b937da0a4e4a0..c18a6b43c76f6 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -152,6 +152,20 @@ struct idle_workqueue {
 	bool running;
 };
 
+/**
+ * struct dm_vupdate_work - Work data for periodic action in idle
+ * @work: Kernel work data for the work event
+ * @adev: amdgpu_device back pointer
+ * @stream: DC stream associated with the crtc
+ * @adjust: DC CRTC timing adjust to be applied to the crtc
+ */
+struct vupdate_offload_work {
+	struct work_struct work;
+	struct amdgpu_device *adev;
+	struct dc_stream_state *stream;
+	struct dc_crtc_timing_adjust *adjust;
+};
+
 #define MAX_LUMINANCE_DATA_POINTS 99
 
 /**
-- 
2.51.0

