Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC4F2727F3;
	Wed,  8 Apr 2026 18:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674208; cv=none; b=T127Lj36njaq/Oc9sii3Blw/ZD5cUJ7M7HLPSiRIt8h3w/hqxLt9U4Zw4jakjPoflmnohVm/L8EkhTsIZX0g0px0Q5M4RsmCQ/3JaqeiJ2pWjG+nH11X8KCgiamezElvwXtB3NAhGWDwSCxPBfYiK+8WCK53Ko0x1XzLGenMZY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674208; c=relaxed/simple;
	bh=cqw+9tLwYaiIEVQNGf6Zqr9hKK8kgWGcVdIJylUqFu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQRN4Y//XszboXEUxTDtkAtMA+V1OxwDKQt2h9/XVdECqjZKlcOdQDOBcbPkncgmF6MbUbA3LHkZAUu5Ar/rqFo5MZ5AxNXk/Om6nV5zS0QlF1Z9ffT0ZpLDxOTCxi6loO+N/pqd+eD4U9rOw3PC+7xz+GgeI8/h3FAUz1fJ3Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7dArmkC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7dArmkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7279DC19421;
	Wed,  8 Apr 2026 18:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674208;
	bh=cqw+9tLwYaiIEVQNGf6Zqr9hKK8kgWGcVdIJylUqFu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7dArmkCUKBMt2t3TzMR0WZj0g3fdcZ9o6SMSCXK1TCD863TvdZdchOHYWWZSPJHC
	 2DuxLZLxoBYgtXlexQ9R2pPhOa0TTf2ncy6xgxW6MKLA1jIZ9VC4xisjhPpC193BOX
	 oZPJGUF6J4aUdGciUBGLbqYyP5Qf2wNAFw0wUz+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 001/311] drm/amd/pm: disable OD_FAN_CURVE if temp or pwm range invalid for smu v13
Date: Wed,  8 Apr 2026 20:00:01 +0200
Message-ID: <20260408175939.452810365@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 3e6dd28a11083e83e11a284d99fcc9eb748c321c ]

Forcibly disable the OD_FAN_CURVE feature when temperature or PWM range is invalid,
otherwise PMFW will reject this configuration on smu v13.0.x

example:
$ sudo cat /sys/bus/pci/devices/<BDF>/gpu_od/fan_ctrl/fan_curve

OD_FAN_CURVE:
0: 0C 0%
1: 0C 0%
2: 0C 0%
3: 0C 0%
4: 0C 0%
OD_RANGE:
FAN_CURVE(hotspot temp): 0C 0C
FAN_CURVE(fan speed): 0% 0%

$ echo "0 50 40" | sudo tee fan_curve

kernel log:
[  756.442527] amdgpu 0000:03:00.0: amdgpu: Fan curve temp setting(50) must be within [0, 0]!
[  777.345800] amdgpu 0000:03:00.0: amdgpu: Fan curve temp setting(50) must be within [0, 0]!

Closes: https://github.com/ROCm/amdgpu/issues/208
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 470891606c5a97b1d0d937e0aa67a3bed9fcb056)
Cc: stable@vger.kernel.org
[ adapted forward declaration placement to existing FEATURE_MASK macro ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |   33 ++++++++++++++++++-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |   33 ++++++++++++++++++-
 2 files changed, 64 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -59,6 +59,10 @@
 
 #define to_amdgpu_device(x) (container_of(x, struct amdgpu_device, pm.smu_i2c))
 
+static void smu_v13_0_0_get_od_setting_limits(struct smu_context *smu,
+					      int od_feature_bit,
+					      int32_t *min, int32_t *max);
+
 #define FEATURE_MASK(feature) (1ULL << feature)
 #define SMC_DPM_FEATURE ( \
 	FEATURE_MASK(FEATURE_DPM_GFXCLK_BIT)     | \
@@ -1061,8 +1065,35 @@ static bool smu_v13_0_0_is_od_feature_su
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
 	const OverDriveLimits_t * const overdrive_upperlimits =
 				&pptable->SkuTable.OverDriveLimitsBasicMax;
+	int32_t min_value, max_value;
+	bool feature_enabled;
+
+	switch (od_feature_bit) {
+	case PP_OD_FEATURE_FAN_CURVE_BIT:
+		feature_enabled = !!(overdrive_upperlimits->FeatureCtrlMask & (1U << od_feature_bit));
+		if (feature_enabled) {
+			smu_v13_0_0_get_od_setting_limits(smu, PP_OD_FEATURE_FAN_CURVE_TEMP,
+							  &min_value, &max_value);
+			if (!min_value && !max_value) {
+				feature_enabled = false;
+				goto out;
+			}
+
+			smu_v13_0_0_get_od_setting_limits(smu, PP_OD_FEATURE_FAN_CURVE_PWM,
+							  &min_value, &max_value);
+			if (!min_value && !max_value) {
+				feature_enabled = false;
+				goto out;
+			}
+		}
+		break;
+	default:
+		feature_enabled = !!(overdrive_upperlimits->FeatureCtrlMask & (1U << od_feature_bit));
+		break;
+	}
 
-	return overdrive_upperlimits->FeatureCtrlMask & (1U << od_feature_bit);
+out:
+	return feature_enabled;
 }
 
 static void smu_v13_0_0_get_od_setting_limits(struct smu_context *smu,
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -59,6 +59,10 @@
 
 #define to_amdgpu_device(x) (container_of(x, struct amdgpu_device, pm.smu_i2c))
 
+static void smu_v13_0_7_get_od_setting_limits(struct smu_context *smu,
+					      int od_feature_bit,
+					      int32_t *min, int32_t *max);
+
 #define FEATURE_MASK(feature) (1ULL << feature)
 #define SMC_DPM_FEATURE ( \
 	FEATURE_MASK(FEATURE_DPM_GFXCLK_BIT)     | \
@@ -1050,8 +1054,35 @@ static bool smu_v13_0_7_is_od_feature_su
 	PPTable_t *pptable = smu->smu_table.driver_pptable;
 	const OverDriveLimits_t * const overdrive_upperlimits =
 				&pptable->SkuTable.OverDriveLimitsBasicMax;
+	int32_t min_value, max_value;
+	bool feature_enabled;
+
+	switch (od_feature_bit) {
+	case PP_OD_FEATURE_FAN_CURVE_BIT:
+		feature_enabled = !!(overdrive_upperlimits->FeatureCtrlMask & (1U << od_feature_bit));
+		if (feature_enabled) {
+			smu_v13_0_7_get_od_setting_limits(smu, PP_OD_FEATURE_FAN_CURVE_TEMP,
+							  &min_value, &max_value);
+			if (!min_value && !max_value) {
+				feature_enabled = false;
+				goto out;
+			}
+
+			smu_v13_0_7_get_od_setting_limits(smu, PP_OD_FEATURE_FAN_CURVE_PWM,
+							  &min_value, &max_value);
+			if (!min_value && !max_value) {
+				feature_enabled = false;
+				goto out;
+			}
+		}
+		break;
+	default:
+		feature_enabled = !!(overdrive_upperlimits->FeatureCtrlMask & (1U << od_feature_bit));
+		break;
+	}
 
-	return overdrive_upperlimits->FeatureCtrlMask & (1U << od_feature_bit);
+out:
+	return feature_enabled;
 }
 
 static void smu_v13_0_7_get_od_setting_limits(struct smu_context *smu,


