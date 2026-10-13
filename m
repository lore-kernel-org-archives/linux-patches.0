Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8BE331EB1;
	Tue, 13 Oct 2026 12:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894360; cv=none; b=QlKyk5L/gviZeiwpM1DGn8OhAq4O2Pop43PgMPGfBw/9L7kgxSxnYDFgw5PXMBsKocVbPhkaGtAjuhp/3Tg1ru/8xrFzvtXvwH7efZ0uNcObv/wIqTc9D+GhdjLB/q8gOD5maWp5bJUd8EBCs5WxhYZ/E83/Sevn8WT7THkewBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894360; c=relaxed/simple;
	bh=jSK6WZZ7krULdc4rmox5mHOE7xKzUQoPS3UyJ5C+0WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENJYlA1Ur9J4EpUW4vLhCsQ14ZKqAiFTmtNuMgxLxBOt0Ntu3THo0OaUwQ3O7drV0175Go1OwHDOMlRlxaoRZbRVuAKd2UAOSqIFvsWmMrpw1wqBB/xNtHZrICUFmR+UxxX2v9oJl1r1kArR22Qi8YFIoF/p/HgDYsT/Ov94u3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6eU3BBO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6eU3BBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DEA1F00893;
	Tue, 13 Oct 2026 12:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894359;
	bh=rrIDd8epBvQ5Hb5wL0YJdKMEdNr5ODhxtBjyKZwcVHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6eU3BBOgzgGOgZu6h6PxmcsDhXpACpUxh3UrVNj0O2PlyQejLbS8zRRkxBtYLDzL
	 6j0ia0cGm/IVBzSA06ctTHkjbCLRRRh8ZIArFpuYda6zi2GJpzzZIzufGXa5zExDUb
	 URugnf+Y6yQhiLhTiFjdVF3MisYHAIToeybLFx3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 490/621] drm/amd/display: Fix dangling pointer in plane reset function
Date: Tue, 13 Oct 2026 13:38:05 +0200
Message-ID: <20261013112932.457286236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 175e4b11b43bd..54e4b48bd78a6 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1446,17 +1446,15 @@ static const struct drm_plane_helper_funcs dm_primary_plane_helper_funcs = {
 
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



