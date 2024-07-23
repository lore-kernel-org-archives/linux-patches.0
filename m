Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C2F156F40;
	Tue, 23 Jul 2024 18:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760287; cv=none; b=oj3mPBi59F9qcGHKkExd86YGVJDI9n3aT5IeCXHJzN04g3nAcoUbD1/HcAxQgV5FDRIkVgudnb1TQVjF9iiQkrYRzNZu03eXR/g+vc2D7dXRL+5iGXqS8t83guwph3ta4z5Jq84EgQoohL6JtifO4F+aE0DpaffUAFKsUrLSdiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760287; c=relaxed/simple;
	bh=59/NULxlpgJlV1YS1jCNfSDoB2XnQD9GIntb7OQzThM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvhWdPXjnnREr1HnP+VSvfpT1HCoaJTyqNzq37DLIR7gTtfRJKMBSgIInXj+4QMAiGTWzQuSS16K2FKplWpx9g/KH3PtjuV9cvpm2B0fWRhaFOBxzIGdqQLrrDVvhiJ5mcBGOfWJQI+hhKXy0PGUA24cJ8MOh3dj/bOxnJ10zq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jkqcf5uB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jkqcf5uB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7F8C4AF09;
	Tue, 23 Jul 2024 18:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760287;
	bh=59/NULxlpgJlV1YS1jCNfSDoB2XnQD9GIntb7OQzThM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jkqcf5uBH24qXcr0DB9q5h505hpSNjHL1cbV3YQ+G6GEHnzIPzfatTfWkkNH/1I7M
	 ZQEea8DSfmWeVZ674Xt/PVAIUGCuzkgDAkygDfNBL8JyN9y8CoqBJM9f9Ky26n7O4E
	 dyJNmDO7WazkBxbYfQFdEwztDsEzLj5qHWMhs4qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 137/163] drm/amd/display: Fix array-index-out-of-bounds in dml2/FCLKChangeSupport
Date: Tue, 23 Jul 2024 20:24:26 +0200
Message-ID: <20240723180148.765879717@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <Roman.Li@amd.com>

[ Upstream commit 0ad4b4a2f6357c45fbe444ead1a929a0b4017d03 ]

[Why]
Potential out of bounds access in dml2_calculate_rq_and_dlg_params()
because the value of out_lowest_state_idx used as an index for FCLKChangeSupport
array can be greater than 1.

[How]
Currently dml2 core specifies identical values for all FCLKChangeSupport
elements. Always use index 0 in the condition to avoid out of bounds access.

Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c
index b72ed3e78df05..bb4e812248aec 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c
@@ -294,7 +294,7 @@ void dml2_calculate_rq_and_dlg_params(const struct dc *dc, struct dc_state *cont
 	context->bw_ctx.bw.dcn.clk.dcfclk_deep_sleep_khz = (unsigned int)in_ctx->v20.dml_core_ctx.mp.DCFCLKDeepSleep * 1000;
 	context->bw_ctx.bw.dcn.clk.dppclk_khz = 0;
 
-	if (in_ctx->v20.dml_core_ctx.ms.support.FCLKChangeSupport[in_ctx->v20.scratch.mode_support_params.out_lowest_state_idx] == dml_fclock_change_unsupported)
+	if (in_ctx->v20.dml_core_ctx.ms.support.FCLKChangeSupport[0] == dml_fclock_change_unsupported)
 		context->bw_ctx.bw.dcn.clk.fclk_p_state_change_support = false;
 	else
 		context->bw_ctx.bw.dcn.clk.fclk_p_state_change_support = true;
-- 
2.43.0



