Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0E121FF26;
	Mon, 19 May 2025 21:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689768; cv=none; b=DX2RBhsARr5S6ov68oMf8IyT1hpcBQ9huvHLCUfHfV6cdn3NC4nSij8jnz93Zp2JRxK2ZzgF7ujuzUpI44/yvPUCSvErUz1lfpPRNV2eVxwGxkcbyItb60GzdrB0F6KpI/xDzldbVE5JV8XqgDNZeV74OCoGhv57K29xFo3IJXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689768; c=relaxed/simple;
	bh=NuT4lb9HhRhO8d1W8NrZyyNBQfpMACSsQp80N2WZK6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QCkfDzKg/ARGn9+6LZWReMrghybLWLgOAiNobfgOOQlXVRHjkZ7YoqTbbj2CVega0fy1k0LfumqtI6zhmj80R0VOBQfpaAuPW+qmh5fIFwh+2bIyisXIM5uWUuDiRpvIQEioj8OgMNUpbZNPynHCShFHyE/UFnI+d9eOwySJQ90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HiD2mWUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HiD2mWUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A4CC4CEED;
	Mon, 19 May 2025 21:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689768;
	bh=NuT4lb9HhRhO8d1W8NrZyyNBQfpMACSsQp80N2WZK6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiD2mWUs/DOl4hN6n3w10R+4/wVl5XnXlm8mVGeNj7To9tjVkBu4wxUWLxFe70MYs
	 Rfh3dPRRBh+Vo24Ypw9Ff7rpm+wcErO8wRIVK94KhicDOeB94gIxAzIYOF3V6nK/6F
	 dBHZYlCYjnaBcv1e5PdGy11gWLzBhFFbNX+OAyYkBiPcRwZB7n6TfupnOcfumuC45B
	 OIZGukrnmwEyza1HGXn0NN+ryYe5dpAPTvBxAQmnmTQ7tyQWWFfKuA5ns8Xpv8L7OO
	 pVqUKomg50MuG1OY7zxLWipeigLkqz4NyARn4+SuKFIoaKdV5juFJhUxMJMNpN2u+W
	 +tx7jj6SB5eXw==
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
Subject: [PATCH AUTOSEL 6.6 06/11] drm/amd/display: fix link_set_dpms_off multi-display MST corner case
Date: Mon, 19 May 2025 17:22:32 -0400
Message-Id: <20250519212237.1986368-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212237.1986368-1-sashal@kernel.org>
References: <20250519212237.1986368-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.91
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
index 4901e27f678bc..9b470812d96a5 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -145,6 +145,7 @@ void link_blank_dp_stream(struct dc_link *link, bool hw_init)
 void link_set_all_streams_dpms_off_for_link(struct dc_link *link)
 {
 	struct pipe_ctx *pipes[MAX_PIPES];
+	struct dc_stream_state *streams[MAX_PIPES];
 	struct dc_state *state = link->dc->current_state;
 	uint8_t count;
 	int i;
@@ -157,10 +158,18 @@ void link_set_all_streams_dpms_off_for_link(struct dc_link *link)
 
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

