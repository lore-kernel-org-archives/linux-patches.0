Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8910C352FFD;
	Tue, 26 Aug 2025 14:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217790; cv=none; b=Hfc4LUXt0ossQc7k7uboU6lHX4WtuKM7e3aawHM/6weh+Zppr0a4g+kghKPRozShYw16QTn/1lDHsIsKiPrcECeVmIkPkXI/KbIYUfmXaU6pjsYx3Bpa3AyqkLTonsQAN4leh3l4U99ldjVi6qwpRdNXc8qgqjZwkZc7ymZxE2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217790; c=relaxed/simple;
	bh=Z7V+I1lZHFSPPTB1nKm6+1FPqhObhMltdcAlFHXeFxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bAYuPAVii73hHAxubEeqaTRz2TVEZVpsPFJtl9WAfFHrZR4ICYvcpAYGicBnT/L/wu4IZfxiQoljM+mHpvv/kICLC5m411ltqUI95N/8AioMoiRQdulwBq/+sJTkpDD6qwyN0/b1gblfdD/7ZhZ2qoagEww9FK9yxaov+tmZ9k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKf4jYrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKf4jYrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEE6C4CEF1;
	Tue, 26 Aug 2025 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217790;
	bh=Z7V+I1lZHFSPPTB1nKm6+1FPqhObhMltdcAlFHXeFxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKf4jYrcAqc6nTiEN0fMA8+2capOy5ZKUoxGVhA4TLZhlytlib0ZcLDwPgv1aTc8f
	 Wbl6dxsLM16s0l7q2RqwTCJuYHC4uHv2q1JXrbos/LhPB9S1ZQzhysrvGamsahx0Kh
	 TQeBvyHHgLDYiR3Y9luyDaPdc4t5Nu/6r/5393So=
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
Subject: [PATCH 5.10 276/523] drm/amd/display: Fix failed to blank crtc!
Date: Tue, 26 Aug 2025 13:08:06 +0200
Message-ID: <20250826110931.238946612@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b6dc99317d7f..402d65759e73 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -735,7 +735,7 @@ enum dc_status dcn20_enable_stream_timing(
 		return DC_ERROR_UNEXPECTED;
 	}
 
-	hws->funcs.wait_for_blank_complete(pipe_ctx->stream_res.opp);
+	fsleep(stream->timing.v_total * (stream->timing.h_total * 10000u / stream->timing.pix_clk_100hz));
 
 	params.vertical_total_min = stream->adjust.v_total_min;
 	params.vertical_total_max = stream->adjust.v_total_max;
-- 
2.39.5



