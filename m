Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35982B9C7;
	Sun,  1 Sep 2024 16:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208532; cv=none; b=nrDNvJyRIBnUqh3rdFHZRKIVpnCkBPBWpVDsHhHkPkrQMmV870zfWkbD93dmEfpxPvHo12b2xRuHo+aEpP5D3UlOdzba9ZL6xyEj767QRW4uQLAbIIcx4FEKlb3mKCu7V4Ib1KtyWAywVqDELhFpvIYfhTJ2JNCo/KG4UjzvzG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208532; c=relaxed/simple;
	bh=Ftz4wo2u1su45f/Q5QkoxPVM1Y8Xd+nBOucyzi7VJ6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzcwzQvtQiGxu7Va3EQGETe96vqb3PUGO2KpXQv1JFE/1rXgWqeA29a8MffIiY7ZTB4E75DisSSmsmLkIK8v5Tvms/X8GLBn7Q33Ljciv8sePGVkX3eoIsQQbRkplNFuS6C5EuflFcU7pbQPHH2EKr7BTbGAEwJP2pkREfMtPIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o72uL8Db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o72uL8Db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D9BC4CEC3;
	Sun,  1 Sep 2024 16:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208531;
	bh=Ftz4wo2u1su45f/Q5QkoxPVM1Y8Xd+nBOucyzi7VJ6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o72uL8DbuxHK1H7FEuCm7u+vZCEDlTJNkaxt2WYTJCeFSUqjX7APX7O+6cXJR7WvH
	 Ll6EaBLLYyr0+/l0+m6pP6kgkbx5TmPXPHbFOmeawZLmh/gUj8h+ZzS+NicgqqWDoc
	 YiH6zpAqBZDKGxwK3yea0LcCXvo8ZSa3BxTk7D8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 110/149] drm/amd/display: avoid using null object of framebuffer
Date: Sun,  1 Sep 2024 18:17:01 +0200
Message-ID: <20240901160821.592504238@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 3b9a33235c773c7a3768060cf1d2cf8a9153bc37 ]

Instead of using state->fb->obj[0] directly, get object from framebuffer
by calling drm_gem_fb_get_obj() and return error code when object is
null to avoid using null object of framebuffer.

Fixes: 5d945cbcd4b1 ("drm/amd/display: Create a file dedicated to planes")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 73dd0ad9e5dad53766ea3e631303430116f834b3)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index 311c62d2d1ebb..70e45d980bb93 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -28,6 +28,7 @@
 #include <drm/drm_blend.h>
 #include <drm/drm_gem_atomic_helper.h>
 #include <drm/drm_plane_helper.h>
+#include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_fourcc.h>
 
 #include "amdgpu.h"
@@ -854,10 +855,14 @@ static int amdgpu_dm_plane_helper_prepare_fb(struct drm_plane *plane,
 	}
 
 	afb = to_amdgpu_framebuffer(new_state->fb);
-	obj = new_state->fb->obj[0];
+	obj = drm_gem_fb_get_obj(new_state->fb, 0);
+	if (!obj) {
+		DRM_ERROR("Failed to get obj from framebuffer\n");
+		return -EINVAL;
+	}
+
 	rbo = gem_to_amdgpu_bo(obj);
 	adev = amdgpu_ttm_adev(rbo->tbo.bdev);
-
 	r = amdgpu_bo_reserve(rbo, true);
 	if (r) {
 		dev_err(adev->dev, "fail to reserve bo (%d)\n", r);
-- 
2.43.0



