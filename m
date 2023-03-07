Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D237EAD5D
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51326C433EF;
	Tue,  7 Mar 2023 18:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213814;
	bh=kMpV1bU0a6OCUyh8n5laN0AE9zA8KycxV71miZMvmcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skYUwP7Pv1cV5kQ7dYBm/Kxqx38KSGGVdOoqFfKnLwGO0QhIrUeyPO8fsHgITLPfC
	 DyhBU9mUNV1w/J0qkEaEsKxjEH6UUr0GN4DJ8AA/+6n0NbguVC911WatWQS1jTxUyb
	 Y1SXlD/38rrkCyl59lcitTFflSqu/7Nz3vhglPgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nevenko Stupar <Nevenko.Stupar@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Vladimir Stempen <vladimir.stempen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 627/885] drm/amd/display: fix FCLK pstate change underflow
Date: Tue,  7 Mar 2023 17:59:21 +0100
Message-Id: <20230307170029.458679167@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Stempen <vladimir.stempen@amd.com>

[ Upstream commit 972243f973eb0821084e5833d5f7f4ed025f42da ]

[Why]
Currently we set FCLK p-state change
watermark calculated based on dummy
p-state latency when UCLK p-state is
not supported

[How]
Calculate FCLK p-state change watermark
based on on FCLK pstate change latency
in case UCLK p-state is not supported

Reviewed-by: Nevenko Stupar <Nevenko.Stupar@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Vladimir Stempen <vladimir.stempen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index d90216d2fe3a8..04cc96e700981 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -1963,6 +1963,10 @@ void dcn32_calculate_wm_and_dlg_fpu(struct dc *dc, struct dc_state *context,
 		 */
 		context->bw_ctx.bw.dcn.watermarks.a = context->bw_ctx.bw.dcn.watermarks.c;
 		context->bw_ctx.bw.dcn.watermarks.a.cstate_pstate.pstate_change_ns = 0;
+		/* Calculate FCLK p-state change watermark based on FCLK pstate change latency in case
+		 * UCLK p-state is not supported, to avoid underflow in case FCLK pstate is supported
+		 */
+		context->bw_ctx.bw.dcn.watermarks.a.cstate_pstate.fclk_pstate_change_ns = get_fclk_watermark(&context->bw_ctx.dml, pipes, pipe_cnt) * 1000;
 	} else {
 		/* Set A:
 		 * All clocks min.
-- 
2.39.2



