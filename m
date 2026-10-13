Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EBB38F62F;
	Tue, 13 Oct 2026 12:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894357; cv=none; b=fomZRPbff9IDA1toXXHZBhmIdKBGsQunHaeZuZvaySgwtOwVGJ1BfFC+RaZa03sC4JaI7+upl9cYRVWr5wc1+EVMUxWA2+lLobXURsiG/MQvwVsuC4O2e/M1WRotQ39M+T4ZRcwjgy/knTU05HLb38dwTIPBdfkPcywPzxXXLMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894357; c=relaxed/simple;
	bh=1TMqf7S9DH0AP0Xj8m8DKIbmoF2pGza/Obe40d3s7VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bd1zeP7wYUu+2XLUic6v4HZLlWepGCd/hGzCHuaYGS8ekZaxIUVeB9tiIhi8wZYb9V0lTGnpyvtMGZowTe00VdZCtAbttYfCShyIzTDXdoAlmlKiianHqIi21wel9H/hSAFtZugBvr4FvsNUtzWpo9pXuDA4OTORNLoO7Nz5KhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVn+RqtA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVn+RqtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966811F000FF;
	Tue, 13 Oct 2026 12:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894356;
	bh=iaTIaVRq5y1jZSHBDEDyX7gGzrDjTTy2B3N+/cPaKwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVn+RqtAXktvvHPXgbUJbOiDTHO343qSpp8AA0mBvxPOicVLErtQJKoOOVmwOlCpD
	 8+G3c110JhOQX0ns/WenkKRzuQEIEPgLttHnxoOP7X/Xd3hlQlrS5EONcHBSVpaNle
	 Tyw+MRcyQT/fV3RKY0hxNRBvl1Pz3krv84EWkXos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgenii Burenchev <evg28bur@yandex.ru>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 489/621] drm/amd/display: Fix dangling pointer in CRTC reset function
Date: Tue, 13 Oct 2026 13:38:04 +0200
Message-ID: <20261013112932.433899365@linuxfoundation.org>
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
index 9082b862e7aa9..db202f27ca38f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -508,13 +508,13 @@ static void amdgpu_dm_crtc_reset_state(struct drm_crtc *crtc)
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



