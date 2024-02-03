Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E0F5027F;
	Sat,  3 Feb 2024 04:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933882; cv=none; b=rcK3VmPPazLo65e/YK6UuBHgixCs6pVpxjh7DPMrEAASh7yP5LZLRZyZV7uKgNvP3u3ruIezDCO8NeObKw6GyappeLvCUsD85xmjNAHyjWtjBOvgQx3NbPbHZ2XooS6mtfvUBgYnpbXUIn+K2A1AwW1RAn68HXmxD76KCunzyDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933882; c=relaxed/simple;
	bh=TQlsH6a8Nyygal1SM5q6497fayvp0FZKBRvs1aki9bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbagyLZCyIdp/bkL24i012RCrWW4rqWYVAy4Vqn2H5xDHnXvKP1Zhy8BR6FdcLlmOGsUfVOzQ6Lr9t5pPW6CXFTgVEys+N+149CHqeiF1utpFoI21vKwF17eE6dX1Z86dggydB3rcjsx/FmsPOTMn1dMTODNE42MHoVITvH05mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdVExNUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdVExNUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC12C433C7;
	Sat,  3 Feb 2024 04:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933882;
	bh=TQlsH6a8Nyygal1SM5q6497fayvp0FZKBRvs1aki9bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdVExNUC7N+SH3ZmRRuXWSuWK1or5jK3WkjnSyj3xp/oLm/RqOvT0e28Q+yOnXjAL
	 tQ7+TJciTFNA+4Fne2fJcjAhCN2VHPW4bMji7a2vf0OAw+Aqjs41aMRN+uIG7nWG8p
	 +MNhmKtkZ296dBslMSkJfmhi9kyrGxiwUgQIn1ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Michael Strauss <michael.strauss@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 222/353] drm/amd/display: Fix lightup regression with DP2 single display configs
Date: Fri,  2 Feb 2024 20:05:40 -0800
Message-ID: <20240203035410.701189540@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Michael Strauss <michael.strauss@amd.com>

[ Upstream commit 5a82b8d6c05f9b30828ede1b103b9ee5cb5c912e ]

[WHY]
Previous fix for multiple displays downstream of DP2 MST hub caused regression

[HOW]
Match sink IDs instead of sink struct addresses

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c
index 2498b8341199..d6a68484153c 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c
@@ -157,6 +157,14 @@ bool is_dp2p0_output_encoder(const struct pipe_ctx *pipe_ctx)
 {
 	/* If this assert is hit then we have a link encoder dynamic management issue */
 	ASSERT(pipe_ctx->stream_res.hpo_dp_stream_enc ? pipe_ctx->link_res.hpo_dp_link_enc != NULL : true);
+	/* Count MST hubs once by treating only 1st remote sink in topology as an encoder */
+	if (pipe_ctx->stream->link && pipe_ctx->stream->link->remote_sinks[0]) {
+		return (pipe_ctx->stream_res.hpo_dp_stream_enc &&
+			pipe_ctx->link_res.hpo_dp_link_enc &&
+			dc_is_dp_signal(pipe_ctx->stream->signal) &&
+			(pipe_ctx->stream->link->remote_sinks[0]->sink_id == pipe_ctx->stream->sink->sink_id));
+	}
+
 	return (pipe_ctx->stream_res.hpo_dp_stream_enc &&
 		pipe_ctx->link_res.hpo_dp_link_enc &&
 		dc_is_dp_signal(pipe_ctx->stream->signal));
-- 
2.43.0



