Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9716C8F8
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6448CC433C8;
	Mon, 26 Jun 2023 18:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804701;
	bh=M26HKupsejBWg5UI81erau+TMbQIXTHPjsVtfGpMoss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nryGU42j3wyDAUFsMqd9O3ZV0Je7O2vEvVb3iOzlhaCnw0r62tPnW9Rf0ATMb2yHq
	 2M56fcAk+FcgiNGV5ZwXzi/uSGGYsupl7VZ2JgoMb5h2Sm1oNrXZVDnWf0rMgkpwS2
	 2x1GU+lkknEznAK8d1ryLKCFrzs2sD26JkJGq2eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <Harry.Wentland@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 05/96] drm/amd/display: Use dc_update_planes_and_stream
Date: Mon, 26 Jun 2023 20:11:20 +0200
Message-ID: <20230626180747.161922880@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
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

commit f7511289821ffccc07579406d6ab520aa11049f5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   30 +++++++++++-----------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2550,10 +2550,12 @@ static void dm_gpureset_commit_state(str
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
@@ -9238,12 +9240,11 @@ static void amdgpu_dm_commit_planes(stru
 		}
 		mutex_lock(&dm->dc_lock);
 
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
@@ -9669,12 +9670,11 @@ static void amdgpu_dm_atomic_commit_tail
 
 
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
 


