Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E675245012;
	Tue, 26 Aug 2025 11:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207410; cv=none; b=mS6LRj1k7d3P3OTOVdBVJwJpvkqtaOF/9m/kNCACREoKC2C3TaQES6G2FmHTXp4Fiory7Z8DZYf/vtDUA31UeROHbSe3rGga/MvnyyVsB7Iw3LyeKdd0uIJWwTmFnI1MRbN+3NpZNwQeBWUU4i+5k0RutAKT6pa4TsQJjqDeaRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207410; c=relaxed/simple;
	bh=anQqA2MxCy/bMl5S5OAZ7nZhFjPURJ27FSKfWsEAw3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sya3XX014HVq8MXQKcVuKQTPFctaYZHvw0WFCZrezrQACjsL1RkggCHfafCuuvxkq5NkCXfsXbhaHSSxM0SgTHC9zhk682mY5uhfIog53W0UVfhiifbWP85VDnCzZN7g6O6emiDt4LmZTi+7YvHmHogteDIPtJAVDrPR/mS1u0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9xDWvX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9xDWvX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C44C4CEF1;
	Tue, 26 Aug 2025 11:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207410;
	bh=anQqA2MxCy/bMl5S5OAZ7nZhFjPURJ27FSKfWsEAw3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9xDWvX279lagxhPTJ8bVoHT0SGgNqKcF+H28sAPhf9imKtTwSN4e+xEUFWum5tGF
	 Qcd+USNiqqCU6Mk6PBJgmUXyGRO9eo4xS51cDs1FTs1/2w6VRseImsUbVNkh8MbN4o
	 ykBlnap5niesn4sBrPZTnIcdJk3HHPoBtl4FhILg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 171/457] drm/amdgpu/discovery: fix fw based ip discovery
Date: Tue, 26 Aug 2025 13:07:35 +0200
Message-ID: <20250826110941.602202007@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 514678da56da089b756b4d433efd964fa22b2079 upstream.

We only need the fw based discovery table for sysfs.  No
need to parse it.  Additionally parsing some of the board
specific tables may result in incorrect data on some boards.
just load the binary and don't parse it on those boards.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4441
Fixes: 80a0e8282933 ("drm/amdgpu/discovery: optionally use fw based ip discovery")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 62eedd150fa11aefc2d377fc746633fdb1baeb55)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c    |    5 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |   72 ++++++++++++++------------
 2 files changed, 41 insertions(+), 36 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2561,9 +2561,6 @@ static int amdgpu_device_parse_gpu_info_
 
 	adev->firmware.gpu_info_fw = NULL;
 
