Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4639E34AB12;
	Mon, 18 Aug 2025 14:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525706; cv=none; b=RTMBGtAmImLWqMLXfvB4WAieoAdk8Rjgx9Nfaulde9+kHtLjZtVQ37wZUxNssr1tne+E2QsTsjfQxGQLpEDWrvkk9rzHR3+P6JgJQxcUpcZ/sZkkysQBREtD8ZFccT5gXtMPQ8jPEZT0G9lsWEkpOUIvs8XY4s+Q4BhORGgmIhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525706; c=relaxed/simple;
	bh=QHPX4hp/jzSGQh55Zk7icKeUeFvuLrerxfDQpOY3aH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A+LPCT6YmMUuSrifill6pJD8ki2yOU1v/yVLtQIoXxLOSsl6HHDK3umRcgtoRVuQXcE+cnvyB2UwqtVjIKpoZs1aw5GwALfqydvsOoKTGjJfHZBktcYBW1y2TKdRHL8U/XMIamoPKLvKXidZu9L2aeQpRbC34C3vkS3lpHzDZg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1uf+fos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1uf+fos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAC9C4CEEB;
	Mon, 18 Aug 2025 14:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525706;
	bh=QHPX4hp/jzSGQh55Zk7icKeUeFvuLrerxfDQpOY3aH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1uf+fosHorhjxfLLSFwjzpfiQ7aOEREyYSwetOgI2upKrYpyZt9Nwg5V6xQZ51eq
	 jAX0YyE0fNiKM3m+Yov2vCQ/8jY4O3V8KLVKYDKrygePGlAvwhjgaerQ+oeYzkv52L
	 orB1cQ1bmEBabsLWwEG7Bc3A+/YkTviB+u/iCjCE=
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
Subject: [PATCH 6.16 310/570] drm/amd/display: Fix failed to blank crtc!
Date: Mon, 18 Aug 2025 14:44:57 +0200
Message-ID: <20250818124517.812389651@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index a93282d6e5a4..cdb8685ae7d7 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -955,7 +955,7 @@ enum dc_status dcn20_enable_stream_timing(
 		return DC_ERROR_UNEXPECTED;
 	}
 
-	hws->funcs.wait_for_blank_complete(pipe_ctx->stream_res.opp);
+	fsleep(stream->timing.v_total * (stream->timing.h_total * 10000u / stream->timing.pix_clk_100hz));
 
 	params.vertical_total_min = stream->adjust.v_total_min;
 	params.vertical_total_max = stream->adjust.v_total_max;
-- 
2.39.5



