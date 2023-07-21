Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EF820F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEFFC433C8;
	Fri, 21 Jul 2023 19:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967403;
	bh=EQbwecLsjpchFafumlf+UusN6K7dQRnk7+x4URAnUBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NiXykNjpa3t7HfWHR8eyCC1DVWU/gIfpqAiLnkxyp57Qw6HalmJZRMpHIedNLzED
	 5fW/rlwj2ykW/uyWy6hSJCnJClKOFev6p77YVuPRMIk0oRWA6zo1qBsd9c27RolUox
	 eVox3BXJjxIeKYNdnyvR6PBqLeJpULgO98QkurRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Sung-huai Wang <danny.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 151/223] drm/amd/display: add a NULL pointer check
Date: Fri, 21 Jul 2023 18:06:44 +0200
Message-ID: <20230721160527.308683491@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sung-huai Wang <danny.wang@amd.com>

commit 0f48a4b83610cb0e4e0bc487800ab69f51b4aca6 upstream.

[Why & How]

We have to check if stream is properly initialized before calling
find_matching_pll(), otherwise we might end up trying to deferecence a
NULL pointer.

Cc: stable@vger.kernel.org # 6.1+
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Sung-huai Wang <danny.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce112/dce112_resource.c
@@ -970,10 +970,12 @@ enum dc_status resource_map_phy_clock_re
 		|| dc_is_virtual_signal(pipe_ctx->stream->signal))
 		pipe_ctx->clock_source =
 				dc->res_pool->dp_clock_source;
-	else
-		pipe_ctx->clock_source = find_matching_pll(
-			&context->res_ctx, dc->res_pool,
-			stream);
+	else {
+		if (stream && stream->link && stream->link->link_enc)
+			pipe_ctx->clock_source = find_matching_pll(
+				&context->res_ctx, dc->res_pool,
+				stream);
+	}
 
 	if (pipe_ctx->clock_source == NULL)
 		return DC_NO_CLOCK_SOURCE_RESOURCE;


