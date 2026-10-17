Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C664635E93B;
	Sat, 17 Oct 2026 18:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260411; cv=none; b=pc+FE/H7APrNt4+/shW/yQ3qkefp0arA5ihlrExThAS2RZHwx9FqJ6NAWyTcyoIWDb1uPLm8oQjGvmZYonV5LzdmPtdu9egZCJr3HO/nNMugfGgAjVMf3jGs00tlkYIPqZFjuLiLW/UdTmTM1HgV+uAKbc4F/ZCRbOOL/uQciGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260411; c=relaxed/simple;
	bh=5qXFJQQYnXeQamNquTik6t1P8aDqwmy6BXacrJ87ZMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehwtWvDZkjIJgynIbaz82bom3ANakpp0L30ROSMjUJiZJOGPlEAOzOJeRBaF6neVSzepCXplNWXfsQKMIStVO/FLSdvJBss05i/ZHnOXd5lBprILhijMNbS7KzHrkBHGLSeCI5SWLSgH38UmGtVgruQsv09MPiGGxLVuqtxaA+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXZhCys+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXZhCys+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2BF1F000C4;
	Sat, 17 Oct 2026 18:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260410;
	bh=fhXwndhV4VkjmaIVBKgGPcthJ+K9cTyV1ogRwPYPasg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pXZhCys+ORv4vhvloBRw89Hxl/iJG2JLUgblFynSfYt/6tFczNmFftQvDqxmtzaRZ
	 AWzcJ2UFyh3NiHtD6mJUw9xUA1+DADqJZSm4no+mQbdYjqUoHBkNSgsPzi/af9dWn9
	 EgDIlKSWL48DQskdL81obdRxFwzY1wn5k7Di70xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1499/1674] drm/amd/display: Fix dangling pointer in CRTC reset function
Date: Sat, 17 Oct 2026 18:02:51 +0200
Message-ID: <20261017160509.616904223@linuxfoundation.org>
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
index dab732c6c6c7c..0531ebcf2cd35 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -270,13 +270,13 @@ static void dm_crtc_reset_state(struct drm_crtc *crtc)
 {
 	struct dm_crtc_state *state;
 
-	if (crtc->state)
-		dm_crtc_destroy_state(crtc, crtc->state);
-
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (WARN_ON(!state))
+	if (!state)
 		return;
 
+	if (crtc->state)
+		dm_crtc_destroy_state(crtc, crtc->state);
+
 	__drm_atomic_helper_crtc_reset(crtc, &state->base);
 }
 
-- 
2.53.0



