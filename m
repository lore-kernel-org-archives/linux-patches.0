Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED5747D949;
	Thu, 20 Aug 2026 17:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247670; cv=none; b=aO/tOSKlD5updU2Ia5YORqv7TsSgySBvI2cRN3FoAMMw6dVBLVjVmHr4NBdsQhGuTLKQA3oExORWNwvZBn7CHovdGl8f26IVvFvU8qLoQyhtALIzcC15+w1RmJHgn9It0gfZuFwNtABhdgN1R8q3L76+WLdBCGTdKE7gazfGAGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247670; c=relaxed/simple;
	bh=v4zupQ/vGaqGURrQjwLYvaWgKlVfJryrV+5+2e4oZcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kteke4e/TBho4q3k2O19y0zV/BhmNWUHoIlb3NjkMEwZJTCSJoSjVX5qRuKsRhp47nWcIuBDznJlC6U6AFzVLvaCdRWl8KCYnlSNotNP9TiOqNeJfm+cs49F81kgESzhkB4RrtnXnaToHos2V6WoL0wyJnDCIO1qpQZIKt1cYfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMlRtLDW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMlRtLDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ED31F000E9;
	Thu, 20 Aug 2026 17:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247668;
	bh=XjyZt/7RKtGGSm+Urnes3at+8fbAQDBvKiKBGa+5OE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMlRtLDWVO+G0WT6y4ukHNPzJ89r9j+U+7DbHWIS+3IbMz+vdBlaATPRMWGlIpNXl
	 hg1wXH+2N6ZhpYZqsenmhcBsXh41usAYY3CRwm6kpiedVUHInL1UaxPaY87ZAT1Oha
	 JS0ZE/Qg9mpA/OgKgfIRDvVeJmsqaN1NUqmh3j+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/166] drm/amd/pm: fix pptable use-after-free
Date: Thu, 20 Aug 2026 16:56:27 +0200
Message-ID: <20260820145215.015851627@linuxfoundation.org>
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

[ Upstream commit bb493058c35c8676e48269ab6732688ea733d23c ]

amdgpu_dpm_get_pp_table() returns a pointer to a driver-owned power table
after dropping adev->pm.mutex. The sysfs path then copies from that pointer.
A concurrent pp_table write can replace and free the allocation during the
copy, causing a use-after-free.

Change the DPM interface to copy into caller-provided storage while the mutex
is held. Keep the size-only query for attribute discovery without exposing
the driver-owned pointer.

Fixes: 1684d3ba4885 ("drm/amd/amdgpu: change pptable output format from ASCII to binary")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f6eed7acfd30099ef7baeb6ba45bb59daad80631)
Cc: stable@vger.kernel.org
[ kept 6.18's existing `if (!pp_funcs->get_pp_table) return 0;` guard instead of upstream's SR-IOV/SCPM `-EOPNOTSUPP` guard and dropped the `default_attr_update()` hunk whose `pp_table` branch doesn't exist yet ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c     |   15 +++++++++++++--
 drivers/gpu/drm/amd/pm/amdgpu_pm.c      |    8 +-------
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h |    3 ++-
 3 files changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -996,17 +996,28 @@ int amdgpu_dpm_dispatch_task(struct amdg
 	return ret;
 }
 
-int amdgpu_dpm_get_pp_table(struct amdgpu_device *adev, char **table)
+int amdgpu_dpm_get_pp_table(struct amdgpu_device *adev, char *table,
+			    size_t size)
 {
 	const struct amd_pm_funcs *pp_funcs = adev->powerplay.pp_funcs;
+	char *pptable = NULL;
 	int ret = 0;
 
+	if ((!table && size) || (table && !size))
+		return -EINVAL;
+
 	if (!pp_funcs->get_pp_table)
 		return 0;
 
 	mutex_lock(&adev->pm.mutex);
 	ret = pp_funcs->get_pp_table(adev->powerplay.pp_handle,
-				     table);
+				     &pptable);
+	if (ret > 0 && !pptable) {
+		ret = -EINVAL;
+	} else if (ret > 0 && table) {
+		ret = min_t(size_t, ret, size);
+		memcpy(table, pptable, ret);
+	}
 	mutex_unlock(&adev->pm.mutex);
 
 	return ret;
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -496,7 +496,6 @@ static ssize_t amdgpu_get_pp_table(struc
 {
 	struct drm_device *ddev = dev_get_drvdata(dev);
 	struct amdgpu_device *adev = drm_to_adev(ddev);
-	char *table = NULL;
 	int size, ret;
 
 	if (amdgpu_in_reset(adev))
@@ -510,7 +509,7 @@ static ssize_t amdgpu_get_pp_table(struc
 		return ret;
 	}
 
-	size = amdgpu_dpm_get_pp_table(adev, &table);
+	size = amdgpu_dpm_get_pp_table(adev, buf, PAGE_SIZE - 1);
 
 	pm_runtime_mark_last_busy(ddev->dev);
 	pm_runtime_put_autosuspend(ddev->dev);
@@ -518,11 +517,6 @@ static ssize_t amdgpu_get_pp_table(struc
 	if (size <= 0)
 		return size;
 
-	if (size >= PAGE_SIZE)
-		size = PAGE_SIZE - 1;
-
-	memcpy(buf, table, size);
-
 	return size;
 }
 
--- a/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
+++ b/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
@@ -463,7 +463,8 @@ int amdgpu_dpm_get_pp_num_states(struct
 int amdgpu_dpm_dispatch_task(struct amdgpu_device *adev,
 			      enum amd_pp_task task_id,
 			      enum amd_pm_state_type *user_state);
-int amdgpu_dpm_get_pp_table(struct amdgpu_device *adev, char **table);
+int amdgpu_dpm_get_pp_table(struct amdgpu_device *adev, char *table,
+			    size_t size);
 int amdgpu_dpm_set_fine_grain_clk_vol(struct amdgpu_device *adev,
 				      uint32_t type,
 				      long *input,


