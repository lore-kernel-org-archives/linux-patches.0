Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAB0352066;
	Tue, 26 Aug 2025 13:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216310; cv=none; b=ZRwv6m1he2MuAKqJYy9xpVEd0hW3kT1LP++teqNITBby4PsKL1HV+vkhDGImrGyiL0xD2oirH/wn6Os8pWp1ImUVk9DJuwDyVmuiGNKcpnALtrvMPq6MH8KtgT5yF/iDVJSS4dpr+BrzJgQr0PBeJukCBbn5Z/kqSTKPiGdCl60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216310; c=relaxed/simple;
	bh=T1xfVbKPtecWu+8gI13GyUM6GqLcZ+NZ/cZXlSAzDB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DYlx5hEy0biHXzyQEtMmR3U99qpERr/1tfqeAgnh+jsinMr3VPB7kZ8YzXNw8GP2hBKMuHOH/9yxMvdUDJnSixVcIDV08VefyxIubsws72ujU5kN0ziWfbw1qriBbUVJqjR3HXjrZg59xap628BGHwkznyiqF2PO+zPn051K+Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGHFNERD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGHFNERD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C72C4CEF1;
	Tue, 26 Aug 2025 13:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216310;
	bh=T1xfVbKPtecWu+8gI13GyUM6GqLcZ+NZ/cZXlSAzDB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGHFNERDQ1vSxPOrYiDdFOtBfaDwsz0CbBHp4rytVi7q8xrlvXaH1sDnnEW81Ns9a
	 ZTJoM1HaIOYJdpkLUbbcs347wPKqfNErtWX2/aFjyqqNN7QkA5z1XwcljdeO4qOpvF
	 vP/TdZ3WTlfBZrL154JU0jbY1UvKnsL6fBo99aag=
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
Subject: [PATCH 5.15 364/644] drm/amd/display: Fix failed to blank crtc!
Date: Tue, 26 Aug 2025 13:07:35 +0200
Message-ID: <20250826110955.435199458@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 59d16c553800..3935c8b32a2b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -729,7 +729,7 @@ enum dc_status dcn20_enable_stream_timing(
 		return DC_ERROR_UNEXPECTED;
 	}
 
-	hws->funcs.wait_for_blank_complete(pipe_ctx->stream_res.opp);
+	fsleep(stream->timing.v_total * (stream->timing.h_total * 10000u / stream->timing.pix_clk_100hz));
 
 	params.vertical_total_min = stream->adjust.v_total_min;
 	params.vertical_total_max = stream->adjust.v_total_max;
-- 
2.39.5