-	if (adev->mman.discovery_bin)
-		return 0;
-
 	switch (adev->asic_type) {
 	default:
 		return 0;
@@ -2585,6 +2582,8 @@ static int amdgpu_device_parse_gpu_info_
 		chip_name = "arcturus";
 		break;
 	case CHIP_NAVI12:
+		if (adev->mman.discovery_bin)
+			return 0;
 		chip_name = "navi12";
 		break;
 	}
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -2555,40 +2555,11 @@ int amdgpu_discovery_set_ip_blocks(struc
 
 	switch (adev->asic_type) {
 	case CHIP_VEGA10:
-	case CHIP_VEGA12:
-	case CHIP_RAVEN:
-	case CHIP_VEGA20:
-	case CHIP_ARCTURUS:
-	case CHIP_ALDEBARAN:
-		/* this is not fatal.  We have a fallback below
-		 * if the new firmwares are not present. some of
-		 * this will be overridden below to keep things
-		 * consistent with the current behavior.
+		/* This is not fatal.  We only need the discovery
+		 * binary for sysfs.  We don't need it for a
+		 * functional system.
 		 */
-		r = amdgpu_discovery_reg_base_init(adev);
-		if (!r) {
-			amdgpu_discovery_harvest_ip(adev);
-			amdgpu_discovery_get_gfx_info(adev);
-			amdgpu_discovery_get_mall_info(adev);
-			amdgpu_discovery_get_vcn_info(adev);
-		}
-		break;
-	default:
-		r = amdgpu_discovery_reg_base_init(adev);
-		if (r) {
-			drm_err(&adev->ddev, "discovery failed: %d\n", r);
-			return r;
-		}
-
-		amdgpu_discovery_harvest_ip(adev);
-		amdgpu_discovery_get_gfx_info(adev);
-		amdgpu_discovery_get_mall_info(adev);
-		amdgpu_discovery_get_vcn_info(adev);
-		break;
-	}
-
-	switch (adev->asic_type) {
-	case CHIP_VEGA10:
+		amdgpu_discovery_init(adev);
 		vega10_reg_base_init(adev);
 		adev->sdma.num_instances = 2;
 		adev->gmc.num_umc = 4;
@@ -2611,6 +2582,11 @@ int amdgpu_discovery_set_ip_blocks(struc
 		adev->ip_versions[DCI_HWIP][0] = IP_VERSION(12, 0, 0);
 		break;
 	case CHIP_VEGA12:
+		/* This is not fatal.  We only need the discovery
+		 * binary for sysfs.  We don't need it for a
+		 * functional system.
+		 */
+		amdgpu_discovery_init(adev);
 		vega10_reg_base_init(adev);
 		adev->sdma.num_instances = 2;
 		adev->gmc.num_umc = 4;
@@ -2633,6 +2609,11 @@ int amdgpu_discovery_set_ip_blocks(struc
 		adev->ip_versions[DCI_HWIP][0] = IP_VERSION(12, 0, 1);
 		break;
 	case CHIP_RAVEN:
+		/* This is not fatal.  We only need the discovery
+		 * binary for sysfs.  We don't need it for a
+		 * functional system.
+		 */
+		amdgpu_discovery_init(adev);
 		vega10_reg_base_init(adev);
 		adev->sdma.num_instances = 1;
 		adev->vcn.num_vcn_inst = 1;
@@ -2674,6 +2655,11 @@ int amdgpu_discovery_set_ip_blocks(struc
 		}
 		break;
 	case CHIP_VEGA20:
+		/* This is not fatal.  We only need the discovery
+		 * binary for sysfs.  We don't need it for a
+		 * functional system.
+		 */
+		amdgpu_discovery_init(adev);
 		vega20_reg_base_init(adev);
 		adev->sdma.num_instances = 2;
 		adev->gmc.num_umc = 8;
@@ -2697,6 +2683,11 @@ int amdgpu_discovery_set_ip_blocks(struc
 		adev->ip_versions[DCI_HWIP][0] = IP_VERSION(12, 1, 0);
 		break;
 	case CHIP_ARCTURUS:
+		/* This is not fatal.  We only need the discovery
+		 * binary for sysfs.  We don't need it for a
+		 * functional system.
+		 */
+		amdgpu_discovery_init(adev);
 		arct_reg_base_init(adev);
 		adev->sdma.num_instances = 8;
 		adev->vcn.num_vcn_inst = 2;
@@ -2725,6 +2716,11 @@ int amdgpu_discovery_set_ip_blocks(struc
 		adev->ip_versions[UVD_HWIP][1] = IP_VERSION(2, 5, 0);
 		break;
 	case CHIP_ALDEBARAN:
+		/* This is not fatal.  We only need the discovery
+		 * binary for sysfs.  We don't need it for a
+		 * functional system.
+		 */
+		amdgpu_discovery_init(adev);
 		aldebaran_reg_base_init(adev);
 		adev->sdma.num_instances = 5;
 		adev->vcn.num_vcn_inst = 2;
@@ -2751,6 +2747,16 @@ int amdgpu_discovery_set_ip_blocks(struc
 		adev->ip_versions[XGMI_HWIP][0] = IP_VERSION(6, 1, 0);
 		break;
 	default:
+		r = amdgpu_discovery_reg_base_init(adev);
+		if (r) {
+			drm_err(&adev->ddev, "discovery failed: %d\n", r);
+			return r;
+		}
+
+		amdgpu_discovery_harvest_ip(adev);
+		amdgpu_discovery_get_gfx_info(adev);
+		amdgpu_discovery_get_mall_info(adev);
+		amdgpu_discovery_get_vcn_info(adev);
 		break;
 	}
 


