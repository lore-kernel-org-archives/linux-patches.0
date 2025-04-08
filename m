Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5862192F2;
	Tue,  8 Apr 2025 11:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112461; cv=none; b=JRIWgNaJ+VQlUrP0fDFEmATdezEvBIP0xgxuo6Vkf4bMOlCkx92prTemI8svlzqijBe+COA05ugWPr2AKmZN7s5S8Q3WMjqSA3cs4k5XplyQ+hRPt/ImK271qX1Jcbu61FGBuLZVQGgNxJubRxHrkoLa6ootmFZX2+Wdyn1bAqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112461; c=relaxed/simple;
	bh=Tf1AWkaTLcCwjnnUUfBywIqOZrMdEZdLmmfrK9VBtGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3+h5k3bFuD6erGeZO+7C9I2d3CQxka3rGifmBayFHNKoeOBptXt5iULdPrM/iBFj/2R6UdUXFnKLezmkhUZKPNhJ2ZocaE8KOsmxpBzi1vKl/RwFbZUox05lRVWDpXgQe40HBukuWhBfMMKMgAA9RQuvBK8JVAkDgi9xKm9ilA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+Fa4gtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+Fa4gtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6A9C4CEEA;
	Tue,  8 Apr 2025 11:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112461;
	bh=Tf1AWkaTLcCwjnnUUfBywIqOZrMdEZdLmmfrK9VBtGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+Fa4gtJVtZ3rDzVzpz+dYo7etZlPOsoHaLTO0zWVxwIigq+t5Whaul9rD+gdClf/
	 LYaKQ6JsYoQMoKMN7yzldnmbUb//mzzNi4Uic24hfqqA3ud7ryVsOM6E2uTtIKyyqi
	 Jz1QJJyatUtNDzeknmIsVJF+ubMmEgdr9/iBdzso=
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
Subject: [PATCH 5.15 075/279] drm/amd/display: Check for invalid input params when building scaling params
Date: Tue,  8 Apr 2025 12:47:38 +0200
Message-ID: <20250408104828.370358399@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f29299fb25c4d..de5192ee2b022 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1025,6 +1025,15 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
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



