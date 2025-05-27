Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF663C01;
	Tue, 27 May 2025 17:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367216; cv=none; b=S7lkrbYkOleRo7RkLWgAvN57YuJaQu0Kc5t3Up+Ts/4a6vlr08r3IzXtYyMCD/7iu5lWPs3xXD3NH7m1bYrc2rUSPPRNed7hL/rnwVHX44pPn7LWOGShLL19WvYF1sJSlg+ebwDeURVwruBy8xa7Upeti11bhtQER4X9EkUGuJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367216; c=relaxed/simple;
	bh=KjqyNNyi7aO+QJzYCBI9P4x1mmVe4JL6p8+yKH0pIz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfi1oqYL2aBbGg675tZN0urbCtTKAboELB/0wWD+l9+UFBf2/7gu5gJQfJBu9oUqneyKi56ezTqs+16xBMNMVz1k8UvXYpfIjjp8PW9XCiPp+c5SRejvilB32HTvAANr7yQRlfvHo/knM+iQjzOq6T+VFHHpWCXKewwn8NZhgv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6QrISLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6QrISLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986BCC4CEE9;
	Tue, 27 May 2025 17:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367216;
	bh=KjqyNNyi7aO+QJzYCBI9P4x1mmVe4JL6p8+yKH0pIz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6QrISLMFS9b25tBqNDqpiOElc/jQ5t+4tLuos9AbKOYiFrTjiZ/xmuD1BhWGgBGQ
	 golBpNF5vdFczVJGrZYeQQX6PqOSDCaAnifvWOUG5T6C0Yut2LWCKJwD18UAHyyab6
	 sC3i3TLo6OI0LlLK+/saE64gLWCN2jDzZjzraRhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Aric Cyr <Aric.Cyr@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 285/783] drm/amd/display: Request HW cursor on DCN3.2 with SubVP
Date: Tue, 27 May 2025 18:21:22 +0200
Message-ID: <20250527162524.694752024@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aric Cyr <Aric.Cyr@amd.com>

[ Upstream commit b74f46f3ce1e5f6336645f1e9ff47c56d5dfdef1 ]

[why]
When SubVP is active the HW cursor size is limited to 64x64, and
anything larger will force composition which is bad for gaming on
DCN3.2 if the game uses a larger cursor.

[how]
If HW cursor is requested, typically by a fullscreen game, do not
enable SubVP so that up to 256x256 cursor sizes are available for
DCN3.2.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Aric Cyr <Aric.Cyr@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c             | 3 ++-
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 722175e347fdc..167f9d99a5408 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -4912,7 +4912,8 @@ static bool full_update_required(struct dc *dc,
 			stream_update->lut3d_func ||
 			stream_update->pending_test_pattern ||
 			stream_update->crtc_timing_adjust ||
-			stream_update->scaler_sharpener_update))
+			stream_update->scaler_sharpener_update ||
+			stream_update->hw_cursor_req))
 		return true;
 
 	if (stream) {
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index 6f490d8d7038c..56dda686e2992 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -626,6 +626,7 @@ static bool dcn32_assign_subvp_pipe(struct dc *dc,
 		 * - Not TMZ surface
 		 */
 		if (pipe->plane_state && !pipe->top_pipe && !pipe->prev_odm_pipe && !dcn32_is_center_timing(pipe) &&
+				!pipe->stream->hw_cursor_req &&
 				!(pipe->stream->timing.pix_clk_100hz / 10000 > DCN3_2_MAX_SUBVP_PIXEL_RATE_MHZ) &&
 				(!dcn32_is_psr_capable(pipe) || (context->stream_count == 1 && dc->caps.dmub_caps.subvp_psr)) &&
 				dc_state_get_pipe_subvp_type(context, pipe) == SUBVP_NONE &&
-- 
2.39.5



