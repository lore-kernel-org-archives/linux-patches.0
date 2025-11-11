Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853043064AB;
	Tue, 11 Nov 2025 01:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823151; cv=none; b=oOsrDaa4y31bO/Wd2J3Njye2YoOssksOoqSluK5mjGf4IX29AnpZ3CSAa81q2N91mHDsRrAfgXhybmZVFouOF6pjsvK8dyBEU3+Mpmo4IReVMqAnBtRnlegi2FZqGURQDqW79ZkUvsSpy80TEULhirlqu+zu4bMCbHCZh/Rfu6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823151; c=relaxed/simple;
	bh=bi1XfDS6ZfSof7koK2lfvWbhjWrmJOl15nd+E8BIJrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFbpPD3UW+8x+VQMp8Mgr1/0o3WjHzggMdkwI/tXvmGyq/bgV931qor06ZpsXouaoywe6mEO3aE6jKAX/Q4gJLU8WmbFq7oZF2evFxhNJCvNuEpQ5e9Z/LXg03B0g8UStjF8byn2ZqyTRwiTxCwETXKfntezR4S6s/MHoTvy9u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgDEKsew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgDEKsew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDEBC16AAE;
	Tue, 11 Nov 2025 01:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823151;
	bh=bi1XfDS6ZfSof7koK2lfvWbhjWrmJOl15nd+E8BIJrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OgDEKsew0cUXwj58P+ji/8UoQkG/7snd+yETYvdwT2ft9PEq1BPIaH+LFydQXWQRV
	 sPzhu8E/5/fiKoR9n7fFsWTa60hrA2hZ3y9h6Dh6M/TqKcf8/RgQ+VQ1V2u16tL28R
	 SwiFQDRmOTjogdYke8u+ALPpv4YE0aGf5r8KgrrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Michael Strauss <michael.strauss@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 240/849] drm/amd/display: Cache streams targeting link when performing LT automation
Date: Tue, 11 Nov 2025 09:36:50 +0900
Message-ID: <20251111004542.239431181@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Strauss <michael.strauss@amd.com>

[ Upstream commit f5b69101f956f5b89605a13cb15f093a7906f2a1 ]

[WHY]
Last LT automation update can cause crash by referencing current_state and
calling into dc_update_planes_and_stream which may clobber current_state.

[HOW]
Cache relevant stream pointers and iterate through them instead of relying
on the current_state.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/link/accessories/link_dp_cts.c  | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
index b12d61701d4d9..23f41c99fa38c 100644
--- a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
+++ b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
@@ -76,6 +76,9 @@ static void dp_retrain_link_dp_test(struct dc_link *link,
 	uint8_t count;
 	int i;
 
+	struct dc_stream_state *streams_on_link[MAX_PIPES];
+	int num_streams_on_link = 0;
+
 	needs_divider_update = (link->dc->link_srv->dp_get_encoding_format(link_setting) !=
 	link->dc->link_srv->dp_get_encoding_format((const struct dc_link_settings *) &link->cur_link_settings));
 
@@ -138,12 +141,19 @@ static void dp_retrain_link_dp_test(struct dc_link *link,
 		pipes[i]->stream_res.tg->funcs->enable_crtc(pipes[i]->stream_res.tg);
 
 	// Set DPMS on with stream update
-	for (i = 0; i < state->stream_count; i++)
-		if (state->streams[i] && state->streams[i]->link && state->streams[i]->link == link) {
-			stream_update.stream = state->streams[i];
+	// Cache all streams on current link since dc_update_planes_and_stream might kill current_state
+	for (i = 0; i < MAX_PIPES; i++) {
+		if (state->streams[i] && state->streams[i]->link && state->streams[i]->link == link)
+			streams_on_link[num_streams_on_link++] = state->streams[i];
+	}
+
+	for (i = 0; i < num_streams_on_link; i++) {
+		if (streams_on_link[i] && streams_on_link[i]->link && streams_on_link[i]->link == link) {
+			stream_update.stream = streams_on_link[i];
 			stream_update.dpms_off = &dpms_off;
-			dc_update_planes_and_stream(state->clk_mgr->ctx->dc, NULL, 0, state->streams[i], &stream_update);
+			dc_update_planes_and_stream(state->clk_mgr->ctx->dc, NULL, 0, streams_on_link[i], &stream_update);
 		}
+	}
 }
 
 static void dp_test_send_link_training(struct dc_link *link)
-- 
2.51.0



