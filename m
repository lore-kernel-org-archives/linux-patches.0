Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283213DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x94TafQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A32C433CB;
	Wed, 15 Nov 2023 19:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078171;
	bh=btxosYFxH7OX3A6cBcvNWbQMkD5BZZet6A2K+YF9NI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x94TafQQ5o7Y6Gme62DnDn9e5XUw9kOYMRvyNer7+2Mj689uskjz4W5ty8296C8yu
	 yAJEyA/A3LYy/Df3dS6Gl0xb2iYYFE2oWLurPxv888b0nQLCk7Ylj8R3vqmps5evUp
	 r4xyZV4aPcV/xVW4OXrGYlY3qIazaiXFRybwRg94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/379] drm/amd/display: Refactor dm_get_plane_scale helper
Date: Wed, 15 Nov 2023 14:23:32 -0500
Message-ID: <20231115192653.230716099@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Dänzer <mdaenzer@redhat.com>

[ Upstream commit ec4d770bbb155674c2497f255f4199bdc42287a9 ]

Cleanup, no functional change intended.

Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: bc0b79ce2050 ("drm/amd/display: Bail from dm_check_crtc_cursor if no relevant change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 23 +++++++++++--------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ebd07e3f12571..73db46b9e3e1a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9626,6 +9626,17 @@ static void dm_get_oriented_plane_size(struct drm_plane_state *plane_state,
 	}
 }
 
+static void
+dm_get_plane_scale(struct drm_plane_state *plane_state,
+		   int *out_plane_scale_w, int *out_plane_scale_h)
+{
+	int plane_src_w, plane_src_h;
+
+	dm_get_oriented_plane_size(plane_state, &plane_src_w, &plane_src_h);
+	*out_plane_scale_w = plane_state->crtc_w * 1000 / plane_src_w;
+	*out_plane_scale_h = plane_state->crtc_h * 1000 / plane_src_h;
+}
+
 static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 				struct drm_crtc *crtc,
 				struct drm_crtc_state *new_crtc_state)
@@ -9634,8 +9645,6 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 	struct drm_plane_state *new_cursor_state, *new_underlying_state;
 	int i;
 	int cursor_scale_w, cursor_scale_h, underlying_scale_w, underlying_scale_h;
-	int cursor_src_w, cursor_src_h;
-	int underlying_src_w, underlying_src_h;
 
 	/* On DCE and DCN there is no dedicated hardware cursor plane. We get a
 	 * cursor per pipe but it's going to inherit the scaling and
@@ -9650,9 +9659,7 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 	if (!new_cursor_state->fb)
 		return 0;
 
-	dm_get_oriented_plane_size(new_cursor_state, &cursor_src_w, &cursor_src_h);
-	cursor_scale_w = new_cursor_state->crtc_w * 1000 / cursor_src_w;
-	cursor_scale_h = new_cursor_state->crtc_h * 1000 / cursor_src_h;
+	dm_get_plane_scale(new_cursor_state, &cursor_scale_w, &cursor_scale_h);
 
 	/* Need to check all enabled planes, even if this commit doesn't change
 	 * their state
@@ -9670,10 +9677,8 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 		if (!new_underlying_state->fb)
 			continue;
 
-		dm_get_oriented_plane_size(new_underlying_state,
-					   &underlying_src_w, &underlying_src_h);
-		underlying_scale_w = new_underlying_state->crtc_w * 1000 / underlying_src_w;
-		underlying_scale_h = new_underlying_state->crtc_h * 1000 / underlying_src_h;
+		dm_get_plane_scale(new_underlying_state,
+				   &underlying_scale_w, &underlying_scale_h);
 
 		if (cursor_scale_w != underlying_scale_w ||
 		    cursor_scale_h != underlying_scale_h) {
-- 
2.42.0



