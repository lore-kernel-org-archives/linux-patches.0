Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E633E2686A8;
	Tue,  8 Apr 2025 10:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109822; cv=none; b=PxxGV5PH1IvoIyNpyA4h6QTSzl1/mnBMKh1+huL1QDD1Y3RT9SzJn4rNkTLce6f7XeGYapqHR5Ny4y7fAZIPD5BBkFKUgIhHnL7p0DL87vkUdDgrXt4AgI1q6Tr0SfshIlti21hKn4kNrUEPI89iQy70LtvHAItX+8IBemtMLgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109822; c=relaxed/simple;
	bh=11SHFLekTI9xdkkdhPHzs7FvZSRNkX/slmVO+098FPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdVc2S3g59q3cLE0NDZC9+wHrEl+c+/eaHmRE7Y6mNzxVy/l47iI7za5jprGD7E+SBIRDu5w6sTG0Bb1fANj0Y6ZvtZYrG6EH0aXwd0IUmcG1MSkgv8lZoG8CxSHMLvBO8qG6QFlTh99kjvy5iOE7dvYuvB49QiGuAiJ+iQoLfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2p76zuEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2p76zuEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2B4C4CEE5;
	Tue,  8 Apr 2025 10:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109821;
	bh=11SHFLekTI9xdkkdhPHzs7FvZSRNkX/slmVO+098FPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2p76zuEHfEEAxAFsBhABUiyUpQNSnNhLT7VPRLcm3/yyNNs2+xLOZD+k2DtdGxAq+
	 eVJNZJV3nhYFYA6cypyEA4x6P7X8nBp0vt0vulx1daZ6jYbmJARv3Y407evS77Y3jU
	 EXtMfrwtXNEm1EZ5lV7NDN/08gEnjPQoMIxEw1nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Michael Strauss <michael.strauss@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/227] drm/amd/display: Check for invalid input params when building scaling params
Date: Tue,  8 Apr 2025 12:47:23 +0200
Message-ID: <20250408104822.359024727@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Strauss <michael.strauss@amd.com>

[ Upstream commit 73b1da69f5314d96e1f963468863eaa884ee1030 ]

[WHY]
Function to calculate scaling ratios can be called with invalid plane
src/dest, causing a divide by zero.

[HOW]
Fail building scaling params if plane state src/dest rects are
unpopulated

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 374c9faac5a7 ("drm/amd/display: Fix null check for pipe_ctx->plane_state in resource_build_scaling_params")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 0a2b3703be537..9564905c2c797 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -951,6 +951,15 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
 	bool res = false;
 	DC_LOGGER_INIT(pipe_ctx->stream->ctx->logger);
 
+	/* Invalid input */
+	if (!plane_state->dst_rect.width ||
+			!plane_state->dst_rect.height ||
+			!plane_state->src_rect.width ||
+			!plane_state->src_rect.height) {
+		ASSERT(0);
+		return false;
+	}
+
 	pipe_ctx->plane_res.scl_data.format = convert_pixel_format_to_dalsurface(
 			pipe_ctx->plane_state->format);
 
-- 
2.39.5



