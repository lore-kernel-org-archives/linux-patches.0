Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A6C46D091;
	Thu, 20 Aug 2026 16:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243964; cv=none; b=URUPrrIaDTjJ1nbCDKvvhbSodhvzsIWAJOERHDvIL+trr41NsPDd5Eis3FV4HxCxzVIUEygIzr1dRrGncZrWlBFBSDjOb1lVll/Fkw3m6Sh4AMvbzIVPPsVzrg/raZS49GPMlUCPlIcp5edGyuQ+wKJWZc1G36qt5fbea7u0RfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243964; c=relaxed/simple;
	bh=WI/LB9QJziQTF09pkUaEHn5N526HwdxObpuT2AKA2dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jo5u6vUOi/zf0ZI8Y2pAK/kyIGYOKhBqMgAbORpsz0O9i65PBm5T5cqsOawBA3mAVs+ELVu6zltSKG+LfjQHDYeu4NGHXDIJWEfIf4V+9ErOOnPsRc5BxP7oty4hXwYqhHAs9loDGH/pEnIp1MS0zovONO6tFqWI015Bd0dmLUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=043CWMJB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="043CWMJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7338A1F000E9;
	Thu, 20 Aug 2026 16:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243963;
	bh=k8H2p849ASZBrxjlcqvKm5+//i+ZhszP7lx4bj5ajRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=043CWMJBpFycI5aNpcX4qnDuD8CblZFvqukJ6wWJ00EckkTSOeDf81wvP00sNPwsp
	 4+pd/pzSRjt3UFa2qpbj2IgCj4DHDRPmjT82wNcauEYpWAky3NlXSGGMVOwPOXb/zE
	 je31qYZqeUgyJoc135m+FUK4VnIv7lpDV9HwKJq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 246/272] drm/amd/pm: fix torn gpu metrics reads
Date: Thu, 20 Aug 2026 16:57:10 +0200
Message-ID: <20260820145239.003247728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ applied the fix at the caller `amdgpu_get_gpu_metrics()` in amdgpu_pm.c since the `amdgpu_dpm_get_gpu_metrics()` wrapper is a macro on this tree ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1804,18 +1804,16 @@ static ssize_t amdgpu_get_gpu_metrics(st
 		return ret;
 	}
 
+	mutex_lock(&adev->pm.mutex);
 	if (adev->powerplay.pp_funcs->get_gpu_metrics)
 		size = amdgpu_dpm_get_gpu_metrics(adev, &gpu_metrics);
 
-	if (size <= 0)
-		goto out;
-
-	if (size >= PAGE_SIZE)
-		size = PAGE_SIZE - 1;
-
-	memcpy(buf, gpu_metrics, size);
+	if (size > 0) {
+		size = min_t(ssize_t, size, PAGE_SIZE - 1);
+		memcpy(buf, gpu_metrics, size);
+	}
+	mutex_unlock(&adev->pm.mutex);
 
-out:
 	pm_runtime_mark_last_busy(ddev->dev);
 	pm_runtime_put_autosuspend(ddev->dev);
 


