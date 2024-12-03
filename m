Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AF71F76AA;
	Tue,  3 Dec 2024 15:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239539; cv=none; b=lh88mLhKjc3W/9qlk6QOdRwWLVJNvUQra6ReDhT/aU5ImBhZOpg9bV2AkiDAKub8lDHhRZFGwb8/GontVHwEttBUHL8PAg8NN/kTiRNEIm0WMAFjtErvV7hrjFD0ekhDCMoNAfbG//16IYmg3dRhN5COACPnHieUjkD9sUAdzaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239539; c=relaxed/simple;
	bh=N+4UDgK8WxeLgPe3K90SqvoXxKFvUhj/QOYKBtmJaKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qi+Jt6jn7GSo93UWd9H1qCcGVj/gdDPSgLvBiKnkFTHQe2nH25Dl+/gfjzGgPAKOqZ/8uW6NkOZ1AsZ79X3Qz+wir8TryoZG4QhYEvprtfSqj0c6R3yix7WOCp+WnT4RuOX/VXyiZn30FLRQ2zKnvJ/rbErURppJCNgeNc5LogE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYzxT/W0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYzxT/W0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD44AC4CECF;
	Tue,  3 Dec 2024 15:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239539;
	bh=N+4UDgK8WxeLgPe3K90SqvoXxKFvUhj/QOYKBtmJaKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYzxT/W09rmbJssWPcLugG4YQrQf0a+ZIQ36MCx2YjR8qJFMFQv+scVqEZ76G2nmb
	 WcHU3TsTG5ZnUAFYL6Al5shJ9kj7uV9HAN88BPfOS3d8hWoFY7jIdwBFlu6MQPBSvI
	 8jGFGnybUu4ZeDbtMtABTx2snNH8egvP2jGKPBT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 617/817] drm/amd/display: Fix null check for pipe_ctx->plane_state in dcn20_program_pipe
Date: Tue,  3 Dec 2024 15:43:09 +0100
Message-ID: <20241203144020.018676100@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 936c0ec076bc4..18c1e52924996 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -1922,9 +1922,9 @@ static void dcn20_program_pipe(
 				dc->res_pool->hubbub, pipe_ctx->plane_res.hubp->inst, pipe_ctx->hubp_regs.det_size);
 	}
 
-	if (pipe_ctx->update_flags.raw ||
-	    (pipe_ctx->plane_state && pipe_ctx->plane_state->update_flags.raw) ||
-	    pipe_ctx->stream->update_flags.raw)
+	if (pipe_ctx->plane_state && (pipe_ctx->update_flags.raw ||
+	    pipe_ctx->plane_state->update_flags.raw ||
+	    pipe_ctx->stream->update_flags.raw))
 		dcn20_update_dchubp_dpp(dc, pipe_ctx, context);
 
 	if (pipe_ctx->update_flags.bits.enable ||
-- 
2.43.0



