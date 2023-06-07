Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B36E10FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0459C433D2;
	Wed,  7 Jun 2023 20:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169724;
	bh=JGCPjgjaisu6qWwe83OrdvqDtScNdKupDNcXuM3Y+Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZK0wzzY4daR+H/jO6PY/gXY5jyW8kT/yHOF8feBkGSDE60rL1N+3BDrtp+Se1O7UV
	 beV3RH/JBpJYa7xJsqarH1vyqdgR2YHzuM0OH0ySHxGC+x5c27R/kJuWdjBRW5yKVo
	 WdJ5QZgxaQ/VqYsIE7nbB8ZU1wJToOVjGrVFZOoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 189/286] drm/amd/display: Only wait for blank completion if OTG active
Date: Wed,  7 Jun 2023 22:14:48 +0200
Message-ID: <20230607200929.444279527@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 82a10aff9428f1d190de55ef7971fdb84303cc7a ]

[why]
If OTG is not active, waiting for blank completion will always fail and
timeout resulting in unnecessary driver delays.

[how]
Check that OTG is enabled before waiting for blank.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index d4a1670a54506..f07cba121d010 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1093,7 +1093,8 @@ static void phantom_pipe_blank(
 			otg_active_height,
 			0);
 
-	hws->funcs.wait_for_blank_complete(opp);
+	if (tg->funcs->is_tg_enabled(tg))
+		hws->funcs.wait_for_blank_complete(opp);
 }
 
 static void disable_dangling_plane(struct dc *dc, struct dc_state *context)
@@ -1156,6 +1157,7 @@ static void disable_dangling_plane(struct dc *dc, struct dc_state *context)
 			if (old_stream->mall_stream_config.type == SUBVP_PHANTOM) {
 				if (tg->funcs->enable_crtc) {
 					int main_pipe_width, main_pipe_height;
+
 					main_pipe_width = old_stream->mall_stream_config.paired_stream->dst.width;
 					main_pipe_height = old_stream->mall_stream_config.paired_stream->dst.height;
 					phantom_pipe_blank(dc, tg, main_pipe_width, main_pipe_height);
-- 
2.39.2



