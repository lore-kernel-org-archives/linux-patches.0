Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115DB16F27E;
	Mon, 21 Oct 2024 10:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506629; cv=none; b=Nr4adC+miQQ/PWuznORIxKG3S2wUixYsxdrjKJYk63oGDa/+qhmwdl7bMSgFipa7mVgp+axU9SxHHGCQ+BAzmvWKx5AasYM+PKIBHQ2kP3snTx3htbUXSXGJPU8AlVGicd2HcRLu6sFYG0aJbEQ1oThy3dCHIVfv0l0EjC+Rfkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506629; c=relaxed/simple;
	bh=piky9WaOCs0mtAbli0rv7+1mELiDwkZ+SdiXucJxuU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3AYkfkXDznxn/f0G6pYdFLXDPkuU1lR9xhnGCRz8PohKsWbnp6UZ6W3mpBL2hRV9tILYWKtno8u1dCqsKcmZ53JVsgXsVbPEZfwihdm5rzaB57qBqixtCxu8Gv5kWvMCdASLdJcKnUbziLebeBcEn9TqEWGdIZDWVfPrXbx3HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vmf0gC73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vmf0gC73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8348EC4CEC3;
	Mon, 21 Oct 2024 10:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506628;
	bh=piky9WaOCs0mtAbli0rv7+1mELiDwkZ+SdiXucJxuU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vmf0gC73fq0nXmX1pXeDfteD5UD6tNR0kW9cTpdCgi0rqX/vx1wP6MrdpBkQmdAe8
	 uCtqRUXz8Mch9Em80WTh9W3J22mFInSm6SwCgG3yNbpvoUaygWnyKt7IpH8x5phZpU
	 FzypRPM9s9QW5+4HsubRV0dHGTnAZSi9DevZZaN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 067/135] drm/amdgpu/smu13: always apply the powersave optimization
Date: Mon, 21 Oct 2024 12:23:43 +0200
Message-ID: <20241021102301.953501829@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7a1613e47e65ba6967085ad99dee95420346a0ce upstream.

It can avoid margin issues in some very demanding applications.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3618
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3131
Fixes: c50fe289ed72 ("drm/amdgpu/swsmu: always force a state reprogram on init")
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 62f38b4ccaa6aa063ca781d80b10aacd39dc5c76)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |   22 ++++++++-----------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2555,18 +2555,16 @@ static int smu_v13_0_0_set_power_profile
 	workload_mask = 1 << workload_type;
 
 	/* Add optimizations for SMU13.0.0/10.  Reuse the power saving profile */
-	if (smu->power_profile_mode == PP_SMC_POWER_PROFILE_COMPUTE) {
-		if ((amdgpu_ip_version(smu->adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 0) &&
-			((smu->adev->pm.fw_version == 0x004e6601) ||
-			(smu->adev->pm.fw_version >= 0x004e7300))) ||
-			(amdgpu_ip_version(smu->adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 10) &&
-			 smu->adev->pm.fw_version >= 0x00504500)) {
-			workload_type = smu_cmn_to_asic_specific_index(smu,
-								CMN2ASIC_MAPPING_WORKLOAD,
-								PP_SMC_POWER_PROFILE_POWERSAVING);
-			if (workload_type >= 0)
-				workload_mask |= 1 << workload_type;
-		}
+	if ((amdgpu_ip_version(smu->adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 0) &&
+	     ((smu->adev->pm.fw_version == 0x004e6601) ||
+	      (smu->adev->pm.fw_version >= 0x004e7300))) ||
+	    (amdgpu_ip_version(smu->adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 10) &&
+	     smu->adev->pm.fw_version >= 0x00504500)) {
+		workload_type = smu_cmn_to_asic_specific_index(smu,
+							       CMN2ASIC_MAPPING_WORKLOAD,
+							       PP_SMC_POWER_PROFILE_POWERSAVING);
+		if (workload_type >= 0)
+			workload_mask |= 1 << workload_type;
 	}
 
 	ret = smu_cmn_send_smc_msg_with_param(smu,


