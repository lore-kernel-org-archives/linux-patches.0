Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7A320C001;
	Tue, 26 Aug 2025 11:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208453; cv=none; b=inAFVT6extAakIv9o6cSTElMvIT5mc6O3UUbTa2RuuivGZU9MreBCHxsknt702DfhxwEBEGP9RnTN/Rxl3sleNSFRNpXwM3z4Dy83RRpTa4OeXtUXfb+SrJPVzOb68aGFBqgUdG+7RLWSeiYrSPw41+ueu/xckXdCHya++oaLtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208453; c=relaxed/simple;
	bh=Lo6uBEcuJMU4TKbwP6qi2+QEFCYXuHc2Dj489bQysWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdGWI8J2ofoqZay9gCZGQbtR7mihYJfk0tkdP40wEBp+z2u+DVgGNcz4lFcl+8vGxMrvnZ1N5Oz515KYq4BsVmcb+J9ag48eUv8aXrN0rncZhukVxC+GHb24KDtrKjqDR8n4Ap/wKKl0nvToRjwGU5VgceZbyNPMJc77APe41Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RotqGFq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RotqGFq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63ED0C4CEF4;
	Tue, 26 Aug 2025 11:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208453;
	bh=Lo6uBEcuJMU4TKbwP6qi2+QEFCYXuHc2Dj489bQysWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RotqGFq1NO5KykF5ETkszxGaqwGJz6g0ySxXaB78Z+sKoR8FAzoMm4qnVcYjh/RFu
	 zvZUVn0HqB1dPwamIm9frtPbfcSwz8iOaGLTHe7STMiP3lC4mwO3ifyddXYMXaGag5
	 yYESjkNYZ0i7qC74uLrwIiAwD4R4vy4Zaz0Oybnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 118/322] drm/amdgpu/discovery: fix fw based ip discovery
Date: Tue, 26 Aug 2025 13:08:53 +0200
Message-ID: <20250826110918.711933165@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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
@@ -2387,9 +2387,6 @@ static int amdgpu_device_parse_gpu_info_
 
 	adev->firmware.gpu_info_fw = NULL;
 
-	if (adev->mman.discovery_bin)
-		return 0;
-
 	switch (adev->asic_type) {
 	default:
 		return 0;
@@ -2411,6 +2408,8 @@ static int amdgpu_device_parse_gpu_info_
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
@@ -2455,40 +2455,11 @@ int amdgpu_discovery_set_ip_blocks(struc
 
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
@@ -2511,6 +2482,11 @@ int amdgpu_discovery_set_ip_blocks(struc
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
@@ -2533,6 +2509,11 @@ int amdgpu_discovery_set_ip_blocks(struc
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
@@ -2572,6 +2553,11 @@ int amdgpu_discovery_set_ip_blocks(struc
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
@@ -2595,6 +2581,11 @@ int amdgpu_discovery_set_ip_blocks(struc
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
@@ -2623,6 +2614,11 @@ int amdgpu_discovery_set_ip_blocks(struc
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
@@ -2649,6 +2645,16 @@ int amdgpu_discovery_set_ip_blocks(struc
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
 


