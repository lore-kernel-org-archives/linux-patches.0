Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1342DEA67;
	Tue, 11 Nov 2025 01:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824690; cv=none; b=k6mxEzMAf5GJ3DldMKpd2kFFznR6BSqfKOS8Ef7jjorlnL9MTI9g9/oh2uga6kFWGCfgFIuQC2uTLCx0wBVrCLLSBdBDqcRE2dZYCWGJJJvHJBfWBCWIUZig/2bkx601aMo63bljlKGA9Sed3EIDgfLciA/weHTp/6J7qawNNTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824690; c=relaxed/simple;
	bh=ROtnLkkuL9lUadE9RsuSBxCbURJevpXVe3jmRedVh6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZwJsyi0ROCrzt6SYYy0CNopdtD045TYsKe391kwNZCOogiH8QABpeh/PCF9duFlYIvhE4YpdudrN3lIhoKbQGVR9QENhJf+opXaGdS8ClitFJheeBvUYfhyVG5KL3eUBtv26eeRBmrjCClfSioirv/iSZjWh2rnb/rCJ0iGUfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPodHeDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPodHeDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AE8C16AAE;
	Tue, 11 Nov 2025 01:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824690;
	bh=ROtnLkkuL9lUadE9RsuSBxCbURJevpXVe3jmRedVh6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPodHeDYhc268YQzc+TpY2DEghcI3zhK4zAJc0e8NRl0y32E+8Htgp6/TSx9fZkEW
	 PWlGZDuCGXKFarfLmlseFj1uHdxe/OT1kncpMN7dG0i4CcECLM1ndStqeTTL79boTI
	 Sw97mvVg22okecLkQkOFXs88+bNgx/wsY5I+7jiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreeja Golui <sreeja.golui@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 551/849] drm/amd/display: Fix DMCUB loading sequence for DCN3.2
Date: Tue, 11 Nov 2025 09:42:01 +0900
Message-ID: <20251111004549.728439878@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 18e755155caa57a6e6c4aa4a40b0db0fba015289 ]

[Why]
New sequence from HW for reset and firmware reloading has been
provided that aims to stabilize the reload sequence in the case the
firmware is hung or has outstanding requests.

[How]
Update the sequence to remove the DMUIF reset and the redundant
writes in the release.

Reviewed-by: Sreeja Golui <sreeja.golui@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dmub/src/dmub_dcn32.c | 53 ++++++++++---------
 .../gpu/drm/amd/display/dmub/src/dmub_dcn32.h |  8 ++-
 2 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c
