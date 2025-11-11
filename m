Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F499248F6A;
	Tue, 11 Nov 2025 01:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823111; cv=none; b=un1UrF2BOsYi2V/zknbTwKJd5qX86bb2D6Eq1ThH4KoPzrpT7gfppHpaNV+eE102liAuwOlV0T/aNzKw6fx7eC3PjwRwUPXdmkj9hdo+pgvw45roZ6D3FHxwOUFeazpC9CztzuewJTZZ7cRZV46o/MvQkpq7wZ/d0TqxNAblLwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823111; c=relaxed/simple;
	bh=mEAgeghi26RdhN9c60M1XklWBKEZ8jkBYHIfiLDra5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pk/fZG7SsO9nDWfeKaiMc79oYdtqAZ4J0EVPA2qr+GzcUXIPqO8lzL3pzYKqDy+iqAiZk8NdWbcQSvugTv3JTFzpyuHMymWeikryqWwRv72UEKxtvm8fqi5zVSDn3+ZA8OJYkNO9VlFel1lh50iaOLiyipPwoLHQSjeJB1/u8Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWMsJIsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWMsJIsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A568CC113D0;
	Tue, 11 Nov 2025 01:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823110;
	bh=mEAgeghi26RdhN9c60M1XklWBKEZ8jkBYHIfiLDra5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWMsJIskxFa5yUTs/9aq6jxzLZq0L6tZFGf8W9CmxogMw3DhDA0XLebF/tcK4Q47w
	 zGzZUquXqRt4aq2KeEdvkCCoU8lypTBSiq1JQd7pfXmOK+tzPXqYdX7msToqg8Brou
	 oMBhsiYvdY2j2SZ5JcwmF8USB2Xl37l2KEd78PGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Clay King <clayking@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 233/849] drm/amd/display: ensure committing streams is seamless
Date: Tue, 11 Nov 2025 09:36:43 +0900
Message-ID: <20251111004542.076441549@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clay King <clayking@amd.com>

[ Upstream commit ca74cc428f2b9d0170c56b473dbcfd7fa01daf2d ]

[Why]
When transitioning between topologies such as multi-display to single
display ODM 2:1, pipes might not be freed before use.

[How]
In dc_commit_streams, commit an additional, minimal transition if
original transition is not seamless to ensure pipes are freed.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Clay King <clayking@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index bb189f6773397..bc364792d9d31 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2413,6 +2413,18 @@ enum dc_status dc_commit_streams(struct dc *dc, struct dc_commit_streams_params
 		goto fail;
 	}
 
+	/*
+	 * If not already seamless, make transition seamless by inserting intermediate minimal transition
+	 */
+	if (dc->hwss.is_pipe_topology_transition_seamless &&
+			!dc->hwss.is_pipe_topology_transition_seamless(dc, dc->current_state, context)) {
+		res = commit_minimal_transition_state(dc, context);
+		if (res != DC_OK) {
+			BREAK_TO_DEBUGGER();
+			goto fail;
+		}
+	}
+
 	res = dc_commit_state_no_check(dc, context);
 
 	for (i = 0; i < params->stream_count; i++) {
-- 
2.51.0



