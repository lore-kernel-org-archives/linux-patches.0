Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037E515B31C;
	Mon, 29 Jan 2024 17:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548273; cv=none; b=j5huu82yucqt0/JPi0hrEVrF8IQ9M0OGynrePEZ0bSBd1eEZIQA9bjyJcAHIBPfg8X0UyFK6dX7PrMjNgKjr97z7bZfg1joHkr5qFq9XDR7nDlxl7BrS6lBrUUxTjfzuY+uJf/gPQ0+nw9sBmiS4JP09ocb3tFnKPnMm3SNCJ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548273; c=relaxed/simple;
	bh=DXbuAgNcOQdQ7lQ1USTmnsOtQCTXQ1gljOnmEgsc0bM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grKqFmUkL6srGdmSbvNBBTW0HSn24pcrEg9Gng62C4LgU/iURol8tSrKYQtkpqWj09V9VQxOLOASS4Fda8VvYU4cEcpiaDN0QIYma1sqpLPMbrUxzz2ifsxTBkJ8slfxc8S3YhXuUui4xtta0249H7an1tz8VWDtEQOtklY4/xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkQAhlRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkQAhlRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66037C43390;
	Mon, 29 Jan 2024 17:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548272;
	bh=DXbuAgNcOQdQ7lQ1USTmnsOtQCTXQ1gljOnmEgsc0bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkQAhlRgkUhr4/lx2qdy6fl9Pw4VG8WCu4RMashdzy78KB6icJ6TBKy8ALQZpnoFP
	 lpvYaiUPKQ7pYGOhy2qP32uLz7TmHEL4Yxl6Ja8nuv7BpbjX1lQAk02M3kO7XAXU2k
	 QW9Tr9U/kI9UWGNOZMEKAB0kys9fYKb2gkZGQHuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Samson Tam <samson.tam@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 289/346] drm/amd/display: do not send commands to DMUB if DMUB is inactive from S3
Date: Mon, 29 Jan 2024 09:05:20 -0800
Message-ID: <20240129170024.890106673@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samson Tam <samson.tam@amd.com>

[ Upstream commit 0f657938e4345a77be871d906f3e0de3c58a7a49 ]

[Why]
On resume from S3, may get apply_idle_optimizations call while DMUB
is inactive which will just time out.

[How]
Set and track power state in dmub_srv and check power state before
sending commands to DMUB.  Add interface in both dmub_srv and
dc_dmub_srv

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Samson Tam <samson.tam@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 8892780834ae ("drm/amd/display: Wake DMCUB before sending a command")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  3 +++
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c  | 14 +++++++++++++
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h  |  2 ++
 drivers/gpu/drm/amd/display/dmub/dmub_srv.h   | 21 +++++++++++++++++++
 .../gpu/drm/amd/display/dmub/src/dmub_srv.c   | 15 +++++++++++++
 5 files changed, 55 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index a9bd020b165a..4d534ac18356 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2656,6 +2656,7 @@ static int dm_suspend(void *handle)
 	hpd_rx_irq_work_suspend(dm);
 
 	dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D3);
+	dc_dmub_srv_set_power_state(dm->dc->ctx->dmub_srv, DC_ACPI_CM_POWER_STATE_D3);
 
 	return 0;
 }
@@ -2851,6 +2852,7 @@ static int dm_resume(void *handle)
 		if (r)
 			DRM_ERROR("DMUB interface failed to initialize: status=%d\n", r);
 
+		dc_dmub_srv_set_power_state(dm->dc->ctx->dmub_srv, DC_ACPI_CM_POWER_STATE_D0);
 		dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D0);
 
 		dc_resume(dm->dc);
@@ -2901,6 +2903,7 @@ static int dm_resume(void *handle)
 	}
 
 	/* power on hardware */
+	dc_dmub_srv_set_power_state(dm->dc->ctx->dmub_srv, DC_ACPI_CM_POWER_STATE_D0);
 	dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D0);
 
 	/* program HPD filter */
diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 0e07699c1e83..0c963dfd6061 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -1251,3 +1251,17 @@ void dc_dmub_srv_exit_low_power_state(const struct dc *dc)
 		ASSERT(0);
 }
 
