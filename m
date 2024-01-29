Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB9215F31A;
	Mon, 29 Jan 2024 17:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548274; cv=none; b=B9YIuOscI7RGII9kqdrqUjNiJjaQLdgO6GwInigJPOtHb0peijHHPXayPXbJpAMD1i+72tsilm94xadSXm0B4sqzw6vhQMwZv5Z2ZamF3IsZqZQWj/WwiNApB2gOKeXkN7TLZb4SoE6DegVxs2fC8o9eSq51IoY2240eGdoSDp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548274; c=relaxed/simple;
	bh=L3rCEwuc1YELclHacUWA5iznzqCYOnbxCtxpe0KGaaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORiDUv0BjNoYXs2Mef9472mr3u/GpvbWil7Pvv6HZPSdTmLjFQEU5MjuMyTUGIvsSe8QUDaKCL1evLbNQB3EgLbxOCKSA62Mn0Vt2g/15LWOSDGzgGny96NqELMglTcXSzJGJt9Kt/Ykyv7DYf1VLVoxnb95OzDLPQqEiuso60w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzMo1Csw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzMo1Csw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E858CC433F1;
	Mon, 29 Jan 2024 17:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548274;
	bh=L3rCEwuc1YELclHacUWA5iznzqCYOnbxCtxpe0KGaaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzMo1Csw9xY2Cid4zTXIfZG/QkzDozagxHhJ2BVko6eYmImgWd7Cq1xLiAWu7iySB
	 beu78Oxcf/wc5V6z6vKjg7GI1ZpS52ilMX1uOy9Nog8fErZ9L6Yc2V0a3pHtZLUnYa
	 FuHThv76xZpon6J4qOjAv+P9Duj9hoA+X64TYFow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Hansen Dsouza <hansen.dsouza@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 290/346] drm/amd/display: Refactor DMCUB enter/exit idle interface
Date: Mon, 29 Jan 2024 09:05:21 -0800
Message-ID: <20240129170024.922623444@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 8e57c06bf4b0f51a4d6958e15e1a99c9520d00fa ]

[Why]
We can hang in place trying to send commands when the DMCUB isn't
powered on.

[How]
We need to exit out of the idle state prior to sending a command,
but the process that performs the exit also invokes a command itself.

Fixing this issue involves the following:

1. Using a software state to track whether or not we need to start
   the process to exit idle or notify idle.

It's possible for the hardware to have exited an idle state without
driver knowledge, but entering one is always restricted to a driver
allow - which makes the SW state vs HW state mismatch issue purely one
of optimization, which should seldomly be hit, if at all.

2. Refactor any instances of exit/notify idle to use a single wrapper
   that maintains this SW state.

This works simialr to dc_allow_idle_optimizations, but works at the
DMCUB level and makes sure the state is marked prior to any notify/exit
idle so we don't enter an infinite loop.

3. Make sure we exit out of idle prior to sending any commands or
   waiting for DMCUB idle.

This patch takes care of 1/2. A future patch will take care of wrapping
DMCUB command submission with calls to this new interface.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hansen Dsouza <hansen.dsouza@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 8892780834ae ("drm/amd/display: Wake DMCUB before sending a command")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  4 +-
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c  | 37 ++++++++++++++++++-
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h  |  6 ++-
 .../amd/display/dc/hwss/dcn35/dcn35_hwseq.c   |  8 +---
 4 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 4d534ac18356..292335b7145c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2825,7 +2825,7 @@ static int dm_resume(void *handle)
 	bool need_hotplug = false;
 
 	if (dm->dc->caps.ips_support) {
-		dc_dmub_srv_exit_low_power_state(dm->dc);
+		dc_dmub_srv_apply_idle_power_optimizations(dm->dc, false);
 	}
 
 	if (amdgpu_in_reset(adev)) {
@@ -8771,7 +8771,7 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 			if (new_con_state->crtc &&
 				new_con_state->crtc->state->active &&
 				drm_atomic_crtc_needs_modeset(new_con_state->crtc->state)) {
-				dc_dmub_srv_exit_low_power_state(dm->dc);
+				dc_dmub_srv_apply_idle_power_optimizations(dm->dc, false);
 				break;
 			}
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 0c963dfd6061..9488f739737e 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -1143,6 +1143,9 @@ bool dc_dmub_srv_is_hw_pwr_up(struct dc_dmub_srv *dc_dmub_srv, bool wait)
 	struct dc_context *dc_ctx = dc_dmub_srv->ctx;
 	enum dmub_status status;
 
+	if (!dc_dmub_srv || !dc_dmub_srv->dmub)
+		return true;
+
 	if (dc_dmub_srv->ctx->dc->debug.dmcub_emulation)
 		return true;
 
@@ -1158,7 +1161,7 @@ bool dc_dmub_srv_is_hw_pwr_up(struct dc_dmub_srv *dc_dmub_srv, bool wait)
 	return true;
 }
 
