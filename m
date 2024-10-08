Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491F7183CB8;
	Tue,  8 Oct 2024 12:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391854; cv=none; b=cyWLWK5+WXqOOHZgyO5S80sA+qTsorWs7hubuqP8/EtzK+9c/c1jl9dfjUd0F5/AiY7qb8d1ptTLUKBZsEyVofu8KUwZQpxLV/6GoEj9McaqETazYKiso7WCI4WBFc7yNTgWlESJq5oNEBebSVhL/3BGiDxJrb22mAqFOzSlQ4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391854; c=relaxed/simple;
	bh=SxOrCCLEZuB45eFmTkogy7JWlJtzka3/zPTtBa0HD9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwy/V5NcgbuA70nX/WJW6tL6WrHBBJHZwd1kqDc1gytdt8g5fEwLWyw122eiqlNUD8rI0xhqVgRTIpEpuhuSehXJJL+1rMOy/061b/65S0SiFzmgtvdlrhMoZhjrGJbHQroSNK+J17oEih4HyY2kMt0tuxrvmjhHc2Ki5JJ5uro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d16G7q7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d16G7q7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B401C4CEC7;
	Tue,  8 Oct 2024 12:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391854;
	bh=SxOrCCLEZuB45eFmTkogy7JWlJtzka3/zPTtBa0HD9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d16G7q7plGOAyux8VSJp+XZgHabrKeIvi/6YcRRkU9zxs82A3UErQtODZu6Prt3jr
	 l3JymBXZK2RYZqwJSYFiYt7ulLZFCHkJB73zC0nw5oTzodpUq4bxc9DkxXxhIs1RI4
	 yJN39SdCZA+H897mMlYFmIdds94XNdg6fBy2zKKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 212/558] drm/amd/display: Add NULL check for clk_mgr and clk_mgr->funcs in dcn401_init_hw
Date: Tue,  8 Oct 2024 14:04:02 +0200
Message-ID: <20241008115710.688057168@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 4b6377f0e96085cbec96eb7f0b282430ccdd3d75 ]

This commit addresses a potential null pointer dereference issue in the
`dcn401_init_hw` function. The issue could occur when `dc->clk_mgr` or
`dc->clk_mgr->funcs` is null.

The fix adds a check to ensure `dc->clk_mgr` and `dc->clk_mgr->funcs` is
not null before accessing its functions. This prevents a potential null
pointer dereference.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn401/dcn401_hwseq.c:416 dcn401_init_hw() error: we previously assumed 'dc->clk_mgr' could be null (see line 225)

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 2c50c0f745a0b..324e77ceaf1cf 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -222,7 +222,7 @@ void dcn401_init_hw(struct dc *dc)
 	uint32_t backlight = MAX_BACKLIGHT_LEVEL;
 	uint32_t user_level = MAX_BACKLIGHT_LEVEL;
 
-	if (dc->clk_mgr && dc->clk_mgr->funcs->init_clocks) {
+	if (dc->clk_mgr && dc->clk_mgr->funcs && dc->clk_mgr->funcs->init_clocks) {
 		dc->clk_mgr->funcs->init_clocks(dc->clk_mgr);
 
 		// mark dcmode limits present if any clock has distinct AC and DC values from SMU
@@ -413,7 +413,7 @@ void dcn401_init_hw(struct dc *dc)
 	if (!dcb->funcs->is_accelerated_mode(dcb) && dc->res_pool->hubbub->funcs->init_watermarks)
 		dc->res_pool->hubbub->funcs->init_watermarks(dc->res_pool->hubbub);
 
-	if (dc->clk_mgr->funcs->notify_wm_ranges)
+	if (dc->clk_mgr && dc->clk_mgr->funcs && dc->clk_mgr->funcs->notify_wm_ranges)
 		dc->clk_mgr->funcs->notify_wm_ranges(dc->clk_mgr);
 
 	if (dc->clk_mgr->funcs->set_hard_max_memclk && !dc->clk_mgr->dc_mode_softmax_enabled)
@@ -438,7 +438,9 @@ void dcn401_init_hw(struct dc *dc)
 		dc->debug.fams2_config.bits.enable &= dc->ctx->dmub_srv->dmub->feature_caps.fw_assisted_mclk_switch_ver == 2;
 		if (!dc->debug.fams2_config.bits.enable && dc->res_pool->funcs->update_bw_bounding_box) {
 			/* update bounding box if FAMS2 disabled */
-			dc->res_pool->funcs->update_bw_bounding_box(dc, dc->clk_mgr->bw_params);
+			if (dc->clk_mgr)
+				dc->res_pool->funcs->update_bw_bounding_box(dc,
+									    dc->clk_mgr->bw_params);
 		}
 	}
 }
-- 
2.43.0