index e7056205b0506..ce041f6239dc7 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c
@@ -89,44 +89,50 @@ static inline void dmub_dcn32_translate_addr(const union dmub_addr *addr_in,
 void dmub_dcn32_reset(struct dmub_srv *dmub)
 {
 	union dmub_gpint_data_register cmd;
-	const uint32_t timeout = 30;
-	uint32_t in_reset, scratch, i;
+	const uint32_t timeout = 100000;
+	uint32_t in_reset, is_enabled, scratch, i, pwait_mode;
 
 	REG_GET(DMCUB_CNTL2, DMCUB_SOFT_RESET, &in_reset);
+	REG_GET(DMCUB_CNTL, DMCUB_ENABLE, &is_enabled);
 
-	if (in_reset == 0) {
+	if (in_reset == 0 && is_enabled != 0) {
 		cmd.bits.status = 1;
 		cmd.bits.command_code = DMUB_GPINT__STOP_FW;
 		cmd.bits.param = 0;
 
 		dmub->hw_funcs.set_gpint(dmub, cmd);
 
-		/**
-		 * Timeout covers both the ACK and the wait
-		 * for remaining work to finish.
-		 *
-		 * This is mostly bound by the PHY disable sequence.
-		 * Each register check will be greater than 1us, so
-		 * don't bother using udelay.
-		 */
-
 		for (i = 0; i < timeout; ++i) {
 			if (dmub->hw_funcs.is_gpint_acked(dmub, cmd))
 				break;
+
+			udelay(1);
 		}
 
 		for (i = 0; i < timeout; ++i) {
-			scratch = dmub->hw_funcs.get_gpint_response(dmub);
+			scratch = REG_READ(DMCUB_SCRATCH7);
 			if (scratch == DMUB_GPINT__STOP_FW_RESPONSE)
 				break;
+
+			udelay(1);
 		}
 
+		for (i = 0; i < timeout; ++i) {
+			REG_GET(DMCUB_CNTL, DMCUB_PWAIT_MODE_STATUS, &pwait_mode);
+			if (pwait_mode & (1 << 0))
+				break;
+
+			udelay(1);
+		}
 		/* Force reset in case we timed out, DMCUB is likely hung. */
 	}
 
-	REG_UPDATE(DMCUB_CNTL2, DMCUB_SOFT_RESET, 1);
-	REG_UPDATE(DMCUB_CNTL, DMCUB_ENABLE, 0);
-	REG_UPDATE(MMHUBBUB_SOFT_RESET, DMUIF_SOFT_RESET, 1);
+	if (is_enabled) {
+		REG_UPDATE(DMCUB_CNTL2, DMCUB_SOFT_RESET, 1);
+		udelay(1);
+		REG_UPDATE(DMCUB_CNTL, DMCUB_ENABLE, 0);
+	}
+
 	REG_WRITE(DMCUB_INBOX1_RPTR, 0);
 	REG_WRITE(DMCUB_INBOX1_WPTR, 0);
 	REG_WRITE(DMCUB_OUTBOX1_RPTR, 0);
@@ -135,7 +141,7 @@ void dmub_dcn32_reset(struct dmub_srv *dmub)
 	REG_WRITE(DMCUB_OUTBOX0_WPTR, 0);
 	REG_WRITE(DMCUB_SCRATCH0, 0);
 
-	/* Clear the GPINT command manually so we don't reset again. */
+	/* Clear the GPINT command manually so we don't send anything during boot. */
 	cmd.all = 0;
 	dmub->hw_funcs.set_gpint(dmub, cmd);
 }
@@ -419,8 +425,8 @@ uint32_t dmub_dcn32_get_current_time(struct dmub_srv *dmub)
 
 void dmub_dcn32_get_diagnostic_data(struct dmub_srv *dmub)
 {
-	uint32_t is_dmub_enabled, is_soft_reset, is_sec_reset;
-	uint32_t is_traceport_enabled, is_cw0_enabled, is_cw6_enabled;
+	uint32_t is_dmub_enabled, is_soft_reset, is_pwait;
+	uint32_t is_traceport_enabled, is_cw6_enabled;
 	struct dmub_timeout_info timeout = {0};
 
 	if (!dmub)
@@ -470,18 +476,15 @@ void dmub_dcn32_get_diagnostic_data(struct dmub_srv *dmub)
 	REG_GET(DMCUB_CNTL, DMCUB_ENABLE, &is_dmub_enabled);
 	dmub->debug.is_dmcub_enabled = is_dmub_enabled;
 
+	REG_GET(DMCUB_CNTL, DMCUB_PWAIT_MODE_STATUS, &is_pwait);
+	dmub->debug.is_pwait = is_pwait;
+
 	REG_GET(DMCUB_CNTL2, DMCUB_SOFT_RESET, &is_soft_reset);
 	dmub->debug.is_dmcub_soft_reset = is_soft_reset;
 
-	REG_GET(DMCUB_SEC_CNTL, DMCUB_SEC_RESET_STATUS, &is_sec_reset);
-	dmub->debug.is_dmcub_secure_reset = is_sec_reset;
-
 	REG_GET(DMCUB_CNTL, DMCUB_TRACEPORT_EN, &is_traceport_enabled);
 	dmub->debug.is_traceport_en  = is_traceport_enabled;
 
-	REG_GET(DMCUB_REGION3_CW0_TOP_ADDRESS, DMCUB_REGION3_CW0_ENABLE, &is_cw0_enabled);
-	dmub->debug.is_cw0_enabled = is_cw0_enabled;
-
 	REG_GET(DMCUB_REGION3_CW6_TOP_ADDRESS, DMCUB_REGION3_CW6_ENABLE, &is_cw6_enabled);
 	dmub->debug.is_cw6_enabled = is_cw6_enabled;
 
diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.h b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.h
index 1a229450c53db..daf81027d6631 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.h
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.h
@@ -89,6 +89,9 @@ struct dmub_srv;
 	DMUB_SR(DMCUB_REGION5_OFFSET) \
 	DMUB_SR(DMCUB_REGION5_OFFSET_HIGH) \
 	DMUB_SR(DMCUB_REGION5_TOP_ADDRESS) \
+	DMUB_SR(DMCUB_REGION6_OFFSET) \
+	DMUB_SR(DMCUB_REGION6_OFFSET_HIGH) \
+	DMUB_SR(DMCUB_REGION6_TOP_ADDRESS) \
 	DMUB_SR(DMCUB_SCRATCH0) \
 	DMUB_SR(DMCUB_SCRATCH1) \
 	DMUB_SR(DMCUB_SCRATCH2) \
@@ -155,6 +158,8 @@ struct dmub_srv;
 	DMUB_SF(DMCUB_REGION4_TOP_ADDRESS, DMCUB_REGION4_ENABLE) \
 	DMUB_SF(DMCUB_REGION5_TOP_ADDRESS, DMCUB_REGION5_TOP_ADDRESS) \
 	DMUB_SF(DMCUB_REGION5_TOP_ADDRESS, DMCUB_REGION5_ENABLE) \
+	DMUB_SF(DMCUB_REGION6_TOP_ADDRESS, DMCUB_REGION6_TOP_ADDRESS) \
+	DMUB_SF(DMCUB_REGION6_TOP_ADDRESS, DMCUB_REGION6_ENABLE) \
 	DMUB_SF(CC_DC_PIPE_DIS, DC_DMCUB_ENABLE) \
 	DMUB_SF(MMHUBBUB_SOFT_RESET, DMUIF_SOFT_RESET) \
 	DMUB_SF(DCN_VM_FB_LOCATION_BASE, FB_BASE) \
@@ -162,7 +167,8 @@ struct dmub_srv;
 	DMUB_SF(DMCUB_INBOX0_WPTR, DMCUB_INBOX0_WPTR) \
 	DMUB_SF(DMCUB_REGION3_TMR_AXI_SPACE, DMCUB_REGION3_TMR_AXI_SPACE) \
 	DMUB_SF(DMCUB_INTERRUPT_ENABLE, DMCUB_GPINT_IH_INT_EN) \
-	DMUB_SF(DMCUB_INTERRUPT_ACK, DMCUB_GPINT_IH_INT_ACK)
+	DMUB_SF(DMCUB_INTERRUPT_ACK, DMCUB_GPINT_IH_INT_ACK) \
+	DMUB_SF(DMCUB_CNTL, DMCUB_PWAIT_MODE_STATUS)
 
 struct dmub_srv_dcn32_reg_offset {
 #define DMUB_SR(reg) uint32_t reg;
-- 
2.51.0



