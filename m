Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A581E9B3D;
	Thu,  3 Jul 2025 15:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555254; cv=none; b=uMLj3cx07eQk5WUoJvhyZLrlRZo1lLcvJV/QTczmDSZ3I8PAa/nTkGzXQc6WIEwlxM1LUlbCxykT4MXukbiTLy82qOGBM/2k+4BK4d8gW0+smHFSn4ap+iDz90k3GXiJiF0tImSltjE0SjryggIfzcact+W4F6mcEKv6aSgxMyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555254; c=relaxed/simple;
	bh=jeMqdrtJA2RULzCFYzEv8G72RM9/F0ZgmT5tofxT8ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khb3mQtOmmRsSEOuN70uoW5Rq1P+s26jhTJkMu1D4d5U+SqM45WHN4tK7cRxPmG8vkZMsoQKevkYaJUN69DlsxoMs8kPEVSzs8US50qM6Mcmqz3Isn0VOdMgp6W+mmSXgHAr5HRDiG3n4AXMNqubAEuwA2tSwGwg/wBTI2Irp0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ub0Qu/B2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ub0Qu/B2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2464BC4CEE3;
	Thu,  3 Jul 2025 15:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555254;
	bh=jeMqdrtJA2RULzCFYzEv8G72RM9/F0ZgmT5tofxT8ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ub0Qu/B2+l7vMJrocHmhHB5Ahrbj3HJMRp8mDa1LDA6EPiw1lB7SD/OWAvUvm85JX
	 zA7PQ/hKpMIOIii/Sj4qTMWV/dXyW4Wh7o7IXPmMqt5dGHr+GYgUZ0HgjQK5ATzxYU
	 uP2csMwiud8ceUzQ7ew7PfBkB4X/OPf1ym2Jfki8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 221/263] drm/amdgpu: disable workload profile switching when OD is enabled
Date: Thu,  3 Jul 2025 16:42:21 +0200
Message-ID: <20250703144013.243580562@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5cccf10f652122a17b40df9d672ccf2ed69cd82f upstream.

Users have reported that they have to reduce the level of undervolting
to acheive stability when dynamic workload profiles are enabled on
GC 10.3.x. Disable dynamic workload profiles if the user has enabled
OD.

Fixes: b9467983b774 ("drm/amdgpu: add dynamic workload profile switching for gfx10")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4262
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.15.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c |    8 ++++++++
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c     |   22 ++++++++++++++++++++++
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h |    1 +
 3 files changed, 31 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -2192,6 +2192,9 @@ void amdgpu_gfx_profile_ring_begin_use(s
 	enum PP_SMC_POWER_PROFILE profile;
 	int r;
 
+	if (amdgpu_dpm_is_overdrive_enabled(adev))
+		return;
+
 	if (adev->gfx.num_gfx_rings)
 		profile = PP_SMC_POWER_PROFILE_FULLSCREEN3D;
 	else
@@ -2222,6 +2225,11 @@ void amdgpu_gfx_profile_ring_begin_use(s
 
 void amdgpu_gfx_profile_ring_end_use(struct amdgpu_ring *ring)
 {
+	struct amdgpu_device *adev = ring->adev;
+
+	if (amdgpu_dpm_is_overdrive_enabled(adev))
+		return;
+
 	atomic_dec(&ring->adev->gfx.total_submission_cnt);
 
 	schedule_delayed_work(&ring->adev->gfx.idle_work, GFX_PROFILE_IDLE_TIMEOUT);
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -1654,6 +1654,28 @@ int amdgpu_dpm_is_overdrive_supported(st
 	}
 }
 
+int amdgpu_dpm_is_overdrive_enabled(struct amdgpu_device *adev)
+{
+	if (is_support_sw_smu(adev)) {
+		struct smu_context *smu = adev->powerplay.pp_handle;
+
+		return smu->od_enabled;
+	} else {
+		struct pp_hwmgr *hwmgr;
+
+		/*
+		 * dpm on some legacy asics don't carry od_enabled member
+		 * as its pp_handle is casted directly from adev.
+		 */
+		if (amdgpu_dpm_is_legacy_dpm(adev))
+			return false;
+
+		hwmgr = (struct pp_hwmgr *)adev->powerplay.pp_handle;
+
+		return hwmgr->od_enabled;
+	}
+}
+
 int amdgpu_dpm_set_pp_table(struct amdgpu_device *adev,
 			    const char *buf,
 			    size_t size)
--- a/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
+++ b/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
@@ -559,6 +559,7 @@ int amdgpu_dpm_get_smu_prv_buf_details(s
 				       void **addr,
 				       size_t *size);
 int amdgpu_dpm_is_overdrive_supported(struct amdgpu_device *adev);
+int amdgpu_dpm_is_overdrive_enabled(struct amdgpu_device *adev);
 int amdgpu_dpm_set_pp_table(struct amdgpu_device *adev,
 			    const char *buf,
 			    size_t size);


