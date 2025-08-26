Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B2F337688;
	Tue, 26 Aug 2025 11:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207662; cv=none; b=u7zaOtgFV9aCT+QbjUopsGQZoYSuKCTVCjs8upagyQOUDIsHZHBeSvHKTZZGCtjp/tzE4pzp4zyUaJAKSbahza0uzPjOE26DUtFDgnC5M2LSMjcQ+4VrYRzr2hMb0Mz+sbxJvxaxdyJtG28/Vyf/cce/nQ64cKHJkZvlmjoPziM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207662; c=relaxed/simple;
	bh=CrASDGBaaxR1UBuukgLmrrouJfyLJEBA4DhMPtpx3NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOmcXToCfB2tkDZGoM94aD6QCgb44t3283bSIMVLnxaxnWILp1CU4zl89IcBmNsgmFiOjtrqT7S/xQEpo3bjuuDbnsGtWnq6eWUsfzKHg2WyJnIilcd4Z+Y+8OwRmur5P5MxTc/LveN09BY9T2cExaGdoq3PHucFNGYOCWQT/bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fLe7nZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fLe7nZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00BAC113CF;
	Tue, 26 Aug 2025 11:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207662;
	bh=CrASDGBaaxR1UBuukgLmrrouJfyLJEBA4DhMPtpx3NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fLe7nZDgh/p9ULmv0WCwfJgEQ154alR4IAHUkfNVQeYCtCcVbFhPYjaku0mcctfX
	 HzBIwJZQ2Q+6EW/biouaiE3+o+v/tWQl/660qvnonZdU9Zzrgkny3Q6ylCvJmb20Xq
	 REagnCm7te9bCezRv2KR1ImUWg83+QaSSUh+zqiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Sun peng (Leo) Li" <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.16 269/457] drm/amd/display: Fix Xorg desktop unresponsive on Replay panel
Date: Tue, 26 Aug 2025 13:09:13 +0200
Message-ID: <20250826110944.024264673@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

commit 66af73a1c319336694a8610fe4c2943f7b33066c upstream.

[WHY & HOW]
IPS & self-fresh feature can cause vblank counter resets between
vblank disable and enable.
It may cause system stuck due to wait the vblank counter.

Call the drm_crtc_vblank_restore() during vblank enable to estimate
missed vblanks by using timestamps and update the vblank counter in
DRM.

It can make the vblank counter increase smoothly and resolve this issue.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Sun peng (Leo) Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 34d66bc7ff10e146a4cec76cf286979740a10954)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   19 +++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -299,6 +299,25 @@ static inline int amdgpu_dm_crtc_set_vbl
 	irq_type = amdgpu_display_crtc_idx_to_irq_type(adev, acrtc->crtc_id);
 
 	if (enable) {
+		struct dc *dc = adev->dm.dc;
+		struct drm_vblank_crtc *vblank = drm_crtc_vblank_crtc(crtc);
+		struct psr_settings *psr = &acrtc_state->stream->link->psr_settings;
+		struct replay_settings *pr = &acrtc_state->stream->link->replay_settings;
+		bool sr_supported = (psr->psr_version != DC_PSR_VERSION_UNSUPPORTED) ||
+								pr->config.replay_supported;
+
+		/*
+		 * IPS & self-refresh feature can cause vblank counter resets between
+		 * vblank disable and enable.
+		 * It may cause system stuck due to waiting for the vblank counter.
+		 * Call this function to estimate missed vblanks by using timestamps and
+		 * update the vblank counter in DRM.
+		 */
+		if (dc->caps.ips_support &&
+			dc->config.disable_ips != DMUB_IPS_DISABLE_ALL &&
+			sr_supported && vblank->config.disable_immediate)
+			drm_crtc_vblank_restore(crtc);
+
 		/* vblank irq on -> Only need vupdate irq in vrr mode */
 		if (amdgpu_dm_crtc_vrr_active(acrtc_state))
 			rc = amdgpu_dm_crtc_set_vupdate_irq(crtc, true);


