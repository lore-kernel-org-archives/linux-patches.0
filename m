Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B671C57A9;
	Tue, 27 Aug 2024 15:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771470; cv=none; b=NFGQpRBS0GnWhYMlSjgF1kf9PbnGaSNyjzbgYVqtwhRuC8ae7TafwC7RpBzNwxmRgEnK2I5HrdbaBq4XbPa/OTfDCJyvlQKgYuRZ6hRKUqfo1RrpH3Z6Xhci1AY3JRtdPTVPj6ceEUJ+vkBUXo6RadMvOgDyEYvJlmJ8d8Jj9Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771470; c=relaxed/simple;
	bh=V0bpvby739mAYOnxEWKk4ICa+/PvKKcHXuDQ2HZool4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcQCSk4tIOsiQmC860BA4N7mW/sMe82wXjjVqnyGHCjVHLbZbPmYGT0YZh4Gk3MLt+t1UJlV+hY2bH4klmIAvlZs14iM1CJVZf79hnxpGQeocXlj95xXrbmBsb5/Ho8tegdevpn94wPyZgwMsoaRaopO7D+9Qrw3ioIgN+M3IM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyc68ZTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyc68ZTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E98C4DDED;
	Tue, 27 Aug 2024 15:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771470;
	bh=V0bpvby739mAYOnxEWKk4ICa+/PvKKcHXuDQ2HZool4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyc68ZTQ8R6+FwuoXGWRV+hElYrm5ncnhUoBajGqSTqYZSkMsVIJbTgxS0dV8k64A
	 IiZcjkLKp/RLgOpK2UAi/IQJXUHfiEou8AUebjplDls8SY/IY0KnYywZJloxnSalGA
	 /DBgM8xPbwAln33uFKpKsLuP0xs5xsRg2tioiZIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 196/273] drm/msm/dpu: cleanup FB if dpu_format_populate_layout fails
Date: Tue, 27 Aug 2024 16:38:40 +0200
Message-ID: <20240827143840.868101388@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1c3a2657450c6..eabc4813c649c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -680,6 +680,9 @@ static int dpu_plane_prepare_fb(struct drm_plane *plane,
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



