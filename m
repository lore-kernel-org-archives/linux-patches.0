Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3A4248891;
	Mon, 23 Jun 2025 13:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686109; cv=none; b=GF36EZxcNo/FN8+76w0H1e2fVN45HHX+LA+Yf8twrTJNvbbwUvdhHAI/ENc0MY3CX9ZUqWldSrVQcRSalI1EY9wqhUVnoXmUql3m5rpKV7mNFVT7IEErNGU5V1pc20ZDtek1DilIY2jDQGV8t2HW//pdA6ena4iOVRRNGP6qxYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686109; c=relaxed/simple;
	bh=yfe9flI3bV5y+bJWBFdmxFJhLRsdUoMl2QcS814l5yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X11Z8Yn55V73h8yMyU80Yr8CQhI6feyAAPjqfoq8qB28KZEw7I74+sEismjYOnl763jTVHZUkNIj4FikLZynlEK9GMmqENt1+AWwEwsOMUpC1dD2Xy/WY1xSZ+HcdN/sIEsX3hnrJpK6R1mnTemyXBeyPwWANY75a0TvM7HvNGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QM7A1H0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QM7A1H0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4A6C4CEEA;
	Mon, 23 Jun 2025 13:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686109;
	bh=yfe9flI3bV5y+bJWBFdmxFJhLRsdUoMl2QcS814l5yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QM7A1H0iuqLKRsOygYUSDzTxaacOg8cW7WOhyIMu/1t0ro/sVDlca2kFMQ8N1hXZ8
	 NhEEDX5U5NTkD3jG43wA65mha5QlQpqopid7G9PZ7W7XakbNXaBVV96PU1pLuDPp4/
	 RJEUGM9wh23Qjt9GchoK2Ohx8eWCbGK4BhxmLEsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 267/592] drm/amd/display: Do Not Consider DSC if Valid Config Not Found
Date: Mon, 23 Jun 2025 15:03:45 +0200
Message-ID: <20250623130706.667671746@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 146a4429b5674b7520a96aea34233949731c6086 ]

[why]
In the mode validation, mst dsc is considered for bw calculation after
common dsc config is determined. Currently it considered common dsc config
is found if max and min target bpp are non zero which is not accurate. Invalid
max and min target bpp values would not get max_kbps and min_kbps calculated,
leading to falsefully pass a mode that does not have valid dsc parameters
available.

[how]
Use the return value of decide_dsc_bandwidth_range() to determine whether valid
dsc common config is found or not. Prune out modes that do not have valid common
dsc config determined.

Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 5cdbc86ef8f5a..25e8befbcc479 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1739,16 +1739,17 @@ static bool is_dsc_common_config_possible(struct dc_stream_state *stream,
 					  struct dc_dsc_bw_range *bw_range)
 {
 	struct dc_dsc_policy dsc_policy = {0};
+	bool is_dsc_possible;
 
 	dc_dsc_get_policy_for_timing(&stream->timing, 0, &dsc_policy, dc_link_get_highest_encoding_format(stream->link));
-	dc_dsc_compute_bandwidth_range(stream->sink->ctx->dc->res_pool->dscs[0],
-				       stream->sink->ctx->dc->debug.dsc_min_slice_height_override,
-				       dsc_policy.min_target_bpp * 16,
-				       dsc_policy.max_target_bpp * 16,
-				       &stream->sink->dsc_caps.dsc_dec_caps,
-				       &stream->timing, dc_link_get_highest_encoding_format(stream->link), bw_range);
-
-	return bw_range->max_target_bpp_x16 && bw_range->min_target_bpp_x16;
+	is_dsc_possible = dc_dsc_compute_bandwidth_range(stream->sink->ctx->dc->res_pool->dscs[0],
+							 stream->sink->ctx->dc->debug.dsc_min_slice_height_override,
+							 dsc_policy.min_target_bpp * 16,
+							 dsc_policy.max_target_bpp * 16,
+							 &stream->sink->dsc_caps.dsc_dec_caps,
+							 &stream->timing, dc_link_get_highest_encoding_format(stream->link), bw_range);
+
+	return is_dsc_possible;
 }
 #endif
 
-- 
2.39.5



