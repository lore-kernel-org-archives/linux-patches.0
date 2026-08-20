Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9D247F79B;
	Thu, 20 Aug 2026 17:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247667; cv=none; b=GqC0AKBBXPemQp00CQiARvJSa2e10CJBrzn6lr2cBdP5ONBwJ51bH3XJ/Gc5ovl3bfOt4ITuF+o6BVTQ4jrAYtT113HcRva0u0VjotQOmUwFYPKN/QlPBRzmCJ2ZzRq1qfyZWjUCA6jB67m2yBRJLRtgZsL5cIQ0ZRHLrwki/YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247667; c=relaxed/simple;
	bh=TC+AZOVTv7YDIY1bSIX4DY0bq+HjgST4VelHXm2fjDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/nm0A+/zpbvUPsMaQz0VcBlxf1GUpZzSeVa0A1CzhCUbmTZ7SLimKcAeJTAoEE06rXvMzFQL6WnuMIj6Ijt/ggPi0SEt5ag0DH/YIaw2HHTLyDI2P6wIF7jhIj3h5e9JUUpwI+L+cTP1PbEk6ndwaeYkDyraZNzyFmTkDjsqNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LV3QiwY9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LV3QiwY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A201F000E9;
	Thu, 20 Aug 2026 17:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247665;
	bh=nV1ulPOAAM044hWtNh5EO3thd4QdiBgAZj8QiV3E/Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LV3QiwY955u7a4jCG0KJRjyQBITdD9BbXAybch1D6VtXkoyKpUBWW8ALUKxknTiHw
	 XuGb6+WMDIl2GRK4ex0HEz1mKL4y47Fcbjj9rCuAHdc2ECyEtgqqm4cFBafw25kTlX
	 CIWGUA86szkKKEzbN9TfkGSTVJnrxsgM6timiiyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/166] drm/amd/pm: fix torn gpu metrics reads
Date: Thu, 20 Aug 2026 16:56:26 +0200
Message-ID: <20260820145214.984845335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 048f4541b71fb19645fb79d6e62e6e4da23a4035 ]

amdgpu_dpm_get_gpu_metrics() returns a pointer to the shared metrics cache
after dropping adev->pm.mutex. The sysfs path then copies from that pointer.
Another reader can refresh the cache in place during the copy and return a
snapshot containing data from two generations.

Pass caller-provided storage through the DPM interface and copy the metrics
while the mutex is held. This keeps the cache pointer private and makes each
sysfs read observe one complete sample.

Fixes: 25c933b1c4fc ("drm/amd/powerplay: add new sysfs interface for retrieving gpu metrics(V2)")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 862333bb48693ecafcae25af0c9d9ec31015ac77)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c     |   12 +++++++++---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c      |    8 +-------
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h |    3 ++-
 3 files changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -1255,17 +1255,23 @@ int amdgpu_dpm_set_power_profile_mode(st
 	return ret;
 }
 
-int amdgpu_dpm_get_gpu_metrics(struct amdgpu_device *adev, void **table)
+ssize_t amdgpu_dpm_get_gpu_metrics(struct amdgpu_device *adev, void *buf,
+				   size_t size)
 {
 	const struct amd_pm_funcs *pp_funcs = adev->powerplay.pp_funcs;
-	int ret = 0;
+	void *table;
+	ssize_t ret;
 
 	if (!pp_funcs->get_gpu_metrics)
 		return 0;
 
 	mutex_lock(&adev->pm.mutex);
 	ret = pp_funcs->get_gpu_metrics(adev->powerplay.pp_handle,
-					table);
+					&table);
+	if (ret > 0) {
+		ret = min_t(ssize_t, ret, size);
+		memcpy(buf, table, ret);
+	}
 	mutex_unlock(&adev->pm.mutex);
 
 	return ret;
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1781,7 +1781,6 @@ static ssize_t amdgpu_get_gpu_metrics(st
 {
 	struct drm_device *ddev = dev_get_drvdata(dev);
 	struct amdgpu_device *adev = drm_to_adev(ddev);
-	void *gpu_metrics;
 	ssize_t size = 0;
 	int ret;
 
@@ -1796,15 +1795,10 @@ static ssize_t amdgpu_get_gpu_metrics(st
 		return ret;
 	}
 
-	size = amdgpu_dpm_get_gpu_metrics(adev, &gpu_metrics);
+	size = amdgpu_dpm_get_gpu_metrics(adev, buf, PAGE_SIZE - 1);
 	if (size <= 0)
 		goto out;
 
-	if (size >= PAGE_SIZE)
-		size = PAGE_SIZE - 1;
-
-	memcpy(buf, gpu_metrics, size);
-
 out:
 	pm_runtime_mark_last_busy(ddev->dev);
 	pm_runtime_put_autosuspend(ddev->dev);
--- a/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
+++ b/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
@@ -493,7 +493,8 @@ int amdgpu_dpm_get_power_profile_mode(st
 				      char *buf);
 int amdgpu_dpm_set_power_profile_mode(struct amdgpu_device *adev,
 				      long *input, uint32_t size);
-int amdgpu_dpm_get_gpu_metrics(struct amdgpu_device *adev, void **table);
+ssize_t amdgpu_dpm_get_gpu_metrics(struct amdgpu_device *adev, void *buf,
+				   size_t size);
 int amdgpu_dpm_get_fan_control_mode(struct amdgpu_device *adev,
 				    uint32_t *fan_mode);
 int amdgpu_dpm_set_fan_speed_pwm(struct amdgpu_device *adev,


