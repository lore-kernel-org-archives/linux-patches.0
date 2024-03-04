Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBD71F60A;
	Mon,  4 Mar 2024 21:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587766; cv=none; b=jS8S8q9xkKtj7u9K/dF11EZUc7jtrsiKUshzACVpoiq2xiCPEw2IFhN6AqqYZTjTWb/c4N6uvtHsZakuA2PKcgAQZCpA/k5yb0M8+a/DrUmFElQhhveRVKo/avwLEZp9fEFLWXV1cGueFxj2PK9eJga25NIC66WJUCijeBc8hlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587766; c=relaxed/simple;
	bh=tTCTzMgLzAIkStGicEz0hSjAZhzOg5ZbnYM/KjFpto4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pE0c9u7QnAifLLiYqksnNUSeLE9Zp+gX2bSnHje3zMCsPZ7yqSoJGEfZ8ZfXVaGDdoS9/mbGHwLRoItHXpBbK+Qr7IAy7aEshd6VVVgJUzTtNFQ/2HQ3uh36ka1SIHvkbOz216FmQ9Am3WFB1/YJfqAB6RP60iNy/CcFDVU+Kyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eilz6cps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eilz6cps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204F7C433F1;
	Mon,  4 Mar 2024 21:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587766;
	bh=tTCTzMgLzAIkStGicEz0hSjAZhzOg5ZbnYM/KjFpto4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eilz6cpsnQt66f3rPmszU8GSOTxJBdrp8LXufAlyfOr0Xxsaur0KJmz1XS5T3F76X
	 U39M9STxyTMt6SqqhGFUUeba7o4/CHAvEFjhDlJqKmWm4EJOHyMgvigkP8HsRc2V2z
	 Lvp7Y1PBDXV0hqDjAAbsOchUYZGaKx6ItaF9VGrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Qingqing Zhuo <Qingqing.Zhuo@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 064/162] drm/amd/display: Prevent potential buffer overflow in map_hw_resources
Date: Mon,  4 Mar 2024 21:22:09 +0000
Message-ID: <20240304211553.900522211@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 0f8ca019544a252d1afb468ce840c6dcbac73af4 ]

Adds a check in the map_hw_resources function to prevent a potential
buffer overflow. The function was accessing arrays using an index that
could potentially be greater than the size of the arrays, leading to a
buffer overflow.

Adds a check to ensure that the index is within the bounds of the
arrays. If the index is out of bounds, an error message is printed and
break it will continue execution with just ignoring extra data early to
prevent the buffer overflow.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml2_wrapper.c:79 map_hw_resources() error: buffer overflow 'dml2->v20.scratch.dml_to_dc_pipe_mapping.disp_cfg_to_stream_id' 6 <= 7
drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml2_wrapper.c:81 map_hw_resources() error: buffer overflow 'dml2->v20.scratch.dml_to_dc_pipe_mapping.disp_cfg_to_plane_id' 6 <= 7

Fixes: 7966f319c66d ("drm/amd/display: Introduce DML2")
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Qingqing Zhuo <Qingqing.Zhuo@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Suggested-by: Roman Li <roman.li@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
index 8f231418870f2..c62b61ac45d27 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
@@ -76,6 +76,11 @@ static void map_hw_resources(struct dml2_context *dml2,
 			in_out_display_cfg->hw.DLGRefClkFreqMHz = 50;
 		}
 		for (j = 0; j < mode_support_info->DPPPerSurface[i]; j++) {
+			if (i >= __DML2_WRAPPER_MAX_STREAMS_PLANES__) {
+				dml_print("DML::%s: Index out of bounds: i=%d, __DML2_WRAPPER_MAX_STREAMS_PLANES__=%d\n",
+					  __func__, i, __DML2_WRAPPER_MAX_STREAMS_PLANES__);
+				break;
+			}
 			dml2->v20.scratch.dml_to_dc_pipe_mapping.dml_pipe_idx_to_stream_id[num_pipes] = dml2->v20.scratch.dml_to_dc_pipe_mapping.disp_cfg_to_stream_id[i];
 			dml2->v20.scratch.dml_to_dc_pipe_mapping.dml_pipe_idx_to_stream_id_valid[num_pipes] = true;
 			dml2->v20.scratch.dml_to_dc_pipe_mapping.dml_pipe_idx_to_plane_id[num_pipes] = dml2->v20.scratch.dml_to_dc_pipe_mapping.disp_cfg_to_plane_id[i];
-- 
2.43.0