-void dc_dmub_srv_notify_idle(const struct dc *dc, bool allow_idle)
+static void dc_dmub_srv_notify_idle(const struct dc *dc, bool allow_idle)
 {
 	union dmub_rb_cmd cmd = {0};
 
@@ -1182,7 +1185,7 @@ void dc_dmub_srv_notify_idle(const struct dc *dc, bool allow_idle)
 	dm_execute_dmub_cmd(dc->ctx, &cmd, DM_DMUB_WAIT_TYPE_WAIT);
 }
 
-void dc_dmub_srv_exit_low_power_state(const struct dc *dc)
+static void dc_dmub_srv_exit_low_power_state(const struct dc *dc)
 {
 	const uint32_t max_num_polls = 10000;
 	uint32_t allow_state = 0;
@@ -1195,6 +1198,9 @@ void dc_dmub_srv_exit_low_power_state(const struct dc *dc)
 	if (!dc->idle_optimizations_allowed)
 		return;
 
+	if (!dc->ctx->dmub_srv || !dc->ctx->dmub_srv->dmub)
+		return;
+
 	if (dc->hwss.get_idle_state &&
 		dc->hwss.set_idle_state &&
 		dc->clk_mgr->funcs->exit_low_power_state) {
@@ -1265,3 +1271,30 @@ void dc_dmub_srv_set_power_state(struct dc_dmub_srv *dc_dmub_srv, enum dc_acpi_c
 	else
 		dmub_srv_set_power_state(dmub, DMUB_POWER_STATE_D3);
 }
+
+void dc_dmub_srv_apply_idle_power_optimizations(const struct dc *dc, bool allow_idle)
+{
+	struct dc_dmub_srv *dc_dmub_srv = dc->ctx->dmub_srv;
+
+	if (!dc_dmub_srv || !dc_dmub_srv->dmub)
+		return;
+
+	if (dc_dmub_srv->idle_allowed == allow_idle)
+		return;
+
+	/*
+	 * Entering a low power state requires a driver notification.
+	 * Powering up the hardware requires notifying PMFW and DMCUB.
+	 * Clearing the driver idle allow requires a DMCUB command.
+	 * DMCUB commands requires the DMCUB to be powered up and restored.
+	 *
+	 * Exit out early to prevent an infinite loop of DMCUB commands
+	 * triggering exit low power - use software state to track this.
+	 */
+	dc_dmub_srv->idle_allowed = allow_idle;
+
+	if (!allow_idle)
+		dc_dmub_srv_exit_low_power_state(dc);
+	else
+		dc_dmub_srv_notify_idle(dc, allow_idle);
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h
index c25ce7546f71..b63cba6235fc 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h
@@ -50,6 +50,8 @@ struct dc_dmub_srv {
 
 	struct dc_context *ctx;
 	void *dm;
+
+	bool idle_allowed;
 };
 
 void dc_dmub_srv_wait_idle(struct dc_dmub_srv *dc_dmub_srv);
@@ -100,8 +102,8 @@ void dc_dmub_srv_enable_dpia_trace(const struct dc *dc);
 void dc_dmub_srv_subvp_save_surf_addr(const struct dc_dmub_srv *dc_dmub_srv, const struct dc_plane_address *addr, uint8_t subvp_index);
 
 bool dc_dmub_srv_is_hw_pwr_up(struct dc_dmub_srv *dc_dmub_srv, bool wait);
-void dc_dmub_srv_notify_idle(const struct dc *dc, bool allow_idle);
-void dc_dmub_srv_exit_low_power_state(const struct dc *dc);
+
+void dc_dmub_srv_apply_idle_power_optimizations(const struct dc *dc, bool allow_idle);
 
 void dc_dmub_srv_set_power_state(struct dc_dmub_srv *dc_dmub_srv, enum dc_acpi_cm_power_state powerState);
 #endif /* _DMUB_DC_SRV_H_ */
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
index 5a8258287438..cf26d2ad4008 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -671,11 +671,7 @@ bool dcn35_apply_idle_power_optimizations(struct dc *dc, bool enable)
 	}
 
 	// TODO: review other cases when idle optimization is allowed
-
-	if (!enable)
-		dc_dmub_srv_exit_low_power_state(dc);
-	else
-		dc_dmub_srv_notify_idle(dc, enable);
+	dc_dmub_srv_apply_idle_power_optimizations(dc, enable);
 
 	return true;
 }
@@ -685,7 +681,7 @@ void dcn35_z10_restore(const struct dc *dc)
 	if (dc->debug.disable_z10)
 		return;
 
-	dc_dmub_srv_exit_low_power_state(dc);
+	dc_dmub_srv_apply_idle_power_optimizations(dc, false);
 
 	dcn31_z10_restore(dc);
 }
-- 
2.43.0



