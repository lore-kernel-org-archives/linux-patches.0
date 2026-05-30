Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58E339A7FE;
	Sat, 30 May 2026 18:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166321; cv=none; b=SesnZ+jsykbg2js3GrZtItNeZ3acs4WLtiFb/Qvs3Je50quHX5BR+RMhHgMaaFq4lMqpS/T+1fqPrH6nab9JYP4S+5nkU9r+Tzh3CAyn9KUz1OMV8saq0hYfRaYeiWEpyBc7VXdzVCFGniAtgZ0bplc7otczAVkpFk19sPLE8Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166321; c=relaxed/simple;
	bh=qpW4k2k9eHHwxPS1YG3rC9F2gpnMbu7JpQYM4uref/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pfSqzWk/0sLbhKJlFWiVKlr+TPkT4YFqAQJNUveMGfM1SrBAwSead8R8S+1JnkkVByPxkd383Sb/BG7EiZMy1wcTIL4NLvWbQfoGhdDwaJQIOUV/BcMdhaLWFDy5uQAXUY5m9S47+0ytF6jAzRq2u70ExXjSScmFKhrLgYCGFIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTIkn3/L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTIkn3/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2CE1F00893;
	Sat, 30 May 2026 18:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166320;
	bh=PTpxhNFGQWkUReamohgID5QCsy556nNme8mWMuITkc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OTIkn3/LM/fwGi3AM5d1+51LcaH9htunr6WXIz62bmeaSrAfGVnKbI79pFtL78Sdq
	 kdNx4xd4U+WQTB3U1P0OI9319obWy2j6PWT4EtWA5Gibegv73T3HI8J/o9z8uVgeYn
	 V4b4Hjv3PW8yvNrb+/rHxRMItQS0Pp0cpARdeBd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 338/589] drm/amd/pm/ci: Disable MCLK DPM on problematic CI ASICs
Date: Sat, 30 May 2026 18:03:39 +0200
Message-ID: <20260530160233.782146291@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 9851f29cb06c09f7dad3867d8b0feec3fc71b6c8 ]

There are two known cases where MCLK DPM can causes issues:

Radeon R9 M380 found in iMac computers from 2015.
The SMU in this GPU just hangs as soon as we send it the
PPSMC_MSG_MCLKDPM_Enable command, even when MCLK switching is
disabled, and even when we only populate one MCLK DPM level.
Apply workaround to all devices with the same subsystem ID.

Radeon R7 260X due to old memory controller microcode.
We only flash the MC ucode when it isn't set up by the VBIOS,
therefore there is no way to make sure that it has the correct
ucode version.

I verified that this patch fixes the SMU hang on the R9 M380
which would previously fail to boot. This also fixes the UVD
initialization error on that GPU which happened because the
SMU couldn't ungate the UVD after it hung.

Fixes: 86457c3b21cb ("drm/amd/powerplay: Add support for CI asics to hwmgr")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c
index f48fdc7f0382e..974a17a953249 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c
@@ -108,6 +108,21 @@ int hwmgr_early_init(struct pp_hwmgr *hwmgr)
 					 PP_GFXOFF_MASK);
 		hwmgr->pp_table_version = PP_TABLE_V0;
 		hwmgr->od_enabled = false;
+		switch (hwmgr->chip_id) {
+		case CHIP_BONAIRE:
+			/* R9 M380 in iMac 2015: SMU hangs when enabling MCLK DPM
+			 * R7 260X cards with old MC ucode: MCLK DPM is unstable
+			 */
+			if (adev->pdev->subsystem_vendor == 0x106B ||
+			    adev->pdev->device == 0x6658) {
+				dev_info(adev->dev, "disabling MCLK DPM on quirky ASIC");
+				adev->pm.pp_feature &= ~PP_MCLK_DPM_MASK;
+				hwmgr->feature_mask &= ~PP_MCLK_DPM_MASK;
+			}
+			break;
+		default:
+			break;
+		}
 		smu7_init_function_pointers(hwmgr);
 		break;
 	case AMDGPU_FAMILY_CZ:
-- 
2.53.0



