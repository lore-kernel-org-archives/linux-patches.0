Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF3143DA2C;
	Tue, 16 Jun 2026 15:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623524; cv=none; b=HdGl3dMuCe/cQTIXZzeS1IyGyWjCZySHN5GCPQb9IaFs7AHxexmwnHe9ye6HvqGUaEPp5FZbCTwyWWAJiUDKL8g11NMtiU6pzZo2vPAc4WjXxW3DzjQEg9HeYl6qbn8PvDw9Ljli9ytY3ktrKJjkZKFOugHcFuKf5ZtDaJ4pago=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623524; c=relaxed/simple;
	bh=sc13e/ZwaB5SCI/RUlZMmiWyU9faqB/4+6w29qcBm8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMbs3yeKWRWPFPoYZzvnFWr2MpSUu4zIQHWpbNGjzvpQ97pc2jNWbqaVujUEJSqCngL6AKvAyM9MeNGUOuspFX15r07k9IjTJGW95krZrsPGXOAB86Y9pjLEHZkNI0Lki7HMIKwaEJ4MHKsrOqOByR3kXphcTGv+9WagZAwpJ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBMa94Rb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBMa94Rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC7D1F000E9;
	Tue, 16 Jun 2026 15:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623522;
	bh=DJ4dGRy024AwbTbBWsinw3JthxqE+V8y1nE+mZaclLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBMa94RbUAN+EfDfqqzcIWrl2uP7t72ofaYjdrEcIH3F5ccJ9+H4toWslEEEIzMIy
	 sQ+Y/9QOUYjzVJ70IwTfkqMW16RClsB2qAy4wJB/yKjrmzJq3UbMst0YxKumMHxWte
	 EEHlfpI/fPatB1vR8KtntB9P5i5vaVyx5ZWcfXEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Melissa Wen <melissa.srw@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 164/378] drm/amd/display: use plane color_mgmt_changed to track colorop changes
Date: Tue, 16 Jun 2026 20:26:35 +0530
Message-ID: <20260616145118.906538526@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit d79716401a954677a93c4dd51fec65beccb38296 ]

Ensure the driver tracks changes in any colorop property of a plane
color pipeline by using the same mechanism of CRTC color management and
update plane color blocks when any colorop property changes. It fixes an
issue observed on gamescope settings for night mode which is done via
shaper/3D-LUT updates.

Fixes: 9ba25915efba ("drm/amd/display: Add support for sRGB EOTF in DEGAM block")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Melissa Wen <melissa.srw@gmail.com>
Link: https://patch.msgid.link/20260609110420.1298352-5-mwen@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0aee65503642d7..2d0c818cace25c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10016,7 +10016,7 @@ static void amdgpu_dm_commit_planes(struct drm_atomic_state *state,
 			continue;
 
 		bundle->surface_updates[planes_count].surface = dc_plane;
-		if (new_pcrtc_state->color_mgmt_changed) {
+		if (new_pcrtc_state->color_mgmt_changed || new_plane_state->color_mgmt_changed) {
 			bundle->surface_updates[planes_count].gamma = &dc_plane->gamma_correction;
 			bundle->surface_updates[planes_count].in_transfer_func = &dc_plane->in_transfer_func;
 			bundle->surface_updates[planes_count].gamut_remap_matrix = &dc_plane->gamut_remap_matrix;
@@ -11756,6 +11756,10 @@ static bool should_reset_plane(struct drm_atomic_state *state,
 	if (new_crtc_state->color_mgmt_changed)
 		return true;
 
+	/* Plane color pipeline or its colorop changes. */
+	if (new_plane_state->color_mgmt_changed)
+		return true;
+
 	/*
 	 * On zpos change, planes need to be reordered by removing and re-adding
 	 * them one by one to the dc state, in order of descending zpos.
-- 
2.53.0



