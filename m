Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF60313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301038; cv=none; b=fxaGwSeNrA1e6cfrKVomfs5ja4xoKn/hgu72cZkfrm433YMBAedGfgSGy7Wl/CaUlRXIe9r9dOAfTxqPz5d/pA3u9GiuBb/tyk12Ti9scd/iUXliU/Dz2nay6J7x3oUMYCmEGpn445J6V3S4E2R1lyqUgxCAlAXgxoInQB/4KwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301038; c=relaxed/simple;
	bh=vphFEWm559N6sOeJ5TgiEGYY8yihtEOhqtbzXnbLERA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i19edrpQnnSRvDnpvkJ0qrx8LTpA1JZSFvneH9Rnu40o0ygsu/lNDMOxpckvnk7zYv7AT1JAMmVyU28h/ITUU1jgUwsQnDxtIGUluNVyI5oIm+B+UMf8BsJX0iOZ8cbbsIgLQIdee6QIy0KwjWTDp6ZNKcwgPnoflQvQvb0jhNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r99kfUoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r99kfUoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFEBC19425;
	Sat, 28 Feb 2026 17:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301038;
	bh=vphFEWm559N6sOeJ5TgiEGYY8yihtEOhqtbzXnbLERA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r99kfUoZ5b7gs691+GG0cUQzF2LtUxHNgxcLhCYb0rQo6Nq+rtUoWCxqV3nt42CGn
	 V4qRbiRSm+xTm24kp4N9TbRPRfvjE6R8axUZaNkZjObPn2lYPCaCmyB3JLtl3Nsuoa
	 i53Kt3bmskHPf8A/f3U2y6OUqOFOr7eTuFZqSmwShmeI9n6Wy1X95dfHuF+3NNFry3
	 mrSJtIs3e/XPLPvNhbP8qJ85n2m7/DLrWM9auB3Z8n01XrF8sbAGauRDUevHc1ILjC
	 q/rpvhDurwqMbgigwFRtWgwADoTNIkVVRknxilEaIjIcj4tFtjCnzVga8Z3XV3cmhb
	 weZA8orO0Aukg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	"Ovidiu (Ovi) Bunea" <ovidiu.bunea@amd.com>,
	Matthew Stewart <matthew.stewart2@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 176/752] drm/amd/display: Ensure link output is disabled in backend reset for PLL_ON
Date: Sat, 28 Feb 2026 12:38:07 -0500
Message-ID: <20260228174750.1542406-176-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 4589712e0111352973131bad975023b25569287c ]

[Why]
We're missing the code to actually disable the link output when we have
to leave the SYMCLK_ON but the TX remains OFF.

[How]
Port the code from DCN401 that detects SYMCLK_ON_TX_OFF and disable
the link output when the backend is reset.

Reviewed-by: Ovidiu (Ovi) Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Matthew Stewart <matthew.stewart2@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c  | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
index b822f2dffff0e..e9bd43a72ce58 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
@@ -546,8 +546,22 @@ static void dcn31_reset_back_end_for_pipe(
 	if (pipe_ctx->stream_res.tg->funcs->set_odm_bypass)
 		pipe_ctx->stream_res.tg->funcs->set_odm_bypass(
 				pipe_ctx->stream_res.tg, &pipe_ctx->stream->timing);
+	/*
+	 * TODO - convert symclk_ref_cnts for otg to a bit map to solve
+	 * the case where the same symclk is shared across multiple otg
+	 * instances
+	 */
 	if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal))
-		pipe_ctx->stream->link->phy_state.symclk_ref_cnts.otg = 0;
+		link->phy_state.symclk_ref_cnts.otg = 0;
+
+	if (pipe_ctx->top_pipe == NULL) {
+		if (link->phy_state.symclk_state == SYMCLK_ON_TX_OFF) {
+			const struct link_hwss *link_hwss = get_link_hwss(link, &pipe_ctx->link_res);
+
+			link_hwss->disable_link_output(link, &pipe_ctx->link_res, pipe_ctx->stream->signal);
+			link->phy_state.symclk_state = SYMCLK_OFF_TX_OFF;
+		}
+	}
 
 	set_drr_and_clear_adjust_pending(pipe_ctx, pipe_ctx->stream, NULL);
 
-- 
2.51.0

