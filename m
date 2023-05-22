Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD9E171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2B9C4339C;
	Mon, 22 May 2023 19:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785184;
	bh=LBECkkhQ8w5rJ2eVm0zXSkQ4sbV25oX/P3ucWnFJOHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSItdmalcJ6IuEYJ6ToY6ayiS2igOdtQlK2WdRu3ESngwf0/aYMx8Cwavsq/h+HFb
	 uVuP3ydTO0QltnlcUOZwIIdCTFzvZpzuWHNmz5RpU+EqQUob+mxmvJpGUDM52x5uwK
	 9/jdGgwx4Pw6CrmBhMG5gB+LrxdzA7tnRFiOFlGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.3 337/364] drm/amd/pm: fix possible power mode mismatch between driver and PMFW
Date: Mon, 22 May 2023 20:10:42 +0100
Message-Id: <20230522190421.200547016@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Evan Quan <evan.quan@amd.com>

commit bf4823267a817f7c155876a125b94336d7113e77 upstream.

PMFW may boots the ASIC with a different power mode from the system's
real one. Notify PMFW explicitly the power mode the system in. This
is needed only when ACDC switch via gpio is not supported.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c            |   18 +++++++++++++++++
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c      |   20 -------------------
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    1 
 3 files changed, 20 insertions(+), 19 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -727,6 +727,24 @@ static int smu_late_init(void *handle)
 		return ret;
 	}
 
+	/*
+	 * Explicitly notify PMFW the power mode the system in. Since
+	 * the PMFW may boot the ASIC with a different mode.
+	 * For those supporting ACDC switch via gpio, PMFW will
+	 * handle the switch automatically. Driver involvement
+	 * is unnecessary.
+	 */
+	if (!smu->dc_controlled_by_gpio) {
+		ret = smu_set_power_source(smu,
+					   adev->pm.ac_power ? SMU_POWER_SOURCE_AC :
+					   SMU_POWER_SOURCE_DC);
+		if (ret) {
+			dev_err(adev->dev, "Failed to switch to %s mode!\n",
+				adev->pm.ac_power ? "AC" : "DC");
+			return ret;
+		}
+	}
+
 	if ((adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 1)) ||
 	    (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 3)))
 		return 0;
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -3412,26 +3412,8 @@ static int navi10_post_smu_init(struct s
 		return 0;
 
 	ret = navi10_run_umc_cdr_workaround(smu);
-	if (ret) {
+	if (ret)
 		dev_err(adev->dev, "Failed to apply umc cdr workaround!\n");
-		return ret;
-	}
-
-	if (!smu->dc_controlled_by_gpio) {
-		/*
-		 * For Navi1X, manually switch it to AC mode as PMFW
-		 * may boot it with DC mode.
-		 */
-		ret = smu_v11_0_set_power_source(smu,
-						 adev->pm.ac_power ?
-						 SMU_POWER_SOURCE_AC :
-						 SMU_POWER_SOURCE_DC);
-		if (ret) {
-			dev_err(adev->dev, "Failed to switch to %s mode!\n",
-					adev->pm.ac_power ? "AC" : "DC");
-			return ret;
-		}
-	}
 
 	return ret;
 }
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1768,6 +1768,7 @@ static const struct pptable_funcs smu_v1
 	.enable_mgpu_fan_boost = smu_v13_0_7_enable_mgpu_fan_boost,
 	.get_power_limit = smu_v13_0_7_get_power_limit,
 	.set_power_limit = smu_v13_0_set_power_limit,
+	.set_power_source = smu_v13_0_set_power_source,
 	.get_power_profile_mode = smu_v13_0_7_get_power_profile_mode,
 	.set_power_profile_mode = smu_v13_0_7_set_power_profile_mode,
 	.set_tool_table_location = smu_v13_0_set_tool_table_location,


