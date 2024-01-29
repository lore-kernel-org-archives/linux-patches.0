Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6342215B965;
	Mon, 29 Jan 2024 17:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548277; cv=none; b=mL8ZSnpRvZeRtzxDB1tYM+Tzi08WN9x8lvEr9JMLdyuvuduYP6S0x54AYoh770PVVOJRzVG7puSndpB6NSU5NQovdS2CWjd6heq4++4GF05wPd3RENESGPmCPz5XNwHiLBXJbW5vuGh+Vy2y+hlBJqLDWGwfMJwMZec9nfc2de0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548277; c=relaxed/simple;
	bh=hPw+HxSrx+S8E1imjRhRsxg757fV6it2Vi0Dkq/bZvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVSj600AhGAYsdugVpa771seyP4tpR1AQB0oQAZEISFe6AzDzNqXf+U1gc0KxWqPKSffCqKhxIriapmBiEAZU+K/MT93aXAgdpvVopb6u2Y207s5POGra4wx4LDcB0JqWLg6M41TmSfntSBOgVJLnvko6vB0ZIlRisjIw0hAh34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQ9HTtSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQ9HTtSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC211C433C7;
	Mon, 29 Jan 2024 17:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548277;
	bh=hPw+HxSrx+S8E1imjRhRsxg757fV6it2Vi0Dkq/bZvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQ9HTtSVV69mUSTfNR8gxSZQDWvgM1r9A6gPrf9aMwUXDkjUN2xyVO9RHT+1/Fvp6
	 d657IlDe5Q/CaWc7PgoTrxXVAM0ccF0ZdCAwyxMd/WEkCI2+tfGp2jqigHhcayP8h5
	 f5k/bMu3LkwdaFe+LnUkqcWQAhYb9CdqCVX01E6s=
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
Subject: [PATCH 6.7 292/346] drm/amd/display: Wake DMCUB before executing GPINT commands
Date: Mon, 29 Jan 2024 09:05:23 -0800
Message-ID: <20240129170024.991178668@linuxfoundation.org>
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

[ Upstream commit e5ffd1263dd5b44929c676171802e7b6af483f21 ]

[Why]
DMCUB can be in idle when we attempt to interface with the HW through
the GPINT mailbox resulting in a system hang.

[How]
Add dc_wake_and_execute_gpint() to wrap the wake, execute, sleep
sequence.

If the GPINT executes successfully then DMCUB will be put back into
sleep after the optional response is returned.

It functions similar to the inbox command interface.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hansen Dsouza <hansen.dsouza@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c  | 72 ++++++++++++++-----
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h  | 11 +++
 drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c | 19 ++---
 3 files changed, 72 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 50f1e6d5321e..61d1b4eadbee 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -282,17 +282,11 @@ bool dc_dmub_srv_optimized_init_done(struct dc_dmub_srv *dc_dmub_srv)
 bool dc_dmub_srv_notify_stream_mask(struct dc_dmub_srv *dc_dmub_srv,
 				    unsigned int stream_mask)
 {
-	struct dmub_srv *dmub;
-	const uint32_t timeout = 30;
-
 	if (!dc_dmub_srv || !dc_dmub_srv->dmub)
 		return false;
 
-	dmub = dc_dmub_srv->dmub;
-
-	return dmub_srv_send_gpint_command(
-		       dmub, DMUB_GPINT__IDLE_OPT_NOTIFY_STREAM_MASK,
-		       stream_mask, timeout) == DMUB_STATUS_OK;
+	return dc_wake_and_execute_gpint(dc_dmub_srv->ctx, DMUB_GPINT__IDLE_OPT_NOTIFY_STREAM_MASK,
+					 stream_mask, NULL, DM_DMUB_WAIT_TYPE_WAIT);
 }
 
 bool dc_dmub_srv_is_restore_required(struct dc_dmub_srv *dc_dmub_srv)
