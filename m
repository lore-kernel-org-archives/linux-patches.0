Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B755B67E;
	Wed,  8 Apr 2026 18:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674618; cv=none; b=fZcAq+eFm/BT2RnC+zkEeYx3m5gjQ6EtfB15lRracnvxUlJCjV5W2/hgTpK4RHccYH6FOaRtDffgtuKFDB6yPb+xMrmSlUzL2KO2Xso35wOMCeYVgzmzq4vCX9zd6VQwU+Jtwvr1N9jWKUM1n+YGEIGzCOdOiPCClZGGEIDYQ5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674618; c=relaxed/simple;
	bh=V5PC+onqENC9Bhfv76sosszcM4B8uOsulDKD9bBilmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c49n+nK8X540Pcz7/lLXVjoL7TFd6rtTgbi0MuHaXIfdGTXgbRfsR2wlwmXFwMYQHUVv+8SnzxM7gfhbcvFRsjBbwEyDLZlW2a1LkNKI7rVfs+GmoQYnLJFeqEd9nKZrp+DfLgrVUo0riUFjKnh6lc78bPz+6Xtc7xKMCuKjrXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/VPtnGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/VPtnGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D016BC19421;
	Wed,  8 Apr 2026 18:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674618;
	bh=V5PC+onqENC9Bhfv76sosszcM4B8uOsulDKD9bBilmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/VPtnGnDnKUwKPYkGUNTv9d75H6IUNpwXCp3OpDGsYX0oBmohAiLEtuhub54PiSo
	 5QLCfZ6jwOUwZgfllFgFlbevkNm6dEWi60c8L2tgkkKkhqXTQjFMfxFcZoILRWiQjT
	 4Xn5HBkY0BfKKJeski0jBV5ycCXF72TtBZqugwoE=
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
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 166/311] drm/amd/display: Fix NULL pointer dereference in dcn401_init_hw()
Date: Wed,  8 Apr 2026 20:02:46 +0200
Message-ID: <20260408175945.604823279@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit e927b36ae18b66b49219eaa9f46edc7b4fdbb25e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c |   17 +++++++++-----
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -146,6 +146,7 @@ void dcn401_init_hw(struct dc *dc)
 	int edp_num;
 	uint32_t backlight = MAX_BACKLIGHT_LEVEL;
 	uint32_t user_level = MAX_BACKLIGHT_LEVEL;
+	bool dchub_ref_freq_changed;
 	int current_dchub_ref_freq = 0;
 
 	if (dc->clk_mgr && dc->clk_mgr->funcs && dc->clk_mgr->funcs->init_clocks) {
@@ -359,14 +360,18 @@ void dcn401_init_hw(struct dc *dc)
 		dc->caps.dmub_caps.psr = dc->ctx->dmub_srv->dmub->feature_caps.psr;
 		dc->caps.dmub_caps.mclk_sw = dc->ctx->dmub_srv->dmub->feature_caps.fw_assisted_mclk_switch_ver > 0;
 		dc->caps.dmub_caps.fams_ver = dc->ctx->dmub_srv->dmub->feature_caps.fw_assisted_mclk_switch_ver;
+
+		/* sw and fw FAMS versions must match for support */
 		dc->debug.fams2_config.bits.enable &=
-				dc->caps.dmub_caps.fams_ver == dc->debug.fams_version.ver; // sw & fw fams versions must match for support
-		if ((!dc->debug.fams2_config.bits.enable && dc->res_pool->funcs->update_bw_bounding_box)
-			|| res_pool->ref_clocks.dchub_ref_clock_inKhz / 1000 != current_dchub_ref_freq) {
+			dc->caps.dmub_caps.fams_ver == dc->debug.fams_version.ver;
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


