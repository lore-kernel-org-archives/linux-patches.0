Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6C1403135;
	Tue, 21 Jul 2026 19:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660845; cv=none; b=ZZ8v+oyTASEkUZhW1ZPYYC93PcwICBQne6YfX841qXvJrLFJxtYuLGLRDNlUFZeEDq5I68slIwV+Uqxa4IlvbgNe7mF+r8kabvOo+CiENjdRr3yzoQb3DkoYg5mA2KCXVPQ4Gh5k1Jt/x3IxR8u5EskRtIR4NSMnWdPXHs6yeuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660845; c=relaxed/simple;
	bh=vhEzvl96mp7B2I5d6yXRFikvmvZYqb7iQsSZkgsxB/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X73piJlrme3jPhcsf8ltUlxknM5s/yAkmrKk9YUee5/NArIgN6L/EMTXyI9snWyZwZGeuL9hPpQYfodrgtDWH1qZxskXg2m/Fbdkk7Mgx6G25ktQ8/u//BXyBTNoeblnH8rr6YUr8f7HhdsvMqW/viKOe4sAn5RT9vnRjibgLKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whyHMbSh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whyHMbSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55A01F000E9;
	Tue, 21 Jul 2026 19:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660843;
	bh=k0QsCYmUEBtshjcngLheNtIwlP7LDQh2iRb2fWx5gCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whyHMbShx6lzBDAuQTXSPe03zalfoNXKkwSV54MguQV4Dv8FY9e7SPmY8y74Mqa78
	 U3DmYzWwu/ZNbx44UeVRE9/zNgpDr6AOupMKN690HuAPYr7xCxYrQ7dbQ1/JmvODMe
	 OSdKdZFwBxNTc9hGLi/c7MZt9QFkBKtI4AObSoMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1106/2077] drm/amd/display: Fix mem_type change detection for async flips
Date: Tue, 21 Jul 2026 17:12:59 +0200
Message-ID: <20260721152618.906439876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index f8c13bad4ac237..1ecd7bef9ed850 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -12553,13 +12553,11 @@ static bool amdgpu_dm_crtc_mem_type_changed(struct drm_device *dev,
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