+void dc_dmub_srv_set_power_state(struct dc_dmub_srv *dc_dmub_srv, enum dc_acpi_cm_power_state powerState)
+{
+	struct dmub_srv *dmub;
+
+	if (!dc_dmub_srv)
+		return;
+
+	dmub = dc_dmub_srv->dmub;
+
+	if (powerState == DC_ACPI_CM_POWER_STATE_D0)
+		dmub_srv_set_power_state(dmub, DMUB_POWER_STATE_D0);
+	else
+		dmub_srv_set_power_state(dmub, DMUB_POWER_STATE_D3);
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h
index d4a60f53faab..c25ce7546f71 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h
@@ -102,4 +102,6 @@ void dc_dmub_srv_subvp_save_surf_addr(const struct dc_dmub_srv *dc_dmub_srv, con
 bool dc_dmub_srv_is_hw_pwr_up(struct dc_dmub_srv *dc_dmub_srv, bool wait);
 void dc_dmub_srv_notify_idle(const struct dc *dc, bool allow_idle);
 void dc_dmub_srv_exit_low_power_state(const struct dc *dc);
+
+void dc_dmub_srv_set_power_state(struct dc_dmub_srv *dc_dmub_srv, enum dc_acpi_cm_power_state powerState);
 #endif /* _DMUB_DC_SRV_H_ */
diff --git a/drivers/gpu/drm/amd/display/dmub/dmub_srv.h b/drivers/gpu/drm/amd/display/dmub/dmub_srv.h
index df63aa8f01e9..d1a4ed6f5916 100644
--- a/drivers/gpu/drm/amd/display/dmub/dmub_srv.h
+++ b/drivers/gpu/drm/amd/display/dmub/dmub_srv.h
@@ -150,6 +150,13 @@ enum dmub_memory_access_type {
 	DMUB_MEMORY_ACCESS_DMA
 };
 
+/* enum dmub_power_state type - to track DC power state in dmub_srv */
+enum dmub_srv_power_state_type {
+	DMUB_POWER_STATE_UNDEFINED = 0,
+	DMUB_POWER_STATE_D0 = 1,
+	DMUB_POWER_STATE_D3 = 8
+};
+
 /**
  * struct dmub_region - dmub hw memory region
  * @base: base address for region, must be 256 byte aligned
@@ -485,6 +492,8 @@ struct dmub_srv {
 	/* Feature capabilities reported by fw */
 	struct dmub_feature_caps feature_caps;
 	struct dmub_visual_confirm_color visual_confirm_color;
+
+	enum dmub_srv_power_state_type power_state;
 };
 
 /**
@@ -889,6 +898,18 @@ enum dmub_status dmub_srv_clear_inbox0_ack(struct dmub_srv *dmub);
  */
 void dmub_srv_subvp_save_surf_addr(struct dmub_srv *dmub, const struct dc_plane_address *addr, uint8_t subvp_index);
 
+/**
+ * dmub_srv_set_power_state() - Track DC power state in dmub_srv
+ * @dmub: The dmub service
+ * @power_state: DC power state setting
+ *
+ * Store DC power state in dmub_srv.  If dmub_srv is in D3, then don't send messages to DMUB
+ *
+ * Return:
+ *   void
+ */
+void dmub_srv_set_power_state(struct dmub_srv *dmub, enum dmub_srv_power_state_type dmub_srv_power_state);
+
 #if defined(__cplusplus)
 }
 #endif
diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
index 38360adc53d9..59d4e64845ca 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
@@ -713,6 +713,7 @@ enum dmub_status dmub_srv_hw_init(struct dmub_srv *dmub,
 		dmub->hw_funcs.reset_release(dmub);
 
 	dmub->hw_init = true;
+	dmub->power_state = DMUB_POWER_STATE_D0;
 
 	return DMUB_STATUS_OK;
 }
@@ -766,6 +767,9 @@ enum dmub_status dmub_srv_cmd_queue(struct dmub_srv *dmub,
 	if (!dmub->hw_init)
 		return DMUB_STATUS_INVALID;
 
+	if (dmub->power_state != DMUB_POWER_STATE_D0)
+		return DMUB_STATUS_INVALID;
+
 	if (dmub->inbox1_rb.rptr > dmub->inbox1_rb.capacity ||
 	    dmub->inbox1_rb.wrpt > dmub->inbox1_rb.capacity) {
 		return DMUB_STATUS_HW_FAILURE;
@@ -784,6 +788,9 @@ enum dmub_status dmub_srv_cmd_execute(struct dmub_srv *dmub)
 	if (!dmub->hw_init)
 		return DMUB_STATUS_INVALID;
 
+	if (dmub->power_state != DMUB_POWER_STATE_D0)
+		return DMUB_STATUS_INVALID;
+
 	/**
 	 * Read back all the queued commands to ensure that they've
 	 * been flushed to framebuffer memory. Otherwise DMCUB might
@@ -1100,3 +1107,11 @@ void dmub_srv_subvp_save_surf_addr(struct dmub_srv *dmub, const struct dc_plane_
 				subvp_index);
 	}
 }
+
+void dmub_srv_set_power_state(struct dmub_srv *dmub, enum dmub_srv_power_state_type dmub_srv_power_state)
+{
+	if (!dmub || !dmub->hw_init)
+		return;
+
+	dmub->power_state = dmub_srv_power_state;
+}
-- 
2.43.0



