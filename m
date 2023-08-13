Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326179446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C42C433C8;
	Sun, 13 Aug 2023 21:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962478;
	bh=B5/TGXiFgftkeJfHdpd4CJwxcB49HhSZvGtdb5vFrYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9RiY9YabhFpz/Qf3JaGgQ3QuAJFUT6SvLyfAYp/6ILjijihy+nQL3eE6xHnHOGiD
	 ORZovLbSoeoPM2TOgf8ZvWQvbzfyRMte0m5ZF1uJ1BaTPaInDi5U+bEMg4zBVJ33aV
	 flhr+2nK7qbsZkWB0mYZ7hHakKq58mLR1urGRMkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 043/149] drm/amd/display: Handle seamless boot stream
Date: Sun, 13 Aug 2023 23:18:08 +0200
Message-ID: <20230813211720.100146543@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

commit 170390e587a69b2a24abac39eb3ae6ec28a4d7f2 upstream

A seamless boot stream has hardware resources assigned to it, and adding
a new stream means rebuilding the current assignment. It is desirable to
avoid this situation since it may cause light-up issues on the VGA
monitor on USB-C. This commit swaps the seamless boot stream to pipe 0
(if necessary) to ensure that the pipe context matches.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Co-developed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2788,6 +2788,21 @@ enum dc_status dc_validate_with_context(
 			goto fail;
 	}
 
+	/* Swap seamless boot stream to pipe 0 (if needed) to ensure pipe_ctx
+	 * matches. This may change in the future if seamless_boot_stream can be
+	 * multiple.
+	 */
+	for (i = 0; i < add_streams_count; i++) {
+		mark_seamless_boot_stream(dc, add_streams[i]);
+		if (add_streams[i]->apply_seamless_boot_optimization && i != 0) {
+			struct dc_stream_state *temp = add_streams[0];
+
+			add_streams[0] = add_streams[i];
+			add_streams[i] = temp;
+			break;
+		}
+	}
+
 	/* Add new streams and then add all planes for the new stream */
 	for (i = 0; i < add_streams_count; i++) {
 		calculate_phy_pix_clks(add_streams[i]);


