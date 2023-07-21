Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC5E1EA8A
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399B9C433CC;
	Fri, 21 Jul 2023 16:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956472;
	bh=EQbwecLsjpchFafumlf+UusN6K7dQRnk7+x4URAnUBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NK26Lt1KGkD4gc8djXGjXoPBdvj0e83HfTdRRrHIZ2zNx8IFejRtJVj8At1hrGl91
	 Yd5fUeOqr1ikxfEkO+uB2/prdmmQuxckwiP5GoRc5nKQ3/vXLbe1xYd5GIsNkq7VEB
	 wQE1t6GEKWJruW1feV+2QQIn2syZmopxGi4zu2MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Sung-huai Wang <danny.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 205/292] drm/amd/display: add a NULL pointer check
Date: Fri, 21 Jul 2023 18:05:14 +0200
Message-ID: <20230721160537.686538012@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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


