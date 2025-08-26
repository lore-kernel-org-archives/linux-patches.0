Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38150187554;
	Tue, 26 Aug 2025 12:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213001; cv=none; b=tpC4iQSwr7agm2E8WlnfUbK7FhatxSmWsdcrMs1weXdbFd3/yvR6ri/S2sH5GPKigy/P7njsN9GtYtnzzivq2H364TJDF5EGKDfBYONZw2b2+/vQVB3ZatniqlMTjV7NRBf4tK8HbGK7e1w6QKMWnY2b2DWHwgzictezGKu7Nyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213001; c=relaxed/simple;
	bh=5u+XWO80XN+bdA6a9bfneou5xWgon2NEJFX383ohxIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=buLYq0Ye3TDoNsEbLA6WQ5o1pgkX8oVXrWPVdR6BZMiIHvisXG76B2OpbHOWgVvEI78Gk+QbulmcraTNfiquSgzoLCUhDMkDqvs9Jws2tNlULlPZ5BxXx+DeW0BYpwK/5Rrzwao6Sy41Jsv7gQ+vSkDqI0Q0G3vD6voaZSYc8nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6O5xTvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6O5xTvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EA1C4CEF1;
	Tue, 26 Aug 2025 12:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213001;
	bh=5u+XWO80XN+bdA6a9bfneou5xWgon2NEJFX383ohxIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6O5xTvTMUjizrvCG10ujkvrTQ7kWi6T7pUGbeQAoPfBlGc8ZN+sTH0PSU8hX8pbN
	 GgSGYvWTHvA4o3QeT3Ua2FgE+OX564O7Emx7vsMO7Mcprq1i91rmFnxjPRGTtxDyiJ
	 q5RwK3qewx7RZ+NZfRpTyM3tRyfQz8xBBqtvnsDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Wen Chen <Wen.Chen3@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/587] drm/amd/display: Fix failed to blank crtc!
Date: Tue, 26 Aug 2025 13:05:32 +0200
Message-ID: <20250826110957.597768155@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Chen <Wen.Chen3@amd.com>

[ Upstream commit 01f60348d8fb6b3fbcdfc7bdde5d669f95b009a4 ]

[why]
DCN35 is having “DC: failed to blank crtc!” when running HPO
test cases. It's caused by not having sufficient udelay time.

[how]
Replace the old wait_for_blank_complete function with fsleep function to
sleep just until the next frame should come up. This way it doesn't poll
in case the pixel clock or other clock was bugged or until vactive and
the vblank are hit again.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Wen Chen <Wen.Chen3@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index f3c682c7fbe6..f0b472e84a53 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -781,7 +781,7 @@ enum dc_status dcn20_enable_stream_timing(
 		return DC_ERROR_UNEXPECTED;
 	}
 
-	hws->funcs.wait_for_blank_complete(pipe_ctx->stream_res.opp);
+	fsleep(stream->timing.v_total * (stream->timing.h_total * 10000u / stream->timing.pix_clk_100hz));
 
 	params.vertical_total_min = stream->adjust.v_total_min;
 	params.vertical_total_max = stream->adjust.v_total_max;
-- 
2.39.5



