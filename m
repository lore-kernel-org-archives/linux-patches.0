Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A5A3EDAB8;
	Mon, 17 Aug 2026 13:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973956; cv=none; b=KFnFLtIX07opKTp5RMxQGgwxhrP6YetALCGI47aD13TSIr/WsSJG2UDayHAC0uG5DqtMjnV7OKfoUsSDgCJpVMTVOYMtLYDlizQA/9hr4dWsTiDXaImO+XNrjkpWQZxG0+I3afYJC3UfBeVOwBlHkscuYDNGgnjUArTRcpPOQMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973956; c=relaxed/simple;
	bh=W0H0E8vExuj9hFQ+G4h5qloERMPqCVB8cRE5qo/F01s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S93Lvf7wdd2PGlw7twPRPdQ7qnFW5+ZGlm9G1yshb9dXMZAl3z61YzzUeY/wRkCSa+bmZtHabq3PFU/9uqo+t0taN+UEpLe9bKSvyCM9jhkvFp2gcmAk95grTMFRPx2M6ihfO/pu/X7LUJUaSpgtSwpUI+ZHmYJ7nyQa7xvoVsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmGWxl8w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmGWxl8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E301F000E9;
	Mon, 17 Aug 2026 13:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973955;
	bh=WMdz/VAXb8dzS88xrM9/DtbsRkORHHcnj2xWiucBxcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmGWxl8wt0afEbYd7wKWsNto4rSd0fYST9ObG4AN1/dUJK2A8UxYrvXsaA/BC5ioZ
	 cyuHhBPFpvReRKWEIoL1UyIV2HDUxC5EGkq3p+YJujuJd6YYIuaNudO4JJUroMlLwY
	 fXb4R5DMIXZc1B/b3TG3HJlxNd/Vm77c3r0Dayt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Viktor=20J=C3=A4gersk=C3=BCpper?= <viktor_jaegerskuepper@freenet.de>,
	Ray Wu <ray.wu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 006/271] drm/amd/display: Check for tg ops in dce110_set_avmute
Date: Mon, 17 Aug 2026 15:28:51 +0200
Message-ID: <20260817132537.012931987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index d2a27aca6cd76..3b26229eff2b6 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1331,7 +1331,10 @@ void dce110_set_avmute(struct pipe_ctx *pipe_ctx, bool enable)
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



