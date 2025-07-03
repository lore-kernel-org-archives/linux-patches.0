Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7A6230996;
	Thu,  3 Jul 2025 14:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554198; cv=none; b=cs2bAYRsEw+9WGaZolqGTU3v/aHeQ5AnokN28jpfL2PpsLKMar0iUmW8+9nxyMXbxfhAqx0o3siK2zoRTLu42bfCaC53jbrEboGqPV1SyDe4NKcGxpxfXz16czV9f68laA+IkJspGjDHWbhbW7/q3BPUvAffZcdlYAuIP7cZWHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554198; c=relaxed/simple;
	bh=skJWsGvcpVKb9ZhP6NCUBarUMggLGzPbI0BMsRdnnTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fkbxtnkvi3BYInCf+t26PvSHV6mGJoYM/UA0AlRLgoanT8dvgyZfK+1Z2fCvCP1C/Mpbffpp8aLgVed+U4kALTxHoOip07+Yk7FMxgC9JRGCCyDpwsG1074g5P4c5kZ8o8Nzfh1al2xyOCfe0SOVsJKuvOf6Z0us+WvnR8HXwd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8kqhxHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8kqhxHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B217C4CEE3;
	Thu,  3 Jul 2025 14:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554198;
	bh=skJWsGvcpVKb9ZhP6NCUBarUMggLGzPbI0BMsRdnnTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8kqhxHeaDbKjo2jXeayndDlsz6Fb6QOSZzHCe/8bzoKnByEf7lFIaRextRAfAoMq
	 Cg3BqnJQrglC5jWlGm9tXVkuNTlP5K8xtSFLocIi8F+xBSpOCyo/XFqsDMVT+Lk3NM
	 bSIurwUVR68elZRjncOE5itYtbaOLVPZDkLJsHH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Flora Cui <flora.cui@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/218] drm/amdgpu/discovery: optionally use fw based ip discovery
Date: Thu,  3 Jul 2025 16:40:59 +0200
Message-ID: <20250703144000.379903939@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

[ Upstream commit 80a0e828293389358f7db56adcdcb22b28df5e11 ]

On chips without native IP discovery support, use the fw binary
if available, otherwise we can continue without it.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Flora Cui <flora.cui@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 73eab78721f7 ("drm/amd: Adjust output for discovery error handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 40 +++++++++++++++----
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index 018240a2ab96a..8929478a8f45c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -2429,6 +2429,38 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 {
 	int r;
 
+	switch (adev->asic_type) {
+	case CHIP_VEGA10:
+	case CHIP_VEGA12:
+	case CHIP_RAVEN:
+	case CHIP_VEGA20:
+	case CHIP_ARCTURUS:
+	case CHIP_ALDEBARAN:
+		/* this is not fatal.  We have a fallback below
+		 * if the new firmwares are not present. some of
+		 * this will be overridden below to keep things
+		 * consistent with the current behavior.
+		 */
+		r = amdgpu_discovery_reg_base_init(adev);
+		if (!r) {
+			amdgpu_discovery_harvest_ip(adev);
+			amdgpu_discovery_get_gfx_info(adev);
+			amdgpu_discovery_get_mall_info(adev);
+			amdgpu_discovery_get_vcn_info(adev);
+		}
+		break;
+	default:
+		r = amdgpu_discovery_reg_base_init(adev);
+		if (r)
+			return -EINVAL;
+
+		amdgpu_discovery_harvest_ip(adev);
+		amdgpu_discovery_get_gfx_info(adev);
+		amdgpu_discovery_get_mall_info(adev);
+		amdgpu_discovery_get_vcn_info(adev);
+		break;
+	}
+
 	switch (adev->asic_type) {
 	case CHIP_VEGA10:
 		vega10_reg_base_init(adev);
@@ -2591,14 +2623,6 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		adev->ip_versions[XGMI_HWIP][0] = IP_VERSION(6, 1, 0);
 		break;
 	default:
-		r = amdgpu_discovery_reg_base_init(adev);
-		if (r)
-			return -EINVAL;
-
-		amdgpu_discovery_harvest_ip(adev);
-		amdgpu_discovery_get_gfx_info(adev);
-		amdgpu_discovery_get_mall_info(adev);
-		amdgpu_discovery_get_vcn_info(adev);
 		break;
 	}
 
-- 
2.39.5



