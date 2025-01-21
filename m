Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A781F0E36;
	Tue, 21 Jan 2025 18:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482542; cv=none; b=agunObmefQz7L3h2yzXJNjf3i6aJvDlKW9Cwi7b21J+DfqW9B2qJHqrIZC/Jz0FlT69caK6feZhK+O7/3t0zawkxx+csXRcwvwDPDrc1/6xtXbUqx/VYNgdwbmUMEOCD9uflFfdtYdXDc1eTs0V27Wxa6MgbfgROEe/tlcVYxz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482542; c=relaxed/simple;
	bh=xncZy2yHzvmOkInKR/9jPJrVO/LyDaHR6ZzkyFu/RsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCJFdtDeY7LFsXX4Bhr1sj39zj/sTm5VmwWcDBV0mxQPyef0Gyu9T978d9mltEpV8MQmRiSMu5/tbWdbDhuCbjHySmcyy46A5BF3/4fUm1K0vXPNmGYoa1bSaDPsX/g5bodvJya/+bkGIFN3ecAOVYoxvjzaRrN/GaakYsIwOlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXtGXRMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXtGXRMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E03C4CEDF;
	Tue, 21 Jan 2025 18:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482542;
	bh=xncZy2yHzvmOkInKR/9jPJrVO/LyDaHR6ZzkyFu/RsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXtGXRMFI7WLDYYwJNTxhH/poAxwn9BJdG738A59N6z5dPwMoRbT385jxDS/91M6G
	 gsplixsl1XZwn33FhBUX/jMdkx1S2ZSMNyZbgSMk9DCL8oWxUhdvNtI+HVedfW27aQ
	 ioc5g3xu8t2Bnl3PHmk5oMc3Jkjsx/X90K897Xl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 113/122] drm/amdgpu/smu13: update powersave optimizations
Date: Tue, 21 Jan 2025 18:52:41 +0100
Message-ID: <20250121174537.408158449@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 11510e67d0bd956878ab4ffa03c45766788092c1 upstream.

Only apply when compute profile is selected.  This is
the only supported configuration.  Selecting other
profiles can lead to performane degradations.

Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d477e39532d725b1cdb3c8005c689c74ffbf3b94)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2549,11 +2549,12 @@ static int smu_v13_0_0_set_power_profile
 					  &backend_workload_mask);
 
 	/* Add optimizations for SMU13.0.0/10.  Reuse the power saving profile */
-	if ((amdgpu_ip_version(smu->adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 0) &&
-	     ((smu->adev->pm.fw_version == 0x004e6601) ||
-	      (smu->adev->pm.fw_version >= 0x004e7300))) ||
-	    (amdgpu_ip_version(smu->adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 10) &&
-	     smu->adev->pm.fw_version >= 0x00504500)) {
+	if ((workload_mask & (1 << PP_SMC_POWER_PROFILE_COMPUTE)) &&
+	    ((amdgpu_ip_version(smu->adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 0) &&
+	      ((smu->adev->pm.fw_version == 0x004e6601) ||
+	       (smu->adev->pm.fw_version >= 0x004e7300))) ||
+	     (amdgpu_ip_version(smu->adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 10) &&
+	      smu->adev->pm.fw_version >= 0x00504500))) {
 		workload_type = smu_cmn_to_asic_specific_index(smu,
 							       CMN2ASIC_MAPPING_WORKLOAD,
 							       PP_SMC_POWER_PROFILE_POWERSAVING);


