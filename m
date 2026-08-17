Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BF82E738B;
	Mon, 17 Aug 2026 14:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977912; cv=none; b=TUQenLctyuzjNvdxV0yOzVmtzK00HdKxYJwOeXK89pQvp/y0MKSvwG5qbBCni2Y+XH/pHjoaXsl5sowYTJlFh9rR8pZ64/1cgN9xYhrFju6Yklqem7dt98YlmBZbBcARbAIHq3VvzRlp2CP9rONb8U/YdMbnGefFet0SorceuqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977912; c=relaxed/simple;
	bh=wVirMeUIpooQuOEyxiQRodSdyNiLHzoPpsfcuGToTJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YoiAKLKVUrjsPvGdHv2+1KGnlAl9LB5lcYVGnopJeHhMxm9R8n8Le7/KG6u20z10X6IFLjMinlm54eo7K1FQCE2wgXq+mPC15YLNngHNsL4mc1ySVv7d6qSY4RIL5Ii2qIDgQ8IrEJR+33SyvXwuYMnEjV0zfi1Hf0LpPH18H5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYvvXNja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYvvXNja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E261F000E9;
	Mon, 17 Aug 2026 14:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977911;
	bh=sDgIru3RM8DXmRnAoeI4Ot7nVoMW0OBiaZdlny86pLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYvvXNjaezS13sC0o37mZCVwz97meSVO4s+wx4cC+QLusluwa1yH25Ah1HDwwjhl1
	 6hyIM+QUOtidzIrAElhk80glGaTpLFRI8AZbyIUc1l51NyZbuurb421rTuye0iwD/N
	 hNCZW3HOt2T9nyiQmkqVMLUWghWOdS2wxXtDbJPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Viktor=20J=C3=A4gersk=C3=BCpper?= <viktor_jaegerskuepper@freenet.de>,
	Ray Wu <ray.wu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/181] drm/amd/display: Check for tg ops in dce110_set_avmute
Date: Mon, 17 Aug 2026 15:31:38 +0200
Message-ID: <20260817132535.573588741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ray Wu <ray.wu@amd.com>

[ Upstream commit 3141e3d61469bba2624a91c5e2407f110b33b29e ]

Some older DCE timing generators do not implement is_tg_enabled in
their ops table. Calling it unconditionally when waiting for AV mute
frames causes a NULL pointer dereference on Southern Islands dGPUs
when turning the display off over HDMI.

Check that tg and the required ops exist before waiting for frames.

Fixes: 414da24137ac ("drm/amd/display: Add AV mute wait frames to dce110_set_avmute")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5557
Tested-by: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2686a0c0aaa07bec2e24131835cf27b5fd4935a5)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index a4f092eb0857b..dcc78244dd7c3 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1267,7 +1267,10 @@ void dce110_set_avmute(struct pipe_ctx *pipe_ctx, bool enable)
 		 * process the mute state, especially after link re-establishment
 		 * with HDMI 2.0 scrambling enabled.
 		 */
-		if (enable && pipe_ctx->stream_res.tg->funcs->is_tg_enabled(pipe_ctx->stream_res.tg)) {
+		if (enable && pipe_ctx->stream_res.tg &&
+		    pipe_ctx->stream_res.tg->funcs->is_tg_enabled &&
+		    pipe_ctx->stream_res.tg->funcs->wait_for_state &&
+		    pipe_ctx->stream_res.tg->funcs->is_tg_enabled(pipe_ctx->stream_res.tg)) {
 			int i;
 
 			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
-- 
2.53.0



