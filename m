Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B50115ADD
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hf89dokd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F78C433BB;
	Mon, 16 Oct 2023 09:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697447201;
	bh=nbIHYK8/C75qW4v+2T5Wend5VeTD3PTdLoMdrv+3iXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hf89dokdLYtO9yCEQsh79qABizlCqaeycq2C1jnw7iAy4fzeiCp2gjW4OuWVyJnwX
	 vfWDz7FDMpf+OH5oWixCyu7768dFcK78A3u3nu9ppDm9VeKGR8gqHrnhcSlDh1VzIq
	 xqCo5fGY0dn+PqPPGdeqfphUBzmHsqXDFXE2FjhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Samson Tam <samson.tam@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.5 012/191] drm/amd/display: apply edge-case DISPCLK WDIVIDER changes to master OTG pipes only
Date: Mon, 16 Oct 2023 10:39:57 +0200
Message-ID: <20231016084015.689108768@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samson Tam <samson.tam@amd.com>

commit b206011bf05069797df1f4c5ce639398728978e2 upstream.

[Why]
The edge-case DISPCLK WDIVIDER changes call stream_enc functions.
But with MPC pipes, downstream pipes have null stream_enc and will
 cause crash.

[How]
Only call stream_enc functions for pipes that are OTG master.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Samson Tam <samson.tam@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c |    4 ++--
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
@@ -157,7 +157,7 @@ void dcn20_update_clocks_update_dentist(
 			int32_t N;
 			int32_t j;
 
-			if (!pipe_ctx->stream)
+			if (!resource_is_pipe_type(pipe_ctx, OTG_MASTER))
 				continue;
 			/* Virtual encoders don't have this function */
 			if (!stream_enc->funcs->get_fifo_cal_average_level)
@@ -188,7 +188,7 @@ void dcn20_update_clocks_update_dentist(
 			int32_t N;
 			int32_t j;
 
-			if (!pipe_ctx->stream)
+			if (!resource_is_pipe_type(pipe_ctx, OTG_MASTER))
 				continue;
 			/* Virtual encoders don't have this function */
 			if (!stream_enc->funcs->get_fifo_cal_average_level)
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
@@ -355,7 +355,7 @@ static void dcn32_update_clocks_update_d
 			int32_t N;
 			int32_t j;
 
-			if (!pipe_ctx->stream)
+			if (!resource_is_pipe_type(pipe_ctx, OTG_MASTER))
 				continue;
 			/* Virtual encoders don't have this function */
 			if (!stream_enc->funcs->get_fifo_cal_average_level)
@@ -401,7 +401,7 @@ static void dcn32_update_clocks_update_d
 			int32_t N;
 			int32_t j;
 
-			if (!pipe_ctx->stream)
+			if (!resource_is_pipe_type(pipe_ctx, OTG_MASTER))
 				continue;
 			/* Virtual encoders don't have this function */
 			if (!stream_enc->funcs->get_fifo_cal_average_level)