@@ -1107,25 +1101,20 @@ bool dc_dmub_check_min_version(struct dmub_srv *srv)
 void dc_dmub_srv_enable_dpia_trace(const struct dc *dc)
 {
 	struct dc_dmub_srv *dc_dmub_srv = dc->ctx->dmub_srv;
-	struct dmub_srv *dmub;
-	enum dmub_status status;
-	static const uint32_t timeout_us = 30;
 
 	if (!dc_dmub_srv || !dc_dmub_srv->dmub) {
 		DC_LOG_ERROR("%s: invalid parameters.", __func__);
 		return;
 	}
 
-	dmub = dc_dmub_srv->dmub;
-
-	status = dmub_srv_send_gpint_command(dmub, DMUB_GPINT__SET_TRACE_BUFFER_MASK_WORD1, 0x0010, timeout_us);
-	if (status != DMUB_STATUS_OK) {
+	if (!dc_wake_and_execute_gpint(dc->ctx, DMUB_GPINT__SET_TRACE_BUFFER_MASK_WORD1,
+				       0x0010, NULL, DM_DMUB_WAIT_TYPE_WAIT)) {
 		DC_LOG_ERROR("timeout updating trace buffer mask word\n");
 		return;
 	}
 
-	status = dmub_srv_send_gpint_command(dmub, DMUB_GPINT__UPDATE_TRACE_BUFFER_MASK, 0x0000, timeout_us);
-	if (status != DMUB_STATUS_OK) {
+	if (!dc_wake_and_execute_gpint(dc->ctx, DMUB_GPINT__UPDATE_TRACE_BUFFER_MASK,
+				       0x0000, NULL, DM_DMUB_WAIT_TYPE_WAIT)) {
 		DC_LOG_ERROR("timeout updating trace buffer mask word\n");
 		return;
 	}
@@ -1337,3 +1326,52 @@ bool dc_wake_and_execute_dmub_cmd_list(const struct dc_context *ctx, unsigned in
 
 	return result;
 }
+
+static bool dc_dmub_execute_gpint(const struct dc_context *ctx, enum dmub_gpint_command command_code,
+				  uint16_t param, uint32_t *response, enum dm_dmub_wait_type wait_type)
+{
+	struct dc_dmub_srv *dc_dmub_srv = ctx->dmub_srv;
+	const uint32_t wait_us = wait_type == DM_DMUB_WAIT_TYPE_NO_WAIT ? 0 : 30;
+	enum dmub_status status;
+
+	if (response)
+		*response = 0;
+
+	if (!dc_dmub_srv || !dc_dmub_srv->dmub)
+		return false;
+
+	status = dmub_srv_send_gpint_command(dc_dmub_srv->dmub, command_code, param, wait_us);
+	if (status != DMUB_STATUS_OK) {
+		if (status == DMUB_STATUS_TIMEOUT && wait_type == DM_DMUB_WAIT_TYPE_NO_WAIT)
+			return true;
+
+		return false;
+	}
+
+	if (response && wait_type == DM_DMUB_WAIT_TYPE_WAIT_WITH_REPLY)
+		dmub_srv_get_gpint_response(dc_dmub_srv->dmub, response);
+
+	return true;
+}
+
+bool dc_wake_and_execute_gpint(const struct dc_context *ctx, enum dmub_gpint_command command_code,
+			       uint16_t param, uint32_t *response, enum dm_dmub_wait_type wait_type)
+{
+	struct dc_dmub_srv *dc_dmub_srv = ctx->dmub_srv;
+	bool result = false, reallow_idle = false;
+
+	if (!dc_dmub_srv || !dc_dmub_srv->dmub)
+		return false;
+
+	if (dc_dmub_srv->idle_allowed) {
+		dc_dmub_srv_apply_idle_power_optimizations(ctx->dc, false);
+		reallow_idle = true;
+	}
+
+	result = dc_dmub_execute_gpint(ctx, command_code, param, response, wait_type);
+
+	if (result && reallow_idle)
+		dc_dmub_srv_apply_idle_power_optimizations(ctx->dc, true);
+
+	return result;
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h
index 784ca3e44414..952bfb368886 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.h
@@ -145,5 +145,16 @@ bool dc_wake_and_execute_dmub_cmd(const struct dc_context *ctx, union dmub_rb_cm
 bool dc_wake_and_execute_dmub_cmd_list(const struct dc_context *ctx, unsigned int count,
 				       union dmub_rb_cmd *cmd, enum dm_dmub_wait_type wait_type);
 
+/**
+ * dc_wake_and_execute_gpint()
+ *
+ * @ctx: DC context
+ * @command_code: The command ID to send to DMCUB
+ * @param: The parameter to message DMCUB
+ * @response: Optional response out value - may be NULL.
+ * @wait_type: The wait behavior for the execution
+ */
+bool dc_wake_and_execute_gpint(const struct dc_context *ctx, enum dmub_gpint_command command_code,
+			       uint16_t param, uint32_t *response, enum dm_dmub_wait_type wait_type);
 
 #endif /* _DMUB_DC_SRV_H_ */
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
index 3d7cef17f881..3e243e407bb8 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c
@@ -105,23 +105,18 @@ static enum dc_psr_state convert_psr_state(uint32_t raw_state)
  */
 static void dmub_psr_get_state(struct dmub_psr *dmub, enum dc_psr_state *state, uint8_t panel_inst)
 {
-	struct dmub_srv *srv = dmub->ctx->dmub_srv->dmub;
 	uint32_t raw_state = 0;
 	uint32_t retry_count = 0;
-	enum dmub_status status;
 
 	do {
 		// Send gpint command and wait for ack
-		status = dmub_srv_send_gpint_command(srv, DMUB_GPINT__GET_PSR_STATE, panel_inst, 30);
-
-		if (status == DMUB_STATUS_OK) {
-			// GPINT was executed, get response
-			dmub_srv_get_gpint_response(srv, &raw_state);
+		if (dc_wake_and_execute_gpint(dmub->ctx, DMUB_GPINT__GET_PSR_STATE, panel_inst, &raw_state,
+					      DM_DMUB_WAIT_TYPE_WAIT_WITH_REPLY)) {
 			*state = convert_psr_state(raw_state);
-		} else
+		} else {
 			// Return invalid state when GPINT times out
 			*state = PSR_STATE_INVALID;
-
+		}
 	} while (++retry_count <= 1000 && *state == PSR_STATE_INVALID);
 
 	// Assert if max retry hit
@@ -452,13 +447,11 @@ static void dmub_psr_force_static(struct dmub_psr *dmub, uint8_t panel_inst)
  */
 static void dmub_psr_get_residency(struct dmub_psr *dmub, uint32_t *residency, uint8_t panel_inst)
 {
-	struct dmub_srv *srv = dmub->ctx->dmub_srv->dmub;
 	uint16_t param = (uint16_t)(panel_inst << 8);
 
 	/* Send gpint command and wait for ack */
-	dmub_srv_send_gpint_command(srv, DMUB_GPINT__PSR_RESIDENCY, param, 30);
-
-	dmub_srv_get_gpint_response(srv, residency);
+	dc_wake_and_execute_gpint(dmub->ctx, DMUB_GPINT__PSR_RESIDENCY, param, residency,
+				  DM_DMUB_WAIT_TYPE_WAIT_WITH_REPLY);
 }
 
 static const struct dmub_psr_funcs psr_funcs = {
-- 
2.43.0



