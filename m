Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD863C2F;
	Wed, 21 Feb 2024 13:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523249; cv=none; b=FUckIDsiojwqDel1ogzhnhNcA0U2rp9NsawwDM3imDkKHQicSnSpm8yzxFyXoWOvgolLS9sPGKgPAoi1Zx/sj46ZEF3HgGgR/wctmxfz0bc6Ra9WUNDsO0nPhCdpR984mNEPzylB+WOrd693Lfo4MIa5CilKFTCIRNAysxmiRZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523249; c=relaxed/simple;
	bh=GyhbAIXsSq0Fknkzw5uj0FP7P9w6qmwvKkrV8LY9hq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEi6MXVPYJthchrh31YlM7qISVnydw4ZF/Xjj+KjwTXZ5gle6Mq/IZ5jZfOQTAVIB5u0P4e4cM9Y0eFQlsbVE6oNgybgGnZ/8kmMDIGRoOJdkwkoFYK5P4kLlBJmuy58fSZwYLSzxffOglcH0to5JJ6/fQgreIVQqjquva0WGyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLcyDakV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLcyDakV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5BBC433F1;
	Wed, 21 Feb 2024 13:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523249;
	bh=GyhbAIXsSq0Fknkzw5uj0FP7P9w6qmwvKkrV8LY9hq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLcyDakVDyiGCn8vteGVmAi0FfqWtfe486gy/L+merlhK7Xs/wZdWERFH4gEuFoKQ
	 k1K13FG41CeWqm3pdcm9iurtFS2fYpZZz9prEuEES8pQhUmvvS5tMYQ4Uv3mKF4xB8
	 5HwE7s79d2XCfQ4r/ZFRseERqtsHEYx5jurqTcLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15 377/476] Revert "drm/amd: flush any delayed gfxoff on suspend entry"
Date: Wed, 21 Feb 2024 14:07:08 +0100
Message-ID: <20240221130021.980929281@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
@@ -4089,7 +4089,6 @@ int amdgpu_device_suspend(struct drm_dev
 		amdgpu_fbdev_set_suspend(adev, 1);
 
 	cancel_delayed_work_sync(&adev->delayed_init_work);
-	flush_delayed_work(&adev->gfx.gfx_off_delay_work);
 
 	amdgpu_ras_suspend(adev);
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -579,8 +579,15 @@ void amdgpu_gfx_off_ctrl(struct amdgpu_d
 
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


