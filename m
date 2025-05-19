Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A752A221284;
	Mon, 19 May 2025 21:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689707; cv=none; b=uOfwXBEC+eLdMExM0AzHsbUxf1zLIlLY/JEVFCX+tIAMRLdowyCQ8trJlf0xIEhRHOgTwycRkCBLNystCFJ0+Bmjtc2VmhdEZO/amvBSwMPh+L7wnXaalSPGMKKpH9EYtpLOO9rVVHjoAKtnrhRe+Eww6JDeS4IoYSBNfekvtdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689707; c=relaxed/simple;
	bh=H23H+mpcL8SHm2I4A3L8pf8bltvgAwtxp/DyOc76IU4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MxpDkCsvNDvaEMjqH6InnrnTRebVGoWXMT7HDz7a3+J27SfD1TDH05SeY1gy2d3lkJXJH0aFNdn/1hsr23XSAxMyYkiDrRz1M0c1UuHN5TJRtldi+txUbKI8hF0PnUG5vlxxku1/SxfDGMJCVPvFx9CgkCEMieOikXmTUMg37fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WFn9euy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WFn9euy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D127DC4CEE4;
	Mon, 19 May 2025 21:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689707;
	bh=H23H+mpcL8SHm2I4A3L8pf8bltvgAwtxp/DyOc76IU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFn9euy1Xux7tU6/4R2PJ3V0uR7Bq1eGZXthwOd1hwAM9PTtMdSLE9yb5uS9loWRP
	 rmEikdPc/ZpwZx1LPTPbX6PJT5sRvjx3wn6WR2x837JmYzMGmEG+aFyg/JS6vIt2G6
	 4kxwU2XeWGyOAVEHC+MwwOrZwvrQBt4lli3shCbPKRNtkZL/BOrBobnSANsysU/7m3
	 fJOKEP0vpSlqAovN3EVj3/UB92rtpoIGKwATGvcAYXilQpzm5CJ+Ati5VF0NKoMreR
	 Oki+obGN8Wq7qQx30iPnb7aQ58HJGUJAUp3BewAqYKpKsz47pCO4zSZ1zivdCBzkA1
	 nyFhJSvUrhy8Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: George Shen <george.shen@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	David1.Zhou@amd.com,
	airlied@linux.ie,
	daniel@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 10/23] drm/amd/display: fix link_set_dpms_off multi-display MST corner case
Date: Mon, 19 May 2025 17:21:17 -0400
Message-Id: <20250519212131.1985647-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212131.1985647-1-sashal@kernel.org>
References: <20250519212131.1985647-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.7
Content-Transfer-Encoding: 8bit

From: George Shen <george.shen@amd.com>

[ Upstream commit 3c1a467372e0c356b1d3c59f6d199ed5a6612dd1 ]

[Why & How]
When MST config is unplugged/replugged too quickly, it can potentially
result in a scenario where previous DC state has not been reset before
the HPD link detection sequence begins. In this case, driver will
disable the streams/link prior to re-enabling the link for link
training.

There is a bug in the current logic that does not account for the fact
that current_state can be released and cleared prior to swapping to a
new state (resulting in the pipe_ctx stream pointers to be cleared) in
between disabling streams.

To resolve this, cache the original streams prior to committing any
stream updates.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1561782686ccc36af844d55d31b44c938dd412dc)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
index ec7de9c01fab0..e95ec72b4096c 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -148,6 +148,7 @@ void link_blank_dp_stream(struct dc_link *link, bool hw_init)
 void link_set_all_streams_dpms_off_for_link(struct dc_link *link)
 {
 	struct pipe_ctx *pipes[MAX_PIPES];
+	struct dc_stream_state *streams[MAX_PIPES];
 	struct dc_state *state = link->dc->current_state;
 	uint8_t count;
 	int i;
@@ -160,10 +161,18 @@ void link_set_all_streams_dpms_off_for_link(struct dc_link *link)
 
 	link_get_master_pipes_with_dpms_on(link, state, &count, pipes);
 
+	/* The subsequent call to dc_commit_updates_for_stream for a full update
+	 * will release the current state and swap to a new state. Releasing the
+	 * current state results in the stream pointers in the pipe_ctx structs
+	 * to be zero'd. Hence, cache all streams prior to dc_commit_updates_for_stream.
+	 */
+	for (i = 0; i < count; i++)
+		streams[i] = pipes[i]->stream;
+
 	for (i = 0; i < count; i++) {
-		stream_update.stream = pipes[i]->stream;
+		stream_update.stream = streams[i];
 		dc_commit_updates_for_stream(link->ctx->dc, NULL, 0,
-				pipes[i]->stream, &stream_update,
+				streams[i], &stream_update,
 				state);
 	}
 
-- 
2.39.5

