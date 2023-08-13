Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451009443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C256AC433C8;
	Sun, 13 Aug 2023 21:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961912;
	bh=YGoW/PHy7nHYaSfDFFpJzHl8mY5c3QhaI9n1Ynao008=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3Rx6+3/C8WdF/xdXMlU3UWGw62zGtTZhUpuFKdXNNiViaHQLIFglUjjr3Zbzt17y
	 rTrGTTmrpcrDPvEOX00Z5wDKIci/bA+r0JqcRaQAAP869UV1aMPYC0WXtvc00uhT0E
	 f4sSq7S1XkSmMl41bxJj1OcqTDGDLE40d6014eeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <Harry.Wentland@amd.com>,
	Klaus.Kusche@computerix.info,
	Mario Limonciello <mario.limonciello@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 044/206] drm/amd/display: Fix a regression on Polaris cards
Date: Sun, 13 Aug 2023 23:16:54 +0200
Message-ID: <20230813211726.253385925@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 3bb575572bf498a9d39e9d1ca5c06cc3152928a1 upstream.

DCE products don't define a `remove_stream_from_ctx` like DCN ones
do. This means that when compute_mst_dsc_configs_for_state() is called
it always returns -EINVAL which causes MST to fail to setup.

Cc: stable@vger.kernel.org # 6.4.y
Cc: Harry Wentland <Harry.Wentland@amd.com>
Reported-by: Klaus.Kusche@computerix.info
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/2671
Fixes: efa4c4df864e ("drm/amd/display: call remove_stream_from_ctx from res_pool funcs")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 9bc86deac9e8..b885c39bd16b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1320,7 +1320,7 @@ int compute_mst_dsc_configs_for_state(struct drm_atomic_state *state,
 		if (computed_streams[i])
 			continue;
 
-		if (!res_pool->funcs->remove_stream_from_ctx ||
+		if (res_pool->funcs->remove_stream_from_ctx &&
 		    res_pool->funcs->remove_stream_from_ctx(stream->ctx->dc, dc_state, stream) != DC_OK)
 			return -EINVAL;
 
-- 
2.41.0



