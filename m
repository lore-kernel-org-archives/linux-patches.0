Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC68A166F1A;
	Mon, 18 Aug 2025 13:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523829; cv=none; b=CYF5rQfW2eOaeoRqJxRHBnhxls7gqmlU/79X3rpnH3ufIop/HDiRAUHnls9Ygqndql6yeLBBKfRFiZV7Ycm1unglorkL36LRmPvuacqSNZEKC1/U4uTZ7bN9KcVMISsEraP8ndNk02+IrN/gpYhthJPQxWt5WZ3WJBmUlFYFysk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523829; c=relaxed/simple;
	bh=n8sBVMITAUNvhCXuvEoyUgYBVUzGY8W1IiR+ouvLL3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j2Us1rLEkKMkbNNME0rm5XJfxGmPzKnDbq6V4P/PKsNbuXn/PvcKaQTCKCD8aDuLoBGmGztLFfo5m4xxNSyjJD6NUvfW/vERceso2BxfsER0o40B018gVhYxXG2RvckhVsRiH+AkwGx7+iSImnfIW0DJb6ND27hEEgD9BtNjBJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAGkDc+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAGkDc+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471EDC4CEEB;
	Mon, 18 Aug 2025 13:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523829;
	bh=n8sBVMITAUNvhCXuvEoyUgYBVUzGY8W1IiR+ouvLL3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAGkDc+aa4JoBPI7yAUjjkG5a1DEKqmVgBs8YBDi+QsNNldLYnGGmKZ3awEA7BNxb
	 4smmWR/keYT5RdiCOClRQLFZyTDAfz6IIunLL3BS+a8ynG+FvsTSxMsj1+gvKUjfQN
	 xEJ6LNYMdQi84sV1sy4dey5NaD7rejKYkDAgliP0=
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
Subject: [PATCH 6.15 284/515] drm/amd/display: Fix failed to blank crtc!
Date: Mon, 18 Aug 2025 14:44:30 +0200
Message-ID: <20250818124509.352433349@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 637f1235d0b7..977ec7c1c212 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -945,7 +945,7 @@ enum dc_status dcn20_enable_stream_timing(
 		return DC_ERROR_UNEXPECTED;
 	}
 
-	hws->funcs.wait_for_blank_complete(pipe_ctx->stream_res.opp);
+	fsleep(stream->timing.v_total * (stream->timing.h_total * 10000u / stream->timing.pix_clk_100hz));
 
 	params.vertical_total_min = stream->adjust.v_total_min;
 	params.vertical_total_max = stream->adjust.v_total_max;
-- 
2.39.5



