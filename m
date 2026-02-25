Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8F82BDC03;
	Wed, 25 Feb 2026 06:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002761; cv=none; b=qfqao5XqU4U4c+xRTAXrub/OHStbu2CYzsbQH+AZyNYX0EoBRIoexV6BqtSNDo+06A5oADCP33OTogLCM2T6qVHKR0JXd55CrzEjMCOEdgD3G4iORVBLhpISqOYhswyqYHzNhv+11mHZRKh6ukjtfOSc9I/hCUjAzJJHV4ZQyP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002761; c=relaxed/simple;
	bh=Dj/lDm+xjbydHE4lA7bCk1qQDiGOcXm+1JRkUSkcNBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R9v44OCLugFE+YqRr/PzErneU01nRG0fpyQCTSLcVtDyRpqGKr9tVTJ4wLWeb+J0a6bJAdd1bvKOxMZmTZtkO9HlhYsUy8b4+6vdbj+fpitaTu4cfqzpGMYZJ58FPf7pgg68kichh2Dnqw4Fh/yv5SJM/T5FrKLWvjXInylGYhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPEfgT6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPEfgT6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7689C116D0;
	Wed, 25 Feb 2026 06:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002761;
	bh=Dj/lDm+xjbydHE4lA7bCk1qQDiGOcXm+1JRkUSkcNBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPEfgT6wfblvRukjYJ5ouczxPPtdVlq4x7A4K/j0AWXjWDbcgQ064h8R7+VLbpezb
	 fX+0rPJxpx6xK1kA5AOP9TXEe4rM+J0kZ2r6BE7z6v1/4rvQjZRwWCAqAARiTX/qgg
	 8/KErPLfkEhEmONUtX4LwH6zcqJsZQQFDENEAK5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 591/641] drm/amd/display: Reject cursor plane on DCE when scaled differently than primary
Date: Tue, 24 Feb 2026 17:25:17 -0800
Message-ID: <20260225012402.836195300@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 41af6215cdbcecd12920f211239479027904abf3 ]

Currently DCE doesn't support the overlay cursor, so the
dm_crtc_get_cursor_mode() function returns DM_CURSOR_NATIVE_MODE
unconditionally. The outcome is that it doesn't check for the
conditions that would necessitate the overlay cursor, meaning
that it doesn't reject cases where the native cursor mode isn't
supported on DCE.

Remove the early return from dm_crtc_get_cursor_mode() for
DCE and instead let it perform the necessary checks and
return DM_CURSOR_OVERLAY_MODE. Add a later check that rejects
when DM_CURSOR_OVERLAY_MODE would be used with DCE.

Fixes: 1b04dcca4fb1 ("drm/amd/display: Introduce overlay cursor mode")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4600
Suggested-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 6252afd1d087f..ccf13bb5281bf 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -12027,10 +12027,9 @@ static int dm_crtc_get_cursor_mode(struct amdgpu_device *adev,
 
 	/* Overlay cursor not supported on HW before DCN
 	 * DCN401 does not have the cursor-on-scaled-plane or cursor-on-yuv-plane restrictions
-	 * as previous DCN generations, so enable native mode on DCN401 in addition to DCE
+	 * as previous DCN generations, so enable native mode on DCN401
 	 */
-	if (amdgpu_ip_version(adev, DCE_HWIP, 0) == 0 ||
-	    amdgpu_ip_version(adev, DCE_HWIP, 0) == IP_VERSION(4, 0, 1)) {
+	if (amdgpu_ip_version(adev, DCE_HWIP, 0) == IP_VERSION(4, 0, 1)) {
 		*cursor_mode = DM_CURSOR_NATIVE_MODE;
 		return 0;
 	}
@@ -12350,6 +12349,12 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 		 * need to be added for DC to not disable a plane by mistake
 		 */
 		if (dm_new_crtc_state->cursor_mode == DM_CURSOR_OVERLAY_MODE) {
+			if (amdgpu_ip_version(adev, DCE_HWIP, 0) == 0) {
+				drm_dbg(dev, "Overlay cursor not supported on DCE\n");
+				ret = -EINVAL;
+				goto fail;
+			}
+
 			ret = drm_atomic_add_affected_planes(state, crtc);
 			if (ret)
 				goto fail;
-- 
2.51.0



