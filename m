Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AD617BED0;
	Sat, 17 Oct 2026 16:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253871; cv=none; b=Dl4Xhi3jgfcsX5fCxNJmWBBqB5DTU5HeTcE9BxZdko7gE+ZGHkcohmCnxlxHNWuGQkpVkPb6AN+StRHPB6ivNeGZ04Ul8dqBS/zvEL3k+URuEBIUqqvdoPDyuS36l/yYTTZuX3kczeQVSU7LWZgMDWw1BTJgIeXfpgYVLCvhnoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253871; c=relaxed/simple;
	bh=k80UNzDGyW6PvokT5SzmjeiqJVaBipuWriJy/IlGjv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAPmuUZSe1YExLKUDcX9a0OYvt9ElQ8Qbv6/YesbyRiCNs8DawvAooOwSHtI94nUS+i4g+nS87D9vJiE7fjg3FCbAo+15YoE0w7NiQawn2ZHLODog6CrN4qKcLHvyLEubcGO6q/iXnVVw66lUCX5mYSBceuPf4te9vYvi8SCyJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5jx5ZCo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5jx5ZCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5961F000C4;
	Sat, 17 Oct 2026 16:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253869;
	bh=gTNZ7R4aEb34mUhhNcoajLfTI5jVK3rx8Td79O1La4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5jx5ZCokUHiL/4/th+X2LLvy1FHG9KmgNl/8/NlHR5VoZvSJbVKHvviKM5xPu5QO
	 dLjJT24Q1RO33UzX2kypFtv5YTvIFmt6TrpbUplDEgBy1wK9LJJ1efw/PlOUBFIV4a
	 Imf03xzJVXdoaNN9tELrCJhlbVkiTZWk3fGHdbqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Sa <Daniel.Sa@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 261/869] drm/amd/display: Fix NULL pointer dereference in dcn401_init_hw()
Date: Sat, 17 Oct 2026 17:51:42 +0200
Message-ID: <20261017160043.752151679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit e927b36ae18b66b49219eaa9f46edc7b4fdbb25e ]

dcn401_init_hw() assumes that update_bw_bounding_box() is valid when
entering the update path. However, the existing condition:

  ((!fams2_enable && update_bw_bounding_box) || freq_changed)

does not guarantee this, as the freq_changed branch can evaluate to true
independently of the callback pointer.

This can result in calling update_bw_bounding_box() when it is NULL.

Fix this by separating the update condition from the pointer checks and
ensuring the callback, dc->clk_mgr, and bw_params are validated before
use.

Fixes the below:
../dc/hwss/dcn401/dcn401_hwseq.c:367 dcn401_init_hw() error: we previously assumed 'dc->res_pool->funcs->update_bw_bounding_box' could be null (see line 362)

Fixes: ca0fb243c3bb ("drm/amd/display: Underflow Seen on DCN401 eGPU")
Cc: Daniel Sa <Daniel.Sa@amd.com>
Cc: Alvin Lee <alvin.lee2@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 86117c5ab42f21562fedb0a64bffea3ee5fcd477)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c   | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 768b756d427c7..be99798cf6ee1 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -225,6 +225,7 @@ void dcn401_init_hw(struct dc *dc)
 	int edp_num;
 	uint32_t backlight = MAX_BACKLIGHT_LEVEL;
 	uint32_t user_level = MAX_BACKLIGHT_LEVEL;
+	bool dchub_ref_freq_changed;
 	int current_dchub_ref_freq = 0;
 
 	if (dc->clk_mgr && dc->clk_mgr->funcs && dc->clk_mgr->funcs->init_clocks) {
@@ -445,12 +446,14 @@ void dcn401_init_hw(struct dc *dc)
 		dc->caps.dmub_caps.mclk_sw = dc->ctx->dmub_srv->dmub->feature_caps.fw_assisted_mclk_switch_ver > 0;
 		dc->caps.dmub_caps.fams_ver = dc->ctx->dmub_srv->dmub->feature_caps.fw_assisted_mclk_switch_ver;
 		dc->debug.fams2_config.bits.enable &= dc->ctx->dmub_srv->dmub->feature_caps.fw_assisted_mclk_switch_ver == 2;
-		if ((!dc->debug.fams2_config.bits.enable && dc->res_pool->funcs->update_bw_bounding_box)
-			|| res_pool->ref_clocks.dchub_ref_clock_inKhz / 1000 != current_dchub_ref_freq) {
+		dchub_ref_freq_changed =
+			res_pool->ref_clocks.dchub_ref_clock_inKhz / 1000 != current_dchub_ref_freq;
+		if ((!dc->debug.fams2_config.bits.enable || dchub_ref_freq_changed) &&
+		    dc->res_pool->funcs->update_bw_bounding_box &&
+		    dc->clk_mgr && dc->clk_mgr->bw_params) {
 			/* update bounding box if FAMS2 disabled, or if dchub clk has changed */
-			if (dc->clk_mgr)
-				dc->res_pool->funcs->update_bw_bounding_box(dc,
-									    dc->clk_mgr->bw_params);
+			dc->res_pool->funcs->update_bw_bounding_box(dc,
+								    dc->clk_mgr->bw_params);
 		}
 	}
 }
-- 
2.53.0



