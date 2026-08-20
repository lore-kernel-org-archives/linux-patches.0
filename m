Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CE037E5FF;
	Thu, 20 Aug 2026 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238329; cv=none; b=oyRdZsvt2LXzVqGee6HE9yrXqyFiyipimzKAk7QxD5nPsyp8lSDSW6qeTKc0V521oDgY2IzAfttL/XPTkjjKQ66b3pCqUZJpxpNK4NaEFmdjkWu9SMHagg5EH4vYZg5gosdEXbfQ7ofIBS7kEf/YjPGXOjLzzMt4RJHWgeMd05U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238329; c=relaxed/simple;
	bh=zvH0isDZ1FFHGPHs5z/aAiLrKDF3oU8MymyZvN8Es1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZZNHgOwpdjj/BJdkUYP80hoplQ7ZADcPwihGn9ulsBkCNIvJzQHRWlirBpUAxJt24RzmeIC4TxnBPX9YcErt52Gl6Clm67Yoeg1L1RMEweKvgLl05q6XZ/A6wqc8u3k1j4AqbQPeSRy+1V8TJ56NMKM96O8jA8kgH7yB9O7MTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8aBhC2D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8aBhC2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1490A1F000E9;
	Thu, 20 Aug 2026 15:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238327;
	bh=4jA20jHXZNn5l+VuJLfy8xEWMINZD303050ueuu/3zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8aBhC2DzUNr7Wj5T1HE63HMl4LGP3kI+Xs7cFnhXM2OLJZaco35MVYxnFEh0Ab7J
	 qSFmKXZNXAu9n59te3nTHeRgKj6cQVKS5hXVzruXPUIsVu7Dw6jKHE0o1/tM8plNrl
	 WGBeckizZKtJLttyrMaUF3TP/dBbKsMINHO9RSoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Samuel Pitoiset <samuel.pitoiset@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 110/228] drm/amd/display: Fix NULL pointer dereference in amdgpu_dm_crtc_set_vblank()
Date: Thu, 20 Aug 2026 16:54:12 +0200
Message-ID: <20260820145247.979865473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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
@@ -287,7 +287,7 @@ static inline int amdgpu_dm_crtc_set_vbl
 
 	irq_type = amdgpu_display_crtc_idx_to_irq_type(adev, acrtc->crtc_id);
 
-	if (enable) {
+	if (enable && acrtc_state->stream) {
 		struct dc *dc = adev->dm.dc;
 		struct drm_vblank_crtc *vblank = drm_crtc_vblank_crtc(crtc);
 		struct psr_settings *psr = &acrtc_state->stream->link->psr_settings;


