Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7E3151CE8;
	Tue, 20 Feb 2024 21:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463774; cv=none; b=V9YI68EoYaqg+fe6BsxeijPOZ/ildIjNZggMdriHBQyfMdtRkMy3P637aoaaHDKXGGaPBDLgnVOQzFVmin9QuL6mVRNB6iH7np0n9FfowvoPhXMhYgtcZMj6gkfQ15AhNRi/1DInhUN0kUyVTyJRDe/to3yqou55wRtjUtuLdmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463774; c=relaxed/simple;
	bh=lRF4kESXDsBMSL5vdWZt+yXmj6yNXIsFtKlPfMkEheE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5H3q8GFUpiIYSdvZl2bXtySkPHVAXmkYhmPPaY+j+cgCJQSmb7L3IZIhGl1bAThQYAllaeoN7XGnDHM11Pff4/MIVavC/qTUf5IgKP7gox/bpYxrfedVdvnoBSotZM7gRWp1AE8k7KR+gD2fgITCz6aJgQdOStvZqqXs7tZIJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0y/16rr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0y/16rr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375E9C433F1;
	Tue, 20 Feb 2024 21:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463774;
	bh=lRF4kESXDsBMSL5vdWZt+yXmj6yNXIsFtKlPfMkEheE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0y/16rr/hxNn1qua5bL0A7la78wOjn4PIprvrRej/KYW9L+DkWuTAXGYyTx2COix7
	 /nA4JZBjSVho+LUSNHqSG6RgOokQM5SkAHe+e0KJ8iLXmmfQ3TGyxhDD3nYBrh+QlB
	 ko+n0t6Gu6a8/K3Rudb0wEUU55jEFuG/I5jZl33E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.6 119/331] Revert "drm/amd: flush any delayed gfxoff on suspend entry"
Date: Tue, 20 Feb 2024 21:53:55 +0100
Message-ID: <20240220205641.351446812@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 916361685319098f696b798ef1560f69ed96e934 upstream.

commit ab4750332dbe ("drm/amdgpu/sdma5.2: add begin/end_use ring
callbacks") caused GFXOFF control to be used more heavily and the
codepath that was removed from commit 0dee72639533 ("drm/amd: flush any
delayed gfxoff on suspend entry") now can be exercised at suspend again.

Users report that by using GNOME to suspend the lockscreen trigger will
cause SDMA traffic and the system can deadlock.

This reverts commit 0dee726395333fea833eaaf838bc80962df886c8.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Fixes: ab4750332dbe ("drm/amdgpu/sdma5.2: add begin/end_use ring callbacks")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c    |    9 ++++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4133,7 +4133,6 @@ int amdgpu_device_suspend(struct drm_dev
 		drm_fb_helper_set_suspend_unlocked(adev_to_drm(adev)->fb_helper, true);
 
 	cancel_delayed_work_sync(&adev->delayed_init_work);
-	flush_delayed_work(&adev->gfx.gfx_off_delay_work);
 
 	amdgpu_ras_suspend(adev);
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -702,8 +702,15 @@ void amdgpu_gfx_off_ctrl(struct amdgpu_d
 
 		if (adev->gfx.gfx_off_req_count == 0 &&
 		    !adev->gfx.gfx_off_state) {
-			schedule_delayed_work(&adev->gfx.gfx_off_delay_work,
+			/* If going to s2idle, no need to wait */
+			if (adev->in_s0ix) {
+				if (!amdgpu_dpm_set_powergating_by_smu(adev,
+						AMD_IP_BLOCK_TYPE_GFX, true))
+					adev->gfx.gfx_off_state = true;
+			} else {
+				schedule_delayed_work(&adev->gfx.gfx_off_delay_work,
 					      delay);
+			}
 		}
 	} else {
 		if (adev->gfx.gfx_off_req_count == 0) {


