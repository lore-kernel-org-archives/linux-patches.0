Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B701DE8BE;
	Tue,  8 Oct 2024 12:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390177; cv=none; b=rTcwLWVSu8aez4Lza27jQWH0diveTndJ2jaH9xyJYr5dSwWaLEzMRXY8+SfdeIKyNKg8r8/mw+NRRGvKnoPtIDVtVC69oSMKFdteSwB8MrzRhJGwbqhliXVDasQy5pxzy9Cx67kbYExSUew8b8sh9wc+r1dR+dzkSTnNP/43+V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390177; c=relaxed/simple;
	bh=r1Jl5OtxO7ZRGC6C/yD9rZ7mr2F4HkmjC9UMMpoC7LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQVX+BDY2uULPNyFBef9hYZZJsxQQWxx/6STuUJAl2PDVftaI0WYmuiliydET5v88KNsCoOEFAr+FTgDttouIa9rGKdYbReibHc5JBPSu2FjtbTHI1vfC4INr45YhyFENg1VUtO5sdU1Ubh5jRcbdd65d+ncz204od+8U4GeFtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1MjVums; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1MjVums"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A35C4CEC7;
	Tue,  8 Oct 2024 12:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390177;
	bh=r1Jl5OtxO7ZRGC6C/yD9rZ7mr2F4HkmjC9UMMpoC7LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1MjVumsQ0CGgWR7ngPELEvYNTRgL9B8Lxe/QJxVKc3sSOHdUvWNesuMlKm024WrV
	 YRvyu185EFJBzME5DdV+IdKTjsp8L3ozv4/pA5jwLuFUa/oQtzJMB/Jh/LM4TOAWQq
	 vOwQnWgBPnOMN4zPVhykQ7xS6cxLEZrn52pZAS6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 213/482] drm/amd/display: Check link_res->hpo_dp_link_enc before using it
Date: Tue,  8 Oct 2024 14:04:36 +0200
Message-ID: <20241008115656.694399976@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 0beca868cde8742240cd0038141c30482d2b7eb8 ]

[WHAT & HOW]
Functions dp_enable_link_phy and dp_disable_link_phy can pass link_res
without initializing hpo_dp_link_enc and it is necessary to check for
null before dereferencing.

This fixes 2 FORWARD_NULL issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_dp.c    | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_dp.c b/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_dp.c
index e1257404357b1..d0148f10dfc0a 100644
--- a/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/link/hwss/link_hwss_hpo_dp.c
@@ -28,6 +28,8 @@
 #include "dccg.h"
 #include "clk_mgr.h"
 
+#define DC_LOGGER link->ctx->logger
+
 void set_hpo_dp_throttled_vcp_size(struct pipe_ctx *pipe_ctx,
 		struct fixed31_32 throttled_vcp_size)
 {
@@ -124,6 +126,11 @@ void disable_hpo_dp_link_output(struct dc_link *link,
 		const struct link_resource *link_res,
 		enum signal_type signal)
 {
+	if (!link_res->hpo_dp_link_enc) {
+		DC_LOG_ERROR("%s: invalid hpo_dp_link_enc\n", __func__);
+		return;
+	}
+
 		link_res->hpo_dp_link_enc->funcs->link_disable(link_res->hpo_dp_link_enc);
 		link_res->hpo_dp_link_enc->funcs->disable_link_phy(
 				link_res->hpo_dp_link_enc, signal);
-- 
2.43.0



