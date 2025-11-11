Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1448F348458;
	Tue, 11 Nov 2025 01:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823218; cv=none; b=MbWHQEOFTgrJuX+deai+S4N1qp1OPT6Z9kcPXy7+/oXgs7CuF+p+txB5X/bpsBEzh65QjspyQRDFvM9B/Kqwb41bafFGydd77rDLF/eJFTp27j2amaJluv8Ay9hVAAtKqbwLChZdqX6EODE1d8V5wjgj1ZCy020K2CqmqecHKmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823218; c=relaxed/simple;
	bh=7QWHfAlwuPhsFFqfqwO0NO24Hoh3+CDyLkJO93wbG4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUYM/573j+mc8sOZairp/AHAAVzr6jJimaf0acQdDJ7e8JpZBYzzf2hJz4EO510j7yJCzxlJHZeiKJnq2BZ3TT6WtALZeIzKGOV0IHoM9PeOy8/ecCGyUlTsJK4Yr4vofm1LnmhUo+D5JRSOwwswXVEsEiXCvoUxgSVohA7Hy9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hK6kATXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hK6kATXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2C8C116B1;
	Tue, 11 Nov 2025 01:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823217;
	bh=7QWHfAlwuPhsFFqfqwO0NO24Hoh3+CDyLkJO93wbG4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hK6kATXpcxtmplY81Saen9dNFgzObDCowyvVh/E0DrTYH0pJ9mZiyXMHVJXQMSYcs
	 4pTEEzTcajSEBUQWdhvl1C63rk9s4JrfpE5UbAibN+iXFxkmfE/WkErADkAjaZfk7F
	 iSiBOT0N9Cs3mek5t6sFQWTXYMx4L2mcnwGAWd0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 255/849] drm/amd/display: fix dmub access race condition
Date: Tue, 11 Nov 2025 09:37:05 +0900
Message-ID: <20251111004542.593270397@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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



