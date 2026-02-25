Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D7526561A;
	Wed, 25 Feb 2026 01:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983631; cv=none; b=Aj8tjIzHE/LpnmD3RXwvsfbeBvHDnHV/Md0avfeEThgst77bhNDuPy3GWfeoPBXJff87IQ3smpwTCBNo+JSTe5UakRs5MDlqR6tSZ8hvVkmqS/C16PoeVX4Uk1GIAbjjHrCiEi50eqUPUd25R1z51jxSx9nsugnpQop/nYgds9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983631; c=relaxed/simple;
	bh=asgFzpIfi7IkccOB2HIO7XedbpEbb/yZY9ZZAs6T8Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HWo96DL2hM4Pnyu26dQB/MaJGvY3Z2LmSMqgKM+DGOEYqd8lu+ML4K6EDPhyYlJ5TxhFjldqh1mjWSGQyurFe/6pCinGAibYal1zEhq382W0Ji8UELcio+Z9dZ/ksThRcN6bQ/tny+406sNbmyEWAgQP3nKq3KBrSL8QGI5zDig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o45MCf2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o45MCf2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444BCC116D0;
	Wed, 25 Feb 2026 01:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983631;
	bh=asgFzpIfi7IkccOB2HIO7XedbpEbb/yZY9ZZAs6T8Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o45MCf2fQiuJazhmT6p8OxRGHjDmW+878zicLtK7iHbuXUc4F/XHZt6JhVx9b5zNu
	 AVRl6e076lRTWSfEkm9isi0qEZHqnAErJt1TAa/m4EGFawyOKJ2J8tMbVY4LiD11zs
	 uD538vd24Q37mgiRqvIBnBlZbPc2GS6ZA7EXI9Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 722/781] drm/amd/display: Reject cursor plane on DCE when scaled differently than primary
Date: Tue, 24 Feb 2026 17:23:51 -0800
Message-ID: <20260225012417.445139554@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index b31bd6fa70181..62622aa622066 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -12275,10 +12275,9 @@ static int dm_crtc_get_cursor_mode(struct amdgpu_device *adev,
 
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
@@ -12598,6 +12597,12 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
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



