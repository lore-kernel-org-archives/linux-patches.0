Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CF9242D90;
	Mon, 23 Jun 2025 13:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686137; cv=none; b=l03WAfQbtd0XDX/YVdLBfT50sBtcZZl6fYxFcc3gvNaBgadRZKG67hWNMTEh7HynRblQ+4rDP3UStIGZt916K63H0c9UbNPdO6XnTYIgXzd+BVA16zZsMcKPutIvCksQNEwrX0hkopzRZf/zDqDLpgS4Liir+iW6sK09ejRsedM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686137; c=relaxed/simple;
	bh=rZ4wD9fFOdyHYm+AuHgLkkQj/yvGiFd9yoMQWZdAJtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVZXR2yue0UtU7ghtQ3jg+FyfA3AIKKZeqrgwbpko3G2ptNHN6qTe1qD8btSHlcVe5+NcIg+FxnJuxyFclVSDNWMBYMApcjLXP8qF/dvd9NdFBcuXOstxEzxY7z2ys8ZsvX2A4tDxf7+zQBKeRGOVvN/kzLlXaxJXSqubg+1N+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqoiRIXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqoiRIXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4BEC4CEEA;
	Mon, 23 Jun 2025 13:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686137;
	bh=rZ4wD9fFOdyHYm+AuHgLkkQj/yvGiFd9yoMQWZdAJtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqoiRIXm4gKOJbyLe3vlvBAXQ6bt5aF4eW7HKZKjMtA7oAT7qUO+lY2xrvyT8xnnD
	 71o5FCMlgXTOu2ipaP93Jv9evqt9ys2D5hAc84a5ZPxWNJA8CBOsSCfFMV/xKmRZyM
	 6zKBZefEJyqr5uK3o5QUH7zQKH0rbaID5OFOPMbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Paul Hsieh <Paul.Hsieh@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 263/592] drm/amd/display: Skip to enable dsc if it has been off
Date: Mon, 23 Jun 2025 15:03:41 +0200
Message-ID: <20250623130706.564104039@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Hsieh <Paul.Hsieh@amd.com>

[ Upstream commit 8b8a602c985e99074fa1d5233cd224b7bcfb9df2 ]

[Why]
It makes DSC enable when we commit the stream which need
keep power off.And then it will skip to disable DSC if
pipe reset at this situation as power has been off. It may
cause the DSC unexpected enable on the pipe with the
next new stream which doesn't support DSC.

[HOW]
Check the DSC used on current pipe status when update stream.
Skip to enable if it has been off. The operation enable
DSC should happen when set power on.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Paul Hsieh <Paul.Hsieh@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c  | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
index be26c925fdfa1..e68f21fd5f0fb 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
@@ -84,6 +84,20 @@ static void update_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 		struct dsc_config dsc_cfg;
 		struct dsc_optc_config dsc_optc_cfg = {0};
 		enum optc_dsc_mode optc_dsc_mode;
+		struct dcn_dsc_state dsc_state = {0};
+
+		if (!dsc) {
+			DC_LOG_DSC("DSC is NULL for tg instance %d:", pipe_ctx->stream_res.tg->inst);
+			return;
+		}
+
+		if (dsc->funcs->dsc_read_state) {
+			dsc->funcs->dsc_read_state(dsc, &dsc_state);
+			if (!dsc_state.dsc_fw_en) {
+				DC_LOG_DSC("DSC has been disabled for tg instance %d:", pipe_ctx->stream_res.tg->inst);
+				return;
+			}
+		}
 
 		/* Enable DSC hw block */
 		dsc_cfg.pic_width = (stream->timing.h_addressable + stream->timing.h_border_left + stream->timing.h_border_right) / opp_cnt;
-- 
2.39.5



