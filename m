Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3313B71A7;
	Sat, 17 Oct 2026 18:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260427; cv=none; b=SK6MC6tQgkLEDdOuEFTy5S368wX0N7Ni+kDN/L5Mds9+xnQ0vDoIe6SwqmhuIlniULwYfR3HhSQnI+3JROyJYLBrrEme5AjKQQwxfZtoOpF2YrY4ZNY1oq06GOSWtJdHlt8bGV0LGup1aD6PqNDpLx6VIgLAxr2ZM52aOYqMH0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260427; c=relaxed/simple;
	bh=4WSGN8B309WaaMpCjeHwmFyGGioTEbImhnCa7pHzp5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqwvqa6M5xScVmi8qcfVaPv3CKz2Uyu/goRvG1+GobBQkSo1r8Ajka6u8VxTz0lynVHxDVYv8w2jBKvTpUBazeFRsMX6QmRECWxLr609VB9KQiEBxUG6i7lf9+5GGYjS8bKQnmLTII9803QHI3fYqdT+s0TXtnw58q1yR0gb3Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqo+yCcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqo+yCcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DAE1F000C4;
	Sat, 17 Oct 2026 18:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260426;
	bh=SdTQ9gM78aS2r0i7UxP1Z3/Ps21CZg5fvqe96EEa4Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bqo+yCcODhxUsPJkfS0+xeQhF081a3mJPFF7Wr9iWeiIxTEFVCbtaWlcTqXse/m9a
	 7zI5OEmAeduF7lwg9dUu+EQvw2llMl46BE4PrYf06K34bsoCUOK6u96949udJrFLLJ
	 foAtUecsBbbp1Z+BK4GqC0pjhOtcyuOkxqgAJXRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1500/1674] drm/amd/display: Fix dangling pointer in plane reset function
Date: Sat, 17 Oct 2026 18:02:52 +0200
Message-ID: <20261017160509.642285127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c  | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
index 4392158697087..c1d18fc365168 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1316,16 +1316,16 @@ static const struct drm_plane_helper_funcs dm_plane_helper_funcs = {
 
 static void dm_drm_plane_reset(struct drm_plane *plane)
 {
-	struct dm_plane_state *amdgpu_state = NULL;
+	struct dm_plane_state *amdgpu_state;
+
+	amdgpu_state = kzalloc(sizeof(*amdgpu_state), GFP_KERNEL);
+	if (!amdgpu_state)
+		return;
 
 	if (plane->state)
 		plane->funcs->atomic_destroy_state(plane, plane->state);
 
-	amdgpu_state = kzalloc(sizeof(*amdgpu_state), GFP_KERNEL);
-	WARN_ON(amdgpu_state == NULL);
-
-	if (amdgpu_state)
-		__drm_atomic_helper_plane_reset(plane, &amdgpu_state->base);
+	__drm_atomic_helper_plane_reset(plane, &amdgpu_state->base);
 }
 
 static struct drm_plane_state *
-- 
2.53.0



