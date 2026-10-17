Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1782A3B1EC8;
	Sat, 17 Oct 2026 16:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255244; cv=none; b=KDpdq3zsHXRKkhxTw9vc82QhmYa4GnOVOjs/IUkRQvQJmUMFCzZEqGxG9kKWg9npYxspYGLXeZ7FrJpO6TabzLAA9iZXw8wCFCQEdiKmyg3/eLsoYB/qoc3y6GJkG6VWoFuMWI1JZ+W8a9yZzvTBKHJCdKp0hCXFlolhmwCA9t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255244; c=relaxed/simple;
	bh=rmR3KcFNmZWdW0HHF6Kyv0+UNs/67qB3cIcMfDY2PM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2VLe/LyLvXXZGUOaDg02H4CVSVJsj5j6I0EdJgMzxa70OLaNQV4e7+Nz6VJNTmtiPxbR1/ygN/rGLr2UPdS7jKvvc/1GUORxYuIhkwXZTE6pvWDVgSjJ7d6GghDpnDdrbGk8fyRe5FotLuftWMluAFLPrJMXotYFzIrYkBXzQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRbcdYXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRbcdYXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220951F000C4;
	Sat, 17 Oct 2026 16:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255242;
	bh=F4KnH4t8pAw5cy2WD1EYpv8dA7XDcMOCj0xrTcQgoAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NRbcdYXycUpFITeRh/4ZDsxsy/shNVAHieZ43jp1rTOwGKlKddji+pPkrY5IVLHYY
	 J7sZeXXHIORTpyDmZDMvlzggVs/xq7xUKkU7q0b6F48j4E0GxWqruPLxBAiaxArT6c
	 Te/J+D5QQCL6u9fgbdUEPohUaCE9hWwPxyeQHASo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 713/869] drm/amd/display: Fix dangling pointer in CRTC reset function
Date: Sat, 17 Oct 2026 17:59:14 +0200
Message-ID: <20261017160055.239349440@linuxfoundation.org>
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

[ Upstream commit 0aeed866cb938943908c3ba46422128e49d2d080 ]

amdgpu_dm_crtc_reset_state() frees the old state before allocating
a new one. If kzalloc() fails, the function returns without updating
the state pointer, leaving a dangling pointer to already freed memory.

Fix this by allocating the new state first. On allocation failure, the
old state remains untouched and the function safely returns.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e7b07ceef2a6 ("drm/amd/display: Merge amdgpu_dm_crtc and dm_crtc_state")
Signed-off-by: Evgenii Burenchev <evg28bur@yandex.ru>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260629090435.9729-4-evg28bur@yandex.ru
[adjust for movement around current amd-staging-drm-next]
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
index 779c2c3ffbc0d..824e88fe54c6f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -479,13 +479,13 @@ static void amdgpu_dm_crtc_reset_state(struct drm_crtc *crtc)
 {
 	struct dm_crtc_state *state;
 
-	if (crtc->state)
-		amdgpu_dm_crtc_destroy_state(crtc, crtc->state);
-
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (WARN_ON(!state))
+	if (!state)
 		return;
 
+	if (crtc->state)
+		amdgpu_dm_crtc_destroy_state(crtc, crtc->state);
+
 	__drm_atomic_helper_crtc_reset(crtc, &state->base);
 }
 
-- 
2.53.0



