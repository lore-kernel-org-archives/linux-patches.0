Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B9F1F12F7;
	Tue,  3 Dec 2024 16:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242146; cv=none; b=of+tfbBNFCohabDpXMxvrrqzqtRQeOtiU4T+FTj8ZMb5bZOVedfryEoOWlyWQqKF8wVtGm+Rs08QAm8MOJBD5T6EW0WbYOH0/DmPtqMcom+v0WLh1AfaBEA9xwH9B2BR+fmICt43AEv45J612GFFRhkTODBFty/Fv3nVaObqWCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242146; c=relaxed/simple;
	bh=EvGDWqJluHJ4pvLWi+DiPfigCbGMJQ5ZHhI2vGRZUOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+vtkQ1rX/Gb+9+eoVcrAr3fNYB8lGV9JKOpRBDZQ3a7OMBN4y8zEOPC75fE2oJ1Ccan+ttauxaDvzxuWcmAFA/WOF1+yIO+6tDjW2XMH/U2qe0BS1ej7Pxr0ChH3T6wtdE1sTU55neLxWawhmnTl3r44/I55FZopHHOqCRNaZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UT7nNDnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UT7nNDnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B54EC4CECF;
	Tue,  3 Dec 2024 16:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242146;
	bh=EvGDWqJluHJ4pvLWi+DiPfigCbGMJQ5ZHhI2vGRZUOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UT7nNDnpPaH7dgFEF7wdX5jnGVswX+m9pGK+zYc+PjCbsPkxAPbi1x9YCB2XVfivP
	 WRTLbI9B7TJwUjFN7mhIBYHUAwAT9cb0R11maYHjsm7tYkRrFz/uEeCiX3YC2za6UA
	 VCcs2Whi4t/w1X9fNqcKJvn59UN8JkuUs0dzx3gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 613/826] drm/amd/display: Fix null check for pipe_ctx->plane_state in dcn20_program_pipe
Date: Tue,  3 Dec 2024 15:45:40 +0100
Message-ID: <20241203144807.665420482@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zicheng Qu <quzicheng@huawei.com>

[ Upstream commit 6a057072ddd127255350357dd880903e8fa23f36 ]

This commit addresses a null pointer dereference issue in
dcn20_program_pipe(). Previously, commit 8e4ed3cf1642 ("drm/amd/display:
Add null check for pipe_ctx->plane_state in dcn20_program_pipe")
partially fixed the null pointer dereference issue. However, in
dcn20_update_dchubp_dpp(), the variable pipe_ctx is passed in, and
plane_state is accessed again through pipe_ctx. Multiple if statements
directly call attributes of plane_state, leading to potential null
pointer dereference issues. This patch adds necessary null checks to
ensure stability.

Fixes: 8e4ed3cf1642 ("drm/amd/display: Add null check for pipe_ctx->plane_state in dcn20_program_pipe")
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index a80c085829320..36d12db8d0225 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -1923,9 +1923,9 @@ static void dcn20_program_pipe(
 				dc->res_pool->hubbub, pipe_ctx->plane_res.hubp->inst, pipe_ctx->hubp_regs.det_size);
 	}
 
-	if (pipe_ctx->update_flags.raw ||
-	    (pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.raw) ||
-	    pipe_ctx->stream->update_flags.raw)
+	if (pipe_ctx->plane_state && (pipe_ctx->update_flags.raw ||
+	    pipe_ctx->plane_state->update_flags.raw ||
+	    pipe_ctx->stream->update_flags.raw))
 		dcn20_update_dchubp_dpp(dc, pipe_ctx, context);
 
 	if (pipe_ctx->plane_state && (pipe_ctx->update_flags.bits.enable ||
-- 
2.43.0



