Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BA3374EA;
	Mon, 10 Mar 2025 18:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630778; cv=none; b=EKcSSCvF7nBAZ0fNZHcY9pYxRlPVSL0d+TFOUCQvZqG3w2DJWKBP4eAGoZc7qAOtITKXfqGGQDH0PI40UvF2sWjVc8dE+VFXRfyLXcab8CTq+qf2eSNLlB7aj7i7EyCfzHI6urfpwxVr6E6sHO8nMCJl8lAYCrnOI17LTJEdrPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630778; c=relaxed/simple;
	bh=r/9C5OIh0izGZx4pIkFhikkJgCpMP6qQeqAaeY8GrI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1nkV5Tbb+/QfTMzWFL9KaTttjqeB1nqEUDr9ap7cjDqzXokkcPKto+DhM8XINiu+XpBAYK1/1waci/2f0KbQEuv1uyWO1i4PkA2BmCHNTx2bUfYynDx0mAHP5B7/aBs0ws0rD4KtNWz+UFQe26hzEWXlOpz2zutMUMMTILvXFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AeF7/Wb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AeF7/Wb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11E2C4CEE5;
	Mon, 10 Mar 2025 18:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630778;
	bh=r/9C5OIh0izGZx4pIkFhikkJgCpMP6qQeqAaeY8GrI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AeF7/Wb9RJF+qkkbWpZH537FlQJeLSdxY/hBp0yaLsaOHghwCyK2y1E8W2ivII8/R
	 C78/VMQalyzFdEvx8Z5i3mHzb880b3EcsznSlbazrnME2EV2o/kXW5HERa1UI4CdGP
	 bGIOomMx1qUJiymoTgK6FxvTKeJcyP79KJkDHeMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 532/620] drm/amdgpu: disable BAR resize on Dell G5 SE
Date: Mon, 10 Mar 2025 18:06:18 +0100
Message-ID: <20250310170606.543754295@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 099bffc7cadff40bfab1517c3461c53a7a38a0d7 ]

There was a quirk added to add a workaround for a Sapphire
RX 5600 XT Pulse that didn't allow BAR resizing.  However,
the quirk caused a regression with runtime pm on Dell laptops
using those chips, rather than narrowing the scope of the
resizing quirk, add a quirk to prevent amdgpu from resizing
the BAR on those Dell platforms unless runtime pm is disabled.

v2: update commit message, add runpm check

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/1707
Fixes: 907830b0fc9e ("PCI: Add a REBAR size quirk for Sapphire RX 5600 XT Pulse")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5235053f443cef4210606e5fb71f99b915a9723d)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 387538f0ca54b..b11a98bee4f08 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1202,6 +1202,13 @@ int amdgpu_device_resize_fb_bar(struct amdgpu_device *adev)
 	if (amdgpu_sriov_vf(adev))
 		return 0;
 
+	/* resizing on Dell G5 SE platforms causes problems with runtime pm */
+	if ((amdgpu_runtime_pm != 0) &&
+	    adev->pdev->vendor == PCI_VENDOR_ID_ATI &&
+	    adev->pdev->device == 0x731f &&
+	    adev->pdev->subsystem_vendor == PCI_VENDOR_ID_DELL)
+		return 0;
+
 	/* PCI_EXT_CAP_ID_VNDR extended capability is located at 0x100 */
 	if (!pci_find_ext_capability(adev->pdev, PCI_EXT_CAP_ID_VNDR))
 		DRM_WARN("System can't access extended configuration space,please check!!\n");
-- 
2.39.5



