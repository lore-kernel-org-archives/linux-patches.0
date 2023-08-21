Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C157E11703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45304C433C7;
	Mon, 21 Aug 2023 19:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647875;
	bh=tSurWd8D/+sPuUwhHLL7pYNrFqe6yCSVhDkkoCv4sYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEV57t2Cl1NHtk1SKMaynz6dqOQm8rvSe2NEalO3EzI06tNxtpffFQVn+o0s3OA4Z
	 IhScVI1WGF/0Y0O3YHBWrGwbatXSX5H6helH/SQOh0Zt0yNRCwBVxJFhFxEzX6amnf
	 AMMCr/2+1m3JkLiPaXSOvK+ECbhQvU0UKdeUJB2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Saaem Rizvi <SyedSaaem.Rizvi@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <mario.limonciello@amd.com>
Subject: [PATCH 6.1 170/194] drm/amd/display: Implement workaround for writing to OTG_PIXEL_RATE_DIV register
Date: Mon, 21 Aug 2023 21:42:29 +0200
Message-ID: <20230821194130.174315568@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Saaem Rizvi <SyedSaaem.Rizvi@amd.com>

commit 74fa4c81aadf418341f0d073c864ea7dca730a2e upstream.

[Why and How]
Current implementation requires FPGA builds to take a different
code path from DCN32 to write to OTG_PIXEL_RATE_DIV. Now that
we have a workaround to write to OTG_PIXEL_RATE_DIV register without
blanking display on hotplug on DCN32, we can allow the code paths for
FPGA to be exactly the same allowing for more consistent
testing.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Saaem Rizvi <SyedSaaem.Rizvi@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.h     |    3 +-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c     |   22 ++++++++++++++++++
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.h     |    3 +-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c    |    2 -
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h |    3 +-
 5 files changed, 29 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.h
@@ -230,7 +230,8 @@
 	type DTBCLK_P2_SRC_SEL;\
 	type DTBCLK_P2_EN;\
 	type DTBCLK_P3_SRC_SEL;\
-	type DTBCLK_P3_EN;
+	type DTBCLK_P3_EN;\
+	type DENTIST_DISPCLK_CHG_DONE;
 
 struct dccg_shift {
 	DCCG_REG_FIELD_LIST(uint8_t)
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
@@ -42,6 +42,20 @@
 #define DC_LOGGER \
 	dccg->ctx->logger
 
+/* This function is a workaround for writing to OTG_PIXEL_RATE_DIV
+ * without the probability of causing a DIG FIFO error.
+ */
+static void dccg32_wait_for_dentist_change_done(
+	struct dccg *dccg)
+{
+	struct dcn_dccg *dccg_dcn = TO_DCN_DCCG(dccg);
+
+	uint32_t dentist_dispclk_value = REG_READ(DENTIST_DISPCLK_CNTL);
+
+	REG_WRITE(DENTIST_DISPCLK_CNTL, dentist_dispclk_value);
+	REG_WAIT(DENTIST_DISPCLK_CNTL, DENTIST_DISPCLK_CHG_DONE, 1, 50, 2000);
+}
+
 static void dccg32_get_pixel_rate_div(
 		struct dccg *dccg,
 		uint32_t otg_inst,
@@ -110,21 +124,29 @@ static void dccg32_set_pixel_rate_div(
 		REG_UPDATE_2(OTG_PIXEL_RATE_DIV,
 				OTG0_PIXEL_RATE_DIVK1, k1,
 				OTG0_PIXEL_RATE_DIVK2, k2);
+
+		dccg32_wait_for_dentist_change_done(dccg);
 		break;
 	case 1:
 		REG_UPDATE_2(OTG_PIXEL_RATE_DIV,
 				OTG1_PIXEL_RATE_DIVK1, k1,
 				OTG1_PIXEL_RATE_DIVK2, k2);
+
+		dccg32_wait_for_dentist_change_done(dccg);
 		break;
 	case 2:
 		REG_UPDATE_2(OTG_PIXEL_RATE_DIV,
 				OTG2_PIXEL_RATE_DIVK1, k1,
 				OTG2_PIXEL_RATE_DIVK2, k2);
+
+		dccg32_wait_for_dentist_change_done(dccg);
 		break;
 	case 3:
 		REG_UPDATE_2(OTG_PIXEL_RATE_DIV,
 				OTG3_PIXEL_RATE_DIVK1, k1,
 				OTG3_PIXEL_RATE_DIVK2, k2);
+
+		dccg32_wait_for_dentist_change_done(dccg);
 		break;
 	default:
 		BREAK_TO_DEBUGGER();
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.h
@@ -147,7 +147,8 @@
 	DCCG_SF(DTBCLK_P_CNTL, DTBCLK_P3_SRC_SEL, mask_sh),\
 	DCCG_SF(DTBCLK_P_CNTL, DTBCLK_P3_EN, mask_sh),\
 	DCCG_SF(DCCG_AUDIO_DTO_SOURCE, DCCG_AUDIO_DTO_SEL, mask_sh),\
-	DCCG_SF(DCCG_AUDIO_DTO_SOURCE, DCCG_AUDIO_DTO0_SOURCE_SEL, mask_sh)
+	DCCG_SF(DCCG_AUDIO_DTO_SOURCE, DCCG_AUDIO_DTO0_SOURCE_SEL, mask_sh),\
+	DCCG_SF(DENTIST_DISPCLK_CNTL, DENTIST_DISPCLK_CHG_DONE, mask_sh)
 
 
 struct dccg *dccg32_create(
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -1177,7 +1177,7 @@ unsigned int dcn32_calculate_dccg_k1_k2_
 			*k2_div = PIXEL_RATE_DIV_BY_2;
 		else
 			*k2_div = PIXEL_RATE_DIV_BY_4;
-	} else if (dc_is_dp_signal(stream->signal)) {
+	} else if (dc_is_dp_signal(stream->signal) || dc_is_virtual_signal(stream->signal)) {
 		if (two_pix_per_container) {
 			*k1_div = PIXEL_RATE_DIV_BY_1;
 			*k2_div = PIXEL_RATE_DIV_BY_2;
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.h
@@ -1272,7 +1272,8 @@ unsigned int dcn32_calc_num_avail_chans_
       DCCG_SRII(PHASE, DTBCLK_DTO, 0), DCCG_SRII(PHASE, DTBCLK_DTO, 1),        \
       DCCG_SRII(PHASE, DTBCLK_DTO, 2), DCCG_SRII(PHASE, DTBCLK_DTO, 3),        \
       SR(DCCG_AUDIO_DTBCLK_DTO_MODULO), SR(DCCG_AUDIO_DTBCLK_DTO_PHASE),       \
-      SR(OTG_PIXEL_RATE_DIV), SR(DTBCLK_P_CNTL), SR(DCCG_AUDIO_DTO_SOURCE)     \
+      SR(OTG_PIXEL_RATE_DIV), SR(DTBCLK_P_CNTL),                               \
+      SR(DCCG_AUDIO_DTO_SOURCE), SR(DENTIST_DISPCLK_CNTL)                      \
   )
 
 /* VMID */


