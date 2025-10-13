Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EA926F2B6;
	Mon, 13 Oct 2025 15:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369532; cv=none; b=BbUPn1qxjx9nW2AM7cw9/LnNG9HyUTGmOnbDs/lVV1D82ETYVkbPHsoyDQLkQH4axepbsAHsoUcgi1bzn/eRdehKECsB3uYg0iwpW6xCoOWrdpiRmqeqm5FSfsWDkgMn50v0CSUuQOU+t94VLOE0dMWuDx/NENYvErSR7qM7Z6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369532; c=relaxed/simple;
	bh=tkYxw4QkypP8BODzfpjEft1TOP3wauElCsTtdVgFL5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KysYR+1WyKM2S9mRdNl4qGABqRj1+uVvSJc6nlXLKMe1bFSrG59dHahrhXkchS44DOS31fLm0LfVywhb+qBxncHataVCI2OU5qXRhgl7d1mHGSjQkMsy00Q9g7s3wCtZ5qjPo/V4mq6xSrq9p1Jquk9MiwILL1dgKbaL9V7ofiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wj7151U0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wj7151U0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF61FC4CEE7;
	Mon, 13 Oct 2025 15:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369532;
	bh=tkYxw4QkypP8BODzfpjEft1TOP3wauElCsTtdVgFL5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wj7151U0RPfMPLBHhe+iJcPMmUnV/5BwiUwG0u4k0ENCDLeeqazba6XkyfDRTS0ud
	 CYr/0aTAZBP6lo3wTybhcfPisWq+LEh1A8/9MZob1XjendPGwhVCUeFcLWEomav/NE
	 QYksv1qKVLiaiJ8mJ793x12wMSooocNUsKnNPwz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathishkumar S <sathishkumar.sundararaju@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 280/563] drm/amdgpu/vcn: Hold pg_lock before vcn power off
Date: Mon, 13 Oct 2025 16:42:21 +0200
Message-ID: <20251013144421.415541629@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sathishkumar S <sathishkumar.sundararaju@amd.com>

[ Upstream commit 111821e4b5a3105c42c7c99f4abd4d8af9f64248 ]

Acquire vcn_pg_lock before changes to vcn power state
and release it after power off in idle work handler.

Signed-off-by: Sathishkumar S <sathishkumar.sundararaju@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 9c0442286f84 ("drm/amdgpu: Check vcn state before profile switch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
index b497a67141384..e965b624efdb1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -443,7 +443,9 @@ static void amdgpu_vcn_idle_work_handler(struct work_struct *work)
 	fences += fence[i];
 
 	if (!fences && !atomic_read(&vcn_inst->total_submission_cnt)) {
+		mutex_lock(&vcn_inst->vcn_pg_lock);
 		vcn_inst->set_pg_state(vcn_inst, AMD_PG_STATE_GATE);
+		mutex_unlock(&vcn_inst->vcn_pg_lock);
 		mutex_lock(&adev->vcn.workload_profile_mutex);
 		if (adev->vcn.workload_profile_active) {
 			r = amdgpu_dpm_switch_power_profile(adev, PP_SMC_POWER_PROFILE_VIDEO,
-- 
2.51.0



