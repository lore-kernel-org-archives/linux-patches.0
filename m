Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57EE12C819;
	Tue, 30 Apr 2024 10:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474313; cv=none; b=oladEYnlJ38X1JkYNzy/IFycFQOKCJFsEEvO2PPXnw61JPMVAt/LdoeY/SVrwQEbIgo244cGtm1v0MVS7qJP88jrudgr9MJAWdL22Z8rDd6QpGNyer8hJeHKB1SPA4BV/mITOzo4V0EVawEzYYFaCWnrVrzG7JOWiS7JKnG+fsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474313; c=relaxed/simple;
	bh=tpSDxl/1dDk4GkbOypVo5SkD7UGXxCCTVL+dK55qJP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtuopGTJf5JF+KFJkQFOnAUyqonNbztphIPp71lwjvVCAFKxdia3PXpUyj9newfRyRpUkckKJvPpVaD0TNFNnKVATHRoIQBXsN9K/n1aQqKXOsS2FmGB/l0aAIeqjaq/rYYcg1H3cXx1Ffh1iHgJJl0Q8UWJ8ig1cANz5ImqmRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1VapChq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1VapChq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41088C2BBFC;
	Tue, 30 Apr 2024 10:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474313;
	bh=tpSDxl/1dDk4GkbOypVo5SkD7UGXxCCTVL+dK55qJP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1VapChqysl49AWKAOpq8m8SH4Ql/Iu3bgDZB5m79H1POUjQS/7ZNI3ek8bjl8h+5
	 Y/fL6kHVPBwVftEmJBBPnT7JtWCtJIwwMq4mL0vulNXjm7wvRD3k+QpR3nQFEK1MAV
	 fo5sSz52hWl7XTil8ZVypOwFSLVkRRYC4Gq4ufGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	George Shen <george.shen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 120/228] drm/amd/display: Check DP Alt mode DPCS state via DMUB
Date: Tue, 30 Apr 2024 12:38:18 +0200
Message-ID: <20240430103107.270811026@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Shen <george.shen@amd.com>

[ Upstream commit 7d1e9d0369e4d45738d4b905c3ec92f76d7f91e6 ]

[Why]
Currently, driver state for DCN3.2 is not strictly matching HW state for
the USBC port. To reduce inconsistencies while debugging, the driver
should match HW configuration.

