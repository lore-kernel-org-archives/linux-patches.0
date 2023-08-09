Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3D6174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60186C433C8;
	Wed,  9 Aug 2023 10:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578599;
	bh=LlGtfBhE9IZR1o1wo2WVxe0E8PDg39/X2N1pBj8VWnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgucIjFUsdGkh9uJUig5ic0Fe69LzXk+gYvH0vnH8QkB6TDKD/3Ao3V2vtsBDNVbI
	 +KTdEwq8un+Iv5sBiD46sxb7SHlChz7uYBUcODdeNmd9F5sErTKhfiRizyBUCph0YZ
	 pkQW3051/sN/mSfsXl8RmjW64tsY7Q46U2II9mCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Shen <George.Shen@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Peichen Huang <PeiChen.Huang@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 118/127] drm/amd/display: skip CLEAR_PAYLOAD_ID_TABLE if device mst_en is 0
Date: Wed,  9 Aug 2023 12:41:45 +0200
Message-ID: <20230809103640.519019782@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peichen Huang <PeiChen.Huang@amd.com>

commit a1c9a1e27022d13c70a14c4faeab6ce293ad043b upstream.

[Why]
Some dock and mst monitor don't like to receive CLEAR_PAYLOAD_ID_TABLE
when mst_en is set to 0. It doesn't make sense to do so in source
side, either.

[How]
Don't send CLEAR_PAYLOAD_ID_TABLE if mst_en is 0

Reviewed-by: George Shen <George.Shen@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Peichen Huang <PeiChen.Huang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ 6.1.y doesn't have the file rename from
  54618888d1ea7 ("drm/amd/display: break down dc_link.c") ]
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -2092,6 +2092,7 @@ static enum dc_status enable_link_dp_mst
 		struct pipe_ctx *pipe_ctx)
 {
 	struct dc_link *link = pipe_ctx->stream->link;
+	unsigned char mstm_cntl;
 
 	/* sink signal type after MST branch is MST. Multiple MST sinks
 	 * share one link. Link DP PHY is enable or training only once.
@@ -2100,7 +2101,9 @@ static enum dc_status enable_link_dp_mst
 		return DC_OK;
 
 	/* clear payload table */
-	dm_helpers_dp_mst_clear_payload_allocation_table(link->ctx, link);
+	core_link_read_dpcd(link, DP_MSTM_CTRL, &mstm_cntl, 1);
+	if (mstm_cntl & DP_MST_EN)
+		dm_helpers_dp_mst_clear_payload_allocation_table(link->ctx, link);
 
 	/* to make sure the pending down rep can be processed
 	 * before enabling the link


