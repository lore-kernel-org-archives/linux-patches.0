Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0189911C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789A7C433C8;
	Mon, 28 Aug 2023 10:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218468;
	bh=lKuxe1+HVGqhK0Eny3edY26vkUOiHeCRkcKAZcTR0pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jM9npXX/LdkGF9Du2PWJMNJ3VE771tyTyohrAnrl1LyDARrRD7FBdWMp+rdXJrVOp
	 dc+gDGnXyT8vocmiimF4I9lnhEWxLTXLtmUkAYJ5oZ8T0kVkmf6vmAYm3eLWdbFiTx
	 wms0NcQUCOjsK71A2SaiycQ1eiz1RITLhbUdup8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Lei <Jun.Lei@amd.com>,
	Pavle Kotarac <Pavle.Kotarac@amd.com>,
	Josip Pavic <Josip.Pavic@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/129] drm/amd/display: do not wait for mpc idle if tg is disabled
Date: Mon, 28 Aug 2023 12:13:13 +0200
Message-ID: <20230828101156.934248395@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josip Pavic <Josip.Pavic@amd.com>

[ Upstream commit 2513ed4f937999c0446fd824f7564f76b697d722 ]

[Why]
When booting, the driver waits for the MPC idle bit to be set as part of
pipe initialization. However, on some systems this occurs before OTG is
enabled, and since the MPC idle bit won't be set until the vupdate
signal occurs (which requires OTG to be enabled), this never happens and
the wait times out. This can add hundreds of milliseconds to the boot
time.

[How]
Do not wait for mpc idle if tg is disabled

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Pavle Kotarac <Pavle.Kotarac@amd.com>
Signed-off-by: Josip Pavic <Josip.Pavic@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 5a25cefc0920 ("drm/amd/display: check TG is non-null before checking if enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index ead221ccb93e0..fc75337aa0a7f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -2529,7 +2529,8 @@ static void dcn10_wait_for_mpcc_disconnect(
 		if (pipe_ctx->stream_res.opp->mpcc_disconnect_pending[mpcc_inst]) {
 			struct hubp *hubp = get_hubp_by_inst(res_pool, mpcc_inst);
 
-			res_pool->mpc->funcs->wait_for_idle(res_pool->mpc, mpcc_inst);
+			if (pipe_ctx->stream_res.tg->funcs->is_tg_enabled(pipe_ctx->stream_res.tg))
+				res_pool->mpc->funcs->wait_for_idle(res_pool->mpc, mpcc_inst);
 			pipe_ctx->stream_res.opp->mpcc_disconnect_pending[mpcc_inst] = false;
 			hubp->funcs->set_blank(hubp, true);
 			/*DC_LOG_ERROR(dc->ctx->logger,
-- 
2.40.1



