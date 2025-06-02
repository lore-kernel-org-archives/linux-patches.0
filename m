Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D9E1C5D72;
	Mon,  2 Jun 2025 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872752; cv=none; b=Oha+0msjdc7Xe2OYtPernwSxOOgf5YNi7ADGL8iqL1q3nMeJ1pr0mi/TOi12agGzUD5/4eW/kqgSvVDawaxu2eScKy0UkfphkMRtpinQbBIV44PHve8p2Jh9X9CwAS80a7sOBPJfs65Kg/8eD1jHtR5x9bW68QEi986OU8YBEiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872752; c=relaxed/simple;
	bh=IOprf9IWIu0JGZ9ocYgP1jS9A0FCp3gXvDh/CeSt2+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMosGHeufyxyyVb7E+7/jHWpUTLw4aotMqZpC6Qq1o2T86on9fbQpCyk/kNTlItYW+IcbyYY6Ddcy4YTXzRwkh4BlBuTKZ5vjMV1szlz4f4B9YiHjyPcu2xmVfctFDXBhWk4fxKUgyVIPd93ST3FlsYe5gLItcvUhmP/Df6nzt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVFgI5TO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVFgI5TO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA442C4CEF5;
	Mon,  2 Jun 2025 13:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872752;
	bh=IOprf9IWIu0JGZ9ocYgP1jS9A0FCp3gXvDh/CeSt2+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVFgI5TO+l6MnYIJGZNiNUetvJems3ZK7VBKtCJtnAas1D4Xj7waEP3kIFRqWKEuM
	 t71v5pzwNdKf11P+g3Fg593l62XrRjF9cJLxXxkqFVkJ0rXWuAnKqETlLw64yCFPZa
	 IkqWBBCl7lnIcH3GUGXp8vTmiPH/qg0P04oL/8vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	George Shen <george.shen@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 57/73] drm/amd/display: fix link_set_dpms_off multi-display MST corner case
Date: Mon,  2 Jun 2025 15:47:43 +0200
Message-ID: <20250602134243.940265872@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

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



