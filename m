Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B291C8228;
	Tue, 27 Aug 2024 15:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772594; cv=none; b=aotNbvjiI8ifuu7wztba5B4e0OTYW2PMNBXqmm/TtNWuyR8rL2rsefqKv+Pk2Ulo+To5OmL04GgBp1D6hyIxt0Evmw2rx2WgrEOgRPeZjjpsfQH1t3VNtT3toQESi8bC7bNmJT2tb14pwdQ2FxNfKg6ikb0j3frRY2M9+rahtP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772594; c=relaxed/simple;
	bh=RYHom4vxaLRscwG+zQWhrh4sHEpRvT+KcT/yEi5BPTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCpn1uTpYykRkY78rp+83IN0JVCxh11Vug/tdzZbN5zZapn0Uhk0z6c3xs/hFP2Qt17EiGrjN9UVOLzl/uEiuD/oLAXirdZK52wnHYRlGdfZ5cwkHDkMOsDw8u7VEGNyO+ebFUUJtV/7XfQQb4FVaXR0nGbvQCbSH9IsOV4ydEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTHxs2rl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTHxs2rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6DCC6107E;
	Tue, 27 Aug 2024 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772594;
	bh=RYHom4vxaLRscwG+zQWhrh4sHEpRvT+KcT/yEi5BPTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTHxs2rlbl/Z9aNVcBsVsE5JNGxmVoF6PgOYuLhHvrnhoyXVfxuXo4f3zDKnuZqrb
	 kDpvMiy3sb8IsUZ90xw0Y1gC9oV1IIH9ucq6bZ1iUohfLbvzkX6Q1w8h92X5nTcZ2P
	 fj1DWvjax7vLN78ho9qoS0QwtVDdHHbUHWlGgEV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 261/321] drm/msm/dpu: cleanup FB if dpu_format_populate_layout fails
Date: Tue, 27 Aug 2024 16:39:29 +0200
Message-ID: <20240827143848.183580345@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit bfa1a6283be390947d3649c482e5167186a37016 ]

If the dpu_format_populate_layout() fails, then FB is prepared, but not
cleaned up. This ends up leaking the pin_count on the GEM object and
causes a splat during DRM file closure:

msm_obj->pin_count
WARNING: CPU: 2 PID: 569 at drivers/gpu/drm/msm/msm_gem.c:121 update_lru_locked+0xc4/0xcc
[...]
Call trace:
 update_lru_locked+0xc4/0xcc
 put_pages+0xac/0x100
 msm_gem_free_object+0x138/0x180
 drm_gem_object_free+0x1c/0x30
 drm_gem_object_handle_put_unlocked+0x108/0x10c
 drm_gem_object_release_handle+0x58/0x70
 idr_for_each+0x68/0xec
 drm_gem_release+0x28/0x40
 drm_file_free+0x174/0x234
 drm_release+0xb0/0x160
 __fput+0xc0/0x2c8
 __fput_sync+0x50/0x5c
 __arm64_sys_close+0x38/0x7c
 invoke_syscall+0x48/0x118
 el0_svc_common.constprop.0+0x40/0xe0
 do_el0_svc+0x1c/0x28
 el0_svc+0x4c/0x120
 el0t_64_sync_handler+0x100/0x12c
 el0t_64_sync+0x190/0x194
irq event stamp: 129818
hardirqs last  enabled at (129817): [<ffffa5f6d953fcc0>] console_unlock+0x118/0x124
hardirqs last disabled at (129818): [<ffffa5f6da7dcf04>] el1_dbg+0x24/0x8c
softirqs last  enabled at (129808): [<ffffa5f6d94afc18>] handle_softirqs+0x4c8/0x4e8
softirqs last disabled at (129785): [<ffffa5f6d94105e4>] __do_softirq+0x14/0x20

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/600714/
Link: https://lore.kernel.org/r/20240625-dpu-mode-config-width-v5-1-501d984d634f@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
index 62d48c0f905e4..61c456c5015a5 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -889,6 +889,9 @@ static int dpu_plane_prepare_fb(struct drm_plane *plane,
 			new_state->fb, &layout);
 	if (ret) {
 		DPU_ERROR_PLANE(pdpu, "failed to get format layout, %d\n", ret);
+		if (pstate->aspace)
+			msm_framebuffer_cleanup(new_state->fb, pstate->aspace,
+						pstate->needs_dirtyfb);
 		return ret;
 	}
 
-- 
2.43.0



