Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6718039FF7;
	Fri, 24 Nov 2023 18:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OsIo0nDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CCAC433C7;
	Fri, 24 Nov 2023 18:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850060;
	bh=rEdCAAYCJu8lmhsElXJNnse3vl+RLyUUf6pmX6yvhuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OsIo0nDf1ejDu0cLI2/zANHyVaZb3prdHM8tPCHHU8mxQvLXBapUg7s3eIynf5pXI
	 EiCfxjguS34kE20kyHrMVL5ywCKFRGABeaUiZyKbGu56PiSCWH0aGtUjlEfvY6ueMt
	 3EHUJuz9zKtZSMpCq+T8RgV724P6apqM3fVZd6jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Muhammad Ahmed <ahmed.ahmed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 405/530] drm/amd/display: enable dsc_clk even if dsc_pg disabled
Date: Fri, 24 Nov 2023 17:49:31 +0000
Message-ID: <20231124172040.384650141@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Ahmed <ahmed.ahmed@amd.com>

[ Upstream commit 40255df370e94d44f0f0a924400d68db0ee31bec ]

[why]
need to enable dsc_clk regardless dsc_pg

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Muhammad Ahmed <ahmed.ahmed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c           | 8 ++++----
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c | 3 +++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 38abbd0c9d997..186936ad283a5 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1843,7 +1843,7 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 	if (dc->hwss.subvp_pipe_control_lock)
 		dc->hwss.subvp_pipe_control_lock(dc, context, true, true, NULL, subvp_prev_use);
 
-	if (dc->debug.enable_double_buffered_dsc_pg_support)
+	if (dc->hwss.update_dsc_pg)
 		dc->hwss.update_dsc_pg(dc, context, false);
 
 	disable_dangling_plane(dc, context);
@@ -1950,7 +1950,7 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 		dc->hwss.optimize_bandwidth(dc, context);
 	}
 
-	if (dc->debug.enable_double_buffered_dsc_pg_support)
+	if (dc->hwss.update_dsc_pg)
 		dc->hwss.update_dsc_pg(dc, context, true);
 
 	if (dc->ctx->dce_version >= DCE_VERSION_MAX)
@@ -2197,7 +2197,7 @@ void dc_post_update_surfaces_to_stream(struct dc *dc)
 
 		dc->hwss.optimize_bandwidth(dc, context);
 
-		if (dc->debug.enable_double_buffered_dsc_pg_support)
+		if (dc->hwss.update_dsc_pg)
 			dc->hwss.update_dsc_pg(dc, context, true);
 	}
 
@@ -3533,7 +3533,7 @@ static void commit_planes_for_stream(struct dc *dc,
 		if (get_seamless_boot_stream_count(context) == 0)
 			dc->hwss.prepare_bandwidth(dc, context);
 
-		if (dc->debug.enable_double_buffered_dsc_pg_support)
+		if (dc->hwss.update_dsc_pg)
 			dc->hwss.update_dsc_pg(dc, context, false);
 
 		context_clock_trace(dc, context);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index be59e1c02f8aa..c9140b50c3454 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -77,6 +77,9 @@ void dcn32_dsc_pg_control(
 	if (hws->ctx->dc->debug.disable_dsc_power_gate)
 		return;
 
+	if (!hws->ctx->dc->debug.enable_double_buffered_dsc_pg_support)
+		return;
+
 	REG_GET(DC_IP_REQUEST_CNTL, IP_REQUEST_EN, &org_ip_request_cntl);
 	if (org_ip_request_cntl == 0)
 		REG_SET(DC_IP_REQUEST_CNTL, 0, IP_REQUEST_EN, 1);
-- 
2.42.0



