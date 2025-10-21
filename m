Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ACC350A3C;
	Tue, 21 Oct 2025 20:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076918; cv=none; b=rMXAGtMWUhtiCo6LbZxSnRwt3bUyevntWxaQ6PzOlC11gsSpfIH4Xr2Zms/9IPpFstKaM1iNO+mipb0P571iycW1ioLVziBSlkyBv5HpDSq71XlOfAde2kSsuwbcUj61fnMvE8bDAaX9/C05zVyXQQ9y+ElEV/GeY1rU/vUlC5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076918; c=relaxed/simple;
	bh=mXFSqjPEodqzM0jXuD2pB/naV0qvEvHN77wgtW8DzXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPnqkvPej6Dp6r7XefXeg9qo1I/Q/M872NlOpdDUg/LGzPME0jab0blDnYam01eiQ+COxR5NxT9UcTQHuJFWx9ZycN3J2sunE+y7GYdjaJt0AKrNM81GflyCzStx0tMJPSe0IhVP/aSIJTUkc+J4op/eQRzLJUgYjcJeV6BUWrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZepum1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZepum1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581FFC4CEF1;
	Tue, 21 Oct 2025 20:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076916;
	bh=mXFSqjPEodqzM0jXuD2pB/naV0qvEvHN77wgtW8DzXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZepum1wXlsiM6PlPTsO3ZmZlVLIQjNE/HjxJS3Y9HOPhMKEFYfJ0uABL0ViG/sWN
	 BXv7gOmJ1jSfKnDNUsmAe/kZcdXkzlPsAxklWokm/kU/WaXwXmpQygwXDuIVinxAPl
	 jlbQwtdBrut8O5T7OQ40gDovhVQllSs47RLsze9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/136] drm/amdgpu: add support for cyan skillfish without IP discovery
Date: Tue, 21 Oct 2025 21:51:05 +0200
Message-ID: <20251021195037.822857944@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 9e6a5cf1a23bf575e93544ae05585659063b1c18 ]

For platforms without an IP discovery table.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 357d90be2c7a ("drm/amdgpu: fix handling of harvesting for ip_discovery firmware")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index 6042956cd5c3c..0f427314b2b48 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -2644,6 +2644,36 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		adev->ip_versions[UVD_HWIP][1] = IP_VERSION(2, 6, 0);
 		adev->ip_versions[XGMI_HWIP][0] = IP_VERSION(6, 1, 0);
 		break;
+	case CHIP_CYAN_SKILLFISH:
+		if (adev->apu_flags & AMD_APU_IS_CYAN_SKILLFISH2) {
+			r = amdgpu_discovery_reg_base_init(adev);
+			if (r)
+				return -EINVAL;
+
+			amdgpu_discovery_harvest_ip(adev);
+			amdgpu_discovery_get_gfx_info(adev);
+			amdgpu_discovery_get_mall_info(adev);
+			amdgpu_discovery_get_vcn_info(adev);
+		} else {
+			cyan_skillfish_reg_base_init(adev);
+			adev->sdma.num_instances = 2;
+			adev->ip_versions[MMHUB_HWIP][0] = IP_VERSION(2, 0, 3);
+			adev->ip_versions[ATHUB_HWIP][0] = IP_VERSION(2, 0, 3);
+			adev->ip_versions[OSSSYS_HWIP][0] = IP_VERSION(5, 0, 1);
+			adev->ip_versions[HDP_HWIP][0] = IP_VERSION(5, 0, 1);
+			adev->ip_versions[SDMA0_HWIP][0] = IP_VERSION(5, 0, 1);
+			adev->ip_versions[SDMA1_HWIP][1] = IP_VERSION(5, 0, 1);
+			adev->ip_versions[DF_HWIP][0] = IP_VERSION(3, 5, 0);
+			adev->ip_versions[NBIO_HWIP][0] = IP_VERSION(2, 1, 1);
+			adev->ip_versions[UMC_HWIP][0] = IP_VERSION(8, 1, 1);
+			adev->ip_versions[MP0_HWIP][0] = IP_VERSION(11, 0, 8);
+			adev->ip_versions[MP1_HWIP][0] = IP_VERSION(11, 0, 8);
+			adev->ip_versions[THM_HWIP][0] = IP_VERSION(11, 0, 1);
+			adev->ip_versions[SMUIO_HWIP][0] = IP_VERSION(11, 0, 8);
+			adev->ip_versions[GC_HWIP][0] = IP_VERSION(10, 1, 3);
+			adev->ip_versions[UVD_HWIP][0] = IP_VERSION(2, 0, 3);
+		}
+		break;
 	default:
 		r = amdgpu_discovery_reg_base_init(adev);
 		if (r) {
-- 
2.51.0



