Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E152281343;
	Thu, 13 Feb 2025 14:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457208; cv=none; b=V1/DHihA6U7UHuHf5fyPjeKnQPON7WmnGlKeh9AmsPcglrMsbXcZimwieNLvFjVQNf+/ecZGr0BG0ib4j8IhS//bsZT3LhkuclMqGZpLUkAPTq5BFFmoA7+Ucsg/KtngcPLCS54IiF3r3j49xQMKStvk5POtYshbOzh3oaUfhHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457208; c=relaxed/simple;
	bh=qJy/iBZ2we9IDQNYsAPw5yXKqkOcGPmj4KZHlZ5vgF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFB23FKAexhejU//ayvsEmH2606NPTVVYpl38UGq623yTPQiwdK68u/rYeox2oOdNc12YkwNHcKC2LPx8lmI82PY1KdKNaZk5FYJ50H1q7yheY2/+EnsisIoz5/pDO36Ml2zD7yh0B46YfUyW4mpbXbFmOKlvm0+j1/xcxCRvtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/Swqgx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/Swqgx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083A6C4CEE2;
	Thu, 13 Feb 2025 14:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457208;
	bh=qJy/iBZ2we9IDQNYsAPw5yXKqkOcGPmj4KZHlZ5vgF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/Swqgx9Orpmma8CItOTV4LmZrmMXhviZU+JMXQi7pm2XGaRk0uhSfi3pGuRrD32Z
	 OpfGP2gI/sFRjZQvaHAfN/7kzZE3kAjjYj6mhEUNdhoMDNVVnzLRaL8d4gHfmpaf1o
	 bLotNnqIRKi4RjMzhR3s03P3c8w5KQbuFnG+40bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Gabe Teeger <Gabe.Teeger@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/422] drm/amd/display: Limit Scaling Ratio on DCN3.01
Date: Thu, 13 Feb 2025 15:23:15 +0100
Message-ID: <20250213142438.340149895@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabe Teeger <Gabe.Teeger@amd.com>

[ Upstream commit abc0ad6d08440761b199988c329ad7ac83f41c9b ]

[why]
Underflow and flickering was occuring due to high scaling ratios
when resizing videos.

[how]
Limit the scaling ratios by increasing the max scaling factor

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Gabe Teeger <Gabe.Teeger@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/resource/dcn301/dcn301_resource.c  | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn301/dcn301_resource.c
index 7d04739c3ba14..4bbbe07ecde7d 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn301/dcn301_resource.c
@@ -671,9 +671,9 @@ static const struct dc_plane_cap plane_cap = {
 
 	/* 6:1 downscaling ratio: 1000/6 = 166.666 */
 	.max_downscale_factor = {
-			.argb8888 = 167,
-			.nv12 = 167,
-			.fp16 = 167 
+			.argb8888 = 358,
+			.nv12 = 358,
+			.fp16 = 358
 	},
 	64,
 	64
@@ -694,7 +694,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.disable_dcc = DCC_ENABLE,
 	.vsr_support = true,
 	.performance_trace = false,
-	.max_downscale_src_width = 7680,/*upto 8K*/
+	.max_downscale_src_width = 4096,/*upto true 4k*/
 	.scl_reset_length10 = true,
 	.sanity_checks = false,
 	.underflow_assert_delay_us = 0xFFFFFFFF,
-- 
2.39.5



