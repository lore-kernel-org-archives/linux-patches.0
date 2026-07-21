Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F7C387362;
	Tue, 21 Jul 2026 18:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657538; cv=none; b=TEJvhZmC9H++RQSrVAqtVxmW4fTw7wL1tgyq1pL6NsDMfeN0hWNv1jpa0RIWHiaAYHjQ6uap/kk1RTrbnMOtH6evfn52LBfjvpdv02TYmnFwqvOQOvaT6MUPK1KeZfV4m/Bf6NEsyftod9EyMv+vmQLuI10gnFQgSegFUcShdgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657538; c=relaxed/simple;
	bh=rnj0AyGExvAri5ufuuCLJXqlAdFwHWqKi/U50cq+1ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+xZniuNLXSDc0C9s1oNpalqEeq/DqxgjOvn2tTDrjJ48EVXZtHA4RK1fS7Ynkxxli1YKIDX0QGG1z61Qh6IpOOL6mFOWMuLnFNxUXWcASgMVHRGbTjix8miF7s4hYKu2IGdGQwlBqELYWG/eXpxKqIOX5YSQto0Np2ydoqXYuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SF9STo7b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SF9STo7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840C41F000E9;
	Tue, 21 Jul 2026 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657537;
	bh=a/mSkB8ipTG8ZdqVi2oMdBHs+lTC5w3/QUlCsU+ehpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SF9STo7bLYaesINJon/3ePXrORSQZTFUozDMvjN6O3kTx60K52Xn51FRibDoldr3k
	 HcIl4+dlFPty82mbi3741rlRDxnQ58CkASEOPah2ur8TS++vytqAJtxLzq2+2k0zTy
	 8yyN5LAhSb5fHsZSLd5aEVWt0LsDYNHO5dgJPePg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0803/1611] drm/amd/display: Fix mem_type change detection for async flips
Date: Tue, 21 Jul 2026 17:15:19 +0200
Message-ID: <20260721152533.447819305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit 8e792f018e10e68f488f279fbd4f38009a2e066d ]

[Why]
amdgpu_dm_crtc_mem_type_changed() fetches the "old" and "new" plane state
with two drm_atomic_get_plane_state() calls, which both return the new
state. It compares a state against itself, so it never detects a mem_type
change and never rejects the async flip.

On DCN 3.0.1, this shows up as intermittent corruption when a single DCC
plane is scanned out with immediate flips under gamescope and its buffer
moves between the VRAM carveout and GTT.

[How]
Use drm_atomic_get_old_plane_state() and drm_atomic_get_new_plane_state()
to compare the actual old and new states. These return NULL rather than
an error pointer for a plane that is not part of the commit, so the
IS_ERR() check becomes a NULL check that skips those planes, such as an
unmodified cursor still in the CRTC's plane_mask.

Fixes: 4caacd1671b7 ("drm/amd/display: Do not elevate mem_type change to full update")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 13158e5dbd896281f3e9982b5437cffa5fd621b2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ae10e8365ae159..a2ca1de6b43cfc 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -12177,13 +12177,11 @@ static bool amdgpu_dm_crtc_mem_type_changed(struct drm_device *dev,
 	struct drm_plane_state *new_plane_state, *old_plane_state;
 
 	drm_for_each_plane_mask(plane, dev, crtc_state->plane_mask) {
-		new_plane_state = drm_atomic_get_plane_state(state, plane);
-		old_plane_state = drm_atomic_get_plane_state(state, plane);
+		new_plane_state = drm_atomic_get_new_plane_state(state, plane);
+		old_plane_state = drm_atomic_get_old_plane_state(state, plane);
 
-		if (IS_ERR(new_plane_state) || IS_ERR(old_plane_state)) {
-			drm_err(dev, "Failed to get plane state for plane %s\n", plane->name);
-			return false;
-		}
+		if (!old_plane_state || !new_plane_state)
+			continue;
 
 		if (old_plane_state->fb && new_plane_state->fb &&
 		    get_mem_type(old_plane_state->fb) != get_mem_type(new_plane_state->fb))
-- 
2.53.0



