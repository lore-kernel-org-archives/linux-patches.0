Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9804F37F72E;
	Thu, 20 Aug 2026 15:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238927; cv=none; b=SaUQvBdr1DVgFx/RbGHdVHdOWI9ht5fFGaZlMXbkjIYhLNwvazm83MkRgvmsq8TEZqkfoELGrWG/7izTSZ98v76dV7L+zgByYpPPxEp+yWbeViuSgvh9uSOOT/8VNkpt2xVoTqQGo74cDlSgGmpKuHufmTp+92aGJNt0aOYXqLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238927; c=relaxed/simple;
	bh=piGMVj9FLg2plVFBLxcZnBzG2nkmrz/lrFwk1AnZ10w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0vcVx18hGX87w3aip1dGWGziGLPcGvo0/hFHtrUQEIMpHBFXWjTt90j3bBRIzWOqHb1oMn0bVOOsABMs6RnWT4OAR78p0vcHLLbsKP6sWqbwFq3zZS6t3EMUEmWng8BBiCSxL0gF+yBcSTnB6zTxA/BnhwpZdg7w7Gyb7juCRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyWK9Vmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyWK9Vmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6AE1F00A3A;
	Thu, 20 Aug 2026 15:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238926;
	bh=1IeX14s0cXeEZw6/wD/RxqQlLR4l8C7VTZI8GGqw60g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyWK9Vmc4E81s/EA/JJ4SOVMNMejFfyxd4aIwYug+7Jk/bvBf9ezpG74uZeUACsXp
	 L7JfFGN/k51p/bK3YSCpYVxhTQMtyVtNZhKhvWIMbJ2UfPQN5qLoyVeM+ntwlPv/YA
	 ExLY+kjFzBvwQw/+nyixb0e/kQOnXijm9kEKbxw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Samuel Pitoiset <samuel.pitoiset@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 090/217] drm/amd/display: Fix NULL pointer dereference in amdgpu_dm_crtc_set_vblank()
Date: Thu, 20 Aug 2026 16:54:18 +0200
Message-ID: <20260820145240.364053340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Samuel Pitoiset <samuel.pitoiset@gmail.com>

commit f2a1c4c6fe0a6fcde02e59dde546dba28d283635 upstream.

amdgpu_dm_crtc_set_vblank() dereferences acrtc_state->stream when
vblank is enabled/queried from DRM_IOCTL_MODE_CRTC_GET_SEQUENCE before
a stream is attached to it.

BUG: kernel NULL pointer dereference, address: 0000000000000008
RIP: amdgpu_dm_crtc_set_vblank+0x6b/0x4d0 [amdgpu]
Call Trace:
 drm_vblank_enable
 drm_vblank_get
 drm_crtc_get_sequence_ioctl
 drm_ioctl_kernel
 drm_ioctl

Reproduced by running VKCTS with WSI tests enabled on RADV.

Guard the enable path on acrtc_state->stream being non-NULL, matching
the existing checks in this function.

Fixes: 34d66bc7ff10 ("drm/amd/display: Fix Xorg desktop unresponsive on Replay panel")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Samuel Pitoiset <samuel.pitoiset@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7b1b31bf6942e6f43509b48da23f8e27269aac39)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -306,7 +306,7 @@ static inline int amdgpu_dm_crtc_set_vbl
 
 	irq_type = amdgpu_display_crtc_idx_to_irq_type(adev, acrtc->crtc_id);
 
-	if (enable) {
+	if (enable && acrtc_state->stream) {
 		struct dc *dc = adev->dm.dc;
 		struct drm_vblank_crtc *vblank = drm_crtc_vblank_crtc(crtc);
 		struct psr_settings *psr = &acrtc_state->stream->link->psr_settings;