[How]
Update link encoder flag to indicate USBC port. Call into DMUB to check
when DP Alt mode is entered, and also to check for 2-lane versuse 4-lane
mode.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 91f10a3d21f2 ("Revert "drm/amd/display: fix USB-C flag update after enc10 feature init"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/dcn32/dcn32_dio_link_encoder.c | 85 ++++++++++++++-----
 .../display/dc/dcn32/dcn32_dio_link_encoder.h |  5 ++
 2 files changed, 71 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dio_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dio_link_encoder.c
index d761b0df28784..e224a028d68ac 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dio_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dio_link_encoder.c
@@ -34,6 +34,7 @@
 #include "dc_bios_types.h"
 #include "link_enc_cfg.h"
 
+#include "dc_dmub_srv.h"
 #include "gpio_service_interface.h"
 
 #ifndef MIN
@@ -61,6 +62,38 @@
 #define AUX_REG_WRITE(reg_name, val) \
 			dm_write_reg(CTX, AUX_REG(reg_name), val)
 
+static uint8_t phy_id_from_transmitter(enum transmitter t)
+{
+	uint8_t phy_id;
+
+	switch (t) {
+	case TRANSMITTER_UNIPHY_A:
+		phy_id = 0;
+		break;
+	case TRANSMITTER_UNIPHY_B:
+		phy_id = 1;
+		break;
+	case TRANSMITTER_UNIPHY_C:
+		phy_id = 2;
+		break;
+	case TRANSMITTER_UNIPHY_D:
+		phy_id = 3;
+		break;
+	case TRANSMITTER_UNIPHY_E:
+		phy_id = 4;
+		break;
+	case TRANSMITTER_UNIPHY_F:
+		phy_id = 5;
+		break;
+	case TRANSMITTER_UNIPHY_G:
+		phy_id = 6;
+		break;
+	default:
+		phy_id = 0;
+		break;
+	}
+	return phy_id;
+}
 
 void enc32_hw_init(struct link_encoder *enc)
 {
@@ -117,38 +150,50 @@ void dcn32_link_encoder_enable_dp_output(
 	}
 }
 
-static bool dcn32_link_encoder_is_in_alt_mode(struct link_encoder *enc)
+static bool query_dp_alt_from_dmub(struct link_encoder *enc,
+	union dmub_rb_cmd *cmd)
 {
 	struct dcn10_link_encoder *enc10 = TO_DCN10_LINK_ENC(enc);
-	uint32_t dp_alt_mode_disable = 0;
-	bool is_usb_c_alt_mode = false;
 
-	if (enc->features.flags.bits.DP_IS_USB_C) {
-		/* if value == 1 alt mode is disabled, otherwise it is enabled */
-		REG_GET(RDPCSPIPE_PHY_CNTL6, RDPCS_PHY_DPALT_DISABLE, &dp_alt_mode_disable);
-		is_usb_c_alt_mode = (dp_alt_mode_disable == 0);
-	}
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->query_dp_alt.header.type = DMUB_CMD__VBIOS;
+	cmd->query_dp_alt.header.sub_type =
+		DMUB_CMD__VBIOS_TRANSMITTER_QUERY_DP_ALT;
+	cmd->query_dp_alt.header.payload_bytes = sizeof(cmd->query_dp_alt.data);
+	cmd->query_dp_alt.data.phy_id = phy_id_from_transmitter(enc10->base.transmitter);
+
+	if (!dc_wake_and_execute_dmub_cmd(enc->ctx, cmd, DM_DMUB_WAIT_TYPE_WAIT_WITH_REPLY))
+		return false;
 
-	return is_usb_c_alt_mode;
+	return true;
 }
 
-static void dcn32_link_encoder_get_max_link_cap(struct link_encoder *enc,
+bool dcn32_link_encoder_is_in_alt_mode(struct link_encoder *enc)
+{
+	union dmub_rb_cmd cmd;
+
+	if (!query_dp_alt_from_dmub(enc, &cmd))
+		return false;
+
+	return (cmd.query_dp_alt.data.is_dp_alt_disable == 0);
+}
+
+void dcn32_link_encoder_get_max_link_cap(struct link_encoder *enc,
 	struct dc_link_settings *link_settings)
 {
-	struct dcn10_link_encoder *enc10 = TO_DCN10_LINK_ENC(enc);
-	uint32_t is_in_usb_c_dp4_mode = 0;
+	union dmub_rb_cmd cmd;
 
 	dcn10_link_encoder_get_max_link_cap(enc, link_settings);
 
-	/* in usb c dp2 mode, max lane count is 2 */
-	if (enc->funcs->is_in_alt_mode && enc->funcs->is_in_alt_mode(enc)) {
-		REG_GET(RDPCSPIPE_PHY_CNTL6, RDPCS_PHY_DPALT_DP4, &is_in_usb_c_dp4_mode);
-		if (!is_in_usb_c_dp4_mode)
-			link_settings->lane_count = MIN(LANE_COUNT_TWO, link_settings->lane_count);
-	}
+	if (!query_dp_alt_from_dmub(enc, &cmd))
+		return;
 
+	if (cmd.query_dp_alt.data.is_usb &&
+			cmd.query_dp_alt.data.is_dp4 == 0)
+		link_settings->lane_count = MIN(LANE_COUNT_TWO, link_settings->lane_count);
 }
 
+
 static const struct link_encoder_funcs dcn32_link_enc_funcs = {
 	.read_state = link_enc2_read_state,
 	.validate_output_with_stream =
@@ -203,13 +248,15 @@ void dcn32_link_encoder_construct(
 	enc10->base.hpd_source = init_data->hpd_source;
 	enc10->base.connector = init_data->connector;
 
-
 	enc10->base.preferred_engine = ENGINE_ID_UNKNOWN;
 
 	enc10->base.features = *enc_features;
 	if (enc10->base.connector.id == CONNECTOR_ID_USBC)
 		enc10->base.features.flags.bits.DP_IS_USB_C = 1;
 
+	if (enc10->base.connector.id == CONNECTOR_ID_USBC)
+		enc10->base.features.flags.bits.DP_IS_USB_C = 1;
+
 	enc10->base.transmitter = init_data->transmitter;
 
 	/* set the flag to indicate whether driver poll the I2C data pin
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dio_link_encoder.h b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dio_link_encoder.h
index bbcfce06bec01..2d5f25290ed14 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dio_link_encoder.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dio_link_encoder.h
@@ -53,4 +53,9 @@ void dcn32_link_encoder_enable_dp_output(
 	const struct dc_link_settings *link_settings,
 	enum clock_source_id clock_source);
 
+bool dcn32_link_encoder_is_in_alt_mode(struct link_encoder *enc);
+
+void dcn32_link_encoder_get_max_link_cap(struct link_encoder *enc,
+	struct dc_link_settings *link_settings);
+
 #endif /* __DC_LINK_ENCODER__DCN32_H__ */
-- 
2.43.0



