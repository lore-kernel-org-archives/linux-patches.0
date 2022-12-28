Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1611868
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FC8C433EF;
	Wed, 28 Dec 2022 15:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241250;
	bh=zCqZwWKjQD7OaoZ7o3KRQw7nyL+7AvFOi2sWVxg5MqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRkbRFuEWVA85nOLl9vYpnJrdf1ETgV/BdrMB9Hi4ytyHPyS1+QbZ9g7TRTMJ93qW
	 bNv5+Tl3Aw+l3S90M89ZkF/owat3OFYkwQnJk9LizCKEOkSFfQrcLOuMHUnUtaKfNs
	 Xcu6JFGFvZzNHcZ39elnzFDIzxwwsa+HYz2o+PS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Broadworth <mark.broadworth@amd.com>,
	Martin Leung <Martin.Leung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Haiyi Zhou <Haiyi.Zhou@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0258/1073] drm/amd/display: wait for vblank during pipe programming
Date: Wed, 28 Dec 2022 15:30:46 +0100
Message-Id: <20221228144335.026544289@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haiyi Zhou <Haiyi.Zhou@amd.com>

[ Upstream commit 203ccaf586446b578909de1b763278033fb74b51 ]

[WHY]
Skipping vblank during global sync update request can result in
underflow on certain displays.

[HOW]
Roll back to the previous behavior where DC waits for vblank during pipe
programming.

Fixes: 5d3e14421410 ("drm/amd/display: do not wait for vblank during pipe programming")
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Haiyi Zhou <Haiyi.Zhou@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 0f30df523fdf..146189323dbe 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1632,10 +1632,8 @@ static void dcn20_program_pipe(
 				pipe_ctx->pipe_dlg_param.vupdate_width);
 
 		if (pipe_ctx->stream->mall_stream_config.type != SUBVP_PHANTOM) {
-			pipe_ctx->stream_res.tg->funcs->wait_for_state(
-				pipe_ctx->stream_res.tg, CRTC_STATE_VBLANK);
-			pipe_ctx->stream_res.tg->funcs->wait_for_state(
-				pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
+			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VBLANK);
+			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
 		}
 
 		pipe_ctx->stream_res.tg->funcs->set_vtg_params(
-- 
2.35.1



