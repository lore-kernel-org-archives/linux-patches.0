Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7421E314D34;
	Fri, 15 May 2026 16:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862775; cv=none; b=oDeEVCGdyDU2Dh3mbkuT8H2qvjQ1jBs1hGV7paaWNK6AnfEtdiIM8yaFgLo3ICuWb5WlDsaz4urgKxZUH0F3BI1eiGYZx/Yn4o+i89dUDsM+rOfR+VfMB6B3QjaIt1vqrCg89ZXMr8CBDFozMs5fZ4uBi1E/mFUuWHqC8G79Xhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862775; c=relaxed/simple;
	bh=yPoZZjdgkffcF8df+vV4slAETJqTsaFu74qnyFu4na0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2WGYwczfR/5aZCTsCd/QerNPqkx5PrTg73bGoNGqY7YPIF+HM/5aBkgUoZHC/akxNrXI2kGOteWSfEWjOGwyKPYD+lpQct2TGxBCpCkhbpk9RS1/uFtfoa7h05SfHh89AhD0CX6BI7rRA+aVGElTkEiHUFSVzKL1AqQPODs0Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kimGk6V/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kimGk6V/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098E7C2BCB0;
	Fri, 15 May 2026 16:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862775;
	bh=yPoZZjdgkffcF8df+vV4slAETJqTsaFu74qnyFu4na0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kimGk6V/y+XxNaA44fgSZCfXX7EhZCYJ7uWin4oqPVI2amcE8GJQUe3rYS63E2k1A
	 NF7rM3qRBwwrCn4evKvdhmxymr9sIwEHkA6PVyb5pA2LFtLPtNs11O7u/j2EBAw4XI
	 bTphXYFNUZu6qzw63dzWx4CkTkze4FXwjOoHeJfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 136/201] drm/amd/pm: fix incorrect FeatureCtrlMask setting on smu v14.0.x
Date: Fri, 15 May 2026 17:49:14 +0200
Message-ID: <20260515154701.514176068@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit 504f0098ebd074ac8c0ce3471795d79f68e3d265 upstream.

OverDriveTable.FanMinimumPwm and FeatureCtrlMask.PP_OD_FEATURE_FAN_LEGACY_BIT
have a hard dependency.
Invalid handling of this dependency leads to disabled thermal monitoring
and temperature boundary validation.

v2: squash in typo fix (Yang)

Fixes: 9710b84e2a6a ("drm/amd/pm: add overdrive support on smu v14.0.2/3")
Cc: stable@vger.kernel.org
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -2372,6 +2372,7 @@ static int smu_v14_0_2_od_restore_table_
 		}
 		od_table->OverDriveTable.FanMode = FAN_MODE_AUTO;
 		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
+		od_table->OverDriveTable.FeatureCtrlMask &= ~BIT(PP_OD_FEATURE_FAN_LEGACY_BIT);
 		break;
 	case PP_OD_EDIT_FAN_ZERO_RPM_ENABLE:
 		od_table->OverDriveTable.FanZeroRpmEnable =
@@ -2400,7 +2401,8 @@ static int smu_v14_0_2_od_restore_table_
 		od_table->OverDriveTable.FanMinimumPwm =
 					boot_overdrive_table->OverDriveTable.FanMinimumPwm;
 		od_table->OverDriveTable.FanMode = FAN_MODE_AUTO;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
+		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_LEGACY_BIT);
+		od_table->OverDriveTable.FeatureCtrlMask &= ~BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
 		break;
 	default:
 		dev_info(adev->dev, "Invalid table index: %ld\n", input);
@@ -2570,6 +2572,7 @@ static int smu_v14_0_2_od_edit_dpm_table
 		od_table->OverDriveTable.FanLinearPwmPoints[input[0]] = input[2];
 		od_table->OverDriveTable.FanMode = FAN_MODE_MANUAL_LINEAR;
 		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
+		od_table->OverDriveTable.FeatureCtrlMask &= ~BIT(PP_OD_FEATURE_FAN_LEGACY_BIT);
 		break;
 
 	case PP_OD_EDIT_ACOUSTIC_LIMIT:
@@ -2639,7 +2642,7 @@ static int smu_v14_0_2_od_edit_dpm_table
 		break;
 
 	case PP_OD_EDIT_FAN_MINIMUM_PWM:
-		if (!smu_v14_0_2_is_od_feature_supported(smu, PP_OD_FEATURE_FAN_CURVE_BIT)) {
+		if (!smu_v14_0_2_is_od_feature_supported(smu, PP_OD_FEATURE_FAN_LEGACY_BIT)) {
 			dev_warn(adev->dev, "Fan curve setting not supported!\n");
 			return -ENOTSUPP;
 		}
@@ -2657,7 +2660,8 @@ static int smu_v14_0_2_od_edit_dpm_table
 
 		od_table->OverDriveTable.FanMinimumPwm = input[0];
 		od_table->OverDriveTable.FanMode = FAN_MODE_AUTO;
-		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
+		od_table->OverDriveTable.FeatureCtrlMask |= BIT(PP_OD_FEATURE_FAN_LEGACY_BIT);
+		od_table->OverDriveTable.FeatureCtrlMask &= ~BIT(PP_OD_FEATURE_FAN_CURVE_BIT);
 		break;
 
 	case PP_OD_EDIT_FAN_ZERO_RPM_ENABLE:


