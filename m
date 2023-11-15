Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8915D3C470
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1Z38ubK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36157C433C9;
	Wed, 15 Nov 2023 19:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077350;
	bh=npQX86jKV2lidGUJf3jEyJGyScyQSr/l3UgeyDdZ68c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1Z38ubKKcAZO3wCpVme4fvqtgQceBLxGZ9fn6b68GFBQY7AONZYGxRre1oYfsHiE
	 pQ6AfTNiUifNucdCYCGwWXZ0XtHAQEDN46AiFZGakcae0ezhexvUXs+KTdodsuWkLP
	 PxasKiszACGWxO49a924+txRd6iHlRpA5gj/GEOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/603] drm/amd/display: Bail from dm_check_crtc_cursor if no relevant change
Date: Wed, 15 Nov 2023 14:13:13 -0500
Message-ID: <20231115191630.415515540@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Dänzer <mdaenzer@redhat.com>

[ Upstream commit bc0b79ce2050aa523c38c96b6d26340a96bfbdca ]

If no plane was newly enabled or changed scaling, there can be no new
scaling mismatch with the cursor plane.

By not pulling non-cursor plane states into all atomic commits while
the cursor plane is enabled, this avoids synchronizing all cursor plane
changes to vertical blank, which caused the following IGT tests to fail:

kms_cursor_legacy@cursor-vs-flip.*
kms_cursor_legacy@flip-vs-cursor.*

Fixes: 003048ddf44b ("drm/amd/display: Check all enabled planes in dm_check_crtc_cursor")
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 33 ++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 70477a6b896ab..34f011cedd065 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9906,10 +9906,12 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 				struct drm_crtc *crtc,
 				struct drm_crtc_state *new_crtc_state)
 {
-	struct drm_plane *cursor = crtc->cursor, *underlying;
+	struct drm_plane *cursor = crtc->cursor, *plane, *underlying;
+	struct drm_plane_state *old_plane_state, *new_plane_state;
 	struct drm_plane_state *new_cursor_state, *new_underlying_state;
 	int i;
 	int cursor_scale_w, cursor_scale_h, underlying_scale_w, underlying_scale_h;
+	bool any_relevant_change = false;
 
 	/* On DCE and DCN there is no dedicated hardware cursor plane. We get a
 	 * cursor per pipe but it's going to inherit the scaling and
@@ -9917,6 +9919,35 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 	 * blending properties match the underlying planes'.
 	 */
 
+	/* If no plane was enabled or changed scaling, no need to check again */
+	for_each_oldnew_plane_in_state(state, plane, old_plane_state, new_plane_state, i) {
+		int new_scale_w, new_scale_h, old_scale_w, old_scale_h;
+
+		if (!new_plane_state || !new_plane_state->fb || new_plane_state->crtc != crtc)
+			continue;
+
+		if (!old_plane_state || !old_plane_state->fb || old_plane_state->crtc != crtc) {
+			any_relevant_change = true;
+			break;
+		}
+
+		if (new_plane_state->fb == old_plane_state->fb &&
+		    new_plane_state->crtc_w == old_plane_state->crtc_w &&
+		    new_plane_state->crtc_h == old_plane_state->crtc_h)
+			continue;
+
+		dm_get_plane_scale(new_plane_state, &new_scale_w, &new_scale_h);
+		dm_get_plane_scale(old_plane_state, &old_scale_w, &old_scale_h);
+
+		if (new_scale_w != old_scale_w || new_scale_h != old_scale_h) {
+			any_relevant_change = true;
+			break;
+		}
+	}
+
+	if (!any_relevant_change)
+		return 0;
+
 	new_cursor_state = drm_atomic_get_plane_state(state, cursor);
 	if (IS_ERR(new_cursor_state))
 		return PTR_ERR(new_cursor_state);
-- 
2.42.0



