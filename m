Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0625E39FE9;
	Fri, 24 Nov 2023 18:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGFOiIQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846A9C433C7;
	Fri, 24 Nov 2023 18:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850439;
	bh=URmzW0qkVOxes00LcoDV60Cnt2lKV8cIOxWzSTPnx2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGFOiIQ6hppJnvWr/OS7gPE3u/4m/qWcTeaiPlBi96NX0H3T7MfRUPtgJYv7y1ktI
	 hnYWI6Ua1CELd8K9Wl24I40EuZcRdhEIY7NgWA8wFq8TRpgUWzaszEiJ8j3Q0A3U2Z
	 0kOWZmFAQl0VBZ2oroEG6gaZhScZGXRUyYcCGdTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samson Tam <samson.tam@amd.com>,
	Stylon Wang <stylon.wang@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 049/491] drm/amd/display: Dont lock phantom pipe on disabling
Date: Fri, 24 Nov 2023 17:44:45 +0000
Message-ID: <20231124172026.165634375@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

From: Alvin Lee <alvin.lee2@amd.com>

[ Upstream commit cbb4c9bc55427774ca4d819933e1b5fa38a6fb44 ]

[Description]
- When disabling a phantom pipe, we first enable the phantom
  OTG so the double buffer update can successfully take place
- However, want to avoid locking the phantom otherwise setting
  DPG_EN=1 for the phantom pipe is blocked (without this we could
  hit underflow due to phantom HUBP being blanked by default)

Reviewed-by: Samson Tam <samson.tam@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 9834b75f1837b..79befa17bb037 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -111,7 +111,8 @@ void dcn10_lock_all_pipes(struct dc *dc,
 		if (pipe_ctx->top_pipe ||
 		    !pipe_ctx->stream ||
 		    (!pipe_ctx->plane_state && !old_pipe_ctx->plane_state) ||
-		    !tg->funcs->is_tg_enabled(tg))
+		    !tg->funcs->is_tg_enabled(tg) ||
+			pipe_ctx->stream->mall_stream_config.type == SUBVP_PHANTOM)
 			continue;
 
 		if (lock)
-- 
2.42.0



