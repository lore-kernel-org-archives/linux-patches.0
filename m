Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D545381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B221C433C0;
	Mon, 19 Jun 2023 10:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171558;
	bh=WaZVmAssyh4p/W8srJFwLUfYNxnPdzVJJ0TkrO4fgOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIqt9eaxcIDEh9inJkdvgmPWiLFsWd4FTj4JNDrAR29F5VlW3pPHBFTR4GmmbKRMg
	 4j0xbJfnsCUXOPpGMNUrjUe/Uk9p8cHZPf3EGsDUCz2fgVLy0SgYt1Je4oZ+LBwyr2
	 Cu3fXvzPNlPzAuFUe3pXwB1iaTcgkfkVJdRHwXXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Feifei Xu <Feifei.Xu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 074/166] drm/amd/pm: workaround for compute workload type on some skus
Date: Mon, 19 Jun 2023 12:29:11 +0200
Message-ID: <20230619102158.356108898@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kenneth Feng <kenneth.feng@amd.com>

commit 7ca302d488f80cf4529620acc1c545f9022d8bb8 upstream.

On smu 13.0.0, the compute workload type cannot be set on all the skus
due to some other problems. This workaround is to make sure compute workload type
can also run on some specific skus.

v2: keep the variable consistent

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Acked-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |   33 +++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1675,10 +1675,39 @@ static int smu_v13_0_0_set_power_profile
 		}
 	}
 
-	/* conv PP_SMC_POWER_PROFILE* to WORKLOAD_PPLIB_*_BIT */
-	workload_type = smu_cmn_to_asic_specific_index(smu,
+	if (smu->power_profile_mode == PP_SMC_POWER_PROFILE_COMPUTE &&
+		(((smu->adev->pdev->device == 0x744C) && (smu->adev->pdev->revision == 0xC8)) ||
+		((smu->adev->pdev->device == 0x744C) && (smu->adev->pdev->revision == 0xCC)))) {
+		ret = smu_cmn_update_table(smu,
+					   SMU_TABLE_ACTIVITY_MONITOR_COEFF,
+					   WORKLOAD_PPLIB_COMPUTE_BIT,
+					   (void *)(&activity_monitor_external),
+					   false);
+		if (ret) {
+			dev_err(smu->adev->dev, "[%s] Failed to get activity monitor!", __func__);
+			return ret;
+		}
+
+		ret = smu_cmn_update_table(smu,
+					   SMU_TABLE_ACTIVITY_MONITOR_COEFF,
+					   WORKLOAD_PPLIB_CUSTOM_BIT,
+					   (void *)(&activity_monitor_external),
+					   true);
+		if (ret) {
+			dev_err(smu->adev->dev, "[%s] Failed to set activity monitor!", __func__);
+			return ret;
+		}
+
+		workload_type = smu_cmn_to_asic_specific_index(smu,
+						       CMN2ASIC_MAPPING_WORKLOAD,
+						       PP_SMC_POWER_PROFILE_CUSTOM);
+	} else {
+		/* conv PP_SMC_POWER_PROFILE* to WORKLOAD_PPLIB_*_BIT */
+		workload_type = smu_cmn_to_asic_specific_index(smu,
 						       CMN2ASIC_MAPPING_WORKLOAD,
 						       smu->power_profile_mode);
+	}
+
 	if (workload_type < 0)
 		return -EINVAL;
 


