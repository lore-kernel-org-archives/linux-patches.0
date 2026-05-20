Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0083F331220;
	Wed, 20 May 2026 18:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300442; cv=none; b=WrRi8Fomxe0lRiqeA42KRT0paPSKwBipBsLw0pyh9LKLCt4wd8nVRAs5yN/sc+QmLyFjyLChWAZ4HJbkzrV61MAMP59A2X59y1jOEPQ9fvcb4b54H1QW53V9ZcY2s0qTw5Wn1Ldv+UdVCSngNnhh3SYEHcAFS7MJ4ELpmtM/saY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300442; c=relaxed/simple;
	bh=Q20OPbUWU4EEgo3XlEqGETuyZN1J2u1Tnd7N8gs6IuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hf1/2J5vxjAVHsdr+tFHWAxMjX1nPGMp21Kon+BIEPMlx3tZ3XQg1ps1CdmCGJgxmALujkhu7fgy8j6mJu4o5i3tR01H7yUidux1dqKpvgs1kYSlosHJozZnUDktEtevCwaJABRSyi/eUHxCI63QSHuFi2Y0c0dZaC6iIHcKSIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EofmpcR6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EofmpcR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664201F000E9;
	Wed, 20 May 2026 18:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300440;
	bh=p6ylkuoD/AP6bK3O6+Um7Agw6fVF2B9hGQnzHRErBz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EofmpcR64DkPscc4lHhkCkc1LA4NbBhHqHn3KSc/zn03gH4kiz8/L+UR3FOBeDBNv
	 js79Pz+bX8DviIXXzeonduro78j53JIRWO7VvVE8IjjNRJUWb20QWBaEVfRwp9gITV
	 bkSfYBB+IR/6A36WGmSL0Xq1TKD8gKc8FCx2GdxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/666] drm/amd/pm/ci: Disable MCLK DPM on problematic CI ASICs
Date: Wed, 20 May 2026 18:16:28 +0200
Message-ID: <20260520162115.037155172@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2b5ac21fee399..1d6e30269d567 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c
@@ -104,6 +104,21 @@ int hwmgr_early_init(struct pp_hwmgr *hwmgr)
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



