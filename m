Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5FE11703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83877C433C7;
	Mon, 21 Aug 2023 19:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647936;
	bh=JedshCUy6kyjG/ozUNf+TOBCYl3EHszl87/0oN85Cj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjEUyDcsM6iWGJQtSkAoOZhYRtaNwGo8M4ok6syNUWXe+JofnUlzAt1QvY3i1bj2t
	 zdgtB6VugWynVFMR5UvTqummXQwBWUAZWOQz3UlVJXdnZ1RAYmcwYpeNqNjFsfpvDd
	 rUxxcv29GDkS6MjR7vy0EGhtMaBKvJpmuvFcTxRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tim Huang <tim.huang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 162/194] drm/amd: flush any delayed gfxoff on suspend entry
Date: Mon, 21 Aug 2023 21:42:21 +0200
Message-ID: <20230821194129.823212332@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit a7b7d9e8aee4f71b4c7151702fd74237b8cef989 upstream.

DCN 3.1.4 is reported to hang on s2idle entry if graphics activity
is happening during entry.  This is because GFXOFF was scheduled as
delayed but RLC gets disabled in s2idle entry sequence which will
hang GFX IP if not already in GFXOFF.

To help this problem, flush any delayed work for GFXOFF early in
s2idle entry sequence to ensure that it's off when RLC is changed.

commit 4b31b92b143f ("drm/amdgpu: complete gfxoff allow signal during
suspend without delay") modified power gating flow so that if called
in s0ix that it ensured that GFXOFF wasn't put in work queue but
instead processed immediately.

This is dead code due to commit 10cb67eb8a1b ("drm/amdgpu: skip
CG/PG for gfx during S0ix") because GFXOFF will now not be explicitly
called as part of the suspend entry code.  Remove that dead code.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c    |    9 +--------
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4232,6 +4232,7 @@ int amdgpu_device_suspend(struct drm_dev
 		drm_fb_helper_set_suspend_unlocked(adev_to_drm(adev)->fb_helper, true);
 
 	cancel_delayed_work_sync(&adev->delayed_init_work);
+	flush_delayed_work(&adev->gfx.gfx_off_delay_work);
 
 	amdgpu_ras_suspend(adev);
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -585,15 +585,8 @@ void amdgpu_gfx_off_ctrl(struct amdgpu_d
 
 		if (adev->gfx.gfx_off_req_count == 0 &&
 		    !adev->gfx.gfx_off_state) {
-			/* If going to s2idle, no need to wait */
-			if (adev->in_s0ix) {
-				if (!amdgpu_dpm_set_powergating_by_smu(adev,
-						AMD_IP_BLOCK_TYPE_GFX, true))
-					adev->gfx.gfx_off_state = true;
-			} else {
-				schedule_delayed_work(&adev->gfx.gfx_off_delay_work,
+			schedule_delayed_work(&adev->gfx.gfx_off_delay_work,
 					      delay);
-			}
 		}
 	} else {
 		if (adev->gfx.gfx_off_req_count == 0) {


