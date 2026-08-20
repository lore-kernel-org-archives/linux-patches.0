Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EB8469859;
	Thu, 20 Aug 2026 17:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247164; cv=none; b=DEiMtmVY8cBOLnKhdNeOJcbyAtrC9fRv6j8PVp1SSHrm251YTboQGj2LnChAY8wkIfqHbSJTVhY1atfm5ePH91yH3WJQ3uqnmB+Wkg0UIxaKEcID20ac038jT4lpNpeWDqCyP4N4XnU+I9C3khDBMlj5drwAQ+wCoIrzRLVVLSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247164; c=relaxed/simple;
	bh=/Iwh1qIeTrH+XAlZ9DYHfxjjvhhpbSJYvZoJTiqU8U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7CdPZk2p8jHYsvgq4OMuKQ60ZLXxDKGbQZLUkEDw95fvKbq6gKop5aB6sDw9Kbck7fIGKL7l19vsWYx3v/FdjiaYwPkChTFKOUMkrHhpSe5eIFsDSIA9R+Lr6CeaR7lZ/DJQxsCpcqm9onN/FkEulCFr0fw5865fxa9be3dln4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZ/XBoSu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZ/XBoSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413DE1F00A3A;
	Thu, 20 Aug 2026 17:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247162;
	bh=Afbufjz7tmF0fRPJ6mLeF1aYHcSPyGnOeh3otoYmbRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZ/XBoSu0cIuS4Cj9T22+TQoxYV2CSOete6zI+57tYf46hYiQErJajPFf4UQa7uDo
	 IciA5BMrWkfWAoeUzSdLAAc4gfEshL4xXARSuFUOByAnMvoe5MUlP6BU9mP28OfXHG
	 mHa1pXEI2O9ysmNdk6phUVS67ThPNrgW9G1R0AMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/220] drm/amd/pm: fix torn gpu metrics reads
Date: Thu, 20 Aug 2026 16:56:00 +0200
Message-ID: <20260820145228.587061664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1318,17 +1318,23 @@ int amdgpu_dpm_set_power_profile_mode(st
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
@@ -1889,7 +1889,6 @@ static ssize_t amdgpu_get_gpu_metrics(st
 {
 	struct drm_device *ddev = dev_get_drvdata(dev);
 	struct amdgpu_device *adev = drm_to_adev(ddev);
-	void *gpu_metrics;
 	ssize_t size = 0;
 	int ret;
 
@@ -1904,15 +1903,10 @@ static ssize_t amdgpu_get_gpu_metrics(st
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
@@ -513,7 +513,8 @@ int amdgpu_dpm_get_power_profile_mode(st
 				      char *buf);
 int amdgpu_dpm_set_power_profile_mode(struct amdgpu_device *adev,
 				      long *input, uint32_t size);
-int amdgpu_dpm_get_gpu_metrics(struct amdgpu_device *adev, void **table);
+ssize_t amdgpu_dpm_get_gpu_metrics(struct amdgpu_device *adev, void *buf,
+				   size_t size);
 
 /**
  * @get_pm_metrics: Get one snapshot of power management metrics from PMFW. The


