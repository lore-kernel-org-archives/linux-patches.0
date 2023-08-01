Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9024D1F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BA2C433C8;
	Tue,  1 Aug 2023 09:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882239;
	bh=Pz3YqO73rXJKqjcY8D2uZ0PO5Tvlicb3eF3JALTnjMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zb3miEdFHvy47dahOl6e1JAwBABmFwEiX43imE3t6nmEQMAlXvwcE/sS6R852hGCW
	 +qd489D/lWDBnRTbha7UfUL4kQ5pLTWAdMpoOYN9Ij8F1mGaXHeUCEbypLV5DGCcbe
	 iOltPrb34tlo3oXnQxhbTKo6OwvoHJ6BLGHIq70o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/228] drm/amd/display: Rework context change check
Date: Tue,  1 Aug 2023 11:18:13 +0200
Message-ID: <20230801091924.160281645@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
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

[ Upstream commit 10fdb0a11c555e0d6f7698d2874581d06e99ee71 ]

Context change is all about streams; for this reason, this commit
renames context_changed to streams_changed. Additionally, to make this
function more flexible, this commit changes the function signature to
receive the stream array and the stream count as a parameter.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Co-developed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 59de751e3845 ("drm/amd/display: add ODM case when looking for first split pipe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index beb2d7f103c58..226c17e78d3e1 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1505,19 +1505,19 @@ static void program_timing_sync(
 	}
 }
 
-static bool context_changed(
-		struct dc *dc,
-		struct dc_state *context)
+static bool streams_changed(struct dc *dc,
+			    struct dc_stream_state *streams[],
+			    uint8_t stream_count)
 {
 	uint8_t i;
 
-	if (context->stream_count != dc->current_state->stream_count)
+	if (stream_count != dc->current_state->stream_count)
 		return true;
 
 	for (i = 0; i < dc->current_state->stream_count; i++) {
-		if (dc->current_state->streams[i] != context->streams[i])
+		if (dc->current_state->streams[i] != streams[i])
 			return true;
-		if (!context->streams[i]->link->link_state_valid)
+		if (!streams[i]->link->link_state_valid)
 			return true;
 	}
 
@@ -1918,7 +1918,7 @@ bool dc_commit_state(struct dc *dc, struct dc_state *context)
 	enum dc_status result = DC_ERROR_UNEXPECTED;
 	int i;
 
-	if (!context_changed(dc, context))
+	if (!streams_changed(dc, context->streams, context->stream_count))
 		return DC_OK;
 
 	DC_LOG_DC("%s: %d streams\n",
-- 
2.39.2



