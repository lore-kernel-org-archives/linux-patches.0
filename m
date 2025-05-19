Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508C021D3C7;
	Mon, 19 May 2025 21:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689740; cv=none; b=uagBBhlf95fYMCWtQbgss60OPI6TFlZ6KNl0lDmvJoXugtPVEsZcYBLoLyYejTji8Z6To3+ToSQeAaaH2WWrmLXXD7/qXlPC36OzMsbSRSz6khSsGdFi3Osk5nlD2i8i3LzJQc0AkCGnDrIWbtrLRPJ9lMdj1ondFdSy7sJjjjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689740; c=relaxed/simple;
	bh=4JY+8/75ggDiBhyuCDTj7dW0Tf8j4uJMmdCW1I7v3/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=naSB60HpwLgzSl0QmHxGnTc4P0qqLhxbV0W+TAKysfcEU/r9zQfYlm7etVywIyMQdgc9QgqZG3d41ehPJXUEIChuOilfmL7lxMC+NVHmaR3oP+FoSKInfL85sX61ByjWAW6yxNtbEfl1JQgoj0rDaNVj2dbRuCO5TPLsutWLX5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHtkH1aU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHtkH1aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C80C4CEE4;
	Mon, 19 May 2025 21:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689740;
	bh=4JY+8/75ggDiBhyuCDTj7dW0Tf8j4uJMmdCW1I7v3/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHtkH1aUUPqmaZqHWtQtiabSJuPYeGgRsou8hl31Ky3qN5lgNWuOqv0iv4reh16vX
	 u13nxwNlzsJISrwZ8v8uq+kj5Ee4KIpMJ+q8tXqwe1bKxzUNckSkcgO3FQJzd2Ds0f
	 SlTRApa2sEkelE6W6bq+LOhEtq8a1CAiI5NPBSxendz/PA4tmpkEFopc1W+p450GfK
	 g7lqmc3Rg5LQPQ32WM/HnxrEUqmrT8I8mzlK1u5NikwmXWkDofetKzD24K2sF95kNA
	 XrmAYJPWSsrukKUuYMIQfJ+5LZaGW7lzbzIQjQKiCwl2+VZNIErf/hvQoJlUe/dY+Y
	 UAptQLCGeqdfQ==
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
Subject: [PATCH AUTOSEL 6.12 07/18] drm/amd/display: fix link_set_dpms_off multi-display MST corner case
Date: Mon, 19 May 2025 17:21:56 -0400
Message-Id: <20250519212208.1986028-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212208.1986028-1-sashal@kernel.org>
References: <20250519212208.1986028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.29
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
index c4e03482ba9ae..aa28001297675 100644
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

