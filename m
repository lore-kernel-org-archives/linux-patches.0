Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46DB34CDD;
	Fri,  7 Aug 2026 15:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115575; cv=none; b=HsAqx9tTU6mUZIIiZ7oslOLV0l7Or+VsqysQhZqvNAN/2pPgOKMxz/gTC9GgpRrn9W+WMtL1dWEGwLUJvswMQOmCIT/tyM/jAh16a0UHfFp1Q2X30M6wgjBo5q6VzQVjAzRZcQ/JPEwLzhxfkbqNoB/0X6C3KrED4TpXW3xj6fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115575; c=relaxed/simple;
	bh=d74gtvBSmSIbecAYEioF0/rG8zACOf/O80gjFTFxzvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQGkI4tGJ64YlGvxd7D9sga3C9bzVB4M2sLMUfY1rVkam5atBXna250dXSlFyK9Bi1K+gFHZxgSwZWOop9I/gIPSwuJcAswOSk+VvvGEsKWO6u0kfvtSl0CM3cfuK/rgGB/fvPRRgTfOBqNDk8eymGXdutA4nkodgJvKg2PcmZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFTWUOoZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFTWUOoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B83C1F000E9;
	Fri,  7 Aug 2026 15:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115573;
	bh=YiqTRUmuDil16MYJ6KdSo7S2jbJ8Ez0R6RWOmX7t+Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFTWUOoZ8LBnLqCygrj1Kb+1qb3NIF6XCVb15Um07p4d1nV2K7p9Hh+cM8RaskhSC
	 3KgtXtH+0sCaUhUddW05R4KGFnsAA2D915HsdMPeNdiSlxi7Jws4whtWuqCn/JQlsb
	 0cf79YLeOFdMRJ4uFH82D9eOJFA11OfwJPVgna6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 322/396] drm/amd/pm: fix torn gpu metrics reads
Date: Fri,  7 Aug 2026 16:38:02 +0200
Message-ID: <20260807143431.211733081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit 048f4541b71fb19645fb79d6e62e6e4da23a4035 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c     |   12 +++++++++---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c      |    8 +-------
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h |    3 ++-
 3 files changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -1442,17 +1442,23 @@ int amdgpu_dpm_set_power_profile_mode(st
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
@@ -1754,7 +1754,6 @@ static ssize_t amdgpu_get_gpu_metrics(st
 {
 	struct drm_device *ddev = dev_get_drvdata(dev);
 	struct amdgpu_device *adev = drm_to_adev(ddev);
-	void *gpu_metrics;
 	ssize_t size = 0;
 	int ret;
 
@@ -1762,15 +1761,10 @@ static ssize_t amdgpu_get_gpu_metrics(st
 	if (ret)
 		return ret;
 
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
 	amdgpu_pm_put_access(adev);
 
--- a/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
+++ b/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
@@ -517,7 +517,8 @@ int amdgpu_dpm_get_power_profile_mode(st
 				      char *buf);
 int amdgpu_dpm_set_power_profile_mode(struct amdgpu_device *adev,
 				      long *input, uint32_t size);
-int amdgpu_dpm_get_gpu_metrics(struct amdgpu_device *adev, void **table);
+ssize_t amdgpu_dpm_get_gpu_metrics(struct amdgpu_device *adev, void *buf,
+				   size_t size);
 ssize_t amdgpu_dpm_get_xcp_metrics(struct amdgpu_device *adev, int xcp_id,
 				   void *table);
 ssize_t amdgpu_dpm_get_temp_metrics(struct amdgpu_device *adev,


