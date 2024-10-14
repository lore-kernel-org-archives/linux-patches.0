Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F1344C77;
	Mon, 14 Oct 2024 14:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917688; cv=none; b=l66GDR3PZ4kzaUgPrpPN/i6kHZfZB/ICQxONUKhsUQWT8GC0dnieWKC7+OqAIi5XcyoyXT8OJVpPQSb74bzl/oQar+1GZBM+oqe9UZMByXQWbl0rgCVkwUlrK9te8cRst2dLWQ61Q2aptNlkMKgtZvL2QVlXwnM0Dl1o2xRfZTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917688; c=relaxed/simple;
	bh=OTIX3zFFgeNOlv+NfUbhMPbJvuDjdlg934L1c/YSrUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvcvLolFI08bbUCx6NwWvw2fYL7q8VthCQu5Of1togaTDeaqlttZJMpKh8hqHnN4ZA2EnxuAKRY4p6gYaW/eGIvzkot9c1AF9pqGwEhCKsXImQJ9btFX3ow69j9UkUAwY0vuJnV0CLKc2Ks6RyHEWN/F5et+bEzOePYNC4QM47g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DubRNXeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DubRNXeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96885C4CEC3;
	Mon, 14 Oct 2024 14:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917688;
	bh=OTIX3zFFgeNOlv+NfUbhMPbJvuDjdlg934L1c/YSrUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DubRNXeMIkP11YdY1L9JnFQQX1R8x981Jb9PwQVpD1XCPXZ53Q00120WK3jo2v6rC
	 PrcA61Y86zRvyngVN1cw7agBGWULDew0MvMXwPedtFSMFnYsKnMFG0h8hY4ASehFuP
	 +lmF+PQ0LqUIcyXcJ53YDFzXCWeUrmm3VwxKZ7ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/798] drm/amd/display: Add null check for set_output_gamma in dcn30_set_output_transfer_func
Date: Mon, 14 Oct 2024 16:10:59 +0200
Message-ID: <20241014141222.053858418@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 08ae395ea22fb3d9b318c8bde28c0dfd2f5fa4d2 ]

This commit adds a null check for the set_output_gamma function pointer
in the  dcn30_set_output_transfer_func function. Previously,
set_output_gamma was being checked for nullity at line 386, but then it
was being dereferenced without any nullity check at line 401. This
could potentially lead to a null pointer dereference error if
set_output_gamma is indeed null.

To fix this, we now ensure that set_output_gamma is not null before
dereferencing it. We do this by adding a nullity check for
set_output_gamma before the call to set_output_gamma at line 401. If
set_output_gamma is null, we log an error message and do not call the
function.

This fix prevents a potential null pointer dereference error.

drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn30/dcn30_hwseq.c:401 dcn30_set_output_transfer_func()
error: we previously assumed 'mpc->funcs->set_output_gamma' could be null (see line 386)

drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn30/dcn30_hwseq.c
    373 bool dcn30_set_output_transfer_func(struct dc *dc,
    374                                 struct pipe_ctx *pipe_ctx,
    375                                 const struct dc_stream_state *stream)
    376 {
    377         int mpcc_id = pipe_ctx->plane_res.hubp->inst;
    378         struct mpc *mpc = pipe_ctx->stream_res.opp->ctx->dc->res_pool->mpc;
    379         const struct pwl_params *params = NULL;
    380         bool ret = false;
    381
    382         /* program OGAM or 3DLUT only for the top pipe*/
    383         if (pipe_ctx->top_pipe == NULL) {
    384                 /*program rmu shaper and 3dlut in MPC*/
    385                 ret = dcn30_set_mpc_shaper_3dlut(pipe_ctx, stream);
    386                 if (ret == false && mpc->funcs->set_output_gamma) {
                                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ If this is NULL

    387                         if (stream->out_transfer_func.type == TF_TYPE_HWPWL)
    388                                 params = &stream->out_transfer_func.pwl;
    389                         else if (pipe_ctx->stream->out_transfer_func.type ==
    390                                         TF_TYPE_DISTRIBUTED_POINTS &&
    391                                         cm3_helper_translate_curve_to_hw_format(
    392                                         &stream->out_transfer_func,
    393                                         &mpc->blender_params, false))
    394                                 params = &mpc->blender_params;
    395                          /* there are no ROM LUTs in OUTGAM */
    396                         if (stream->out_transfer_func.type == TF_TYPE_PREDEFINED)
    397                                 BREAK_TO_DEBUGGER();
    398                 }
    399         }
    400
--> 401         mpc->funcs->set_output_gamma(mpc, mpcc_id, params);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Then it will crash

    402         return ret;
    403 }

Fixes: d99f13878d6f ("drm/amd/display: Add DCN3 HWSEQ")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Hersen Wu <hersenxs.wu@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index 0225b2c96041d..407f7889e8fd4 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -215,7 +215,11 @@ bool dcn30_set_output_transfer_func(struct dc *dc,
 		}
 	}
 
-	mpc->funcs->set_output_gamma(mpc, mpcc_id, params);
+	if (mpc->funcs->set_output_gamma)
+		mpc->funcs->set_output_gamma(mpc, mpcc_id, params);
+	else
+		DC_LOG_ERROR("%s: set_output_gamma function pointer is NULL.\n", __func__);
+
 	return ret;
 }
 
-- 
2.43.0



