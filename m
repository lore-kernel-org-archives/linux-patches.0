Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1262A23BD;
	Tue, 23 Jan 2024 00:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969510; cv=none; b=Cx0PJE1uuh8ebwL07McBWuJ2ulb+1dxun7uCZZ4pnA11sjl1e8OjGvQovQl0n8ql1JMBnQZgR17imgl91RnpaGBKKkvcbvoxCBgvFVCNSHAc3+DBx3T2V9y+heWfkAviGmbXWvET4m/hkJ6MqWX0TaoRq1636BgYuJut6rE3xZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969510; c=relaxed/simple;
	bh=2EVzQju/kqnPcfeZ52LjgHEWlk6C07DE96Xtxf/3Zeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+u120ePEZadwCwjPh6a6Gt0TFG3rv9bttKpwUrqZsmTn3GyzQwKZx7eMAhhIDTofUJY9lUlYGLETYFfD4HUbz8YqAL0s1n/e60I8RnLBR4slWwxBu/Y1D4A5YGDMISJrPDC/lG/b9U3HgZONMyrbeityeB5i3pNPoey2AmkxAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gkde0/AB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gkde0/AB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE47C43399;
	Tue, 23 Jan 2024 00:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969509;
	bh=2EVzQju/kqnPcfeZ52LjgHEWlk6C07DE96Xtxf/3Zeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gkde0/ABvi6gtE8uixLcuE0IU8uBK+BmqvtX2pt6wasfHc/ucKcsTn8/lm6kOUS9T
	 ZvhdoltNPeP1VRGo0QUitj8s23cZknZc0XeiAESCCUihqyh5icTAFo2phppKTDZ7nS
	 6WXMl5+VN7c6tUazxq6dL0O9tc6Dyud1y4AnP+WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 270/641] drm/amd/display: Fix NULL pointer dereference at hibernate
Date: Mon, 22 Jan 2024 15:52:54 -0800
Message-ID: <20240122235826.366473565@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit b719a9c15d52d4f56bdea8241a5d90fd9197ce99 ]

During hibernate sequence the source context might not have a clk_mgr.
So don't use it to look for DML2 support.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2980
Fixes: 7966f319c66d ("drm/amd/display: Introduce DML2")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index a1f1d1003992..e4bb1e25ee3b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -4512,7 +4512,7 @@ void dc_resource_state_copy_construct(
 	struct dml2_context *dml2 = NULL;
 
 	// Need to preserve allocated dml2 context
-	if (src_ctx->clk_mgr->ctx->dc->debug.using_dml2)
+	if (src_ctx->clk_mgr && src_ctx->clk_mgr->ctx->dc->debug.using_dml2)
 		dml2 = dst_ctx->bw_ctx.dml2;
 #endif
 
@@ -4520,7 +4520,7 @@ void dc_resource_state_copy_construct(
 
 #ifdef CONFIG_DRM_AMD_DC_FP
 	// Preserve allocated dml2 context
-	if (src_ctx->clk_mgr->ctx->dc->debug.using_dml2)
+	if (src_ctx->clk_mgr && src_ctx->clk_mgr->ctx->dc->debug.using_dml2)
 		dst_ctx->bw_ctx.dml2 = dml2;
 #endif
 
-- 
2.43.0



