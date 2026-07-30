Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EF5446070;
	Thu, 30 Jul 2026 16:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427583; cv=none; b=aSysvbD6UNsVr2ZVMa0pV0v8v2NFJttK2a7JCEo4joEiq2srHuwJDOX6D0uyy4OWDynfa63RAhZNNIJT8llPU61Zi8dj1bm/xVJsNgQ4ilT/o6w04Qpqg7w5Lz16xRJoMx3z0qqGR/LBLs42pZvkvy/l3/eetwIMlTm5+byc3Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427583; c=relaxed/simple;
	bh=fXYON/iu8E1KK7zekaewlo/wJJ1i/LQ4to5DM61OOjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFiDs8YLCoeNczEyc5Xfa7fjWAcU1Z4tG3BM2FZueESaGsVbeqRhOLsjXkwdTf+Ok0RtjOTSylNk9+wFu96Va7SantcbKrn6m4Dtric0vNynoK+s3IBCSc07CH3K9neefh9ymKv5Mredw+rnbqSRd/6ffPGJXQVisu4kPfmu7uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBb7b1lm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBb7b1lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDD11F000E9;
	Thu, 30 Jul 2026 16:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427581;
	bh=BO0yjRlSYq6X/n1YuPnObJR/q3F6/ZmJgkHOmqeynwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBb7b1lmLR7u7G/MXlyEnJzKB1jhkJWw6p2a739bnizQ2TUd6PdUpBqb8x1TooSyE
	 6EGa1/KYdmWZlS7mZvHcQgfUOx1eB8UD06CpZsMl4F+GSvgYThOvXRa2WfNsNI/Lle
	 cmVv0oow4yj7qmBBfDSr7cSsDkowkkUecLlqPlnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Zack Rusin <zackr@vmware.com>,
	dri-devel@lists.freedesktop.org,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 219/484] drm/amd/display: Handle struct drm_plane_state.ignore_damage_clips
Date: Thu, 30 Jul 2026 16:11:56 +0200
Message-ID: <20260730141428.230421951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit ac11060c6d4959e2d4ceada037d2e1e1bfcf6645 upstream.

The mode-setting pipeline can disabled damage clippings for a commit
by setting ignore_damage_clips in struct drm_plane_state. The commit
will then do a full display update.

Test the flag in DCN code and do a full update in DCN code if it has
been set.

Commit 35ed38d58257 ("drm: Allow drivers to indicate the damage helpers
to ignore damage clips") introduced ignore_damage_clips to selectively
ignore damage clipping in certain framebuffer changes. This driver does
not do that, but DRM's damage iterator will soon rely on the flag.
Therefore supporting it here as well make sense for consistency.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 35ed38d58257 ("drm: Allow drivers to indicate the damage helpers to ignore damage clips")
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Zack Rusin <zackr@vmware.com>
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a24019f6480fad5c077b5956eed942c8960323d6)
Cc: <stable@vger.kernel.org> # v6.8+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5180,8 +5180,8 @@ static void fill_dc_dirty_rects(struct d
 {
 	struct dm_crtc_state *dm_crtc_state = to_dm_crtc_state(crtc_state);
 	struct rect *dirty_rects = flip_addrs->dirty_rects;
-	u32 num_clips;
-	struct drm_mode_rect *clips;
+	u32 num_clips = 0;
+	struct drm_mode_rect *clips = NULL;
 	bool bb_changed;
 	bool fb_changed;
 	u32 i = 0;
@@ -5197,8 +5197,10 @@ static void fill_dc_dirty_rects(struct d
 	if (new_plane_state->rotation != DRM_MODE_ROTATE_0)
 		goto ffu;
 
-	num_clips = drm_plane_get_damage_clips_count(new_plane_state);
-	clips = drm_plane_get_damage_clips(new_plane_state);
+	if (!new_plane_state->ignore_damage_clips) {
+		num_clips = drm_plane_get_damage_clips_count(new_plane_state);
+		clips = drm_plane_get_damage_clips(new_plane_state);
+	}
 
 	if (!dm_crtc_state->mpo_requested) {
 		if (!num_clips || num_clips > DC_MAX_DIRTY_RECTS)


