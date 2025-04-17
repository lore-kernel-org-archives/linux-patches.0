Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347872528FA;
	Thu, 17 Apr 2025 18:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915470; cv=none; b=CdC2ZW6d1Py27WWqmooYmabBWYEm6V7Z6hsxuCWsA15OKCBQY9ZJcS6QtVoI8Cge7cHH3etPyETBM3mRxMtD5cRrrOY3GjYAcqfR+F1famWXJ6fnp7FZoUgW5MjCVqzGpvpBxwdDK8pP1VA7PBISMoJoXCSoW8dnVKc3vNw8IKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915470; c=relaxed/simple;
	bh=nl7LZmtqiBUmONXaY2OxTyjqYnNRPAZjJMq3XOWKJME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePPLVghDOm62CNlEuCrk8MrXUlBYuPPNpvoNnvxMyWrDwuRhxyq3Hrem70Sm7vpmJdMQ/u+AYHCqVqGwCvCDF5UqAmt+B6+BmqmUtTg2WrFpIfxUOJ/WuXZj9vLghJN/45CmaZhRGaNBGgHg4rfRhF0jeSNr1X5tKw/edn57770=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USMvGUzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USMvGUzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908E0C4CEEA;
	Thu, 17 Apr 2025 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915470;
	bh=nl7LZmtqiBUmONXaY2OxTyjqYnNRPAZjJMq3XOWKJME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USMvGUzTPjGzXK7PaaHFcx9hQ0Wvgp88JCrOJKk0Zfg8HTAx7DhKKNt9eG67aZVln
	 676sPICEMsoeFAMXh7GHwG4gckijdnFGgm9a31gTQXdOa0C8XLIA8Wwjz03Whk+bAN
	 QrFCA4yaOpLkz97LpnyZzkSiceOq9NiM4tJ62VoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Mike Katsnelson <mike.katsnelson@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/393] drm/amd/display: stop DML2 from removing pipes based on planes
Date: Thu, 17 Apr 2025 19:49:07 +0200
Message-ID: <20250417175113.138238369@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Katsnelson <mike.katsnelson@amd.com>

[ Upstream commit 8adeff83a3b07fa6d0958ed51e1b38ba7469e448 ]

[Why]
Transitioning from low to high resolutions at high refresh rates caused grey corruption.
During the transition state, there is a period where plane size is based on low resultion
state and ODM slices are based on high resoultion state, causing the entire plane to be
contained in one ODM slice. DML2 would turn off the pipe for the ODM slice with no plane,
causing an underflow since the pixel rate for the higher resolution cannot be supported on
one pipe. This change stops DML2 from turning off pipes that are mapped to an ODM slice
with no plane. This is possible to do without negative consequences because pipes can now
take the minimum viewport and draw with zero recout size, removing the need to have the
pipe turned off.

[How]
In map_pipes_from_plane(), remove "check" that skips ODM slices that are not covered by
the plane. This prevents the pipes for those ODM slices from being freed.

Reviewed-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Mike Katsnelson <mike.katsnelson@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/dml2/dml2_dc_resource_mgmt.c   | 26 -------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_dc_resource_mgmt.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_dc_resource_mgmt.c
index 1ed21c1b86a5b..a966abd407881 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_dc_resource_mgmt.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_dc_resource_mgmt.c
@@ -532,26 +532,6 @@ static void calculate_odm_slices(const struct dc_stream_state *stream, unsigned
 	odm_slice_end_x[odm_factor - 1] = stream->src.width - 1;
 }
 
-static bool is_plane_in_odm_slice(const struct dc_plane_state *plane, unsigned int slice_index, unsigned int *odm_slice_end_x, unsigned int num_slices)
-{
-	unsigned int slice_start_x, slice_end_x;
-
-	if (slice_index == 0)
-		slice_start_x = 0;
-	else
-		slice_start_x = odm_slice_end_x[slice_index - 1] + 1;
-
-	slice_end_x = odm_slice_end_x[slice_index];
-
-	if (plane->clip_rect.x + plane->clip_rect.width < slice_start_x)
-		return false;
-
-	if (plane->clip_rect.x > slice_end_x)
-		return false;
-
-	return true;
-}
-
 static void add_odm_slice_to_odm_tree(struct dml2_context *ctx,
 		struct dc_state *state,
 		struct dc_pipe_mapping_scratch *scratch,
@@ -791,12 +771,6 @@ static void map_pipes_for_plane(struct dml2_context *ctx, struct dc_state *state
 	sort_pipes_for_splitting(&scratch->pipe_pool);
 
 	for (odm_slice_index = 0; odm_slice_index < scratch->odm_info.odm_factor; odm_slice_index++) {
-		// We build the tree for one ODM slice at a time.
-		// Each ODM slice shares a common OPP
-		if (!is_plane_in_odm_slice(plane, odm_slice_index, scratch->odm_info.odm_slice_end_x, scratch->odm_info.odm_factor)) {
-			continue;
-		}
-
 		// Now we have a list of all pipes to be used for this plane/stream, now setup the tree.
 		scratch->odm_info.next_higher_pipe_for_odm_slice[odm_slice_index] = add_plane_to_blend_tree(ctx, state,
 				plane,
-- 
2.39.5



