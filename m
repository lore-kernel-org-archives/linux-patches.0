Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657BA134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9A0C433C0;
	Mon, 26 Jun 2023 18:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803316;
	bh=i/P3ARdGPoW+wIi+D/wvlyDeGXM+LpDZa83HIYtpyLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1exCkjHnj25+ShW36jNMSZMDw1ooKXG/3QgNF/rye3JqNLObVgySjETX4TJywxRG+
	 SqYObDkfVA9/6a7NZ+EZb0y8FcGst4k3rrN0PdMuh/c6NtO3BlZZE7Sh5Zo6+XXa5J
	 pnci/42oPnVpgHDLw4TesGzhoYXXNeQ/FCNCalb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <Harry.Wentland@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 002/199] drm/amd/display: Use dc_update_planes_and_stream
Date: Mon, 26 Jun 2023 20:08:28 +0200
Message-ID: <20230626180805.757504509@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
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

[ Upstream commit f7511289821ffccc07579406d6ab520aa11049f5 ]

[Why & How]
The old dc_commit_updates_for_stream lacks manipulation for many corner
cases where the DC feature requires special attention; as a result, it
starts to show its limitation (e.g., the SubVP feature is not supported
by it, among other cases). To modernize and unify our internal API, this
commit replaces the old dc_commit_updates_for_stream with
dc_update_planes_and_stream, which has more features.

Reviewed-by: Harry Wentland <Harry.Wentland@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: ea2062dd1f03 ("drm/amd/display: fix the system hang while disable PSR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 30 +++++++++----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 289c261ffe876..ae58f24be511c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2683,10 +2683,12 @@ static void dm_gpureset_commit_state(struct dc_state *dc_state,
 			bundle->surface_updates[m].surface->force_full_update =
 				true;
 		}
-		dc_commit_updates_for_stream(
-			dm->dc, bundle->surface_updates,
+
+		dc_update_planes_and_stream(dm->dc,
+			bundle->surface_updates,
 			dc_state->stream_status->plane_count,
-			dc_state->streams[k], &bundle->stream_update, dc_state);
+			dc_state->streams[k],
+			&bundle->stream_update);
 	}
 
 cleanup:
@@ -8198,12 +8200,11 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 				acrtc_state->stream->link->psr_settings.psr_allow_active)
 			amdgpu_dm_psr_disable(acrtc_state->stream);
 
-		dc_commit_updates_for_stream(dm->dc,
-						     bundle->surface_updates,
-						     planes_count,
-						     acrtc_state->stream,
-						     &bundle->stream_update,
-						     dc_state);
+		dc_update_planes_and_stream(dm->dc,
+					    bundle->surface_updates,
+					    planes_count,
+					    acrtc_state->stream,
+					    &bundle->stream_update);
 
 		/**
 		 * Enable or disable the interrupts on the backend.
@@ -8741,12 +8742,11 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 
 
 		mutex_lock(&dm->dc_lock);
-		dc_commit_updates_for_stream(dm->dc,
-						     dummy_updates,
-						     status->plane_count,
-						     dm_new_crtc_state->stream,
-						     &stream_update,
-						     dc_state);
+		dc_update_planes_and_stream(dm->dc,
+					    dummy_updates,
+					    status->plane_count,
+					    dm_new_crtc_state->stream,
+					    &stream_update);
 		mutex_unlock(&dm->dc_lock);
 	}
 
-- 
2.39.2



