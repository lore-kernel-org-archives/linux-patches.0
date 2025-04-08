Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B9726FD89;
	Tue,  8 Apr 2025 12:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115892; cv=none; b=slujB8asfc3vU6daflreLyD2lItC5FaORIy9kRRoA17gOyK4V6X46s0SnazKwWgmr3cnIe4mL5krxEBKoMpguacSWL7/zC+A+biPB7BCxYvrOYu2ESJ2dsT32w+hLxYJ0hjNBpIbGWzoCJaIG5TQJPGfTupNSy+oGKSWI6z2XTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115892; c=relaxed/simple;
	bh=bQuGi26xgIfjcbUoCPNqs79flZDlBx9AOufiKGTg+yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGX5KplUt1XvKSLu1Zyc4gsvSnFvlKN69JaQ2jL7fTSVN8hNABOtCS89kA9jr4SFJJJ31e5kqVF/PhWX2ASR9kLAw0+HThRadIfWH0+qecokWyxUEBh5uXoGvdiWnsrqO8G6tNYEC6H+wXqf6PGQHXj36uCJUiwx40u8xOyKV3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TX5/8Inn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TX5/8Inn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342FEC4CEE5;
	Tue,  8 Apr 2025 12:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115892;
	bh=bQuGi26xgIfjcbUoCPNqs79flZDlBx9AOufiKGTg+yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TX5/8Innnpa8v7oWDXd1dvvvIuLA/vjlQEeaHB4AgmhGPHkUhzZ0WmuZoCKvNJtCJ
	 JMdTWaUbtL1LjDCtWpsONiS4glT0l1nWzq0pjXTdUa4kolOANj+BalfYVA4gbR3fU2
	 YcBlGIAMqf903Z7zkG42KOruwQv6oEW9upSG/Xwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xaver Hugl <xaver.hugl@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/204] drm/amd: Keep display off while going into S4
Date: Tue,  8 Apr 2025 12:51:13 +0200
Message-ID: <20250408104824.493357706@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 4afacc9948e1f8fdbca401d259ae65ad93d298c0 ]

When userspace invokes S4 the flow is:

1) amdgpu_pmops_prepare()
2) amdgpu_pmops_freeze()
3) Create hibernation image
4) amdgpu_pmops_thaw()
5) Write out image to disk
6) Turn off system

Then on resume amdgpu_pmops_restore() is called.

This flow has a problem that because amdgpu_pmops_thaw() is called
it will call amdgpu_device_resume() which will resume all of the GPU.

This includes turning the display hardware back on and discovering
connectors again.

This is an unexpected experience for the display to turn back on.
Adjust the flow so that during the S4 sequence display hardware is
not turned back on.

Reported-by: Xaver Hugl <xaver.hugl@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/2038
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Link: https://lore.kernel.org/r/20250306185124.44780-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 68bfdc8dc0a1a7fdd9ab61e69907ae71a6fd3d91)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c           | 11 +++++++++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  5 +++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 238c15c0c7e1e..48076cf8ba803 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2466,7 +2466,6 @@ static int amdgpu_pmops_freeze(struct device *dev)
 
 	adev->in_s4 = true;
 	r = amdgpu_device_suspend(drm_dev, true);
-	adev->in_s4 = false;
 	if (r)
 		return r;
 
@@ -2478,8 +2477,13 @@ static int amdgpu_pmops_freeze(struct device *dev)
 static int amdgpu_pmops_thaw(struct device *dev)
 {
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
+	struct amdgpu_device *adev = drm_to_adev(drm_dev);
+	int r;
 
-	return amdgpu_device_resume(drm_dev, true);
+	r = amdgpu_device_resume(drm_dev, true);
+	adev->in_s4 = false;
+
+	return r;
 }
 
 static int amdgpu_pmops_poweroff(struct device *dev)
@@ -2492,6 +2496,9 @@ static int amdgpu_pmops_poweroff(struct device *dev)
 static int amdgpu_pmops_restore(struct device *dev)
 {
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
+	struct amdgpu_device *adev = drm_to_adev(drm_dev);
+
+	adev->in_s4 = false;
 
 	return amdgpu_device_resume(drm_dev, true);
 }
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 9b3f5f76d52d9..5a837e3df7f38 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2897,6 +2897,11 @@ static int dm_resume(void *handle)
 
 		return 0;
 	}
+
+	/* leave display off for S4 sequence */
+	if (adev->in_s4)
+		return 0;
+
 	/* Recreate dc_state - DC invalidates it when setting power state to S3. */
 	dc_release_state(dm_state->context);
 	dm_state->context = dc_create_state(dm->dc);
-- 
2.39.5



