Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02583AAF60;
	Sat, 17 Oct 2026 16:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255247; cv=none; b=ST26WJzEFIZVa4DZJtza1SLLGSy6Achsd1HfleOQk93kJC/GN4ALFdiVoY4HPe7F/9lTixqnrI2keokEFGG/lyPCEWFjgIoAcrTMMLlc67eg099M3hxzKVoy9wpMoExRh/HBtkz6CvA4fIg9U3Ln+pT+4Wo3vvMc2ZKdK/IwaME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255247; c=relaxed/simple;
	bh=NNHfQ3x+DMnGIfuSASPaHNb1M2dv0cdoiLJ/oWr9h6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3YmDvu4fVvI9Urvq8LnUTdKo9T6EqkNM9v2mtLjFPtisVutTbH0sD1TNBgzNpDcbnYjse5W1zYDq8kpoVtPA6k5zxhWdbuITzSJ8JT/Um0dF7Sq35ZTCz7IMU+IqiqpJ79O5mBu/pp2iLD3661zfJS1MYqZJi6YUGDVHEqx7KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Hcar3Qt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Hcar3Qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B641F000C4;
	Sat, 17 Oct 2026 16:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255245;
	bh=IvHuF/PUbnka+6QeCOT8Ogeh6IDBbYErWZu489b/3qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Hcar3QtzLEjFcs20K4AIWBCYMwir5vw4k5UvRrNwpoO8tBetSOf/P4jYBImSpRkp
	 YUZ0osCCfUHuHNrQDD2BinFM0tu1Yxaq8r8WnZowjY212SXzDS1cOu+E9kGV/2RQpo
	 MUIjnDHh/qSm+I710petmYq0HWzbnQ67irUsg4Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 714/869] drm/amd/display: Fix dangling pointer in plane reset function
Date: Sat, 17 Oct 2026 17:59:15 +0200
Message-ID: <20261017160055.267336755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evgenii Burenchev <evg28bur@yandex.ru>

[ Upstream commit 98cad4bd1443975d972f4c7f705980da03722a22 ]

amdgpu_dm_plane_drm_plane_reset() frees the old state before allocating
a new one. If kzalloc() fails, the function returns without updating
the state pointer, leaving a dangling pointer to already freed memory.

Fix this by allocating the new state first. On allocation failure, the
old state remains untouched and the function safely returns.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5d945cbcd4b1 ("drm/amd/display: Create a file dedicated to planes")
Signed-off-by: Evgenii Burenchev <evg28bur@yandex.ru>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260629090435.9729-3-evg28bur@yandex.ru
[adjust for movement around current amd-staging-drm-next]
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index 97eeabc556a05..a033628c3d549 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1415,17 +1415,15 @@ static const struct drm_plane_helper_funcs dm_plane_helper_funcs = {
 
 static void amdgpu_dm_plane_drm_plane_reset(struct drm_plane *plane)
 {
-	struct dm_plane_state *amdgpu_state = NULL;
-
-	if (plane->state)
-		plane->funcs->atomic_destroy_state(plane, plane->state);
+	struct dm_plane_state *amdgpu_state;
 
 	amdgpu_state = kzalloc(sizeof(*amdgpu_state), GFP_KERNEL);
-	WARN_ON(amdgpu_state == NULL);
-
 	if (!amdgpu_state)
 		return;
 
+	if (plane->state)
+		plane->funcs->atomic_destroy_state(plane, plane->state);
+
 	__drm_atomic_helper_plane_reset(plane, &amdgpu_state->base);
 	amdgpu_state->degamma_tf = AMDGPU_TRANSFER_FUNCTION_DEFAULT;
 	amdgpu_state->hdr_mult = AMDGPU_HDR_MULT_DEFAULT;
-- 
2.53.0



