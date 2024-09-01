Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A2B17C;
	Sun,  1 Sep 2024 17:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210332; cv=none; b=CI2nPDMPjlg9ivOxHwnafVqKTQHVueOo5hI7dgmxRWTtZ2qCB+vDtbiq9hFTBoL+61VMpTZG/PrOks6fMbcZK6pEtIWTc9xTArXVAkFrFav8KZkm1z0dVLX9KvV5rDwXAOB0UPoknDx2xmaQxQ8H/cLyVz+R1vYcNCEBQxsnp3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210332; c=relaxed/simple;
	bh=mJ7xZ+EMQLxyxuZVAwSgAJNEiVT75t9wB9/iiil9Q+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mr7fIW9BKtLYUcLja+2SuPy/qjAbO6D2ZPpuogeE6FVGgd9ga7KZj5i+n1gWn/bCfi0uMp3desEPq9QNKUB1kNbWeQTLJNIRc0kHsi9lO17SzrT52XIHCdToJbNCItL6jRD0xy1PINJ/ams6eqERwd6KFCy0Np5axPjeG8LFzVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0K7lhEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0K7lhEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BC9C4CEC3;
	Sun,  1 Sep 2024 17:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210331;
	bh=mJ7xZ+EMQLxyxuZVAwSgAJNEiVT75t9wB9/iiil9Q+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0K7lhEgJdfGUqO7VjqPqtQyoKPrhBZv1FbM3R9iczXalvSMF3j7QVhsKmbeOkCio
	 ZT/Vlj91bXXkC4WvDmFn9JIGfy4ltPvf/A/hX4IqwtXkMCrtnOluykxetJHEfxwb0L
	 Vfuozj27tGDcaUdODVXIQbAQoZ5timfce7aM16u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/215] drm/msm/dpu: cleanup FB if dpu_format_populate_layout fails
Date: Sun,  1 Sep 2024 18:17:49 +0200
Message-ID: <20240901160829.297181920@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9c30ab106b0a1..3ee9a92ffed57 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -906,6 +906,9 @@ static int dpu_plane_prepare_fb(struct drm_plane *plane,
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



