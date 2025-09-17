Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACE11F09A5;
	Wed, 17 Sep 2025 12:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113050; cv=none; b=TCi1rUfG20PlGNuArcDBUWGD7tiB0qmMv3pD94pVryWa6U6JG0NsEV1K4Uxv623oGDrBTm6KqIQaOvIKPZvDzWpQKBwQbpT+/l6BMsP7nJD60MiwYEOL9Y9GSKYjq6nK7utunTbVHHOwddILTfkE2QhV4K+juqR9A3IsADQ6myE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113050; c=relaxed/simple;
	bh=QM4e1kFEi/FelQbOtIGf19c45w7tYwfREyeAPqeG1bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E1J3CqLbpprhnM7fKnGW6pemYjDlOVSK6MafRO/Nx1mP13q9KyDoBuJtgKfrzO0Mt6Za8QkfuqWt9BS70aXYnJ4PMD0ZPRUNN8/xzgJORmEI2n34mrmYx6Hku9U4Pijyi2+Ccx2QYKhyfC9ImK5wLf14B8akYbUDTi6cejM91AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BY3paBlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BY3paBlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66565C4CEF5;
	Wed, 17 Sep 2025 12:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113049;
	bh=QM4e1kFEi/FelQbOtIGf19c45w7tYwfREyeAPqeG1bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BY3paBlGz+eOKA9l0O7Y3v1lDK9MZTT9Wq2AVXUR2MsmVEimzqpTebHnhJ7Phdt/k
	 M1f5kSaHDM8pG9hZO6UmmryzEXaTTFPwGlJJMUYDz3wgroccgWMCmFqyqa1UHZQ0kw
	 2o2cPNdQSjFVsZ94ZksWSHgjJPmsN7yy1RvZ9d+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	=?UTF-8?q?Przemys=C5=82aw=20Kopa?= <prz.kopa@gmail.com>,
	Kalvin <hikaph+oss@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 111/189] drm/amd/display: Drop dm_prepare_suspend() and dm_complete()
Date: Wed, 17 Sep 2025 14:33:41 +0200
Message-ID: <20250917123354.579443162@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Mario Limonciello (AMD)" <mario.limonciello@amd.com>

[ Upstream commit 60f71f0db7b12f303789ef59949e38ee5838ee8b ]

[Why]
dm_prepare_suspend() was added in commit 50e0bae34fa6b
("drm/amd/display: Add and use new dm_prepare_suspend() callback")
to allow display to turn off earlier in the suspend sequence.

This caused a regression that HDMI audio sometimes didn't work
properly after resume unless audio was playing during suspend.

[How]
Drop dm_prepare_suspend() callback. All code in it will still run
during dm_suspend(). Also drop unnecessary dm_complete() callback.
dm_complete() was used for failed prepare and also for any case
of successful resume.  The code in it already runs in dm_resume().

This change will introduce more time that the display is turned on
during suspend sequence. The compositor can turn it off sooner if
desired.

Cc: Harry Wentland <harry.wentland@amd.com>
Reported-by: Przemysław Kopa <prz.kopa@gmail.com>
Closes: https://lore.kernel.org/amd-gfx/1cea0d56-7739-4ad9-bf8e-c9330faea2bb@kernel.org/T/#m383d9c08397043a271b36c32b64bb80e524e4b0f
Reported-by: Kalvin <hikaph+oss@gmail.com>
Closes: https://github.com/alsa-project/alsa-lib/issues/465
Closes: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/4809
Fixes: 50e0bae34fa6b ("drm/amd/display: Add and use new dm_prepare_suspend() callback")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2fd653b9bb5aacec5d4c421ab290905898fe85a2)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   21 ---------------------
 1 file changed, 21 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3135,25 +3135,6 @@ static void dm_destroy_cached_state(stru
 	dm->cached_state = NULL;
 }
 
-static void dm_complete(struct amdgpu_ip_block *ip_block)
-{
-	struct amdgpu_device *adev = ip_block->adev;
-
-	dm_destroy_cached_state(adev);
-}
-
-static int dm_prepare_suspend(struct amdgpu_ip_block *ip_block)
-{
-	struct amdgpu_device *adev = ip_block->adev;
-
-	if (amdgpu_in_reset(adev))
-		return 0;
-
-	WARN_ON(adev->dm.cached_state);
-
-	return dm_cache_state(adev);
-}
-
 static int dm_suspend(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
@@ -3579,10 +3560,8 @@ static const struct amd_ip_funcs amdgpu_
 	.early_fini = amdgpu_dm_early_fini,
 	.hw_init = dm_hw_init,
 	.hw_fini = dm_hw_fini,
-	.prepare_suspend = dm_prepare_suspend,
 	.suspend = dm_suspend,
 	.resume = dm_resume,
-	.complete = dm_complete,
 	.is_idle = dm_is_idle,
 	.wait_for_idle = dm_wait_for_idle,
 	.check_soft_reset = dm_check_soft_reset,


