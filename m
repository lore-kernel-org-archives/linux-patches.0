Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D2646D544;
	Thu, 20 Aug 2026 16:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244558; cv=none; b=sG49Ew4tQT8HcXDhepyXbMvPl1O0ak/8AnohiEhwkwntB/gieFW4nn/kOSUypTC/zd+3vKjW8t4LgK+DSdDs+Ih5WTyefYP6GmK5l6bGUXQTBSq9kQzstGYWE9tTr/nB81gt2YzgTdUSERYGlxGhr7mn+tNtqtsOJ0AtjLpBVEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244558; c=relaxed/simple;
	bh=OyC+mlXmEsgdoPwy9ndRj7ySNfL0IJZg18CUj5arBx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C33GS3mWe+rAfwIU2W01b+nPtroE9mxh1L4LYn+Xb6YRTajncLF7e6t2kXvlKW4IfFJ4VTe1mjvJB4sa69heVCrGKIVgR4SqPo6IDUOrp4lwuaj3XbsDwD93uZspbTOLPmINsfazpi29NEQJg5B7JIHm3JQw2mOZ5ShM/tM/JMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBSSfw99; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBSSfw99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810AD1F000E9;
	Thu, 20 Aug 2026 16:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244557;
	bh=PvJKjDW/FwjvUygxuU1QYoiJBqfoBspVjaGK2jaBEts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBSSfw99EvnnAXXPa80UaBSGyFjBfWE8ql/hVVVf5rqBjOgH3+wCu+4IgdsDxxcCe
	 zbGvvt3acw+d/8/P0vlZ2jo0askm7WbA0Khn9qET3IID9Qn65LnaWThJ0N00augCyX
	 Mydn/sdcN5dPpZs37TF0+q6ZvQdlfmwK5uuuuGgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 209/235] drm/amd/pm: fix torn gpu metrics reads
Date: Thu, 20 Aug 2026 16:57:25 +0200
Message-ID: <20260820145222.920196890@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ applied the fix at the sole caller `amdgpu_get_gpu_metrics()` since 5.10 lacks the `amdgpu_dpm_get_gpu_metrics()` wrapper function, wrapping both the swsmu and pp_funcs dispatch branches in `adev->pm.mutex` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1994,20 +1994,18 @@ static ssize_t amdgpu_get_gpu_metrics(st
 		return ret;
 	}
 
+	mutex_lock(&adev->pm.mutex);
 	if (is_support_sw_smu(adev))
 		size = smu_sys_get_gpu_metrics(&adev->smu, &gpu_metrics);
 	else if (adev->powerplay.pp_funcs->get_gpu_metrics)
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
 


