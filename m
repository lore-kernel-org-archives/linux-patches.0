Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A3B171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CD9C433D2;
	Mon, 22 May 2023 19:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783435;
	bh=Do8RwKlCy6GwAleJgok+hQDUEKiHkL7cY1TFGe0+u7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JF2wvAtg/NEdBhGpF1wMzI4tdhQ3dVE2Q2LlmQPCSp1raB3lq/t/ig6uqe6ArMFhj
	 6LFjM4tc+Ucdkj1fIUJGlbmVOq8v6gBBLlhmU4k/gZxwdKe3nieKcdwbqx5O6Lv6F4
	 Acpg8ttaMxVzVHjl4bC1AAj1CPJwHU1urwNcQJ80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Ayush Gupta <ayush.gupta@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/292] drm/amd/display: populate subvp cmd info only for the top pipe
Date: Mon, 22 May 2023 20:06:39 +0100
Message-Id: <20230522190406.953436196@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ayush Gupta <ayush.gupta@amd.com>

[ Upstream commit 9bb10b7aaec3b6278f9cc410c17dcaa129bbbbf0 ]

[Why]
System restart observed while changing the display resolution
to 8k with extended mode. Sytem restart was caused by a page fault.

[How]
When the driver populates subvp info it did it for both the pipes using
vblank which caused an outof bounds array access causing the page fault.
added checks to allow the top pipe only to fix this issue.

Co-authored-by: Ayush Gupta <ayush.gupta@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Ayush Gupta <ayush.gupta@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 0541e87e4f389..a461e9463534b 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -764,7 +764,8 @@ void dc_dmub_setup_subvp_dmub_command(struct dc *dc,
 					!pipe->top_pipe && !pipe->prev_odm_pipe &&
 					pipe->stream->mall_stream_config.type == SUBVP_MAIN) {
 				populate_subvp_cmd_pipe_info(dc, context, &cmd, pipe, cmd_pipe_index++);
-			} else if (pipe->plane_state && pipe->stream->mall_stream_config.type == SUBVP_NONE) {
+			} else if (pipe->plane_state && pipe->stream->mall_stream_config.type == SUBVP_NONE &&
+				    !pipe->top_pipe && !pipe->prev_odm_pipe) {
 				// Don't need to check for ActiveDRAMClockChangeMargin < 0, not valid in cases where
 				// we run through DML without calculating "natural" P-state support
 				populate_subvp_cmd_vblank_pipe_info(dc, context, &cmd, pipe, cmd_pipe_index++);
-- 
2.39.2



