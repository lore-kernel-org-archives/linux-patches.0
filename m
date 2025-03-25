Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396CD2586CD;
	Tue, 25 Mar 2025 12:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906037; cv=none; b=KryMs4X070yb55Chlit9fOS3Sp0+DgJcf76W939jB8mjcNJn/FGmHZEAqSi5aXcGHPwK2qHUGzPucwAdAZhRePcKPIcvRIpK9m51Mc0BQbixtS7EjpVT9Y+FK434PjrRHkhSIRmWktIRrklyaKBx18aEDwqfKvTeJz2OFSkyYA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906037; c=relaxed/simple;
	bh=VuCl4f69McuVueVo1oQlCGOQzEdcfbaMeTCq9OYDBn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XkA9++fvWEMTtwiPBJW2BCeFQBJgBoLSaTmf3aNbmXP0uU3nJAbI4H6HaFmWFaswFHstj5qUWWrO//gRikOnPAKlb+85GZoxjSJVElBca0p4UhGtAc5d8yN/AY6ci2qsAVFx2uX+AEhmtqTBbtiK5vdLrgG7PD1KZQHmWgwYZ+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nooa8WZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nooa8WZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37C2C4CEE4;
	Tue, 25 Mar 2025 12:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906037;
	bh=VuCl4f69McuVueVo1oQlCGOQzEdcfbaMeTCq9OYDBn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nooa8WZuEp1b4ihsihdZkzPKdKHOyWJWfECJCyTZcVxfOrv7ID34YP4EyL5eMdVQw
	 hMtQonQZrRZ3SdDuJ3kIcoQHpqPsgVc38sOJs+TwFq1AuAVGqGrK7wYf970ZYdkKmg
	 StBHbBXLwvMYLhsKwyAlDK09Zc/lpJX5zXcRQFbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 101/119] drm/amdgpu/pm: Handle SCLK offset correctly in overdrive for smu 14.0.2
Date: Tue, 25 Mar 2025 08:22:39 -0400
Message-ID: <20250325122151.637767611@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

commit d9d4cb224e4140f51847642aa5a4a5c3eb998af0 upstream.

Currently, it seems like the code was carried over from RDNA3 because
it assumes two possible values to set. RDNA4, instead of having:
0: min SCLK
1: max SCLK
only has
0: SCLK offset

This change makes it so it only reports current offset value instead of
showing possible min/max values and their indices. Moreover, it now only
accepts the offset as a value, without the indice index.

Additionally, the lower bound was printed as %u by mistake.

Old:
OD_SCLK_OFFSET:
0: -500Mhz
1: 1000Mhz
OD_MCLK:
0: 97Mhz
1: 1259MHz
OD_VDDGFX_OFFSET:
0mV
OD_RANGE:
SCLK_OFFSET:    -500Mhz       1000Mhz
MCLK:      97Mhz       1500Mhz
VDDGFX_OFFSET:    -200mv          0mv

New:
OD_SCLK_OFFSET:
0Mhz
OD_MCLK:
0: 97Mhz
1: 1259MHz
OD_VDDGFX_OFFSET:
0mV
OD_RANGE:
SCLK_OFFSET:    -500Mhz       1000Mhz
MCLK:      97Mhz       1500Mhz
VDDGFX_OFFSET:    -200mv          0mv

Setting this offset:
Old: "s 1 <offset>"
New: "s <offset>"

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4036
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1cfeb60e6e8837b1de5eb4e17df7cf31f4442144)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c |   59 +++++--------------
 1 file changed, 18 insertions(+), 41 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -1193,16 +1193,9 @@ static int smu_v14_0_2_print_clk_levels(
 							 PP_OD_FEATURE_GFXCLK_BIT))
 			break;
 
-		PPTable_t *pptable = smu->smu_table.driver_pptable;
-		const OverDriveLimits_t * const overdrive_upperlimits =
-					&pptable->SkuTable.OverDriveLimitsBasicMax;
-		const OverDriveLimits_t * const overdrive_lowerlimits =
-					&pptable->SkuTable.OverDriveLimitsBasicMin;
-
 		size += sysfs_emit_at(buf, size, "OD_SCLK_OFFSET:\n");
-		size += sysfs_emit_at(buf, size, "0: %dMhz\n1: %uMhz\n",
-					overdrive_lowerlimits->GfxclkFoffset,
-					overdrive_upperlimits->GfxclkFoffset);
+		size += sysfs_emit_at(buf, size, "%dMhz\n",
+					od_table->OverDriveTable.GfxclkFoffset);
 		break;
 
 	case SMU_OD_MCLK:
@@ -1337,12 +1330,8 @@ static int smu_v14_0_2_print_clk_levels(
 
 		if (smu_v14_0_2_is_od_feature_supported(smu, PP_OD_FEATURE_GFXCLK_BIT)) {
 			smu_v14_0_2_get_od_setting_limits(smu,
-							  PP_OD_FEATURE_GFXCLK_FMIN,
-							  &min_value,
-							  NULL);
-			smu_v14_0_2_get_od_setting_limits(smu,
 							  PP_OD_FEATURE_GFXCLK_FMAX,
-							  NULL,
+							  &min_value,
 							  &max_value);
 			size += sysfs_emit_at(buf, size, "SCLK_OFFSET: %7dMhz %10uMhz\n",
 					      min_value, max_value);
@@ -2417,36 +2406,24 @@ static int smu_v14_0_2_od_edit_dpm_table
 			return -ENOTSUPP;
 		}
 
-		for (i = 0; i < size; i += 2) {
-			if (i + 2 > size) {
-				dev_info(adev->dev, "invalid number of input parameters %d\n", size);
-				return -EINVAL;
-			}
+		if (size != 1) {
+			dev_info(adev->dev, "invalid number of input parameters %d\n", size);
+			return -EINVAL;
+		}
 
-			switch (input[i]) {
-			case 1:
-				smu_v14_0_2_get_od_setting_limits(smu,
-								  PP_OD_FEATURE_GFXCLK_FMAX,
-								  &minimum,
-								  &maximum);
-				if (input[i + 1] < minimum ||
-				    input[i + 1] > maximum) {
-					dev_info(adev->dev, "GfxclkFmax (%ld) must be within [%u, %u]!\n",
-						input[i + 1], minimum, maximum);
-					return -EINVAL;
-				}
-
-				od_table->OverDriveTable.GfxclkFoffset = input[i + 1];
-				od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_GFXCLK_BIT;
-				break;
-
-			default:
-				dev_info(adev->dev, "Invalid SCLK_VDDC_TABLE index: %ld\n", input[i]);
-				dev_info(adev->dev, "Supported indices: [0:min,1:max]\n");
-				return -EINVAL;
-			}
+		smu_v14_0_2_get_od_setting_limits(smu,
+						  PP_OD_FEATURE_GFXCLK_FMAX,
+						  &minimum,
+						  &maximum);
+		if (input[0] < minimum ||
+		    input[0] > maximum) {
+			dev_info(adev->dev, "GfxclkFoffset must be within [%d, %u]!\n",
+				 minimum, maximum);
+			return -EINVAL;
 		}
 
+		od_table->OverDriveTable.GfxclkFoffset = input[0];
+		od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_GFXCLK_BIT;
 		break;
 
 	case PP_OD_EDIT_MCLK_VDDC_TABLE:


