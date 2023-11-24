Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EE339FF3;
	Fri, 24 Nov 2023 18:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IR4Mm1iN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F07C433C8;
	Fri, 24 Nov 2023 18:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850324;
	bh=7/vj06eLL1kuiUMmqOCGGhPgT8fTj022D/941adxfqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IR4Mm1iN968mChN/ynvsQpX9Gg9JmSdt91jb2mMnNBF8zCE8Zrub9Y3OtJnCGiEW6
	 qRurYDrXG0HbaNRjh4KUabMhkpGPBGCHqLONJhMnMMeRqI9sqs96RA/8PveWnmmTOV
	 IvFBIecM3Ea1/pEVz/3q3Jwc0gyA+ivYDHYTtp2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 516/530] drm/amdgpu/smu13: drop compute workload workaround
Date: Fri, 24 Nov 2023 17:51:22 +0000
Message-ID: <20231124172043.889676545@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 23170863ea0a0965d224342c0eb2ad8303b1f267 upstream.

This was fixed in PMFW before launch and is no longer
required.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |   32 +------------------
 1 file changed, 2 insertions(+), 30 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2163,38 +2163,10 @@ static int smu_v13_0_0_set_power_profile
 		}
 	}
 
-	if (smu->power_profile_mode == PP_SMC_POWER_PROFILE_COMPUTE &&
-		(((smu->adev->pdev->device == 0x744C) && (smu->adev->pdev->revision == 0xC8)) ||
-		((smu->adev->pdev->device == 0x744C) && (smu->adev->pdev->revision == 0xCC)))) {
-		ret = smu_cmn_update_table(smu,
-					   SMU_TABLE_ACTIVITY_MONITOR_COEFF,
-					   WORKLOAD_PPLIB_COMPUTE_BIT,
-					   (void *)(&activity_monitor_external),
-					   false);
-		if (ret) {
-			dev_err(smu->adev->dev, "[%s] Failed to get activity monitor!", __func__);
-			return ret;
-		}
-
-		ret = smu_cmn_update_table(smu,
-					   SMU_TABLE_ACTIVITY_MONITOR_COEFF,
-					   WORKLOAD_PPLIB_CUSTOM_BIT,
-					   (void *)(&activity_monitor_external),
-					   true);
-		if (ret) {
-			dev_err(smu->adev->dev, "[%s] Failed to set activity monitor!", __func__);
-			return ret;
-		}
-
-		workload_type = smu_cmn_to_asic_specific_index(smu,
-						       CMN2ASIC_MAPPING_WORKLOAD,
-						       PP_SMC_POWER_PROFILE_CUSTOM);
-	} else {
-		/* conv PP_SMC_POWER_PROFILE* to WORKLOAD_PPLIB_*_BIT */
-		workload_type = smu_cmn_to_asic_specific_index(smu,
+	/* conv PP_SMC_POWER_PROFILE* to WORKLOAD_PPLIB_*_BIT */
+	workload_type = smu_cmn_to_asic_specific_index(smu,
 						       CMN2ASIC_MAPPING_WORKLOAD,
 						       smu->power_profile_mode);
-	}
 
 	if (workload_type < 0)
 		return -EINVAL;


