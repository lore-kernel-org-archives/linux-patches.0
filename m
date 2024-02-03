Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5849E1CAA5;
	Sat,  3 Feb 2024 04:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933864; cv=none; b=UGVyJLEEc0JSdt8cMee2qh43NTtrIesGGzo37DdqSXtNtIsjU9FkAS7FFkwIgV6xM6K+Fd3wuuDtyxpr8lWvm2T/BcEX40TjFVfJ7/FRIr6unvLAnopMayIWqQrie/CCRp5NlOeeX6b8sR/zvKyK3RzzjNCGLumQmEkFNdIKXNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933864; c=relaxed/simple;
	bh=/mPlyNOC83xaNvx1jrFRRIeS5IDuFaXbvwpaPssj9YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ujn286MbEZyOkwpO9Jgz3aSQP3umjkX4aOv6qTKHbNRcCvP0vF4E44zprcbgRvsDTi0Wr6NO2TE2vu0nXIGG4iL7bU1hZcvIVRbtt0fpUmKc0my6L+zUa+KozbRYLlMha+rEfNccWmo7iIUFuSeVjCjYVgNqcWdv3PVfmg0QZmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcBw8VZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcBw8VZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2125AC43390;
	Sat,  3 Feb 2024 04:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933864;
	bh=/mPlyNOC83xaNvx1jrFRRIeS5IDuFaXbvwpaPssj9YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PcBw8VZ+nxqI3RHe5SrebTNxz6uCFOoxtaUGTPDgvzsAiqVZP0sPTAAqRzmQGamkn
	 OPx/WoyhJFY5LE7E54pNvYggfOkuDxie1NfThRrLJSzTOXK4lCfKnuaVbdeE1FmmCi
	 POeNo9VLnACn7kwGc47208mxR8876QNRe7WQpVaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Nicholas Susanto <nicholas.susanto@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 176/353] drm/amd/display: Fix disable_otg_wa logic
Date: Fri,  2 Feb 2024 20:04:54 -0800
Message-ID: <20240203035409.213588957@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Susanto <nicholas.susanto@amd.com>

[ Upstream commit 2ce156482a6fef349d2eba98e5070c412d3af662 ]

[Why]
When switching to another HDMI mode, we are unnecesarilly
disabling/enabling FIFO causing both HPO and DIG registers to be set at
the same time when only HPO is supposed to be set.

This can lead to a system hang the next time we change refresh rates as
there are cases when we don't disable OTG/FIFO but FIFO is enabled when
it isn't supposed to be.

[How]
Removing the enable/disable FIFO entirely.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Nicholas Susanto <nicholas.susanto@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c  | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
index 45ede6440a79..4ef90a3add1c 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -126,21 +126,13 @@ static void dcn35_disable_otg_wa(struct clk_mgr *clk_mgr_base, struct dc_state *
 			continue;
 		if (pipe->stream && (pipe->stream->dpms_off || dc_is_virtual_signal(pipe->stream->signal) ||
 				     !pipe->stream->link_enc)) {
-			struct stream_encoder *stream_enc = pipe->stream_res.stream_enc;
-
 			if (disable) {
-				if (stream_enc && stream_enc->funcs->disable_fifo)
-					pipe->stream_res.stream_enc->funcs->disable_fifo(stream_enc);
-
 				if (pipe->stream_res.tg && pipe->stream_res.tg->funcs->immediate_disable_crtc)
 					pipe->stream_res.tg->funcs->immediate_disable_crtc(pipe->stream_res.tg);
 
 				reset_sync_context_for_pipe(dc, context, i);
 			} else {
 				pipe->stream_res.tg->funcs->enable_crtc(pipe->stream_res.tg);
-
-				if (stream_enc && stream_enc->funcs->enable_fifo)
-					pipe->stream_res.stream_enc->funcs->enable_fifo(stream_enc);
 			}
 		}
 	}
-- 
2.43.0



